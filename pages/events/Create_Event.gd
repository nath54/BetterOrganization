extends Control

var titre = "";
var day = 0;
var month = 0;
var year = 0;
var hour_beg = 8;
var hour_end = 10;


# Called when the node enters the scene tree for the first time.
func _ready():
	var date = OS.get_datetime();
	day = date["day"];
	month = date["month"];
	year = date["year"];
	#
	display_date();
	#
	for c in Global.data.calendars:
		$VBoxContainer/Calendrier/OptionButton.add_item(c.title);


func display_date():
	$VBoxContainer/Date/Date.text = String(day)+"/"+String(month)+"/"+String(year);


func _on_Bt_delete_pressed():
	pass # Replace with function body.


func _on_Bt_cancel_pressed():
	Global.go_to_page("res://pages/events/page_events.tscn");


func _on_Bt_validate_pressed():
	pass # Replace with function body.


func _on_CalendarButton_date_selected(date_obj):
	day = date_obj.day();
	month = date_obj.month();
	year = date_obj.year();
	display_date();
