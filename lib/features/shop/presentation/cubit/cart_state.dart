import 'package:equatable/equatable.dart';
import '../../data/models/shop_models.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double total;
  final bool isUpdating;
  final String? errorMessage;
  final int timestamp;

  CartLoaded({
    required this.items,
    required this.total,
    this.isUpdating = false,
    this.errorMessage,
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object?> get props => [items, total, isUpdating, errorMessage, timestamp];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

class CartCheckoutLoading extends CartState {}

class CartCheckoutSuccess extends CartState {
  final int orderId;
  final String orderNo;
  final double total;
  final String? paymentSessionId;
  final String? mode;

  const CartCheckoutSuccess({
    required this.orderId,
    required this.orderNo,
    required this.total,
    this.paymentSessionId,
    this.mode,
  });

  @override
  List<Object?> get props => [orderId, orderNo, total, paymentSessionId, mode];
}
