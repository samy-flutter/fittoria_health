import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/records_cubit.dart';
import '../bloc/records_state.dart';
import '../../../profile_records/data/models/records.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Set<int> _expandedCaseSheetIds = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<RecordsCubit>().loadRecords();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleCaseSheet(int id) {
    setState(() {
      if (_expandedCaseSheetIds.contains(id)) {
        _expandedCaseSheetIds.remove(id);
      } else {
        _expandedCaseSheetIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Health Records', style: TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: isDark ? Colors.white : AppColors.lightTextPrimary,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.lightTeal,
          labelColor: isDark ? Colors.white : AppColors.lightTextPrimary,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Case Sheets'),
            Tab(text: 'History'),
            Tab(text: 'Summary'),
          ],
        ),
      ),
      body: BlocBuilder<RecordsCubit, RecordsState>(
        builder: (context, state) {
          if (state is RecordsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.lightTeal),
            );
          }

          if (state is RecordsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.danger),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load health records',
                      style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<RecordsCubit>().loadRecords(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppColors.darkTeal : AppColors.lightTeal,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is RecordsLoaded) {
            final records = state.records;

            // Auto-expand first case sheet if not expanded yet
            if (_expandedCaseSheetIds.isEmpty && records.caseSheets.isNotEmpty) {
              _expandedCaseSheetIds.add(records.caseSheets.first.id);
            }

            return TabBarView(
              controller: _tabController,
              children: [
                _buildCaseSheetsTab(records.caseSheets, isDark),
                _buildHistoryTab(records.medicalHistory, isDark),
                _buildSummaryTab(records.patient, isDark),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCaseSheetsTab(List<CaseSheet> caseSheets, bool isDark) {
    if (caseSheets.isEmpty) {
      return _buildEmptyState(
        Icons.assignment_ind_rounded,
        'No Case Sheets Yet',
        'Clinical notes from visits will appear here.',
        isDark,
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<RecordsCubit>().loadRecords(),
      color: AppColors.lightTeal,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: caseSheets.length,
        itemBuilder: (context, index) {
          final cs = caseSheets[index];
          final isExpanded = _expandedCaseSheetIds.contains(cs.id);
          return _buildCaseSheetCard(cs, isExpanded, isDark);
        },
      ),
    );
  }

  Widget _buildCaseSheetCard(CaseSheet cs, bool isExpanded, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderLg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Area
          InkWell(
            onTap: () => _toggleCaseSheet(cs.id),
            borderRadius: isExpanded
                ? const BorderRadius.vertical(top: Radius.circular(16))
                : AppRadius.borderLg,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.cTealBg,
                      border: Border.all(color: AppColors.cTealBorder),
                      borderRadius: AppRadius.borderLg,
                    ),
                    child: const Center(
                      child: Icon(Icons.medical_services_rounded, color: AppColors.lightTeal, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. ${cs.doctorName}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.business_rounded, size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                cs.clinicName,
                                style: const TextStyle(fontSize: 11.5, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.calendar_today_rounded, size: 11, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(cs.createdAt),
                              style: const TextStyle(fontSize: 11.5, color: Colors.grey),
                            ),
                          ],
                        ),
                        if (cs.diagnosis != null && cs.diagnosis!.trim().isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Dx: ${cs.diagnosis}',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Case Sheet Content
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vitals Grid
                  _buildVitalsGrid(cs, isDark),
                  const SizedBox(height: 16),

                  if (cs.chiefComplaint != null && cs.chiefComplaint!.isNotEmpty)
                    _buildDetailsSection('Chief Complaint', cs.chiefComplaint!, isDark),
                  if (cs.historyOfIllness != null && cs.historyOfIllness!.isNotEmpty)
                    _buildDetailsSection('History of Illness', cs.historyOfIllness!, isDark),
                  if (cs.generalExamination != null && cs.generalExamination!.isNotEmpty)
                    _buildDetailsSection('General Examination', cs.generalExamination!, isDark),
                  if (cs.systemicExamination != null && cs.systemicExamination!.isNotEmpty)
                    _buildDetailsSection('Systemic Examination', cs.systemicExamination!, isDark),
                  if (cs.diagnosis != null && cs.diagnosis!.isNotEmpty)
                    _buildDetailsSection('Diagnosis', cs.diagnosis!, isDark, accent: true),
                  if (cs.plan != null && cs.plan!.isNotEmpty)
                    _buildDetailsSection('Plan / Advice', cs.plan!, isDark),

                  if (cs.followUpDate != null && cs.followUpDate!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.cAmberBg,
                        border: Border.all(color: AppColors.cAmberBorder),
                        borderRadius: AppRadius.borderMd,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.warning),
                          const SizedBox(width: 8),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 11.5, color: AppColors.warning),
                              children: [
                                const TextSpan(text: 'Follow-up Date: '),
                                TextSpan(
                                  text: _formatDate(cs.followUpDate!),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVitalsGrid(CaseSheet cs, bool isDark) {
    final hasSystolic = cs.bpSystolic != null && cs.bpSystolic! > 0;
    final hasDiastolic = cs.bpDiastolic != null && cs.bpDiastolic! > 0;

    final vitals = <Widget>[
      if (hasSystolic && hasDiastolic)
        _buildVitalTile(
          Icons.monitor_heart_rounded,
          'BP',
          '${cs.bpSystolic}/${cs.bpDiastolic}',
          'mmHg',
          AppColors.cRedBg,
          AppColors.cRedBorder,
          AppColors.danger,
          isDark,
        ),
      if (cs.pulseBpm != null && cs.pulseBpm! > 0)
        _buildVitalTile(
          Icons.favorite_rounded,
          'Pulse',
          '${cs.pulseBpm}',
          'bpm',
          AppColors.cRedBg,
          AppColors.cRedBorder,
          AppColors.danger,
          isDark,
        ),
      if (cs.temperatureF != null && cs.temperatureF! > 0)
        _buildVitalTile(
          Icons.thermostat_rounded,
          'Temp',
          '${cs.temperatureF}',
          '°F',
          AppColors.cAmberBg,
          AppColors.cAmberBorder,
          AppColors.warning,
          isDark,
        ),
      if (cs.spo2Percent != null && cs.spo2Percent! > 0)
        _buildVitalTile(
          Icons.air_rounded,
          'SpO2',
          '${cs.spo2Percent}',
          '%',
          AppColors.cBlueBg,
          AppColors.cBlueBorder,
          AppColors.cBlue,
          isDark,
        ),
      if (cs.weightKg != null && cs.weightKg! > 0)
        _buildVitalTile(
          Icons.scale_rounded,
          'Weight',
          '${cs.weightKg}',
          'kg',
          AppColors.cTealBg,
          AppColors.cTealBorder,
          AppColors.lightTeal,
          isDark,
        ),
      if (cs.heightCm != null && cs.heightCm! > 0)
        _buildVitalTile(
          Icons.straighten_rounded,
          'Height',
          '${cs.heightCm}',
          'cm',
          AppColors.cGreyBg,
          AppColors.cGreyBorder,
          Colors.blueGrey,
          isDark,
        ),
      if (cs.bmi != null && cs.bmi! > 0)
        _buildVitalTile(
          Icons.speed_rounded,
          'BMI',
          cs.bmi!.toStringAsFixed(1),
          '',
          AppColors.cTealBg,
          AppColors.cTealBorder,
          AppColors.lightTeal,
          isDark,
        ),
    ];

    if (vitals.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'VITALS',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2.2,
          children: vitals,
        ),
      ],
    );
  }

  Widget _buildVitalTile(
    IconData icon,
    String label,
    String value,
    String unit,
    Color bg,
    Color border,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        borderRadius: AppRadius.borderMd,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: bg,
              border: Border.all(color: border),
              borderRadius: AppRadius.borderMd,
            ),
            child: Center(
              child: Icon(icon, color: color, size: 16),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                    children: [
                      TextSpan(text: value),
                      if (unit.isNotEmpty)
                        TextSpan(
                          text: ' $unit',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(String title, String value, bool isDark, {bool accent = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accent
                  ? AppColors.cTealBg
                  : (isDark ? AppColors.darkBgBase : AppColors.lightBgBase),
              border: Border.all(
                color: accent
                    ? AppColors.cTealBorder
                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              borderRadius: AppRadius.borderMd,
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.5,
                color: accent
                    ? AppColors.lightTeal
                    : (isDark ? Colors.white : AppColors.lightTextPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(List<MedicalHistoryItem> history, bool isDark) {
    if (history.isEmpty) {
      return _buildEmptyState(
        Icons.book_rounded,
        'No Medical History',
        'Past medical conditions will appear here.',
        isDark,
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<RecordsCubit>().loadRecords(),
      color: AppColors.lightTeal,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final h = history[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              borderRadius: AppRadius.borderLg,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.cRedBg,
                    border: Border.all(color: AppColors.cRedBorder),
                    borderRadius: AppRadius.borderMd,
                  ),
                  child: const Center(
                    child: Icon(Icons.book_rounded, color: AppColors.danger, size: 18),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        h.conditionName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      if (h.diagnosedAt != null && h.diagnosedAt!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Diagnosed: ${_formatDate(h.diagnosedAt!)}',
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                      if (h.notes != null && h.notes!.trim().isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          h.notes!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryTab(dynamic patient, bool isDark) {
    if (patient == null) {
      return _buildEmptyState(
        Icons.assignment_ind_rounded,
        'No Summary Data',
        'Health summary will appear when profile is complete.',
        isDark,
      );
    }

    final double? height = patient.heightCm != null ? (patient.heightCm is num ? (patient.heightCm as num).toDouble() : double.tryParse(patient.heightCm.toString())) : null;
    final double? weight = patient.weightKg != null ? (patient.weightKg is num ? (patient.weightKg as num).toDouble() : double.tryParse(patient.weightKg.toString())) : null;

    final String bloodGroup = patient.bloodGroupName ?? '—';
    final String heightStr = height != null ? '${height.toStringAsFixed(1)} cm' : '—';
    final String weightStr = weight != null ? '${weight.toStringAsFixed(1)} kg' : '—';

    return RefreshIndicator(
      onRefresh: () => context.read<RecordsCubit>().loadRecords(),
      color: AppColors.lightTeal,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // General Details
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              borderRadius: AppRadius.borderLg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'HEALTH SUMMARY',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryTile(
                        Icons.opacity_rounded,
                        'Blood Group',
                        bloodGroup,
                        AppColors.cRedBg,
                        AppColors.cRedBorder,
                        AppColors.danger,
                        isDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSummaryTile(
                        Icons.straighten_rounded,
                        'Height',
                        heightStr,
                        AppColors.cTealBg,
                        AppColors.cTealBorder,
                        AppColors.lightTeal,
                        isDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSummaryTile(
                        Icons.scale_rounded,
                        'Weight',
                        weightStr,
                        AppColors.cGreyBg,
                        AppColors.cGreyBorder,
                        Colors.blueGrey,
                        isDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Known Allergies
          if (patient.allergies != null && patient.allergies!.trim().isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cRedBg,
                border: Border.all(color: AppColors.cRedBorder),
                borderRadius: AppRadius.borderLg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Known Allergies',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    patient.allergies!,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Current Medications
          if (patient.currentMedications != null && patient.currentMedications!.trim().isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                borderRadius: AppRadius.borderLg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.medication_rounded, color: AppColors.lightTeal, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Current Medications',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    patient.currentMedications!,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryTile(
    IconData icon,
    String label,
    String value,
    Color bg,
    Color border,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        borderRadius: AppRadius.borderMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: bg,
              border: Border.all(color: border),
              borderRadius: AppRadius.borderMd,
            ),
            child: Center(
              child: Icon(icon, color: color, size: 14),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String desc, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: isDark ? Colors.white24 : Colors.black26),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return raw;
    }
  }
}
