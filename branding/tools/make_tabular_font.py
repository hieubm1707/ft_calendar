"""Tạo BeVietnamProTabular-ExtraBold.ttf: bản số đều cho đồng hồ và số liệu chạy.

Be Vietnam Pro không có tính năng `tnum`, chữ số rộng khác nhau nên đồng hồ đếm
ngược bị nhảy. Script giữ nguyên nét vẽ, chỉ đặt 10 chữ số về cùng bề rộng (căn giữa
trong ô), bỏ kerning và giữ lại bảng chữ Latin cơ bản.

Cách chạy (cần `pip install fonttools`):
    python3 make_tabular_font.py <BeVietnamPro-ExtraBold.ttf> <file-ra.ttf>
"""
import sys

from fontTools import subset
from fontTools.ttLib import TTFont

FAMILY = "Be Vietnam Pro Tabular"


def main(src: str, dst: str) -> None:
    font = TTFont(src)

    options = subset.Options()
    options.layout_features = []
    options.hinting = False
    options.name_IDs = ["*"]
    options.notdef_outline = True
    options.drop_tables += ["DSIG", "GPOS", "GSUB", "GDEF", "kern", "hdmx", "VDMX", "LTSH"]
    subsetter = subset.Subsetter(options)
    subsetter.populate(unicodes=range(0x20, 0x7F))
    subsetter.subset(font)

    cmap = font.getBestCmap()
    glyf, hmtx = font["glyf"], font["hmtx"]
    digits = [cmap[ord(c)] for c in "0123456789"]
    width = max(hmtx[g][0] for g in digits)
    for name in digits:
        glyph = glyf[name]
        assert not glyph.isComposite(), name
        advance, lsb = hmtx[name]
        dx = (width - advance) // 2
        glyph.coordinates.translate((dx, 0))
        glyph.recalcBounds(glyf)
        hmtx[name] = (width, lsb + dx)

    for rec in font["name"].names:
        if rec.nameID in (1, 3, 4, 6, 16):
            text = rec.toUnicode()
            text = text.replace("Be Vietnam Pro", FAMILY).replace("BeVietnamPro", FAMILY.replace(" ", ""))
            rec.string = text
    font.save(dst)


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
