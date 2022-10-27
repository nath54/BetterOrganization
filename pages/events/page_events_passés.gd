extends Control


var events_list = []; # 0 = date, 1 = event

var current_date: Dictionary = OS.get_date();
var cdar: Array = [[current_date["year"], current_date["month"], current_date["day"]]]; # Peut être rajouter l'heure plus tard

# Called when the node enters the scene tree for the first time.
func _ready():
	#
	for c in Global.data.calendars:
		if c.active:
			for ev in c.events:
				# On vérifie que l'évenements n'est pas encore fini
				if not Global.custom_arrdate_sort(cdar, [[ev["date"]["year"], ev["date"]["month"], ev["date"]["day"], ev["heure_deb"]]]):
					# On trie dans l'ordre chronologique
					events_list.append([[ev["date"]["year"], ev["date"]["month"], ev["date"]["day"], ev["heure_deb"]], ev]);
	#
	if len(events_list) == 0:
		pass # Il y a par défaut le texte : il n'y a pas d'events
	else:
		Global.empty_childs($VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer);
		#
		events_list.sort_custom(Global, "custom_arrdate_sort");
		events_list.invert();
		#
		for ev in events_list:
			var btev = preload("res://pages/events/BoutonEvent.tscn").instance();
			btev.get_node("VBoxContainer/NomEvent").text = ev[1]["title"];
			btev.get_node("VBoxContainer/HBoxContainer/Date").text = String(ev[1]["date"]["day"])+"/"+String(ev[1]["date"]["month"])+"/"+String(ev[1]["date"]["year"]);
			btev.get_node("VBoxContainer/HBoxContainer/Heure").text = Global.float_to_heure_str(ev[1]["heure_deb"]) + " - " + Global.float_to_heure_str(ev[1]["heure_fin"]);
			btev.modulate = ev[1]["color"];
			btev.connect("pressed", self, "on_bt_clicked", [ev[1]]);
			$VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer.add_child(btev);
	#
	Global.resize_all_fonts();



func _on_Bt_retour_pressed():
	Global.go_to_page("res://pages/events/page_events.tscn");
