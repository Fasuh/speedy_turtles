part of logic;

class SocketBloc extends AnyChangeableButtonBloc {
  IOWebSocketChannel _channel;
  Stream _stream;
  bool _isConnected = false;

  @override
  Stream<AnyChangeableButtonState> customEventHandler(CustomChangeableEvent event) async* {
    if(event is ConnectToTheGameEvent) {
      yield* _mapConnectToTheGame(event);
    }
  }

  Stream<AnyChangeableButtonState> _mapConnectToTheGame(ConnectToTheGameEvent event) async* {
    try {
      if (!_isConnected) {
        yield ProgressAnyChangeableButtonState();
        _channel = IOWebSocketChannel.connect('ws://10.0.2.2:5000/message');
        _isConnected = true;
        _stream = _channel.stream.asBroadcastStream();
        _channel.sink.add(event.name);
        _addEventHandlers();
        yield SuccessAnyChangeableButtonState();
      }
    } catch (error) {
      yield ErrorAnyChangeableButtonState(ErrorHandler.get(error));
    }
  }

  void _addEventHandlers() {
      _stream
        .listen((data) {
          print(data);
      }, // TODO - fix that
        onDone: () {
          _isConnected = false;
          print('CLOSED ${_channel.closeCode}: ${_channel.closeReason}');
        }, onError: (error) => print('ERROR $error'));
  }
}
