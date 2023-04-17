import 'package:flutter/material.dart';

import 'package:gsheets/gsheets.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'secret.dart';

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
  final String processingAndGlue;
  final DateTime dateTime;

  EntrySheet(
      {required this.dateTime,
      this.hoursTotal = '',
      this.ruggedTreadCount = '',
      this.nonRuggedTreadCount = '',
      this.patchCount = '',
      this.sideRepairCentimeterCount = '',
      this.packedTread = '',
      this.treadAndLayerCount = '',
      this.treadAndNonLayerCount = '',
      this.hourCount = '',
      this.cutTreadCount = '',
      this.processingAndGlue = ''});

  Future<void> addEntry(EntrySheet entrySheet, BuildContext context) async {
    Worksheet? sheet = await getSheetName();
    String str = DateFormat('dd.MM.yyyy').format(dateTime).toString();
    var cell = await sheet!.cells.findByValue(str).then((value) => value
        .toString()
        .split('at ')
        .last
        .substring(0, value.toString().split('at ').last.length - 1));
    var digit = cell.substring(1);

    final data = [
      hoursTotal.replaceAll('.', ','),
      ruggedTreadCount,
      nonRuggedTreadCount,
      patchCount,
      sideRepairCentimeterCount,
      packedTread,
      treadAndLayerCount,
      treadAndNonLayerCount,
      hourCount.replaceAll('.', ','),
      cutTreadCount,
      processingAndGlue
    ];
    await sheet.values
        .insertRow(int.parse(digit), data, fromColumn: 2)
        .then((value) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        'Added successfully!',
        textAlign: TextAlign.center,
      )));
    });
  }

  Future<List<Cell>> fetchWorkSheet(int row) async {
    Worksheet? sheet = await getSheetName();
    final cellsRow = await sheet!.cells.row(row);
    return cellsRow;
  }

  Future<List<Cell>> fetchSalary() async {
    Worksheet? sheet = await getSheetName();

    final bruttoHourlySalary = await sheet!.cells.cell(column: 2, row: 36);
    final nettoHourlySalary = await sheet.cells.cell(column: 2, row: 37);
    final bruttoPieceSalary = await sheet.cells.cell(column: 3, row: 36);
    final nettoPieceSalary = await sheet.cells.cell(column: 3, row: 37);

    List<Cell> salaryData = [
      bruttoHourlySalary,
      nettoHourlySalary,
      bruttoPieceSalary,
      nettoPieceSalary
    ];
    return salaryData;
  }

  Future<String?> getTableUrl(String filter) async {
    var tableNumber = 0;
    const _sheetsEndpoint =
        'https://sheets.googleapis.com/v4/spreadsheets/1WyykcwK1iTrqwuXKJtUYs1KqIwznJDC3tmnqh3ftmc8?key=$API_KEY';
    var url = Uri.parse(_sheetsEndpoint);
    try {
      final response = await http.get(url);
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      if (filter == 'monthly') {
        print(jsonResponse['sheets'][0]['charts'][0]['chartId']);
        tableNumber = jsonResponse['sheets'][0]['charts'][0]['chartId'];
        String tableUrl =
            'https://docs.google.com/spreadsheets/d/e/2PACX-1vQtiXSYwaCWDjeBh2hqCIqjjVECKptGphKrZ6UoDPXBJ6zgpo_Lex2E715W7IaIRezV5W3I8J0Xe__f/pubchart?oid=$tableNumber&format=image&';
        print(tableUrl);
        return tableUrl;
      } else {
        //should return hourly table
        print(jsonResponse['sheets'][0]['charts'][1]['chartId']);
        tableNumber = jsonResponse['sheets'][0]['charts'][1]['chartId'];
        String tableUrl =
            'https://docs.google.com/spreadsheets/d/e/2PACX-1vQtiXSYwaCWDjeBh2hqCIqjjVECKptGphKrZ6UoDPXBJ6zgpo_Lex2E715W7IaIRezV5W3I8J0Xe__f/pubchart?oid=$tableNumber&format=image&';
        print(tableUrl);
        return tableUrl;
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<Worksheet?> getSheetName() async {
    final gsheets = GSheets(CREDENTIALS);
    final ss = await gsheets.spreadsheet(spreadsheetID);

    DateFormat dateFormatMonth = new DateFormat.LLLL('ru');
    var month = dateFormatMonth
        .format(dateTime); //get month to pick sheet which is needed
    var monthCapitalized =
        month.capitalize; //make month name start from capital letter
    DateFormat dateFormatYear = new DateFormat.y('ru');
    var year = dateFormatYear
        .format(dateTime); //get year to pick sheet which is needed
    print('$monthCapitalized $year');
    var sheet = ss.worksheetByTitle('$monthCapitalized $year');
    return sheet;
  }
}
