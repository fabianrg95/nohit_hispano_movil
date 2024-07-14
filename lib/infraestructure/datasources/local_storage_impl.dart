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

  @override
  Future<void> guardarJugadorFavorito(int idJugador, bool guardar) async {
    final box = GetStorage(BoxLocal.jugadoresFavoritos.nombreAlmacenamiento);

    List<int> listaJugadoresFavoritos = await obtenerJugadoresFavoritos();

    if (guardar == true) {
      listaJugadoresFavoritos.add(idJugador);
    } else {
      listaJugadoresFavoritos.remove(idJugador);
    }

    await box.write(BoxLocal.jugadoresFavoritos.llaveAlmacenamiento, listaJugadoresFavoritos);
    box.save();
  }

  @override
  Future<List<int>> obtenerJugadoresFavoritos() {
    final box = GetStorage(BoxLocal.jugadoresFavoritos.nombreAlmacenamiento);
    var read = box.read(BoxLocal.jugadoresFavoritos.llaveAlmacenamiento);
    final List<int> listaJugadoresFavoritos = read != null ? (read as List).map((e) => e as int).toList() : [];
    return Future.value(listaJugadoresFavoritos);
  }

  @override
  Future<void> guardarJuegoFavorito(int idJuego, bool guardar) async {
    final box = GetStorage(BoxLocal.juegosFavoritos.nombreAlmacenamiento);

    List<int> listaJuegosFavoritos = await obtenerJuegosFavoritos();

    if (guardar == true) {
      listaJuegosFavoritos.add(idJuego);
    } else {
      listaJuegosFavoritos.remove(idJuego);
    }

    await box.write(BoxLocal.juegosFavoritos.llaveAlmacenamiento, listaJuegosFavoritos);
    box.save();
  }

  @override
  Future<List<int>> obtenerJuegosFavoritos() async {
    final box = GetStorage(BoxLocal.juegosFavoritos.nombreAlmacenamiento);
    var read = box.read(BoxLocal.juegosFavoritos.llaveAlmacenamiento);
    final List<int> listaJuegosFavoritos = read != null ? (read as List).map((e) => e as int).toList() : [];
    return listaJuegosFavoritos;
  }
}
