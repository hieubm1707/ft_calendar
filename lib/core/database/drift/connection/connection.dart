// Mở kết nối DB theo nền tảng: native (iOS/Android/macOS…) dùng file sqlite,
// web dùng sqlite3.wasm + drift_worker.js (đặt trong thư mục `web/`).
export 'connection_native.dart'
    if (dart.library.js_interop) 'connection_web.dart';
