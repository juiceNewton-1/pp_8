class RateHelper {
  static String getFormattedRate(String value) {
    final dotPosition = value.indexOf('.');
    return value.substring(0, dotPosition + 3);
  }
}
