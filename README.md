# ChunkBox

**ChunkBox** یک دانلودر ساده و کاربردی بر پایه **GitHub Actions** است.  
با این پروژه می‌توانی یک یا چند لینک مستقیم دانلود را به GitHub Action بدهی تا فایل‌ها را دانلود کند، اگر لازم بود آن‌ها را به پارت‌های کوچک‌تر تقسیم کند، و خروجی را داخل ریپو یا GitHub Release ذخیره کند.

---

## فهرست مطالب

- [معرفی](#معرفی)
- [امکانات](#امکانات)
- [ساختار پروژه](#ساختار-پروژه)
- [نصب و راه‌اندازی](#نصب-و-راه‌اندازی)
- [نحوه استفاده](#نحوه-استفاده)
- [ورودی‌های Workflow](#ورودیهای-workflow)
- [ذخیره در ریپو یا Release](#ذخیره-در-ریپو-یا-release)
- [بازیابی فایل‌های چندپارتی](#بازیابی-فایلهای-چندپارتی)
- [بررسی سلامت فایل](#بررسی-سلامت-فایل)
- [فایل manifest.json](#فایل-manifestjson)
- [لینک‌های خصوصی و Secret](#لینکهای-خصوصی-و-secret)
- [خطاهای رایج](#خطاهای-رایج)
- [نکات مهم](#نکات-مهم)
- [ایده‌های آینده](#ایدههای-آینده)
- [هشدار](#هشدار)

---

## معرفی

**ChunkBox** برای زمانی ساخته شده که بخواهی بدون داشتن سرور جداگانه، از خود GitHub Actions به‌عنوان یک دانلودر استفاده کنی.

کافی است لینک مستقیم فایل را به Workflow بدهی. ربات فایل را دانلود می‌کند و اگر حجم فایل زیاد باشد، آن را به پارت‌های کوچک‌تر تقسیم می‌کند تا بتوانی خروجی را راحت‌تر مدیریت کنی.

نام **ChunkBox** از دو بخش تشکیل شده است:

- **Chunk** یعنی تکه یا پارت فایل
- **Box** یعنی جعبه‌ای برای نگهداری فایل‌ها

---

## امکانات

- دانلود فایل از لینک مستقیم
- پشتیبانی از یک یا چند لینک همزمان
- تقسیم خودکار فایل‌های بزرگ به پارت‌های کوچک‌تر
- ذخیره خروجی در دو حالت:
  - داخل ریپو
  - داخل GitHub Release
- ساخت پوشه جدا برای هر دانلود
- ساخت فایل `manifest.json` برای هر فایل
- ساخت فایل `README.md` برای هر دانلود
- ساخت فایل `sha256` برای بررسی سلامت فایل
- ساخت اسکریپت `rebuild.sh` برای اتصال دوباره پارت‌ها
- ساخت اسکریپت `verify.sh` برای بررسی فایل‌های تکی
- جلوگیری از ذخیره فایل تکراری بر اساس SHA256 در حالت `repo`
- پشتیبانی از لینک‌های خصوصی با GitHub Secrets
- نمایش گزارش نهایی در GitHub Actions Summary

---

## ساختار پروژه

ساختار اصلی پروژه به این شکل است:

```text
.github/
  workflows/
    downloader.yml

README.md
```

اگر از حالت `repo` استفاده کنی، خروجی‌ها معمولاً داخل پوشه `downloads` ذخیره می‌شوند:

```text
downloads/
  2026-05-01_153000_001_example_abc123/
    example.zip.part-0000
    example.zip.part-0001
    example.zip.part-0002
    example.zip.sha256
    rebuild.sh
    README.md
    manifest.json
```

اگر فایل کوچک باشد و نیاز به split نداشته باشد، خروجی شبیه این است:

```text
downloads/
  2026-05-01_153000_001_file_abc123/
    file.zip
    file.zip.sha256
    verify.sh
    README.md
    manifest.json
```

---

## نصب و راه‌اندازی

### 1. ساخت فایل Workflow

در ریپوی خودت این مسیر را بساز:

```text
.github/workflows/
```

سپس فایل زیر را داخل آن قرار بده:

```text
.github/workflows/downloader.yml
```

محتوای Workflow همان نسخه‌ای است که برای ChunkBox ساخته شده است.

---

### 2. فعال بودن GitHub Actions

بعد از اینکه فایل `downloader.yml` را commit و push کردی، وارد تب **Actions** در GitHub شو.

باید Workflow با نام زیر را ببینی:

```text
PartFetch Downloader v2
```

اگر خواستی اسم Workflow هم با نام پروژه یکی شود، داخل فایل `downloader.yml` این خط را تغییر بده:

```yaml
name: PartFetch Downloader v2
```

به:

```yaml
name: ChunkBox Downloader
```

---

### 3. دسترسی لازم برای push و release

داخل فایل Workflow باید این بخش وجود داشته باشد:

```yaml
permissions:
  contents: write
```

این دسترسی باعث می‌شود GitHub Action بتواند فایل‌ها را داخل ریپو commit کند یا در حالت `release` فایل‌ها را به GitHub Release آپلود کند.

---

## نحوه استفاده

بعد از نصب Workflow:

1. وارد ریپوی GitHub شو.
2. به تب **Actions** برو.
3. Workflow دانلودر را انتخاب کن.
4. روی **Run workflow** کلیک کن.
5. لینک یا لینک‌های دانلود را وارد کن.
6. حالت ذخیره‌سازی را انتخاب کن.
7. Workflow را اجرا کن.

---

## ورودی‌های Workflow

### `urls`

لینک یا لینک‌های دانلود مستقیم.

برای یک لینک:

```text
https://example.com/file.zip
```

برای چند لینک، هر لینک را در یک خط جدا بگذار:

```text
https://example.com/file1.zip
https://example.com/file2.iso
https://example.com/file3.mp4
```

یا با کاما جدا کن:

```text
https://example.com/file1.zip, https://example.com/file2.iso
```

---

### `storage_mode`

مشخص می‌کند خروجی کجا ذخیره شود.

دو مقدار دارد:

```text
repo
release
```

حالت `repo` فایل‌ها را داخل ریپو ذخیره و commit می‌کند.

حالت `release` فایل‌ها را داخل GitHub Release آپلود می‌کند.

---

### `output_folder`

فقط در حالت `repo` استفاده می‌شود.

مثال:

```text
downloads
```

در این حالت فایل‌ها داخل پوشه `downloads` ذخیره می‌شوند.

---

### `output_name`

نام دلخواه برای فایل خروجی.

این گزینه فقط وقتی استفاده می‌شود که فقط یک لینک وارد کرده باشی.

مثال:

```text
ubuntu.iso
```

اگر خالی باشد، ChunkBox تلاش می‌کند اسم فایل را از لینک یا هدر دانلود تشخیص دهد.

---

### `release_tag`

فقط در حالت `release` استفاده می‌شود.

اگر مقدار بدهی، فایل‌ها داخل همان Release آپلود می‌شوند.

مثال:

```text
my-downloads
```

اگر خالی بماند، Workflow خودش یک tag می‌سازد؛ مثلاً:

```text
partfetch-12
```

اگر خواستی اسم tagها هم با پروژه هماهنگ باشد، در فایل Workflow مقدار پیش‌فرض را از `partfetch` به `chunkbox` تغییر بده.

---

### `split_size_mib`

اندازه هر پارت بر حسب MiB.

مقدار پیشنهادی:

```text
98
```

بهتر است این مقدار را بالاتر از 98 نگذاری، چون GitHub برای فایل‌های بزرگ محدودیت دارد.

---

### `dedupe`

اگر روی `true` باشد، در حالت `repo` قبل از ذخیره فایل بررسی می‌کند که فایل مشابه با همان SHA256 قبلاً ذخیره نشده باشد.

مقدار پیشنهادی:

```text
true
```

---

## ذخیره در ریپو یا Release

### حالت repo

در حالت `repo` فایل‌ها داخل خود ریپو ذخیره می‌شوند.

نمونه تنظیمات:

```text
urls: https://example.com/file.zip
storage_mode: repo
output_folder: downloads
split_size_mib: 98
dedupe: true
```

مزایا:

- خروجی‌ها داخل ساختار ریپو دیده می‌شوند.
- برای تست و فایل‌های کوچک ساده‌تر است.
- همه چیز با commit ثبت می‌شود.

معایب:

- حجم history ریپو زیاد می‌شود.
- برای فایل‌های خیلی بزرگ یا تعداد زیاد مناسب نیست.

---

### حالت release

در حالت `release` فایل‌ها به بخش GitHub Releases آپلود می‌شوند.

نمونه تنظیمات:

```text
urls: https://example.com/big-file.iso
storage_mode: release
release_tag: big-files
split_size_mib: 98
dedupe: true
```

مزایا:

- برای فایل‌های بزرگ مناسب‌تر است.
- ریپو تمیزتر می‌ماند.
- history ریپو سنگین نمی‌شود.

معایب:

- فایل‌ها داخل پوشه‌های ریپو دیده نمی‌شوند.
- باید از بخش Releases دانلود شوند.

---

## بازیابی فایل‌های چندپارتی

اگر فایل بزرگ باشد، ChunkBox آن را به پارت‌های کوچک‌تر تقسیم می‌کند.

نمونه خروجی:

```text
file.zip.part-0000
file.zip.part-0001
file.zip.part-0002
file.zip.sha256
rebuild.sh
```

برای اتصال دوباره پارت‌ها:

```bash
bash rebuild.sh
```

یا دستی:

```bash
cat file.zip.part-* > file.zip
sha256sum -c file.zip.sha256
```

اگر خروجی `OK` بود، فایل درست بازسازی شده است.

---

## بررسی سلامت فایل

برای هر فایل، ChunkBox یک فایل SHA256 می‌سازد.

نمونه:

```text
file.zip.sha256
```

برای بررسی سلامت فایل:

```bash
sha256sum -c file.zip.sha256
```

اگر فایل split نشده باشد، می‌توانی از اسکریپت آماده استفاده کنی:

```bash
bash verify.sh
```

---

## فایل manifest.json

برای هر دانلود، یک فایل `manifest.json` ساخته می‌شود.

این فایل شامل اطلاعات کامل دانلود است؛ مثل لینک اصلی، نام فایل، حجم، هش، تعداد پارت‌ها و حالت ذخیره‌سازی.

نمونه:

```json
{
  "created_at_utc": "2026-05-01T15:30:00+00:00",
  "url": "https://example.com/file.zip",
  "filename": "file.zip",
  "size_bytes": 245366784,
  "sha256": "abc123...",
  "split": true,
  "part_count": 3,
  "split_size_mib": 98,
  "storage_mode": "repo",
  "subdir": "2026-05-01_153000_001_file_abc123",
  "asset_prefix": "",
  "files": [
    "file.zip.part-0000",
    "file.zip.part-0001",
    "file.zip.part-0002",
    "file.zip.sha256",
    "rebuild.sh",
    "README.md",
    "manifest.json"
  ]
}
```

---

## لینک‌های خصوصی و Secret

اگر لینک دانلود نیاز به Authorization header داشته باشد، نباید توکن را مستقیم داخل Workflow یا README بنویسی.

به مسیر زیر برو:

```text
Settings > Secrets and variables > Actions > New repository secret
```

یک Secret با این نام بساز:

```text
DOWNLOAD_AUTH_HEADER
```

مقدار آن می‌تواند این باشد:

```text
Bearer YOUR_TOKEN
```

یا این:

```text
Authorization: Bearer YOUR_TOKEN
```

ChunkBox هنگام دانلود، این مقدار را به درخواست `curl` اضافه می‌کند.

---

## خطاهای رایج

### خطای Invalid workflow file

اگر GitHub این خطا را نشان داد:

```text
Invalid workflow file
```

یعنی فایل YAML مشکل syntax یا indentation دارد.

YAML نسبت به فاصله‌ها حساس است. بهتر است فایل `downloader.yml` را کامل بررسی و جایگزین کنی.

---

### Workflow در Actions نمایش داده نمی‌شود

اگر Workflow را نمی‌بینی:

- مطمئن شو فایل در مسیر درست است:

```text
.github/workflows/downloader.yml
```

- مطمئن شو فایل روی branch اصلی ریپو قرار دارد.
- یک بار صفحه Actions را refresh کن.
- اگر GitHub Actions غیرفعال است، آن را از تنظیمات ریپو فعال کن.

---

### دانلود fail می‌شود

ممکن است لینک مستقیم نباشد.

برای تست لینک:

```bash
curl -L -I "YOUR_URL"
```

اگر خروجی به صفحه HTML، صفحه login یا captcha اشاره کند، لینک مستقیم نیست.

---

### فایل دانلودشده HTML است

گاهی به‌جای فایل اصلی، صفحه دانلود ذخیره می‌شود.

برای بررسی:

```bash
file filename
```

اگر خروجی شبیه این بود:

```text
HTML document
```

یعنی لینک مستقیم نبوده است.

---

### Push انجام نمی‌شود

اگر Workflow دانلود کرد ولی نتوانست commit و push کند، بررسی کن این بخش داخل Workflow وجود داشته باشد:

```yaml
permissions:
  contents: write
```

همچنین مطمئن شو تنظیمات Actions اجازه write به `GITHUB_TOKEN` را می‌دهد.

---

### Release ساخته نمی‌شود

اگر در حالت `release` خطا گرفتی:

- مقدار `storage_mode` باید `release` باشد.
- `permissions: contents: write` باید وجود داشته باشد.
- اگر `release_tag` تکراری است، Workflow باید اجازه آپلود با `--clobber` داشته باشد.
- نام tag نباید شامل کاراکترهای مشکل‌ساز باشد.

---

## نکات مهم

- ChunkBox برای لینک‌های مستقیم طراحی شده است.
- لینک‌هایی که نیاز به login، cookie، captcha یا کلیک در مرورگر دارند معمولاً مستقیم کار نمی‌کنند.
- برای فایل‌های بزرگ، حالت `release` بهتر از `repo` است.
- مقدار `split_size_mib` را بهتر است روی `98` نگه داری.
- اگر فایل‌ها را داخل ریپو ذخیره کنی، حجم ریپو و history به مرور زیاد می‌شود.
- برای لینک‌های خصوصی حتماً از GitHub Secrets استفاده کن.
- توکن‌ها را داخل فایل‌ها commit نکن.

---

## لینک‌هایی که ممکن است مستقیم کار نکنند

این سرویس‌ها گاهی لینک مستقیم نمی‌دهند یا نیاز به تنظیمات اضافه دارند:

- Google Drive
- Mega
- MediaFire
- Dropbox با صفحه واسط
- لینک‌های دارای کپچا
- لینک‌های نیازمند کوکی
- لینک‌هایی که فقط در مرورگر کار می‌کنند

برای این موارد باید لینک مستقیم دانلود تهیه کنی.

---

## نمونه‌های آماده

### دانلود یک فایل داخل ریپو

```text
urls: https://example.com/file.zip
storage_mode: repo
output_folder: downloads
output_name:
release_tag:
split_size_mib: 98
dedupe: true
```

---

### دانلود چند فایل داخل ریپو

```text
urls:
https://example.com/file1.zip
https://example.com/file2.iso
https://example.com/file3.mp4

storage_mode: repo
output_folder: downloads
split_size_mib: 98
dedupe: true
```

---

### دانلود فایل حجیم داخل Release

```text
urls: https://example.com/big-file.iso
storage_mode: release
release_tag: big-files
split_size_mib: 98
dedupe: true
```

---

## شخصی‌سازی نام Workflow

اگر می‌خواهی اسم Action در GitHub هم ChunkBox باشد، بالای فایل `downloader.yml` این خط را:

```yaml
name: PartFetch Downloader v2
```

به این تغییر بده:

```yaml
name: ChunkBox Downloader
```

همچنین اگر در حالت release، tag خودکار ساخته می‌شود و می‌خواهی نام آن با پروژه هماهنگ باشد، مقدار پیش‌فرض tag را از:

```text
partfetch-12
```

به چیزی مثل این تغییر بده:

```text
chunkbox-12
```

---

## پیشنهاد برای توضیح کوتاه ریپو

برای بخش Description ریپو می‌توانی این متن را بگذاری:

```text
A GitHub Actions powered downloader that downloads files, splits large files into chunks, and stores them in repo or releases.
```

یا فارسی:

```text
دانلودر ساده بر پایه GitHub Actions برای دانلود، تقسیم و ذخیره فایل‌ها در ریپو یا Releases.
```

---

## ایده‌های آینده

چند قابلیت که می‌شود بعداً به ChunkBox اضافه کرد:

- ساخت صفحه `index.html` برای لیست فایل‌های دانلودشده
- ارسال گزارش دانلود به Telegram
- حذف خودکار فایل‌های قدیمی
- ساخت Release جدا برای هر دانلود
- پشتیبانی بهتر از Google Drive
- پشتیبانی از فایل متنی شامل لیست لینک‌ها
- رمزگذاری فایل‌ها قبل از ذخیره
- اضافه کردن وضعیت دانلود در Issue یا Discussion
- ساخت badge برای آخرین اجرای موفق Workflow
- امکان انتخاب branch خروجی
- ساخت آرشیو zip از همه پارت‌ها

---

## لایسنس پیشنهادی

اگر می‌خواهی پروژه عمومی باشد، می‌توانی از لایسنس MIT استفاده کنی.

فایل زیر را بساز:

```text
LICENSE
```

و متن MIT License را داخل آن قرار بده.

---

## هشدار

از ChunkBox فقط برای دانلود فایل‌هایی استفاده کن که اجازه دانلود و ذخیره آن‌ها را داری.

مسئولیت استفاده از لینک‌ها، فایل‌ها و محتوای دانلودشده با خود کاربر است.

---

## وضعیت پروژه

ChunkBox یک پروژه ساده، سبک و قابل توسعه است که با GitHub Actions کار می‌کند و برای دانلود فایل، split کردن فایل‌های بزرگ، ساخت manifest و ذخیره خروجی در ریپو یا Release طراحی شده است.
