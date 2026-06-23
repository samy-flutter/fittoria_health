import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../injection_container.dart';
import '../../data/models/clinic.dart';
import '../cubit/clinics_cubit.dart';
import '../../../../core/widgets/custom_app_bar.dart';

const _clinicTypes = ['Polyclinic', 'Diagnostic', 'Clinic', 'Hospital'];

class ClinicsScreen extends StatelessWidget {
  const ClinicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ClinicsCubit>(
      create: (_) => sl<ClinicsCubit>()..loadClinics(),
      child: const _ClinicsBody(),
    );
  }
}

class _ClinicsBody extends StatefulWidget {
  const _ClinicsBody();

  @override
  State<_ClinicsBody> createState() => _ClinicsBodyState();
}

class _ClinicsBodyState extends State<_ClinicsBody> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: Icon(LucideIcons.chevronLeft,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Explore Clinics',
          style: AppTextStyles.h3.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // --- Search Bar ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBgSurface : Colors.white,
                      borderRadius: AppRadius.borderXl,
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => context.read<ClinicsCubit>().updateSearch(v),
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search clinic, specialty, city...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                        prefixIcon: Icon(LucideIcons.search, size: 18,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    // TODO: Request location permission and set lat/lng
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Location discovery coming soon')),
                    );
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBgSurface : Colors.white,
                      borderRadius: AppRadius.borderXl,
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                    child: Icon(LucideIcons.locateFixed, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, size: 18),
                  ),
                ),
              ],
            ),
          ),

          // --- Filter Chips ---
          SizedBox(
            height: 36,
            child: BlocBuilder<ClinicsCubit, ClinicsState>(
              buildWhen: (prev, curr) => curr is ClinicsLoaded || curr is ClinicsLoading,
              builder: (context, state) {
                final activeType = state is ClinicsLoaded ? state.activeTypeFilter : null;
                final filterOptions = ['All', ..._clinicTypes];
                
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filterOptions.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final type = filterOptions[index];
                    final typeVal = type == 'All' ? '' : type;
                    final isActive = activeType == typeVal || (activeType == null && type == 'All');
                    
                    return GestureDetector(
                      onTap: () => context.read<ClinicsCubit>().setTypeFilter(typeVal),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.lightTeal
                              : (isDark ? AppColors.darkBgSurface : Colors.white),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isActive
                                ? AppColors.lightTeal
                                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            type,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isActive
                                  ? Colors.white
                                  : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // --- Clinic List ---
          Expanded(
            child: BlocBuilder<ClinicsCubit, ClinicsState>(
              builder: (context, state) {
                if (state is ClinicsLoading) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 4,
                    itemBuilder: (_, _) => Container(
                      height: 140,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.withAlpha(25),
                        borderRadius: AppRadius.borderXl,
                      ),
                    ),
                  );
                } else if (state is ClinicsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.alertCircle, size: 40, color: AppColors.danger),
                        AppSpacing.heightMd,
                        Text(state.message, textAlign: TextAlign.center),
                        AppSpacing.heightMd,
                        ElevatedButton(
                          onPressed: () => context.read<ClinicsCubit>().loadClinics(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state is ClinicsLoaded) {
                  if (state.clinics.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.building2, size: 48,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                          AppSpacing.heightMd,
                          Text('No clinics found',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              )),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => context.read<ClinicsCubit>().loadClinics(),
                    color: AppColors.lightTeal,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: state.clinics.length,
                      itemBuilder: (_, i) => _ClinicCard(clinic: state.clinics[i], isDark: isDark),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ClinicCard extends StatelessWidget {
  final Clinic clinic;
  final bool isDark;

  const _ClinicCard({required this.clinic, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : Colors.white,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo placeholder
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.lightTeal, AppColors.lightCyan],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: AppRadius.borderXl,
                  ),
                  child: Center(
                    child: Text(
                      clinic.name.substring(0, 2).toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
                AppSpacing.widthMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clinic.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      if (clinic.clinicType != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          clinic.clinicType!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (index) => const Icon(LucideIcons.star, size: 12, color: AppColors.warning)),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '4.8',
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
            
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (clinic.address != null || clinic.city != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(LucideIcons.mapPin, size: 14, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          [clinic.address, clinic.city, clinic.state].where((s) => s != null && s.isNotEmpty).join(', '),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (clinic.phone != null && clinic.phone!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(LucideIcons.phone, size: 14, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                      const SizedBox(width: 6),
                      Text(
                        clinic.phone!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(LucideIcons.stethoscope, size: 14, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    const SizedBox(width: 6),
                    Text(
                      '${clinic.doctorCount ?? 0} doctors',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (clinic.consultationFee != null) ...[
                      Icon(LucideIcons.clock, size: 14, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                      const SizedBox(width: 6),
                      Text(
                        'From ₹${clinic.consultationFee!.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: GestureDetector(
              onTap: () {
                context.push('/patient/book?clinicId=${clinic.id}');
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.lightTeal,
                  borderRadius: AppRadius.borderLg,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Book Appointment',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    const Icon(LucideIcons.arrowRight, size: 14, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
