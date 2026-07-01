# ft_calender

Ứng dụng lịch (Flutter) xây theo **Clean Architecture, feature-first**.
Stack: `flutter_bloc` + `drift` (1 DB duy nhất) + `get_it`/`injectable`, xử lý lỗi bằng `dartz` (`Either<Failure, T>`).

## Workflow phát triển

Mọi task đi qua đúng 5 bước, không bỏ bước:

**1. Nhận task** — làm rõ yêu cầu; xác định feature + tầng bị ảnh hưởng (data / domain / presentation) và ranh giới thay đổi.

**2. Lên plan** — trước khi code, liệt kê file cần tạo/sửa theo tầng, bám cấu trúc + convention ở file này (Clean Architecture, barrel-theo-tầng, hợp đồng `Either`). Với thay đổi lớn, dùng plan mode và chốt plan trước khi động vào code.

**3. Coding** — implement theo luồng phụ thuộc `Page → Bloc → UseCase → Repository ← Impl → DataSource → DAO`. Nếu đổi Drift table/DAO hoặc annotation `@injectable`:
```bash
dart run build_runner build --force-jit
```

**4. Verify (bắt buộc pass trước khi commit)** — tĩnh rồi động:
```bash
flutter analyze        # phải "No issues found!"
flutter test           # tất cả test pass
```
Rồi **giả lập máy ảo** để kiểm tra hành vi thật, không chỉ tin vào test:
```bash
flutter emulators                       # liệt kê emulator/simulator
flutter emulators --launch <id>         # hoặc: open -a Simulator (iOS)
flutter run                             # build & chạy trên máy ảo, quan sát UI/luồng
```
Xác nhận feature chạy đúng trên máy ảo (tạo/sửa/xoá event hiển thị đúng, không crash) rồi mới sang bước 5.

**5. Commit** — chỉ commit khi bước 4 đã pass.
```bash
# Lần đầu (repo chưa init):
git init && git add -A && git commit -m "chore: init ft_calender clean architecture skeleton"
# Các lần sau: tạo nhánh cho task, không commit thẳng lên main
git checkout -b <feat/ten-task>
git add -A && git commit -m "<type>: <mô tả ngắn>"   # feat/fix/refactor/chore/test
```
Commit message viết theo Conventional Commits; một task = một nhánh.

**Sau khi merge vào master:** LUÔN xoá nhánh vừa merge (`git branch -d <branch>`).

## Code generation

⚠️ **Luôn dùng `--force-jit`**. `build_runner` bản mới AOT-compile builders và crash vì `sqlite3_flutter_libs` khai báo native build-hook.

```bash
dart run build_runner build --force-jit          # sinh code 1 lần
dart run build_runner watch --force-jit           # sinh code liên tục khi dev
```

Chạy lại mỗi khi đổi Drift table/DAO, hoặc thêm/bớt annotation `@injectable`.
File sinh ra: `*.g.dart` (Drift), `lib/core/di/injection.config.dart` (injectable).

## Cấu trúc & luồng phụ thuộc

```
lib/
├── core/                    # dùng chung, không thuộc feature nào
│   ├── domain/              # ⭐ shared domain: Event entity + EventRepository (interface)
│   ├── error/               # Failure (domain) + Exception (data)
│   ├── usecase/             # abstract UseCase<T, Params>
│   ├── database/drift/      # ⚠️ infrastructure: AppDatabase (1 DB), tables, DAOs
│   └── di/                  # get_it + injectable
└── features/<feature>/
    ├── data/                # datasource (Drift) + model/mapper + repository impl
    ├── domain/              # usecases (interface repo nằm ở core/domain nếu dùng chung)
    └── presentation/        # bloc/cubit + pages + widgets
```

Luồng phụ thuộc (chỉ hướng vào trong): `Page → Bloc → UseCase → Repository(interface) ← RepositoryImpl → DataSource → DAO → Drift`.

- `core/domain` và `features/*/domain` là **thuần Dart** — KHÔNG import Flutter/Drift.
- Bloc chỉ gọi `UseCase`, không đụng Repository/DataSource.
- Tầng data bắt `Exception` → trả về `Failure`; tầng trên không thấy exception.

