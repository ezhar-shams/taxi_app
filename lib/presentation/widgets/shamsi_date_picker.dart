import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/persian_utils.dart';

/// Bottom-sheet Shamsi (Solar Hijri) date picker.
/// Returns a [DateTime] (Gregorian) for the selected Shamsi date.
class ShamsiDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String lang; // 'fa' or 'ps'

  const ShamsiDatePicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.lang = 'fa',
  });

  /// Show the picker as a modal bottom sheet and return selected [DateTime] or null.
  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime initialDate,
    required String lang,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ShamsiDatePicker(
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime.now(),
        lastDate: lastDate ?? DateTime.now().add(const Duration(days: 120)),
        lang: lang,
      ),
    );
  }

  @override
  State<ShamsiDatePicker> createState() => _ShamsiDatePickerState();
}

class _ShamsiDatePickerState extends State<ShamsiDatePicker> {
  late int _jYear;
  late int _jMonth;
  late int _jDay;
  late int _minYear;
  late int _maxYear;
  late int _minMonth;
  late int _maxMonth;

  @override
  void initState() {
    super.initState();
    final s = PersianUtils.dateTimeToShamsi(widget.initialDate);
    _jYear = s[0]; _jMonth = s[1]; _jDay = s[2];
    final mn = PersianUtils.dateTimeToShamsi(widget.firstDate);
    final mx = PersianUtils.dateTimeToShamsi(widget.lastDate);
    _minYear = mn[0]; _minMonth = mn[1];
    _maxYear = mx[0]; _maxMonth = mx[1];
  }

  bool _canGoPrev() {
    if (_jYear < _minYear) return false;
    if (_jYear == _minYear && _jMonth <= _minMonth) return false;
    return true;
  }

  bool _canGoNext() {
    if (_jYear > _maxYear) return false;
    if (_jYear == _maxYear && _jMonth >= _maxMonth) return false;
    return true;
  }

  void _prevMonth() {
    if (!_canGoPrev()) return;
    setState(() {
      if (_jMonth == 1) { _jMonth = 12; _jYear--; }
      else { _jMonth--; }
      final days = PersianUtils.daysInShamsiMonth(_jYear, _jMonth);
      if (_jDay > days) _jDay = days;
    });
  }

  void _nextMonth() {
    if (!_canGoNext()) return;
    setState(() {
      if (_jMonth == 12) { _jMonth = 1; _jYear++; }
      else { _jMonth++; }
      final days = PersianUtils.daysInShamsiMonth(_jYear, _jMonth);
      if (_jDay > days) _jDay = days;
    });
  }

  bool _isDaySelectable(int day) {
    final minS = PersianUtils.dateTimeToShamsi(widget.firstDate);
    final maxS = PersianUtils.dateTimeToShamsi(widget.lastDate);
    final y = _jYear; final m = _jMonth;
    if (y < minS[0] || (y == minS[0] && m < minS[1]) ||
        (y == minS[0] && m == minS[1] && day < minS[2])) return false;
    if (y > maxS[0] || (y == maxS[0] && m > maxS[1]) ||
        (y == maxS[0] && m == maxS[1] && day > maxS[2])) return false;
    return true;
  }

  void _confirm() {
    final dt = PersianUtils.shamsiToDateTime(_jYear, _jMonth, _jDay);
    Navigator.pop(context, dt);
  }

  @override
  Widget build(BuildContext context) {
    final monthDays = PersianUtils.shamsiMonthDays(_jYear, _jMonth);
    final monthNames = widget.lang == 'ps' ? PersianUtils.monthNamesPs : PersianUtils.monthNamesFa;
    final weekDays  = widget.lang == 'ps' ? PersianUtils.weekDaysPs   : PersianUtils.weekDaysFa;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // handle
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Month navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // prev
                IconButton(
                  onPressed: _canGoPrev() ? _prevMonth : null,
                  icon: Icon(Icons.chevron_right, color: _canGoPrev() ? AppColors.primary : AppColors.textDisabled),
                ),
                Column(
                  children: [
                    Text(
                      monthNames[_jMonth - 1],
                      style: AppTextStyles.headline3.copyWith(color: AppColors.textPrimary),
                    ),
                    Text(
                      PersianUtils.intToPersian(_jYear),
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                // next
                IconButton(
                  onPressed: _canGoNext() ? _nextMonth : null,
                  icon: Icon(Icons.chevron_left, color: _canGoNext() ? AppColors.primary : AppColors.textDisabled),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Week day headers
            Row(
              children: weekDays.map((d) => Expanded(
                child: Center(
                  child: Text(d, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textTertiary)),
                ),
              )).toList(),
            ),
            const SizedBox(height: 8),
            // Day grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, mainAxisSpacing: 4, crossAxisSpacing: 4,
              ),
              itemCount: monthDays.length,
              itemBuilder: (_, i) {
                final day = monthDays[i];
                if (day == null) return const SizedBox();
                final isSelected = day == _jDay;
                final isSelectable = _isDaySelectable(day);
                return GestureDetector(
                  onTap: isSelectable ? () => setState(() => _jDay = day) : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        PersianUtils.intToPersian(day),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isSelected ? AppColors.white
                              : isSelectable ? AppColors.textPrimary
                              : AppColors.textDisabled,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // Confirm
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  widget.lang == 'ps' ? 'تایید' : 'تایید',
                  style: AppTextStyles.buttonText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
