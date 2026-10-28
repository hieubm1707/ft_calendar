import 'package:equatable/equatable.dart';

/// Domain-level error. Trả về trong `Either<Failure, T>` để presentation xử lý.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'Đã xảy ra lỗi cơ sở dữ liệu.']);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Đã xảy ra lỗi không mong muốn.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Không lưu/đọc được cài đặt.']);
}
