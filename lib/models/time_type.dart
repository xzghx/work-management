import 'package:equatable/equatable.dart';

class TimeType extends Equatable {
  final int id;
  final String name;

  const TimeType({required this.id, required this.name});

  TimeType.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  static const empty = TimeType(id: 0, name: '');

  @override
  List<Object?> get props => [id, name];
}
