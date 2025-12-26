extension StringExtension on String {
  /// Highlight search term in string
  String highlightSearchTerm(String? term) {
    if (term == null || term.isEmpty) return this;

    final lowerText = toLowerCase();
    final lowerTerm = term.toLowerCase();
    final index = lowerText.indexOf(lowerTerm);

    if (index == -1) return this;

    return substring(0, index) +
        '[' +
        substring(index, index + term.length) +
        ']' +
        substring(index + term.length);
  }

  /// Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Check if string is a valid email
  bool isValidEmail() {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(this);
  }
}
