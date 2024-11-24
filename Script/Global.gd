extends Node

var dayProgress = []
var monologDay1 = [
  "Hari pertama. Aku harus berhasil.",
  "Kota ini gelap dan sepi, tapi aku bisa melakukannya.",
  "Aku yakin bisa lebih dari sekadar tugas utama.",
  "Tidak ada ruang untuk kesalahan.",
  "Aku ingin jadi yang terbaik.",
  "Ini baru permulaan. Aku tidak boleh gagal."
]
var monologDay2 = [
  "Hari kedua, aku bisa tingkatkan lagi.",
  "Suara-suara itu... mungkin hanya perasaanku.",
  "Aku harus lakukan lebih dari yang diminta.",
  "Setiap paket tambahan membuktikan kemampuanku.",
  "Ada sesuatu yang salah, tapi aku tidak bisa berhenti sekarang.",
  "Aku terus menambah targetku sendiri, tapi kenapa ini masih terasa kurang?"
]
var monologDay3 = [
  "Suara-suara ini semakin menggangguku.",
  "Ada yang berubah. Ini terasa lebih sulit.",
  "Bayangan ini tahu kelemahanku.",
  "Aku harus tetap tenang.",
  "Aku bisa lebih dari sekadar cukup.",
  "Hari ini lebih berat, tapi aku tidak boleh kalah."
]
var monologDay4 = [
  "Bisikan ini semakin meragukan kemampuanku.",
  "Kenapa aku selalu merasa kurang?",
  "Monster ini makin agresif, seolah tahu ketakutanku.",
  "Aku mulai merasa tertekan.",
  "Tidak pernah ada cukupnya.",
  "Aku mulai kehilangan arah."
]
var monologDay5 = [
  "Aku sangat lelah, tapi tidak bisa berhenti.",
  "Teriakan itu sekarang terdengar seperti diriku sendiri.",
  "Bayangan dan monster ini... sepertinya muncul karena aku yang ciptakan.",
  "Aku sadar, aku telah terlalu keras pada diriku.",
  "Setiap langkah mengingatkanku bahwa ini tidak lagi soal tugas, tapi obsesi.",
  "Mungkin aku harus berhenti mencoba melakukan semuanya dengan sempurna."
]

func _ready():
	var loaded_data = Addonsave.edit_data()
	if loaded_data.has("dayProgress"):
		dayProgress = loaded_data["dayProgress"]
	else:
		dayProgress = [0, 0, 0, 0, 0]

func _exit_tree():
	Addonsave.save_data({"dayProgress": dayProgress})
