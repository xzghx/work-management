import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [Shift.empty] represents an unauthenticated user.
/// {@endtemplate}
///
class Shift extends Equatable {
  final int id;
  final String name;

  final String startTime;
  final String endTime;
  final int
  endsToday; //آیا ساعت پایان سیفت تا  روز بعدی است؟ مانند شیفت های فول


  final String allowedStartTime; //بازه مجاز کارت زدن کاربران
  final String allowedEndTime; //بازه مجاز کارت زدن کاربران
  final int
      validEndForToday; //آیا زمان ثبت شده برای بازه مجاز خروج، زمان امروزه یا برای فرداست؟

  @override
  List<Object> get props => [
        id,
        name,
        startTime,
        endTime,
        endsToday,
        allowedStartTime,
        allowedEndTime,
        validEndForToday,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startTime': startTime,
      'endTime': endTime,
      'endsToday': endsToday ,//must be 0 or 1
      'allowedStartTime': allowedStartTime,
      'allowedEndTime': allowedEndTime,
      'validEndForToday': validEndForToday ,//must be 0 or 1
    };
  }

  Shift.fromJson(Map<String, dynamic> map)
      : id = map['id'] ?? 0,
        name = map['name'] ?? '-',
        startTime = map['startTime'] ?? '-',
        endTime = map['endTime'] ?? '-',
        endsToday = map['endsToday'] ??0 ,
        allowedStartTime = map['allowedStartTime'] ?? '-',
        allowedEndTime = map['allowedEndTime'] ?? '-',
        validEndForToday = map['validEndForToday'] ??0 ;

  const Shift({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.endsToday,
    required this.allowedStartTime,
    required this.allowedEndTime,
    required this.validEndForToday,
  });

  // Empty user which represents an unauthenticated user.
  static const empty = Shift(
    id: 0,
    name: '-',
    startTime: '-',
    endTime: '-',
    endsToday: 0,
    allowedStartTime: '-',
    allowedEndTime: '-',
    validEndForToday: 0,
  );

  Shift copyWith({
    int? id,
    String? name,
    String? startTime,
    String? endTime,
    int? endsToday,
    String? allowedStartTime,
    String? allowedEndTime,
    int? validEndForToday,
  }) {
    return Shift(
      id: id ?? this.id,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      endsToday: endsToday ?? this.endsToday,
      allowedStartTime: allowedStartTime ?? this.allowedStartTime,
      allowedEndTime: allowedEndTime ?? this.allowedEndTime,
      validEndForToday: validEndForToday ?? this.validEndForToday,
    );
  }
}