## Quy tắc barrel file (`index.dart`) — barrel-theo-tầng

Mỗi barrel là public API của **một tầng**. Không gom nhiều tầng vào một barrel.

1. **File KHÔNG import barrel của chính tầng nó** (tránh import vòng). Dùng đường dẫn tương đối cho file sibling.
   - VD: `event_repository_impl.dart` import `../datasources/event_local_datasource.dart`, KHÔNG import `../index.dart`.
2. **Xuyên feature chỉ được qua `features/<feature>/domain/index.dart`.** Cấm import `data/` hay `presentation/` của feature khác.
3. **`core/database/drift/index.dart` (Drift) chỉ tầng data import.** KHÔNG bao giờ re-export nó qua `core/domain` — nếu không domain sẽ chạm được Drift và mất ranh giới tầng.
4. `core/domain/index.dart` và `core/error/index.dart` an toàn để import ở bất kỳ đâu.
5. File generated (`*.g.dart`, `injection.config.dart`) tham chiếu file cụ thể, không qua barrel — đúng hành vi generator, đừng sửa.

## Convention: hợp đồng xử lý lỗi `Either<Failure, T>`

Đây là quy ước xuyên suốt mọi feature — làm đúng theo template này, KHÔNG tự chế cách khác.

**Trách nhiệm từng tầng:**
- **DataSource**: gói mọi lỗi DB trong `try/catch` → `throw DatabaseException(e.toString())`. KHÔNG trả `null`, KHÔNG để exception thô lọt ra.
- **RepositoryImpl**: bắt exception, chuyển thành `Failure`, luôn trả `Either`. KHÔNG bao giờ `throw`.
- **UseCase**: trả thẳng `Either` từ repository, không bắt lỗi.
- **Bloc/Cubit**: dùng `result.fold(onFailure, onSuccess)` — nhánh lỗi emit `status: failure` + `errorMessage`; KHÔNG dùng `try/catch` quanh usecase.

**Template (bám đúng code hiện có):**

```dart
// data/datasources — ném exception có kiểu
try {
  return await _dao.getScheduledEvents(from: from, to: to);
} catch (e) {
  throw DatabaseException(e.toString());
}

// data/repositories — exception → Failure, luôn trả Either
try {
  final rows = await _local.getScheduledEvents(from: from, to: to);
  return Right(rows.map((r) => r.toEntity()).toList());
} on DatabaseException catch (e) {
  return Left(DatabaseFailure(e.message));
} catch (_) {
  return const Left(UnexpectedFailure());
}

// presentation/bloc — fold, không try/catch
final result = await _getScheduledEvents(params);
result.fold(
  (failure) => emit(state.copyWith(
    status: EventsStatus.failure, errorMessage: failure.message)),
  (events) => emit(state.copyWith(
    status: EventsStatus.success, events: events)),
);
```

**Quy ước phụ đi kèm:**
- Thao tác "không có giá trị trả" (delete...) dùng `Either<Failure, Unit>` + `return const Right(unit)` (dartz `Unit`), KHÔNG dùng `void`.
- `copyWith` của state để `errorMessage` **không** null-coalesce (`errorMessage: errorMessage`) → cho phép xoá lỗi cũ khi chuyển sang success/loading.
- Mapping Drift ↔ entity chỉ đặt ở `data/models/*_mapper.dart` dưới dạng extension (`toEntity()` / `toCompanion()`); KHÔNG map rải rác trong repository hay bloc.

## Thêm feature mới

1. Table + DAO vào `core/database/drift/` → `--force-jit` để sinh code.
2. Entity + repository interface: nếu dùng chung nhiều feature → `core/domain`; nếu riêng → `features/<feature>/domain`.
3. `data/` (datasource + mapper + repo impl), `domain/usecases`, `presentation/` (bloc + page).
4. Đánh annotation injectable (`@LazySingleton(as: ...)`, `@injectable`), tạo barrel `index.dart` cho từng tầng theo quy tắc trên.
5. Đăng ký object thư viện bên thứ 3 (không annotation) trong `core/di/register_module.dart`.
