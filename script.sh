browser_app_name="Safari"
key="(ASCII character 29)" # 右矢印キー
page=800
ptslp=0.3
npslp=1.0

# 指定範囲を取得

getX() {
    /usr/libexec/PlistBuddy -c "print :last-selection:X" ~/Library/Preferences/com.apple.screencapture.plist
}
getY() {
    /usr/libexec/PlistBuddy -c "print :last-selection:Y" ~/Library/Preferences/com.apple.screencapture.plist
}
getW() {
    /usr/libexec/PlistBuddy -c "print :last-selection:Width" ~/Library/Preferences/com.apple.screencapture.plist
}
getH() {
    /usr/libexec/PlistBuddy -c "print :last-selection:Height" ~/Library/Preferences/com.apple.screencapture.plist
}

x=`getX`
y=`getY`
w=`getW`
h=`getH`

# スクリーンショットを撮影

mkdir .photos
cd .photos

for i in {1..$page}
do
    screencapture -R $x,$y,$w,$h -x $i.png -t png
    sleep $ptslp
    osascript -e 'tell application "'$browser_app_name'" to activate' -e 'tell application "System Events" to keystroke '$key
    sleep $npslp
done

# PNGをPDFに変換

sips -s format pdf *.png 1>/dev/null 2>/dev/null

# PDFを結合

pdfunite {1..$page}.png ../output.pdf

# PNGファイルを削除

cd ../

rm -rf .photos