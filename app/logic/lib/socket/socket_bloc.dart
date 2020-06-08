part of logic;

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  IOWebSocketChannel channel;

  @override
  SocketState get initialState => OfflineState();

  @override
  Stream<SocketState> mapEventToState(
    SocketEvent event,
  ) async* {
    if(event is ConnectToTheGameEvent) {
      yield* _mapConnectToTheGame();
    }
  }

  Stream<SocketState> _mapConnectToTheGame() async* {
    if(channel == null) {
      channel = IOWebSocketChannel.connect('localhost')
      yield OnlineState();
    }
  }
}
