part of logic;

abstract class AnyChangeableButtonBloc extends Bloc<AnyChangeableButtonEvent, AnyChangeableButtonState> {
  @override
  AnyChangeableButtonState get initialState => InitialAnyChangeableButtonState();

  @override
  Stream<AnyChangeableButtonState> mapEventToState(
      AnyChangeableButtonEvent event,
  ) async* {
    if (event is ChangeableButtonEvent) {
      yield* _mapAsyncAction(event);
    } else if (event is CustomChangeableEvent) {
      yield* customEventHandler(event);
    } else if (event is ResetChangeableButtonEvent) {
      yield InitialAnyChangeableButtonState();
    }
  }

  Stream<AnyChangeableButtonState> _mapAsyncAction(ChangeableButtonEvent event) async* {
    try {
      yield ProgressAnyChangeableButtonState();
      await asyncAction(event);
      yield SuccessAnyChangeableButtonState();
    } on NoSuchMethodError catch(error) {
      yield ErrorAnyChangeableButtonState(ErrorHandler.get(Exception('NoSuchMethod')));
    } catch(error) {
      yield ErrorAnyChangeableButtonState(ErrorHandler.get(error));
    }
  }

  Stream<AnyChangeableButtonState> customEventHandler(CustomChangeableEvent event) {
    throw UnimplementedError();
  }

  Future asyncAction(AnyChangeableButtonEvent event) {
    throw UnimplementedError();
  }
}
