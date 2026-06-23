import '../../../../core/error/exception_handler.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/shop_repository.dart';
import '../data_sources/shop_remote_data_source.dart';
import '../models/shop_models.dart';

class ShopRepositoryImpl implements ShopRepository {
  final ShopRemoteDataSource remoteDataSource;

  ShopRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ShopData>> getShopData({
    String? query,
    String? categoryId,
    bool? recommended,
    bool? picks,
  }) async {
    try {
      final data = await remoteDataSource.getShopData(
        query: query,
        categoryId: categoryId,
        recommended: recommended,
        picks: picks,
      );
      return Right(data);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(int productId, int qty) async {
    try {
      await remoteDataSource.addToCart(productId, qty);
      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCart() async {
    try {
      final data = await remoteDataSource.getCart();
      return Right(data);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateCartItemQty(int cartItemId, int qty) async {
    try {
      await remoteDataSource.updateCartItemQty(cartItemId, qty);
      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> removeCartItem(int cartItemId) async {
    try {
      await remoteDataSource.removeCartItem(cartItemId);
      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> checkout(Map<String, dynamic> shippingDetails) async {
    try {
      final res = await remoteDataSource.checkout(shippingDetails);
      return Right(res);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getOrders() async {
    try {
      final res = await remoteDataSource.getOrders();
      return Right(res);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, ShopOrderDetail>> getOrderDetails(int orderId) async {
    try {
      final res = await remoteDataSource.getOrderDetails(orderId);
      return Right(ShopOrderDetail.fromJson(res));
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> verifyCashfreePayment(int orderId) async {
    try {
      final res = await remoteDataSource.verifyCashfreePayment(orderId);
      return Right(res);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<ShopAddress>>> getAddresses() async {
    try {
      final res = await remoteDataSource.getAddresses();
      return Right(res);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> addAddress(ShopAddress address) async {
    try {
      await remoteDataSource.addAddress(address);
      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateAddress(ShopAddress address) async {
    try {
      await remoteDataSource.updateAddress(address);
      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress(int addressId) async {
    try {
      await remoteDataSource.deleteAddress(addressId);
      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }
}
