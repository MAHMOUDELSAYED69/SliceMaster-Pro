class PizzaModel {
  final int? id;
  final String name;
  final int price;
  final String? image;

  PizzaModel({
    this.id,
    required this.name,
    required this.price,
    this.image,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'price': price,
      'image': image,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory PizzaModel.fromMap(Map<String, dynamic> map) {
    return PizzaModel(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      image: map['image'],
    );
  }

  @override
  String toString() {
    return 'Juice{id: $id, name: $name, price: $price, image: $image}';
  }
}
