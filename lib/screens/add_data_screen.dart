import 'package:flutter/material.dart';

import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/entry_sheet.dart';

class AddDataScreen extends StatefulWidget {
  static const routeName = '/add-data-screen';

  const AddDataScreen({Key? key}) : super(key: key);

  @override
  _AddDataScreenState createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  final _form = GlobalKey<FormState>();
  var dateTime;
  var hoursTotal;
  var ruggedTreadCount;
  var nonRuggedTreadCount;
  var patchCount;
  var sideRepairCentimeterCount;
  var packedTread;
  var treadAndLayerCount;
  var treadAndNonLayerCount;
  var hourCount;
  var cutTreadCount;
  List<Cell> cellForCurrentDay = [];
  List<Cell> cellForSalary = [];

  Future<void> _fetchWork() async {
    if (dateTime == null) {
      DateTime dateTimeNow = DateTime.now();
      EntrySheet entrySheet = new EntrySheet(dateTime: dateTimeNow);
      cellForCurrentDay = await entrySheet.fetchWorkSheet(dateTimeNow.day + 1);
      cellForSalary = await entrySheet.fetchSalary();
      print('${dateTimeNow.day} stuck in loop');
      print(cellForCurrentDay.elementAt(2).value);
      return;
    }
    EntrySheet entrySheet = new EntrySheet(dateTime: dateTime);
    cellForCurrentDay = await entrySheet.fetchWorkSheet(dateTime.day + 1);
    cellForSalary = await entrySheet.fetchSalary();
    print('${dateTime.day} stuck in loop');
    print(cellForCurrentDay.elementAt(2).value);
    print(cellForCurrentDay.elementAt(31).value);
  }

