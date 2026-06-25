import 'package:flutter/material.dart';
import 'package:fumo/core/theme/chat_theme_local_storage.dart';
import 'package:fumo/domain/entities/chat_theme_entity.dart';
import 'package:fumo/extensions/context_extensions.dart';

class ChatThemeEditorSheet extends StatefulWidget {
  const ChatThemeEditorSheet({
    super.key,
    required this.currentTheme,
    required this.chatRoomId,
    required this.onThemeApplied,
  });

  final ChatThemeEntity currentTheme;
  final String chatRoomId;
  final ValueChanged<ChatThemeEntity> onThemeApplied;

  @override
  State<ChatThemeEditorSheet> createState() => _ChatThemeEditorSheetState();
}

class _ChatThemeEditorSheetState extends State<ChatThemeEditorSheet> {
  late ChatThemeEntity _editedTheme;

  @override
  void initState() {
    super.initState();
    _editedTheme = widget.currentTheme;
  }

  void _pickColor({
    required String label,
    required Color currentColor,
    required ValueChanged<Color> onColorPicked,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(label),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _colorPreset(const Color(0xFFFFFFFF), currentColor, onColorPicked),
                  _colorPreset(const Color(0xFF000000), currentColor, onColorPicked),
                  _colorPreset(const Color(0xFF87A3A1), currentColor, onColorPicked),
                  _colorPreset(const Color(0xFF293635), currentColor, onColorPicked),
                  _colorPreset(const Color(0xFFEEEDED), currentColor, onColorPicked),
                  _colorPreset(const Color(0xFF969595), currentColor, onColorPicked),
                  _colorPreset(const Color(0xFF4CAF50), currentColor, onColorPicked),
                  _colorPreset(const Color(0xFF2196F3), currentColor, onColorPicked),
                  _colorPreset(const Color(0xFFFF5722), currentColor, onColorPicked),
                  _colorPreset(const Color(0xFF9C27B0), currentColor, onColorPicked),
                  _colorPreset(const Color(0xFFFFEB3B), currentColor, onColorPicked),
                  _colorPreset(const Color(0xFFE91E63), currentColor, onColorPicked),
                  _colorPreset(const Color(0xFF00BCD4), currentColor, onColorPicked),
                  _colorPreset(const Color(0xFF795548), currentColor, onColorPicked),
                  _colorPreset(const Color(0xFF607D8B), currentColor, onColorPicked),
                  _colorPreset(const Color(0xFFCDDC39), currentColor, onColorPicked),
                ],
              ),
              const SizedBox(height: 16),
              Text(context.localizations.customRgb, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              _ColorSlider(
                label: 'R',
                value: currentColor.red.toDouble(),
                max: 255,
                color: Colors.red,
                onChanged: (v) {
                  final newColor = Color.fromARGB(
                    currentColor.alpha,
                    v.round(),
                    currentColor.green,
                    currentColor.blue,
                  );
                  onColorPicked(newColor);
                },
              ),
              _ColorSlider(
                label: 'G',
                value: currentColor.green.toDouble(),
                max: 255,
                color: Colors.green,
                onChanged: (v) {
                  final newColor = Color.fromARGB(
                    currentColor.alpha,
                    currentColor.red,
                    v.round(),
                    currentColor.blue,
                  );
                  onColorPicked(newColor);
                },
              ),
              _ColorSlider(
                label: 'B',
                value: currentColor.blue.toDouble(),
                max: 255,
                color: Colors.blue,
                onChanged: (v) {
                  final newColor = Color.fromARGB(
                    currentColor.alpha,
                    currentColor.red,
                    currentColor.green,
                    v.round(),
                  );
                  onColorPicked(newColor);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.localizations.done),
          ),
        ],
      ),
    );
  }

  Widget _colorPreset(Color color, Color current, ValueChanged<Color> onPicked) {
    final isSelected = color.toARGB32() == current.toARGB32();
    return GestureDetector(
      onTap: () {
        onPicked(color);
        Navigator.pop(context);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.grey.shade400,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.white.withValues(alpha: 0.5), blurRadius: 8)]
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                context.localizations.customizeChatTheme,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              _ThemePreview(theme: _editedTheme),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: context.localizations.themeName,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  controller: TextEditingController(text: _editedTheme.themeName),
                  onChanged: (v) {
                    setState(() {
                      _editedTheme = _editedTheme.copyWith(themeName: v.isEmpty ? context.localizations.custom : v);
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _ColorOption(
                      label: context.localizations.backgroundColor,
                      color: _editedTheme.backgroundColor,
                      onTap: () => _pickColor(
                        label: context.localizations.backgroundColor,
                        currentColor: _editedTheme.backgroundColor,
                        onColorPicked: (c) => setState(() => _editedTheme = _editedTheme.copyWith(backgroundColor: c)),
                      ),
                    ),
                    _ColorOption(
                      label: context.localizations.yourBubbleColor,
                      color: _editedTheme.ownBubbleColor,
                      onTap: () => _pickColor(
                        label: context.localizations.yourBubbleColor,
                        currentColor: _editedTheme.ownBubbleColor,
                        onColorPicked: (c) => setState(() => _editedTheme = _editedTheme.copyWith(ownBubbleColor: c)),
                      ),
                    ),
                    _ColorOption(
                      label: context.localizations.othersBubbleColor,
                      color: _editedTheme.otherBubbleColor,
                      onTap: () => _pickColor(
                        label: context.localizations.othersBubbleColor,
                        currentColor: _editedTheme.otherBubbleColor,
                        onColorPicked: (c) => setState(() => _editedTheme = _editedTheme.copyWith(otherBubbleColor: c)),
                      ),
                    ),
                    _ColorOption(
                      label: context.localizations.yourTextColor,
                      color: _editedTheme.ownTextColor,
                      onTap: () => _pickColor(
                        label: context.localizations.yourTextColor,
                        currentColor: _editedTheme.ownTextColor,
                        onColorPicked: (c) => setState(() => _editedTheme = _editedTheme.copyWith(ownTextColor: c)),
                      ),
                    ),
                    _ColorOption(
                      label: context.localizations.othersTextColor,
                      color: _editedTheme.otherTextColor,
                      onTap: () => _pickColor(
                        label: context.localizations.othersTextColor,
                        currentColor: _editedTheme.otherTextColor,
                        onColorPicked: (c) => setState(() => _editedTheme = _editedTheme.copyWith(otherTextColor: c)),
                      ),
                    ),
                    _ColorOption(
                      label: context.localizations.appBarColor,
                      color: _editedTheme.appBarColor,
                      onTap: () => _pickColor(
                        label: context.localizations.appBarColor,
                        currentColor: _editedTheme.appBarColor,
                        onColorPicked: (c) => setState(() => _editedTheme = _editedTheme.copyWith(appBarColor: c)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(context.localizations.fontStyle, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ...ChatThemeEntity.availableFonts.map((font) => _FontOption(
                          fontFamily: font,
                          isSelected: _editedTheme.fontFamily == font,
                          onTap: () => setState(() => _editedTheme = _editedTheme.copyWith(fontFamily: font)),
                        )),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(context.localizations.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          ChatThemeLocalStorage.saveThemeForChat(
                            chatRoomId: widget.chatRoomId,
                            theme: _editedTheme,
                          );
                          widget.onThemeApplied(_editedTheme);
                          Navigator.pop(context);
                        },
                        child: Text(context.localizations.applyTheme),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ColorOption extends StatelessWidget {
  const _ColorOption({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
        ),
        title: Text(label),
        trailing: const Icon(Icons.edit),
        onTap: onTap,
      ),
    );
  }
}

class _FontOption extends StatelessWidget {
  const _FontOption({
    required this.fontFamily,
    required this.isSelected,
    required this.onTap,
  });

  final String fontFamily;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2) : null,
      child: ListTile(
        title: Text(
          fontFamily == 'Shonen' ? context.localizations.shonenCustom : fontFamily,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
          ),
        ),
        trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
        onTap: onTap,
      ),
    );
  }
}

class _ColorSlider extends StatelessWidget {
  const _ColorSlider({
    required this.label,
    required this.value,
    required this.max,
    required this.color,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double max;
  final Color color;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: 0,
            max: max,
            divisions: 255,
            activeColor: color,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(value.round().toString(), style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}

class _ThemePreview extends StatelessWidget {
  const _ThemePreview({required this.theme});

  final ChatThemeEntity theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.otherBubbleColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                context.localizations.otherUser,
                style: TextStyle(
                  color: theme.otherTextColor,
                  fontFamily: theme.fontFamily,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.ownBubbleColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                context.localizations.you,
                style: TextStyle(
                  color: theme.ownTextColor,
                  fontFamily: theme.fontFamily,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}