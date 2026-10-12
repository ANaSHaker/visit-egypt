import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:get/get.dart';
List<PopupMenuEntry> menu(BuildContext context,Callback editPress ,Callback deletePress)
{
  List<PopupMenuEntry> list =
  [
    PopupMenuItem(
      value: 0,

      child: Row(
        children: [
          FlatButton.icon(
            icon: Icon(Icons.edit),
            label: Text("Update".tr),
            onPressed:editPress,
          ),
        ],
      ),
    ),
    PopupMenuItem(
      value: 1,
      child: Row(
        children: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.delete),
            label: Text("Delete".tr),
            onPressed: deletePress,
          )
        ],
      ),
    )
  ];
  return list;
}