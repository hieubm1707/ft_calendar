import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../core/di/index.dart';
import '../../../../core/theme/index.dart';
import '../cubit/calendar_cubit.dart';
import '../widgets/add_event_sheet.dart';
import '../widgets/color_filter_sheet.dart';
import '../widgets/month_view.dart';
import 'day_detail_page.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  // Dải hiển thị: 6 tháng quá khứ + tháng hiện tại + 12 tháng tương lai.
  static const _monthsBefore = 6;
  static const _monthsAfter = 12;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CalendarCubit>(),
      child: const _CalendarView(),
    );
  }
}

class _CalendarView extends StatefulWidget {
  const _CalendarView();

  @override
  State<_CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<_CalendarView> {
  final _itemScrollController = ItemScrollController();
  final _positionsListener = ItemPositionsListener.create();
  
  late final DateTime _today;
  late final List<DateTime> _months;
  late final int _todayIndex;
  late final ValueNotifier<int> _visibleYear;

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _todayIndex = CalendarPage._monthsBefore;
    final start = DateTime(_today.year, _today.month - CalendarPage._monthsBefore, 1);
    _months = List.generate(
      CalendarPage._monthsBefore + 1 + CalendarPage._monthsAfter,
      (i) => DateTime(start.year, start.month + i, 1),
    );
    _visibleYear = ValueNotifier(_months[_todayIndex].year);
    _positionsListener.itemPositions.addListener(_onScroll);

    // Hoãn việc load DB sang microtask/postFrame sau khi route animation hoàn tất
    Future.microtask(() {
      if (!mounted) return;
      final last = _months.last;
      final rangeEnd = DateTime(last.year, last.month,
          DateUtils.getDaysInMonth(last.year, last.month), 23, 59, 59);
      context.read<CalendarCubit>().loadRange(start, rangeEnd);
    });
  }

  @override
  void dispose() {
    _positionsListener.itemPositions.removeListener(_onScroll);
    _visibleYear.dispose();
    super.dispose();
  }

    void _onScroll() {
    final positions = _positionsListener.itemPositions.value;
    if (positions.isEmpty) return;
    // Tháng trên cùng đang hiển thị.
    final topIndex = positions
        .where((p) => p.itemTrailingEdge > 0)
        .reduce((a, b) => a.itemLeadingEdge < b.itemLeadingEdge ? a : b)
        .index;
    _visibleYear.value = _months[topIndex].year;
  }

  void _scrollToToday() {
    _itemScrollController.scrollTo(
      index: _todayIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  Future<void> _openFilter() async {
    final cubit = context.read<CalendarCubit>();
    final result = await showColorFilterSheet(
      context,
      selected: cubit.state.activeColors,
    );
    if (result != null) cubit.setColorFilter(result);
  }

  void _openDay(DateTime date) {
    final cubit = context.read<CalendarCubit>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: DayDetailPage(day: date),
        ),
      ),
    );
  }

  Future<void> _addToday() async {
    final cubit = context.read<CalendarCubit>();
    final event = await showAddEventSheet(context, initialDate: _today);
    if (event != null) await cubit.addEvent(event);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<int>(
          valueListenable: _visibleYear,
          builder: (context, y, child) => Text(
            'Lịch $y',
            style: TextStyle(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          BlocBuilder<CalendarCubit, CalendarState>(
            buildWhen: (p, c) => p.activeColors != c.activeColors,
            builder: (context, state) {
              final active = state.activeColors.isNotEmpty;
              return IconButton(
                onPressed: _openFilter,
                icon: Icon(
                  active ? Icons.filter_alt : Icons.filter_alt_outlined,
                  color: active
                      ? Theme.of(context).colorScheme.primary
                      : colors.textPrimary,
                ),
              );
            },
          ),
          GestureDetector(
            onTap: _scrollToToday,
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: colors.divider,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Today',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocConsumer<CalendarCubit, CalendarState>(
                listenWhen: (p, c) => c.status == CalendarStatus.failure,
                listener: (context, state) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage ?? 'Lỗi')),
                  );
                },
                builder: (context, state) {
                  if (state.status == CalendarStatus.loading ||
                      state.status == CalendarStatus.initial) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: colors.accent,
                      ),
                    );
                  }
                  return ScrollablePositionedList.builder(
                    itemScrollController: _itemScrollController,
                    itemPositionsListener: _positionsListener,
                    initialScrollIndex: _todayIndex,
                    padding: const EdgeInsets.fromLTRB(16, 0, 12, 24),
                    itemCount: _months.length,
                    itemBuilder: (_, i) => MonthView(
                      month: _months[i],
                      today: _today,
                      eventsOf: state.eventsOf,
                      onTapDay: _openDay,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addToday,
        child: const Icon(Icons.add),
      ),
    );
  }
}