  Future<void> _saveForm() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Loading...',
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 10),
    ));
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    if (dateTime == null) {
      dateTime = DateTime.now();
    }
    EntrySheet entrySheet = new EntrySheet(
      dateTime: dateTime,
      hoursTotal: hoursTotal,
      ruggedTreadCount: ruggedTreadCount,
      nonRuggedTreadCount: nonRuggedTreadCount,
      patchCount: patchCount,
      sideRepairCentimeterCount: sideRepairCentimeterCount,
      packedTread: packedTread,
      treadAndLayerCount: treadAndLayerCount,
      treadAndNonLayerCount: treadAndNonLayerCount,
      hourCount: hourCount,
      cutTreadCount: cutTreadCount,
    );
    print(ruggedTreadCount);
    try {
      entrySheet.addEntry(entrySheet, context);
    } catch (error) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something went wrong:(')));
    } finally {}
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      firstDate: DateTime(2016),
      initialDate: DateTime.now(),
      lastDate: DateTime(2025),
      locale: const Locale('en', 'GB'),
    ).then((value) {
      if (value == null) {
        return null;
      }
      setState(() {
        dateTime = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _saveForm();
          },
          child: Icon(Icons.add),
        ),
        body: FutureBuilder(
          future: _fetchWork(),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    _fetchWork();
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _form,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: _presentDatePicker,
                                  child: Text(
                                      AppLocalizations.of(context)!.chooseDate),
                                ),
                                if (dateTime != null)
                                  Text(DateFormat('dd.MM.yyyy')
                                      .format(dateTime)
                                      .toString()),
                                if (dateTime == null)
                                  Text(DateFormat('dd.MM.yyyy')
                                      .format(DateTime.now())
                                      .toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                cellForCurrentDay.elementAt(21).value == '0' ||
                                        cellForCurrentDay
                                            .elementAt(21)
                                            .value
                                            .isEmpty
                                    ? SizedBox.shrink()
                                // next - parse to double value at
                                // cellForCurrentDay list, then leave 2 digits
                                // after dot, make string and replace dot with
                                // comma
                                    : Text("€" +
                                        NumberFormat()
                                            .parse(cellForCurrentDay
                                                .elementAt(21)
                                                .value)
                                            .toStringAsFixed(2)
                                            .replaceAll('.', ',') +
                                        ' - выработка за день'),
                                cellForCurrentDay.elementAt(31).value ==
                                        '#DIV/0! (Function DIVIDE parameter 2 cannot be zero.)'
                                    ? SizedBox.shrink()
                                // next - parse to double value at
                                // cellForCurrentDay list, then leave 2 digits
                                // after dot, make string and replace dot with
                                // comma
                                    : Text("€" +
                                        NumberFormat()
                                            .parse(cellForCurrentDay
                                                .elementAt(31)
                                                .value)
                                            .toStringAsFixed(2)
                                            .replaceAll('.', ',') +
                                        ' в час')
                              ],
                            ),
                            TextFormField(
                              initialValue: cellForCurrentDay.isEmpty
                                  ? ''
                                  : cellForCurrentDay
                                      .elementAt(2)
                                      .value
                                      .replaceAll('.', ','),
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.lightGreen,
                                  labelText:
                                      AppLocalizations.of(context)!.hoursTotal),
                              textInputAction: TextInputAction.next,
                              onSaved: (value) => hoursTotal = value,
                              keyboardType: TextInputType.number,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: cellForCurrentDay.isEmpty
                                        ? ''
                                        : cellForCurrentDay.elementAt(10).value,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.lightGreen,
                                        labelText: AppLocalizations.of(context)!
                                            .treadAndNonLayerCount),
                                    textInputAction: TextInputAction.next,
                                    onSaved: (value) =>
                                        treadAndNonLayerCount = value,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                cellForCurrentDay.elementAt(29).value == '0'
                                    ? SizedBox.shrink()
                                    : Container(
                                        child: Text("   €" +
                                            cellForCurrentDay
                                                .elementAt(29)
                                                .value),
                                      )
                              ],
                            ),
                            TextFormField(
                              initialValue: cellForCurrentDay.isEmpty
                                  ? ''
                                  : cellForCurrentDay.elementAt(4).value,
                              decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!
                                      .ruggedTreadCount),
                              textInputAction: TextInputAction.next,
                              onSaved: (value) => ruggedTreadCount = value,
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              initialValue: cellForCurrentDay.isEmpty
                                  ? ''
                                  : cellForCurrentDay.elementAt(5).value,
                              decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!
                                      .nonRuggedTreadCount),
                              textInputAction: TextInputAction.next,
                              onSaved: (value) => nonRuggedTreadCount = value,
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              initialValue: cellForCurrentDay.isEmpty
                                  ? ''
                                  : cellForCurrentDay.elementAt(6).value,
                              decoration: InputDecoration(
                                  labelText:
                                      AppLocalizations.of(context)!.patchCount),
                              textInputAction: TextInputAction.next,
                              onSaved: (value) => patchCount = value,
                              keyboardType: TextInputType.text,
                            ),
                            TextFormField(
                              initialValue: cellForCurrentDay.isEmpty
                                  ? ''
                                  : cellForCurrentDay.elementAt(7).value,
                              decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!
                                      .sideRepairCentimeterCount),
                              textInputAction: TextInputAction.next,
                              onSaved: (value) =>
                                  sideRepairCentimeterCount = value,
                              keyboardType: TextInputType.text,
                            ),
                            TextFormField(
                              initialValue: cellForCurrentDay.isEmpty
                                  ? ''
                                  : cellForCurrentDay.elementAt(8).value,
                              decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!
                                      .packedTread),
                              textInputAction: TextInputAction.next,
                              onSaved: (value) => packedTread = value,
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              initialValue: cellForCurrentDay.isEmpty
                                  ? ''
                                  : cellForCurrentDay.elementAt(9).value,
                              decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!
                                      .treadAndLayerCount),
                              textInputAction: TextInputAction.next,
                              onSaved: (value) => treadAndLayerCount = value,
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              initialValue: cellForCurrentDay.isEmpty
                                  ? ''
                                  : cellForCurrentDay
                                      .elementAt(11)
                                      .value
                                      .replaceAll('.', ','),
                              decoration: InputDecoration(
                                  labelText:
                                      AppLocalizations.of(context)!.hourCount),
                              textInputAction: TextInputAction.next,
                              onSaved: (value) => hourCount = value,
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              initialValue: cellForCurrentDay.isEmpty
                                  ? ''
                                  : cellForCurrentDay.elementAt(12).value,
                              decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!
                                      .cutTreadCount),
                              textInputAction: TextInputAction.none,
                              onSaved: (value) => cutTreadCount = value,
                              keyboardType: TextInputType.number,
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.topLeft,
                              child: Text("Зарплата брутто(часовая): " +
                                  double.parse(cellForSalary.elementAt(0).value)
                                      .toStringAsFixed(2)
                                      .replaceAll('.', ',')),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.topLeft,
                              child: Text("Зарплата нетто(часовая): " +
                                  double.parse(cellForSalary.elementAt(1).value)
                                      .toStringAsFixed(2)
                                      .replaceAll('.', ',')),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.topLeft,
                              child: Text("Зарплата брутто(сдельная): " +
                                  double.parse(cellForSalary.elementAt(2).value)
                                      .toStringAsFixed(2)
                                      .replaceAll('.', ',')),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.topLeft,
                              child: Text("Зарплата нетто(сдельная): " +
                                  double.parse(cellForSalary.elementAt(3).value)
                                      .toStringAsFixed(2)
                                      .replaceAll('.', ',')),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ));
  }
}
