# ربات بازار آگهی Clash of Clans — cocagahibot

پروژه JavaScript ES Modules روی Cloudflare Workers و Cloudflare D1 است. رابط کاربران و مدیران فقط تلگرام است؛ پنل وب ندارد.

## مشخصات تنظیم‌شده

- Bot: `@cocagahibot`
- مدیر اصلی: `8952746307` (نقش `owner` در Migration)
- مدیر پشتیبانی: `@P10N33RR`
- کانال: `@cocpioneernews`
- `CHANNEL_ID`: `-1003841945394`
- Clan link: `https://link.clashofclans.com/fa?action=OpenClanProfile&tag=2LCP90URY`

## پیش‌نیازها

- Node.js 20 یا بالاتر
- حساب Cloudflare با دسترسی Workers و D1
- ربات ساخته‌شده از BotFather
- ربات باید در کانال `@cocpioneernews` ادمین با مجوز ارسال و ویرایش پیام باشد.

## نصب و راه‌اندازی

```bash
npm install
npx wrangler login
npx wrangler d1 create cocagahi-db
```

شناسه‌ای که دستور D1 برمی‌گرداند را به جای `REPLACE_WITH_D1_DATABASE_ID` در `wrangler.toml` بگذارید. شناسه کانال در فایل حاضر از مالک دریافت شده است.

### تنظیم Secretها

```bash
npx wrangler secret put BOT_TOKEN
npx wrangler secret put WEBHOOK_SECRET
```

برای `WEBHOOK_SECRET` یک رشته تصادفی امن حداقل 32 کاراکتری بسازید. مقدار آن را در Git، پیام‌ها یا لاگ‌ها قرار ندهید.

### Migration و اجرا

```bash
npx wrangler d1 migrations apply DB --remote
npx wrangler dev
```

در ترمینال دوم (یا پس از deploy) Worker را منتشر کنید:

```bash
npx wrangler deploy
```

آدرس Worker را از خروجی Wrangler بردارید و Webhook را بدون قرار دادن توکن در history یا خروجی عمومی ثبت کنید. روش پیشنهادی: از اسکریپت محلی زیر استفاده کنید و مقادیر را در متغیرهای محیطی شل وارد کنید:

```bash
export BOT_TOKEN='توکن-واقعی'
export WEBHOOK_SECRET='رشته-تصادفی-امن'
export WORKER_URL='https://نام-ورکر.نام-حساب.workers.dev'
node scripts/set-webhook.js
```

اسکریپت از متغیرهای محیطی می‌خواند و توکن را چاپ نمی‌کند.

## تنظیمات مدیریتی تلگرام

- `/admin` پنل مدیریت
- `/find ACC-XXXXXX` جست‌وجوی آگهی
- `/addadmin TELEGRAM_ID` افزودن مدیر (فقط مدیر اصلی)
- `/removeadmin TELEGRAM_ID` غیرفعال‌کردن مدیر (فقط مدیر اصلی؛ مالک حذف‌ناپذیر است)
- `/block TELEGRAM_ID` و `/unblock TELEGRAM_ID`
- `/broadcast متن پیام` نمایش پیش‌نمایش و سپس تأیید مدیر برای قرار دادن در صف
- `/history ACC-XXXXXX` مشاهده تاریخچه آگهی
- `/set mature_label عنوان` تغییر عنوان نمایشی گزینه Mature
- `/set mature_description توضیح` تغییر توضیح آن
- `/set clan_leagues Bronze I|Silver I|Gold I` تغییر لیگ‌ها
- `/set max_clan_members 50` تغییر ظرفیت قابل قبول
- `/set account_levels {"barbarian_king_level":100,...}` تعیین سقف سطح قهرمان‌ها به‌صورت JSON

`BOT_TOKEN` و `WEBHOOK_SECRET` در پنل یا D1 نمایش داده نمی‌شوند.

## رفتار فرم‌ها

- ثبت اکانت و کلن با عکس تلگرام، فیلدهای مرحله‌ای، اعداد فارسی/عربی/انگلیسی و پیش‌نمایش.
- نام عددی معتبر است؛ تگ به صورت `#` و حروف/اعداد انگلیسی بررسی می‌شود.
- یک نشست فعال برای هر کاربر در D1 نگهداری می‌شود و بعد از Restart قابل ادامه است.
- هر مرحله داده را ذخیره می‌کند؛ `/cancel` فرم را می‌بندد.
- هر آگهی با کد تصادفی و قید UNIQUE ساخته می‌شود.
- ارسال به مدیر با عکس و دکمه‌های بررسی انجام می‌شود.
- انتشار تنها بعد از تأیید مدیر و وجود Username عمومی فروشنده مجاز است.

## تنظیم کانال و انتشار

