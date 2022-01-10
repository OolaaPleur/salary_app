import 'package:flutter/material.dart';

import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

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

  late TextEditingController hoursTotalController = TextEditingController(text: '');
  late TextEditingController ruggedTreadCountController = TextEditingController(text: '');
  late TextEditingController nonRuggedTreadCountController = TextEditingController(text: '');
  late TextEditingController patchCountController = TextEditingController(text: '');
  late TextEditingController sideRepairCentimeterCountController = TextEditingController(text: '');
  late TextEditingController packedTreadController = TextEditingController(text: '');
  late TextEditingController treadAndLayerCountController = TextEditingController(text: '');
  late TextEditingController treadAndNonLayerCountController = TextEditingController(text: '');
  late TextEditingController hourCountController = TextEditingController(text: '');
  late TextEditingController cutTreadCountController = TextEditingController(text: '');
  late String overallForOneDay;
  late String hourlyPay = "";
  late String treadAndNonLayerDayPay = "";
  late String bruttoHourlySalary = "";
  late String nettoHourlySalary = "";
  late String bruttoPieceSalary = "";
  late String nettoPieceSalary = "";

  Future<void> _fetchWork() async {
    //print(dateTime);
    if (dateTime == null) {
      DateTime dateTime = DateTime.now();
      print('${dateTime.day} stuck in loop');
      await connectToSpreadsheetAndGetData(dateTime);
      return;
    } else {
      print(dateTime);
      print(dateTime);
      await connectToSpreadsheetAndGetData(dateTime);
      print(cellForCurrentDay);
    }
  }

  Future<void> connectToSpreadsheetAndGetData(DateTime dateTime) async {
    EntrySheet entrySheet = new EntrySheet(dateTime: dateTime);
    cellForCurrentDay = await entrySheet.fetchWorkSheet(dateTime.day + 1);
    cellForSalary = await entrySheet.fetchSalary();
    print('${dateTime.day} stuck in loop');
    hoursTotalController = TextEditingController(text: cellForCurrentDay
        .elementAt(2)
        .value
        .replaceAll('.', ','));

    treadAndNonLayerCountController = TextEditingController(text: cellForCurrentDay.elementAt(10).value);
    ruggedTreadCountController = TextEditingController(text: cellForCurrentDay.elementAt(4).value);
    nonRuggedTreadCountController = TextEditingController(text: cellForCurrentDay.elementAt(5).value);
    patchCountController = TextEditingController(text: cellForCurrentDay.elementAt(6).value);
    sideRepairCentimeterCountController = TextEditingController(text: cellForCurrentDay.elementAt(7).value);
    packedTreadController = TextEditingController(text: cellForCurrentDay.elementAt(8).value);
    treadAndLayerCountController = TextEditingController(text: cellForCurrentDay.elementAt(9).value);
    hourCountController = TextEditingController(text: cellForCurrentDay
        .elementAt(11)
        .value
        .replaceAll('.', ','));
    cutTreadCountController = TextEditingController(text: cellForCurrentDay.elementAt(12).value);
    overallForOneDay = cellForCurrentDay.elementAt(21).value;
    hourlyPay = cellForCurrentDay.elementAt(31).value;
    treadAndNonLayerDayPay = cellForCurrentDay.elementAt(29).value;
    bruttoHourlySalary = cellForSalary.elementAt(0).value;
    nettoHourlySalary = cellForSalary.elementAt(1).value;
    bruttoPieceSalary = cellForSalary.elementAt(2).value;
    nettoPieceSalary = cellForSalary.elementAt(3).value;
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

  bool _enabled = false;

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
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: Row(
                        children: [
                          Expanded(
                              child: Shimmer.fromColors(
                                  baseColor: Color.fromRGBO(176, 176, 176, 1),
                                  highlightColor: Colors.white,
                                  child: buildAddDataScreen(
                                      context, _enabled = false))),
                        ],
                      ),
                    )
                  : buildAddDataScreen(context, _enabled = true),
        ));
  }

  RefreshIndicator buildAddDataScreen(BuildContext context, bool _enabled) {
    return RefreshIndicator(
      onRefresh: () async {
        _fetchWork();
        setState(() {
          print(_enabled.toString());
        });
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
                      onPressed: _enabled ? _presentDatePicker : null,
                      child: Text(AppLocalizations.of(context)!.chooseDate),
                    ),
                    if (dateTime != null)
                      Text(
                          DateFormat('dd.MM.yyyy').format(dateTime).toString()),
                    if (dateTime == null)
                      Text(DateFormat('dd.MM.yyyy')
                          .format(DateTime.now())
                          .toString()),
                  ],
                ),
                _enabled
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          overallForOneDay == '0' ||
                              overallForOneDay.isEmpty
                              ? SizedBox.shrink()
                              // next - parse to double value at
                              // cellForCurrentDay list, then leave 2 digits
                              // after dot, make string and replace dot with
                              // comma
                              : Text("€" +
                                  NumberFormat()
                                      .parse(
                                      overallForOneDay)
                                      .toStringAsFixed(2)
                                      .replaceAll('.', ',') +
                                  ' - выработка за день'),
                          double.tryParse(hourlyPay) == null
                              ? SizedBox.shrink()
                              // next - parse to double value at
                              // cellForCurrentDay list, then leave 2 digits
                              // after dot, make string and replace dot with
                              // comma
                              : Text("€" +
                                  NumberFormat().parse(hourlyPay).toStringAsFixed(2).replaceAll('.', ',') +
                                  ' в час')
                        ],
                      )
                    : SizedBox.shrink(),
                TextFormField(
                  enabled: _enabled,
                  controller: hoursTotalController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: _enabled
                          ? Colors.lightGreen
                          : Color.fromRGBO(252, 252, 252, 1),
                      labelText: AppLocalizations.of(context)!.hoursTotal),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) => hoursTotal = value,
                  keyboardType: TextInputType.number,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFormField(
                        enabled: _enabled,
                        controller: treadAndNonLayerCountController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: _enabled
                                ? Colors.lightGreen
                                : Color.fromRGBO(252, 252, 252, 1),
                            labelText: AppLocalizations.of(context)!
                                .treadAndNonLayerCount),
                        textInputAction: TextInputAction.next,
                        onSaved: (value) => treadAndNonLayerCount = value,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    _enabled
                        ? Row(
                            children: [
                              treadAndNonLayerDayPay == '0'
                                  ? SizedBox.shrink()
                                  : Container(
                                      child: Text("   €" +
                                          treadAndNonLayerDayPay),
                                    )
                            ],
                          )
                        : SizedBox.shrink()
                  ],
                ),
                TextFormField(
                  enabled: _enabled,
                  controller: ruggedTreadCountController,
                  decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)!.ruggedTreadCount),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) => ruggedTreadCount = value,
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  enabled: _enabled,
                  controller: nonRuggedTreadCountController,
                  decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)!.nonRuggedTreadCount),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) => nonRuggedTreadCount = value,
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  enabled: _enabled,
                  controller: patchCountController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.patchCount),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) => patchCount = value,
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  enabled: _enabled,
                  controller: sideRepairCentimeterCountController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!
                          .sideRepairCentimeterCount),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) => sideRepairCentimeterCount = value,
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  enabled: _enabled,
                  controller: packedTreadController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.packedTread),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) => packedTread = value,
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  enabled: _enabled,
                  controller: treadAndLayerCountController,
                  decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)!.treadAndLayerCount),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) => treadAndLayerCount = value,
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  enabled: _enabled,
                  controller: hourCountController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.hourCount),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) => hourCount = value,
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  enabled: _enabled,
                  controller: cutTreadCountController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.cutTreadCount),
                  textInputAction: TextInputAction.none,
                  onSaved: (value) => cutTreadCount = value,
                  keyboardType: TextInputType.number,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.topLeft,
                  child: _enabled && double.tryParse(bruttoHourlySalary) != null
                      ? Text("Зарплата брутто(часовая): " +
                          double.parse(bruttoHourlySalary)
                              .toStringAsFixed(2)
                              .replaceAll('.', ','))
                      : SizedBox.shrink(),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.topLeft,
                  child: _enabled && double.tryParse(nettoHourlySalary) != null
                      ? Text("Зарплата нетто(часовая): " +
                          double.parse(nettoHourlySalary)
                              .toStringAsFixed(2)
                              .replaceAll('.', ','))
                      : SizedBox.shrink(),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.topLeft,
                  child: _enabled && double.tryParse(bruttoPieceSalary) != null
                      ? Text("Зарплата брутто(сдельная): " +
                          double.parse(bruttoPieceSalary)
                              .toStringAsFixed(2)
                              .replaceAll('.', ','))
                      : SizedBox.shrink(),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.topLeft,
                  child: _enabled && double.tryParse(bruttoHourlySalary) != null
                      ? Text("Зарплата нетто(сдельная): " +
                          double.parse(bruttoHourlySalary)
                              .toStringAsFixed(2)
                              .replaceAll('.', ','))
                      : SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
