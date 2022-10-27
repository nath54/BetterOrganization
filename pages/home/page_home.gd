extends Control

var current_date: Dictionary = OS.get_date();
var current_time: Dictionary = OS.get_time();

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_Timer_timeout();
	#
	Global.resize_all_fonts();

func _on_Timer_timeout():
	current_date = OS.get_date();
	current_time = OS.get_time();
	$VBoxContainer/Titre_Date.text = Global.cal.get_weekday_name(current_date["day"], current_date["month"], current_date["year"])+" "+String(current_date["day"])+" "+Global.cal.MONTH_NAME[current_date["month"]]+" "+String(Global.current_date["year"]);
	$VBoxContainer/Heure.text = String(current_time["hour"])+"h "+String(current_time["minute"])+"min "+String(current_time["second"])+"sec";


func _on_Bt_params_pressed():
	Global.go_to_page("res://pages/home/settings/page_settings.tscn", false);
