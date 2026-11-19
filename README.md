# Keripikroll - Responsi Praktikum Pemrograman Aplikasi Mobile

Aplikasi mobile streaming & browsing anime **Keripikroll** yang dibangun menggunakan Flutter sesuai dengan ketentuan Responsi Praktikum Pemrograman Aplikasi Mobile.

## Data Mahasiswa
- **NIM**: 124240002
- **Password Default**: 123

## Kriteria & Fitur yang Diimplementasikan
1. **Login Page (10%)**
   - Autentikasi user dengan validasi input (kredensial NIM `124240002` & Password `123`).
   - Terdapat error handling jika username/password kosong atau keliru.
   - Status login dan username disimpan secara persisten menggunakan `SharedPreferences`.

2. **Home Page (25%)**
   - `BottomNavigationBar` untuk navigasi 3 halaman utama: Beranda, Favorit, dan Profil.
   - Daftar anime ditampilkan dalam bentuk `GridView` (2 kolom) responsif.
   - Menampilkan atribut minimal:
     - Poster Image (`posterImage->tiny/small/etc`)
     - Nama Anime (`titles->en_jp` dengan fallback aman)
     - Rating Umur & Jumlah Episode (`ageRating`, `episodeCount`)
     - Rating Anime (`averageRating`)
   - Terdapat `CircularProgressIndicator` saat memuat data dan fitur *pull-to-refresh*.

3. **Detail Page (35%)**
   - Menampilkan detail anime secara dinamis dari endpoint API Kitsu.
   - Komponen wajib:
     - Cover Image sebagai Hero banner
     - Rating (`averageRating`)
     - Rating Umur & Jumlah Episode (`ageRating`, `episodeCount`)
     - Sinopsis anime (`synopsis`)
     - Tombol "▶ Nonton" (statis dengan interaksi SnackBar)
     - Tombol Tambah/Hapus Favorit dengan UI dinamis (ikon berbeda saat disukai vs tidak disukai)
   - Tombol kembali (AppBar back arrow) ke halaman sebelumnya.
   - Loading indicator saat memuat detail anime.

4. **Favorite Page (20%)**
   - Menampilkan daftar anime yang telah disukai pengguna dalam format `ListView`.
   - Menampilkan: Poster Image, Nama anime, dan Rating.
   - Tombol hapus (ikon tempat sampah warna merah) untuk menghapus anime dari perpustakaan favorit.
   - Tapping pada item akan membuka `DetailPage` anime tersebut.
   - Pengelolaan data favorit disimpan secara lokal dan persisten menggunakan **Hive**.

5. **Profile Page (10%)**
   - Menampilkan avatar pengguna.
   - Username diambil secara dinamis dari **SharedPreferences**.
   - Jumlah anime disukai dihitung secara real-time dari data **Hive** menggunakan `ValueListenableBuilder`.
   - Tombol Logout dengan dialog konfirmasi yang membersihkan session dan mengarahkan kembali ke `LoginPage`.

6. **Arsitektur & Kode Bersih**
   - Pemisahan fetch & parse API pada file tersendiri: `lib/services/api_service.dart`.
   - Data model terstruktur: `lib/models/anime.dart`.
   - Layanan terpisah: `AuthService` dan `FavoriteService`.

## Endpoint API Kitsu yang Digunakan
- **Daftar Anime**: `https://kitsu.io/api/edge/anime/?page[limit]=20&page[offset]=0`
- **Detail Anime**: `https://kitsu.io/api/edge/anime/{anime_id}`
