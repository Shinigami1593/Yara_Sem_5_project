class ApiEndpoints {
  ApiEndpoints._();

  //TimeOUts
  static const connectionTimeout = Duration(seconds: 1000);
  static const recieveTimeout = Duration(seconds: 1000);


  static const String serviceAddress = 'http://10.0.2.2:5050';

  static const String baseUrl = "$serviceAddress/api/v1/auth/";
  
  //Auth
  static const String login = "users/login";
  static const String register = "users/signup";
}