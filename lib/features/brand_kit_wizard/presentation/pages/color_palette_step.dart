import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/brand_kit_wizard_cubit.dart';
import '../cubit/brand_kit_wizard_state.dart';

class ColorPaletteStep extends StatefulWidget {
  const ColorPaletteStep({super.key});

  @override
  State<ColorPaletteStep> createState() => _ColorPaletteStepState();
}

class _ColorPaletteStepState extends State<ColorPaletteStep> {
  final _hexController = TextEditingController();
  String? _hexError;

  static const List<Map<String, dynamic>> _predefinedPalettes = [
    {'name': 'Modern Blue', 'colors': ['#2563EB', '#60A5FA', '#DBEAFE']},
    {'name': 'Elegant Black', 'colors': ['#1F2937', '#6B7280', '#F3F4F6']},
    {'name': 'Vibrant Red', 'colors': ['#DC2626', '#F87171', '#FEE2E2']},
    {'name': 'Nature Green', 'colors': ['#16A34A', '#86EFAC', '#DCFCE7']},
    {'name': 'Royal Purple', 'colors': ['#7C3AED', '#A78BFA', '#EDE9FE']},
    {'name': 'Warm Orange', 'colors': ['#EA580C', '#FB923C', '#FFEDD5']},
    {'name': 'Professional', 'colors': ['#0F172A', '#334155', '#94A3B8']},
    {'name': 'Playful', 'colors': ['#F59E0B', '#FCD34D', '#FEF3C7']},
  ];

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  bool _isValidHex(String hex) {
    final hexRegex = RegExp(r'^#[0-9A-Fa-f]{6}$');
    return hexRegex.hasMatch(hex);
  }

  void _addCustomColor(BuildContext context) {
    final hex = _hexController.text.trim();
    if (_isValidHex(hex)) {
      context.read<BrandKitWizardCubit>().addColor(hex.toUpperCase());
      _hexController.clear();
      setState(() {
        _hexError = null;
      });
    } else {
      setState(() {
        _hexError = 'Please enter a valid hex color (e.g., #FF5733)';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrandKitWizardCubit, BrandKitWizardState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose your brand colors',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select a predefined palette or add your own custom colors. These colors will be used throughout your brand materials.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Predefined Palettes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _predefinedPalettes.length,
                itemBuilder: (context, index) {
                  final palette = _predefinedPalettes[index];
                  final isSelected = _isPaletteSelected(state.colors, palette['colors'] as List<String>);
                  return GestureDetector(
                    onTap: () {
                      context.read<BrandKitWizardCubit>().setColors(palette['colors'] as List<String>);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: (palette['colors'] as List<String>)
                                .take(3)
                                .map((color) => Container(
                                      width: 24,
                                      height: 24,
                                      margin: const EdgeInsets.symmetric(horizontal: 2),
                                      decoration: BoxDecoration(
                                        color: Color(int.parse(color.replaceFirst('#', '0xFF'))),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 1),
                                      ),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            palette['name'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Add Custom Color',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _hexController,
                      decoration: InputDecoration(
                        hintText: '#FF5733',
                        labelText: 'Hex Color',
                        errorText: _hexError,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.colorize),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _addCustomColor(context),
                    child: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (state.colors.isNotEmpty) ...[
                const Text(
                  'Selected Colors',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: state.colors.map((color) {
                    return GestureDetector(
                      onTap: () {
                        context.read<BrandKitWizardCubit>().removeColor(color);
                      },
                      child: Container(
                        width: 80,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Color(int.parse(color.replaceFirst('#', '0xFF'))),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              color,
                              style: const TextStyle(fontSize: 10),
                            ),
                            const Icon(Icons.close, size: 12),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  bool _isPaletteSelected(List<String> selectedColors, List<String> paletteColors) {
    if (selectedColors.length != paletteColors.length) return false;
    for (var i = 0; i < selectedColors.length; i++) {
      if (selectedColors[i].toUpperCase() != paletteColors[i].toUpperCase()) {
        return false;
      }
    }
    return true;
  }
}
