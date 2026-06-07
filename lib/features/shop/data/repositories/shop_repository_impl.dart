import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/shop_repository.dart';
import '../models/shop_models.dart';

class ShopRepositoryImpl implements ShopRepository {
  final List<ShopProduct> _mockProducts = [
    ShopProduct(
      id: 1,
      name: 'Whey Protein Isolate - 2kg',
      brand: 'MuscleFit',
      mrp: 6999,
      patientPrice: 5599,
      categoryName: 'Supplements',
      sellerName: 'Fittoria Official',
      ratingAvg: 4.8,
      ratingCount: 124,
      isFittoriaPick: true,
      primaryImage: 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?auto=format&fit=crop&q=80&w=200',
    ),
    ShopProduct(
      id: 2,
      name: 'Pro Yoga Mat - 8mm',
      brand: 'ZenFit',
      mrp: 1499,
      patientPrice: 999,
      categoryName: 'Equipment',
      sellerName: 'Sports Hub',
      ratingAvg: 4.5,
      ratingCount: 85,
      isFittoriaPick: false,
      primaryImage: 'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?auto=format&fit=crop&q=80&w=200',
    ),
    ShopProduct(
      id: 3,
      name: 'BCAA Energy Drink - 30 Servings',
      brand: 'NutriBoost',
      mrp: 2499,
      patientPrice: 1899,
      categoryName: 'Supplements',
      sellerName: 'Health First',
      ratingAvg: 4.2,
      ratingCount: 42,
      isFittoriaPick: false,
      primaryImage: null,
    ),
    ShopProduct(
      id: 4,
      name: 'Resistance Band Set (5 Levels)',
      brand: 'FitGear',
      mrp: 1299,
      patientPrice: 799,
      categoryName: 'Equipment',
      sellerName: 'Fittoria Official',
      ratingAvg: 4.9,
      ratingCount: 210,
      isFittoriaPick: true,
      primaryImage: 'https://images.unsplash.com/photo-1598266663439-2056e6900339?auto=format&fit=crop&q=80&w=200',
    ),
  ];

  final List<ShopCategory> _mockCategories = [
    ShopCategory(id: 1, name: 'Supplements'),
    ShopCategory(id: 2, name: 'Equipment'),
    ShopCategory(id: 3, name: 'Apparel'),
  ];

  @override
  Future<Either<Failure, ShopData>> getShopData({
    String? query,
    String? categoryId,
    bool? recommended,
    bool? picks,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      
      List<ShopProduct> filtered = List.from(_mockProducts);
      
      if (query != null && query.isNotEmpty) {
        filtered = filtered.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
      }
      if (categoryId != null && categoryId.isNotEmpty) {
        final cat = _mockCategories.firstWhere((c) => c.id.toString() == categoryId, orElse: () => ShopCategory(id: 0, name: ''));
        if (cat.id != 0) {
          filtered = filtered.where((p) => p.categoryName == cat.name).toList();
        }
      }
      if (picks == true) {
        filtered = filtered.where((p) => p.isFittoriaPick).toList();
      }
      
      return Right(ShopData(
        products: filtered,
        categories: _mockCategories,
        goalTags: recommended == true ? ['muscle_gain', 'recovery'] : null,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(int productId, int qty) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
