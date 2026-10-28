// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:example_app/core/database/drift/index.dart' as _i413;
import 'package:example_app/core/desktop/desktop_window_service.dart' as _i1036;
import 'package:example_app/core/desktop/index.dart' as _i1055;
import 'package:example_app/core/di/register_module.dart' as _i255;
import 'package:example_app/core/domain/index.dart' as _i714;
import 'package:example_app/core/home_widget/home_widget_service.dart' as _i424;
import 'package:example_app/core/home_widget/index.dart' as _i1008;
import 'package:example_app/core/notifications/index.dart' as _i272;
import 'package:example_app/core/notifications/notification_service.dart'
    as _i815;
import 'package:example_app/features/calendar/presentation/cubit/calendar_cubit.dart'
    as _i915;
import 'package:example_app/features/events/data/datasources/event_local_datasource.dart'
    as _i630;
import 'package:example_app/features/events/data/repositories/event_repository_impl.dart'
    as _i356;
import 'package:example_app/features/events/domain/index.dart' as _i451;
import 'package:example_app/features/events/domain/usecases/create_event.dart'
    as _i1065;
import 'package:example_app/features/events/domain/usecases/delete_event.dart'
    as _i970;
import 'package:example_app/features/events/domain/usecases/get_scheduled_events.dart'
    as _i817;
import 'package:example_app/features/events/domain/usecases/update_event.dart'
    as _i466;
import 'package:example_app/features/events/presentation/bloc/events_bloc.dart'
    as _i753;
import 'package:example_app/features/pomodoro/data/datasources/focus_tag_local_datasource.dart'
    as _i363;
import 'package:example_app/features/pomodoro/data/datasources/pomodoro_local_datasource.dart'
    as _i460;
import 'package:example_app/features/pomodoro/data/repositories/focus_tag_repository_impl.dart'
    as _i629;
import 'package:example_app/features/pomodoro/data/repositories/pomodoro_repository_impl.dart'
    as _i186;
import 'package:example_app/features/pomodoro/domain/index.dart' as _i228;
import 'package:example_app/features/pomodoro/domain/repositories/focus_tag_repository.dart'
    as _i280;
import 'package:example_app/features/pomodoro/domain/repositories/pomodoro_repository.dart'
    as _i325;
import 'package:example_app/features/pomodoro/domain/usecases/delete_focus_tag.dart'
    as _i850;
import 'package:example_app/features/pomodoro/domain/usecases/delete_pomodoro_session.dart'
    as _i938;
import 'package:example_app/features/pomodoro/domain/usecases/get_focus_tags.dart'
    as _i794;
import 'package:example_app/features/pomodoro/domain/usecases/get_pomodoro_sessions.dart'
    as _i112;
import 'package:example_app/features/pomodoro/domain/usecases/save_focus_tag.dart'
    as _i915;
import 'package:example_app/features/pomodoro/domain/usecases/save_pomodoro_session.dart'
    as _i678;
import 'package:example_app/features/pomodoro/presentation/cubit/pomodoro_cubit.dart'
    as _i709;
import 'package:example_app/features/pomodoro/presentation/cubit/pomodoro_report_cubit.dart'
    as _i697;
import 'package:example_app/features/pomodoro/presentation/desktop/pomodoro_tray_controller.dart'
    as _i610;
import 'package:example_app/features/remote/data/repositories/remote_repository_impl.dart'
    as _i179;
import 'package:example_app/features/remote/domain/repositories/remote_repository.dart'
    as _i137;
import 'package:example_app/features/settings/data/datasources/appearance_local_datasource.dart'
    as _i471;
import 'package:example_app/features/settings/data/repositories/appearance_repository_impl.dart'
    as _i710;
import 'package:example_app/features/settings/domain/index.dart' as _i228;
import 'package:example_app/features/settings/domain/repositories/appearance_repository.dart'
    as _i197;
import 'package:example_app/features/settings/domain/usecases/get_theme_mode.dart'
    as _i985;
import 'package:example_app/features/settings/domain/usecases/save_theme_mode.dart'
    as _i364;
import 'package:example_app/features/settings/presentation/cubit/appearance_cubit.dart'
    as _i8;
import 'package:example_app/features/tasks/data/datasources/task_local_datasource.dart'
    as _i725;
import 'package:example_app/features/tasks/data/repositories/task_repository_impl.dart'
    as _i444;
import 'package:example_app/features/tasks/domain/index.dart' as _i904;
import 'package:example_app/features/tasks/domain/repositories/task_repository.dart'
    as _i721;
