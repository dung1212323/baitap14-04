# Cấu Trúc Dự Án Flutter - Cấu Hình Game Đố Vui

Dự án đã được tách thành các file nhỏ dễ quản lý:

```
lib/
├── main.dart                 # Entry point - khởi tạo app
├── models/
│   └── setting_snapshot.dart # Model lưu trữ snapshot cài đặt
├── services/
│   └── settings_service.dart # Logic lưu/tải dữ liệu từ SharedPreferences
└── pages/
    └── settings_page.dart    # UI chính - giao diện cấu hình
```

## File từng phần

### 1. **main.dart** (18 dòng)
- Khởi tạo `SettingsService`
- Tạo `GameConfigApp` root widget
- Khởi động ứng dụng

**Trách nhiệm**: Startup, dependency injection

---

### 2. **models/setting_snapshot.dart** (37 dòng)
```dart
class SettingSnapshot {
  DateTime timestamp;
  bool soundEnabled;
  bool autoSaveEnabled;
  double volume;
  int highScore;
  // ... toJson(), fromJson(), toString()
}
```

**Trách nhiệm**: Lưu trữ và chuyển đổi dữ liệu

---

### 3. **services/settings_service.dart** (77 dòng)
Quản lý tất cả logic liên quan `SharedPreferences`:
- Lưu & tải từng setting
- Quản lý lịch sử (tối đa 10 bản ghi)
- Khôi phục snapshot
- Xóa tất cả dữ liệu

**Trách nhiệm**: Persistence layer, xử lý dữ liệu

---

### 4. **pages/settings_page.dart** (220+ dòng)
StatefulWidget quản lý UI:
- SwitchListTile (Âm thanh, Tự lưu)
- TextField (Điểm cao nhất)
- Slider (Volume)
- Hiển thị lịch sử
- Nút Tải lại, Xóa tất cả, Khôi phục

**Trách nhiệm**: Giao diện người dùng

---

## Lợi ích khi tách file

| Vấn đề | Trước | Sau |
|--------|-------|-----|
| Độ dài file | 400+ dòng | 18 + 37 + 77 + 220 |
| Dễ hiểu | ❌ Khó | ✅ Rõ ràng |
| Tái sử dụng | ❌ Khó | ✅ Dễ |
| Test | ❌ Rắc rối | ✅ Có thể test từng phần |
| Bảo trì | ❌ Phức tạp | ✅ Đơn giản |

## Cách làm việc với code

### Thêm cài đặt mới
1. Thêm key constant trong `SettingsService`
2. Thêm method get/set trong `SettingsService`
3. Thêm widget trong `SettingsPage`

### Sửa UI
→ Chỉnh sửa `settings_page.dart`

### Sửa logic lưu dữ liệu
→ Chỉnh sửa `settings_service.dart`

### Thêm trường dữ liệu
1. Thêm field trong `SettingSnapshot`
2. Cập nhật `toJson()`, `fromJson()`
3. Thêm method trong `SettingsService`

## Warnings (có thể bỏ qua)
- `avoid_print`: Debug logs có thể xóa sau
- `unnecessary_brace_in_string_interps`: Format nhỏ, không ảnh hưởng

## Chạy ứng dụng

```bash
cd flutter_app
flutter pub get
flutter run
```

## Tệp test

```
test/
└── widget_test.dart # Test cơ bản
```

Hiện tại test chỉ check app load mà không lỗi. Có thể mở rộng để test từng service riêng.

---

**Tóm lại**: Code bây giờ sạch, dễ hiểu, dễ bảo trì! 🎉
