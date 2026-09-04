import '../../../../core/database/drift/index.dart';
import '../../domain/index.dart';

extension TypingResultRowMapper on TypingResultTableData {
  TypingResult toEntity() => TypingResult(
        id: id,
        takenAt: takenAt,
        language: TypingLanguage.fromCode(language),
        mode: TypingMode.fromCode(mode),
        durationSeconds: durationSeconds,
        elapsedSeconds: elapsedSeconds,
        typedChars: typedChars,
        correctChars: correctChars,
        incorrectChars: incorrectChars,
        correctWords: correctWords,
        wpm: wpm,
        accuracy: accuracy,
      );
}

extension TypingResultEntityMapper on TypingResult {
  TypingResultTableCompanion toInsertCompanion() =>
      TypingResultTableCompanion.insert(
        takenAt: takenAt,
        language: language.code,
        mode: mode.code,
        durationSeconds: durationSeconds,
        elapsedSeconds: elapsedSeconds,
        typedChars: typedChars,
        correctChars: correctChars,
        incorrectChars: incorrectChars,
        correctWords: correctWords,
        wpm: wpm,
        accuracy: accuracy,
      );
}
