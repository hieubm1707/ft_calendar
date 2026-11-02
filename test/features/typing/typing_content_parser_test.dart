import 'package:example_app/features/typing/domain/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JSON', () {
    test('object có words + paragraphs', () {
      final r = parseTypingContent(
          '{"words": ["the", "and"], "paragraphs": ["Một câu hoàn chỉnh."]}');

      expect(r.words, ['the', 'and']);
      expect(r.paragraphs, ['Một câu hoàn chỉnh.']);
    });

    test('thiếu một khoá vẫn đọc được', () {
      expect(parseTypingContent('{"words": ["mua"]}').paragraphs, isEmpty);
      expect(parseTypingContent('{"words": ["mua"]}').words, ['mua']);
    });

    test('mảng chuỗi: phần tử có khoảng trắng là đoạn văn', () {
      final r = parseTypingContent('["mua", "nang", "Trời hôm nay đẹp."]');

      expect(r.words, ['mua', 'nang']);
      expect(r.paragraphs, ['Trời hôm nay đẹp.']);
    });

    test('bỏ qua phần tử sai kiểu và chuỗi rỗng', () {
      final r = parseTypingContent('{"words": ["mua", 5, "", null, "gio"]}');

      expect(r.words, ['mua', 'gio']);
    });
  });

  group('văn bản / CSV', () {
    test('dòng không có khoảng trắng tách thành từ theo dấu phẩy', () {
      final r = parseTypingContent('the,and,people\nwater');

      expect(r.words, ['the', 'and', 'people', 'water']);
      expect(r.paragraphs, isEmpty);
    });

    test('dòng có khoảng trắng giữ nguyên làm đoạn văn, KHÔNG cắt ở dấu phẩy',
        () {
      final r = parseTypingContent(
          'Mỗi buổi sáng, tôi pha một cốc cà phê và ngồi xuống bàn.');

      expect(r.paragraphs, [
        'Mỗi buổi sáng, tôi pha một cốc cà phê và ngồi xuống bàn.',
      ]);
      expect(r.words, isEmpty);
    });

    test('CSV có khoảng trắng sau dấu phẩy vẫn là danh sách từ', () {
      final r = parseTypingContent('the, and, people');

      expect(r.words, ['the', 'and', 'people']);
      expect(r.paragraphs, isEmpty);
    });

    test('câu có dấu phẩy KHÔNG bị cắt đôi thành 2 đoạn', () {
      final r = parseTypingContent(
          'Mỗi buổi sáng, tôi pha cà phê rồi ngồi xuống bàn làm việc.');

      expect(r.paragraphs, hasLength(1));
      expect(r.words, isEmpty);
    });

    test('trộn lẫn từ và đoạn văn trong cùng một file', () {
      final r = parseTypingContent('mua,nang\nTrời hôm nay đẹp.\ngio');

      expect(r.words, ['mua', 'nang', 'gio']);
      expect(r.paragraphs, ['Trời hôm nay đẹp.']);
    });

    test('bỏ dòng rỗng và cắt khoảng trắng thừa', () {
      final r = parseTypingContent('  mua  \n\n\n  gio ,  may  \n');

      expect(r.words, ['mua', 'gio', 'may']);
    });
  });

  group('đầu vào không dùng được', () {
    test('chuỗi rỗng', () {
      expect(parseTypingContent('   ').words, isEmpty);
      expect(parseTypingContent('   ').paragraphs, isEmpty);
    });

    test('JSON hỏng thì lùi về đọc như văn bản thuần, không ném lỗi', () {
      final r = parseTypingContent('{"words": [');

      // Đọc như văn bản: dòng có khoảng trắng → đoạn văn.
      expect(r.paragraphs, ['{"words": [']);
    });
  });
}
