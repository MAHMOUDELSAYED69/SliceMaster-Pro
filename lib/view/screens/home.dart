import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:slice_master_pro/utils/constants/images.dart';
import 'package:slice_master_pro/utils/extentions/extentions.dart';

import '../../model/pizza.dart';
import '../../viewmodel/calc/calccubit_cubit.dart';
import '../../viewmodel/repository/pizza_cubit.dart';
import '../widgets/add_remove.dart';
import '../widgets/invoice_widget.dart';
import '../widgets/item_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calculator = context.cubit<CalculatorCubit>();
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          ImageManager.logo,
          width: context.width * 0.15,
        ),
        actions: [
          SizedBox(width: 5.w),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.local_pizza),
          ),
          SizedBox(width: 5.w),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.inventory),
          ),
          SizedBox(width: 5.w),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.logout),
          ),
          SizedBox(width: 5.w),
        ],
      ),
      body: BlocBuilder<PizzasRepositoryCubit, List<PizzaModel>>(
        builder: (context, userPizzaList) {
          return Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.only(
                        left: context.width / 25,
                        right: context.width / 25,
                        top: 10,
                        bottom: 50,
                      ),
                      itemCount: userPizzaList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        crossAxisCount: 4,
                      ),
                      itemBuilder: (context, index) {
                        final pizza = userPizzaList[index];
                        return GestureDetector(
                          onTap: () => calculator.increment(pizza),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(1, -1),
                                      color: Colors.brown.withOpacity(0.5),
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(pizza.image!),
                                  ),
                                ),
                              ),
                              ItemCard(
                                price: pizza.mediumPrice,
                                name: pizza.name,
                              ),
                              AddAndRemoveCard(
                                onDecrement: () => calculator.decrement(pizza),
                                onIncrement: () => calculator.increment(pizza),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const InvoiceWidget(),
                ],
              ),
              Positioned(
                left: 5,
                top: 5,
                child: IconButton(
                  hoverColor: Colors.white,
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Colors.white.withOpacity(0.7),
                    ),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                  icon: const Icon(
                    size: 24,
                    Icons.settings,
                    color: Colors.brown,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
