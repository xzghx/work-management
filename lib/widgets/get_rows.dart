import 'package:flutter/material.dart';

import '../helpers/my_colors.dart';
import '../models/time_type.dart';

class GetRows extends StatelessWidget {
  final List<dynamic> keys;
  final void Function()? onClick;
  final int? isHoliday;

  const GetRows({super.key, required this.keys, this.onClick, this.isHoliday});

  @override
  Widget build(BuildContext context) {
    final List<Widget> c = keys
        .map(
          (e) => Flexible(
            flex: 1,
            child: Tooltip(
              waitDuration: const Duration(milliseconds: 400),
              message: e.toString(),
              textStyle: const TextStyle(fontSize: 20),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accentColor.withOpacity(0.1),
                    Colors.white10,
                    accentColor.withOpacity(0.2),
                  ],
                ),
              ),
              child: SizedBox(
                width: 200,
                child: Text(
                  e.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        )
        .toList();
    c.add(
      Flexible(
        flex: 1,
        child: IconButton(
          onPressed: () {
            if (onClick != null) onClick!();
          },
          icon: const Icon(Icons.select_all),
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color:( isHoliday != null && isHoliday ==1 )? Colors.pinkAccent.shade100 : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: c,
        ),
      ),
    );
  }
}

class GetRowsForInOut extends StatelessWidget {
  final List<Map<String, dynamic>> detailRecords;
  final List<DropdownMenuItem<TimeType>> timeTypeItems;
  final void Function(TimeType selected, String currentKey) onTimeTypeChanged;

  final bool checkBoxValue;
  final void Function(int selectedIndex) onIndexChanged;

  final int mapIndex;
  final void Function(String key, String value, int index) onFieldChanged;
  final void Function() onConfirmChanges;
  final List<TimeType> timeTypes;

  //
  final List<dynamic> keys;
  final List<dynamic>? values;

  late final List<dynamic> row1Keys = [];
  late final List<dynamic> row1Values = [];

  late final List<dynamic> row2Keys = [];
  late final List<dynamic> row2Values = [];

  late final List<dynamic> row3Keys = [];
  late final List<dynamic> row3Values = [];

  final List<int> key1 = []; //= [0, 1, 2]; //keys for row1
  final List<int> key2 =
      []; //[24, 25, 26, 27, 28, 29, 30, 31, 32]; //keys for row2
  final List<int> key3 = [];

  /* = [
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22
  ];*/ //[3,,22];//keys for row1

  //converted key values to text field with labels of keys and filled with values
  late final List<Widget> widgets1 = [];
  late final List<Widget> widgets2 = [];
  late final List<Widget> widgets3 = [];
  late final List<Widget> widgets4 = [];

  GetRowsForInOut({
    required this.detailRecords,
    required this.timeTypeItems,
    required this.onTimeTypeChanged,
    required this.checkBoxValue,
    required this.onIndexChanged,
    required this.mapIndex,
    required this.onFieldChanged,
    required this.keys,
    required this.values,
    required this.onConfirmChanges,
    required this.timeTypes,
    super.key,
  }) {
    prepareKeys();
    prepareRow1();
    // prepareRow2();
    prepareRow3();

    prepareChildren();
  }

  void prepareKeys() {
    //order matters. id has index 0 in db. so id must come first.
    //DO NOT CHANGE THIS ORDER because:
    //NOTE: Index of first element must be the smallest and the last element must be the largest
    key1.add(keys.indexOf('id'));
    key1.add(keys.indexOf('تاریخ'));
    key1.add(keys.indexOf('روزهفته'));
    key1.add(keys.indexOf('شیفت'));
    //----------
    //NOTE: Index of first element must be the smallest and the last element must be the largest
/*    key2.add(keys.indexOf('تعجیل'));
    key2.add(keys.indexOf('کارکرد'));
    key2.add(keys.indexOf('تاخیر'));
    key2.add(keys.indexOf('مرخصی'));
    key2.add(keys.indexOf('ماموریت'));
    key2.add(keys.indexOf('مرخصی'));
    key2.add(keys.indexOf('کسرکار'));
    key2.add(keys.indexOf('توضیحات'));*/
    //NOTE: Index of first element must be the smallest and the last element must be the largest
    key3.add(keys.indexOf('time1'));
    key3.add(keys.indexOf('type1'));
    key3.add(keys.indexOf('time2'));
    key3.add(keys.indexOf('type2'));
    key3.add(keys.indexOf('time3'));
    key3.add(keys.indexOf('type3'));
    key3.add(keys.indexOf('time4'));
    key3.add(keys.indexOf('type4'));
    key3.add(keys.indexOf('time5'));
    key3.add(keys.indexOf('type5'));
    key3.add(keys.indexOf('time6'));
    key3.add(keys.indexOf('type6'));
    key3.add(keys.indexOf('time7'));
    key3.add(keys.indexOf('type7'));
    key3.add(keys.indexOf('time8'));
    key3.add(keys.indexOf('type8'));
    key3.add(keys.indexOf('time9'));
    key3.add(keys.indexOf('type9'));
    key3.add(keys.indexOf('time10'));
    key3.add(keys.indexOf('type10'));
  }

