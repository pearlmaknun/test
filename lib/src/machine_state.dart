part of 'machine_bloc.dart';

abstract class MachineState {
  List<Product> list;
  List money;
  int nominal;
  List moneyBundle;

  MachineState({this.list, this.money, this.nominal, this.moneyBundle});
}

class MachineInitial extends MachineState {

  MachineInitial(List<Product> list, List money) : super(list: list, money: money);

  @override
  String toString() => 'MachineInitial { result: $list }';
}

class ProductChanged extends MachineState {
  ProductChanged(List<Product> list) : super(list: list);
}

class MoneyChanged extends MachineState {
  MoneyChanged(int nominal, List money) : super(nominal: nominal, money: money);
}

class PreviewMoneys extends MachineState {
  PreviewMoneys(List moneyBundle) : super(moneyBundle: moneyBundle);
}

class SoldOut extends MachineState {
  SoldOut(List moneyBundle) : super(moneyBundle: moneyBundle);
}

class InsufficientMoney extends MachineState {
  InsufficientMoney(List moneyBundle) : super(moneyBundle: moneyBundle);
}

class PurchaseDone extends MachineState {
  PurchaseDone(List moneyBundle) : super(moneyBundle: moneyBundle);
}

