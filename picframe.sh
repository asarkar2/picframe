#!/bin/bash

## TODO:
# *) [D] Remove -i flag. Support only jpg, jpeg, png, gif and their
#       capital version

## Picture frame via conky
## Author: Anjishnu Sarkar
## Acknowledgment(s):
##  *)  All the imagemagick codes are taken from
##      http://www.imagemagick.org/Usage/thumbnails/index.html
##      http://www.imagemagick.org/Usage/advanced/

## Requirement(s):
##  *) Conky version 1.10.8 with Imlib2 support
##  *) Imagemagick
##  *) Bash

## Install:
## mkdir -p ~/bin/
## chmod +x picframe.sh
## mv picframe.sh ~/bin/

## Version:
## 1.4) Updated conkyrc to lua scripting language
## 1.2) Added tacks to polaroid frame-type.
## 1.1) Added shawdow to wooden frame-type.
##      Added option of polaroid, torn-paper, torn-paper-edge for frame-type.
##      Added option to source local rc file
## 1.0) Initial build

## Variables
ThumbWidth=136
ThumbHeight=102
Angle=15
FrameType="polaroid"
Version=1.5

ScriptName=$(basename $0)
CurrentFolder="."
pixfolder="$CurrentFolder"/pix
outfilepath="$pixfolder"/image.png
PicFrameConky="$CurrentFolder"/"$ScriptName".conkyrc
UpdateConky="False"
RCFile="$CurrentFolder"/"$ScriptName".rc
Alignment="bottom_right"
XGap=5
YGap=25
AllFrameTypes="none, wooden, polaroid, polaroid-tack, torn-paper, torn-paper-edge"
# polaroid-tack
HelpText="Usage:
$ScriptName [options] your-imagefile > picframe.conkyrc
conky -c picframe.conkyrc

Options:
-h|--help               Show this help and exit.
-r|--rotate  <angle>    Rotate image by an angle <angle>. Default: $Angle degrees.
-f|--frame <frame-type>
                        Sets frame-type to <frame-type>. Options are
                        "$AllFrameTypes".
                        Default: $FrameType.
-sf|--show-frames       Show all frame types.
-iw|--width <width>     Set image width. Default: "$ThumbWidth".
-ih|--height <height>   Set image width. Default: "$ThumbHeight".
-a|--alignment <alignment>
                        Image alignment position. Options are top_left,
                        top_right, top_middle, bottom_left, bottom_right,
                        bottom_middle, middle_left, middle_middle,
                        middle_right, or none (also can be abreviated as
                        tl, tr, tm, bl, br, bm, ml, mm, mr)
                        Default: $Alignment.
-xgap <x-gap>           Gap, in pixels, between right or left border of screen.
                        Default: $XGap.
-ygap <y-gap>           Gap, in pixels, between top or bottom border of screen.
                        Default: $YGap.
-u|--update-conkyrc     Updates conkyrc.
-n|--no-update-conkyrc  Don't update conkyrc. Default.
-v|--version            Show version number and exit.
"
ErrMsg="$ScriptName: Unspecified option. Aborting."

## Source options from rc file.
if [ -f "$RCFile" ];then
    source "$RCFile"
fi

while test -n "${1}"
do
    case "${1}" in
    -h|--help)      echo -n "$HelpText"
                    exit 0 ;;
    *.[jJ][pP][gG] | *.[jJ][pP][eE][gG] | *.[pP][nN][gG] | *.[gG][iI][fF])
                    InputFile="$1"
                    ;;
    -r|--rotate)    Angle="$2"
                    shift ;;
    -f|--frame)     FrameType="$2"
                    shift ;;
    -sf|--show-frames) echo "Supported frame types are:"
                       echo " ${AllFrameTypes}".
                    exit 0 ;;
    -iw|--width)    ThumbWidth="$2"
                    shift ;;
    -ih|--height)   ThumbHeight="$2"
                    shift ;;
    -a|--alignment) Alignment="$2"
                    shift ;;
    -xgap)          XGap="$2"
                    shift ;;
    -ygap)          YGap="$2"
                    shift ;;
    -u|--update-conkyrc)   UpdateConky="True"
                    ;;
    -n|--no-update-conkyrc)   UpdateConky="False"
                    ;;
    -v|--version)   echo ""$ScriptName": Version "$Version""
                    exit 0 ;;
    *)              echo "$ErrMsg"
                    exit 1 ;;
    esac
    shift
done

if [ ! -f "$InputFile" ];then
    echo "Image file not found. Aborting."
    exit 1
else
    mkdir -p "$pixfolder"
fi

