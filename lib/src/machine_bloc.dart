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
  int _selectedProduct;
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
  Stream<MachineState> mapEventToState(MachineEvent event,) async* {
    if (event is ChangeProduct) {
      yield* _mapChangeProductToState(event);
    } else if (event is ChangeMoney) {
      yield* _mapChangeMoneyToState(event);
    } else if (event is InsertMoney) {
      yield* _mapInsertMoneyToState(event);
    } else if (event is Calculate) {
      yield* _mapCalculateToState(event);
    } else if (event is Reset) {
      yield* _mapResetToState(event);
    }
  }

  Stream<MachineState> _mapChangeProductToState(ChangeProduct event) async* {
    _list.forEach((element) => element.selected = false);
    _list[event.index].selected = true;
    _selectedProduct = event.index;
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

  Stream<MachineState> _mapResetToState(Reset event) async* {
    _selectedProduct = null;
    _list.forEach((element) => element.selected = false);
    _selectedMoney = null;
    _moneyBundle.clear();
    _changeBundle.clear();
    yield ResetState(_moneyBundle, _selectedMoney, _money, _list);
  }

  Stream<MachineState> _mapCalculateToState(Calculate event) async* {
    int total = 0;
    int change = 0;
    for (int a in _moneyBundle) {
      total = total + a;
    }
    if (_list[_selectedProduct].quantity > 0) {
      if (total >= _list[_selectedProduct].price) {
        change = total - _list[_selectedProduct].price;
        _list[_selectedProduct].quantity--;
        calculateChange(change);
        yield PurchaseDone(_changeBundle);
      } else {
        yield InsufficientMoney(_moneyBundle);
      }
    } else {
      change = total;
      yield SoldOut(_moneyBundle);
    }
  }

  calculateChange(int amountMoneyToReturn) {
    print(amountMoneyToReturn);
    int remainingAmount = amountMoneyToReturn;
    for (int j = _money.length-1; j >= 0; j--) {
      print('masuk');
      int numberOf = remainingAmount ~/ _money[j];
      print(numberOf);
      for (int i = numberOf; i > 0; i--) {
        _changeBundle.add(_money[j]);
      }
      remainingAmount = remainingAmount % _money[j];
    }
    for (int a in _changeBundle) {
      print(a);
    }
    print(_list[_selectedProduct].quantity);
  }
}
