import '../../../../core/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/custom_app_bar.dart';

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

  final List<Map<String, String>> _meals = [
    {'key': 'breakfast', 'label': 'Breakfast', 'emoji': '🍳'},
    {'key': 'lunch', 'label': 'Lunch', 'emoji': '🥗'},
    {'key': 'dinner', 'label': 'Dinner', 'emoji': '🍽️'},
    {'key': 'snack', 'label': 'Snack', 'emoji': '🍎'},
  ];

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
    Navigator.pop(context);
    UIHelpers.showSuccessSnackBar(context, 'Food logged successfully!');
}

  void _showAddFoodModal(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                          Navigator.pop(ctx);
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
      appBar: CustomAppBar(
        title: const Text('Nutrition'),
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: AppRadius.borderLg,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(LucideIcons.apple, color: accentColor),
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
            ),
            const SizedBox(height: 32),
            Container(
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
                        CircularProgressIndicator(value: 850 / 2000, strokeWidth: 8, color: accentColor, strokeCap: StrokeCap.round),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('850', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
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
                        _buildMacroBar(isDark, 'Protein', 45, 120, const Color(0xFFEF4444)),
                        const SizedBox(height: 8),
                        _buildMacroBar(isDark, 'Carbs', 110, 250, const Color(0xFFF59E0B)),
                        const SizedBox(height: 8),
                        _buildMacroBar(isDark, 'Fat', 25, 65, const Color(0xFF8B5CF6)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
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
            ),
            const SizedBox(height: 32),
            _buildMealSection(isDark, 'Breakfast', '🍳', 350, [
              {'name': 'Oatmeal with berries', 'details': '1 bowl · 250 kcal · P8 C40 F5'},
              {'name': 'Black Coffee', 'details': '1 cup · 100 kcal · P0 C0 F0'},
            ]),
            _buildMealSection(isDark, 'Lunch', '🥗', 500, [
              {'name': 'Grilled Chicken Salad', 'details': '1 bowl · 500 kcal · P40 C20 F20'},
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroBar(bool isDark, String label, double value, double maxVal, Color color) {
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
            value: value / maxVal,
            minHeight: 8,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildMealSection(bool isDark, String label, String emoji, int totalKcal, List<Map<String, String>> items) {
    return Container(
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
                Text(emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
                const Spacer(),
                Text('$totalKcal kcal', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
              ],
            ),
          ),
          const Divider(height: 1),
          ...items.map((e) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e['name']!, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                      Text(e['details']!, style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    ],
                  ),
                ),
                Icon(LucideIcons.trash2, size: 14, color: Colors.red.withValues(alpha: 0.5)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
