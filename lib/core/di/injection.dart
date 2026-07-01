import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

/// Gọi 1 lần ở main(). `getIt.init()` được sinh trong injection.config.dart.
@InjectableInit()
void configureDependencies() => getIt.init();
