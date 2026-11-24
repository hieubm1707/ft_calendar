#!/usr/bin/env python3
"""Sinh sprite cá voi 52Hz cho màn Focus toàn màn hình.

Vào: branding/mascot/52hz_swim_sheet.png (lưới 3x3, ảnh AI, frame 1 đuôi cao
nhất, frame 9 đuôi thấp nhất, frame 5 đuôi thẳng).
Ra:  assets/mascot/52hz_swim.png (lưới 3x3, các ô cùng cỡ, mắt cùng toạ độ, sắp
theo đuôi từ cao xuống thấp).

Ảnh gốc có 3 lỗi phải xử lý:
- Nền còn nhiễu alpha thấp và thân cá hơi trong suốt → dựng lại alpha từ hình
  bao của con cá.
- Viền còn ám màu từ nền cũ → gọt viền rồi loang màu trong thân ra ngoài.
- Ảnh AI vẽ lại đầu ở từng frame, chạy lên sẽ thấy rung → cả 9 frame dùng chung
  đầu của frame 5, chỉ giữ riêng phần đuôi.
- Ảnh AI không vẽ đuôi đúng thứ tự (frame 3 thấp hơn frame 4, 5), phát ra sẽ giật
  → đo độ cao đuôi rồi sắp lại.

Chạy lại khi thay ảnh gốc (cần pillow, numpy, scipy):
  python3 branding/tools/make_whale_sprite.py
"""
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage as ni

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "branding/mascot/52hz_swim_sheet.png"
OUT = ROOT / "assets/mascot/52hz_swim.png"

# Cỡ một ô và vị trí mắt trong ô. Giữ khớp với WhaleSprite trong
# lib/features/pomodoro/presentation/widgets/whale_swimmer.dart.
CELL_W, CELL_H = 384, 232
EYE_X, EYE_Y = 292, 118
COLS, ROWS = 3, 3
NEUTRAL = 4  # frame 5, đếm từ 0

# Phần đầu lấy từ frame 5: từ SPLIT_X (tính từ mắt) về bên phải; chuyển tiếp mượt
# trên FEATHER điểm ảnh để không lộ đường nối.
SPLIT_X = EYE_X - 118
FEATHER = 44

# Vùng tính là đuôi khi đo độ cao, tính từ mép trái ô.
TAIL_W = 90

MIN_AREA = 1500
LUM_EYE = 60
ERODE = 1
# Làm mượt hình bao (viền ảnh AI bị gợn) rồi mới tạo viền mềm chống răng cưa.
SMOOTH_SIGMA = 1.8
EDGE_SIGMA = 0.7


def find_whales(rgba: np.ndarray) -> list[np.ndarray]:
    """Trả về mặt nạ từng con cá, sắp theo hàng rồi cột."""
    lab, n = ni.label(rgba[..., 3] >= 128)
    found = []
    for i, box in enumerate(ni.find_objects(lab), 1):
        if (lab[box] == i).sum() >= MIN_AREA:
            found.append((box[0].start, box[1].start, ni.binary_fill_holes(lab == i)))
    if len(found) != COLS * ROWS:
        raise SystemExit(f"Cần {COLS * ROWS} con cá, tìm thấy {len(found)}")
    row_h = rgba.shape[0] / ROWS
    found.sort(key=lambda f: (int(f[0] // row_h), f[1]))
    return [f[2] for f in found]


def eye_center(rgba: np.ndarray, mask: np.ndarray) -> tuple[int, int]:
    """Mắt là mảng tối lớn nhất trong thân cá."""
    dark = (rgba[..., :3].mean(axis=2) < LUM_EYE) & mask
    lab, n = ni.label(dark)
    sizes = ni.sum(dark, lab, range(1, n + 1))
    cy, cx = ni.center_of_mass(lab == int(np.argmax(sizes)) + 1)
    return int(round(cx)), int(round(cy))


def cut_frame(rgba: np.ndarray, mask: np.ndarray) -> np.ndarray:
    """Đặt con cá vào ô chuẩn theo mắt, alpha sạch, màu không ám viền."""
    ex, ey = eye_center(rgba, mask)
    solid = ni.binary_erosion(mask, iterations=ERODE)
    solid = ni.gaussian_filter(solid.astype(float), SMOOTH_SIGMA) > 0.5
    # Loang màu trong thân ra ngoài để lọc ảnh không kéo màu nền cũ vào viền.
    idx = ni.distance_transform_edt(~solid, return_distances=False, return_indices=True)
    rgb = rgba[..., :3][idx[0], idx[1]]
    alpha = np.clip(ni.gaussian_filter(solid.astype(float), EDGE_SIGMA) * 255, 0, 255)

    h, w = mask.shape
    x0, y0 = ex - EYE_X, ey - EYE_Y
    out = np.zeros((CELL_H, CELL_W, 4), dtype=float)
    sx0, sy0 = max(x0, 0), max(y0, 0)
    sx1, sy1 = min(x0 + CELL_W, w), min(y0 + CELL_H, h)
    dx, dy = sx0 - x0, sy0 - y0
    out[dy : dy + sy1 - sy0, dx : dx + sx1 - sx0, :3] = rgb[sy0:sy1, sx0:sx1]
    out[dy : dy + sy1 - sy0, dx : dx + sx1 - sx0, 3] = alpha[sy0:sy1, sx0:sx1]
    return out


def blend_head(frame: np.ndarray, head: np.ndarray) -> np.ndarray:
    """Ghép đầu chung vào frame. Trộn trên màu đã nhân alpha để viền không tối."""
    t = np.clip((np.arange(CELL_W) - SPLIT_X) / FEATHER, 0, 1)
    t = (t * t * (3 - 2 * t))[None, :, None]
    fa, ha = frame[..., 3:] / 255, head[..., 3:] / 255
    premul = frame[..., :3] * fa * (1 - t) + head[..., :3] * ha * t
    alpha = fa * (1 - t) + ha * t
    rgb = np.where(alpha > 1e-3, premul / np.maximum(alpha, 1e-3), head[..., :3])
    return np.dstack([rgb, alpha * 255])


def tail_height(frame: np.ndarray) -> float:
    """Toạ độ y trọng tâm của đuôi: càng nhỏ thì đuôi càng cao."""
    return ni.center_of_mass(frame[:, :TAIL_W, 3] >= 128)[0]


def main() -> None:
    rgba = np.array(Image.open(SRC).convert("RGBA")).astype(float)
    frames = [cut_frame(rgba, m) for m in find_whales(rgba)]
    head = frames[NEUTRAL]
    frames = sorted((blend_head(f, head) for f in frames), key=tail_height)
    print("Độ cao đuôi:", [round(tail_height(f), 1) for f in frames])

    atlas = np.zeros((CELL_H * ROWS, CELL_W * COLS, 4), dtype=float)
    for i, f in enumerate(frames):
        r, c = divmod(i, COLS)
        atlas[r * CELL_H : (r + 1) * CELL_H, c * CELL_W : (c + 1) * CELL_W] = f
    OUT.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(np.clip(atlas + 0.5, 0, 255).astype(np.uint8)).save(
        OUT, optimize=True
    )
    print(f"{OUT.relative_to(ROOT)}: {OUT.stat().st_size // 1024} KB")


if __name__ == "__main__":
    main()
