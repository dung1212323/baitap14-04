class SettingSnapshot {
  final DateTime timestamp;
  final bool soundEnabled;
  final bool autoSaveEnabled;
  final double volume;
  final int highScore;

  SettingSnapshot({
    required this.timestamp,
    required this.soundEnabled,
    required this.autoSaveEnabled,
    required this.volume,
    required this.highScore,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'soundEnabled': soundEnabled,
    'autoSaveEnabled': autoSaveEnabled,
    'volume': volume,
    'highScore': highScore,
  };

  factory SettingSnapshot.fromJson(Map<String, dynamic> json) => SettingSnapshot(
    timestamp: DateTime.parse(json['timestamp']),
    soundEnabled: json['soundEnabled'],
    autoSaveEnabled: json['autoSaveEnabled'],
    volume: (json['volume'] as num).toDouble(),
    highScore: json['highScore'],
  );

  @override
  String toString() {
    return 'SettingSnapshot('
        'time: ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}, '
        'sound: $soundEnabled, '
        'autoSave: $autoSaveEnabled, '
        'volume: $volume, '
        'highScore: $highScore)';
  }
}
