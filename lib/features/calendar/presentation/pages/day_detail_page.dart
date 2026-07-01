import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/index.dart';
import '../../../../core/utils/index.dart';
import '../cubit/calendar_cubit.dart';
import '../widgets/add_event_sheet.dart';

/// Chi tiết một ngày: danh sách sự kiện, bấm để sửa, vuốt/nút để xoá, nút thêm.
/// Dùng chung CalendarCubit (truyền qua BlocProvider.value) để lịch tự cập nhật.
class DayDetailPage extends StatelessWidget {
  final DateTime day;

  const DayDetailPage({super.key, required this.day});

  static const _weekdays = [
    'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật',
  ];

  Future<void> _add(BuildContext context) async {
    final cubit = context.read<CalendarCubit>();
    final created = await showAddEventSheet(context, initialDate: day);
    if (created != null) await cubit.addEvent(created);
  }

  Future<void> _edit(BuildContext context, Event event) async {
    final cubit = context.read<CalendarCubit>();
    final updated = await showAddEventSheet(context, event: event);
    if (updated != null) await cubit.updateEvent(updated);
  }

  Future<void> _delete(BuildContext context, Event event) async {
    final cubit = context.read<CalendarCubit>();
    if (event.id == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xoá sự kiện?'),
        content: Text('"${event.title}" sẽ bị xoá.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
    if (ok == true) await cubit.deleteEvent(event.id!);
  }

  @override
  Widget build(BuildContext context) {
    final lunar = solarToLunar(day);
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF7F2),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_weekdays[day.weekday - 1]}, ${day.day}/${day.month}/${day.year}',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C1C1E),
              ),
            ),
            Text(
              '${lunar.day}/${lunar.month} âm lịch',
              style: const TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
            ),
          ],
        ),
      ),
      body: BlocBuilder<CalendarCubit, CalendarState>(
        builder: (context, state) {
          final events = state.eventsOf(day);
          if (events.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có sự kiện nào.\nNhấn + để thêm.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF8E8E93)),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: events.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1, indent: 16),
            itemBuilder: (context, i) {
              final e = events[i];
              return Dismissible(
                key: ValueKey(e.id ?? i),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (_) async {
                  await _delete(context, e);
                  return false; // xoá do cubit reload, không tự gỡ khỏi list
                },
                child: ListTile(
                  onTap: () => _edit(context, e),
                  leading: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Color(e.color),
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(e.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.isAllDay
                            ? 'Cả ngày'
                            : '${_hhmm(e.startTime)} - ${_hhmm(e.endTime)}',
                      ),
                      if (e.description != null &&
                          e.description!.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            e.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF8E8E93)),
                          ),
                        ),
                    ],
                  ),
                  isThreeLine: e.description != null &&
                      e.description!.trim().isNotEmpty,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _delete(context, e),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        onPressed: () => _add(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _hhmm(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}
