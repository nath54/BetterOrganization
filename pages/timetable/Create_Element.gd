extends Control

var titre = "";
var day = 0;
var month = 0;
var year = 0;
var hour_beg = 8;
var hour_end = 10;
var cal = -1;
var original_cal = -1;

var mode = "create";

var elmt;

# Called when the node enters the scene tree for the first time.
func _ready():
	#
	if Global.active_object == null:
		mode = "create";
		#
		day = 0;
		cal = 0;
		$VBoxContainer/Bt_suppr.visible = false;
	else:
		mode = "edit";
		#
		elmt = Global.active_object;
		day = elmt["day"];
		$VBoxContainer/Date/Jour.selected = day;
		#
		var i = 0;
		for c in Global.data.calendars:
			if elmt in c.elements:
				cal = i;
				original_cal = i;
				break;
			i+=1;
		#
		$VBoxContainer/Titre/LineEdit.text = elmt["title"];
		$VBoxContainer/Calendrier/OptionButton.selected = cal;
		$VBoxContainer/Date/Date.text = String(day) + "/"+ String(month) + "/" + String(year);
	#
	var i = 0;
	for c in Global.data.calendars:
		$VBoxContainer/Calendrier/OptionButton.add_item(c.title);
		#
		if i == cal:
			$VBoxContainer/Calendrier/OptionButton.selected = i;
		#
		i+=1;

func _on_Bt_delete_pressed():
	for c in Global.data.calendars:
		if elmt in c.elements:
			c.elements.erase(elmt);
			break;
	Global.save_data();
	Global.go_to_page("res://pages/timetable/page_timetable.tscn");


func _on_Bt_cancel_pressed():
	Global.go_to_page("res://pages/timetable/page_timetable.tscn");

func test():
	return true;
	
func convert_str_to_heure(txt):
	return 0.0;

func _on_Bt_validate_pressed():
	if test():
		if mode == "create":
			Global.data.calendars[cal].elements.append({
				"title": $VBoxContainer/Titre/LineEdit.text,
				"description": "",
				"day": day,
				"heure_deb": convert_str_to_heure($VBoxContainer/Heure_Deb/LineEdit.text),
				"heure_fin": convert_str_to_heure($VBoxContainer/Heure_Fin/LineEdit.text)
			})
		elif mode == "edit":
			if original_cal != -1:
				Global.data.calendars[original_cal].elements(elmt);
			Global.data.calendars[cal].elements.append({
				"title": $VBoxContainer/Titre/LineEdit.text,
				"description": "",
				"day": day,
				"heure_deb": convert_str_to_heure($VBoxContainer/Heure_Deb/LineEdit.text),
				"heure_fin": convert_str_to_heure($VBoxContainer/Heure_Fin/LineEdit.text)
			});
		Global.save_data();
		Global.go_to_page("res://pages/timetable/page_timetable.tscn");

func _on_OptionButton_item_selected(index):
	cal = index;
