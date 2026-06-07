class ShopProduct {
  final int id;
  final String name;
  final String? description;
  final String? brand;
  final double mrp;
  final double patientPrice;
  final String? categoryName;
  final String sellerName;
  final String? primaryImage;
  final double ratingAvg;
  final int ratingCount;
  final bool isFittoriaPick;

  ShopProduct({
    required this.id,
    required this.name,
    this.description,
    this.brand,
    required this.mrp,
    required this.patientPrice,
    this.categoryName,
    required this.sellerName,
    this.primaryImage,
    required this.ratingAvg,
    required this.ratingCount,
    required this.isFittoriaPick,
  });
}

class ShopCategory {
  final int id;
  final String name;

  ShopCategory({required this.id, required this.name});
}

class ShopData {
  final List<ShopProduct> products;
  final List<ShopCategory> categories;
  final List<String>? goalTags;

  ShopData({
    required this.products,
    required this.categories,
    this.goalTags,
  });
}
