# UMeals Assets Guide

## 🚨 PENTING: Status Assets Saat Ini

**✅ FIXED**: Masalah routing gambar sudah diperbaiki! Aplikasi sekarang menggunakan placeholder icons sementara menunggu gambar real.

## Struktur Folder Assets

```
assets/
├── README.md                    # Panduan lengkap mengganti gambar
├── images/
│   ├── vendors/                 # Gambar vendor/penjual
│   │   ├── bu_linda.jpg         # ← GANTI dengan foto real Bu Linda
│   │   ├── pak_bambang.jpg      # ← GANTI dengan foto real Pak Bambang
│   │   └── bu_yayuk.jpg         # ← GANTI dengan foto real Bu Yayuk
│   ├── food/                    # Gambar makanan
│   │   ├── mie_ayam.jpg         # ← GANTI dengan foto Mie Ayam Special
│   │   ├── soto_ayam.jpg        # ← GANTI dengan foto Soto Ayam Berkuah
│   │   ├── rawon_ayam.jpg       # ← GANTI dengan foto Rawon Ayam Kampung
│   │   ├── dimsum.jpg           # ← GANTI dengan foto Dimsum
│   │   ├── bubur_ayam.jpg       # ← GANTI dengan foto Bubur Ayam
│   │   ├── chicken_katsu.jpg    # ← GANTI dengan foto Chicken Katsu
│   │   ├── ayam_geprek.jpg      # ← GANTI dengan foto Ayam Geprek
│   │   ├── nasi_goreng.jpg      # ← GANTI dengan foto Nasi Goreng
│   │   └── sate_ayam.jpg        # ← GANTI dengan foto Sate Ayam
│   └── background/              # Gambar background
│       └── kantin_fmipa.jpg     # ← GANTI dengan foto Kantin FMIPA
└── icons/                       # Folder untuk icon (jika diperlukan)
```

## 🚨 PENTING: Cara Mengganti Gambar

### **Langkah 1: Siapkan Gambar Real**
- **Format**: JPG atau PNG
- **Ukuran**:
  - Vendor photos: 400x400px
  - Food photos: 500x500px
  - Background: 1200x800px
- **Kualitas**: High quality, tidak blur
- **Nama file**: HARUS sama persis dengan yang ada

### **Langkah 2: Ganti File Placeholder**
1. Buka folder project → `assets/images/`
2. **Hapus file JPG kosong yang ada**
3. **Masukkan gambar real** dengan nama yang sama
4. Pastikan nama file sama persis (case-sensitive)

### **Langkah 3: Test Aplikasi**
```bash
flutter clean
flutter pub get
flutter run
```

## 📋 Daftar File yang Perlu Diganti

### **Vendor Photos** (3 gambar)
- `assets/images/vendors/bu_linda.jpg`
- `assets/images/vendors/pak_bambang.jpg`
- `assets/images/vendors/bu_yayuk.jpg`

### **Food Photos** (9 gambar)
- `assets/images/food/mie_ayam.jpg`
- `assets/images/food/soto_ayam.jpg`
- `assets/images/food/rawon_ayam.jpg`
- `assets/images/food/dimsum.jpg`
- `assets/images/food/bubur_ayam.jpg`
- `assets/images/food/chicken_katsu.jpg`
- `assets/images/food/ayam_geprek.jpg`
- `assets/images/food/nasi_goreng.jpg`
- `assets/images/food/sate_ayam.jpg`

### **Background Photo** (1 gambar)
- `assets/images/background/kantin_fmipa.jpg`
cp /path/to/your/mie_ayam.jpg assets/images/food/

# Copy gambar background
cp /path/to/your/kantin_fmipa.jpg assets/images/background/
```

### 3. Update Kode (Jika Path Berubah)

Jika Anda mengubah struktur folder, update path di kode:

**File: `lib/screens/home_screen.dart`**
```dart
// Dari:
image: 'assets/images/bu_linda.jpg',

// Menjadi:
image: 'assets/images/vendors/bu_linda.jpg',
```

### 4. Update pubspec.yaml

Pastikan assets path sudah terdaftar di `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/images/vendors/
    - assets/images/food/
    - assets/images/background/
    - assets/icons/
