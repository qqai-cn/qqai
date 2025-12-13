import 'package:qqai/app/pages/demo/getx/data/idemo_provider.dart';
import 'package:qqai/app/pages/demo/getx/domain/entity/demo_modal.dart';

import '../domain/adapters/idemo_repo.dart';

class DemoRepo implements IDemoRepo {
  DemoRepo({required this.provider});
  final IDemoProvider provider;

  @override
  Future<List<DemoModal>> getDemoModals() async {
    final cases = await provider.getDemoModals();
    if (cases.status.hasError) {
      return Future.error(cases.statusText!);
    } else {
      return cases.body!;
    }
  }

  Future<DemoModal> getDemoModal(int id) async {
    final country = await provider.getDemoModal(id);
    if (country.status.hasError) {
      return Future.error(country.statusText!);
    } else {
      return country.body!;
    }
  }
}
