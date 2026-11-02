# Habitool: bộ nhận diện

Tagline: **Small tools for daily habits.**

## Logo

Chữ H ghép từ 7 ô trên lưới 3×3, tương ứng dải 7 ngày của trang Tracking. Ô giữa có dấu tích là hôm nay, cột phải màu nhạt là các ngày tới.

- Mỗi ô 28 đơn vị, khe 6, bo góc 9. Toàn bộ logo rộng 96.
- Từ 28 px trở lên dùng `habitool-mark*.svg`. Dưới 28 px dùng `habitool-mark-micro.svg`.
- Khoảng trống quanh logo tối thiểu bằng 1 ô.
- Chữ trong logo đã chuyển thành nét vẽ từ Be Vietnam Pro ExtraBold, nên không cần cài font.

## Thư mục

| Đường dẫn | Nội dung |
|---|---|
| `brand-book.html` | Trang hướng dẫn nhận diện, mở bằng trình duyệt |
| `logo/` | Logo ngang, xếp dọc, biểu tượng và phần chữ (SVG) |
| `app-icon/` | Icon đã xuất cho iOS, Android, macOS, web và menu bar (PNG) |
| `app-icon/source/` | Bản gốc của icon (SVG) |

## Màu

Giao diện dùng token trong `lib/core/theme/app_colors.dart`. Các màu sau chỉ dành cho logo và icon:

| Màu | Dùng cho |
|---|---|
| `#94AFF9` | Cột phải của logo trên nền sáng |
| `#4A5FAF` | Cột phải của logo trên nền tối |
| `#A9C0FB` | Cột phải của logo trên nền xanh |
| `#5B86F7` → `#2C53D8` | Nền icon app |

## Chữ

Be Vietnam Pro (giấy phép SIL Open Font License), nằm ở `assets/fonts/`. Font này không có số đều, nên đồng hồ và số liệu chạy dùng bản `BeVietnamProTabular`, sinh bằng `tools/make_tabular_font.py`.
