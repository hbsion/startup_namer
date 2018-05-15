import 'package:svan_play/store/action_type.dart';


abstract class Store {
  void dispatch(ActionType type, dynamic action);
}