import 'package:bloc/bloc.dart';
import 'package:slice_master_pro/model/pizza.dart';

class CalculatorCubit extends Cubit<Map<PizzaModel, int>> {
  CalculatorCubit() : super({});

  void increment(PizzaModel juice) {
    final currentCount = state[juice] ?? 0;
    emit({...state, juice: currentCount + 1});
  }

  void decrement(PizzaModel pizza) {
    final currentCount = state[pizza] ?? 0;
    if (currentCount > 0) {
      emit({...state, pizza: currentCount - 1});
    }
  }

  void reset() => emit({});

  double getTotalPrice() {
    return state.entries.fold<double>(0, (sum, entry) {
      return sum + entry.key.mediumPrice * entry.value;
    });
  }
}
