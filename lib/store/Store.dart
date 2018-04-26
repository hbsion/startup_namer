import 'package:startup_namer/store/action_type.dart';


abstract class Store {
  void dispatch(ActionType type, dynamic action);
}