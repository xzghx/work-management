import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../helpers/links.dart';
import 'centers.dart';
import 'drop_down_base.dart';

/// {@template user}
/// User model
///
/// [AdminUser.empty] represents an unauthenticated user.
/// {@endtemplate}
///
class AdminUser extends Equatable {
  final int id;
  final String name;
  final String lastName;
  final String userName;
  final String mobile;
  final String accessIds; //*1*2*13*
  final String centersAccessIds; //*1*2*13*
  final String token;

  //-------------------
  final String? image;
  final int issuedAt;

  AdminUser.fromJson(Map<String, dynamic> map)
      : id = map['id'] ?? -1,
        name = map['name'] ?? '-',
        lastName = map['lastName'] ?? '-',
        userName = map['userName'] ?? '-',
        mobile = map['mobile'] ?? '-',
        accessIds = map['accessIds'] ?? '*',
        centersAccessIds = map['centersAccessIds'] ?? '*',
        token = map['token'] ?? '-1',
//------------
        image = map['image'] != null ? Links.baseUrlImage + map['image'] : null,
        issuedAt = map['issuedAt'] ?? -1,
        expiresIn = map['expiresIn'] ?? -1;

  final int expiresIn;

  const AdminUser({
    required this.id,
    required this.name,
    required this.lastName,
    required this.userName,
    required this.mobile,
    required this.image,
    required this.accessIds,
    required this.centersAccessIds,
    required this.token,
    required this.issuedAt,
    required this.expiresIn,
  });

  // Empty user which represents an unauthenticated user.
  static const empty = AdminUser(
    id: 0,
    name: '_',
    lastName: '_',
    userName: '_',
    mobile: '_',
    image: '_',
    accessIds: '',
    centersAccessIds:'',
    token: '_',
    issuedAt: 0,
    expiresIn: 0,
  );

  AdminUser copyWith({
    int? id,
    String? name,
    String? lastName,
    String? userName,
    String? mobile,
    String? image,
    String? accessIds, //*1*2*13*
    String? centersAccessIds,//*1*2*3
    String? token,
    int? issuedAt,
    int? expiresIn,
  }) {
    return AdminUser(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      userName: userName ?? this.userName,
      mobile: mobile ?? this.mobile,
      image: image ?? this.image,
      accessIds: accessIds ?? this.accessIds,
      centersAccessIds:centersAccessIds??this.centersAccessIds,
      token: token ?? this.token,
      issuedAt: issuedAt ?? this.issuedAt,
      expiresIn: expiresIn ?? this.expiresIn,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        lastName,
        userName,
        mobile,
        accessIds,
    centersAccessIds,
        //image,
        token,
        issuedAt,
        expiresIn,
      ];

  bool hasAccessTo(int accessType) => accessIds.contains('*$accessType*');

  //return a List<Access>  of user's accesses which is like:*1*2*3*  to [Access(id:1,title:''), Access(...),...]
  List<Access> getAccessesAsList(List<Access> allAccesses) {
    String userAccessIds = accessIds;

    List<Access> result = allAccesses
        .where((Access c) => userAccessIds.contains('*${c.id}*'))
        .toList();
    debugPrint('user access id to Model:');
    for (var element in result) {
      debugPrint('${element.id}  - ${element.title}');
    }

    return result;
  }
  List<Centers> getAccessesCentersAsList(List<Centers> allCenters){
    String userAccessIds = centersAccessIds;

    List<Centers> result = allCenters
        .where((Centers c) => userAccessIds.contains('*${c.id}*'))
        .toList();
    debugPrint('user access to Centers to Model:');
    for (var element in result) {
      debugPrint('${element.id}  - ${element.name}');
    }

    return result;
  }

  //map a list of Access to this pattern:*id1*id2*  example: *1*2*3*4*
  static String mapAccessToStaredIds(List  userAccessesContaingId) {
    List<int> ids = _getIds(userAccessesContaingId);
    String starredString = listToString(ids);
    return starredString;
  }

  static List<int> _getIds(List  valuesContaingId) {
    List<int> ids = [];
    for (var s in valuesContaingId) {
      ids.add(s.id);
    }
    return ids;
  }

  static String listToString(List<int> lst) {
    String result = '*';

    for (int number in lst) {
      result += '$number*';
    }

    debugPrint('selected id to String :   $result');

    return result;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'userName': userName,
      'mobile': mobile,
      'accessIds': accessIds,
      'centersAccessIds':centersAccessIds,
      'token': token,
      'issuedAt': issuedAt,
      'expiresIn': expiresIn,
    };
  }

}

class Access extends Equatable implements DropDownBase {
  @override
  final int id;
  @override
  final String title;

  const Access({required this.id, required this.title});

  Access.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'];

  @override
  List<Object> get props => [
        id,
        title,
      ];
}
