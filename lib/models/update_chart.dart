import 'package:flutter/material.dart';

import 'entry_sheet.dart';

class UpdateChart {
  static Future<String?> refreshPic(BuildContext context, String filter) async {
    EntrySheet entrySheet = new EntrySheet(dateTime: DateTime.now());
    var ret = await entrySheet.getTableUrl(filter);
    return ret;
  }
}