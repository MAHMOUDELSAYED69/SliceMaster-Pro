class PizzaModel {
  final int? id;
  final String name;
  final num smallPrice;
  final num mediumPrice;
  final num largePrice;
  final String? image;

  PizzaModel({
    this.id,
    required this.name,
    required this.smallPrice,
    required this.mediumPrice,
    required this.largePrice,
    this.image,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'smallPrice': smallPrice,
      'mediumPrice': mediumPrice,
      'largePrice': largePrice,
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
      smallPrice: map['smallPrice'],
      mediumPrice: map['mediumPrice'],
      largePrice: map['largePrice'],
      image: map['image'],
    );
  }

  @override
  String toString() {
    return 'Pizza{id: $id, name: $name, smallPrice: $smallPrice, mediumPrice: $mediumPrice, largePrice: $largePrice, image: $image}';
  }
}
