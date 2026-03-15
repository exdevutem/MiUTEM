import "package:flutter/services.dart";

/// Custom TextInputFormatter that blocks @ symbol input
/// to restrict users to only @utem.cl domain
class UtemEmailInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove any @ symbols from the new text
    final filteredText = newValue.text.replaceAll("@utem.cl", "").replaceAll("@", "");

    if (filteredText == newValue.text) {
      return newValue;
    }

    // Adjust cursor position if @ was removed
    final cursorOffset = newValue.text.length - filteredText.length;
    final newCursorPosition = (newValue.selection.baseOffset - cursorOffset)
        .clamp(0, filteredText.length);

    return TextEditingValue(
      text: filteredText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}

