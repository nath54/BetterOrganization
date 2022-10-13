extends Control

onready var ititre: LineEdit = $VBoxContainer/ScrollContainer/Inputs/Titre/LineEdit;

var mode = "create";

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.active_object == null:
		mode = "create";
	else:
		mode = "edit";
		ititre.text = Global.active_object.title;
		$"VBoxContainer/ScrollContainer/Inputs/Activé/CheckBox".pressed = Global.active_object.active;
		$VBoxContainer/ScrollContainer/Inputs/VBoxContainer2.visible = true;



func _on_Bt_Delete_pressed():
	if mode == "create":
		Global.go_to_page("res://pages/timetable/gerer_edt.tscn");
	else:
		Global.data.calendars.erase(Global.active_object);
		Global.save_data();
		Global.go_to_page("res://pages/timetable/gerer_edt.tscn");


func _on_Bt_Cancel_pressed():
	Global.go_to_page("res://pages/timetable/gerer_edt.tscn");


func test():
	if len(ititre.text) == 0 or len(ititre.text) > 50: return false;
	for c in Global.data.calendars:
		if Global.active_object != c and c.title == ititre.text:
			print(c);
			return false;
	return true;

func _on_Bt_Validate_pressed():
	if test():
		if mode=="create":
			Global.data.calendars.append(Calendrier.new(ititre.text));
			Global.save_data();
			Global.go_to_page("res://pages/timetable/gerer_edt.tscn");
		else:
			var idx = Global.data.calendars.find(Global.active_object);
			if idx != -1:
				Global.data.calendars[idx].title = ititre.text;
				Global.data.calendars[idx].active = $"VBoxContainer/ScrollContainer/Inputs/Activé/CheckBox".pressed;
				Global.save_data();
				Global.go_to_page("res://pages/timetable/gerer_edt.tscn");
			
