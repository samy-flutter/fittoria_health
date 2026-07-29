import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../cubit/nutrition_cubit.dart';
import '../../data/models/fit_models.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();

  String _selectedMeal = 'breakfast';
  final String todayStr = DateTime.now().toIso8601String().substring(0, 10);

  final List<Map<String, String>> _meals = [
    {'key': 'breakfast', 'label': 'Breakfast', 'emoji': '??'},
    {'key': 'lunch', 'label': 'Lunch', 'emoji': '??'},
    {'key': 'dinner', 'label': 'Dinner', 'emoji': '???'},
    {'key': 'snack', 'label': 'Snack', 'emoji': '??'},
  ];

  @override
  void initState() {
    super.initState();
    context.read<NutritionCubit>().load(todayStr);
  }

  @override
  void dispose() {
    _foodNameController.dispose();
    _quantityController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  void _saveLog() {
    if (_foodNameController.text.isEmpty) return;
    
    context.read<NutritionCubit>().logFood(
      todayStr,
      _selectedMeal,
      _foodNameController.text,
      _quantityController.text,
      int.tryParse(_caloriesController.text) ?? 0,
      int.tryParse(_proteinController.text) ?? 0,
      int.tryParse(_carbsController.text) ?? 0,
      int.tryParse(_fatController.text) ?? 0,
    );
    
    _foodNameController.clear();
    _quantityController.clear();
    _caloriesController.clear();
    _proteinController.clear();
    _carbsController.clear();
    _fatController.clear();
    
    Navigator.pop(context);
    UIHelpers.showSuccessSnackBar(context, 'Food logged successfully!');
  }

  void _showAddFoodModal(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 16),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
                  ),
                  Text('Add Food', style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Meal', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                          const SizedBox(height: 8),
                          Row(
                            children: _meals.map((m) {
                              final isSelected = _selectedMeal == m['key'];
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () => setModalState(() => _selectedMeal = m['key']!),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFF22C55E).withValues(alpha: 0.1) : (isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: isSelected ? const Color(0xFF22C55E) : (isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(m['emoji']!, style: const TextStyle(fontSize: 20)),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                          _buildInputCol('Food Name', '', _foodNameController, isDark, TextInputType.text),
                          const SizedBox(height: 16),
                          _buildInputCol('Quantity', '', _quantityController, isDark, TextInputType.text),
                          const SizedBox(height: 16),
                          _buildInputCol('Calories', 'kcal', _caloriesController, isDark, TextInputType.number),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _buildInputCol('Protein', 'g', _proteinController, isDark, TextInputType.number)),
                              const SizedBox(width: 8),
                              Expanded(child: _buildInputCol('Carbs', 'g', _carbsController, isDark, TextInputType.number)),
                              const SizedBox(width: 8),
                              Expanded(child: _buildInputCol('Fat', 'g', _fatController, isDark, TextInputType.number)),
                            ],
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF22C55E),
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
                        ),
                        onPressed: () {
                          _saveLog();
                        },
                        child: Text('Save', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInputCol(String label, String suffix, TextEditingController controller, bool isDark, TextInputType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: type,
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.zero, isDense: true),
                ),
              ),
              if (suffix.isNotEmpty) Text(suffix, style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const accentColor = Color(0xFF22C55E);

    return Scaffold(
      appBar: CustomAppBar(title: const Text('Nutrition')),
      body: BlocBuilder<NutritionCubit, NutritionState>(
        builder: (context, state) {
          if (state is NutritionLoading) {
            return const Center(child: CircularProgressIndicator(color: accentColor));
          } else if (state is NutritionError) {
            return Center(child: Text(state.message));
          } else if (state is NutritionLoaded) {
            final data = state.data;
            return RefreshIndicator(
              color: accentColor,
              onRefresh: () => context.read<NutritionCubit>().load(todayStr, silently: true),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderRow(isDark, accentColor),
                    const SizedBox(height: 32),
                    _buildMacrosCard(isDark, accentColor, data.totals),
                    const SizedBox(height: 24),
                    _buildAddButton(isDark, accentColor),
                    const SizedBox(height: 32),
                    ..._buildMealSections(isDark, data.entries),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeaderRow(bool isDark, Color accentColor) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.1),
            borderRadius: AppRadius.borderLg,
          ),
          alignment: Alignment.center,
          child: Icon(LucideIcons.apple, color: accentColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nutrition', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
              Text('Food & macro tracking', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMacrosCard(bool isDark, Color accentColor, NutritionTotals totals) {
    // We assume 2000 kcal max, and standard macro maxes for visualization
    double progress = (totals.kcal / 2000.0).clamp(0.0, 1.0);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            height: 92,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(value: 1.0, strokeWidth: 8, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                CircularProgressIndicator(value: progress, strokeWidth: 8, color: accentColor, strokeCap: StrokeCap.round),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${totals.kcal.toInt()}', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('kcal', style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              children: [
                _buildMacroBar(isDark, 'Protein', totals.proteinG.toDouble(), 120, const Color(0xFFEF4444)),
                const SizedBox(height: 8),
                _buildMacroBar(isDark, 'Carbs', totals.carbsG.toDouble(), 250, const Color(0xFFF59E0B)),
                const SizedBox(height: 8),
                _buildMacroBar(isDark, 'Fat', totals.fatG.toDouble(), 65, const Color(0xFF8B5CF6)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroBar(bool isDark, String label, double value, double maxVal, Color color) {
    double progress = (value / maxVal).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold)),
            Text('${value.toInt()}g', style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            backgroundColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(bool isDark, Color accentColor) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
          elevation: 0,
        ),
        onPressed: () => _showAddFoodModal(context, isDark),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.plus, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text('Add Food', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMealSections(bool isDark, List<NutritionEntry> entries) {
    final List<Widget> sections = [];
    
    for (var m in _meals) {
      final mealKey = m['key']!;
      final mealItems = entries.where((e) => e.mealType == mealKey).toList();
      
      if (mealItems.isEmpty) continue;

      int totalKcal = mealItems.fold(0, (sum, e) => sum + e.caloriesKcal);

      sections.add(
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
            borderRadius: AppRadius.borderXl,
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Text(m['emoji']!, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Text(m['label']!, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
                    const Spacer(),
                    Text('${totalKcal.toInt()} kcal', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                  ],
                ),
              ),
              const Divider(height: 1),
              ...mealItems.map((e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.foodName, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                          Text('${e.caloriesKcal.toInt()} kcal • P${e.proteinG.toInt()} C${e.carbsG.toInt()} F${e.fatG.toInt()}', style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      );
    }
    
    if (sections.isEmpty) {
      return [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text("No food logged today.", style: GoogleFonts.inter(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          )
        )
      ];
    }
    
    return sections;
  }
}
