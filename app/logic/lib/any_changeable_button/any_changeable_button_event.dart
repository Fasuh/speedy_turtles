part of logic;

abstract class AnyChangeableButtonEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ChangeableButtonEvent extends AnyChangeableButtonEvent {}

class CustomChangeableEvent extends AnyChangeableButtonEvent {}

class ResetChangeableButtonEvent extends AnyChangeableButtonEvent {}
