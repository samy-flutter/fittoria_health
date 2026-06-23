import '../../../../core/utils/ui_helpers.dart';
import 'package:fittoria_patient_app/features/shop/presentation/cubit/addresses_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../data/data_sources/google_places_service.dart';
import '../../../../core/theme/app_colors.dart';

import '../../../../core/theme/app_radius.dart';
import '../../data/models/shop_models.dart';
import '../cubit/addresses_cubit.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class AddressFormScreen extends StatefulWidget {
  final ShopAddress? existingAddress;

  const AddressFormScreen({super.key, this.existingAddress});

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressLine1Controller;
  late final TextEditingController _addressLine2Controller;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _pincodeController;
  late final FocusNode _addressLine1FocusNode;
  bool _isDefault = false;
  bool _isSubmitting = false;
  late final Listenable _formListenable;
  final GooglePlacesService _placesService = GooglePlacesService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingAddress?.name);
    _phoneController = TextEditingController(
      text: widget.existingAddress?.phone,
    );
    _addressLine1Controller = TextEditingController(
      text: widget.existingAddress?.addressLine1,
    );
    _addressLine2Controller = TextEditingController(
      text: widget.existingAddress?.addressLine2,
    );
    _cityController = TextEditingController(text: widget.existingAddress?.city);
    _stateController = TextEditingController(
      text: widget.existingAddress?.state,
    );
    _pincodeController = TextEditingController(
      text: widget.existingAddress?.pincode,
    );
    _addressLine1FocusNode = FocusNode();
    _isDefault = widget.existingAddress?.isDefault ?? false;

    // Listen to changes to enable/disable submit button efficiently
    _formListenable = Listenable.merge([
      _nameController,
      _phoneController,
      _addressLine1Controller,
      _addressLine2Controller,
      _cityController,
      _stateController,
      _pincodeController,
    ]);
  }

  bool get _hasChanges {
    if (widget.existingAddress == null) return true;
    final e = widget.existingAddress!;
    return _nameController.text.trim() != e.name ||
           _phoneController.text.trim() != e.phone ||
           _addressLine1Controller.text.trim() != e.addressLine1 ||
           (_addressLine2Controller.text.trim().isNotEmpty ? _addressLine2Controller.text.trim() : null) != e.addressLine2 ||
           _cityController.text.trim() != e.city ||
           _stateController.text.trim() != e.state ||
           _pincodeController.text.trim() != e.pincode ||
           _isDefault != e.isDefault;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _addressLine1FocusNode.dispose();
    super.dispose();
  }

  void _saveAddress() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);
      final address = ShopAddress(
        id: widget.existingAddress?.id ?? 0,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        addressLine1: _addressLine1Controller.text.trim(),
        addressLine2: _addressLine2Controller.text.trim().isNotEmpty
            ? _addressLine2Controller.text.trim()
            : null,
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        pincode: _pincodeController.text.trim(),
        isDefault: _isDefault,
      );

      if (widget.existingAddress == null) {
        context.read<AddressesCubit>().addAddress(address);
      } else {
        context.read<AddressesCubit>().updateAddress(address);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          widget.existingAddress == null ? 'Add Address' : 'Edit Address',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
      ),
      body: BlocConsumer<AddressesCubit, AddressesState>(
        listener: (context, state) {
          if (_isSubmitting) {
            if (state is AddressesError) {
              setState(() => _isSubmitting = false);
              UIHelpers.showErrorSnackBar(context, state.message);
            } else if (state is AddressesLoaded && !state.isActionLoading) {
              setState(() => _isSubmitting = false);
              context.pop();
            }
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      icon: LucideIcons.user,
                      isDark: isDark,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      icon: LucideIcons.phone,
                      keyboardType: TextInputType.phone,
                      isDark: isDark,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildAddressAutocomplete(isDark),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _addressLine2Controller,
                      label: 'Address Line 2 (Street, Area)',
                      icon: LucideIcons.mapPin,
                      isDark: isDark,
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
                      controller: _pincodeController,
                      label: 'Pincode',
                      icon: LucideIcons.hash,
                      keyboardType: TextInputType.number,
                      isDark: isDark,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 24),
                    SwitchListTile(
                      title: Text(
                        'Set as Default Address',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      value: _isDefault,
                      onChanged: (value) => setState(() => _isDefault = value),
                      activeThumbColor: AppColors.fitOrange,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 32),
                    AnimatedBuilder(
                      animation: _formListenable,
                      builder: (context, child) {
                        return SizedBox(
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
                            onPressed: (_isSubmitting || !_hasChanges) ? null : _saveAddress,
                            child: Text(
                              widget.existingAddress == null
                                  ? 'Save Address'
                                  : 'Update Address',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              if (_isSubmitting)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.fitOrange,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    FocusNode? focusNode,
    required String label,
    required IconData icon,
    required bool isDark,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
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

  Widget _buildAddressAutocomplete(bool isDark) {
    return RawAutocomplete<Map<String, dynamic>>(
      textEditingController: _addressLine1Controller,
      focusNode: _addressLine1FocusNode,
      optionsBuilder: (TextEditingValue textEditingValue) async {
        final currentText = textEditingValue.text;
        if (currentText.isEmpty) {
          return const Iterable<Map<String, dynamic>>.empty();
        }
        await Future.delayed(const Duration(milliseconds: 500));
        if (currentText != _addressLine1Controller.text) {
          return const Iterable<Map<String, dynamic>>.empty();
        }
        return await _placesService.getSuggestions(currentText);
      },
      displayStringForOption: (option) => option['description'] ?? '',
      onSelected: (Map<String, dynamic> selection) async {
        final placeId = selection['place_id'];
        if (placeId != null) {
          setState(() => _isSubmitting = true);
          final details = await _placesService.getPlaceDetails(placeId);

          if (mounted) {
            setState(() {
              _isSubmitting = false;
              if (details != null) {
                _addressLine1Controller.text = details['addressLine1'] ?? '';
                _cityController.text = details['city'] ?? '';
                _stateController.text = details['state'] ?? '';
                _pincodeController.text = details['pincode'] ?? '';
              }
            });
          }
        }
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return _buildTextField(
          controller: controller,
          focusNode: focusNode,
          label: 'Address Line 1 (Search to Auto-fill)',
          icon: LucideIcons.mapPin,
          isDark: isDark,
          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 250, maxWidth: MediaQuery.of(context).size.width - 40),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    leading: Icon(LucideIcons.mapPin, size: 20, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    title: Text(
                      option['structured_formatting']?['main_text'] ?? option['description'] ?? '',
                      style: GoogleFonts.inter(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, fontSize: 14),
                    ),
                    subtitle: Text(
                      option['structured_formatting']?['secondary_text'] ?? '',
                      style: GoogleFonts.inter(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, fontSize: 12),
                    ),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
