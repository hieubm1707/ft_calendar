import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../core/di/index.dart';
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
    final today = DateTime.now();
    final start = DateTime(today.year, today.month - _monthsBefore, 1);
    final months = List.generate(
      _monthsBefore + 1 + _monthsAfter,
      (i) => DateTime(start.year, start.month + i, 1),
    );
    final last = months.last;
    final rangeEnd = DateTime(last.year, last.month,
        DateUtils.getDaysInMonth(last.year, last.month), 23, 59, 59);

    return BlocProvider(
      create: (_) => getIt<CalendarCubit>()..loadRange(start, rangeEnd),
      child: _CalendarView(
        today: today,
        months: months,
        todayIndex: _monthsBefore,
      ),
    );
  }
}

class _CalendarView extends StatefulWidget {
  final DateTime today;
  final List<DateTime> months;
  final int todayIndex;

  const _CalendarView({
    required this.today,
    required this.months,
    required this.todayIndex,
  });

  @override
  State<_CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<_CalendarView> {
  final _itemScrollController = ItemScrollController();
  final _positionsListener = ItemPositionsListener.create();
  late final ValueNotifier<int> _visibleYear =
      ValueNotifier(widget.months[widget.todayIndex].year);

  @override
  void initState() {
    super.initState();
    _positionsListener.itemPositions.addListener(_onScroll);
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
    _visibleYear.value = widget.months[topIndex].year;
  }

  void _scrollToToday() {
    _itemScrollController.scrollTo(
      index: widget.todayIndex,
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
    final event = await showAddEventSheet(context, initialDate: widget.today);
    if (event != null) await cubit.addEvent(event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F2),
      appBar: AppBar(
        title: ValueListenableBuilder<int>(
          valueListenable: _visibleYear,
          builder: (context, y, child) => Text(
            'Lịch $y',
            style: const TextStyle(
              color: Color(0xFF1C1C1E),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF1C1C1E)),
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
                      : const Color(0xFF1C1C1E),
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
                color: const Color(0xFFEDE9E4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Today',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1E),
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
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF5252),
                      ),
                    );
                  }
                  return ScrollablePositionedList.builder(
                    itemScrollController: _itemScrollController,
                    itemPositionsListener: _positionsListener,
                    initialScrollIndex: widget.todayIndex,
                    padding: const EdgeInsets.fromLTRB(16, 0, 12, 24),
                    itemCount: widget.months.length,
                    itemBuilder: (_, i) => MonthView(
                      month: widget.months[i],
                      today: widget.today,
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
        backgroundColor: Colors.black,
        elevation: 2,
        shape: const CircleBorder(),
        onPressed: _addToday,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

