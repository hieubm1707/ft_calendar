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
Rồi **kiểm thử trên máy ảo iOS — iPhone 16e (KHÔNG dùng Android để verify)**:
```bash
flutter run -d 3E46A6BE-AF54-4F4A-8530-A908B29B6E33   # iPhone 16e simulator
```
Thao tác/chụp màn hình bằng **idb** (xem cách dùng ở memory `ios-ui-testing-with-idb`):
`idb ui tap X Y` (X,Y là point = pixel/3), `idb screenshot`, `idb launch com.example.exampleApp`.
Xác nhận feature chạy đúng trên iPhone 16e (không crash) rồi mới sang bước 5.
> ⚠️ Yêu cầu của người dùng: **luôn verify trên iOS (iPhone 16e)**, không kiểm thử trên Android nữa.

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

## Migration DB (`core/database/drift/app_database.dart`)

`onUpgrade` **không tin tuyệt đối vào `from`**. DB thật có thể ở trạng thái *nửa vời*: schema đã đổi nhưng `user_version` chưa kịp tăng (migration lần trước chết giữa chừng). Khi đó `addColumn` theo số phiên bản ném `duplicate column name` → cả migration rollback → DB **kẹt vĩnh viễn** ở phiên bản cũ, bảng mới không bao giờ được tạo (đã xảy ra thật trên bản macOS: `user_version` = 5 nhưng schema đã ở v6, nên `typing_result_table` không được tạo).

Vì mọi bước từ trước tới nay chỉ THÊM bảng/cột (không biến đổi dữ liệu), `onUpgrade` đối chiếu lại với schema hiện tại và **tự chữa**:
1. `m.createAll()` — sinh `CREATE TABLE IF NOT EXISTS`, bảng đã có thì bỏ qua.
2. `_addColumnIfMissing()` cho từng cột thêm về sau — hỏi `PRAGMA table_info` trước vì SQLite không có `ADD COLUMN IF NOT EXISTS`.

**Thêm cột mới**: khai báo ở table rồi thêm 1 dòng `_addColumnIfMissing` (không cần bọc `if (from < n)`). **Thêm bảng mới**: chỉ cần khai báo trong `@DriftDatabase` — `createAll()` lo phần còn lại. Vẫn phải tăng `schemaVersion` để `onUpgrade` được gọi.

Test ở `test/core/database/migration_test.dart` dựng DB in-memory ở đúng các trạng thái cũ/hỏng (dùng `NativeDatabase.memory(setup:)` + `PRAGMA user_version`) và kiểm tra migration chạy được nhiều lần.

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

## Widget home/lock screen (`core/home_widget/`)

Hiển thị lịch + sự kiện ra widget. **Kiến trúc: render UI bằng Dart → ảnh PNG** (`HomeWidget.renderFlutterWidget`), native chỉ hiện ảnh → 1 codebase UI cho cả 2 nền tảng.
- `WidgetCalendarView` dựng lịch theo `WidgetMode` (day=agenda hôm nay / week / month); `HomeWidgetService.refreshAll()` render 3 ảnh (`cal_day/cal_week/cal_month`) qua `EventRepository` rồi `updateWidget`. Ảnh render đúng tỉ lệ từng family iOS (small ~1:1, medium ~2.14:1, large ~0.95:1) + `.contentMarginsDisabled()` để lấp đầy widget.
- Gọi `refreshAll()` sau frame đầu (`main.dart`) và trong `CalendarCubit._reload()` (sau CRUD). ⚠️ `renderFlutterWidget` cần có frame → KHÔNG gọi trước `runApp`.
- **iOS**: App Group `group.com.example.exampleApp`; widget extension target `CalendarWidget` (`ios/CalendarWidget/`, bundle `com.example.exampleApp.CalendarWidget`) đọc ảnh từ App Group theo `WidgetFamily` — **small = 1 ngày, medium = 1 tuần, large = 1 tháng**; lock accessoryRectangular/Circular = 1 ngày. Deployment target 17.0 (cần cho `.contentMarginsDisabled()`). Thêm/sửa target bằng gem `xcodeproj` (script), KHÔNG sửa tay pbxproj. Lưu ý: phase **"Embed App Extensions" phải đứng trước "Thin Binary"** (nếu không sẽ lỗi "Cycle inside Runner"); Info.plist extension dùng `$(MARKETING_VERSION)`/`$(CURRENT_PROJECT_VERSION)` (KHÔNG dùng `$(FLUTTER_BUILD_*)` vì target extension không có biến đó).
- **Android**: `CalendarWidgetProvider` (HomeWidgetProvider) hiện ảnh vào `ImageView`, chọn ảnh theo chiều cao widget (resize = đổi mode). **Android KHÔNG có widget màn hình khóa** (OS bỏ từ Android 5.0) — chỉ home screen.

