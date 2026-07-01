// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:example_app/core/database/drift/app_database.dart' as _i260;
import 'package:example_app/core/database/drift/daos/event_dao.dart' as _i722;
import 'package:example_app/core/di/register_module.dart' as _i255;
import 'package:example_app/core/domain/repositories/event_repository.dart'
    as _i180;
import 'package:example_app/features/calendar/presentation/cubit/calendar_cubit.dart'
    as _i915;
import 'package:example_app/features/events/data/datasources/event_local_datasource.dart'
    as _i630;
import 'package:example_app/features/events/data/repositories/event_repository_impl.dart'
    as _i356;
import 'package:example_app/features/events/domain/usecases/create_event.dart'
    as _i1065;
import 'package:example_app/features/events/domain/usecases/delete_event.dart'
    as _i970;
import 'package:example_app/features/events/domain/usecases/get_scheduled_events.dart'
    as _i817;
import 'package:example_app/features/events/presentation/bloc/events_bloc.dart'
    as _i753;
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
    gh.lazySingleton<_i260.AppDatabase>(() => registerModule.appDatabase);
    gh.lazySingleton<_i722.EventDao>(
      () => registerModule.eventDao(gh<_i260.AppDatabase>()),
    );
    gh.lazySingleton<_i630.EventLocalDataSource>(
      () => _i630.EventDriftDataSource(gh<_i722.EventDao>()),
    );
    gh.lazySingleton<_i180.EventRepository>(
      () => _i356.EventRepositoryImpl(gh<_i630.EventLocalDataSource>()),
    );
    gh.lazySingleton<_i1065.CreateEvent>(
      () => _i1065.CreateEvent(gh<_i180.EventRepository>()),
    );
    gh.lazySingleton<_i970.DeleteEvent>(
      () => _i970.DeleteEvent(gh<_i180.EventRepository>()),
    );
    gh.lazySingleton<_i817.GetScheduledEvents>(
      () => _i817.GetScheduledEvents(gh<_i180.EventRepository>()),
    );
    gh.factory<_i753.EventsBloc>(
      () => _i753.EventsBloc(
        gh<_i817.GetScheduledEvents>(),
        gh<_i1065.CreateEvent>(),
        gh<_i970.DeleteEvent>(),
      ),
    );
    gh.factory<_i915.CalendarCubit>(
      () => _i915.CalendarCubit(gh<_i817.GetScheduledEvents>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i255.RegisterModule {}
