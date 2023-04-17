import 'package:flutter/material.dart';

import '../models/updateChart.dart';

class ShowHourlyPayMonthTableScreen extends StatefulWidget {
  const ShowHourlyPayMonthTableScreen({Key? key}) : super(key: key);

  @override
  _ShowHourlyPayMonthTableScreenState createState() =>
      _ShowHourlyPayMonthTableScreenState();
}

class _ShowHourlyPayMonthTableScreenState
    extends State<ShowHourlyPayMonthTableScreen> {
  String tableUrl = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: UpdateChart.refreshPic(context, 'hourly'),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasError ||
                    !snapshot.hasData
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: InkWell(
                          onTap: () {
                            setState(() {});
                          },
                          child: Transform.rotate(
                            angle: 0,
                            child: Image.network(
                              snapshot.data.toString(),
                              fit: BoxFit.cover,
                            ),
                          )),
                    ),
                  ));
  }
}