## Feature Tasks (`features/tasks/`) + điều hướng tab

Tab "Tasks" quản lý công việc theo ngày, tách biệt với sự kiện lịch.
- **Mô hình**: `TaskScheduleTable` (loại `dates` = 1/nhiều ngày cụ thể qua `datesCsv`; loại `weekly` = lặp theo `weekdaysMask` từ `startDate`, cờ `active` để huỷ lặp; `note` = mô tả, `minutesOfDay` = giờ tuỳ chọn, `color` = cờ ưu tiên) + `TaskCompletionTable` (đánh dấu hoàn thành theo từng ngày). DB **schemaVersion 4** (v3 tạo 2 bảng; v4 thêm `note` + `minutesOfDay`). Event cũng có `description` (nhập ở add_event_sheet, hiện ở DayDetailPage).
- **Instance sinh ảo**: `expandTaskInstances()` (hàm thuần ở `features/tasks/domain/task_recurrence.dart`, có unit test) sinh task cho từng ngày trong khoảng — task lặp tự "xuất hiện" đến khi huỷ, KHÔNG lưu sẵn từng ngày.
- **Tầng**: nhân theo pattern `events` (data/domain/presentation); entity + `TaskRepository` đặt ở `features/tasks/domain` (feature độc lập, không dùng chung).
- **Điều hướng**: `features/shell/presentation/main_shell.dart` (IndexedStack + `AppBottomNav` chuyển tab Typing/Calendar/Tasks/Focus/Notes). `app.dart` → `MainShell`. Các page (TypingPage, CalendarPage, TasksPage) là Scaffold riêng, KHÔNG tự chứa bottom nav.

## Feature Pomodoro (`features/pomodoro/`) — tab "Focus"