case "$FrameType" in
    none)
        convert "$InputFile" -resize ${ThumbWidth}x${ThumbHeight}'>' \
            -background none -rotate $Angle \
            "$outfilepath"
            ;;
    wooden)
        convert "$InputFile" -resize "$ThumbWidth"x"$ThumbHeight"'>' \
            -mattecolor peru -frame 9x9+3+3 \
            -background  black  \( +clone -shadow 60x4+4+4 \) +swap \
            -background  none   -flatten \
            -background none -rotate $Angle \
            "$outfilepath"
            ;;
    polaroid)
        convert "$InputFile" -resize ${ThumbWidth}x${ThumbHeight}'>' \
            -bordercolor grey60 -border 1 \
            -bordercolor white  -border 6 \
            -bordercolor grey60 -border 1 \
            -background  black  \( +clone -shadow 60x4+4+4 \) +swap \
            -background  none   -flatten \
            -background none -rotate $Angle \
            "$outfilepath"
            ;;
    polaroid-tack)
        TackImg=""$pixfolder"/bullet3D.png"
        convert \( -size 70x70 xc:none -draw 'circle 35,35 10,30' \) -matte \
            \( +clone -channel A -separate +channel \
            -bordercolor black -border 5 -blur 0x5 -shade 120x30 \
            -normalize -blur 0x1 -fill red -tint 100 \) \
            -gravity center -compose Atop -composite \
            -resize 30x30 \
            "$TackImg"
#             -flip -flop \
        TmpFile=""$pixfolder"/"$RANDOM".png"
        ExtraHeight=10
        convert "$InputFile" -resize ${ThumbWidth}x${ThumbHeight}'>' \
            -bordercolor grey60 -border 1 \
            -bordercolor white  -border 6 \
            -bordercolor grey60 -border 1 \
            "$TmpFile"

        NewThumbWidth=$(identify -format '%w' "$TmpFile")
        NewThumbHeight=$(echo "$(identify -format '%h' "$TmpFile")\
            +"$ExtraHeight"" | bc)

        convert -size ${NewThumbWidth}x${NewThumbHeight} xc:none \
            \( "$TmpFile" \) \
            -gravity South -composite \
            \( "$TackImg" \) \
            -gravity North -composite \
            -background  black  \( +clone -shadow 60x4+4+4 \) +swap \
            -background  none   -flatten \
            -background none -rotate $Angle \
            "$outfilepath"
        rm -f "$TmpFile" "$TackImg"
            ;;
    torn-paper)
        convert "$InputFile" -resize ${ThumbWidth}x${ThumbHeight}'>' \
            \( +clone -threshold -1 -virtual-pixel black \
            -spread 10 -blur 0x3 -threshold 50% -spread 1 -blur 0x.7 \) \
            -alpha off -compose Copy_Opacity -composite \
            -background none -rotate $Angle \
            "$outfilepath"
            ;;
    torn-paper-edge)
        convert "$InputFile" -resize ${ThumbWidth}x${ThumbHeight}'>' \
            -bordercolor linen -border 8x8 \
            -background Linen  -gravity SouthEast -splice 10x10+0+0 \
            \( +clone -alpha extract -virtual-pixel black \
            -spread 10 -blur 0x3 -threshold 50% -spread 1 -blur 0x.7 \) \
            -alpha off -compose Copy_Opacity -composite \
            -gravity SouthEast -chop 10x10 \
            -background none -rotate $Angle \
            "$outfilepath"
            ;;
    torn-paper-border)
        convert "$InputFile" -resize ${ThumbWidth}x${ThumbHeight}'>' \
            -bordercolor linen -border 8x8 \
            \( +clone -alpha extract -virtual-pixel black \
            -spread 10 -blur 0x3 -threshold 50% -spread 1 -blur 0x.7 \) \
            -alpha off -compose Copy_Opacity -composite \
            -background none -rotate $Angle \
            "$outfilepath"
            ;;
    *)      echo "$ScriptName: Unknown frame-type. Aborting.
Known frame-types are: "$AllFrameTypes"."
            exit 1
            ;;
esac

ImgWidth=$(identify -format %w "$outfilepath")
ImgHeight=$(identify -format %h "$outfilepath")

if [ "$UpdateConky" == "True" ];then
    echo "conky.config = {
-- Conkyrc for picframe
	background = true,

	update_interval = 1,
	total_run_times = 0,
	net_avg_samples = 2,

	override_utf8_locale = true,

	double_buffer = true,
	no_buffers = true,

	text_buffer_size = 2048,
	imlib_cache_size = 0,

-- Window specifications

	own_window = true,
-- 	own_window_type = 'desktop',
-- 	own_window_type = 'normal',
	own_window_type = 'override',
	own_window_transparent = true,
	own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',

	border_inner_margin = 0,
	border_outer_margin = 0,

	minimum_width = $ImgWidth, minimum_height = $ImgHeight,

	alignment = ${Alignment},
	gap_x = ${XGap},
	gap_y = ${YGap},

-- - Graphics settings - #
	draw_shades = false,
	draw_outline = false,
	draw_borders = false,
	draw_graph_borders = false,

-- — Text settings — #
	use_xft = true,
	font = 'Bitstream Vera Sans Mono:size=9',
	xftalpha = 0.8,

	default_color = '#FFFFFF',
	default_gauge_width = 47, default_gauge_height = 25,

	uppercase = false,
	use_spacer = 'right',

	color0 = 'white',
	color1 = 'orange',
	color2 = 'green',
};

conky.text = [[
\${image ${outfilepath} -p 0,0 -s ${ImgWidth}x${ImgHeight}}

]];
"
else
    echo "Image Width : ${ImgWidth}"
    echo "Image Height: ${ImgHeight}"
fi

