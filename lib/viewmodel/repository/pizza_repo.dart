import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slice_master_pro/model/pizza.dart';
import 'package:slice_master_pro/repositories/pizzas.dart';

import '../../utils/helpers/shared_pref.dart';

class PizzasRepositoryCubit extends Cubit<List<PizzaModel>> {
  PizzasRepositoryCubit() : super([]) {
    loadUserPizzas();
  }

  Future<void> loadUserPizzas() async {
    final username = await _getUsername();
    final pizzas = await PizzasRepository.instance.getUserPizzas(username);
    emit(pizzas);
  }

  Future<void> addUserJuice(
      {required String name, required int price, required String image}) async {
    final username = await _getUsername();
    final newJuice = PizzaModel(
        name: name,
        smallPrice: price,
        largePrice: price,
        mediumPrice: price,
        image: image);
    await PizzasRepository.instance.addUserPizza(username, newJuice);
    await loadUserPizzas();
  }

  Future<void> removeUserJuice({required String juiceName}) async {
    final username = await _getUsername();
    await PizzasRepository.instance.removeUserPizza(username, juiceName);
    await loadUserPizzas();
  }

  Future<void> updateJuicePrice(
      {required PizzaModel pizza, required int newPrice}) async {
    final username = await _getUsername();
    await PizzasRepository.instance.updatePizzaPrice(
      username,
      pizza.name,
      newPrice,
      newPrice,
      newPrice,
    );
    await loadUserPizzas();
  }

  Future<String> _getUsername() async {
    return CacheData.getData(key: 'currentUser');
  }
}