Đồng hồ tập trung + báo cáo thời gian đã tập trung.
- **Mô hình**: `PomodoroSessionTable` chỉ lưu phiên **FOCUS** đã thực hiện (`startedAt`, `endedAt`, `focusSeconds` thực tế, `plannedSeconds`, `completed` = chạy hết hay dừng sớm, `label` + `taskScheduleId` + `focusTagId` = việc đang tập trung). Thời gian nghỉ KHÔNG lưu. `FocusTagTable` = tag tập trung có sẵn (`title`, `minutes`, `color`, `emoji`, `sortOrder`). DB **schemaVersion 6** (v5 tạo bảng pomodoro; v6 tạo `focus_tag_table` + thêm cột `focusTagId`). 5 tag mặc định (Work 25p, Read 30p, Fitness 10p, Focus 25p, Study 45p) seed trong `beforeOpen` **chỉ khi `wasCreated`/`hadUpgrade`** → xoá hết tag rồi mở lại app không bị seed lại.
- **Đồng hồ**: `PomodoroCubit` là máy trạng thái `focus → nghỉ ngắn → … → nghỉ dài` (mặc định 25/5/15, 4 vòng). Đếm ngược theo **mốc deadline đồng hồ thật** (`DateTime`), không cộng dồn tick → chính xác kể cả khi app bị treo/ngủ. Hết giờ focus (hoặc dừng sớm ≥ 60s) → lưu 1 phiên; hết giờ → `NotificationService.showNow()` báo. Giai đoạn kế KHÔNG tự chạy, người dùng bấm Bắt đầu.
- **Tag tập trung**: thay ô nhập tay bằng tag. Nhãn giữa đồng hồ (`_TargetLabel`) hiện **tên tag đang chọn** (giai đoạn nghỉ thì hiện tên giai đoạn); bấm vào nhãn mở `showFocusTagSheet` — trang KHÔNG hiển thị sẵn danh sách tag cho đỡ rối. Trong sheet: chọn tag (đặt nhãn + lấy số phút của tag khi đang rảnh), `Tag mới`, bút chì/chạm giữ để sửa, `Bỏ chọn`, và lối chọn task hôm nay. Thêm/sửa/xoá qua `showFocusTagEditor` (tên, số phút, emoji, màu) → `PomodoroCubit.saveTag/deleteTag`. Sheet nhận cubit tường minh (`BlocProvider.value`) vì nằm trên route khác.
- **Toàn màn hình**: nút ⛶ trên AppBar trang Focus → `PomodoroFullscreenPage`. **Luôn xoay ngang** (`setPreferredOrientations` landscape), thoát ra thì khoá về `portraitUp`. Nền tối; góc trái trên = nhãn tag/giai đoạn + chấm vòng (luôn hiện), góc phải trên = Dừng · Chạy/Tạm dừng · Bỏ qua · Thoát (`_Controls`); số đếm chiếm phần còn lại — `FittedBox` thu chữ cỡ lớn cho vừa cạnh chạm trước — kèm **thanh tiến độ ngang** `_LineProgress` bên dưới. Vào trang: `SystemUiMode.immersiveSticky` + `WakelockPlus.enable()` + `DesktopWindowService.setFullScreen(true)` (macOS); `dispose` trả lại `edgeToEdge`/tắt wakelock/thoát fullscreen. Đang chạy thì cụm nút tự ẩn sau 4s (giữ chỗ, không nhảy layout), chạm màn hình để hiện lại; tạm dừng/dừng/hết giờ thì hiện ngay.
- **Thống kê**: `summarizePomodoro()` (hàm thuần ở `features/pomodoro/domain/pomodoro_stats.dart`, có unit test) gom phiên → tổng/**theo ngày**/theo tag/streak; mọi ngày trong khoảng đều có mặt (kể cả ngày 0) để vẽ biểu đồ. Gom tag theo `focusTagId` (không có tag thì theo nhãn) và nhận `tagTitles` để **đổi tên tag thì report cũ cũng đổi theo**. `bucketDaySummaries()` + `autoBucketUnit()` gom cột theo tháng khi khoảng > 62 ngày (xem theo năm).
- **Trang**: `PomodoroPage` (ring tiến độ + nhãn tag bấm được + preset 15/25/45/60 + Dừng/Bắt đầu/Bỏ qua) và `PomodoroReportPage` (bộ lọc **Tuần này / Tháng này / Năm nay / Tuỳ chọn** — tuỳ chọn dùng `showDateRangePicker` từ ngày → đến ngày; 4 thẻ tổng quan, cột theo ngày/tháng, mục **Focus trend** = tỉ trọng thời gian theo tag, danh sách phiên gần đây + xoá). Khoảng tuần/tháng/năm luôn kết thúc ở hôm nay. Chọn việc lấy task hôm nay qua `features/tasks/domain` (import xuyên feature hợp lệ vì chỉ qua barrel domain).

## Feature Typing (`features/typing/`) — tab "Typing"

