import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [Employee.empty] represents an unauthenticated user.
/// {@endtemplate}
///
class Employee extends Equatable {
  final int id;
  final String name;
  final String lastName;
  final String codeMelli;
  final String codePersonely;
  final int idCenter;
  final int idPart;
  final String startDate;
  final String endDate;
  final String mobile;
  final String idEmployeeDarMarkaz;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'codeMelli': codeMelli,
      'codePersonely': codePersonely,
      'idCenter': idCenter,
      'idPart': idPart,
      'startDate': startDate,
      'endDate': endDate,
      'mobile': mobile,
      'idEmployeeDarMarkaz': idEmployeeDarMarkaz,
    };
  }

  Employee.fromJson(Map<String, dynamic> map)
      : id = map['id'] ?? -1,
        name = map['name'] ?? '',
        lastName = map['lastName'] ?? '',
        codeMelli = map['codeMelli'] ?? '',
        codePersonely = map['codePersonely'] ?? '',
        idCenter = map['idCenter'] ?? 0,
        idPart = map['idPart'] ?? 0,
        startDate = map['startDate'] ?? '',
        endDate = map['endDate'] ?? '',
        mobile = map['mobile'] ?? '',
        idEmployeeDarMarkaz = map['idEmployeeDarMarkaz'] ?? '';

  const Employee({
    required this.id,
    required this.name,
    required this.lastName,
    required this.codeMelli,
    required this.codePersonely,
    required this.idCenter,
    required this.idPart,
    required this.startDate,
    required this.endDate,
    required this.mobile,
    required this.idEmployeeDarMarkaz,
  });

  // Empty user which represents an unauthenticated user.
  static const empty = Employee(
    id: 0,
    name: '',
    lastName: '',
    codeMelli: '',
    codePersonely: '',
    idCenter: 0,
    idPart: 0,
    startDate: '',
    endDate: '0',
    mobile: '',
    idEmployeeDarMarkaz: '',
  );

  Employee copyWith({
    int? id,
    String? name,
    String? lastName,
    String? codeMelli,
    String? codePersonely,
    int? idCenter,
    int? idPart,
    String? startDate,
    String? endDate,
    String? mobile,
    String? idEmployeeDarMarkaz,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      codeMelli: codeMelli ?? this.codeMelli,
      codePersonely: codePersonely ?? this.codePersonely,
      idCenter: idCenter ?? this.idCenter,
      idPart: idPart ?? this.idPart,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      mobile: mobile ?? this.mobile,
      idEmployeeDarMarkaz: idEmployeeDarMarkaz ?? this.idEmployeeDarMarkaz,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        lastName,
        codeMelli,
        codePersonely,
        idCenter,
        idPart,
        startDate,
        endDate,
        mobile,
        idEmployeeDarMarkaz,
      ];
}