import 'package:example_app/features/tasks/domain/usecases/create_task_schedule.dart'
    as _i176;
import 'package:example_app/features/tasks/domain/usecases/get_task_instances.dart'
    as _i82;
import 'package:example_app/features/tasks/domain/usecases/remove_task_schedule.dart'
    as _i69;
import 'package:example_app/features/tasks/domain/usecases/set_task_done.dart'
    as _i1029;
import 'package:example_app/features/tasks/presentation/cubit/task_cubit.dart'
    as _i553;
import 'package:example_app/features/tracking/data/datasources/tracking_local_datasource.dart'
    as _i116;
import 'package:example_app/features/tracking/data/datasources/tracking_reminder_local_datasource.dart'
    as _i399;
import 'package:example_app/features/tracking/data/repositories/tracking_reminder_repository_impl.dart'
    as _i432;
import 'package:example_app/features/tracking/data/repositories/tracking_repository_impl.dart'
    as _i48;
import 'package:example_app/features/tracking/domain/index.dart' as _i231;
import 'package:example_app/features/tracking/domain/repositories/tracking_reminder_repository.dart'
    as _i615;
import 'package:example_app/features/tracking/domain/repositories/tracking_repository.dart'
    as _i322;
import 'package:example_app/features/tracking/domain/usecases/delete_tracking_goal.dart'
    as _i593;
import 'package:example_app/features/tracking/domain/usecases/get_tracking_overview.dart'
    as _i278;
import 'package:example_app/features/tracking/domain/usecases/get_tracking_reminder_rules.dart'
    as _i594;
import 'package:example_app/features/tracking/domain/usecases/save_tracking_goal.dart'
    as _i806;
import 'package:example_app/features/tracking/domain/usecases/save_tracking_reminder_rules.dart'
    as _i677;
import 'package:example_app/features/tracking/domain/usecases/set_tracking_checkin.dart'
    as _i571;
import 'package:example_app/features/tracking/presentation/cubit/tracking_cubit.dart'
    as _i392;
import 'package:example_app/features/tracking/presentation/cubit/tracking_reminder_cubit.dart'
    as _i503;
import 'package:example_app/features/tracking/presentation/reminders/tracking_reminder_sync.dart'
    as _i112;
import 'package:example_app/features/typing/data/datasources/typing_content_datasource.dart'
    as _i682;
import 'package:example_app/features/typing/data/datasources/typing_content_pack_datasource.dart'
    as _i734;
import 'package:example_app/features/typing/data/datasources/typing_local_datasource.dart'
    as _i908;
import 'package:example_app/features/typing/data/repositories/typing_content_pack_repository_impl.dart'
    as _i655;
import 'package:example_app/features/typing/data/repositories/typing_content_repository_impl.dart'
    as _i558;
import 'package:example_app/features/typing/data/repositories/typing_repository_impl.dart'
    as _i250;
import 'package:example_app/features/typing/domain/index.dart' as _i885;
import 'package:example_app/features/typing/domain/repositories/typing_content_pack_repository.dart'
    as _i440;
import 'package:example_app/features/typing/domain/repositories/typing_content_repository.dart'
    as _i713;
import 'package:example_app/features/typing/domain/repositories/typing_repository.dart'
    as _i500;
import 'package:example_app/features/typing/domain/usecases/add_typing_content_pack.dart'
    as _i903;
import 'package:example_app/features/typing/domain/usecases/delete_typing_content_pack.dart'
    as _i909;
import 'package:example_app/features/typing/domain/usecases/delete_typing_result.dart'
    as _i529;
import 'package:example_app/features/typing/domain/usecases/get_typing_content.dart'
    as _i677;
import 'package:example_app/features/typing/domain/usecases/get_typing_content_packs.dart'
    as _i273;
import 'package:example_app/features/typing/domain/usecases/get_typing_results.dart'
    as _i37;
import 'package:example_app/features/typing/domain/usecases/save_typing_result.dart'
    as _i825;
import 'package:example_app/features/typing/presentation/cubit/typing_content_cubit.dart'
    as _i23;
import 'package:example_app/features/typing/presentation/cubit/typing_cubit.dart'
    as _i97;
