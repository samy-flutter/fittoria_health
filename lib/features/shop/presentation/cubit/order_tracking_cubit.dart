import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/shop_repository.dart';
import 'order_tracking_state.dart';

class OrderTrackingCubit extends Cubit<OrderTrackingState> {
  final ShopRepository repository;

  OrderTrackingCubit(this.repository) : super(OrderTrackingInitial());

  Future<void> loadOrderDetails(int orderId) async {
    emit(OrderTrackingLoading());
    final result = await repository.getOrderDetails(orderId);
    result.fold(
      (failure) => emit(OrderTrackingError(failure.message)),
      (data) => emit(OrderTrackingLoaded(data)),
    );
  }
}
