import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/index.dart';

part 'typing_content_state.dart';

/// Quản lý kho nội dung gõ phím: xem đang có bao nhiêu từ/đoạn, import thêm
/// (file hoặc dán tay), xoá gói đã import.
@injectable
class TypingContentCubit extends Cubit<TypingContentState> {
  final GetTypingContent _getBank;
  final GetTypingContentPacks _getPacks;
  final AddTypingContentPack _addPack;
  final DeleteTypingContentPack _deletePack;

  TypingContentCubit(
    this._getBank,
    this._getPacks,
    this._addPack,
    this._deletePack,
  ) : super(const TypingContentState());

  /// true nếu người dùng đã thêm/xoá gì đó — trang gọi biết mà nạp lại đề.
  bool get changed => _changed;
  bool _changed = false;

  Future<void> load({TypingLanguage? language}) async {
    final selected = language ?? state.language;
    emit(state.copyWith(
        status: TypingContentStatus.loading, language: selected));

    final packs = await _getPacks(selected);
    final bank = await _getBank(selected);

    emit(packs.fold(
      (failure) => state.copyWith(
          status: TypingContentStatus.failure, errorMessage: failure.message),
      (list) => bank.fold(
        (failure) => state.copyWith(
            status: TypingContentStatus.failure, errorMessage: failure.message),
        (loaded) => state.copyWith(
          status: TypingContentStatus.success,
          packs: list,
          bank: loaded,
        ),
      ),
    ));
  }

  Future<void> changeLanguage(TypingLanguage language) =>
      load(language: language);

  /// Đọc [source] (JSON hoặc văn bản/CSV) rồi lưu thành 1 gói tên [name].
  Future<void> import({required String name, required String source}) async {
    final parsed = parseTypingContent(source);
    if (parsed.words.isEmpty && parsed.paragraphs.isEmpty) {
      emit(state.copyWith(
          status: TypingContentStatus.failure,
          errorMessage: 'Không đọc được từ hay đoạn văn nào trong nội dung này.'));
      return;
    }

    final trimmed = name.trim();
    final result = await _addPack(TypingContentPack(
      name: trimmed.isEmpty ? 'Không tên' : trimmed,
      language: state.language,
      words: parsed.words,
      paragraphs: parsed.paragraphs,
      addedAt: DateTime.now(),
    ));
    if (isClosed) return;

    await result.fold(
      (failure) async => emit(state.copyWith(
          status: TypingContentStatus.failure, errorMessage: failure.message)),
      (_) async {
        _changed = true;
        await load();
        if (!isClosed) {
          emit(state.copyWith(
              message: 'Đã thêm ${parsed.words.length} từ'
                  ' và ${parsed.paragraphs.length} đoạn văn.'));
        }
      },
    );
  }

  Future<void> remove(int id) async {
    final result = await _deletePack(id);
    if (isClosed) return;
    await result.fold(
      (failure) async => emit(state.copyWith(
          status: TypingContentStatus.failure, errorMessage: failure.message)),
      (_) async {
        _changed = true;
        await load();
      },
    );
  }
}
