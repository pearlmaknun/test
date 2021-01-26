import 'package:flutter/material.dart';
import 'package:vending_machine/src/product.dart';

class RadioItem extends StatelessWidget {
  final Product _item;

  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Container(
        height: 50.0,
        width: 50.0,
        child: new Center(
          child: new Text("${_item.name} RP${_item.price}",
              style: new TextStyle(
                  color: _item.selected ? Colors.white : Colors.black,
                  //fontWeight: FontWeight.bold,
                  fontSize: 18.0)),
        ),
        decoration: new BoxDecoration(
          color: _item.selected ? Colors.blueAccent : Colors.transparent,
          border: new Border.all(
              width: 1.0,
              color: _item.selected ? Colors.blueAccent : Colors.grey),
          borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
        ),
      ),
    );
  }
}
