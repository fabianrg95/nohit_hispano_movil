import 'package:get_storage/get_storage.dart';
import 'package:no_hit/domain/datasources/local_storage.dart';
import 'package:no_hit/infraestructure/enums/enums.dart';

class LocalStorageImpl extends LocalStorage {
  @override
  Future<void> guardarEsTemaClaro(final bool temaClaroSeleccinado) async {
    final box = GetStorage(BoxLocal.temaSeleccinado.nombreAlmacenamiento);
    await box.write(BoxLocal.temaSeleccinado.llaveAlmacenamiento, temaClaroSeleccinado);
    box.save();
  }

  @override
  Future<bool> obtenerEsTemaClaro() async {
    final box = GetStorage(BoxLocal.temaSeleccinado.nombreAlmacenamiento);
    final bool temaClaroSeleccionado = box.read(BoxLocal.temaSeleccinado.llaveAlmacenamiento) ?? false;
    return Future.value(temaClaroSeleccionado);
  }

  @override
  Future<bool> obtenerIntroduccionFinalizada() async {
    final box = GetStorage(BoxLocal.introduccionFinalizada.nombreAlmacenamiento);
    final bool introduccionFinalizada = box.read(BoxLocal.introduccionFinalizada.llaveAlmacenamiento) ?? false;
    return Future.value(introduccionFinalizada);
  }

  @override
  Future<void> guardarIntroduccionFinalizada(final bool introduccionFinalizada) async {
    final box = GetStorage(BoxLocal.introduccionFinalizada.nombreAlmacenamiento);
    await box.write(BoxLocal.introduccionFinalizada.llaveAlmacenamiento, introduccionFinalizada);
    box.save();
  }
}
