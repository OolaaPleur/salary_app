import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:http/http.dart';
import 'package:salary_app/screens/add_data_screen.dart';



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

  final String dateTime;

  EntrySheet(
      {required this.dateTime,
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
    final gsheets = GSheets(_credentials);
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    var sheet = ss.worksheetByTitle('Октябрь 2021');
    //print(dateTime);
    var cell = await sheet!.cells.findByValue(dateTime).then((value) => value
        .toString()
        .split('at ')
        .last
        .substring(0, value.toString().split('at ').last.length - 1));
    var letter = cell.substring(0, cell.length - 2);
    print(letter);
    var digit = cell.substring(1);
    print(digit);
    //print(await sheet.values.value(column: 1, row: 3));
    await sheet.values.insertValue(hoursTotal.toString().replaceAll('.', ','),
        column: 3, row: int.parse(digit));
    await sheet.values.insertValue(ruggedTreadCount.toString(),
        column: 5, row: int.parse(digit));
    await sheet.values.insertValue(nonRuggedTreadCount.toString(),
        column: 6, row: int.parse(digit));
    await sheet.values.insertValue(patchCount.toString(),
        column: 7, row: int.parse(digit));
    await sheet.values.insertValue(sideRepairCentimeterCount.toString(),
        column: 8, row: int.parse(digit));
    await sheet.values.insertValue(packedTread.toString(),
        column: 9, row: int.parse(digit));
    await sheet.values.insertValue(treadAndLayerCount.toString(),
        column: 10, row: int.parse(digit));
    await sheet.values.insertValue(treadAndNonLayerCount.toString(),
        column: 11, row: int.parse(digit));
    await sheet.values.insertValue(hourCount.toString().replaceAll('.', ','),
        column: 12, row: int.parse(digit));
    await sheet.values.insertValue(cutTreadCount.toString(),
        column: 13, row: int.parse(digit));
    final url = Uri.parse('https://docs.google.com/spreadsheets/d/1WyykcwK1iTrqwuXKJtUYs1KqIwznJDC3tmnqh3ftmc8/edit#gid=203697693');
    final response = await get(url);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added successfully!')));
    }
  }
  Future<List<Cell>> fetchWorkSheet(int row) async {
    final gsheets = GSheets(_credentials);
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    var sheet = ss.worksheetByTitle('Октябрь 2021');
    final cellsRow = await sheet!.cells.row(row);
    return cellsRow;
  }
}
