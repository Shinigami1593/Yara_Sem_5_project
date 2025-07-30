import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:yatra_app/app/service_locator/service_locator.dart';
import 'package:yatra_app/app/themes/dashboard_theme.dart';
import 'package:yatra_app/feature/home/domain/entity/route_entity.dart';
import 'package:yatra_app/feature/home/presentation/view_model/route/route_event.dart';
import 'package:yatra_app/feature/home/presentation/view_model/route/route_state.dart';
import 'package:yatra_app/feature/home/presentation/view_model/route/route_viewmodel.dart';

class RoutesView extends StatefulWidget {
  const RoutesView({super.key});

  @override
  State<RoutesView> createState() => _RoutesViewState();
}

class _RoutesViewState extends State<RoutesView> with TickerProviderStateMixin {
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  
  List<double>? _sourceCoords;
  List<double>? _destinationCoords;
  List<LatLng> _polylinePoints = [];
  List<Marker> _mapMarkers = [];
  
  final MapController _mapController = MapController();
  late AnimationController _searchBarAnimationController;
  late Animation<double> _searchBarAnimation;
  
  bool _isSearchExpanded = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _searchBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _searchBarAnimation = CurvedAnimation(
      parent: _searchBarAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _sourceController.dispose();
    _destinationController.dispose();
    _searchBarAnimationController.dispose();
    super.dispose();
  }

  void _updateMap(RouteEntity route) {
    if (route.points.isEmpty) return;

    _polylinePoints = route.points
        .map((coord) => LatLng(coord.latitude, coord.longitude))
        .toList();

    _mapMarkers = [
      Marker(
        point: _polylinePoints.first,
        width: 40,
        height: 40,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.my_location,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
      Marker(
        point: _polylinePoints.last,
        width: 40,
        height: 40,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.location_on,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    ];

    // Animate to show the route
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds.fromPoints(_polylinePoints),
        padding: const EdgeInsets.all(50),
      ),
    );

    setState(() {});
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    
    try {
      final position = await serviceLocator<RouteViewModel>().determinePosition();
      setState(() {
        _sourceController.text = "Your Location";
        _sourceCoords = [position.longitude, position.latitude];
        _isLoading = false;
      });
      
      _showSnackBar("Location updated successfully", Colors.green);
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar("Failed to get location", Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _searchRoute() {
    if (_sourceController.text.trim().isEmpty || 
        _destinationController.text.trim().isEmpty) {
      _showSnackBar("Please enter both source and destination", Colors.orange);
      return;
    }

    _sourceCoords ??= [85.3240, 27.7172]; // Default: Ratnapark
    _destinationCoords ??= [85.3470, 27.6789]; // Default: Koteshwor

    context.read<RouteViewModel>().add(
      FetchRoutesWithInputEvent(
        sourceName: _sourceController.text.trim(),
        destinationName: _destinationController.text.trim(),
        sourceCoords: _sourceCoords!,
        destinationCoords: _destinationCoords!,
      ),
    );

    // Collapse search bar after search
    _toggleSearchBar();
  }

  void _toggleSearchBar() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
    });
    
    if (_isSearchExpanded) {
      _searchBarAnimationController.forward();
    } else {
      _searchBarAnimationController.reverse();
    }
  }

