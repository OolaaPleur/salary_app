import 'package:flutter/material.dart';

class ShowYearTableScreen extends StatefulWidget {
  static const routeName = '/show-table-screen';

  const ShowYearTableScreen({Key? key}) : super(key: key);

  @override
  _ShowYearTableScreenState createState() => _ShowYearTableScreenState();
}

class _ShowYearTableScreenState extends State<ShowYearTableScreen> {
  static String imageUrl = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQtiXSYwaCWDjeBh2hqCIqjjVECKptGphKrZ6UoDPXBJ6zgpo_Lex2E715W7IaIRezV5W3I8J0Xe__f/pubchart?oid=6171734&format=image';
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: InkWell(
            onTap: () {setState(() {
              imageUrl='https://docs.google.com/spreadsheets/d/e/2PACX-1vQtiXSYwaCWDjeBh2hqCIqjjVECKptGphKrZ6UoDPXBJ6zgpo_Lex2E715W7IaIRezV5W3I8J0Xe__f/pubchart?oid=6171734&format=image&${DateTime.now().microsecondsSinceEpoch}';
            });},
            child:
            Transform.rotate(
              angle: 0,
              child: Image.network(
                imageUrl, fit: BoxFit.cover,
              ),
            )
        ),
      ),
    );
  }
}