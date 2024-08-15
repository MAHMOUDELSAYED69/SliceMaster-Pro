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

  Future<void> addUserPizza({
    required String name,
    required int smallPrice,
    required int mediumPrice,
    required int largePrice,
    required String image,
  }) async {
    final username = await _getUsername();
    final newPizza = PizzaModel(
      name: name,
      smallPrice: smallPrice,
      mediumPrice: mediumPrice,
      largePrice: largePrice,
      image: image,
    );
    await PizzasRepository.instance.addUserPizza(username, newPizza);
    await loadUserPizzas();
  }

  Future<void> removeUserPizza({required String pizzaName}) async {
    final username = await _getUsername();
    await PizzasRepository.instance.removeUserPizza(username, pizzaName);
    await loadUserPizzas();
  }

  Future<void> updatePizzaPrice({
    required PizzaModel pizza,
    required num newSmallPrice,
    required num newMediumPrice,
    required num newLargePrice,
  }) async {
    final username = await _getUsername();
    await PizzasRepository.instance.updatePizzaPrice(
      username,
      pizza.name,
      newSmallPrice,
      newMediumPrice,
      newLargePrice,
    );
    await loadUserPizzas();
  }

  Future<String> _getUsername() async {
    return CacheData.getData(key: 'currentUser');
  }
}