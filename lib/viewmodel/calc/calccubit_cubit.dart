import 'package:bloc/bloc.dart';
import 'package:slice_master_pro/model/pizza.dart';

enum PizzaSize { small, medium, large }

class CalculatorCubit extends Cubit<Map<PizzaModel, Map<PizzaSize, int>>> {
  CalculatorCubit() : super({});

  PizzaSize selectedSize = PizzaSize.medium;

  void increment(PizzaModel pizza) {
    final currentSizeCount = state[pizza]?[selectedSize] ?? 0;
    final updatedState = {
      ...state,
      pizza: {
        ...state[pizza]!,
        selectedSize: currentSizeCount + 1,
      }
    };
    emit(updatedState);
  }

  void decrement(PizzaModel pizza) {
    final currentSizeCount = state[pizza]?[selectedSize] ?? 0;
    if (currentSizeCount > 0) {
      final updatedState = {
        ...state,
        pizza: {
          ...state[pizza]!,
          selectedSize: currentSizeCount - 1,
        }
      };
      emit(updatedState);
    }
  }

  void setSize(PizzaSize size) {
    selectedSize = size;
    emit({...state}); // Emit state to update the UI if needed
  }

  void reset() => emit({});

  double getTotalPrice() {
    return state.entries.fold<double>(0, (sum, entry) {
      final pizza = entry.key;
      final sizeCounts = entry.value;
      return sum +
          sizeCounts.entries.fold<double>(0, (sizeSum, sizeEntry) {
            final size = sizeEntry.key;
            final count = sizeEntry.value;
            final price = getPizzaPrice(pizza, size);
            return sizeSum + (price * count);
          });
    });
  }

  num getPizzaPrice(PizzaModel pizza, PizzaSize size) {
    switch (size) {
      case PizzaSize.small:
        return pizza.smallPrice;
      case PizzaSize.medium:
        return pizza.mediumPrice;
      case PizzaSize.large:
        return pizza.largePrice;
    }
  }
}
