/// Data-level errors. DataSource ném ra, RepositoryImpl bắt và chuyển thành Failure.
class DatabaseException implements Exception {
  final String message;
  DatabaseException([this.message = 'Database error']);
}
