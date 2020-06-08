part of logic;

abstract class AnyChangeableButtonState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialAnyChangeableButtonState extends AnyChangeableButtonState {}

class ProgressAnyChangeableButtonState extends AnyChangeableButtonState {}

class SuccessAnyChangeableButtonState extends AnyChangeableButtonState {}

class ErrorAnyChangeableButtonState extends AnyChangeableButtonState {
  final Error error;

  ErrorAnyChangeableButtonState(this.error);
}