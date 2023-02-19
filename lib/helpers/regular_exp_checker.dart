class ReqularExpChecker {
  //-----------validation
  static final RegExp regExpBirthDate = RegExp(
      r"^[1-4]\d{3}\/((0[1-6]\/((3[0-1])|([1-2][0-9])|(0[1-9])))|((1[0-2]|(0[7-9]))\/(30|31|([1-2][0-9])|(0[1-9]))))$");
  static final RegExp regExpCodeMelli = RegExp(r".{10}");
  static final RegExp regExpNameReg = RegExp(r'.{3}');
  static final RegExp regUserName = RegExp(r'.{3}');
  static final RegExp regExpPassword = RegExp(r'.{3}');


  static final RegExp regExpShamsiYear = RegExp(r'1[3-4][0-9]{2}');
  static final RegExp regExpShamsiDate =
      RegExp(r'1[3-4][0-9]{2}/[0-9]{2}/[0-9]{2}');
  static final RegExp regExpCodePersonely = RegExp(r'.');

  // static final RegExp regExpTime5 = RegExp(r'((0[1-9])|(1[0-9])|(2[0-3])):([0-5][0-9])');//length is 5 like: 13:04
  static final RegExp regExpTime5 =
      RegExp(r'[0-9]{2}:[0-5][0-9]'); //length is 5 like: 13:04
  static final RegExp regExpTimePersian5 = RegExp(
      r'([\u0660-\u0669]|[0-9]){2}:([0-5]|[\u0660-\u0665])([\u0660-\u0669]|[0-9])'); //length is 5 like: 13:04

  static final RegExp regExpMobile =
      RegExp(r"(09)(1[0-9]|3[0-9]|2[0-2])([0-9]{7})");
}
