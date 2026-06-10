import 'package:flutter/material.dart';

class ConjugationField extends StatefulWidget {
  const ConjugationField({super.key, required this.onSubmit, this.hintText});
  final void Function(String) onSubmit;
  final String? hintText;

  @override
  State<ConjugationField> createState() => _ConjugationFieldState();
}

class _ConjugationFieldState extends State<ConjugationField> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus so the keyboard opens immediately.
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text;
    if (text.trim().isNotEmpty) widget.onSubmit(text);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: _focus,
            onSubmitted: (_) => _submit(),
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: widget.hintText ?? 'Type the conjugated form…',
            ),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton(
          onPressed: _submit,
          child: const Text('Check'),
        ),
      ],
    );
  }
}
