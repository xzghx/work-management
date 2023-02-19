import 'package:equatable/equatable.dart';

class FileInfoSmall extends Equatable {
  final int id;
  final String month;
  final String centerName;
  final String fileType;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'month': month,
      'centerName': centerName,
      'fileType': fileType,
    };
  }

  FileInfoSmall.fromJson(Map<String, dynamic> map)
      : id = map['id'] ?? -1,
        month = map['month'] ?? '-',
        centerName = map['centerName'] ?? '-',
        fileType = map['fileType'] ?? '-';

  const FileInfoSmall({
    required this.id,
    required this.month,
    required this.centerName,
    required this.fileType,
  });

  // Empty user which represents an unauthenticated user.
  static const empty = FileInfoSmall(
    id: 0,
    month: '',
    centerName: '',
    fileType: '',
  );

  FileInfoSmall copyWith({
    int? id,
    String? month,
    String? centerName,
    String? fileType,
  }) {
    return FileInfoSmall(
      id: id ?? this.id,
      month: month ?? this.month,
      centerName: centerName ?? this.centerName,
      fileType: fileType ?? this.fileType,
    );
  }

  @override
  List<Object> get props => [id, month, centerName, fileType];
}

/// for model class for inserting in server
class FileInfo extends Equatable {
  final int id;
  final int idCenter;
  final int idMonth;
  final int idFileType;
  final int year;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idCenter': idCenter,
      'idMonth': idMonth,
      'idFileType': idFileType,
      'year': year,
    };
  }

  FileInfo.fromJson(Map<String, dynamic> map)
      : id = map['id'] ?? -1,
        idCenter = map['idCenter'] ?? 0,
        idMonth = map['idMonth'] ?? 0,
        idFileType = map['idFileType'] ?? 0,
        year = map['year'] ?? 0;

  const FileInfo({
    required this.id,
    required this.idCenter,
    required this.idMonth,
    required this.idFileType,
    required this.year,
  });

  // Empty user which represents an unauthenticated user.
  static const empty = FileInfo(
    id: 0,
    idCenter: 0,
    idMonth: 0,
    idFileType: 0,
    year: 0,
  );

  FileInfo copyWith({
    int? id,
    int? idCenter,
    int? idMonth,
    int? idFileType,
    int? year,
  }) {
    return FileInfo(
        id: id ?? this.id,
        idCenter: idCenter ?? this.idCenter,
        idMonth: idMonth ?? this.idMonth,
        idFileType: idFileType ?? this.idFileType,
        year: year ?? this.year);
  }

  @override
  List<Object> get props => [
        id,
        idCenter,
        idMonth,
        idFileType,
        year,
      ];
}
