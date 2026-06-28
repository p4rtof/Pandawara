# Pandawara — Ekspedisi Ciliwung

Game edukasi 2D berbasis Godot 4 yang terinspirasi dari kisah nyata Pandawara Group, komunitas pemuda yang berjuang membersihkan Sungai Ciliwung dari sampah dan ikan invasif. Pemain berperan sebagai nelayan muda yang menjaring ikan sapu-sapu di tiga ekosistem berbeda, sambil menghindari bahaya yang mengintai di dalam sungai.

---

## Tentang Game

Ikan sapu-sapu (*Pterygoplichthys* spp.) adalah spesies asing invasif yang kini mendominasi perairan Ciliwung dan mengancam ekosistem asli sungai. Game ini memvisualisasikan masalah tersebut dengan cara yang ringan dan menyenangkan — pemain ditugaskan menjaring sebanyak mungkin sapu-sapu sambil mengumpulkan informasi spesies ikan yang ditemui ke dalam album koleksi.

Setiap bioma punya ekosistem, tingkat kesulitan, dan jenis ikan yang berbeda. Semakin jauh ke hilir (kota), semakin banyak ancaman yang muncul.

---

## Cara Main

- **Gerak** : Arrow keys / WASD / joystick analog
- **Jaring** : Bergerak ke arah ikan — jaring aktif otomatis ke kiri/kanan sesuai arah gerak
- **Tangkap Sapu-sapu** : Kena jaring → poin bertambah, progress misi naik
- **Hindari** : Ikan lele dan ikan mas mengurangi nyawa; buaya jauh lebih berbahaya (-3 nyawa, aktif mengejar)
- **Tahan klik** : Tahan di atas ikan manapun selama ~0.8 detik untuk menambahkannya ke album tanpa harus menjaring
- **Menang** : Tangkap sapu-sapu sesuai target di tiap bioma
- **Game Over** : Nyawa habis (mulai dari 5)

---

## Fitur

- **3 Bioma** dengan latar dan populasi ikan yang berbeda
  - **Hulu (Desa)** — sapu-sapu biasa & mujair
  - **Tengah** — sapu-sapu albino, sapu-sapu biasa, ikan mas, mujair
  - **Kota** — sapu-sapu loreng (zebra), albino, biasa, lele, buaya, mas, mujair
- **Sistem bobot spawn** — setiap ikan punya probabilitas kemunculan berbeda per bioma
- **Album Koleksi** — 7 spesies bisa dikumpulkan, masing-masing punya popup info dan gambar tersendiri
- **Popup saat tangkap** — info singkat muncul pertama kali ikan baru ditemukan
- **Sistem Story** — cutscene berbasis slideshow gambar di awal game, transisi antar bioma, dan ending per bioma
- **Bioma terkunci** — bioma berikutnya hanya terbuka setelah berhasil menyelesaikan bioma sebelumnya
- **Loading Screen sinematik** — efek fireflies, logo float, loading bar bergaya air, rotasi tips gameplay
- **Musik & SFX** — BGM looping, SFX tangkap/menang/kalah, duck otomatis saat SFX muncul
- **Pause menu** dan **popup keluar**
- **Settings** (halaman pengaturan)

---

## Struktur Proyek

