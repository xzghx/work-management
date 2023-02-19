import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [MonthShift.empty] represents an unauthenticated user.
/// {@endtemplate}
///
class MonthShift extends Equatable {
  final int id;
  final String name;
  final String lastName;
  final String codePersonely;
  final String f1;
  final String f2;
  final String f3;
  final String f4;
  final String f5;
  final String f6;
  final String f7;
  final String f8;
  final String f9;
  final String f10;
  final String f11;
  final String f12;
  final String f13;
  final String f14;
  final String f15;
  final String f16;
  final String f17;
  final String f18;
  final String f19;
  final String f20;
  final String f21;
  final String f22;
  final String f23;
  final String f24;
  final String f25;
  final String f26;
  final String f27;
  final String f28;
  final String f29;
  final String f30;
  final String f31;

  @override
  List<Object> get props => [
        id,
        name,
        lastName,
        codePersonely,
        f1,
        f2,
        f3,
        f4,
        f5,
        f6,
        f7,
        f8,
        f9,
        f10,
        f11,
        f12,
        f13,
        f14,
        f15,
        f16,
        f17,
        f18,
        f19,
        f20,
        f21,
        f22,
        f23,
        f24,
        f25,
        f26,
        f27,
        f28,
        f29,
        f30,
        f31,
      ];

  Map<String, dynamic> toJson() {

    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'codePersonely': codePersonely,
      'f1_f31':
          "f1='$f1',f2='$f2',f3='$f3',f4='$f4',f5='$f5',f6='$f6',f7='$f7',f8='$f8',f9='$f9',f10='$f10',f11='$f11',f12='$f12',f13='$f13',f14='$f14',f15='$f15',f16='$f16',f17='$f17',f18='$f18',f19='$f19',f20='$f20',f21='$f21',f22='$f22',f23='$f23',f24='$f24',f25='$f25',f26='$f26',f27='$f27',f28='$f28',f29='$f29',f30='$f30',f31='$f31'",
    };
  }

  MonthShift.fromJson(Map<String, dynamic> map)
      : id = map['id'] ?? -1,
        name = map['name'] ?? '-',
        lastName = map['lastName'] ?? '',
        codePersonely = map['codePersonely'] ?? '',
        f1 = map['f1'] ?? '',
        f2 = map['f2'] ?? '',
        f3 = map['f3'] ?? '',
        f4 = map['f4'] ?? '',
        f5 = map['f5'] ?? '',
        f6 = map['f6'] ?? '',
        f7 = map['f7'] ?? '',
        f8 = map['f8'] ?? '',
        f9 = map['f9'] ?? '',
        f10 = map['f10'] ?? '',
        f11 = map['f11'] ?? '',
        f12 = map['f12'] ?? '',
        f13 = map['f13'] ?? '',
        f14 = map['f14'] ?? '',
        f15 = map['f15'] ?? '',
        f16 = map['f16'] ?? '',
        f17 = map['f17'] ?? '',
        f18 = map['f18'] ?? '',
        f19 = map['f19'] ?? '',
        f20 = map['f20'] ?? '',
        f21 = map['f21'] ?? '',
        f22 = map['f22'] ?? '',
        f23 = map['f23'] ?? '',
        f24 = map['f24'] ?? '',
        f25 = map['f25'] ?? '',
        f26 = map['f26'] ?? '',
        f27 = map['f27'] ?? '',
        f28 = map['f28'] ?? '',
        f29 = map['f29'] ?? '',
        f30 = map['f30'] ?? '',
        f31 = map['f31'] ?? '';

  const MonthShift({
    required this.id,
    required this.name,
    required this.lastName,
    required this.codePersonely,
    required this.f1,
    required this.f2,
    required this.f3,
    required this.f4,
    required this.f5,
    required this.f6,
    required this.f7,
    required this.f8,
    required this.f9,
    required this.f10,
    required this.f11,
    required this.f12,
    required this.f13,
    required this.f14,
    required this.f15,
    required this.f16,
    required this.f17,
    required this.f18,
    required this.f19,
    required this.f20,
    required this.f21,
    required this.f22,
    required this.f23,
    required this.f24,
    required this.f25,
    required this.f26,
    required this.f27,
    required this.f28,
    required this.f29,
    required this.f30,
    required this.f31,
  });

  // Empty user which represents an unauthenticated user.
  static const empty = MonthShift(
    id: 0,
    name: '_',
    lastName: '',
    codePersonely: '',
    f1: '',
    f2: '',
    f3: '',
    f4: '',
    f5: '',
    f6: '',
    f7: '',
    f8: '',
    f9: '',
    f10: '',
    f11: '',
    f12: '',
    f13: '',
    f14: '',
    f15: '',
    f16: '',
    f17: '',
    f18: '',
    f19: '',
    f20: '',
    f21: '',
    f22: '',
    f23: '',
    f24: '',
    f25: '',
    f26: '',
    f27: '',
    f28: '',
    f29: '',
    f30: '',
    f31: '',
  );

  MonthShift copyWith({
    int? id,
    String? name,
    String? lastName,
    String? codePersonely,
    String? f1,
    String? f2,
    String? f3,
    String? f4,
    String? f5,
    String? f6,
    String? f7,
    String? f8,
    String? f9,
    String? f10,
    String? f11,
    String? f12,
    String? f13,
    String? f14,
    String? f15,
    String? f16,
    String? f17,
    String? f18,
    String? f19,
    String? f20,
    String? f21,
    String? f22,
    String? f23,
    String? f24,
    String? f25,
    String? f26,
    String? f27,
    String? f28,
    String? f29,
    String? f30,
    String? f31,
  }) {
    return MonthShift(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      codePersonely: codePersonely ?? this.codePersonely,
      f1: f1 ?? this.f1,
      f2: f2 ?? this.f2,
      f3: f3 ?? this.f3,
      f4: f4 ?? this.f4,
      f5: f5 ?? this.f5,
      f6: f6 ?? this.f6,
      f7: f7 ?? this.f7,
      f8: f8 ?? this.f8,
      f9: f9 ?? this.f9,
      f10: f10 ?? this.f10,
      f11: f11 ?? this.f11,
      f12: f12 ?? this.f12,
      f13: f13 ?? this.f13,
      f14: f14 ?? this.f14,
      f15: f15 ?? this.f15,
      f16: f16 ?? this.f16,
      f17: f17 ?? this.f17,
      f18: f18 ?? this.f18,
      f19: f19 ?? this.f19,
      f20: f20 ?? this.f20,
      f21: f21 ?? this.f21,
      f22: f22 ?? this.f22,
      f23: f23 ?? this.f23,
      f24: f24 ?? this.f24,
      f25: f25 ?? this.f25,
      f26: f26 ?? this.f26,
      f27: f27 ?? this.f27,
      f28: f28 ?? this.f28,
      f29: f29 ?? this.f29,
      f30: f30 ?? this.f30,
      f31: f31 ?? this.f31,
    );
  }
}
