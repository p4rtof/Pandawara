extends Node

var poin = 0
var nyawa = 5
var album_koleksi = []
var bioma_dipilih = 0
var poin_per_bioma = [0, 0, 0]

var sapu_sapu_ditangkap: int = 0
var target_sapu_sapu_per_bioma: Array = [5, 5, 5]
var target_sapu_sapu: int = 5
var sedang_game_over: bool = false

var bioma_terbuka: int = 0

enum StoryTujuan { PILIH_BIOMA, MAIN_BIOMA, GAME_SELESAI }
var story_gambar: Array = []
var story_tujuan: int = StoryTujuan.PILIH_BIOMA

func reset_game():
	poin = 0
	nyawa = 5
	sapu_sapu_ditangkap = 0
	album_koleksi.clear()
	bioma_dipilih = 0
	sedang_game_over = false
	target_sapu_sapu = target_sapu_sapu_per_bioma[0]

func buka_bioma_berikutnya():
	if bioma_dipilih + 1 > bioma_terbuka:
		bioma_terbuka = bioma_dipilih + 1

# Dipanggil dari PopupMenang, abis pemain menang di satu bioma
func siapkan_story_outro():
	match bioma_dipilih:
		0:  # baru saja menang di DESA
			story_gambar = [
				"res://asset/story/menang_desa_1.png",
				"res://asset/story/menang_desa_2.png",
				"res://asset/story/menang_desa_3.png",
			]
			story_tujuan = StoryTujuan.PILIH_BIOMA
		1:  # baru saja menang di TENGAH
			story_gambar = [
				"res://asset/story/menang_tengah_1.png",
			]
			story_tujuan = StoryTujuan.PILIH_BIOMA
		2:  # baru saja menang di KOTA (final)
			story_gambar = [
				"res://asset/story/menang_kota_1.png",
				"res://asset/story/menang_kota_2.png",
				"res://asset/story/menang_kota_3.png",
				"res://asset/story/menang_kota_4.png",
			]
			story_tujuan = StoryTujuan.GAME_SELESAI

# Dipanggil dari pilih_bioma, sebelum pemain mulai main di bioma yang dipilih
# return true kalau ada story intro yang harus ditampilkan dulu
func siapkan_story_intro(bioma_index: int) -> bool:
	match bioma_index:
		1:  # masuk TENGAH
			story_gambar = [
				"res://asset/story/masuk_tengah_1.png",
				"res://asset/story/masuk_tengah_2.png",
				"res://asset/story/masuk_tengah_3.png",
				"res://asset/story/masuk_tengah_4.png",
			]
			story_tujuan = StoryTujuan.MAIN_BIOMA
			return true
		2:  # masuk KOTA
			story_gambar = [
				"res://asset/story/masuk_kota_1.png",
				"res://asset/story/masuk_kota_2.png",
				"res://asset/story/masuk_kota_3.png",
				"res://asset/story/masuk_kota_4.png",
			]
			story_tujuan = StoryTujuan.MAIN_BIOMA
			return true
		_:
			return false  # DESA: gak ada intro, langsung main
