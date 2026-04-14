import 'package:flutter/material.dart';
import 'pages/settings_page.dart';
import 'services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsService = SettingsService();
  await settingsService.initialize();
  runApp(GameConfigApp(settingsService: settingsService));
}

class GameConfigApp extends StatelessWidget {
  final SettingsService settingsService;

  const GameConfigApp({
    super.key,
    required this.settingsService,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cấu hình game đố vui',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: SettingsPage(settingsService: settingsService),
    );
  }
}

