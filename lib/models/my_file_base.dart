import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

import 'file_content.dart';

abstract class MyFileBase extends Equatable {
  abstract final Uint8List fileBytes;

  //todo change return type to FileContent and String error message to log it
  Future<StringAndBool> read();

  String getAsDilimateRecords(List<FileContent> records) {
    return _getAsDilimateRecords(records);
  }
}

class StringAndBool extends Equatable {
  final String error;
  final String data;

  const StringAndBool({required this.error, required this.data});

  @override
  List<Object?> get props => [error, data];
}

///.dat file which has TSV(Tab Separated) format
class MyTSV implements MyFileBase {
  MyTSV({
    required this.fileBytes,
  });

  @override
  final Uint8List fileBytes;

  @override
  Future<StringAndBool> read() async {
    debugPrint("Read() TSV file called. Content:------------------------ ");
    try {
      //io is not supported in web
      debugPrint("Read() fromCharCodes started ");
      String content = String.fromCharCodes(fileBytes);
      debugPrint("Read() fromCharCodes finished ");
      // debugPrint(content.substring(0 ,3));
      debugPrint('end  content ------------------------------');
      return StringAndBool(error: '', data: content);
    } catch (e) {
      debugPrint("read TSV catch error.  ${e.toString()}");
      return StringAndBool(error: e.toString(), data: '');
    }
  }

  @override
  List<Object?> get props => [fileBytes];

  @override
  bool? get stringify => throw UnimplementedError();

  @override
  String getAsDilimateRecords(List<FileContent> records) {
    return _getAsDilimateRecords(records);
  }
}

class MyExcel implements MyFileBase {
  MyExcel({
    required this.fileBytes,
  });

  @override
  final Uint8List fileBytes;

  @override
  Future<StringAndBool> read() async {
    String content = '';
    debugPrint("Read() Excel file called. Content:------------------------ ");
    try  {
      //io is not supported in web

      debugPrint("Read() decodeBytes started");
      Excel excel = Excel.decodeBytes(fileBytes);
      debugPrint("Read() decodeBytes finished");
      // print(table); //sheet Name
      // print(excel.tables[table].maxCols);
      // print(excel.tables[table].maxRows);
      String table = excel.tables.keys.first;
      if (excel.tables[table] != null) {
        for (List<Data?> row in excel.tables[table]!.rows) {
          String codeMelli =
              row[0] != null ? row[0]!.value.toString() : 'NULL'; //id
          String date =
              row[1] != null ? row[1]!.value.toString() : 'NULL'; //date
          String time =
              row[2] != null ? row[2]!.value.toString() : 'NULL'; //time
          // String type =
          //     row[3] != null ? row[3]!.value.toString() : 'NULL'; //type

          content += '$codeMelli\t$date\t$time\r\n';
        }
      }

      // debugPrint(content.substring(0,30));
      debugPrint('end  content ------------------------------');
      return StringAndBool(error: '', data: content);
    } catch (e) {
      debugPrint("read Excel catch error.  ${e.toString()}");
      return StringAndBool(error: e.toString(), data: '');
    }
  }

  @override
  List<Object?> get props => [fileBytes];

  @override
  bool? get stringify => throw UnimplementedError();

  @override
  String getAsDilimateRecords(List<FileContent> records) {
    return _getAsDilimateRecords(records);
  }
}

class MyEmptyFile implements MyFileBase {
  const MyEmptyFile({
    required this.fileBytes,
  });

  @override
  final Uint8List fileBytes;

  @override
  Future<StringAndBool> read() async {
    debugPrint("Read MyEmptyFile!!");
    return const StringAndBool(error: '', data: '');
  }

  @override
  List<Object?> get props => [fileBytes];

  @override
  bool? get stringify => throw UnimplementedError();

  @override
  String getAsDilimateRecords(List<FileContent> records) {
    return '';
  }
}

///fields are separated by comma ,
/// and rows are separated by tilde ~
/// codeMelli,data,time~codeMelli,data,time~...
String _getAsDilimateRecords(List<FileContent> records) {
  String delimated = '';
  //~ is new line
  //, data seperation
  for (FileContent r in records) {
    delimated += '${r.codeMelli},${r.date},${r.time}~';
  }
  return delimated;
}
