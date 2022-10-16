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

var evnt;

# Called when the node enters the scene tree for the first time.
func _ready():
	#
	if Global.active_object == null:
		mode = "create";
		#
		var date = OS.get_datetime();
		day = date["day"];
		month = date["month"];
		year = date["year"];
		cal = 0;
		$VBoxContainer/Bt_suppr.visible = false;
	else:
		mode = "edit";
		#
		evnt = Global.active_object;
		day = evnt["date"]["day"];
		month = evnt["date"]["month"];
		year = evnt["date"]["year"];
		#
		var i = 0;
		for c in Global.data.calendars:
			if evnt in c.events:
				cal = i;
				original_cal = i;
				break;
			i+=1;
		#
		$VBoxContainer/Titre/LineEdit.text = evnt["title"];
		$VBoxContainer/Calendrier/OptionButton.selected = cal;
		$VBoxContainer/Date/Date.text = String(day) + "/"+ String(month) + "/" + String(year);
	#
	display_date();
	#
	var i = 0;
	for c in Global.data.calendars:
		$VBoxContainer/Calendrier/OptionButton.add_item(c.title);
		#
		if i == cal:
			$VBoxContainer/Calendrier/OptionButton.selected = i;
		#
		i+=1;


func display_date():
	$VBoxContainer/Date/Date.text = String(day)+"/"+String(month)+"/"+String(year);

func _on_Bt_delete_pressed():
	for c in Global.data.calendars:
		if evnt in c.events:
			c.events.erase(evnt);
			break;
	Global.save_data();
	Global.go_to_page("res://pages/events/page_events.tscn");


func _on_Bt_cancel_pressed():
	Global.go_to_page("res://pages/events/page_events.tscn");

func test():
	return true;
	

func _on_Bt_validate_pressed():
	if test():
		if mode == "create":
			Global.data.calendars[cal].events.append({
				"title": $VBoxContainer/Titre/LineEdit.text,
				"description": "",
				"date": {"day": day, "month": month, "year": year},
				"heure_deb": Global.str_heure_to_float($VBoxContainer/Heure_Deb/LineEdit.text),
				"heure_fin":  Global.str_heure_to_float($VBoxContainer/Heure_Fin/LineEdit.text)
			})
		elif mode == "edit":
			if original_cal != -1:
				Global.data.calendars[original_cal].events.erase(evnt);
			Global.data.calendars[cal].events.append({
				"title": $VBoxContainer/Titre/LineEdit.text,
				"description": "",
				"date": {"day": day, "month": month, "year": year},
				"heure_deb":  Global.str_heure_to_float($VBoxContainer/Heure_Deb/LineEdit.text),
				"heure_fin":  Global.str_heure_to_float($VBoxContainer/Heure_Fin/LineEdit.text)
			});
		Global.save_data();
		Global.go_to_page("res://pages/events/page_events.tscn");
	

func _on_CalendarButton_date_selected(date_obj):
	day = date_obj.day();
	month = date_obj.month();
	year = date_obj.year();
	display_date();


func _on_OptionButton_item_selected(index):
	cal = index;
