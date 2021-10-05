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

  Future<void> _fetchWork() async {
    if (dateTime == null) {
      DateTime dateTimeNow = DateTime.now();
      EntrySheet entrySheet = new EntrySheet(
          dateTime: DateFormat('dd.MM.yyyy').format(dateTimeNow).toString());
      cellForCurrentDay = await entrySheet.fetchWorkSheet(dateTimeNow.day + 1);
      print('${dateTimeNow.day} stuck in loop');
      print(cellForCurrentDay.elementAt(2).value);
      return;
    }
    EntrySheet entrySheet = new EntrySheet(
        dateTime: DateFormat('dd.MM.yyyy').format(dateTime).toString());
    cellForCurrentDay = await entrySheet.fetchWorkSheet(dateTime.day + 1);
    print('${dateTime.day} stuck in loop');
    print(cellForCurrentDay.elementAt(2).value);
  }

  Future<void> _saveForm() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Loading...',
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 10),
    ));
    //print(_isLoading.toString());
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    //print(dateTime.toString());
    //print(ruggedTreadCount);

    if (dateTime == null) {
      dateTime = DateTime.now();
    }
    EntrySheet entrySheet = new EntrySheet(
      dateTime: DateFormat('dd.MM.yyyy').format(dateTime).toString(),
      hoursTotal:
          hoursTotal == '' ? 0 : double.parse(hoursTotal.replaceAll(',', '.')),
      ruggedTreadCount:
          ruggedTreadCount == '' ? 0 : int.parse(ruggedTreadCount),
      nonRuggedTreadCount:
          nonRuggedTreadCount == '' ? 0 : int.parse(nonRuggedTreadCount),
      patchCount: patchCount == '' ? 0 : int.parse(patchCount),
      sideRepairCentimeterCount: sideRepairCentimeterCount == ''
          ? 0
          : int.parse(sideRepairCentimeterCount),
      packedTread: packedTread == '' ? 0 : int.parse(packedTread),
      treadAndLayerCount:
          treadAndLayerCount == '' ? 0 : int.parse(treadAndLayerCount),
      treadAndNonLayerCount:
          treadAndNonLayerCount == '' ? 0 : int.parse(treadAndNonLayerCount),
      hourCount:
          hourCount == '' ? 0 : double.parse(hourCount.replaceAll(',', '.')),
      cutTreadCount: cutTreadCount == '' ? 0 : int.parse(cutTreadCount),
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
      lastDate: DateTime(2023),
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
                  onRefresh: () => _fetchWork(),
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
                                  child: Text(AppLocalizations.of(context)!.chooseDate),
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
                            TextFormField(
                              initialValue: cellForCurrentDay.isEmpty
                                  ? ''
                                  : cellForCurrentDay.elementAt(2).value.replaceAll('.', ','),
                              decoration:
                                  InputDecoration(labelText: AppLocalizations.of(context)!.hoursTotal),
                              textInputAction: TextInputAction.next,
                              onSaved: (value) => hoursTotal = value,
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              initialValue: cellForCurrentDay.isEmpty
                                  ? ''
                                  : cellForCurrentDay.elementAt(4).value,
                              decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!.ruggedTreadCount),
                              textInputAction: TextInputAction.next,
                              onSaved: (value) => ruggedTreadCount = value,
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              initialValue: cellForCurrentDay.isEmpty
                                  ? ''
                                  : cellForCurrentDay.elementAt(5).value,
                              decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!.nonRuggedTreadCount),
                              textInputAction: TextInputAction.next,
                              onSaved: (value) => nonRuggedTreadCount = value,
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              initialValue: cellForCurrentDay.isEmpty
                                  ? ''
                                  : cellForCurrentDay.elementAt(6).value,
                              decoration:
                                  InputDecoration(labelText: AppLocalizations.of(context)!.patchCount),
                              textInputAction: TextInputAction.next,
                              onSaved: (value) => patchCount = value,
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              initialValue: cellForCurrentDay.isEmpty
                                  ? ''
                                  : cellForCurrentDay.elementAt(7).value,
                              decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!.sideRepairCentimeterCount),
                              textInputAction: TextInputAction.next,
                              onSaved: (value) =>
                                  sideRepairCentimeterCount = value,
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              initialValue: cellForCurrentDay.isEmpty
                                  ? ''
                                  : cellForCurrentDay.elementAt(8).value,
                              decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!.packedTread),
                              textInputAction: TextInputAction.next,
                              onSaved: (value) => packedTread = value,
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              initialValue: cellForCurrentDay.isEmpty
                                  ? ''
                                  : cellForCurrentDay.elementAt(9).value,
                              decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!.treadAndLayerCount),
                              textInputAction: TextInputAction.next,
                              onSaved: (value) => treadAndLayerCount = value,
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              initialValue: cellForCurrentDay.isEmpty
                                  ? ''
                                  : cellForCurrentDay.elementAt(10).value,
                              decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!.treadAndNonLayerCount),
                              textInputAction: TextInputAction.next,
                              onSaved: (value) => treadAndNonLayerCount = value,
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              initialValue: cellForCurrentDay.isEmpty
                                  ? ''
                                  : cellForCurrentDay.elementAt(11).value.replaceAll('.', ','),
                              decoration:
                                  InputDecoration(labelText: AppLocalizations.of(context)!.hourCount),
                              textInputAction: TextInputAction.next,
                              onSaved: (value) => hourCount = value,
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              initialValue: cellForCurrentDay.isEmpty
                                  ? ''
                                  : cellForCurrentDay.elementAt(12).value,
                              decoration:
                                  InputDecoration(labelText: AppLocalizations.of(context)!.cutTreadCount),
                              textInputAction: TextInputAction.none,
                              onSaved: (value) => cutTreadCount = value,
                              keyboardType: TextInputType.number,
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
