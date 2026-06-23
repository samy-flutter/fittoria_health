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

  factory ShopProduct.fromJson(Map<String, dynamic> json) {
    return ShopProduct(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      brand: json['brand'] as String?,
      mrp: double.tryParse(json['mrp']?.toString() ?? '') ?? 0.0,
      patientPrice: double.tryParse(json['patient_price']?.toString() ?? '') ?? 0.0,
      categoryName: json['category_name'] as String?,
      sellerName: json['seller_name'] as String? ?? 'Unknown Seller',
      primaryImage: json['primary_image'] as String?,
      ratingAvg: double.tryParse(json['rating_avg']?.toString() ?? '') ?? 0.0,
      ratingCount: int.tryParse(json['rating_count']?.toString() ?? '') ?? 0,
      isFittoriaPick: json['is_fittoria_pick'] == 1 || json['is_fittoria_pick'] == true || json['is_fittoria_pick'] == '1',
    );
  }
}




class ShopCategory {
  final int id;
  final String name;

  ShopCategory({required this.id, required this.name});

  factory ShopCategory.fromJson(Map<String, dynamic> json) {
    return ShopCategory(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class ShopAddress {
  final int id;
  final String name;
  final String phone;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String pincode;
  final bool isDefault;

  ShopAddress({
    required this.id,
    required this.name,
    required this.phone,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    this.isDefault = false,
  });

  factory ShopAddress.fromJson(Map<String, dynamic> json) {
    return ShopAddress(
      id: json['id'] as int,
      name: json['name'] as String? ?? json['contact_name'] as String? ?? '',
      phone: json['phone'] as String? ?? json['contact_phone'] as String? ?? '',
      addressLine1: json['address_line1'] as String? ?? json['address'] as String? ?? '',
      addressLine2: json['address_line2'] as String?,
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      pincode: json['pincode'] as String? ?? json['pin'] as String? ?? '',
      isDefault: json['is_default'] == 1 || json['is_default'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contact_name': name,
      'phone': phone,
      'contact_phone': phone,
      'address_line1': addressLine1,
      'address': addressLine1,
      if (addressLine2 != null && addressLine2!.isNotEmpty) 'address_line2': addressLine2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'pin': pincode,
      'is_default': isDefault ? 1 : 0,
    };
  }
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

class CartItem {
  final int id;
  final int productId;
  final int qty;
  final String productName;
  final String? brand;
  final double sellingPrice;
  final int stockQty;
  final String? unit;
  final String? primaryImage;
  final double patientPrice;
  final double lineTotal;

  CartItem({
    required this.id,
    required this.productId,
    required this.qty,
    required this.productName,
    this.brand,
    required this.sellingPrice,
    required this.stockQty,
    this.unit,
    this.primaryImage,
    required this.patientPrice,
    required this.lineTotal,
  });

  CartItem copyWith({
    int? id,
    int? productId,
    int? qty,
    String? productName,
    String? brand,
    double? sellingPrice,
    int? stockQty,
    String? unit,
    String? primaryImage,
    double? patientPrice,
    double? lineTotal,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      qty: qty ?? this.qty,
      productName: productName ?? this.productName,
      brand: brand ?? this.brand,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      stockQty: stockQty ?? this.stockQty,
      unit: unit ?? this.unit,
      primaryImage: primaryImage ?? this.primaryImage,
      patientPrice: patientPrice ?? this.patientPrice,
      lineTotal: lineTotal ?? this.lineTotal,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      qty: json['qty'] as int,
      productName: json['product_name'] as String? ?? json['name'] as String? ?? 'Unknown',
      brand: json['brand'] as String?,
      sellingPrice: double.tryParse(json['selling_price']?.toString() ?? '') ?? 0.0,
      stockQty: int.tryParse(json['stock_qty']?.toString() ?? '') ?? 100,
      unit: json['unit'] as String?,
      primaryImage: json['primary_image'] as String?,
      patientPrice: double.tryParse(json['patient_price']?.toString() ?? json['unit_price']?.toString() ?? '') ?? 0.0,
      lineTotal: double.tryParse(json['line_total']?.toString() ?? '') ?? 0.0,
    );
  }
}

class ShopOrder {
  final int id;
  final String orderNo;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final double total;
  final DateTime placedAt;
  final int itemCount;
  final String? trackingNo;
  final String? courierName;
  final String? shippingName;
  final String? shippingPhone;
  final String? shippingAddr;
  final String? shippingLine2;
  final String? shippingCity;
  final String? shippingState;
  final String? shippingPin;

  ShopOrder({
    required this.id,
    required this.orderNo,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.total,
    required this.placedAt,
    required this.itemCount,
    this.trackingNo,
    this.courierName,
    this.shippingName,
    this.shippingPhone,
    this.shippingAddr,
    this.shippingLine2,
    this.shippingCity,
    this.shippingState,
    this.shippingPin,
  });

  factory ShopOrder.fromJson(Map<String, dynamic> json) {
    return ShopOrder(
      id: json['id'] as int,
      orderNo: json['order_no'] as String,
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String,
      paymentMethod: json['payment_method'] as String,
      total: double.tryParse(json['total']?.toString() ?? '') ?? 0.0,
      placedAt: DateTime.parse(json['placed_at'] as String),
      itemCount: int.tryParse(json['item_count']?.toString() ?? '') ?? 0,
      trackingNo: json['tracking_no'] as String?,
      courierName: json['courier_name'] as String?,
      shippingName: json['shipping_name'] as String? ?? json['contact_name'] as String?,
      shippingPhone: json['shipping_phone'] as String? ?? json['contact_phone'] as String?,
      shippingAddr: json['shipping_addr'] as String? ?? json['address_line1'] as String?,
      shippingLine2: json['shipping_line2'] as String? ?? json['address_line2'] as String?,
      shippingCity: json['shipping_city'] as String? ?? json['city'] as String?,
      shippingState: json['shipping_state'] as String? ?? json['state'] as String?,
      shippingPin: json['shipping_pin'] as String? ?? json['pincode'] as String?,
    );
  }
}

class ShopOrderItem {
  final int id;
  final int productId;
  final String productName;
  final int qty;
  final double unitPrice;
  final double lineTotal;
  final String shopName;
  final String? productImage;

  ShopOrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.qty,
    required this.unitPrice,
    required this.lineTotal,
    required this.shopName,
    this.productImage,
  });

  factory ShopOrderItem.fromJson(Map<String, dynamic> json) {
    return ShopOrderItem(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      productName: json['product_name'] as String? ?? 'Unknown',
      qty: json['qty'] as int,
      unitPrice: double.tryParse(json['unit_price']?.toString() ?? '') ?? 0.0,
      lineTotal: double.tryParse(json['line_total']?.toString() ?? '') ?? 0.0,
      shopName: json['shop_name'] as String? ?? 'Unknown Seller',
      productImage: json['product_image'] as String?,
    );
  }
}

class ShopOrderEvent {
  final String status;
  final String? note;
  final DateTime createdAt;

  ShopOrderEvent({
    required this.status,
    this.note,
    required this.createdAt,
  });

  factory ShopOrderEvent.fromJson(Map<String, dynamic> json) {
    return ShopOrderEvent(
      status: json['status'] as String,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class ShopOrderDetail {
  final ShopOrder order;
  final List<ShopOrderItem> items;
  final List<ShopOrderEvent> events;

  ShopOrderDetail({
    required this.order,
    required this.items,
    required this.events,
  });

  factory ShopOrderDetail.fromJson(Map<String, dynamic> json) {
    final orderJson = json['order'] as Map<String, dynamic>;
    return ShopOrderDetail(
      order: ShopOrder.fromJson({...orderJson, 'item_count': (json['items'] as List).length}),
      items: (json['items'] as List).map((e) => ShopOrderItem.fromJson(e)).toList(),
      events: (json['events'] as List).map((e) => ShopOrderEvent.fromJson(e)).toList(),
    );
  }
}

