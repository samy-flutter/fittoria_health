import '../../data/models/shop_models.dart';

abstract class ShopState {}

class ShopInitial extends ShopState {}

class ShopLoading extends ShopState {}

class ShopLoaded extends ShopState {
  final ShopData data;
  final String searchQuery;
  final String categoryId;
  final String tab; // 'all', 'recommended', 'picks'
  final int? addingProductId;
  final Set<int> addedProductIds;

  ShopLoaded({
    required this.data,
    this.searchQuery = '',
    this.categoryId = '',
    this.tab = 'all',
    this.addingProductId,
    this.addedProductIds = const {},
  });

  ShopLoaded copyWith({
    ShopData? data,
    String? searchQuery,
    String? categoryId,
    String? tab,
    int? addingProductId,
    Set<int>? addedProductIds,
    bool clearAdding = false,
  }) {
    return ShopLoaded(
      data: data ?? this.data,
      searchQuery: searchQuery ?? this.searchQuery,
      categoryId: categoryId ?? this.categoryId,
      tab: tab ?? this.tab,
      addingProductId: clearAdding ? null : (addingProductId ?? this.addingProductId),
      addedProductIds: addedProductIds ?? this.addedProductIds,
    );
  }
}

class ShopError extends ShopState {
  final String message;
  ShopError(this.message);
}
