import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/shop_repository.dart';
import '../../data/models/shop_models.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final ShopRepository repository;

  OrdersCubit(this.repository) : super(OrdersInitial());

  Future<void> loadOrders() async {
    emit(OrdersLoading());
    final result = await repository.getOrders();
    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (data) {
        final ordersList = data.map((e) => ShopOrder.fromJson(e)).toList();
        emit(OrdersLoaded(ordersList));
      },
    );
  }
}