import 'package:example_app/features/typing/presentation/cubit/typing_history_cubit.dart'
    as _i677;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i1036.DesktopWindowService>(
      () => _i1036.DesktopWindowService(),
    );
    gh.lazySingleton<_i413.AppDatabase>(() => registerModule.appDatabase);
    gh.lazySingleton<_i815.NotificationService>(
      () => _i815.NotificationService(),
    );
    gh.lazySingleton<_i471.AppearanceLocalDataSource>(
      () => _i471.AppearanceLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i399.TrackingReminderLocalDataSource>(
      () => _i399.TrackingReminderLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i682.TypingContentDataSource>(
      () => _i682.TypingContentAssetDataSource(),
    );
    gh.lazySingleton<_i413.EventDao>(
      () => registerModule.eventDao(gh<_i413.AppDatabase>()),
    );
    gh.lazySingleton<_i413.TaskDao>(
      () => registerModule.taskDao(gh<_i413.AppDatabase>()),
    );
    gh.lazySingleton<_i413.PomodoroDao>(
      () => registerModule.pomodoroDao(gh<_i413.AppDatabase>()),
    );
    gh.lazySingleton<_i413.FocusTagDao>(
      () => registerModule.focusTagDao(gh<_i413.AppDatabase>()),
    );
    gh.lazySingleton<_i413.TypingDao>(
      () => registerModule.typingDao(gh<_i413.AppDatabase>()),
    );
    gh.lazySingleton<_i413.TypingContentDao>(
      () => registerModule.typingContentDao(gh<_i413.AppDatabase>()),
    );
    gh.lazySingleton<_i413.RemoteDeviceDao>(
      () => registerModule.remoteDeviceDao(gh<_i413.AppDatabase>()),
    );
    gh.lazySingleton<_i413.TrackingDao>(
      () => registerModule.trackingDao(gh<_i413.AppDatabase>()),
    );
    gh.lazySingleton<_i908.TypingLocalDataSource>(
      () => _i908.TypingDriftDataSource(gh<_i413.TypingDao>()),
    );
    gh.lazySingleton<_i228.AppearanceRepository>(
      () =>
          _i710.AppearanceRepositoryImpl(gh<_i471.AppearanceLocalDataSource>()),
    );
    gh.lazySingleton<_i231.TrackingReminderRepository>(
      () => _i432.TrackingReminderRepositoryImpl(
        gh<_i399.TrackingReminderLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i985.GetThemeMode>(
      () => _i985.GetThemeMode(gh<_i197.AppearanceRepository>()),
    );
    gh.lazySingleton<_i364.SaveThemeMode>(
      () => _i364.SaveThemeMode(gh<_i197.AppearanceRepository>()),
    );
    gh.lazySingleton<_i734.TypingContentPackDataSource>(
      () =>
          _i734.TypingContentPackDriftDataSource(gh<_i413.TypingContentDao>()),
    );
    gh.lazySingleton<_i116.TrackingLocalDataSource>(
      () => _i116.TrackingDriftDataSource(
        gh<_i413.TrackingDao>(),
        gh<_i413.TaskDao>(),
      ),
    );
    gh.lazySingleton<_i137.RemoteRepository>(
      () => _i179.RemoteRepositoryImpl(gh<_i413.RemoteDeviceDao>()),
    );
    gh.lazySingleton<_i725.TaskLocalDataSource>(
      () => _i725.TaskDriftDataSource(gh<_i413.TaskDao>()),
    );
    gh.lazySingleton<_i231.TrackingRepository>(
      () => _i48.TrackingRepositoryImpl(gh<_i116.TrackingLocalDataSource>()),
    );
    gh.lazySingleton<_i460.PomodoroLocalDataSource>(
      () => _i460.PomodoroDriftDataSource(gh<_i413.PomodoroDao>()),
    );
    gh.lazySingleton<_i8.AppearanceCubit>(
      () => _i8.AppearanceCubit(
        gh<_i228.GetThemeMode>(),
        gh<_i228.SaveThemeMode>(),
      ),
    );
    gh.lazySingleton<_i593.DeleteTrackingGoal>(
      () => _i593.DeleteTrackingGoal(gh<_i322.TrackingRepository>()),
    );
    gh.lazySingleton<_i278.GetTrackingOverview>(
      () => _i278.GetTrackingOverview(gh<_i322.TrackingRepository>()),
    );
    gh.lazySingleton<_i806.SaveTrackingGoal>(
      () => _i806.SaveTrackingGoal(gh<_i322.TrackingRepository>()),
    );
    gh.lazySingleton<_i571.SetTrackingCheckin>(
      () => _i571.SetTrackingCheckin(gh<_i322.TrackingRepository>()),
    );
    gh.lazySingleton<_i363.FocusTagLocalDataSource>(
      () => _i363.FocusTagDriftDataSource(gh<_i413.FocusTagDao>()),
    );
    gh.lazySingleton<_i228.PomodoroRepository>(
      () => _i186.PomodoroRepositoryImpl(gh<_i460.PomodoroLocalDataSource>()),
    );
    gh.lazySingleton<_i885.TypingContentPackRepository>(
      () => _i655.TypingContentPackRepositoryImpl(
        gh<_i734.TypingContentPackDataSource>(),
      ),
    );
    gh.lazySingleton<_i630.EventLocalDataSource>(
      () => _i630.EventDriftDataSource(gh<_i413.EventDao>()),
    );
    gh.lazySingleton<_i885.TypingRepository>(
      () => _i250.TypingRepositoryImpl(gh<_i908.TypingLocalDataSource>()),
    );
    gh.lazySingleton<_i885.TypingContentRepository>(
      () => _i558.TypingContentRepositoryImpl(
        gh<_i682.TypingContentDataSource>(),
        gh<_i734.TypingContentPackDataSource>(),
      ),
    );
    gh.lazySingleton<_i594.GetTrackingReminderRules>(
      () => _i594.GetTrackingReminderRules(
        gh<_i615.TrackingReminderRepository>(),
      ),
    );
    gh.lazySingleton<_i677.SaveTrackingReminderRules>(
      () => _i677.SaveTrackingReminderRules(
        gh<_i615.TrackingReminderRepository>(),
      ),
    );
    gh.lazySingleton<_i677.GetTypingContent>(
      () => _i677.GetTypingContent(gh<_i713.TypingContentRepository>()),
    );
    gh.lazySingleton<_i904.TaskRepository>(
      () => _i444.TaskRepositoryImpl(gh<_i725.TaskLocalDataSource>()),
    );
    gh.lazySingleton<_i529.DeleteTypingResult>(
      () => _i529.DeleteTypingResult(gh<_i500.TypingRepository>()),
    );
    gh.lazySingleton<_i37.GetTypingResults>(
      () => _i37.GetTypingResults(gh<_i500.TypingRepository>()),
    );
    gh.lazySingleton<_i825.SaveTypingResult>(
      () => _i825.SaveTypingResult(gh<_i500.TypingRepository>()),
    );
    gh.lazySingleton<_i903.AddTypingContentPack>(
      () => _i903.AddTypingContentPack(gh<_i440.TypingContentPackRepository>()),
    );
    gh.lazySingleton<_i909.DeleteTypingContentPack>(
      () => _i909.DeleteTypingContentPack(
        gh<_i440.TypingContentPackRepository>(),
      ),
    );
    gh.lazySingleton<_i273.GetTypingContentPacks>(
      () =>
          _i273.GetTypingContentPacks(gh<_i440.TypingContentPackRepository>()),
    );
    gh.lazySingleton<_i228.FocusTagRepository>(
      () => _i629.FocusTagRepositoryImpl(gh<_i363.FocusTagLocalDataSource>()),
    );
    gh.lazySingleton<_i938.DeletePomodoroSession>(
      () => _i938.DeletePomodoroSession(gh<_i325.PomodoroRepository>()),
    );
    gh.lazySingleton<_i112.GetPomodoroSessions>(
      () => _i112.GetPomodoroSessions(gh<_i325.PomodoroRepository>()),
    );
    gh.lazySingleton<_i678.SavePomodoroSession>(
      () => _i678.SavePomodoroSession(gh<_i325.PomodoroRepository>()),
    );
    gh.lazySingleton<_i714.EventRepository>(
      () => _i356.EventRepositoryImpl(gh<_i630.EventLocalDataSource>()),
    );
    gh.lazySingleton<_i112.TrackingReminderSync>(
      () => _i112.TrackingReminderSync(
        gh<_i231.GetTrackingOverview>(),
        gh<_i231.GetTrackingReminderRules>(),
        gh<_i272.NotificationService>(),
      ),
    );
    gh.factory<_i23.TypingContentCubit>(
      () => _i23.TypingContentCubit(
        gh<_i885.GetTypingContent>(),
        gh<_i885.GetTypingContentPacks>(),
        gh<_i885.AddTypingContentPack>(),
        gh<_i885.DeleteTypingContentPack>(),
      ),
    );
    gh.factory<_i97.TypingCubit>(
      () => _i97.TypingCubit(
        gh<_i885.GetTypingContent>(),
        gh<_i885.SaveTypingResult>(),
        gh<_i885.GetTypingResults>(),
      ),
    );
    gh.lazySingleton<_i176.CreateTaskSchedule>(
      () => _i176.CreateTaskSchedule(gh<_i721.TaskRepository>()),
    );
    gh.lazySingleton<_i82.GetTaskInstances>(
      () => _i82.GetTaskInstances(gh<_i721.TaskRepository>()),
    );
    gh.lazySingleton<_i69.RemoveTaskSchedule>(
      () => _i69.RemoveTaskSchedule(gh<_i721.TaskRepository>()),
    );
    gh.lazySingleton<_i1029.SetTaskDone>(
      () => _i1029.SetTaskDone(gh<_i721.TaskRepository>()),
    );
    gh.lazySingleton<_i424.HomeWidgetService>(
      () => _i424.HomeWidgetService(gh<_i714.EventRepository>()),
    );
    gh.lazySingleton<_i1065.CreateEvent>(
      () => _i1065.CreateEvent(gh<_i714.EventRepository>()),
    );
    gh.lazySingleton<_i970.DeleteEvent>(
      () => _i970.DeleteEvent(gh<_i714.EventRepository>()),
    );
    gh.lazySingleton<_i817.GetScheduledEvents>(
      () => _i817.GetScheduledEvents(gh<_i714.EventRepository>()),
    );
    gh.lazySingleton<_i466.UpdateEvent>(
      () => _i466.UpdateEvent(gh<_i714.EventRepository>()),
    );
    gh.factory<_i553.TaskCubit>(
      () => _i553.TaskCubit(
        gh<_i904.GetTaskInstances>(),
        gh<_i904.CreateTaskSchedule>(),
        gh<_i904.SetTaskDone>(),
        gh<_i904.RemoveTaskSchedule>(),
      ),
    );
    gh.factory<_i503.TrackingReminderCubit>(
      () => _i503.TrackingReminderCubit(
        gh<_i231.GetTrackingReminderRules>(),
        gh<_i231.SaveTrackingReminderRules>(),
        gh<_i112.TrackingReminderSync>(),
      ),
    );
    gh.factory<_i677.TypingHistoryCubit>(
      () => _i677.TypingHistoryCubit(
        gh<_i885.GetTypingResults>(),
        gh<_i885.DeleteTypingResult>(),
      ),
    );
    gh.factory<_i392.TrackingCubit>(
      () => _i392.TrackingCubit(
        gh<_i231.GetTrackingOverview>(),
        gh<_i231.SaveTrackingGoal>(),
        gh<_i231.DeleteTrackingGoal>(),
        gh<_i231.SetTrackingCheckin>(),
        gh<_i272.NotificationService>(),
        gh<_i112.TrackingReminderSync>(),
      ),
    );
    gh.lazySingleton<_i850.DeleteFocusTag>(
      () => _i850.DeleteFocusTag(gh<_i280.FocusTagRepository>()),
    );
    gh.lazySingleton<_i794.GetFocusTags>(
      () => _i794.GetFocusTags(gh<_i280.FocusTagRepository>()),
    );
    gh.lazySingleton<_i915.SaveFocusTag>(
      () => _i915.SaveFocusTag(gh<_i280.FocusTagRepository>()),
    );
    gh.factory<_i753.EventsBloc>(
      () => _i753.EventsBloc(
        gh<_i451.GetScheduledEvents>(),
        gh<_i451.CreateEvent>(),
        gh<_i451.DeleteEvent>(),
      ),
    );
    gh.lazySingleton<_i709.PomodoroCubit>(
      () => _i709.PomodoroCubit(
        gh<_i228.SavePomodoroSession>(),
        gh<_i228.GetPomodoroSessions>(),
        gh<_i904.GetTaskInstances>(),
        gh<_i228.GetFocusTags>(),
        gh<_i228.SaveFocusTag>(),
        gh<_i228.DeleteFocusTag>(),
        gh<_i272.NotificationService>(),
      ),
    );
    gh.factory<_i915.CalendarCubit>(
      () => _i915.CalendarCubit(
        gh<_i451.GetScheduledEvents>(),
        gh<_i451.CreateEvent>(),
        gh<_i451.UpdateEvent>(),
        gh<_i451.DeleteEvent>(),
        gh<_i272.NotificationService>(),
        gh<_i1008.HomeWidgetService>(),
      ),
    );
    gh.lazySingleton<_i610.PomodoroTrayController>(
      () => _i610.PomodoroTrayController(
        gh<_i709.PomodoroCubit>(),
        gh<_i1055.DesktopWindowService>(),
      ),
    );
    gh.factory<_i697.PomodoroReportCubit>(
      () => _i697.PomodoroReportCubit(
        gh<_i228.GetPomodoroSessions>(),
        gh<_i228.DeletePomodoroSession>(),
        gh<_i228.GetFocusTags>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i255.RegisterModule {}
