import 'package:equatable/equatable.dart';

class Month extends Equatable {
  final int id;
  final String name;

  const Month({required this.id, required this.name});

  Month.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  static const empty = Month(id: 0, name: '');

  @override
  List<Object?> get props => [id, name];
}
