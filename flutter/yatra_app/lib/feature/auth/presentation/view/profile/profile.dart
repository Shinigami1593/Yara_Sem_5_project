import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:yatra_app/app/constant/api_endpoints.dart';
import 'package:yatra_app/app/shared_pref/auth_shared_preferences.dart';
import 'package:yatra_app/app/themes/dashboard_theme.dart';
import 'package:yatra_app/core/network/biometric_service.dart';
import 'package:yatra_app/feature/auth/presentation/view/signin_view.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/profile_view_model/profile_event.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/profile_view_model/profile_state.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/profile_view_model/profile_view_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late TextEditingController nameController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  File? _selectedImage;
  bool _isBiometricEnabled = false;
  bool _isBiometricAvailable = false;
  String _biometricType = '';
  // Accelerometer shake detection variables
  double _lastX = 0.0;
  int _shakeCount = 0;
  static const double _shakeThreshold = 5.0; // Lowered for emulator
  static const int _shakeCountThreshold = 2; // Lowered for emulator
  DateTime? _lastShakeTime;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadProfile();
    _checkBiometricStatus();
    _initializeAccelerometer();
  }

  void _initializeControllers() {
    nameController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
  }

  void _loadProfile() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().add(
            GetProfileEvent(context: context),
          );
    });
  }

  Future<void> _checkBiometricStatus() async {
    final isEnabled = await SimpleStorageService.isBiometricEnabled();
    final isAvailable = await BiometricService.isAvailable();

    if (isAvailable) {
      final biometrics = await BiometricService.getAvailableBiometrics();
      final biometricTypeString = BiometricService.getBiometricTypeString(biometrics);
      setState(() {
        _isBiometricEnabled = isEnabled;
        _isBiometricAvailable = isAvailable;
        _biometricType = biometricTypeString;
      });
    } else {
      setState(() {
        _isBiometricEnabled = false;
        _isBiometricAvailable = false;
        _biometricType = '';
      });
    }
  }

  void _initializeAccelerometer() {
    try {
      accelerometerEvents.listen((AccelerometerEvent event) {
        print('Accelerometer event: x=${event.x}, y=${event.y}, z=${event.z}');
        final currentTime = DateTime.now();
        // Avoid rapid triggers by checking time since last shake
        if (_lastShakeTime != null &&
            currentTime.difference(_lastShakeTime!).inMilliseconds < 500) {
          return;
        }

        // Detect significant change in x-axis acceleration
        final deltaX = event.x - _lastX;
        if (deltaX.abs() > _shakeThreshold) {
          _shakeCount++;
          print('Shake detected: count=$_shakeCount, deltaX=$deltaX');
          if (_shakeCount >= _shakeCountThreshold) {
            print('Shake threshold reached, triggering logout');
            _shakeCount = 0; // Reset shake count
            _lastShakeTime = currentTime;
            _logout(); // Trigger logout
          }
        } else {
          // Reset shake count if movement is too small
          _shakeCount = 0;
          print('Movement too small, resetting shake count');
        }
        _lastX = event.x;
      }, onError: (error) {
        print('Accelerometer error: $error');
        _showSnackBar('Accelerometer not available on this device', Colors.red);
      });
    } catch (e) {
      print('Failed to initialize accelerometer: $e');
      _showSnackBar('Failed to initialize accelerometer', Colors.red);
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    if (!_isBiometricAvailable) {
      _showSnackBar('Biometric authentication not available on this device', Colors.red);
      return;
    }

    if (value) {
      final authenticated = await BiometricService.authenticate(
        reason: 'Authenticate to enable biometric login for YATRA',
      );

      if (authenticated) {
        await SimpleStorageService.setBiometricEnabled(true);
        setState(() {
          _isBiometricEnabled = true;
        });
        _showSnackBar('$_biometricType login enabled successfully!', Colors.green);
      } else {
        _showSnackBar('Authentication failed. Biometric login not enabled.', Colors.red);
      }
    } else {
      final bool? shouldDisable = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Icon(Icons.fingerprint_outlined, color: Colors.orange),
                SizedBox(width: 8),
                Text('Disable Biometric Login'),
              ],
            ),
            content: Text('Are you sure you want to disable $_biometricType login?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Disable'),
              ),
            ],
          );
        },
      );

      if (shouldDisable == true) {
        await SimpleStorageService.setBiometricEnabled(false);
        setState(() {
          _isBiometricEnabled = false;
        });
        _showSnackBar('$_biometricType login disabled', Colors.orange);
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  void _updateProfile() {
    if (_validateInputs()) {
      context.read<ProfileViewModel>().add(
            UpdateProfileEvent(
              context: context,
              name: nameController.text.trim(),
              firstName: firstNameController.text.trim(),
              lastName: lastNameController.text.trim(),
              profilePicture: _selectedImage,
            ),
          );
    }
  }

  bool _validateInputs() {
    if (nameController.text.trim().isEmpty) {
      _showSnackBar('Please enter your full name', Colors.red);
      return false;
    }
    if (firstNameController.text.trim().isEmpty) {
      _showSnackBar('Please enter your first name', Colors.red);
      return false;
    }
    if (lastNameController.text.trim().isEmpty) {
      _showSnackBar('Please enter your last name', Colors.red);
      return false;
    }
    return true;
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text('Logout'),
            ],
          ),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<ProfileViewModel>().add(
                      LogoutEvent(context: context),
                    );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileViewModel, ProfileState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            backgroundColor: DashboardTheme.backgroundColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: DashboardTheme.primaryColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading profile...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state.isLoggedOut) {
          print('ProfileView: isLoggedOut detected, navigating to SignInView');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => SignInView()),
              (route) => false,
            );
          });
        }

        final user = state.user;
        if (user != null) {
          nameController.text = user.name;
          firstNameController.text = user.firstName;
          lastNameController.text = user.lastName;
        }

        return Scaffold(
          backgroundColor: DashboardTheme.backgroundColor,
          appBar: AppBar(
            title: Text('Profile'),
            backgroundColor: const Color.fromARGB(255, 10, 80, 45),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: _logout,
                icon: Icon(Icons.logout),
                tooltip: 'Logout',
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: DashboardTheme.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(user),
                  SizedBox(height: 24),
                  _buildEditSection(),
                  SizedBox(height: 24),
                  _buildSecuritySection(),
                  SizedBox(height: 24),
                  _buildActionButtons(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSecuritySection() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security, color: DashboardTheme.primaryColor),
              SizedBox(width: 8),
              Text(
                'Security Settings',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _isBiometricAvailable
                        ? DashboardTheme.primaryColor.withOpacity(0.1)
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.fingerprint,
                    color: _isBiometricAvailable
                        ? DashboardTheme.primaryColor
                        : const Color.fromARGB(255, 199, 74, 74),
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isBiometricAvailable
                            ? '$_biometricType Login'
                            : 'Biometric Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _isBiometricAvailable
                            ? _isBiometricEnabled
                                ? 'Enabled - Quick and secure login'
                                : 'Disabled - Use $_biometricType for faster login'
                            : 'Not available on this device',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isBiometricEnabled && _isBiometricAvailable,
                  onChanged: _isBiometricAvailable ? _toggleBiometric : null,
                  activeColor: DashboardTheme.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        DashboardTheme.primaryColor.withOpacity(0.1),
                        DashboardTheme.primaryColor.withOpacity(0.2),
                      ],
                    ),
                    border: Border.all(
                      color: DashboardTheme.primaryColor,
                      width: 3,
                    ),
                  ),
                  child: _selectedImage != null
                      ? ClipOval(
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildDefaultAvatar(),
                          ),
                        )
                      : user?.profilePicture != null && user.profilePicture.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                '${ApiEndpoints.serviceAddress}${user.profilePicture}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildDefaultAvatar(),
                              ),
                            )
                          : _buildDefaultAvatar(),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            user?.name ?? 'User Name',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          if (user?.email != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: DashboardTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user.email,
                style: TextStyle(
                  fontSize: 16,
                  color: DashboardTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          SizedBox(height: 20),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     _buildStatItem('Trips', '12', Icons.flight_takeoff),
          //     Container(width: 1, height: 40, color: Colors.grey[300]),
          //     _buildStatItem('Reviews', '8', Icons.star),
          //     Container(width: 1, height: 40, color: Colors.grey[300]),
          //     _buildStatItem('Points', '2.4k', Icons.emoji_events),
          //   ],
          // ),
        ],
      ),
    );
  }


  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            DashboardTheme.primaryColor.withOpacity(0.3),
            DashboardTheme.primaryColor.withOpacity(0.1),
          ],
        ),
      ),
      child: Icon(
        Icons.person,
        size: 60,
        color: DashboardTheme.primaryColor,
      ),
    );
  }

  Widget _buildEditSection() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit, color: DashboardTheme.primaryColor),
              SizedBox(width: 8),
              Text(
                'Edit Information',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          _buildTextField(
            controller: nameController,
            label: 'Full Name',
            icon: Icons.person_outline,
            hint: 'Enter your full name',
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: firstNameController,
                  label: 'First Name',
                  icon: Icons.badge_outlined,
                  hint: 'First name',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: lastNameController,
                  label: 'Last Name',
                  icon: Icons.badge_outlined,
                  hint: 'Last name',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint ?? label,
            prefixIcon: Icon(icon, color: DashboardTheme.primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: DashboardTheme.primaryColor, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                DashboardTheme.primaryColor,
                DashboardTheme.primaryColor.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: DashboardTheme.primaryColor.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: _updateProfile,
            icon: Icon(Icons.save, size: 20),
            label: Text(
              'Update Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: BorderSide(color: Colors.red, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: _logout,
            icon: Icon(Icons.logout, size: 20),
            label: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}