<div dir="rtl" align="right">

# ‏📦 ChunkBox

‏**ChunkBox** یه دانلودر ساده و جمع‌وجور بر پایه **GitHub Actions** هست.

لینک مستقیم فایل رو بهش می‌دی، خودش دانلود می‌کنه، اگه فایل بزرگ بود تیکه‌تیکه‌اش می‌کنه، بعد هم خروجی رو یا داخل ریپو ذخیره می‌کنه یا می‌فرسته توی GitHub Release.

این پروژه مخصوصاً برای شرایطیه که از داخل ایران خیلی وقت‌ها دسترسی‌ها محدود، کند، قطع‌ووصلی یا کلاً بسته‌ست.  
ایده اینه که بدون سرور شخصی و دردسر اضافه، از خود GitHub Actions برای دانلود و مدیریت فایل‌ها استفاده کنیم.

> ⚠️ از ChunkBox فقط برای فایل‌هایی استفاده کن که اجازه دانلود و نگهداری‌شون رو داری.

---

## ✨ چی کار می‌کنه؟

- دانلود فایل از لینک مستقیم
- پشتیبانی از یک یا چند لینک همزمان
- تقسیم فایل‌های بزرگ به پارت‌های کوچیک‌تر
- ذخیره خروجی داخل ریپو یا GitHub Release
- ساخت فایل `manifest.json` برای هر دانلود
- ساخت فایل `sha256` برای چک کردن سلامت فایل
- ساخت اسکریپت `rebuild.sh` برای چسبوندن دوباره پارت‌ها
- نمایش گزارش نهایی داخل GitHub Actions
- پشتیبانی از لینک‌های خصوصی با GitHub Secrets

---

## 🚀 راه‌اندازی

فایل Workflow رو اینجا بذار:

</div>

<pre dir="ltr" align="left"><code>.github/workflows/downloader.yml
</code></pre>

<div dir="rtl" align="right">

بعد commit و push کن.

حالا برو توی تب **Actions** ریپوت و Workflow با اسم **ChunkBox Downloader** رو اجرا کن.

---

## 🧩 ورودی‌های مهم

### ‏`urls`

لینک مستقیم دانلود رو اینجا می‌دی.

برای یه فایل:

</div>

<pre dir="ltr" align="left"><code>https://example.com/file.zip
</code></pre>

<div dir="rtl" align="right">

برای چندتا فایل:

</div>

<pre dir="ltr" align="left"><code>https://example.com/file1.zip
https://example.com/file2.iso
https://example.com/file3.mp4
</code></pre>

<div dir="rtl" align="right">

---

### ‏`storage_mode`

مشخص می‌کنه خروجی کجا ذخیره بشه:

</div>

<pre dir="ltr" align="left"><code>repo
release
auto
</code></pre>

<div dir="rtl" align="right">

توضیح ساده:

- `repo` یعنی فایل‌ها داخل خود ریپو commit بشن.
- `release` یعنی فایل‌ها برن داخل GitHub Release.
- `auto` یعنی خودش تصمیم بگیره؛ فایل‌های کوچیک‌تر داخل ریپو، فایل‌های بزرگ‌تر داخل Release.

پیشنهاد من:

</div>

<pre dir="ltr" align="left"><code>auto
</code></pre>

<div dir="rtl" align="right">

---

### ‏`output_folder`

اگه حالت `repo` رو انتخاب کرده باشی، فایل‌ها داخل این پوشه ذخیره می‌شن:

</div>

<pre dir="ltr" align="left"><code>downloads
</code></pre>

<div dir="rtl" align="right">

---

### ‏`split_size_mib`

اندازه هر پارت رو مشخص می‌کنه.

مقدار پیشنهادی:

</div>

<pre dir="ltr" align="left"><code>98
</code></pre>

<div dir="rtl" align="right">

چون GitHub با فایل‌های نزدیک یا بالای ۱۰۰ مگابایت مشکل داره، بهتره همین مقدار بمونه.

---

### ‏`repo_push_batch_mib`

وقتی داری فایل‌ها رو داخل ریپو ذخیره می‌کنی، ChunkBox فایل‌ها رو در چند push جدا می‌فرسته که گیر نکنه.

مقدار پیشنهادی:

</div>

<pre dir="ltr" align="left"><code>500
</code></pre>

<div dir="rtl" align="right">

---

## 📁 خروجی چه شکلیه؟

اگه فایل بزرگ باشه، خروجی تقریباً این شکلی می‌شه:

</div>

<pre dir="ltr" align="left"><code>downloads/
  2026-05-01_113525_001_file_ab12cd34/
    file.zip.part-0000
    file.zip.part-0001
    file.zip.part-0002
    file.zip.sha256
    rebuild.sh
    README.md
    manifest.json
</code></pre>

<div dir="rtl" align="right">

اگه فایل کوچیک باشه و split نشه:

</div>

<pre dir="ltr" align="left"><code>downloads/
  2026-05-01_113525_001_file_ab12cd34/
    file.zip
    file.zip.sha256
    verify.sh
    README.md
    manifest.json
</code></pre>

