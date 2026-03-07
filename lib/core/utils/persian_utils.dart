/// Persian/Dari utilities: digit conversion, Hijri Shamsi (Solar Hijri) calendar.
class PersianUtils {
  PersianUtils._();

  // ── Digit conversion ──────────────────────────────────────────────────────
  static const _faDigits = ['۰','۱','۲','۳','۴','۵','۶','۷','۸','۹'];

  /// Convert any ASCII digit string to Persian/Dari digits.
  static String toPersianDigits(String input) {
    return input.runes.map((r) {
      if (r >= 48 && r <= 57) return _faDigits[r - 48]; // 0-9
      return String.fromCharCode(r);
    }).join();
  }

  static String intToPersian(int n) => toPersianDigits(n.toString());
  static String doubleToPersian(double n, {int decimals = 0}) =>
      toPersianDigits(n.toStringAsFixed(decimals));

  /// Format price with thousands separator: e.g. 12500 → ۱۲٬۵۰۰
  static String formatPrice(double price) {
    final raw = price.toInt().toString();
    final buf = StringBuffer();
    for (int i = 0; i < raw.length; i++) {
      if (i > 0 && (raw.length - i) % 3 == 0) buf.write('٬');
      buf.write(raw[i]);
    }
    return toPersianDigits(buf.toString());
  }

  // ── Gregorian → Solar Hijri (Shamsi) conversion ───────────────────────────
  /// Returns [year, month, day] in Shamsi.
  static List<int> gregorianToShamsi(int gy, int gm, int gd) {
    final g_d_no = _gDayNo(gy, gm, gd);
    int j_d_no = g_d_no - _gDayNo(1600, 1, 1);
    int j_np = j_d_no ~/ 12053;
    j_d_no %= 12053;
    int jy = 979 + 33 * j_np + 4 * (j_d_no ~/ 1461);
    j_d_no %= 1461;
    if (j_d_no >= 366) {
      jy += (j_d_no - 1) ~/ 365;
      j_d_no = (j_d_no - 1) % 365;
    }
    int jm = 0, jd = 0;
    final months = [31,31,31,31,31,31,30,30,30,30,30,29];
    for (int i = 0; i < 12; i++) {
      if (j_d_no < months[i]) { jm = i + 1; jd = j_d_no + 1; break; }
      j_d_no -= months[i];
    }
    return [jy, jm, jd];
  }

  static int _gDayNo(int gy, int gm, int gd) {
    final g = [0,31,59,90,120,151,181,212,243,273,304,334];
    gy -= 1600;
    gm -= 1;
    gd -= 1;
    int gDayNo = 365 * gy + (gy + 3) ~/ 4 - (gy + 99) ~/ 100 + (gy + 399) ~/ 400;
    gDayNo += g[gm];
    if (gm > 1 && ((gy + 1600) % 4 == 0 && ((gy + 1600) % 100 != 0 || (gy + 1600) % 400 == 0))) {
      gDayNo++;
    }
    gDayNo += gd;
    return gDayNo;
  }

  // ── Shamsi month names ────────────────────────────────────────────────────
  static const monthNamesFa = [
    'حمل','ثور','جوزا','سرطان','اسد','سنبله',
    'میزان','عقرب','قوس','جدی','دلو','حوت',
  ];
  static const monthNamesPs = [
    'وری','غويی','غبرګولی','چنګاښ','زمری','وږی',
    'تله','لړم','ليندۍ','مرغومی','سلواغه','کب',
  ];

  static const weekDaysFa  = ['یکشنبه','دوشنبه','سه‌شنبه','چهارشنبه','پنجشنبه','جمعه','شنبه'];
  static const weekDaysPs  = ['یوه شنبه','دوه شنبه','درې شنبه','څلور شنبه','پنځه شنبه','جمعه','شنبه'];

  /// Format a DateTime as a full Shamsi date string.
  /// [lang] either 'fa' or 'ps'.
  static String formatDate(DateTime dt, String lang) {
    final s = gregorianToShamsi(dt.year, dt.month, dt.day);
    final monthNames = lang == 'fa' ? monthNamesFa : monthNamesPs;
    return '${intToPersian(s[2])} ${monthNames[s[1] - 1]} ${intToPersian(s[0])}';
  }

  /// Short format: ۱۴۰۴/۰۲/۱۵
  static String formatDateShort(DateTime dt) {
    final s = gregorianToShamsi(dt.year, dt.month, dt.day);
    final y = intToPersian(s[0]);
    final m = toPersianDigits(s[1].toString().padLeft(2, '0'));
    final d = toPersianDigits(s[2].toString().padLeft(2, '0'));
    return '$y/$m/$d';
  }

