import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [Part.empty] represents an unauthenticated user.
/// {@endtemplate}
///
class Part extends Equatable {
  final int id;
  final String name;
  final int idCenter;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'idCenter': idCenter,
    };
  }

  Part.fromJson(Map<String, dynamic> map)
      : id = map['id'] ?? -1,
        name = map['name'] ?? '-',
        idCenter = map['idCenter'] ?? 0;

  const Part({
    required this.id,
    required this.name,
    required this.idCenter,
  });

  // Empty user which represents an unauthenticated user.
  static const empty = Part(
    id: 0,
    name: '_',
    idCenter: 0,
  );

  Part copyWith({
    int? id,
    String? name,
    int? idCenter,
  }) {
    return Part(
      id: id ?? this.id,
      name: name ?? this.name,
      idCenter: idCenter ?? this.idCenter,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        idCenter,
      ];
}
