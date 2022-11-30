import 'dart:math' as math;

import 'package:custom_date_picker_example/app_colors.dart';
import 'package:custom_date_picker_example/cubits/preset_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'custom_date_picker.dart';

const List<String> _weekDays = <String>[
  'Sun',
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
];

const Duration _monthScrollDuration = Duration(milliseconds: 200);
const double _dayPickerRowHeight = 50.0;
const int _maxDayPickerRowCount = 6; // A 31 day month that starts on Saturday.
// One extra row for the day-of-week header.
const double _maxDayPickerHeight =
    _dayPickerRowHeight * (_maxDayPickerRowCount + 1);
const double _monthPickerHorizontalPadding = 4.0;

const double _subHeaderHeight = 52.0;

class CustomCalendar extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime currentDate;
  final Preset preset;

  CustomCalendar(
      {Key? key,
      required DateTime initialDate,
      required DateTime firstDate,
      required DateTime lastDate,
      DateTime? currentDate,
      required this.preset})
      : initialDate = DateUtils.dateOnly(initialDate),
        firstDate = DateUtils.dateOnly(firstDate),
        lastDate = DateUtils.dateOnly(lastDate),
        currentDate = DateUtils.dateOnly(currentDate ?? DateTime.now()),
        super(key: key);

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _currentDisplayedMonthDate;
  late DateTime _selectedDate;
  final GlobalKey _monthPickerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _currentDisplayedMonthDate =
        DateTime(widget.initialDate.year, widget.initialDate.month);
    _selectedDate = widget.initialDate;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PresetCubit, int>(
      listener: (context, state) {
        if (widget.preset == Preset.four) {
          DateTime today = DateTime.now();
          switch (state) {
            // Never Ends
            case 0:
              _handleDayChanged(today);
              break;
            // 15 Days Later
            case 1:
              DateTime newDate = today.add(const Duration(days: 15));
              _handleDayChanged(newDate);
              break;
            // 30 Days Later
            case 2:
              DateTime newDate = today.add(const Duration(days: 30));
              _handleDayChanged(newDate);
              break;
            // 60 Days Later
            case 3:
              DateTime newDate = today.add(const Duration(days: 60));
              _handleDayChanged(newDate);
              break;
          }
        } else if (widget.preset == Preset.six) {
          final today = DateTime.now();
          switch (state) {
            // Yesterday
            case 0:
              DateTime newDate = today.subtract(const Duration(days: 1));
              if (!DateUtils.isSameMonth(newDate, today)) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('You can\'t select a date from the last month'),
                  ),
                );
                Future.delayed(const Duration(milliseconds: 100), () {
                  context.read<PresetCubit>().updatePresetIndex(1);
                });
                return;
              } else {
                _handleDayChanged(newDate);
              }
              break;
            //Today
            case 1:
              _handleDayChanged(today);
              break;
            //Tomorrow
            case 2:
              DateTime newDate = today.add(const Duration(days: 1));
              _handleDayChanged(newDate);
              break;
            // This Saturday
            case 3:
              DateTime newDate = today.add(Duration(days: 6 - today.weekday));
              _handleDayChanged(newDate);
              break;
            // This Sunday
            case 4:
              DateTime newDate = today.add(Duration(days: 7 - today.weekday));
              _handleDayChanged(newDate);
              break;
            // Next Week same day
            case 5:
              DateTime newDate = today.add(const Duration(days: 7));
              _handleDayChanged(newDate);
              break;
          }
        }
      },
      child: SizedBox(
        height: _subHeaderHeight + _maxDayPickerHeight,
        child: _buildPicker(),
      ),
    );
  }

  void _handleMonthChanged(DateTime date) {
    setState(() {
      if (_currentDisplayedMonthDate.year != date.year ||
          _currentDisplayedMonthDate.month != date.month) {
        _currentDisplayedMonthDate = DateTime(date.year, date.month);
      }
    });
  }

  void _handleDayChanged(DateTime value) {
    setState(() {
      _selectedDate = value;
    });
  }

  Widget _buildPicker() {
    return _MonthPicker(
      key: _monthPickerKey,
      initialMonth: _currentDisplayedMonthDate,
      currentDate: widget.currentDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      selectedDate: _selectedDate,
      onChanged: _handleDayChanged,
      onDisplayedMonthChanged: _handleMonthChanged,
      preset: widget.preset,
    );
  }
}

