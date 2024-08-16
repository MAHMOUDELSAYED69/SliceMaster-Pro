import 'package:slice_master_pro/model/pizza.dart';

import '../database/sql.dart';

import '../model/invoice.dart';
import '../utils/constants/images.dart';

class PizzasRepository {
  PizzasRepository._privateConstructor();
  static final PizzasRepository instance =
      PizzasRepository._privateConstructor();

  final SqlDb _sqlDb = SqlDb();

  static List<PizzaModel> pizzaList = [
    PizzaModel(
        name: 'Cheese Lover',
        smallPrice: 50,
        mediumPrice: 70,
        largePrice: 90,
        image: ImageManager.cheeseloverPizza),
    PizzaModel(
        name: 'Neapolitan',
        smallPrice: 40,
        mediumPrice: 60,
        largePrice: 80,
        image: ImageManager.neapolitanPizza),
  ];

  Future<List<PizzaModel>> getUserPizzas(String username) async {
    final data = await _sqlDb.readData(
        data: 'SELECT * FROM pizzas WHERE username = "$username"');
    List<PizzaModel> userPizzas = data
            ?.map((item) => PizzaModel(
                  name: item['name'] as String,
                  smallPrice: item['smallPrice'] as num,
                  mediumPrice: item['mediumPrice'] as num,
                  largePrice: item['largePrice'] as num,
                  image: item['image'] as String,
                ))
            .toList() ??
        [];

    List<PizzaModel> mergedList = [...pizzaList];
    mergedList.addAll(userPizzas);

    return mergedList;
  }

  Future<void> addUserPizza(String username, PizzaModel pizza) async {
    final data = '''
      INSERT INTO pizzas (name, smallPrice, mediumPrice, largePrice, image, username)
      VALUES ('${pizza.name}', ${pizza.smallPrice}, ${pizza.mediumPrice}, ${pizza.largePrice}, '${pizza.image}', "$username")
    ''';
    await _sqlDb.insertData(data: data);
  }

  Future<void> removeUserPizza(String username, String pizzaName) async {
    final data = '''
      DELETE FROM pizzas WHERE username = "$username" AND name = '$pizzaName'
    ''';
    await _sqlDb.deleteData(data: data);
  }

  Future<void> updatePizzaPrice(String username, String pizzaName,
      num newSmallPrice, num newMediumPrice, num newLargePrice) async {
    final data = '''
      UPDATE pizzas SET smallPrice = $newSmallPrice, mediumPrice = $newMediumPrice, largePrice = $newLargePrice WHERE username = "$username" AND name = '$pizzaName'
    ''';
    await _sqlDb.updateData(data: data);
  }

  Future<List<InvoiceModel>?> getInvoices(String username) async {
    final data = '''
    SELECT * FROM invoices WHERE username = "$username"
    ''';
    final List<Map<String, Object?>>? result =
        await _sqlDb.readData(data: data);
    return result?.map((e) => InvoiceModel.fromMap(e)).toList();
  }

  Future<void> saveInvoice({
    required int invoiceNumber,
    required String customerName,
    required String formattedDate,
    required String formattedTime,
    required double totalAmount,
    required num discount,
    required String items,
    required String userName,
  }) async {
    final data = '''
  INSERT INTO invoices (invoice_number, customer_name, date, time, total_amount, discount, items, username)
  VALUES ("$invoiceNumber", "$customerName", "$formattedDate", "$formattedTime", $totalAmount, $discount, "$items", "$userName")
  ''';
    await _sqlDb.insertData(data: data);
  }
}
