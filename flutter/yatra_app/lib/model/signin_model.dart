class SignInModel {
  bool validateCredentials(String email, String password) {
    return email == 'admin' && password == 'admin';
  }
}
