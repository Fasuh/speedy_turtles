part of logic;

abstract class AppError extends Error {
  Exception error;

  AppError(this.error);
}

class NoConnectionError extends AppError {
  NoConnectionError(Exception error) : super(error);
}

class ServerError extends AppError {
  ServerError(Exception error) : super(error);
}

class InternalServerError extends AppError {
  InternalServerError(Exception error) : super(error);
}

class IncorrectEmailOrPassword extends ServerError {
  IncorrectEmailOrPassword(Exception error) : super(error);
}

class AccountAlreadyExists extends ServerError {
  AccountAlreadyExists(Exception error) : super(error);
}

class IncorrectFormViolation extends ServerError {
  IncorrectFormViolation(Exception error) : super(error);
}

class AccountDoesntExist extends ServerError {
  AccountDoesntExist(Exception error) : super(error);
}

class RegistrationError extends ServerError {
  RegistrationError(Exception error) : super(error);
}

class DefaultError extends AppError {
  DefaultError(Exception error) : super(error);
}

class AppleSignInNotAvailableError extends Error {}