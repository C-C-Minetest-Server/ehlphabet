#!/bin/bash

chars=(
    # digits
    "1" "2" "3" "4" "5" "6" "7" "8" "9" "0"

    # base characters
    "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O"
    "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"

    # special characters except whitespace
    "!" "#" "$" "%" "&" "(" ")" "*" "+" "," "-" "." "/" ":" ";"
    "<" "=" ">" "?" "@" "'" '"'

    # german characters
    "Ä" "Ö" "Ü" "ß"

    # cryillic characters
    "А" "Б" "В" "Г" "Д" "Е" "Ё" "Ж" "З" "И" "Й" "К" "Л" "М" "Н"
    "О" "П" "Р" "С" "Т" "У" "Ф" "Х" "Ц" "Ч" "Ш" "Щ" "Ъ" "Ы" "Ь"
    "Э" "Ю" "Я"

    # greek characters
    "Α" "Β" "Γ" "Δ" "Ε" "Ζ" "Η" "Θ" "Ι" "Κ" "Λ" "Μ" "Ν" "Ξ" "Ο"
    "Π" "Ρ" "Σ" "Τ" "Υ" "Φ" "Χ" "Ψ" "Ω"
)

chars_chinese=(
    "非" "常" "可" "愛" "爱" "的" "猫"
    "北" "东" "東" "南" "西" "站"
)

generate_filename() {
    char="$1"
    filename=$(printf "%s" "$char" | od -N 1 -An -tu1 | tr -d ' \n' | xargs -0 printf "%03d")
    second_byte=$(printf "%s" "$char" | od -j 1 -N 1 -An -tu1 | tr -d ' \n' | xargs -0 printf "%03d")
    [ "$second_byte" == "000" ] || filename="$filename"_"$second_byte"
    echo "$filename"
}

for char in "${chars[@]}"; do
    filename=$(generate_filename "$char")
    ./generate_single.sh "$char" "../textures/ehlphabet_char_$filename.png" '/usr/share/fonts/noto/NotoSerif-Bold.ttf'
done

for char in "${chars_chinese[@]}"; do
    filename=$(generate_filename "$char")
    ./generate_single.sh "$char" "../textures/ehlphabet_char_$filename.png" '/usr/share/fonts/noto-cjk/NotoSansCJK-Bold.ttc'
done

magick -size 64x64 xc:white "../textures/ehlphabet_char_base.png"