import 'package:flutter/material.dart';
import '../models/setting_snapshot.dart';
import '../services/settings_service.dart';

class SettingsPage extends StatefulWidget {
  final SettingsService settingsService;

  const SettingsPage({
    super.key,
    required this.settingsService,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _highScoreController;
  bool _soundEnabled = true;
  bool _autoSaveEnabled = false;
  double _volume = 50;
  int _highScore = 3500;
  String _status = 'Đang tải cấu hình...';
  List<SettingSnapshot> _history = [];

  @override
  void initState() {
    super.initState();
    _highScoreController = TextEditingController();
    _loadSettings();
  }

  @override
  void dispose() {
    _highScoreController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _soundEnabled = widget.settingsService.getSoundEnabled();
      _autoSaveEnabled = widget.settingsService.getAutoSaveEnabled();
      _volume = widget.settingsService.getVolume();
      _highScore = widget.settingsService.getHighScore();
      _history = widget.settingsService.getHistory();
      _highScoreController.text = _highScore.toString();
      _status = 'Cấu hình đã được tải (${_history.length} lần lưu trước).';
    });
  }

  Future<void> _saveSetting({
    bool? sound,
    bool? autoSave,
    double? volume,
    int? highScore,
  }) async {
    if (sound != null) {
      await widget.settingsService.setSoundEnabled(sound);
      setState(() => _soundEnabled = sound);
    }
    if (autoSave != null) {
      await widget.settingsService.setAutoSaveEnabled(autoSave);
      setState(() => _autoSaveEnabled = autoSave);
    }
    if (volume != null) {
      await widget.settingsService.setVolume(volume);
      setState(() => _volume = volume);
    }
    if (highScore != null) {
      await widget.settingsService.setHighScore(highScore);
      setState(() => _highScore = highScore);
    }

    await _addToHistory();
  }

  Future<void> _addToHistory() async {
    final snapshot = SettingSnapshot(
      timestamp: DateTime.now(),
      soundEnabled: _soundEnabled,
      autoSaveEnabled: _autoSaveEnabled,
      volume: _volume,
      highScore: _highScore,
    );

    await widget.settingsService.addSnapshot(snapshot);
    setState(() {
      _history = widget.settingsService.getHistory();
      _status = 'Lưu thành công.';
    });
  }

  Future<void> _saveHighScore() async {
    final value = int.tryParse(_highScoreController.text);
    if (value == null || value < 0) {
      setState(() {
        _status = 'Điểm cao nhất phải là số nguyên >= 0.';
      });
      return;
    }
    await _saveSetting(highScore: value);
  }

  Future<void> _restoreSnapshot(SettingSnapshot snapshot) async {
    await widget.settingsService.restoreSnapshot(snapshot);
    await _loadSettings();
    setState(() {
      _status = 'Đã khôi phục từ: ${snapshot.timestamp.toString().split('.')[0]}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cấu hình game đố vui'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            // Âm thanh
            SwitchListTile(
              title: const Text('Âm thanh'),
              subtitle: const Text('Bật hoặc tắt âm thanh game'),
              value: _soundEnabled,
              onChanged: (value) => _saveSetting(sound: value),
            ),
            const Divider(),

            // Điểm cao nhất
            ListTile(
              title: const Text('Điểm cao nhất'),
              subtitle: Text('$_highScore'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _highScoreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cập nhật điểm cao nhất',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _saveHighScore(),
              onEditingComplete: _saveHighScore,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saveHighScore,
              child: const Text('Lưu điểm cao nhất'),
            ),
            const Divider(height: 36),

            // Tự động lưu game
            SwitchListTile(
              title: const Text('Tự động lưu game'),
              subtitle: const Text('Lưu cài đặt tự động khi thay đổi'),
              value: _autoSaveEnabled,
              onChanged: (value) => _saveSetting(autoSave: value),
            ),
            const Divider(),

            // Volume
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Volume: ${_volume.round()}%',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Slider(
              value: _volume,
              min: 0,
              max: 100,
              divisions: 100,
              label: '${_volume.round()}%',
              onChanged: (value) => _saveSetting(volume: value),
            ),

            const SizedBox(height: 20),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  _status,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _loadSettings,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tải lại'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await widget.settingsService.clearAll();
                    await _loadSettings();
                    setState(() {
                      _soundEnabled = true;
                      _autoSaveEnabled = false;
                      _volume = 50;
                      _highScore = 3500;
                      _history = [];
                      _status = 'Đã xóa tất cả dữ liệu.';
                    });
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Xóa tất cả'),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(height: 36),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Lịch sử thay đổi (${_history.length})',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            _history.isEmpty
                ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Chưa có lịch sử thay đổi'),
                )
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final snapshot = _history[_history.length - 1 - index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          '${snapshot.timestamp.hour}:${snapshot.timestamp.minute.toString().padLeft(2, '0')}:${snapshot.timestamp.second.toString().padLeft(2, '0')} - Điểm: ${snapshot.highScore}, Volume: ${snapshot.volume.round()}%',
                          style: const TextStyle(fontSize: 13),
                        ),
                        subtitle: Text(
                          'Âm thanh: ${snapshot.soundEnabled ? 'Bật' : 'Tắt'} | Tự lưu: ${snapshot.autoSaveEnabled ? 'Bật' : 'Tắt'}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => _restoreSnapshot(snapshot),
                          child: const Text('Khôi phục'),
                        ),
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
