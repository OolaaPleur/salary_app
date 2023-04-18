import 'package:flutter/material.dart';

import '../models/update_chart.dart';

class ShowTableScreen extends StatefulWidget {
  static const routeName = '/show-table-screen';

  @override
  _ShowTableScreenState createState() => _ShowTableScreenState();
}

class _ShowTableScreenState extends State<ShowTableScreen> {
  String tableUrl = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: UpdateChart.refreshPic(context, 'monthly'),
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