```

### 5. Testing

Setelah mengganti gambar:
1. Jalankan `flutter clean`
2. Jalankan `flutter pub get`
3. Jalankan `flutter run`
4. Pastikan semua gambar ter-load dengan benar

## Daftar Gambar yang Dibutuhkan

### Vendor Images (3 gambar)
- `bu_linda.jpg` - Foto Bu Linda
- `pak_bambang.jpg` - Foto Pak Bambang
- `bu_yayuk.jpg` - Foto Bu Yayuk

### Food Images (9 gambar)
- `mie_ayam.jpg` - Mie Ayam Special
- `soto_ayam.jpg` - Soto Ayam Berkuah
- `rawon_ayam.jpg` - Rawon Ayam Kampung
- `dimsum.jpg` - Dimsum
- `bubur_ayam.jpg` - Bubur Ayam
- `chicken_katsu.jpg` - Chicken Katsu
- `ayam_geprek.jpg` - Ayam Geprek
- `nasi_goreng.jpg` - Nasi Goreng
- `sate_ayam.jpg` - Sate Ayam

### Background Images (1 gambar)
- `kantin_fmipa.jpg` - Background kantin FMIPA

## Tips untuk Gambar Berkualitas

1. **Vendor Photos**: Gunakan foto close-up yang jelas, pencahayaan baik
2. **Food Photos**: Foto makanan yang menggugah selera, angle yang menarik
3. **Background**: Foto kantin yang representatif dan tidak terlalu ramai
4. **Compression**: Kompres gambar agar ukuran file tidak terlalu besar (< 500KB per gambar)
5. **Consistency**: Pastikan style dan kualitas gambar seragam

## ⚙️ Troubleshooting

### **✅ FIXED: Gambar tidak muncul setelah diganti:**
1. **Masalah**: pubspec.yaml tidak include subfolder assets
2. **Solusi**: ✅ Sudah diperbaiki - semua subfolder sudah terdaftar
3. **Test**: Jalankan `flutter clean && flutter pub get`

### **Gambar tidak muncul setelah diganti:**
1. Pastikan nama file sama persis (case-sensitive)
2. Pastikan format gambar valid (JPG/PNG)
3. Jalankan `flutter clean && flutter pub get`
4. Restart aplikasi (tekan `R` di terminal)

### **Error "Asset not found":**
- Cek pubspec.yaml sudah include folder assets ✅
- Pastikan path gambar benar
- Restart VS Code/emulator

### **Gambar terlalu besar/kecil:**
- Sesuaikan ukuran sesuai spesifikasi di atas
- Gunakan tools seperti Photoshop atau online resizer

---

## 🎯 Quick Start Guide

1. **📸 Ambil foto** semua vendor dan makanan
2. **✂️ Edit foto** sesuai spesifikasi ukuran
3. **📁 Copy ke folder** yang sesuai
4. **🧹 Clean & rebuild**: `flutter clean && flutter pub get && flutter run`
5. **✅ Test** semua screen untuk memastikan gambar muncul

## 🎨 Tips untuk Gambar Berkualitas

### **Foto Vendor:**
- Close-up, pencahayaan baik
- Ekspresi ramah dan profesional
- Background netral

### **Foto Makanan:**
- Angle menarik (45 derajat)
- Pencahayaan food photography
- Menggugah selera
- Komposisi yang bagus

### **Foto Background:**
- Representatif kantin FMIPA
- Tidak terlalu ramai
- Pencahayaan cukup terang

## 🔧 pubspec.yaml Configuration

✅ **Sudah dikonfigurasi dengan benar:**

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/images/vendors/
    - assets/images/food/
    - assets/images/background/
    - assets/icons/
```

## 📱 Testing di Device

Setelah mengganti gambar:
1. Hot restart aplikasi (tekan `R` di terminal)
2. Cek semua screen yang menggunakan gambar
3. Pastikan tidak ada error loading

---

**🎉 Setelah mengganti semua gambar, aplikasi UMeals akan terlihat jauh lebih profesional dan sesuai dengan realitas kantin FMIPA!**

**📞 Butuh bantuan?** Cek troubleshooting guide di atas atau tanya developer! 🚀