extends Control

func _ready():
	Global.empty_childs($VBoxContainer/ScrollContainer/Dossiers);
	for c in Global.data.calendars:
		var d = preload("res://pages/timetable/Reference_Button.tscn").instance();
		d.text = c.title;
		if not c.active:
			d.text += " [désactivé]";
		d.connect("pressed", self, "on_bt_dossier_pressed", [c]);
		$VBoxContainer/ScrollContainer/Dossiers.add_child(d);
	#
	Global.resize_all_fonts();


func _on_Bt_Create_pressed():
	Global.active_object = null;
	Global.go_to_page("res://pages/timetable/create_calendar.tscn", false);

func on_bt_dossier_pressed(cal: Calendrier):
	Global.active_object = cal;
	Global.go_to_page("res://pages/timetable/create_calendar.tscn");


func _on_Bt_Retour_pressed():
	Global.go_to_page("res://pages/timetable/page_timetable.tscn");