  void prepareRow1() {
    for (int i = key1[0]; i <= key1.last; i++) {
      row1Keys.add(keys[i]);
      row1Values.add(values?[i]);
    }
  }

/*
  void prepareRow2() {
    for (int i = key2[0]; i <= key2.last; i++) {
      row2Keys.add(keys[i]);
      row2Values.add(values?[i]);
    }
  }
*/

  void prepareRow3() {
    for (int i = key3[0]; i <= key3.last; i++) {
      row3Keys.add(keys[i]);
      row3Values.add(values?[i]);
    }
  }

  //convert  key,values to text field with labels of keys and filled with values
  void prepareChildren() {
    //check box
    widgets1.add(Checkbox(
        value: checkBoxValue,
        onChanged: (bool? b) {
          if (b == true) onIndexChanged(mapIndex);
        }));
    //--------1--------------- dayName , date , id
    for (int i = row1Values.length - 1; i >= 0; i--) {
      widgets1.add(
        Text('${row1Values[i]}  '),
      );
    }
    // widgets1.add(const Spacer());
    //--------2--------------- karkard, tajil , ...
    for (int i = 0; i < row2Values.length; i++) {
      widgets2.add(
        Flexible(
          flex: 1,
          child: SizedBox(
            height: 30,
            child: TextFormField(
              style: const TextStyle(fontSize: 15),
              initialValue: row2Values[i].toString(),
              decoration: InputDecoration(
                  labelText: row2Keys[i],
                  contentPadding: const EdgeInsets.all(5)),
            ),
          ),
        ),
      );
    }
    //--------3---------------times and types
    for (int i = 0; i < row3Values.length; i++) {
      //create a DropDown button
      if (row3Keys[i].toString().contains('type')) {
        widgets3.add(MyTypeButton(
          index: mapIndex,
          detailRecords: detailRecords,
          currentKey: row3Keys[i],
          onTimeTypeChanged: onTimeTypeChanged,
          timeTypesItems: timeTypeItems,
          timeTypes: timeTypes,
        ));
/*
        widgets3.add(
          Flexible(
            flex: 1,
            child: SizedBox(
              height: 30,
              child: TextFormField(
                onChanged: (String value) {
                  onFieldChanged(row3Keys[i], value, mapIndex);
                },
                initialValue: row3Values[i].toString(),
                decoration: InputDecoration(
                  // filled: true,
                  // fillColor: Colors.greenAccent,
                  labelText: row3Keys[i],
                ),
              ),
            ),
          ),
        );*/
      } else
      //create a TextFormField
      {
        widgets3.add(
          Flexible(
            flex: 1,
            child: SizedBox(
              height: 30,
              child: TextFormField(
                onChanged: (String value) {
                  onFieldChanged(row3Keys[i], value, mapIndex);
                },
                initialValue: row3Values[i].toString(),
                decoration: InputDecoration(
                  // filled: true,
                  // fillColor: Colors.greenAccent,
                  labelText: row3Keys[i],
                ),
              ),
            ),
          ),
        );
      }
    }
    //--------4---------------
    //Add Confirm botton for row
    /*  widgets4.add(
      Row(
        children: [
          IconButton(
            icon: const Icon(Icons.done),
            color: Colors.greenAccent,
            onPressed: () {
              onConfirmChanges();
            },
          ),
        ],
      ),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // const SizedBox(height: 32),
          /*     Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widgets1,
          ),*/
          // const SizedBox(height: 16),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...widgets4,
              ...widgets1,
              ...widgets2,
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widgets3,
          ),
          const SizedBox(height: 16),
          /*     Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widgets4,
          ),*/
          // const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class MyTypeButton extends StatefulWidget {
  const MyTypeButton({
    Key? key,
    required this.index,
    required this.detailRecords,
    required this.onTimeTypeChanged,
    required this.currentKey,
    required this.timeTypesItems,
    required this.timeTypes,
  }) : super(key: key);
  final int index;
  final List<Map<String, dynamic>> detailRecords;
  final void Function(TimeType selected, String currentKey) onTimeTypeChanged;
  final String currentKey;
  final List<DropdownMenuItem<TimeType>> timeTypesItems;
  final List<TimeType> timeTypes;

  @override
  State<MyTypeButton> createState() => _MyTypeButtonState();
}

class _MyTypeButtonState extends State<MyTypeButton> {
  @override
  Widget build(BuildContext context) {
    int selectedTimeType =
        widget.detailRecords[widget.index][widget.currentKey];
    return DropdownButton<TimeType>(
        value: _getSelectedDropValue(selectedTimeType, widget.timeTypes),
        // TimeType(id: 15, name: 'عادی'),
        items: widget.timeTypesItems,
        onChanged: (TimeType? t) {
          setState(() {
            widget.onTimeTypeChanged(t!, widget.currentKey);
            widget.detailRecords[widget.index][widget.currentKey] = t.id;
          });
        });
  }

  TimeType _getSelectedDropValue(int selectedInt, List<TimeType> timeTypes) {
    return timeTypes.firstWhere((element) => element.id == selectedInt,
        orElse: () => timeTypes.first);
  }
}
