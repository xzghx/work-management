import 'package:equatable/equatable.dart';

class FileContent extends Equatable {
  final int? id;
  final String date;
  final String time;
  final String codeMelli;
  final String type;

  const FileContent({
      this.id,
    required this.date,
    required this.time,
    required this.codeMelli,
    required this.type,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        time,
        codeMelli,
        type,
      ];

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'time': time,
        'codeMelli': codeMelli,
        'type': type
      };
}