class _MonthPicker extends StatefulWidget {
  /// Creates a month picker.
  _MonthPicker({
    super.key,
    required this.initialMonth,
    required this.currentDate,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.onChanged,
    required this.onDisplayedMonthChanged,
    required this.preset,
    this.selectableDayPredicate,
  })  : assert(!firstDate.isAfter(lastDate)),
        assert(!selectedDate.isBefore(firstDate)),
        assert(!selectedDate.isAfter(lastDate));

  /// The initial month to display.
  final DateTime initialMonth;

  /// The current date.
  ///
  /// This date is subtly highlighted in the picker.
  final DateTime currentDate;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [lastDate].
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [firstDate].
  final DateTime lastDate;

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// Called when the user navigates to a new month.
  final ValueChanged<DateTime> onDisplayedMonthChanged;

  /// Optional user supplied predicate function to customize selectable days.
  final SelectableDayPredicate? selectableDayPredicate;

  final Preset preset;

  @override
  _MonthPickerState createState() => _MonthPickerState();
}

class _MonthPickerState extends State<_MonthPicker> {
  final GlobalKey _pageViewKey = GlobalKey();
  late DateTime _currentMonth;
  late PageController _pageController;
  late MaterialLocalizations _localizations;
  DateTime? _focusedDay;

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.initialMonth;
    _pageController = PageController(
        initialPage: DateUtils.monthDelta(widget.firstDate, _currentMonth));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = MaterialLocalizations.of(context);
  }

  @override
  void didUpdateWidget(_MonthPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialMonth != oldWidget.initialMonth &&
        widget.initialMonth != _currentMonth) {
      // We can't interrupt this widget build with a scroll, so do it next frame
      WidgetsBinding.instance.addPostFrameCallback(
        (Duration timeStamp) => _showMonth(widget.initialMonth, jump: true),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleDateSelected(DateTime selectedDate) {
    _focusedDay = selectedDate;
    widget.onChanged(selectedDate);
  }

  void _handleMonthPageChanged(int monthPage) {
    setState(() {
      final DateTime monthDate =
          DateUtils.addMonthsToMonthDate(widget.firstDate, monthPage);
      if (!DateUtils.isSameMonth(_currentMonth, monthDate)) {
        _currentMonth = DateTime(monthDate.year, monthDate.month);
        widget.onDisplayedMonthChanged(_currentMonth);
        if (_focusedDay != null &&
            !DateUtils.isSameMonth(_focusedDay, _currentMonth)) {
          // We have navigated to a new month with the grid focused, but the
          // focused day is not in this month. Choose a new one trying to keep
          // the same day of the month.
          _focusedDay = _focusableDayForMonth(_currentMonth, _focusedDay!.day);
        }
      }
    });
  }

  /// Returns a focusable date for the given month.
  ///
  /// If the preferredDay is available in the month it will be returned,
  /// otherwise the first selectable day in the month will be returned. If
  /// no dates are selectable in the month, then it will return null.
  DateTime? _focusableDayForMonth(DateTime month, int preferredDay) {
    final int daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);

    // Can we use the preferred day in this month?
    if (preferredDay <= daysInMonth) {
      final DateTime newFocus = DateTime(month.year, month.month, preferredDay);
      if (_isSelectable(newFocus)) {
        return newFocus;
      }
    }

    // Start at the 1st and take the first selectable date.
    for (int day = 1; day <= daysInMonth; day++) {
      final DateTime newFocus = DateTime(month.year, month.month, day);
      if (_isSelectable(newFocus)) {
        return newFocus;
      }
    }
    return null;
  }

  /// Navigate to the next month.
  void _handleNextMonth() {
    if (!_isDisplayingLastMonth) {
      _pageController.nextPage(
        duration: _monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  /// Navigate to the previous month.
  void _handlePreviousMonth() {
    if (!_isDisplayingFirstMonth) {
      _pageController.previousPage(
        duration: _monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  /// Navigate to the given month.
  void _showMonth(DateTime month, {bool jump = false}) {
    final int monthPage = DateUtils.monthDelta(widget.firstDate, month);
    if (jump) {
      _pageController.jumpToPage(monthPage);
    } else {
      _pageController.animateToPage(
        monthPage,
        duration: _monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  /// True if the earliest allowable month is displayed.
  bool get _isDisplayingFirstMonth {
    return !_currentMonth.isAfter(
      DateTime(widget.firstDate.year, widget.firstDate.month),
    );
  }

  /// True if the latest allowable month is displayed.
  bool get _isDisplayingLastMonth {
    return !_currentMonth.isBefore(
      DateTime(widget.lastDate.year, widget.lastDate.month),
    );
  }

  /// Handler for when the overall day grid obtains or loses focus.
  void _handleGridFocusChange(bool focused) {
    setState(() {
      if (focused && _focusedDay == null) {
        if (DateUtils.isSameMonth(widget.selectedDate, _currentMonth)) {
          _focusedDay = widget.selectedDate;
        } else if (DateUtils.isSameMonth(widget.currentDate, _currentMonth)) {
          _focusedDay =
              _focusableDayForMonth(_currentMonth, widget.currentDate.day);
        } else {
          _focusedDay = _focusableDayForMonth(_currentMonth, 1);
        }
      }
    });
  }

  bool _isSelectable(DateTime date) {
    return widget.selectableDayPredicate == null ||
        widget.selectableDayPredicate!.call(date);
  }

  Widget _buildItems(BuildContext context, int index) {
    final DateTime month =
        DateUtils.addMonthsToMonthDate(widget.firstDate, index);
    return _DayPicker(
      key: ValueKey<DateTime>(month),
      selectedDate: widget.selectedDate,
      currentDate: widget.currentDate,
      onChanged: _handleDateSelected,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      displayedMonth: month,
      selectableDayPredicate: widget.selectableDayPredicate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color controlColor =
        Theme.of(context).colorScheme.onSurface.withOpacity(0.60);
    return BlocListener<PresetCubit, int>(
      listener: (context, state) {
        final DateTime today = DateTime.now();
        late DateTime newDate;
        if (widget.preset == Preset.four) {
          switch (state) {
            // Never Ends
            case 0:
              newDate = today;
              break;
            // 15 Days Later
            case 1:
              newDate = today.add(const Duration(days: 15));
              break;
            // 30 Days Later
            case 2:
              newDate = today.add(const Duration(days: 30));
              break;
            // 60 Days Later
            case 3:
              newDate = today.add(const Duration(days: 60));

              break;
          }
        } else if (widget.preset == Preset.six) {
          switch (state) {
            // Yesterday
            case 0:
              newDate = today.subtract(const Duration(days: 1));
              if (!DateUtils.isSameMonth(newDate, today)) {
                return;
              }
              break;
            //Today
            case 1:
              newDate = today;
              break;
            //Tomorrow
            case 2:
              newDate = today.add(const Duration(days: 1));
              break;
            // This Saturday
            case 3:
              newDate = today.add(Duration(days: 6 - today.weekday));
              break;
            // This Sunday
            case 4:
              newDate = today.add(Duration(days: 7 - today.weekday));
              break;
            // Next Week same day
            case 5:
              newDate = today.add(const Duration(days: 7));
              break;
          }
        }
        if (!DateUtils.isSameMonth(_currentMonth, newDate)) {
          _pageController.animateToPage(
            DateUtils.monthDelta(widget.firstDate, newDate),
            duration: _monthScrollDuration,
            curve: Curves.ease,
          );
        }
      },
      child: Semantics(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsetsDirectional.only(start: 16, end: 4),
              height: _subHeaderHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.arrow_left),
                    color: controlColor,
                    tooltip: _isDisplayingFirstMonth
                        ? null
                        : _localizations.previousMonthTooltip,
                    onPressed:
                        _isDisplayingFirstMonth ? null : _handlePreviousMonth,
                  ),
                  Text(
                    _localizations.formatMonthYear(_currentMonth),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right),
                    color: controlColor,
                    tooltip: _isDisplayingLastMonth
                        ? null
                        : _localizations.nextMonthTooltip,
                    onPressed: _isDisplayingLastMonth ? null : _handleNextMonth,
                  ),
                ],
              ),
            ),
            Expanded(
              child: FocusableActionDetector(
                onFocusChange: _handleGridFocusChange,
                child: _FocusedDate(
                  date: _focusedDay,
                  child: PageView.builder(
                    key: _pageViewKey,
                    controller: _pageController,
                    itemBuilder: _buildItems,
                    itemCount: DateUtils.monthDelta(
                            widget.firstDate, widget.lastDate) +
                        1,
                    onPageChanged: _handleMonthPageChanged,
                  ),
                ),
              ),
            ),
            Theme(
              data: ThemeData(
                outlinedButtonTheme: OutlinedButtonThemeData(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide.none,
                    minimumSize: const Size(80, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.event,
                      color: AppColors.primaryBlue,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(DateFormat('dd MMM yyyy').format(widget.selectedDate)),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.secondaryBlue,
                        foregroundColor: AppColors.primaryBlue,
                        minimumSize: const Size(80, 40),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context, widget.selectedDate);
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: AppColors.secondaryBlue,
                        minimumSize: const Size(80, 40),
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayPicker extends StatefulWidget {
  /// Creates a day picker.
  _DayPicker({
    super.key,
    required this.currentDate,
    required this.displayedMonth,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.onChanged,
    this.selectableDayPredicate,
  })  : assert(!firstDate.isAfter(lastDate)),
        assert(!selectedDate.isBefore(firstDate)),
        assert(!selectedDate.isAfter(lastDate));

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedDate;

  /// The current date at the time the picker is displayed.
  final DateTime currentDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [lastDate].
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [firstDate].
  final DateTime lastDate;

  /// The month whose days are displayed by this picker.
  final DateTime displayedMonth;

  /// Optional user supplied predicate function to customize selectable days.
  final SelectableDayPredicate? selectableDayPredicate;

  @override
  _DayPickerState createState() => _DayPickerState();
}

class _DayPickerState extends State<_DayPicker> {
  /// List of [FocusNode]s, one for each day of the month.
  late List<FocusNode> _dayFocusNodes;

  @override
  void initState() {
    super.initState();
    final int daysInMonth = DateUtils.getDaysInMonth(
        widget.displayedMonth.year, widget.displayedMonth.month);
    _dayFocusNodes = List<FocusNode>.generate(
      daysInMonth,
      (int index) =>
          FocusNode(skipTraversal: true, debugLabel: 'Day ${index + 1}'),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check to see if the focused date is in this month, if so focus it.
    final DateTime? focusedDate = _FocusedDate.of(context);
    if (focusedDate != null &&
        DateUtils.isSameMonth(widget.displayedMonth, focusedDate)) {
      _dayFocusNodes[focusedDate.day - 1].requestFocus();
    }
  }

  @override
  void dispose() {
    for (final FocusNode node in _dayFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  /// Builds widgets showing abbreviated days of week. The first widget in the
  /// returned list corresponds to the first day of week for the current locale.
  ///
  /// Examples:
  ///
  /// ```
  /// ┌ Sunday is the first day of week in the US (en_US)
  /// |
  /// S M T W T F S  <-- the returned list contains these widgets
  /// _ _ _ _ _ 1 2
  /// 3 4 5 6 7 8 9
  ///
  /// ┌ But it's Monday in the UK (en_GB)
  /// |
  /// M T W T F S S  <-- the returned list contains these widgets
  /// _ _ _ _ 1 2 3
  /// 4 5 6 7 8 9 10
  /// ```
  ///
  /// modified to show Sun, Mon, Tue, Wed, Thu, Fri, Sat
  List<Widget> _dayHeaders(
      TextStyle? headerStyle, MaterialLocalizations localizations) {
    final List<Widget> result = <Widget>[];
    for (int i = localizations.firstDayOfWeekIndex; true; i = (i + 1) % 7) {
      final String weekday = _weekDays[i];
      result.add(ExcludeSemantics(
        child: Center(child: Text(weekday, style: headerStyle)),
      ));
      if (i == (localizations.firstDayOfWeekIndex - 1) % 7) {
        break;
      }
    }
    return result;
  }

  int _getPreviousMonthDays(int year, int month) {
    if (month == 1) {
      return DateUtils.getDaysInMonth(year - 1, 12);
    } else {
      return DateUtils.getDaysInMonth(year, month - 1);
    }
  }

  int _getNextMonthDaysToFill(int year, int month) {
    final lastWeekDayOfCurrentMonth = DateTime.now().weekday;
    final firstWeekDayOfNextMonth = DateTime(year, month + 1, 1).weekday;
    if (lastWeekDayOfCurrentMonth == DateTime.sunday) {
      return 0;
    }
    return 7 - firstWeekDayOfNextMonth;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle headerStyle =
        textTheme.caption!.copyWith(color: AppColors.black, fontSize: 14);
    final TextStyle dayStyle = textTheme.caption!.copyWith(fontSize: 14);
    final Color enabledDayColor = colorScheme.onSurface.withOpacity(0.87);
    final Color disabledDayColor = colorScheme.onSurface.withOpacity(0.38);
    final Color selectedDayColor = colorScheme.onPrimary;
    final Color selectedDayBackground = colorScheme.primary;
    final Color todayColor = colorScheme.primary;

    final int year = widget.displayedMonth.year;
    final int month = widget.displayedMonth.month;

    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int previousMonthDays = _getPreviousMonthDays(year, month);
    final int nextMonthDaysToFill = _getNextMonthDaysToFill(year, month);

    final int dayOffset = DateUtils.firstDayOffset(year, month, localizations);

    final List<Widget> dayItems = _dayHeaders(headerStyle, localizations);
    // 1-based day of month, e.g. 1-31 for January, and 1-29 for February on
    // a leap year.
    int day = -dayOffset;
    while (day < daysInMonth + nextMonthDaysToFill) {
      day++;
      if (day < 1) {
        Widget dayWidget = Center(
          child: Text(localizations.formatDecimal(previousMonthDays + day),
              style: dayStyle.apply(color: disabledDayColor)),
        );
        dayItems.add(dayWidget);
      } else if (day > daysInMonth) {
        Widget dayWidget = Center(
          child: Text(localizations.formatDecimal(day - daysInMonth),
              style: dayStyle.apply(color: disabledDayColor)),
        );
        dayItems.add(dayWidget);
      } else {
        final DateTime dayToBuild = DateTime(year, month, day);
        final bool isDisabled = dayToBuild.isAfter(widget.lastDate) ||
            dayToBuild.isBefore(widget.firstDate) ||
            (widget.selectableDayPredicate != null &&
                !widget.selectableDayPredicate!(dayToBuild));
        final bool isSelectedDay =
            DateUtils.isSameDay(widget.selectedDate, dayToBuild);
        final bool isToday =
            DateUtils.isSameDay(widget.currentDate, dayToBuild);

        BoxDecoration? decoration;
        Color dayColor = enabledDayColor;
        if (isSelectedDay) {
          // The selected day gets a circle background highlight, and a
          // contrasting text color.
          dayColor = selectedDayColor;
          decoration = BoxDecoration(
            color: selectedDayBackground,
            shape: BoxShape.circle,
          );
        } else if (isDisabled) {
          dayColor = disabledDayColor;
        } else if (isToday) {
          // The current day gets a different text color and a circle stroke
          // border.
          dayColor = todayColor;
          // decoration = BoxDecoration(
          //   border: Border.all(color: todayColor),
          //   shape: BoxShape.circle,
          // );
        }

        Widget dayWidget = Container(
          decoration: decoration,
          child: Center(
            child: Text(localizations.formatDecimal(day),
                style: dayStyle.apply(color: dayColor)),
          ),
        );

        if (isDisabled) {
          dayWidget = ExcludeSemantics(
            child: dayWidget,
          );
        } else {
          dayWidget = InkResponse(
            focusNode: _dayFocusNodes[day - 1],
            onTap: () => widget.onChanged(dayToBuild),
            radius: _dayPickerRowHeight / 2 + 4,
            splashColor: selectedDayBackground.withOpacity(0.38),
            child: Semantics(
              // We want the day of month to be spoken first irrespective of the
              // locale-specific preferences or TextDirection. This is because
              // an accessibility user is more likely to be interested in the
              // day of month before the rest of the date, as they are looking
              // for the day of month. To do that we prepend day of month to the
              // formatted full date.
              label:
                  '${localizations.formatDecimal(day)}, ${localizations.formatFullDate(dayToBuild)}',
              selected: isSelectedDay,
              excludeSemantics: true,
              child: dayWidget,
            ),
          );
        }

        dayItems.add(dayWidget);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _monthPickerHorizontalPadding,
      ),
      child: GridView.custom(
        physics: const ClampingScrollPhysics(),
        gridDelegate: _dayPickerGridDelegate,
        childrenDelegate: SliverChildListDelegate(
          dayItems,
          addRepaintBoundaries: false,
        ),
      ),
    );
  }
}

class _DayPickerGridDelegate extends SliverGridDelegate {
  const _DayPickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    const int columnCount = DateTime.daysPerWeek;
    final double tileWidth = constraints.crossAxisExtent / columnCount;
    final double tileHeight = math.min(
      _dayPickerRowHeight,
      constraints.viewportMainAxisExtent / (_maxDayPickerRowCount + 1),
    );
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: tileHeight,
      crossAxisCount: columnCount,
      crossAxisStride: tileWidth,
      mainAxisStride: tileHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_DayPickerGridDelegate oldDelegate) => false;
}

const _DayPickerGridDelegate _dayPickerGridDelegate = _DayPickerGridDelegate();

/// InheritedWidget indicating what the current focused date is for its children.
///
/// This is used by the [_MonthPicker] to let its children [_DayPicker]s know
/// what the currently focused date (if any) should be.
class _FocusedDate extends InheritedWidget {
  const _FocusedDate({
    required super.child,
    this.date,
  });

  final DateTime? date;

  @override
  bool updateShouldNotify(_FocusedDate oldWidget) {
    return !DateUtils.isSameDay(date, oldWidget.date);
  }

  static DateTime? of(BuildContext context) {
    final _FocusedDate? focusedDate =
        context.dependOnInheritedWidgetOfExactType<_FocusedDate>();
    return focusedDate?.date;
  }
}
