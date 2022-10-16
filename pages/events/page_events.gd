extends Control

var events_list = []; # 0 = date, 1 = event

# Called when the node enters the scene tree for the first time.
func _ready():
	for c in Global.data.calendars:
		if c.active:
			for ev in c.events:
				# On trie dans l'ordre chronologique*/
				events_list.append([[ev["date"]["year"], ev["date"]["month"], ev["date"]["day"], ev["heure_deb"]], ev]);
	#
	if len(events_list) == 0:
		pass
	else:
		Global.empty_childs($VBoxContainer/ScrollContainer/VBoxContainer);
		#
		events_list.sort_custom(Global, "custom_arrdate_sort");
		#
		for ev in events_list:
			var btev = preload("res://pages/timetable/Reference_Button.tscn").instance();
			btev.text = ev[1]["title"];
			btev.connect("pressed", self, "on_bt_clicked", [ev[1]]);
			$VBoxContainer/ScrollContainer/VBoxContainer.add_child(btev);

func _on_Bt_create_pressed():
	Global.active_object = null;
	Global.go_to_page("res://pages/events/Create_Event.tscn", false);

func on_bt_clicked(ev):
	Global.active_object = ev;
	Global.go_to_page("res://pages/events/Create_Event.tscn", false);
