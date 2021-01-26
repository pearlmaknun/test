part of 'machine_bloc.dart';

abstract class MachineEvent {
  const MachineEvent();
}

class ChangeProduct extends MachineEvent {
  int index;

  ChangeProduct(this.index);
}

class ChangeMoney extends MachineEvent {
  int nominal;

  ChangeMoney(this.nominal);
}

class InsertMoney extends MachineEvent {}

class Calculate extends MachineEvent {}

class Reset extends MachineEvent {}
