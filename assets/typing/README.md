# Nội dung bài test gõ phím

Mỗi ngôn ngữ là một thư mục theo mã: `en/` (Tiếng Anh), `vi/` (Tiếng Việt).

App nạp **mọi file `.json`** trong thư mục ngôn ngữ rồi gộp lại (bỏ trùng).
Muốn thêm từ / đoạn văn mới: **thả thêm 1 file JSON vào đúng thư mục** rồi chạy
lại app — không phải sửa code. Không cần khai báo thêm gì trong `pubspec.yaml`
vì cả thư mục đã được khai báo.

## Định dạng

```json
{
  "words": ["the", "and", "people"],
  "paragraphs": ["Một đoạn văn hoàn chỉnh, có hoa và dấu câu."]
}
```

- `words` — từ đơn, dùng cho chế độ "Từ ngẫu nhiên".
- `paragraphs` — đoạn văn, dùng cho chế độ "Đoạn văn".
- Cả hai khoá đều tuỳ chọn; file chỉ có `words` hoặc chỉ có `paragraphs` đều hợp lệ.

Cũng chấp nhận mảng chuỗi ở cấp cao nhất — phần tử **có khoảng trắng** được coi
là đoạn văn, còn lại là từ:

```json
["mưa", "nắng", "Một đoạn văn ngắn để luyện gõ."]
```

Chuỗi rỗng và phần tử sai kiểu bị bỏ qua, nên một dòng hỏng không làm hỏng cả file.

## Ví dụ

```
assets/typing/vi/basic.json      # có sẵn
assets/typing/vi/tin-tuc.json    # bạn thêm vào
assets/typing/en/basic.json      # có sẵn
assets/typing/en/tech.json       # bạn thêm vào
```
