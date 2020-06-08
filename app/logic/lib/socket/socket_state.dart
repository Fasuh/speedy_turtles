part of logic;

abstract class SocketState extends Equatable {
  @override
  List<Object> get props => [];
}

class OfflineState extends SocketState {}

class OnlineState extends SocketState {}
