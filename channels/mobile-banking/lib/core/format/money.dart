/// 金额展示格式化（千分位 + 两位小数）。
abstract final class AbnkMoney {
  /// `10000.0` → `¥10,000.00`（不带符号则返回 `10,000.00`）。
  static String format(num value, {String symbol = '¥'}) {
    final fixed = value.abs().toStringAsFixed(2);
    final dot = fixed.indexOf('.');
    final intPart = dot == -1 ? fixed : fixed.substring(0, dot);
    final decPart = dot == -1 ? '.00' : fixed.substring(dot);
    final grouped = _group(intPart);
    final sign = value.isNegative ? '-' : '';
    return '$sign$symbol$grouped$decPart';
  }

  static String _group(String digits) {
    final sb = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final posFromRight = digits.length - i;
      sb.write(digits[i]);
      if (posFromRight > 1 && posFromRight % 3 == 1) {
        sb.write(',');
      }
    }
    return sb.toString();
  }
}
