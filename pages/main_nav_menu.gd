extends Control

signal change_page(page);

var NEUTRAL_COLOR: Color = Color(1,1,1);
var SELECTED_COLOR: Color = Color(120.0/255.0, 222.0/255.0, 245.0/255.0);

onready var pages_text: Dictionary = {
	"events": $HBoxContainer/Bt_Events/Text_Events,
	"todos":$HBoxContainer/Bt_Todos/Text_Todos,
	"home":$HBoxContainer/Bt_Home/Text_Home,
	"timetable":$HBoxContainer/Bt_Timetable/Text_Timetable,
	"sheets":$HBoxContainer/Bt_Sheets/Text_Sheets
};

func _ready():
	_on_Bt_Home_pressed();

func affich_page(page):
	for p in pages_text:
		if p == page:
			pages_text[p].modulate = SELECTED_COLOR;
		else:
			pages_text[p].modulate = NEUTRAL_COLOR;

func _on_Bt_Events_pressed():
	emit_signal("change_page", "events");
	affich_page("events");

func _on_Bt_Todos_pressed():
	emit_signal("change_page", "todos");
	affich_page("todos");

func _on_Bt_Home_pressed():
	emit_signal("change_page", "home");
	affich_page("home");

func _on_Bt_Timetable_pressed():
	emit_signal("change_page", "timetable");
	affich_page("timetable");

func _on_Bt_Sheets_pressed():
	emit_signal("change_page", "sheets");
	affich_page("sheets");
