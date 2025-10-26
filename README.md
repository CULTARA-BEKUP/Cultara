# CULTARA Flutter App

CULTARA adalah aplikasi Flutterun tuk eksplorasi, manajemen, dan edukasi seputar budaya indonesia khususnya untuk tarian dan lagu daerah. Aplikasi ini terintegrasi dengan Firebase sebagai tempat penyimpanan datanya.

## Fitur Utama

### 1. Museum
- Lihat daftar museum budaya beserta detail dan gambar
- Tambah museum baru (admin)
- Edit museum (admin)
- Hapus museum (admin)

### 2. Artikel
- Lihat koleksi artikel budaya 
- Tambah, edit, hapus artikel (admin)
- Pencarian artefak/artikel

### 3. Event
- Lihat event/kegiatan yang diadakan museum
- Tambah, edit, hapus event (admin)

### 4. User & Auth
- Registrasi dan login user (Firebase Auth)
- Edit profil user
- Role user: admin & user biasa

### 5. Komentar & Rating
- User bisa memberi komentar dan rating pada article dan evet
- Admin bisa moderasi komentar


## Setup & Penggunaan

### 1. Clone Repo & Install Dependency
```bash
flutter pub get
```

### 2. Buat file `.env`
Copy contoh berikut ke file `.env` di root project:
```env
# WEB
FIREBASE_API_KEY=xxx
FIREBASE_APP_ID=xxx
FIREBASE_MESSAGING_SENDER_ID=xxx
FIREBASE_PROJECT_ID=xxx
FIREBASE_AUTH_DOMAIN=xxx
FIREBASE_STORAGE_BUCKET=xxx
FIREBASE_MEASUREMENT_ID=xxx

# ANDROID
FIREBASE_ANDROID_API_KEY=xxx
FIREBASE_ANDROID_APP_ID=xxx

# IOS
FIREBASE_IOS_API_KEY=xxx
FIREBASE_IOS_APP_ID=xxx
FIREBASE_IOS_BUNDLE_ID=xxx

# MACOS
FIREBASE_MACOS_API_KEY=xxx
FIREBASE_MACOS_APP_ID=xxx
FIREBASE_MACOS_BUNDLE_ID=xxx

# WINDOWS
FIREBASE_WINDOWS_API_KEY=xxx
FIREBASE_WINDOWS_APP_ID=xxx
FIREBASE_WINDOWS_MEASUREMENT_ID=xxx
```

> **JANGAN** commit file `.env` ke repo!

### 3. Tambahkan `.env` ke assets (khusus Web)
Edit `pubspec.yaml`:
```yaml
flutter:
	assets:
		- .env
```
Lalu jalankan:
```bash
flutter pub get
```

### 4. Jalankan Aplikasi
```bash
flutter run
```
## Kolaborasi & Setup Credential

Jika Anda kolaborator:

1. **Minta file berikut ke owner/project admin:**
	- `android/app/google-services.json` (untuk Android)
	- `ios/Runner/GoogleService-Info.plist` (untuk iOS)
	- File `.env` (atau isi credential-nya)

2. **Letakkan file di folder berikut:**
	- `google-services.json` → `android/app/`
	- `GoogleService-Info.plist` → `ios/Runner/`

3. **Jalankan:**
	```bash
	flutter pub get
	flutter run
	```
