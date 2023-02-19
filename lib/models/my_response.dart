import 'package:equatable/equatable.dart';

class MyResponse {
  String message;

  int status;

  Map<String, dynamic> serverResponse;

  MyResponse(this.status, this.message, this.serverResponse);
}

class MyResponse2 {
  String? error;

  Map<String, dynamic> serverResponse;

  MyResponse2(this.error, this.serverResponse);
}

class MessageAndMap extends Equatable {
  final String message;

  final List<Map<String, dynamic>> maps;

  const MessageAndMap({required this.message, required this.maps});

  // do not change key entities
  static const empty = MessageAndMap(message: '', maps: []);

  @override
  List<Object?> get props => [message, maps];
}
