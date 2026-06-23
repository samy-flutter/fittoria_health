import '../../../../core/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../cubit/addresses_cubit.dart';
import '../cubit/addresses_state.dart';
import '../../data/models/shop_models.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pinController = TextEditingController();

  String _paymentMethod = 'cashfree';
  final CFPaymentGatewayService _cfPaymentGatewayService =
      CFPaymentGatewayService();

  ShopAddress? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _cfPaymentGatewayService.setCallback(verifyPayment, onError);
    context.read<AddressesCubit>().loadAddresses();
  }

  void _onAddressSelected(ShopAddress? address) {
    setState(() {
      _selectedAddress = address;
      if (address != null) {
        _nameController.text = address.name;
        _phoneController.text = address.phone;
        _addressController.text = '${address.addressLine1}${address.addressLine2 != null ? ', ${address.addressLine2}' : ''}';
        _cityController.text = address.city;
        _stateController.text = address.state;
        _pinController.text = address.pincode;
      }
    });
  }

  void verifyPayment(String orderId) {
    final cartCubit = context.read<CartCubit>();
    final state = cartCubit.state;
    if (state is CartCheckoutSuccess) {
      cartCubit.verifyCashfreePayment(
        state.orderId,
        state.orderNo,
        state.total,
      );
    }
  }

  void onError(CFErrorResponse error, String orderId) {
    UIHelpers.showErrorSnackBar(context, error.getMessage() ?? 'Payment Failed');
}

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _submitCheckout(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final shippingDetails = {
        'shipping_name': _nameController.text.trim(),
        'shipping_phone': _phoneController.text.trim(),
        'shipping_addr': _addressController.text.trim(),
        'shipping_city': _cityController.text.trim(),
        'shipping_state': _stateController.text.trim(),
        'shipping_pin': _pinController.text.trim(),
        'payment_method': _paymentMethod,
      };
      context.read<CartCubit>().checkout(shippingDetails);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Checkout',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartCheckoutSuccess) {
            if (state.paymentSessionId != null &&
                state.paymentSessionId!.isNotEmpty) {
              try {
                var session = CFSessionBuilder()
                    .setEnvironment(
                      state.mode == 'production'
                          ? CFEnvironment.PRODUCTION
                          : CFEnvironment.SANDBOX,
                    )
                    .setOrderId(state.orderNo)
                    .setPaymentSessionId(state.paymentSessionId!)
                    .build();
                var cfWebCheckoutPayment = CFWebCheckoutPaymentBuilder()
                    .setSession(session)
                    .build();
                _cfPaymentGatewayService.doPayment(cfWebCheckoutPayment);
              } on CFException catch (e) {
                UIHelpers.showErrorSnackBar(context, e.message);
              }
            } else {
              _showSuccessDialog(context, state.orderNo);
            }
          } else if (state is CartError) {
            UIHelpers.showErrorSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is CartCheckoutLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.fitOrange),
                  SizedBox(height: 16),
                  Text('Processing order...'),
                ],
              ),
            );
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Shipping Information',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<AddressesCubit, AddressesState>(
                  builder: (context, addrState) {
                    if (addrState is AddressesLoaded && addrState.addresses.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<ShopAddress>(
                            initialValue: _selectedAddress,
                            isExpanded: true,
                            hint: const Text('Select a saved address'),
                            items: [
                              const DropdownMenuItem<ShopAddress>(
                                value: null,
                                child: Text('Add New Address'),
                              ),
                              ...addrState.addresses.map((addr) {
                                return DropdownMenuItem(
                                  value: addr,
                                  child: Text('${addr.name} - ${addr.addressLine1}, ${addr.city}'),
                                );
                              }),
                            ],
                            onChanged: _onAddressSelected,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
                              border: OutlineInputBorder(
                                borderRadius: AppRadius.borderLg,
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: LucideIcons.user,
                  isDark: isDark,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: LucideIcons.phone,
                  keyboardType: TextInputType.phone,
                  isDark: isDark,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _addressController,
                  label: 'Address (House No, Building, Street)',
                  icon: LucideIcons.mapPin,
                  isDark: isDark,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _cityController,
                        label: 'City',
                        icon: LucideIcons.building,
                        isDark: isDark,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _stateController,
                        label: 'State',
                        icon: LucideIcons.map,
                        isDark: isDark,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _pinController,
                  label: 'Pincode',
                  icon: LucideIcons.hash,
                  keyboardType: TextInputType.number,
                  isDark: isDark,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 32),
                Text(
                  'Payment Method',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildPaymentOption(
                  title: 'Pay Online (Cashfree)',
                  icon: LucideIcons.creditCard,
                  value: 'cashfree',
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _buildPaymentOption(
                  title: 'Cash on Delivery',
                  icon: LucideIcons.banknote,
                  value: 'cod',
                  isDark: isDark,
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.fitOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.borderLg,
                      ),
                      ),
                    onPressed: () => _submitCheckout(context),
                    child: Text(
                      'Place Order',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.inter(
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        ),
        prefixIcon: Icon(
          icon,
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          size: 20,
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderLg,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderLg,
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderLg,
          borderSide: const BorderSide(color: AppColors.fitOrange),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required IconData icon,
    required String value,
    required bool isDark,
  }) {
    final isSelected = _paymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
          borderRadius: AppRadius.borderLg,
          border: Border.all(
            color: isSelected
                ? AppColors.fitOrange
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.fitOrange
                  : (isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(LucideIcons.checkCircle2, color: AppColors.fitOrange),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String orderNo) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.check,
                size: 48,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Order Placed Successfully!',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Order No: $orderNo',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.fitOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.borderLg,
                  ),
                ),
                onPressed: () {
                  context.pop(); // Close dialog
                  context.pop(); // Close checkout screen
                  context.pop(); // Close cart screen (return to shop)
                },
                child: Text(
                  'Continue Shopping',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