  /// Format time as HH:mm in Persian digits.
  static String formatTime(DateTime dt) {
    final h = toPersianDigits(dt.hour.toString().padLeft(2, '0'));
    final m = toPersianDigits(dt.minute.toString().padLeft(2, '0'));
    return '$h:$m';
  }

  /// Duration in hours and minutes, e.g. "۱۲ ساعت و ۳۰ دقیقه".
  static String formatDuration(Duration d, String lang) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    if (lang == 'ps') {
      if (h == 0) return '${intToPersian(m)} دقیقې';
      if (m == 0) return '${intToPersian(h)} ساعته';
      return '${intToPersian(h)} ساعته و ${intToPersian(m)} دقیقې';
    }
    if (h == 0) return '${intToPersian(m)} دقیقه';
    if (m == 0) return '${intToPersian(h)} ساعت';
    return '${intToPersian(h)} ساعت و ${intToPersian(m)} دقیقه';
  }

  // ── Shamsi calendar grid ──────────────────────────────────────────────────
  /// Get all [year, month, day] days in a Shamsi month for a grid (with nulls for empty cells).
  static List<int?> shamsiMonthDays(int jy, int jm) {
    final daysInMonth = (jm <= 6) ? 31 : (jm <= 11) ? 30 : _isLeapShamsi(jy) ? 30 : 29;
    // Find weekday of first day: convert jy/jm/1 to Gregorian, then get weekday
    final gDate = shamsiToGregorian(jy, jm, 1);
    final dt = DateTime(gDate[0], gDate[1], gDate[2]);
    // Afghan week starts Saturday(6) -> 0
    int startWd = (dt.weekday % 7); // Mon=1..Sun=7 → Sat=6→0, Sun=0→1, Mon=1→2...
    // Shift: DateTime.weekday: Mon=1,Tue=2,...Sat=6,Sun=7
    // We want Sat=0, Sun=1, Mon=2, Tue=3, Wed=4, Thu=5, Fri=6
    int offset = (dt.weekday + 1) % 7; // Sat=0,Sun=1...Fri=6
    final cells = <int?>[];
    for (int i = 0; i < offset; i++) cells.add(null);
    for (int d = 1; d <= daysInMonth; d++) cells.add(d);
    return cells;
  }

  static bool _isLeapShamsi(int jy) {
    const leapRemainders = [1,5,9,13,17,22,26,30];
    return leapRemainders.contains(jy % 33);
  }

  static int daysInShamsiMonth(int jy, int jm) {
    if (jm <= 6) return 31;
    if (jm <= 11) return 30;
    return _isLeapShamsi(jy) ? 30 : 29;
  }

  /// Shamsi → Gregorian
  static List<int> shamsiToGregorian(int jy, int jm, int jd) {
    jy += 1595;
    int days = -355779 + (365 + (_isLeapShamsi(jy) ? 1 : 0)) * (jy ~/ 33) * 8 +
        jy % 33 * 365;
    // simpler approach using known offset
    int j_d_no = (jy - 979) ~/ 33 * 12053;
    int rem = (jy - 979) % 33;
    j_d_no += rem * 365 + (rem ~/ 4) * 1 + (rem >= 5 ? 1 : 0);
    j_d_no += [0,31,62,93,124,155,186,216,246,276,306,336][jm - 1] + jd - 1;
    j_d_no += _gDayNo(1600, 1, 1);
    int gy = 400 * (j_d_no ~/ 146097);
    j_d_no %= 146097;
    if (j_d_no > 36524) {
      gy += 100 * (--j_d_no ~/ 36524);
      j_d_no %= 36524;
      if (j_d_no >= 365) j_d_no++;
    }
    gy += 4 * (j_d_no ~/ 1461);
    j_d_no %= 1461;
    if (j_d_no >= 366) { gy += (j_d_no - 1) ~/ 365; j_d_no = (j_d_no - 1) % 365; }
    final gMonths = [31,28,31,30,31,30,31,31,30,31,30,31];
    int gm = 0, gd = 0;
    bool isLeapG = (gy % 4 == 0 && gy % 100 != 0) || gy % 400 == 0;
    if (isLeapG) gMonths[1] = 29;
    for (int i = 0; i < 12; i++) {
      if (j_d_no < gMonths[i]) { gm = i + 1; gd = j_d_no + 1; break; }
      j_d_no -= gMonths[i];
    }
    return [gy, gm, gd];
  }

  static DateTime shamsiToDateTime(int jy, int jm, int jd) {
    final g = shamsiToGregorian(jy, jm, jd);
    return DateTime(g[0], g[1], g[2]);
  }

  static List<int> dateTimeToShamsi(DateTime dt) =>
      gregorianToShamsi(dt.year, dt.month, dt.day);
}
