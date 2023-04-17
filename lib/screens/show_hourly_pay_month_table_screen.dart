import 'package:flutter/material.dart';

class ShowHourlyPayMonthTableScreen extends StatefulWidget {
  const ShowHourlyPayMonthTableScreen({Key? key}) : super(key: key);

  @override
  _ShowHourlyPayMonthTableScreenState createState() => _ShowHourlyPayMonthTableScreenState();
}

class _ShowHourlyPayMonthTableScreenState extends State<ShowHourlyPayMonthTableScreen> {
  Map<String, String> monthTables = {'4': '31468050', '12': '240229873'}; // map of months number as key and table number as value
  late String tableNumber = monthTables[DateTime.now().month.toString()].toString(); // get table number for current month
  late String tableUrl = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQtiXSYwaCWDjeBh2hqCIqjjVECKptGphKrZ6UoDPXBJ6zgpo_Lex2E715W7IaIRezV5W3I8J0Xe__f/pubchart?oid=$tableNumber&format=image&';
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: InkWell(
            onTap: () {setState(() {
              tableUrl=tableUrl+DateTime.now().microsecondsSinceEpoch.toString();
              print(DateTime.now().month.toString());
            });},
            child:
            Transform.rotate(
              angle: 0,
              child: Image.network(
                tableUrl, fit: BoxFit.cover,
              ),
            )
        ),
      ),
    );
  }
}