  void _swapLocations() {
    final tempText = _sourceController.text;
    final tempCoords = _sourceCoords;
    
    setState(() {
      _sourceController.text = _destinationController.text;
      _destinationController.text = tempText;
      _sourceCoords = _destinationCoords;
      _destinationCoords = tempCoords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<RouteViewModel>(),
      child: Scaffold(
        body: Stack(
          children: [
            // Full Screen Map
            _buildMap(),
            
            // Top Search Overlay
            _buildSearchOverlay(),
            
            // Floating Action Buttons
            _buildFloatingButtons(),
            
            // Loading Overlay
            if (_isLoading) _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return BlocConsumer<RouteViewModel, RouteState>(
      listener: (context, state) {
        if (state is RouteLoaded && state.routes.isNotEmpty) {
          _updateMap(state.routes.first);
        } else if (state is RouteError) {
          _showSnackBar(state.message, Colors.red);
        }
      },
      builder: (context, state) {
        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _polylinePoints.isNotEmpty
                ? _polylinePoints.first
                : const LatLng(27.7172, 85.3240), // Kathmandu
            initialZoom: 13,
            minZoom: 10,
            maxZoom: 18,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.yatra_app',
            ),
            
            // Route Polyline
            if (_polylinePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _polylinePoints,
                    color: const Color(0xFF1A73E8),
                    strokeWidth: 6.0,
                    borderColor: Colors.white,
                    borderStrokeWidth: 2.0,
                  ),
                ],
              ),
            
            // Markers
            if (_mapMarkers.isNotEmpty) 
              MarkerLayer(markers: _mapMarkers),
          ],
        );
      },
    );
  }

  Widget _buildSearchOverlay() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: AnimatedBuilder(
        animation: _searchBarAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Collapsed Search Bar
                if (!_isSearchExpanded) _buildCollapsedSearchBar(),
                
                // Expanded Search Form
                if (_isSearchExpanded) _buildExpandedSearchForm(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCollapsedSearchBar() {
    return InkWell(
      onTap: _toggleSearchBar,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Colors.grey[600],
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _sourceController.text.isEmpty && _destinationController.text.isEmpty
                    ? "Search for places"
                    : "${_sourceController.text} → ${_destinationController.text}",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedSearchForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header with close button
          Row(
            children: [
              IconButton(
                onPressed: _toggleSearchBar,
                icon: const Icon(Icons.arrow_back),
                color: Colors.grey[700],
              ),
              const Expanded(
                child: Text(
                  "Plan your route",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Source and Destination Fields
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 40,
                    color: Colors.grey[400],
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  children: [
                    _buildSearchTextField(
                      controller: _sourceController,
                      hint: "Choose starting point",
                      suffixIcon: IconButton(
                        icon: _isLoading 
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.my_location, color: DashboardTheme.backgroundColor),
                        onPressed: _isLoading ? null : _getCurrentLocation,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _buildSearchTextField(
                      controller: _destinationController,
                      hint: "Choose destination",
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Swap button
              IconButton(
                onPressed: _swapLocations,
                icon: const Icon(Icons.swap_vert),
                color: Colors.grey[600],
                tooltip: "Swap locations",
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Search Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _searchRoute,
              style: ElevatedButton.styleFrom(
                backgroundColor: DashboardTheme.backgroundColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 2,
              ),
              icon: const Icon(Icons.directions),
              label: const Text(
                "Get Directions",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTextField({
    required TextEditingController controller,
    required String hint,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[500]),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1A73E8), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Positioned(
      right: 16,
      bottom: 100,
      child: Column(
        children: [
          // My Location Button
          FloatingActionButton(
            heroTag: "location",
            onPressed: () async {
              try {
                final position = await serviceLocator<RouteViewModel>().determinePosition();
                _mapController.move(
                  LatLng(position.latitude, position.longitude),
                  16,
                );
              } catch (e) {
                _showSnackBar("Failed to get location", Colors.red);
              }
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey[700],
            mini: true,
            child: const Icon(Icons.my_location),
          ),
          
          const SizedBox(height: 12),
          
          // Zoom In Button
          FloatingActionButton(
            heroTag: "zoom_in",
            onPressed: () {
              final zoom = _mapController.camera.zoom;
              _mapController.move(_mapController.camera.center, zoom + 1);
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey[700],
            mini: true,
            child: const Icon(Icons.add),
          ),
          
          const SizedBox(height: 8),
          
          // Zoom Out Button
          FloatingActionButton(
            heroTag: "zoom_out",
            onPressed: () {
              final zoom = _mapController.camera.zoom;
              _mapController.move(_mapController.camera.center, zoom - 1);
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey[700],
            mini: true,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Getting your location..."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}