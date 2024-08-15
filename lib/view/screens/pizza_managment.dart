import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:slice_master_pro/model/pizza.dart';
import 'package:slice_master_pro/utils/extentions/extentions.dart';
import 'package:slice_master_pro/viewmodel/repository/pizza_cubit.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/images.dart';
import '../../utils/helpers/my_snackbar.dart';
import '../../viewmodel/image/image_cubit.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class PizzaManagmentScreen extends StatefulWidget {
  const PizzaManagmentScreen({super.key});

  @override
  State<PizzaManagmentScreen> createState() => _PizzaManagmentScreenState();
}

class _PizzaManagmentScreenState extends State<PizzaManagmentScreen> {
  File? _pickedImage;
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SvgPicture.asset(
          ImageManager.logo,
          width: context.width * 0.15,
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          SizedBox(width: 5.w),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: -35,
            right: 10,
            child: Image.asset(
              ImageManager.splashImage,
              width: context.width * 0.2,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: context.width / 2.7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocConsumer<PickImageCubit, PickImageState>(
                      listener: (context, state) {
                        if (state is PickImageSuccess) {
                          _pickedImage = state.imagePath;
                        }
                        if (state is PickImageFailure) {
                          customSnackBar(context, state.errMessage);
                        }
                      },
                      builder: (context, state) {
                        return ElevatedButton(
                          style: ButtonStyle(
                            padding:
                                const WidgetStatePropertyAll(EdgeInsets.zero),
                            shape: const WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                // side: BorderSide(
                                //     width: 1.2, color: ColorManager.offWhite2),
                              ),
                            ),
                            overlayColor: const WidgetStatePropertyAll(
                                ColorManager.offWhite2),
                            backgroundColor: WidgetStatePropertyAll(
                                ColorManager.offWhite2.withOpacity(0.9)),
                            fixedSize: WidgetStatePropertyAll(
                              Size(context.width / 3, context.height / 2),
                            ),
                          ),
                          child: _pickedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.file(
                                    width: double.infinity,
                                    height: double.infinity,
                                    _pickedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.add_a_photo_rounded,
                                  size: 20.sp,
                                  color: ColorManager.darkGrey,
                                ),
                          onPressed: () =>
                              context.cubit<PickImageCubit>().pickImage(),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                _buildPizzaForm(context)
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              margin: EdgeInsets.only(right: context.width * 0.04, bottom: 20),
              width: context.width / 3,
              height: context.height / 1.2,
              decoration: BoxDecoration(
                // border: const Border.symmetric(
                //   vertical: BorderSide(width: 2, color: ColorManager.darkGrey),
                // ),
                color: ColorManager.offWhite2.withOpacity(0.6),
                boxShadow: ShadowManager.shadow,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildPizzaList(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPizzaForm(BuildContext context) {
    return SizedBox(
      width: context.width / 3,
      child: Column(
        children: [
          MyTextFormField(
            controller: _nameController,
            hintText: 'Pizza Name',
          ),
          MyTextFormField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            hintText: 'Price',
          ),
          SizedBox(height: 20.h),
          MyElevatedButton(
            title: 'Add Pizza',
            onPressed: () {
              if (_nameController.text.isNotEmpty &&
                  _priceController.text.isNotEmpty &&
                  _pickedImage != null) {
                final name = _nameController.text;
                final price = int.tryParse(_priceController.text) ?? 0;
                final image = _pickedImage!.path;
                context.cubit<PizzasRepositoryCubit>().addUserPizza(
                      name: name,
                      largePrice: price,
                      mediumPrice: price,
                      smallPrice: price,
                      image: image,
                    );
                _clearForm();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPizzaList(BuildContext context) {
    return BlocBuilder<PizzasRepositoryCubit, List<PizzaModel>>(
      builder: (context, pizzas) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: pizzas.map((pizza) => _buildPizzaItem(pizza)).toList(),
        );
      },
    );
  }

  Widget _buildPizzaItem(PizzaModel pizza) {
    return ListTile(
      leading: CircleAvatar(
        radius: 40,
        backgroundImage: FileImage(File(pizza.image!)),
      ),
      title: Text(
        pizza.name,
        style: context.textTheme.bodyLarge,
      ),
      subtitle: Text(
        '${pizza.mediumPrice} EGP',
        style: context.textTheme.displayMedium,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: context.iconTheme.color,
            ),
            onPressed: () => _showUpdatePriceDialog(pizza),
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: context.iconTheme.color,
            ),
            onPressed: () => _showConfirmationDialog(pizza),
          ),
        ],
      ),
    );
  }

  void _showUpdatePriceDialog(PizzaModel pizza) {
    TextEditingController priceController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: ColorManager.white,
          title: Text(
            'Update Price for ${pizza.name}',
            style: context.textTheme.bodyLarge,
          ),
          content: MyTextFormField(
            controller: priceController,
            keyboardType: TextInputType.number,
            hintText: 'Enter new price',
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                overlayColor: WidgetStatePropertyAll(
                    ColorManager.correct.withOpacity(0.3)),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Cancel',
                style: context.textTheme.displayMedium
                    ?.copyWith(color: ColorManager.correct),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                overlayColor:
                    WidgetStatePropertyAll(ColorManager.red.withOpacity(0.3)),
              ),
              onPressed: () {
                num newPrice =
                    num.tryParse(priceController.text) ?? pizza.mediumPrice;
                context.cubit<PizzasRepositoryCubit>().updatePizzaPrice(
                      pizza: pizza,
                      newLargePrice: newPrice,
                      newMediumPrice: newPrice,
                      newSmallPrice: newPrice,
                    );
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Update',
                style: context.textTheme.displayMedium
                    ?.copyWith(color: ColorManager.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(PizzaModel pizza) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: ColorManager.white,
          title: Text(
            'Remove ${pizza.name}?',
            style: context.textTheme.bodyLarge,
          ),
          content: Text(
            'Are you sure you want to remove this pizza?',
            style: context.textTheme.displayMedium,
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                overlayColor: WidgetStatePropertyAll(
                    ColorManager.correct.withOpacity(0.3)),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: context.textTheme.displayMedium
                    ?.copyWith(color: ColorManager.correct),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                overlayColor:
                    WidgetStatePropertyAll(ColorManager.red.withOpacity(0.3)),
              ),
              onPressed: () {
                context
                    .cubit<PizzasRepositoryCubit>()
                    .removeUserPizza(pizzaName: pizza.name);

                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Remove',
                style: context.textTheme.displayMedium
                    ?.copyWith(color: ColorManager.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    _nameController.clear();
    _priceController.clear();
    setState(() {
      _pickedImage = null;
    });
  }
}