Bài test gõ phím theo thời gian, 2 ngôn ngữ Anh/Việt; kết quả lưu kèm ngày giờ.
- **Mô hình**: DB **schemaVersion 8** (v7 tạo `typing_result_table`, v8 tạo `typing_content_pack_table`). `TypingResultTable` lưu mỗi lần làm bài (`takenAt` = ngày giờ kết thúc, `language` 'en'/'vi', `mode` 'words'/'paragraph', `durationSeconds` đã chọn vs `elapsedSeconds` thực tế, `typedChars`/`correctChars`/`incorrectChars`/`correctWords`, `wpm` + `accuracy` dạng REAL).
- **Đo tốc độ**: `computeTypingMetrics()` + `typingCharStates()` (hàm thuần ở `features/typing/domain/typing_metrics.dart`, có unit test). Quy ước chuẩn: **1 từ = 5 ký tự ĐÚNG**, `wpm = (correctChars/5) / phút`, `rawWpm` tính trên mọi ký tự đã gõ, `accuracy = correctChars/typedChars`. So sánh **theo rune** nên chữ tiếng Việt có dấu tính là 1 ký tự. Ký tự gõ dư quá độ dài đề đều tính là sai. `TypingResult.wps`/`TypingMetrics.wps` chỉ là `wpm/60`.
- **Nội dung đề bài** = **nội dung có sẵn (assets) + gói người dùng tự import (DB)**, gộp trong `TypingContentRepositoryImpl.getBank()`. Gói đọc lại mỗi lần gọi (không cache) để import xong dùng được ngay.
  - *Có sẵn*: mọi file `.json` trong `assets/typing/<mã ngôn ngữ>/` (`TypingContentAssetDataSource` dùng `AssetManifest` tự phát hiện file, cache theo ngôn ngữ). Thả thêm file JSON vào thư mục là xong, KHÔNG sửa code/pubspec (pubspec khai báo cả thư mục) — xem `assets/typing/README.md`. Dùng khi muốn nội dung đi kèm bản cài.
  - *Người dùng import*: `TypingContentPackTable` (tên gói, ngôn ngữ, `wordsJson`/`paragraphsJson`, `addedAt`) — mỗi lần import là 1 "gói", xoá được cả gói. UI ở `TypingContentPage` (icon 📚 trên `TypingPage`): chọn file `.json/.csv/.txt` bằng `file_selector`, hoặc dán tay. Đóng trang trả `true` nếu có thay đổi → `TypingCubit.reloadContent()` nạp lại kho + sinh đề mới.
  - ⚠️ `XTypeGroup` phải khai `uniformTypeIdentifiers` (`public.json`, `public.comma-separated-values-text`, `public.plain-text`) — iOS/macOS lọc theo **UTI**, chỉ có `extensions` thì `openFile` ném lỗi trên iOS. macOS cần entitlement `com.apple.security.files.user-selected.read-only` ở cả Debug lẫn Release.
- **Đọc nội dung import**: `parseTypingContent()` (thuần, có test) nhận JSON (object `{words, paragraphs}` hoặc mảng chuỗi) lẫn văn bản/CSV. Với văn bản, xử lý theo từng dòng: dòng tách bằng dấu phẩy ra **toàn mảnh không có khoảng trắng** → danh sách từ (`the, and, people`); còn lại cả dòng là đoạn văn nếu có khoảng trắng. Nhờ vậy câu có dấu phẩy không bị cắt đôi mà CSV vẫn tách đúng.
- `buildPrompt()` (thuần, có test) sinh đề: chế độ `words` rút ngẫu nhiên `wordCountForDuration()` từ; chế độ `paragraph` lấy 1 đoạn, kho chưa có đoạn thì tự lùi về `words`.
- **Đồng hồ**: `TypingCubit` đếm ngược theo **mốc deadline đồng hồ thật** (giống pomodoro) — bắt đầu ở ký tự đầu tiên, chốt khi hết giờ hoặc gõ hết đề. Bài < 5 giây hoặc chưa gõ ký tự nào thì không lưu. Đổi ngôn ngữ/chế độ/thời lượng chỉ được khi bài chưa chạy.
- **Nhập liệu**: dùng `TextField` thật (không bắt phím thô) để **bộ gõ tiếng Việt telex/VNI hoạt động**; tắt `autocorrect`/`enableSuggestions` để máy không sửa hộ làm sai số liệu.
- **Hiển thị đề** (`TypingPromptView`): tô màu từng ký tự đúng/sai/chưa gõ, ô cao đúng 3 dòng và **cuộn theo từng DÒNG** — gõ trong một dòng thì đề đứng yên, hết dòng mới trượt lên đúng 1 dòng (cuộn mượt theo tiến độ ký tự làm rối mắt). Vị trí dòng lấy từ `TextPainter` đo trên đúng bề rộng + kiểu chữ đang vẽ (`getOffsetForCaret`), cache lại và chỉ đo lại khi đổi đề/đổi bề rộng. `NeverScrollableScrollPhysics` để người dùng không kéo tay làm lệch dòng.
- **Thống kê**: `summarizeTyping()` (thuần, có unit test) gom kết quả → tổng/**theo ngày**/theo ngôn ngữ/streak; mọi ngày trong khoảng đều có mặt (kể cả ngày 0) để vẽ biểu đồ. `bucketTypingDays()` + `autoTypingBucketUnit()` gom cột theo tháng khi khoảng > 62 ngày.
- **Trang**: `TypingPage` (chip ngôn ngữ/chế độ/thời lượng + đồng hồ & WPM chạy realtime + đề đã tô màu + ô nhập + thẻ kết quả + dải kết quả hôm nay) và `TypingHistoryPage` (bộ lọc **Tuần này / Tháng này / Năm nay / Tuỳ chọn**, 4 thẻ tổng quan, cột WPM tốt nhất theo ngày/tháng, so sánh theo ngôn ngữ, danh sách bài gần đây + xoá).