<div dir="rtl" align="right">

---

## 🔧 چسبوندن دوباره پارت‌ها

اگه فایل چند پارت شده بود، داخل پوشه خروجی یه فایل `rebuild.sh` ساخته می‌شه.

برای ساخت فایل اصلی:

</div>

<pre dir="ltr" align="left"><code>bash rebuild.sh
</code></pre>

<div dir="rtl" align="right">

یا دستی:

</div>

<pre dir="ltr" align="left"><code>cat file.zip.part-* &gt; file.zip
sha256sum -c file.zip.sha256
</code></pre>

<div dir="rtl" align="right">

اگه خروجی `OK` گرفتی، یعنی فایل سالمه.

---

## 🧾 فایل manifest.json

برای هر دانلود یه فایل `manifest.json` ساخته می‌شه که اطلاعات دانلود رو نگه می‌داره.

مثلاً:

</div>

<pre dir="ltr" align="left"><code>{
  "url": "https://example.com/file.zip",
  "filename": "file.zip",
  "size_bytes": 2453667840,
  "sha256": "abc123...",
  "split": true,
  "part_count": 26,
  "storage_mode": "repo"
}
</code></pre>

<div dir="rtl" align="right">

این فایل کمک می‌کنه بعداً بفهمی فایل از کجا اومده، چند پارت شده و هش اصلیش چی بوده.

---

## 🔐 لینک‌های خصوصی

اگه لینک دانلودت نیاز به توکن یا Authorization داشته باشه، توکن رو مستقیم توی فایل‌ها ننویس.

برو این مسیر:

</div>

<pre dir="ltr" align="left"><code>Settings &gt; Secrets and variables &gt; Actions &gt; New repository secret
</code></pre>

<div dir="rtl" align="right">

یه Secret بساز با این اسم:

</div>

<pre dir="ltr" align="left"><code>DOWNLOAD_AUTH_HEADER
</code></pre>

<div dir="rtl" align="right">

نمونه مقدار:

</div>

<pre dir="ltr" align="left"><code>Bearer YOUR_TOKEN
</code></pre>

<div dir="rtl" align="right">

یا:

</div>

<pre dir="ltr" align="left"><code>Authorization: Bearer YOUR_TOKEN
</code></pre>

<div dir="rtl" align="right">

---

## ⚠️ چند نکته مهم

- ChunkBox فقط با لینک مستقیم درست کار می‌کنه.
- لینک‌هایی که کپچا، لاگین، کوکی یا صفحه واسط دارن ممکنه کار نکنن.
- برای فایل‌های خیلی بزرگ، حالت `release` یا `auto` بهتر از `repo`ـه.
- اگه Workflow وسط کار قطع بشه، ممکنه فقط چند پارت اول ذخیره شده باشن.
- فایل‌های خصوصی یا بدون مجوز رو با این ابزار منتشر نکن.

---

## 🌐 درباره شرایط ایران

ChunkBox برای همین موقعیت‌های اعصاب‌خردکن ساخته شده؛ وقتی یه فایل از یه سرور خارجی در دسترس نیست، دانلود کند می‌شه، وسطش قطع می‌شه، یا کلاً دسترسی بسته‌ست.

اینجا GitHub Actions نقش یه واسطه ساده رو بازی می‌کنه:  
فایل رو از بیرون می‌گیره، مرتبش می‌کنه، تیکه‌تیکه‌اش می‌کنه و تحویل می‌ده.

قرار نیست جای سرویس‌های حرفه‌ای ذخیره‌سازی رو بگیره، ولی برای استفاده شخصی، تست، آرشیو و انتقال فایل خیلی به‌دردبخوره.

---

## 🧪 پیشنهاد استفاده

برای شروع ساده:

</div>

<pre dir="ltr" align="left"><code>storage_mode: auto
split_size_mib: 98
repo_push_batch_mib: 500
dedupe: true
</code></pre>

<div dir="rtl" align="right">

برای فایل‌های خیلی بزرگ:

</div>

<pre dir="ltr" align="left"><code>storage_mode: release
split_size_mib: 98
</code></pre>

<div dir="rtl" align="right">

برای فایل‌های معمولی:

</div>

<pre dir="ltr" align="left"><code>storage_mode: repo
split_size_mib: 98
repo_push_batch_mib: 500
</code></pre>

<div dir="rtl" align="right">

---

## 🛣️ ایده‌های بعدی

چیزهایی که می‌شه بعداً اضافه کرد:

- ساخت صفحه لیست دانلودها
- ارسال گزارش به تلگرام
- حذف خودکار فایل‌های قدیمی
- ساخت Release جدا برای هر دانلود
- پشتیبانی بهتر از لینک‌های خاص مثل Google Drive
- رمزگذاری فایل‌ها قبل از ذخیره

---

## 📌 وضعیت پروژه

ChunkBox یه ابزار ساده، سبک و قابل توسعه‌ست.  
هدفش اینه که دانلود و مدیریت فایل‌ها رو توی شرایط محدودیت دسترسی راحت‌تر کنه، بدون اینکه نیاز به سرور جدا داشته باشی.

</div>
