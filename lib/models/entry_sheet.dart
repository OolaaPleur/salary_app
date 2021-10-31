import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:intl/intl.dart';

class EntrySheet {
  final double hoursTotal;
  final int ruggedTreadCount;
  final int nonRuggedTreadCount;
  final int patchCount;
  final int sideRepairCentimeterCount;
  final int packedTread;
  final int treadAndLayerCount;
  final int treadAndNonLayerCount;
  final double hourCount;
  final int cutTreadCount;
  final DateTime dateTime;

  EntrySheet({required this.dateTime,
    this.hoursTotal = 0,
    this.ruggedTreadCount = 0,
    this.nonRuggedTreadCount = 0,
    this.patchCount = 0,
    this.sideRepairCentimeterCount = 0,
    this.packedTread = 0,
    this.treadAndLayerCount = 0,
    this.treadAndNonLayerCount = 0,
    this.hourCount = 0,
    this.cutTreadCount = 0});

  Future<void> addEntry(EntrySheet entrySheet, BuildContext context) async {
    final gsheets = GSheets(CREDENTIALS);
    final ss = await gsheets
        .spreadsheet(spreadsheetID);

    DateFormat dateFormatMonth = new DateFormat.LLLL('ru');
    var month = dateFormatMonth
        .format(dateTime); //get month to pick sheet which is needed
    var monthCapitalized =
    month.capitalize(); //make month name start from capital letter
    DateFormat dateFormatYear = new DateFormat.y('ru');
    var year = dateFormatYear
        .format(dateTime); //get year to pick sheet which is needed
    var sheet = ss.worksheetByTitle('$monthCapitalized $year');
    String str = DateFormat('dd.MM.yyyy').format(dateTime).toString();
    var cell = await sheet!.cells.findByValue(str).then((value) =>
        value
            .toString()
            .split('at ')
            .last
            .substring(0, value
            .toString()
            .split('at ')
            .last
            .length - 1));
    var letter = cell.substring(0, cell.length - 2);
    print(letter);
    var digit = cell.substring(1);
    print(digit);

    final data = [
      hoursTotal.toString().replaceAll('.', ','),
      0,
      ruggedTreadCount.toString(),
      nonRuggedTreadCount.toString(),
      patchCount.toString(),
      sideRepairCentimeterCount.toString(),
      packedTread.toString(),
      treadAndLayerCount.toString(),
      treadAndNonLayerCount.toString(),
      hourCount.toString().replaceAll('.', ','),
      cutTreadCount.toString(),
    ];
    await sheet.values.insertRow(int.parse(digit), data, fromColumn: 3).then((value) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Added successfully!',
            textAlign: TextAlign.center,
          )));
    });
  }

  Future<List<Cell>> fetchWorkSheet(int row) async {
    final gsheets = GSheets(CREDENTIALS);
    final ss = await gsheets.spreadsheet(spreadsheetID);

    DateFormat dateFormatMonth = new DateFormat.LLLL('ru');
    var month = dateFormatMonth
        .format(dateTime); //get month to pick sheet which is needed
    var monthCapitalized =
    month.capitalize(); //make month name start from capital letter
    DateFormat dateFormatYear = new DateFormat.y('ru');
    var year = dateFormatYear
        .format(dateTime); //get year to pick sheet which is needed
    var sheet = ss.worksheetByTitle('$monthCapitalized $year');
    final cellsRow = await sheet!.cells.row(row);
    return cellsRow;
  }
}