## macOS: menu bar + cửa sổ nổi (`core/desktop/`)

Trên macOS pomodoro chạy như một app menu bar, đồng hồ không phụ thuộc cửa sổ.
- **`PomodoroCubit` là `@lazySingleton`**, cung cấp ở gốc `app.dart` bằng `BlocProvider.value` → đổi tab / ẩn cửa sổ không reset phiên. Trang Focus chỉ hiển thị, KHÔNG tự tạo cubit.
- **`DesktopWindowService`** (`core/desktop/`, dùng `window_manager`): `init()` phải gọi **trước `runApp`**; đặt cỡ cửa sổ (thường 520×780, mini 280×330), ghim trên cùng, ẩn/hiện. Bấm nút đóng chỉ ẩn (`setPreventClose(true)` + `AppDelegate.applicationShouldTerminateAfterLastWindowClosed = false`) → thoát hẳn bằng menu "Thoát" ở menu bar. Mọi hàm no-op trên iOS/Android nên UI gọi thẳng, không rải `Platform.isMacOS`.
- **`PomodoroTrayController`** (`features/pomodoro/presentation/desktop/`, dùng `tray_manager`): nghe `PomodoroCubit.stream`, `setTitle` mm:ss mỗi giây; **menu chỉ dựng lại khi phase/runStatus/label/miniMode đổi**, không dựng mỗi tick. `start()` gọi sau frame đầu vì `setIcon` đọc asset qua rootBundle. `tray_manager` chỉ tạo status item khi `setIcon` được gọi → luôn setIcon trước setTitle. Icon: `assets/tray/tray_icon.png` (template đơn sắc, macOS tự tô màu).
- **Cửa sổ nổi nhỏ**: `DesktopWindowService.miniMode` → `MainShell` đổi sang `PomodoroMiniView` (bỏ bottom nav) + cửa sổ thu nhỏ và ghim trên cùng.
- **Thông báo**: macOS có implementation riêng — phải xin quyền qua `MacOSFlutterLocalNotificationsPlugin` (resolve theo `IOSFlutterLocalNotificationsPlugin` trả null → thông báo im lặng).
- **Verify trên macOS**: terminal thường không có quyền Screen Recording nên `screencapture` chỉ chụp được hình nền. Kiểm tra bằng `CGWindowListCopyWindowInfo` (script Swift): cửa sổ chính = layer 0, ghim trên cùng = layer 3, status item menu bar = layer 25 (bề rộng item tăng khi có title mm:ss).

## Thêm feature mới

1. Table + DAO vào `core/database/drift/` → `--force-jit` để sinh code.
2. Entity + repository interface: nếu dùng chung nhiều feature → `core/domain`; nếu riêng → `features/<feature>/domain`.
3. `data/` (datasource + mapper + repo impl), `domain/usecases`, `presentation/` (bloc + page).
4. Đánh annotation injectable (`@LazySingleton(as: ...)`, `@injectable`), tạo barrel `index.dart` cho từng tầng theo quy tắc trên.
5. Đăng ký object thư viện bên thứ 3 (không annotation) trong `core/di/register_module.dart`.
