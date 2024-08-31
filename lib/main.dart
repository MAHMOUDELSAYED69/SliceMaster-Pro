import 'dart:io';

import 'package:flutter/material.dart';
import 'package:slice_master_pro/data/database/hive.dart';
import 'package:window_manager/window_manager.dart';

import 'app/app.dart';
import 'utils/helpers/shared_pref.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheData.cacheDataInit();
  await HiveDb().initializeDatabase();
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1280, 800),
      center: true,
      backgroundColor: Colors.transparent,
      title: 'SliceMaster Pro',
      titleBarStyle: TitleBarStyle.normal,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setResizable(true);
      await windowManager.setMinimumSize(const Size(1280, 800));
    });
  }
  runApp(const MyApp());
}
