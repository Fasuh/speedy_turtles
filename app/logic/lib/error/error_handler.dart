part of logic;

class ErrorHandler {
  static Error get(error) {
    print(error);
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.CONNECT_TIMEOUT:
        case DioErrorType.RECEIVE_TIMEOUT:
        case DioErrorType.SEND_TIMEOUT:
        case DioErrorType.DEFAULT:
          return NoConnectionError(error);
          break;
        case DioErrorType.RESPONSE:
          if (error.response.statusCode == 400 || error.response.statusCode == 401)
            return _badRequestTypeOfError(error);
          else
            return InternalServerError(error);
          break;
        default:
          return DefaultError(error);
          break;
      }
    } else if (error is Error){
      return error;
    } else if (error is Exception) {
      return DefaultError(error);
    } else {
      return DefaultError(Exception("wth is going on"));
    }
  }

  static Error _badRequestTypeOfError(DioError error) {
    final Map<String, dynamic> response = (error.response.data as Map).cast<String, dynamic>();
    switch(response['error'] as String) {
      case "invalid_grant":
        return IncorrectEmailOrPassword(error);
      default:
        return DefaultError(error);
    }
  }
}
