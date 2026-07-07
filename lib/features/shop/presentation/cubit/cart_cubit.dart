import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/shop_repository.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final ShopRepository repository;
  final Map<int, Timer> _updateTimers = {};

  CartCubit(this.repository) : super(CartInitial());

  Future<void> loadCart() async {
    if (state is CartLoaded) {
      final result = await repository.getCart();
      result.fold(
        (failure) => null, // ignore error
        (data) {
          emit(CartLoaded(
            items: data['items'],
            total: data['total'],
          ));
        },
      );
      return;
    }
    emit(CartLoading());
    final result = await repository.getCart();
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (data) {
        emit(CartLoaded(
          items: data['items'],
          total: data['total'],
        ));
      },
    );
  }

  Future<void> updateQty(int cartItemId, int qty) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      // Optimistic update
      final newItems = currentState.items.map((i) {
        if (i.id == cartItemId) {
          return i.copyWith(qty: qty, lineTotal: i.patientPrice * qty);
        }
        return i;
      }).toList();
      
      final newTotal = newItems.fold(0.0, (sum, item) => sum + item.lineTotal);

      emit(CartLoaded(items: newItems, total: newTotal));
      
      // Debounce API call by 500ms
      _updateTimers[cartItemId]?.cancel();
      _updateTimers[cartItemId] = Timer(const Duration(milliseconds: 500), () async {
        final result = await repository.updateCartItemQty(cartItemId, qty);
        result.fold(
          (failure) {
            // Revert state if we're still loaded
            final finalState = state;
            if (finalState is CartLoaded) {
              emit(CartLoaded(
                items: currentState.items, // revert to what it was BEFORE this optimistic update
                total: currentState.total,
                errorMessage: failure.message,
              ));
            }
          },
          (_) => _loadCartSilently(),
        );
      });
    }
  }

  Future<void> removeItem(int cartItemId) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      // Optimistic update
      final newItems = currentState.items.where((i) => i.id != cartItemId).toList();
      final newTotal = newItems.fold(0.0, (sum, item) => sum + item.lineTotal);

      emit(CartLoaded(items: newItems, total: newTotal));
      
      final result = await repository.removeCartItem(cartItemId);
      result.fold(
        (failure) {
          emit(CartLoaded(
            items: currentState.items,
            total: currentState.total,
            errorMessage: failure.message,
          ));
        },
        (_) => _loadCartSilently(),
      );
    }
  }

  Future<void> _loadCartSilently() async {
    final result = await repository.getCart();
    result.fold(
      (failure) => null, // Ignore background errors
      (data) {
        final currentState = state;
        // Only emit if we are still loaded and not showing an error
        if (currentState is CartLoaded) {
          emit(CartLoaded(
            items: data['items'],
            total: data['total'],
          ));
        }
      },
    );
  }

  Future<void> checkout(Map<String, dynamic> shippingDetails) async {
    emit(CartCheckoutLoading());
    final result = await repository.checkout(shippingDetails);
    result.fold(
      (failure) {
        emit(CartError(failure.message));
        loadCart(); // Reload cart on failure
      },
      (data) {
        // Success
        emit(CartCheckoutSuccess(
          orderId: data['orderId'] ?? 0,
          orderNo: data['orderNo'] ?? 'Unknown',
          total: (data['total'] as num).toDouble(),
          paymentSessionId: data['paymentSessionId'],
          mode: data['mode'],
        ));
      },
    );
  }

  Future<void> verifyCashfreePayment(int orderId, String orderNo, double total) async {
    emit(CartCheckoutLoading());
    final result = await repository.verifyCashfreePayment(orderId);
    result.fold(
      (failure) {
        emit(CartError(failure.message));
        loadCart();
      },
      (data) {
        emit(CartCheckoutSuccess(
          orderId: orderId,
          orderNo: orderNo,
          total: total,
        ));
      },
    );
  }
}
