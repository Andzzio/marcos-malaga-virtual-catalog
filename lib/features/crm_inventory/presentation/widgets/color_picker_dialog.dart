import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gap/gap.dart';

class ColorPickerDialog extends StatefulWidget {
  final int initialColorValue;
  final ValueChanged<int> onColorSelected;

  const ColorPickerDialog({
    super.key,
    required this.initialColorValue,
    required this.onColorSelected,
  });

  static Future<int?> show({
    required BuildContext context,
    required int initialColorValue,
  }) {
    return showDialog<int>(
      context: context,
      builder: (ctx) => ColorPickerDialog(
        initialColorValue: initialColorValue,
        onColorSelected: (color) => Navigator.of(ctx).pop(color),
      ),
    );
  }

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  static const List<Map<String, dynamic>> _quickColors = [
    {'name': 'Negro', 'value': 0xFF1B1B1B},
    {'name': 'Blanco', 'value': 0xFFFFFFFF},
    {'name': 'Marfil', 'value': 0xFFFDFBF7},
    {'name': 'Gris', 'value': 0xFF78909C},
    {'name': 'Rojo', 'value': 0xFFE53935},
    {'name': 'Vino', 'value': 0xFF880E4F},
    {'name': 'Palo Rosa', 'value': 0xFFD81B60},
    {'name': 'Rosa Pastel', 'value': 0xFFF8BBD0},
    {'name': 'Azul Marino', 'value': 0xFF1A237E},
    {'name': 'Azul Rey', 'value': 0xFF1565C0},
    {'name': 'Celeste', 'value': 0xFF81D4FA},
    {'name': 'Verde Militar', 'value': 0xFF558B2F},
    {'name': 'Esmeralda', 'value': 0xFF00897B},
    {'name': 'Mostaza', 'value': 0xFFFBC02D},
    {'name': 'Terracota', 'value': 0xFFD84315},
    {'name': 'Beige / Nude', 'value': 0xFFD7CCC8},
  ];

  late Color _currentColor;
  int _tabIndex = 0; // 0 = Selector visual, 1 = Colores frecuentes

  @override
  void initState() {
    super.initState();
    _currentColor = Color(widget.initialColorValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = _currentColor.computeLuminance() < 0.5;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      actionsPadding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      title: Row(
        children: [
          Icon(Icons.palette, size: 22, color: theme.colorScheme.primary),
          const Gap(10),
          const Expanded(
            child: Text(
              'Elegir Color de Muestra',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          // Live preview circle
          Tooltip(
            message: 'Color actual seleccionado',
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _currentColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.check,
                  size: 16,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 340,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Segmented toggle between Visual Picker and Preset Swatches
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(
                      value: 0,
                      icon: Icon(Icons.gradient, size: 16),
                      label: Text('Espectro visual', style: TextStyle(fontSize: 12)),
                    ),
                    ButtonSegment(
                      value: 1,
                      icon: Icon(Icons.grid_view, size: 16),
                      label: Text('Prendas populares', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                  selected: {_tabIndex},
                  onSelectionChanged: (newSelection) {
                    setState(() {
                      _tabIndex = newSelection.first;
                    });
                  },
                ),
              ),
              const Gap(14),

              if (_tabIndex == 0) ...[
                // 100% Visual color picker: chromatic box + rainbow hue slider
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ColorPicker(
                    pickerColor: _currentColor,
                    onColorChanged: (color) {
                      setState(() => _currentColor = color);
                    },
                    colorPickerWidth: 300,
                    pickerAreaHeightPercent: 0.7,
                    enableAlpha: false,
                    displayThumbColor: true,
                    portraitOnly: true,
                    paletteType: PaletteType.hsvWithHue,
                    labelTypes: const [], // No manual text inputs or HEX typing required!
                    pickerAreaBorderRadius: BorderRadius.circular(10),
                  ),
                ),
              ] else ...[
                // Popular garment colors grid
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _quickColors.map((c) {
                    final int val = c['value'] as int;
                    final String name = c['name'] as String;
                    final itemColor = Color(val);
                    final isSelected = _currentColor.toARGB32() == val;
                    final itemIsDark = itemColor.computeLuminance() < 0.5;

                    return Tooltip(
                      message: name,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _currentColor = itemColor;
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: itemColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : (itemColor == const Color(0xFFFFFFFF)
                                      ? Colors.grey.shade300
                                      : Colors.transparent),
                              width: isSelected ? 3 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: isSelected
                              ? Center(
                                  child: Icon(
                                    Icons.check,
                                    size: 20,
                                    color: itemIsDark ? Colors.white : Colors.black,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const Gap(8),
              ],
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.check, size: 16),
          onPressed: () => widget.onColorSelected(_currentColor.toARGB32()),
          label: const Text('Seleccionar'),
        ),
      ],
    );
  }
}
