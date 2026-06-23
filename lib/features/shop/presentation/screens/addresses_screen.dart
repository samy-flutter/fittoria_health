import '../../../../core/utils/ui_helpers.dart';
import 'package:fittoria_patient_app/features/shop/data/models/shop_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../routes/route_names.dart';
import '../cubit/addresses_cubit.dart';
import '../cubit/addresses_state.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AddressesCubit>().loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'My Addresses',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              LucideIcons.plus,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
            onPressed: () {
              context.push(RouteNames.patientShopAddressForm);
            },
          ),
        ],
      ),
      body: BlocConsumer<AddressesCubit, AddressesState>(
        listener: (context, state) {
          if (state is AddressesError) {
            UIHelpers.showErrorSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is AddressesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.fitOrange),
            );
          } else if (state is AddressesLoaded) {
            if (state.addresses.isEmpty) {
              return Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.mapPin,
                          size: 64,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No addresses found',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.fitOrange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.borderLg,
                            ),
                          ),
                          onPressed: () {
                            context.push(RouteNames.patientShopAddressForm);
                          },
                          child: const Text('Add New Address'),
                        ),
                      ],
                    ),
                  ),
                  if (state.isActionLoading)
                    const Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: LinearProgressIndicator(
                        color: AppColors.fitOrange,
                      ),
                    ),
                ],
              );
            }
            return Stack(
              children: [
                ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.addresses.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final address = state.addresses[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkBgSurface
                            : AppColors.lightBgSurface,
                        borderRadius: AppRadius.borderLg,
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  address.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                ),
                              ),
                              if (address.isDefault)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.fitOrange.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: AppRadius.borderSm,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        LucideIcons.checkCircle,
                                        size: 14,
                                        color: AppColors.fitOrange,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Default',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: AppColors.fitOrange,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            address.phone,
                            style: GoogleFonts.inter(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${address.addressLine1}${address.addressLine2 != null ? ', ${address.addressLine2}' : ''}',
                            style: GoogleFonts.inter(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${address.city}, ${address.state} - ${address.pincode}',
                            style: GoogleFonts.inter(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Divider(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (!address.isDefault)
                                TextButton.icon(
                                  onPressed: () {
                                    final updatedAddress = ShopAddress(
                                      id: address.id,
                                      name: address.name,
                                      phone: address.phone,
                                      addressLine1: address.addressLine1,
                                      addressLine2: address.addressLine2,
                                      city: address.city,
                                      state: address.state,
                                      pincode: address.pincode,
                                      isDefault: true,
                                    );
                                    context
                                        .read<AddressesCubit>()
                                        .updateAddress(updatedAddress);
                                  },
                                  icon: const Icon(
                                    LucideIcons.checkCircle,
                                    size: 16,
                                    color: AppColors.fitOrange,
                                  ),
                                  label: Text(
                                    'Set as Default',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.fitOrange,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                )
                              else
                                const SizedBox.shrink(),
                              Row(
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      context.push(
                                        RouteNames.patientShopAddressForm,
                                        extra: address,
                                      );
                                    },
                                    icon: Icon(
                                      LucideIcons.edit2,
                                      size: 16,
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.lightTextSecondary,
                                    ),
                                    label: Text(
                                      'Edit',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.lightTextSecondary,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      context
                                          .read<AddressesCubit>()
                                          .deleteAddress(address.id);
                                    },
                                    icon: const Icon(
                                      LucideIcons.trash2,
                                      size: 16,
                                      color: Colors.redAccent,
                                    ),
                                    label: Text(
                                      'Delete',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (state.isActionLoading)
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(color: AppColors.fitOrange),
                  ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
