class AmFunctions {
  static String getShortName(String fullName) {
    if (fullName.trim().isEmpty) {
      return "";
    }
    var li = fullName.trim().split(" ");
    if (li.length > 1) {
      return li.first.substring(0, 1) + li.last.substring(0, 1);
    }
    return li.first.substring(0, 2);
  }
}
