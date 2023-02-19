import 'package:equatable/equatable.dart';

enum FType {
  excel,
  dat,
  datQuted,
  empty, //choosing empty means not selected any type
}

///this is a constant information.
class MyFileType extends Equatable {
  final int id;

  final FType type;
  final List<String> fileExtensions;

  const MyFileType({
    required this.id,
    required this.type,
    required this.fileExtensions,
  });

  static const empty = MyFileType(id: 0, type: FType.empty, fileExtensions: []);

  @override
  List<Object?> get props => [
        id,
        type,
        fileExtensions,
      ];
}
