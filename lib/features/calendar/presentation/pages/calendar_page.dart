import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/index.dart';
import '../cubit/calendar_cubit.dart';
import '../widgets/add_event_sheet.dart';
import '../widgets/calendar_bottom_nav.dart';
import '../widgets/month_view.dart';
import 'day_detail_page.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, 1);
    final months = List.generate(
      13,
      (i) => DateTime(start.year, start.month + i, 1),
    );
    final last = months.last;
    final rangeEnd = DateTime(
      last.year,
      last.month,
      DateUtils.getDaysInMonth(last.year, last.month),
      23,
      59,
      59,
    );

    return BlocProvider(
      create: (_) => getIt<CalendarCubit>()..loadRange(start, rangeEnd),
      child: _CalendarView(today: today, months: months),
    );
  }
}

class _CalendarView extends StatefulWidget {
  final DateTime today;
  final List<DateTime> months;

  const _CalendarView({required this.today, required this.months});

  @override
  State<_CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<_CalendarView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToToday() {
    // Tháng hiện tại là phần tử đầu danh sách → cuộn về đầu.
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  Future<void> _addEvent(DateTime date) async {
    final cubit = context.read<CalendarCubit>();
    final event = await showAddEventSheet(context, initialDate: date);
    if (event != null) {
      await cubit.addEvent(event);
    }
  }

  /// Mở chi tiết ngày, chia sẻ cùng CalendarCubit để thay đổi phản ánh về lịch.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F2),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(year: widget.today.year, onToday: _scrollToToday),
            Expanded(
              child: BlocConsumer<CalendarCubit, CalendarState>(
                listenWhen: (p, c) => c.status == CalendarStatus.failure,
                listener: (context, state) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage ?? 'Lỗi')),
                  );
                },
                builder: (context, state) {
                  return ListView.builder(
                    controller: _scrollController,
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
        onPressed: () => _addEvent(widget.today),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const CalendarBottomNav(),
    );
  }
}

class _Header extends StatelessWidget {
  final int year;
  final VoidCallback onToday;

  const _Header({required this.year, required this.onToday});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 12, 4),
      child: Row(
        children: [
          Text(
            '$year',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1C1C1E),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onToday,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE9E4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Today',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1E),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
