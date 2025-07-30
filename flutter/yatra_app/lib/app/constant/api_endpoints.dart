class ApiEndpoints {
  ApiEndpoints._();

  //TimeOUts
  static const connectionTimeout = Duration(seconds: 1000);
  static const recieveTimeout = Duration(seconds: 1000);


  static const String serviceAddress = 'http://192.168.1.77:5050';

  static const String baseUrl = "$serviceAddress/api/v1/";
  
  //Auth
  static const String login = "auth/users/login";
  static const String register = "auth/users/signup";
  static const String getProfile = "auth/users/profile";
  static const String routes = "auth/users/routes";
} 