# Flutter Map Setup Guide

## ✅ Maps Sudah Terintegrasi dengan flutter_map!

Project ini menggunakan **flutter_map** dengan **OpenStreetMap** - 100% GRATIS dan TIDAK PERLU API KEY!

---

## Keuntungan flutter_map:

- ✅ **Gratis selamanya** - tidak ada biaya
- ✅ **Tanpa API key** - langsung jalan
- ✅ **Tanpa billing account** - tidak perlu kartu kredit
- ✅ **Open source** - menggunakan OpenStreetMap
- ✅ **Interactive** - bisa zoom, pan, marker
- ✅ **Offline support** - bisa digunakan offline jika tiles di-cache

---

## Yang Sudah Terinstall:

### Packages:
```yaml
flutter_map: ^7.0.2    # Library maps
latlong2: ^0.9.1       # Library untuk koordinat
```

### Features:
- Interactive map dengan zoom dan pan
- Marker lokasi event (pin merah)
- OpenStreetMap tile layer
- Zoom level 5-18
- Radius 15 km default

---

## Cara Testing:

```bash
flutter run
```

Buka detail event, dan maps akan langsung muncul dengan marker lokasi event!

---

## Customization (Opsional):

### 1. Ganti Tile Server (Style Maps)
Jika ingin tampilan berbeda, ganti `urlTemplate`:

```dart
TileLayer(
  // Dark mode
  urlTemplate: 'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png',
  
  // Atau satelit (perlu API key)
  // urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
)
```

### 2. Custom Marker
Ganti icon pin dengan gambar custom:

```dart
Marker(
  point: eventLocation,
  width: 80,
  height: 80,
  child: Image.asset('assets/images/custom_marker.png'),
)
```

### 3. Enable Gesture
Sudah enabled by default (zoom, pan, rotate)

---

## Tile Servers Gratis Lainnya:

1. **OpenStreetMap** (default - paling stabil)
   ```
   https://tile.openstreetmap.org/{z}/{x}/{y}.png
   ```

2. **Stadia Maps Alidade Smooth** (modern, clean)
   ```
   https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}{r}.png
   ```

3. **Wikimedia Maps**
   ```
   https://maps.wikimedia.org/osm-intl/{z}/{x}/{y}.png
   ```

> **Note:** Beberapa tile server memerlukan attribution. OpenStreetMap sudah include attribution by default.

---

## Troubleshooting:

### Maps tidak muncul / blank:
1. Check internet connection (tile loading perlu internet)
2. Check console log untuk error
3. Pastikan koordinat latitude/longitude valid

### Tiles loading lambat:
- Normal untuk pertama kali load
- Tiles akan di-cache otomatis
- Gunakan WiFi untuk development

### Marker tidak muncul:
- Check koordinat latitude/longitude sudah benar
- Pastikan MarkerLayer sudah ada di children FlutterMap

---

## Documentation:

- flutter_map: https://docs.fleaflet.dev/
- OpenStreetMap: https://www.openstreetmap.org/
- Tile servers list: https://wiki.openstreetmap.org/wiki/Tile_servers

---

## Kesimpulan:

**TIDAK PERLU SETUP APAPUN!** Maps sudah langsung jalan. Tinggal `flutter run` dan test! 🎉
