import 'package:flutter/material.dart';

class ShowTableScreen extends StatefulWidget {
  static const routeName = '/show-table-screen';
  const ShowTableScreen({Key? key}) : super(key: key);

  @override
  _ShowTableScreenState createState() => _ShowTableScreenState();
}

class _ShowTableScreenState extends State<ShowTableScreen> {
  String tableUrl = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQtiXSYwaCWDjeBh2hqCIqjjVECKptGphKrZ6UoDPXBJ6zgpo_Lex2E715W7IaIRezV5W3I8J0Xe__f/pubchart?oid=2124533607&format=image&';
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: InkWell(
          onTap: () {setState(() {
            tableUrl=tableUrl+DateTime.now().microsecondsSinceEpoch.toString();
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