```
pandawara-1/
├── asset/
│   ├── audio/          # BGM (sound.ogg) dan SFX (tangkap, menang, kalah)
│   ├── story/          # Slideshow gambar untuk intro, transisi bioma, dan ending
│   └── *.png / *.jpg   # Sprite, background, UI, album art, dan popup ikan
├── scene/
│   ├── mainmenu.tscn
│   ├── story.tscn          # Cutscene intro awal
│   ├── story_transisi.tscn # Cutscene transisi masuk bioma baru
│   ├── pilih_bioma.tscn
│   ├── game_sungai.tscn    # Scene utama gameplay
│   ├── player.tscn
│   ├── ikan.tscn           # Base scene ikan generik
│   ├── buaya.tscn          # Musuh aktif (mengejar player)
│   ├── lele.tscn
│   ├── ikan_mas.tscn
│   ├── mujair.tscn
│   ├── sapu_sapu.tscn
│   ├── sapu_sapu_albino.tscn
│   ├── sapu_sapu_loreng.tscn
│   ├── album.tscn          # UI koleksi ikan
│   ├── popup_ikan.tscn     # Popup info ikan
│   ├── loading_screen.tscn
│   ├── gameover.tscn
│   ├── pause_menu.tscn
│   ├── setting.tscn
│   └── ...
└── script/
    ├── global.gd           # Autoload — state game global (poin, nyawa, album, bioma)
    ├── game_manager.gd     # Autoload — inisialisasi sesi game
    ├── music_manager.gd    # Autoload — manajemen BGM & SFX dengan duck
    ├── game.gd             # Logic gameplay utama (spawn ikan, kamera, background)
    ├── ikan.gd             # Perilaku ikan generik + logika tangkap & album
    ├── buaya.gd            # AI buaya (kejar player, damage per sentuhan)
    ├── player.gd           # Kontrol player + jaring kiri/kanan
    ├── album.gd            # UI album koleksi
    ├── pilih_bioma.gd      # Pemilihan dan unlock bioma
    ├── loading_screen.gd   # Loading screen sinematik
    ├── mainmenu.gd
    ├── gameover.gd
    ├── story.gd
    └── ...
```

---

## Spesies Ikan

| Ikan | Bioma | Kategori | Efek |
|---|---|---|---|
| Sapu-sapu Biasa | Hulu, Tengah, Kota | Target utama | +poin, +progress misi |
| Sapu-sapu Albino | Tengah, Kota | Target utama | +poin, +progress misi |
| Sapu-sapu Loreng | Kota | Target utama (+30 poin) | +poin lebih banyak |
| Mujair | Semua | Ikan lain | -nyawa |
| Ikan Mas | Tengah, Kota | Ikan lain | -nyawa |
| Lele | Kota | Ikan lain | -nyawa |
| Buaya | Kota | Musuh aktif | -3 nyawa, mengejar player |

Semua spesies (termasuk buaya) bisa masuk album koleksi.

---

## Autoload / Singleton

| Nama | File | Fungsi |
|---|---|---|
| `Global` | `global.gd` | Poin, nyawa, album, bioma dipilih/terbuka, state game over, data story |
| `GameManager` | `game_manager.gd` | Pengaturan awal sesi |
| `MusicManager` | `music_manager.gd` | Putar BGM/SFX, duck volume saat SFX aktif |

---

## Teknologi

- **Engine** : [Godot 4.6](https://godotengine.org/) — Forward Plus renderer
- **Bahasa** : GDScript
- **Physics** : Jolt Physics (3D engine, digunakan via setting proyek)
- **Audio** : OGG Vorbis
- **Rendering** : D3D12 (Windows)
- **Stretch mode** : `canvas_items` + aspect `expand`

---

## Cara Menjalankan

1. Pastikan sudah install [Godot 4.6](https://godotengine.org/download/) atau versi yang kompatibel
2. Clone atau download repo ini
3. Buka Godot → **Import** → pilih folder `pandawara-1/`
4. Klik **Play** (F5) atau langsung jalankan dari scene `scene/loading_screen.tscn`

> Tidak perlu setup tambahan. Semua asset sudah di-bundle di dalam proyek.

---

## Kontribusi & Kredit

Proyek ini dibuat sebagai bentuk apresiasi terhadap kerja nyata Pandawara Group yang sejak 2022 aktif membersihkan Sungai Ciliwung. Misi mereka sederhana tapi berani — terjun langsung ke sungai yang penuh sampah demi lingkungan yang lebih baik.

Kalau mau kontribusi atau ada bug yang ditemukan, silakan buka issue atau pull request.

---

*"Sungai bukan tempat sampah. Sungai adalah milik kita semua."*
