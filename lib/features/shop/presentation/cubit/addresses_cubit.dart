import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/shop_repository.dart';
import '../../data/models/shop_models.dart';
import 'addresses_state.dart';

class AddressesCubit extends Cubit<AddressesState> {
  final ShopRepository repository;

  AddressesCubit(this.repository) : super(AddressesInitial());

  Future<void> loadAddresses() async {
    if (state is AddressesLoaded) {
      _silentLoadAddresses();
      return;
    }
    emit(AddressesLoading());
    final res = await repository.getAddresses();
    res.fold(
      (failure) => emit(AddressesError(failure.message)),
      (addresses) => emit(AddressesLoaded(addresses)),
    );
  }

  Future<void> addAddress(ShopAddress address) async {
    final currentState = state;
    if (currentState is AddressesLoaded) {
      emit(currentState.copyWith(isActionLoading: true));
    } else {
      emit(AddressesLoading());
    }
    final res = await repository.addAddress(address);
    res.fold(
      (failure) {
        emit(AddressesError(failure.message));
        if (currentState is AddressesLoaded) emit(currentState);
      },
      (_) => _silentLoadAddresses(),
    );
  }

  Future<void> updateAddress(ShopAddress address) async {
    final currentState = state;
    if (currentState is AddressesLoaded) {
      emit(currentState.copyWith(isActionLoading: true));
    } else {
      emit(AddressesLoading());
    }
    final res = await repository.updateAddress(address);
    res.fold(
      (failure) {
        emit(AddressesError(failure.message));
        if (currentState is AddressesLoaded) emit(currentState);
      },
      (_) => _silentLoadAddresses(),
    );
  }

  Future<void> deleteAddress(int addressId) async {
    final currentState = state;
    List<ShopAddress> previousAddresses = [];
    ShopAddress? deletedAddress;
    int deletedIndex = -1;

    if (currentState is AddressesLoaded) {
      previousAddresses = List.from(currentState.addresses);
      deletedIndex = previousAddresses.indexWhere((a) => a.id == addressId);
      if (deletedIndex != -1) {
        deletedAddress = previousAddresses[deletedIndex];
        final updatedAddresses = List<ShopAddress>.from(previousAddresses)..removeAt(deletedIndex);
        emit(AddressesLoaded(updatedAddresses, isActionLoading: false));
      }
    } else {
      emit(AddressesLoading());
    }

    final res = await repository.deleteAddress(addressId);
    res.fold(
      (failure) {
        emit(AddressesError(failure.message));
        // Revert optimistic deletion
        if (deletedAddress != null) {
          final revertedAddresses = List<ShopAddress>.from(previousAddresses);
          emit(AddressesLoaded(revertedAddresses, isActionLoading: false));
        } else if (currentState is AddressesLoaded) {
          emit(currentState);
        }
      },
      (_) {
        // We can still trigger a background load to ensure consistency
        // without showing a loader.
        _silentLoadAddresses();
      },
    );
  }

  Future<void> _silentLoadAddresses() async {
    final res = await repository.getAddresses();
    res.fold(
      (failure) => null, // Ignore failures on silent loads
      (addresses) {
        if (state is AddressesLoaded) {
          emit(AddressesLoaded(addresses, isActionLoading: false));
        }
      },
    );
  }
}
