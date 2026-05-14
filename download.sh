#!/bin/bash
# download.sh - دانلود APK از گوگل پلی با استخراج خودکار شناسه برنامه

set -e  # در صورت بروز خطا متوقف شود

# تابع راهنما
usage() {
    echo "Usage: $0 <Google-Play-URL-or-App-ID>"
    echo "Example: $0 https://play.google.com/store/apps/details?id=com.instagram.android"
    echo "Or: $0 com.instagram.android"
    exit 1
}

# بررسی ورودی
if [ $# -eq 0 ]; then
    echo "❌ خطا: هیچ ورودی داده نشده است."
    usage
fi

INPUT="$1"

# استخراج شناسه برنامه از لینک یا استفاده مستقیم
if [[ "$INPUT" == *"play.google.com"* ]]; then
    # استخراج مقدار id=... از لینک
    APP_ID=$(echo "$INPUT" | grep -oP '(?<=id=)[^&]+')
    if [ -z "$APP_ID" ]; then
        echo "❌ خطا: لینک معتبر گوگل پلی حاوی 'id=' یافت نشد."
        usage
    fi
else
    APP_ID="$INPUT"
fi

# بررسی نشدن مقدار None یا خالی
if [[ -z "$APP_ID" || "$APP_ID" == "None" ]]; then
    echo "❌ خطا: شناسه برنامه نامعتبر است ('$APP_ID'). لطفاً یک شناسه واقعی وارد کنید."
    usage
fi

echo "✅ شناسه برنامه استخراج شد: $APP_ID"

# رفتن به پوشه ابزار و اجرای دانلود
cd gplay-apk-downloader || { echo "❌ پوشه gplay-apk-downloader یافت نشد"; exit 1; }

echo "🔄 در حال دانلود APK برای معماری arm64..."
./gplay download "$APP_ID" -a arm64 -o ../downloads -m

if [ $? -eq 0 ]; then
    echo "✅ دانلود با موفقیت کامل شد. فایل در پوشه ../downloads قرار دارد."
else
    echo "❌ دانلود ناموفق بود. ممکن است برنامه در منطقه شما دردسترس نباشد یا نیاز به توکن گوگل داشته باشید."
    exit 1
fi
