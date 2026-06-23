import '../../data/models/shop_models.dart';

abstract class AddressesState {}

class AddressesInitial extends AddressesState {}

class AddressesLoading extends AddressesState {}

class AddressesLoaded extends AddressesState {
  final List<ShopAddress> addresses;
  final bool isActionLoading;
  
  AddressesLoaded(this.addresses, {this.isActionLoading = false});

  AddressesLoaded copyWith({
    List<ShopAddress>? addresses,
    bool? isActionLoading,
  }) {
    return AddressesLoaded(
      addresses ?? this.addresses,
      isActionLoading: isActionLoading ?? this.isActionLoading,
    );
  }
}

class AddressesError extends AddressesState {
  final String message;
  AddressesError(this.message);
}
