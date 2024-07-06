# Aplikasi_Mobile_PPM_FOODSWIPE

A new Flutter project.

## Getting Started

Aplikasi ini adalah aplikasi untuk memesan makanan dan minuman dengan  pembayaran menggunakan QR atau tunai. Data menu diambil dari Google Sheets melalui API eksternal untuk memudahkan pengelolaan menu.

Arsitektur Aplikasi
Aplikasi ini dibangun menggunakan Flutter, sebuah framework pengembangan aplikasi lintas platform dari Google. Arsitektur aplikasi terdiri dari beberapa komponen utama:

UI Layer: Menggunakan widget Flutter untuk membangun antarmuka pengguna yang responsif dan menarik.
State Management: Menggunakan Provider untuk manajemen state, memungkinkan sinkronisasi data antara beberapa bagian aplikasi.
API Integration: Terhubung ke Google Sheets API untuk mengambil data menu secara dinamis.
Pembayaran: Integrasi dengan WhatsApp API untuk memfasilitasi pembayaran dan pemesanan.
Library yang Digunakan
Aplikasi ini memanfaatkan beberapa library Flutter untuk meningkatkan fungsionalitas dan tampilan aplikasi:

badges: Untuk menampilkan badge di ikon keranjang belanja.
google_fonts: Untuk menggunakan font Google di seluruh aplikasi.
http: Untuk melakukan permintaan HTTP ke Google Sheets API.
provider: Untuk manajemen state aplikasi dengan lebih baik.
url_launcher: Untuk membuka WhatsApp dari dalam aplikasi untuk proses pemesanan.
Panduan Penggunaan Aplikasi
Berikut adalah langkah-langkah penggunaan aplikasi:

Halaman Utama:

Akses halaman utama aplikasi untuk melihat daftar menu makanan dan minuman.
Pilih menu yang diinginkan dengan menambahkan atau mengurangi jumlahnya menggunakan tombol "+" dan "-".
Pemesanan:

Tekan tombol keranjang belanja untuk melihat pesanan yang telah dipilih.
Masukkan nama dan nomor meja Anda pada dialog yang muncul.
Pilih metode pembayaran antara QR atau tunai.
Tekan tombol "Pesan Sekarang" untuk mengirim pesanan melalui WhatsApp dengan rincian pesanan dan total harga.
Integrasi Google Sheets:

Data menu ditampilkan secara dinamis dari Google Sheets menggunakan Google Sheets API.
Perubahan pada Google Sheets akan tercermin secara langsung pada aplikasi setelah diperbarui
