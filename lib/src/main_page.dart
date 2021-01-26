import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vending_machine/src/machine_bloc.dart';
import 'package:vending_machine/src/product.dart';
import 'package:vending_machine/src/radio_item.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  MachineBloc _machineBloc;

  @override
  void initState() {
    _machineBloc = new MachineBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vending Machine"),
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (_) => _machineBloc,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Text("Select a Product"),
                ),
                BlocBuilder<MachineBloc, MachineState>(
                    buildWhen: (previousState, state) =>
                        state.runtimeType == MachineInitial ||
                        state.runtimeType == ProductChanged,
                    builder: (context, state) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return new InkWell(
                            splashColor: Colors.blue,
                            onTap: () {
                              _machineBloc.add(ChangeProduct(index));
                            },
                            child: new RadioItem(state.list[index]),
                          );
                        },
                      );
                    }),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Text("Insert Money"),
                ),
                BlocBuilder<MachineBloc, MachineState>(
                    buildWhen: (previousState, state) =>
                        state.runtimeType == MachineInitial ||
                        state.runtimeType == MoneyChanged,
                    builder: (context, state) {
                      return DropdownButton(
                        isExpanded: true,
                        hint: Text("Pilih Nilai Ulang"),
                        value: state.nominal,
                        items: state.money.map((value) {
                          return DropdownMenuItem(
                            child: Text(value.toString()),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (value) {
                          _machineBloc.add(ChangeMoney(value));
                        },
                      );
                    }),
                FlatButton(
                    onPressed: () {
                      _machineBloc.add(InsertMoney());
                    },
                    minWidth: MediaQuery.of(context).size.width,
                    color: Colors.blue,
                    child: Text(
                      "INSERT MONEY",
                      style: TextStyle(color: Colors.white),
                    )),
                BlocBuilder<MachineBloc, MachineState>(
                    buildWhen: (previousState, state) =>
                        state.runtimeType == MachineInitial ||
                        state.runtimeType == PreviewMoneys,
                    builder: (context, state) {
                      if (state.moneyBundle != null) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.moneyBundle.length,
                            itemBuilder: (context, index) =>
                                Text("${state.moneyBundle[index]} inserted"));
                      } else {
                        return Container();
                      }
                    }),
                FlatButton(
                    onPressed: () {
                      _machineBloc.add(Calculate());
                    },
                    child: Text("SUBMIT"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
