import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SquareController extends GetxController{

  final List<String> items = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    items.add('1');
    items.add('1');
    items.add('1');
    items.add('1');
    items.add('1');
    items.add('1');
    items.add('1');
  }

}