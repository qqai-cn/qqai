import 'package:qqai/app/pages/demo/getx/domain/entity/demo_modal.dart';

abstract class IDemoRepo {
  Future<List<DemoModal>> getDemoModals();

  Future<DemoModal> getDemoModal(int id);
}
