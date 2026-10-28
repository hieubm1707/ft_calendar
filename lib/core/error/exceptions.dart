/// Data-level errors. DataSource ném ra, RepositoryImpl bắt và chuyển thành Failure.
class DatabaseException implements Exception {
  final String message;
  DatabaseException([this.message = 'Database error']);
}

/// Lỗi đọc/ghi cài đặt cục bộ (SharedPreferences).
class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error']);
}
