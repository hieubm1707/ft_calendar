import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/domain/entities/event.dart';
import '../bloc/events_bloc.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EventsBloc>()..add(const EventsLoaded()),
      child: const _EventsView(),
    );
  }
}

class _EventsView extends StatelessWidget {
  const _EventsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sự kiện')),
      body: BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          switch (state.status) {
            case EventsStatus.loading:
            case EventsStatus.initial:
              return const Center(child: CircularProgressIndicator());
            case EventsStatus.failure:
              return Center(child: Text(state.errorMessage ?? 'Lỗi'));
            case EventsStatus.success:
              if (state.events.isEmpty) {
                return const Center(child: Text('Chưa có sự kiện nào.'));
              }
              return ListView.separated(
                itemCount: state.events.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final e = state.events[index];
                  return ListTile(
                    title: Text(e.title),
                    subtitle: Text(e.startTime.toString()),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: e.id == null
                          ? null
                          : () => context
                              .read<EventsBloc>()
                              .add(EventDeleted(e.id!)),
                    ),
                  );
                },
              );
          }
        },
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () {
            final now = DateTime.now();
            context.read<EventsBloc>().add(
                  EventCreated(Event(
                    title: 'Sự kiện mới',
                    startTime: now,
                    endTime: now.add(const Duration(hours: 1)),
                  )),
                );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
