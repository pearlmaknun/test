import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:vending_machine/src/product.dart';

part 'machine_event.dart';

part 'machine_state.dart';

class MachineBloc extends Bloc<MachineEvent, MachineState> {
  static List<Product> _list = [
    Product("BISKUIT", 6000, 2, false),
    Product("CHIPS", 8000, 2, false),
    Product("OREO", 10000, 2, false),
    Product("TANGO", 12000, 2, false),
    Product("COKELAT", 15000, 2, false)
  ];
  Product _selectedProduct;
  static List _money = [2000, 5000, 10000, 20000, 50000];
  int _selectedMoney;
  List<int> _moneyBundle = new List();
  List<int> _changeBundle = new List();

  MachineBloc() : super(MachineInitial(_list, _money));

  @override
  void onTransition(Transition<MachineEvent, MachineState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  Stream<MachineState> mapEventToState(
    MachineEvent event,
  ) async* {
    if (event is ChangeProduct) {
      yield* _mapChangeProductToState(event);
    } else if (event is ChangeMoney) {
      yield* _mapChangeMoneyToState(event);
    } else if (event is InsertMoney) {
      yield* _mapInsertMoneyToState(event);
    } else if (event is Calculate) {
      yield* _mapCalculateToState(event);
    }
  }

  Stream<MachineState> _mapChangeProductToState(ChangeProduct event) async* {
    _list.forEach((element) => element.selected = false);
    _list[event.index].selected = true;
    _selectedProduct = _list[event.index];
    yield ProductChanged(_list);
  }

  Stream<MachineState> _mapChangeMoneyToState(ChangeMoney event) async* {
    _selectedMoney = event.nominal;
    yield MoneyChanged(_selectedMoney, _money);
  }

  Stream<MachineState> _mapInsertMoneyToState(InsertMoney event) async* {
    print(_selectedMoney);
    _moneyBundle.add(_selectedMoney);
    yield PreviewMoneys(_moneyBundle);
  }

  Stream<MachineState> _mapCalculateToState(Calculate event) async* {
    int total = 0;
    int change = 0;
    for (int a in _moneyBundle) {
      total = total + a;
    }
    if (_selectedProduct.quantity >= 0) {
      if (total >= _selectedProduct.price) {
        change = total - _selectedProduct.price;
        calculateChange(change);
      } else {
        yield InsufficientMoney(_changeBundle);
      }
      yield PurchaseDone(_changeBundle);
    } else {
      change = total;
      yield SoldOut(_changeBundle);
    }
  }

  calculateChange(int amountMoneyToReturn) {
    print(amountMoneyToReturn);
    int remainingAmount = amountMoneyToReturn;
    for (int a in _money) {
      print('masuk');
      int numberOf = remainingAmount ~/ a;
      for (int i = numberOf; i > 0; i++) {
        _changeBundle.add(a);
      }
      remainingAmount = remainingAmount % numberOf;
    }
    for (int a in _changeBundle) {
      print(a);
    }
  }
}
