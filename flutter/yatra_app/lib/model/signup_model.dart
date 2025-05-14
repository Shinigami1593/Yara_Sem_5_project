class SignUpModel {
  bool validateSignup(String email, String password, String confirmPassword) {
    return password == confirmPassword && email.isNotEmpty && password.length >= 4;
  }
}