ربات را در کانال ادمین کنید. برای انتشار از `sendPhoto` با کپشن و دو دکمه عمودی استفاده می‌شود. شناسه چت کانال و message_id در `channel_posts` ذخیره می‌شوند. تغییر وضعیت فروخته/ناموجود، همان پست را ویرایش و دکمه‌ها را حذف می‌کند.

## وضعیت Mature

معنای این فیلد از طرف مالک تعیین نشده است؛ عنوان اولیه صرفاً «وضعیت Mature» است. معنی آن را حدس نزنید. پیش از انتشار عمومی، عنوان و توضیح دقیق را با `/set mature_label ...` و `/set mature_description ...` تنظیم کنید.

## تست‌ها

```bash
npm test
```

تست‌های واحد، اعتبارسنجی اعداد فارسی، قیمت، متن و تگ را اجرا می‌کنند. این تست‌ها اتصال واقعی Telegram/Cloudflare، تحویل پیام به کانال یا Webhook Production را اثبات نمی‌کنند. برای تست یکپارچه از یک کانال خصوصی و ربات آزمایشی استفاده کنید.

## مشاهده لاگ‌ها

```bash
npx wrangler tail
```

## Backup و Restore D1

```bash
npx wrangler d1 export cocagahi-db --remote --output=backup.sql
npx wrangler d1 execute cocagahi-db --remote --file=backup.sql
```

قبل از Restore، روی دیتابیس آزمایشی بررسی کنید؛ Restore روی دیتابیس زنده ممکن است داده‌ها را جایگزین یا تکراری کند.

## محدودیت‌ها و موارد لازم پیش از بهره‌برداری

1. هیچ توکن، شناسه دیتابیس یا حساب Cloudflare در این بسته وجود ندارد؛ مالک باید آن‌ها را در حساب خودش تنظیم کند.
2. Webhook، ارسال واقعی عکس، مجوز ادمین کانال و D1 Production از این محیط قابل آزمایش نبودند.
3. Telegram Bot API برای `sendPhoto` کلید idempotency ندارد؛ اگر درخواست سمت تلگرام موفق شود اما پاسخ در شبکه گم شود، امکان پیام تکراری وجود دارد. پس از timeout، قبل از Retry باید کانال بررسی شود. پیاده‌سازی در صورت وجود رکورد channel_posts مانع انتشار مجدد می‌شود، اما این پنجره timeout را به صورت ریاضی حذف نمی‌کند.
4. درخواست ویرایش نسخه‌ای با نگهداری نسخه پیشنهادی جداگانه، تأیید مدیر و به‌روزرسانی پست قبلی پیاده‌سازی شده است؛ قبل از Production حتماً جریان editMessageMedia را در کانال آزمایشی تست کنید.
5. کلیک «خرید از فروشنده» یک درخواست خرید باز در D1 ثبت می‌کند و سپس لینک چت فروشنده را به خریدار نشان می‌دهد.
6. پیام همگانی در Cron با دسته‌های 20تایی پردازش می‌شود؛ قبل از استفاده گسترده، محدودیت‌های نرخ تلگرام و زمان اجرای Worker را با حساب واقعی آزمایش کنید.
7. وبهوک‌های تکراری با update_id حذف می‌شوند؛ update ناموفق در جدول ثبت می‌شود اما replay خودکار updateهای شکست‌خورده در این نسخه فعال نیست.
8. حساب‌های اکانت به‌صورت پیش‌فرض از نظر تنظیم پروژه فعال‌اند، اما این به معنی مجازبودن معامله نیست.

## هشدار رسمی Supercell

شرایط استفاده Supercell (نسخه‌ای با تاریخ مؤثر ۶ نوامبر ۲۰۲۴ در زمان بررسی) خرید، فروش، اجاره یا واگذاری حساب بازی را منع می‌کند؛ سیاست Safe and Fair Play نیز صراحتاً خریدوفروش و اشتراک‌گذاری حساب را ناقض شرایط استفاده می‌داند و می‌تواند به تعلیق یا بسته‌شدن حساب منجر شود. این پروژه هیچ تضمینی درباره مجاز بودن معامله، امنیت انتقال یا عدم مسدودسازی ارائه نمی‌کند. قبل از راه‌اندازی عمومی، آخرین نسخه شرایط استفاده رسمی را بررسی کنید:

- https://supercell.com/en/terms-of-service/
- https://supercell.com/en/safe-and-fair-play/

آخرین بررسی وب: ۷ نوامبر ۲۰۲۶. شرایط ممکن است تغییر کند؛ این بررسی جایگزین مشاوره حقوقی نیست.

## ساختار

```text
src/
  index.js
  config.js
  telegram/ (API, keyboards, messages)
  handlers/ (فرم‌ها، callback و بررسی مدیر)
  services/ (اعتبارسنجی، آگهی، انتشار)
  database/ (repository)
  migrations/ (schema و migration)
test/
scripts/
```
