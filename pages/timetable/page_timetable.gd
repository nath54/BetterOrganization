extends Control

const jours: Array = ["lun", "mar", "mer", "jeu", "ven", "sam", "dim"];
const periods: Array = ["1 jour", "3 jours", "5 jours", "7 jours"];
var current_period: int = 1;

onready var current_date = OS.get_date();

func _ready():
	$VBoxContainer/ScrollContainer/HBoxContainer/j1/day.text = jours[(current_date["weekday"]-1)%7]
	$VBoxContainer/ScrollContainer/HBoxContainer/j2/day.text = jours[(current_date["weekday"])%7]
	$VBoxContainer/ScrollContainer/HBoxContainer/j3/day.text = jours[(current_date["weekday"]+1)%7]
	$VBoxContainer/ScrollContainer/HBoxContainer/j4/day.text = jours[(current_date["weekday"]+2)%7]
	$VBoxContainer/ScrollContainer/HBoxContainer/j5/day.text = jours[(current_date["weekday"]+3)%7]
	$VBoxContainer/ScrollContainer/HBoxContainer/j6/day.text = jours[(current_date["weekday"]+4)%7]
	$VBoxContainer/ScrollContainer/HBoxContainer/j7/day.text = jours[(current_date["weekday"]+5)%7]
	#
	$VBoxContainer/HBoxContainer2/HBoxContainer/interval.text = String(current_date["day"])+"/"+String(current_date["month"])+"/"+String(current_date["year"])

func update_period():
	if current_period == 0:
		$VBoxContainer/ScrollContainer/HBoxContainer/j1.visible = true;
		$VBoxContainer/ScrollContainer/HBoxContainer/j2.visible = false;
		$VBoxContainer/ScrollContainer/HBoxContainer/j3.visible = false;
		$VBoxContainer/ScrollContainer/HBoxContainer/j4.visible = false;
		$VBoxContainer/ScrollContainer/HBoxContainer/j5.visible = false;
		$VBoxContainer/ScrollContainer/HBoxContainer/j6.visible = false;
		$VBoxContainer/ScrollContainer/HBoxContainer/j7.visible = false;
	elif current_period == 1:
		$VBoxContainer/ScrollContainer/HBoxContainer/j1.visible = true;
		$VBoxContainer/ScrollContainer/HBoxContainer/j2.visible = true;
		$VBoxContainer/ScrollContainer/HBoxContainer/j3.visible = true;
		$VBoxContainer/ScrollContainer/HBoxContainer/j4.visible = false;
		$VBoxContainer/ScrollContainer/HBoxContainer/j5.visible = false;
		$VBoxContainer/ScrollContainer/HBoxContainer/j6.visible = false;
		$VBoxContainer/ScrollContainer/HBoxContainer/j7.visible = false;
	elif current_period == 2:
		$VBoxContainer/ScrollContainer/HBoxContainer/j1.visible = true;
		$VBoxContainer/ScrollContainer/HBoxContainer/j2.visible = true;
		$VBoxContainer/ScrollContainer/HBoxContainer/j3.visible = true;
		$VBoxContainer/ScrollContainer/HBoxContainer/j4.visible = true;
		$VBoxContainer/ScrollContainer/HBoxContainer/j5.visible = true;
		$VBoxContainer/ScrollContainer/HBoxContainer/j6.visible = false;
		$VBoxContainer/ScrollContainer/HBoxContainer/j7.visible = false;
	elif current_period == 3:
		$VBoxContainer/ScrollContainer/HBoxContainer/j1.visible = true;
		$VBoxContainer/ScrollContainer/HBoxContainer/j2.visible = true;
		$VBoxContainer/ScrollContainer/HBoxContainer/j3.visible = true;
		$VBoxContainer/ScrollContainer/HBoxContainer/j4.visible = true;
		$VBoxContainer/ScrollContainer/HBoxContainer/j5.visible = true;
		$VBoxContainer/ScrollContainer/HBoxContainer/j6.visible = true;
		$VBoxContainer/ScrollContainer/HBoxContainer/j7.visible = true;


func _on_Bt_manage_pressed():
	Global.go_to_page("res://pages/timetable/gerer_edt.tscn");


func _on_Bt_Create_pressed():
	# Créer un event
	pass # Replace with function body.


func _on_Bt_period_pressed():
	current_period = (current_period+1)%len(periods);
	$VBoxContainer/HBoxContainer2/Bt_period.text = periods[current_period];
	update_period();
