import '../../data/models/shop_models.dart';

abstract class OrderTrackingState {}

class OrderTrackingInitial extends OrderTrackingState {}

class OrderTrackingLoading extends OrderTrackingState {}

class OrderTrackingLoaded extends OrderTrackingState {
  final ShopOrderDetail orderDetail;

  OrderTrackingLoaded(this.orderDetail);
}

class OrderTrackingError extends OrderTrackingState {
  final String message;

  OrderTrackingError(this.message);
}
