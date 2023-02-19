import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [Centers.empty] represents an unauthenticated user.
/// {@endtemplate}
///
class Centers extends Equatable {
  final int id;
  final String name;

  @override
  List<Object> get props => [
        id,
        name,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  Centers.fromJson(Map<String, dynamic> map)
      : id = map['id'] ?? -1,
        name = map['name'] ?? '-';

  const Centers({
    required this.id,
    required this.name,
  });

  // Empty user which represents an unauthenticated user.
  static const empty = Centers(
    id: 0,
    name: '_',
  );

  Centers copyWith({
    int? id,
    String? name,
  }) {
    return Centers(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
