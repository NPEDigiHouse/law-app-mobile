extension Capitalize on String {
  String toCapitalize([String separator = ' ']) {
    return split(separator).map((e) {
      return '${e.substring(0, 1).toUpperCase()}${e.substring(1, e.length)}';
    }).join(separator);
  }
}

extension CamelCase on String {
  String toCamelCase([String separator = ' ']) {
    final upperWords = split(separator).map((e) {
      return '${e.substring(0, 1).toUpperCase()}${e.substring(1, e.length)}';
    }).toList();

    return [upperWords.first.toLowerCase(), ...upperWords.sublist(1)].join();
  }
}
