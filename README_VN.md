# Ứng dụng Cấu hình Game Đố Vui

## Hướng dẫn sử dụng

Ứng dụng Flutter này cho phép bạn:
- ✅ Bật/tắt âm thanh
- ✅ Điều chỉnh volume
- ✅ Lưu điểm cao nhất
- ✅ Bật/tắt tự động lưu game
- ✅ Xem lịch sử 10 lần thay đổi gần nhất
- ✅ Khôi phục cấu hình từ lịch sử

## Vấn đề lưu dữ liệu

Nếu dữ liệu không lưu giữa các lần chạy:

### 1. **Android Emulator**
   - Hãy đảm bảo emulator sử dụng partition storage thay vì RAM
   - Chạy: `flutter run --device-id <device_id> --release`

### 2. **iOS Simulator**
   - SharedPreferences được lưu trong app's Documents directory
   - Nếu xóa app hoàn toàn hoặc reset simulator, dữ liệu sẽ bị xóa

### 3. **Kiểm tra dữ liệu**
   - Bấm nút **"Tải lại"** để tải lại cấu hình từ SharedPreferences
   - Bấm nút **"Xóa tất cả"** để xóa tất cả dữ liệu
   - Kiểm tra Console (Logcat/Xcode) để xem debug logs

## Chạy ứng dụng

```bash
cd flutter_app
flutter pub get
flutter run
```

## Cấu trúc lưu trữ

Dữ liệu được lưu trong SharedPreferences:
```
sound_enabled: bool
auto_save_enabled: bool
volume_level: double
high_score: int
settings_history: List<String> (JSON)
```

## Lịch sử thay đổi tối đa 10 bản ghi

Mỗi bản ghi bao gồm:
- Thời gian (timestamp)
- Trạng thái âm thanh
- Trạng thái tự lưu
- Giá trị volume
- Điểm cao nhất

## Nút hỗ trợ

- **Tải lại**: Tải lại cấu hình hiện tại từ SharedPreferences
- **Xóa tất cả**: Xóa toàn bộ dữ liệu (cẩn thận với nút này!)

## Lưu ý

- Nếu trên Android, hãy kiểm tra quyền `WRITE_EXTERNAL_STORAGE` (nếu cần)
- Trên iOS, không cần quyền bổ sung vì SharedPreferences lưu trong app sandbox
