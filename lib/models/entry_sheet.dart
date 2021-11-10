import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:intl/intl.dart';


class EntrySheet {
  final String hoursTotal;
  final String ruggedTreadCount;
  final String nonRuggedTreadCount;
  final String patchCount;
  final String sideRepairCentimeterCount;
  final String packedTread;
  final String treadAndLayerCount;
  final String treadAndNonLayerCount;
  final String hourCount;
  final String cutTreadCount;
  final DateTime dateTime;

  EntrySheet({required this.dateTime,
    this.hoursTotal = '',
    this.ruggedTreadCount = '',
    this.nonRuggedTreadCount = '',
    this.patchCount = '',
    this.sideRepairCentimeterCount = '',
    this.packedTread = '',
    this.treadAndLayerCount = '',
    this.treadAndNonLayerCount = '',
    this.hourCount = '',
    this.cutTreadCount = ''});

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
      hoursTotal.replaceAll('.', ','),
      '',
      ruggedTreadCount,
      nonRuggedTreadCount,
      patchCount,
      sideRepairCentimeterCount,
      packedTread,
      treadAndLayerCount,
      treadAndNonLayerCount,
      hourCount.replaceAll('.', ','),
      cutTreadCount,
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
