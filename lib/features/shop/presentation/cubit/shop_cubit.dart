import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/shop_repository.dart';
import 'shop_state.dart';

class ShopCubit extends Cubit<ShopState> {
  final ShopRepository repository;

  ShopCubit(this.repository) : super(ShopInitial());

  Future<void> loadShop({String? query, String? categoryId, String? tab}) async {
    final currentState = state is ShopLoaded ? state as ShopLoaded : null;
    
    final currentQuery = query ?? currentState?.searchQuery ?? '';
    final currentCat = categoryId ?? currentState?.categoryId ?? '';
    final currentTab = tab ?? currentState?.tab ?? 'all';

    if (currentState == null) {
      emit(ShopLoading());
    }

    final result = await repository.getShopData(
      query: currentQuery,
      categoryId: currentCat,
      recommended: currentTab == 'recommended',
      picks: currentTab == 'picks',
    );

    result.fold(
      (failure) => emit(ShopError(failure.message)),
      (data) {
        emit(ShopLoaded(
          data: data,
          searchQuery: currentQuery,
          categoryId: currentCat,
          tab: currentTab,
          addedProductIds: currentState?.addedProductIds ?? {},
        ));
      },
    );
  }

  Future<void> addToCart(int productId) async {
    if (state is ShopLoaded) {
      final currentState = state as ShopLoaded;
      emit(currentState.copyWith(addingProductId: productId));

      final result = await repository.addToCart(productId, 1);
      
      result.fold(
        (failure) {
          emit(currentState.copyWith(clearAdding: true));
        },
        (_) async {
          final newAdded = Set<int>.from(currentState.addedProductIds)..add(productId);
          emit(currentState.copyWith(clearAdding: true, addedProductIds: newAdded));
          
          // Clear added state after 2 seconds
          await Future.delayed(const Duration(seconds: 2));
          if (!isClosed && state is ShopLoaded) {
            final latestState = state as ShopLoaded;
            final resetAdded = Set<int>.from(latestState.addedProductIds)..remove(productId);
            emit(latestState.copyWith(addedProductIds: resetAdded));
          }
        },
      );
    }
  }
}
