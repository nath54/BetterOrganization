extends Control

var events_list = []; # 0 = date, 1 = event

var limit: int = 10;
var nb_aff: int = 0;

var current_date: Dictionary = OS.get_date();
var cdar: Array = [[current_date["year"], current_date["month"], current_date["day"]]]; # Peut être rajouter l'heure plus tard

# Called when the node enters the scene tree for the first time.
func _ready():
	#
	for c in Global.data.calendars:
		if c.active:
			for ev in c.events:
				# On vérifie que l'évenements n'est pas encore fini
				if not Global.custom_arrdate_sort([[ev["date"]["year"], ev["date"]["month"], ev["date"]["day"], ev["heure_deb"]]], cdar):
					# On trie dans l'ordre chronologique
					events_list.append([[ev["date"]["year"], ev["date"]["month"], ev["date"]["day"], ev["heure_deb"]], ev]);
	#
	if len(events_list) == 0:
		pass # Il y a par défaut le texte : il n'y a pas d'events
	else:
		Global.empty_childs($VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer);
		nb_aff = 0;
		#
		events_list.sort_custom(Global, "custom_arrdate_sort");
		#
		for ev in events_list:
			var btev = preload("res://pages/events/BoutonEvent.tscn").instance();
			btev.get_node("VBoxContainer/NomEvent").text = ev[1]["title"];
			btev.get_node("VBoxContainer/HBoxContainer/Date").text = String(ev[1]["date"]["day"])+"/"+String(ev[1]["date"]["month"])+"/"+String(ev[1]["date"]["year"]);
			btev.get_node("VBoxContainer/HBoxContainer/Heure").text = Global.float_to_heure_str(ev[1]["heure_deb"]) + " - " + Global.float_to_heure_str(ev[1]["heure_fin"]);
			btev.modulate = ev[1]["color"];
			btev.connect("pressed", self, "on_bt_clicked", [ev[1]]);
			$VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer.add_child(btev);
			nb_aff += 1;
			if nb_aff >= limit:
				break;
		#
		if len(events_list) > limit:
			$VBoxContainer/ScrollContainer/VBoxContainer/Bt_voir_tout.visible = true;
	#
	Global.resize_all_fonts();

func tout_afficher():
	Global.empty_childs($VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer);
	# Liste déjà triée normalement
	for ev in events_list:
		var btev = preload("res://pages/events/BoutonEvent.tscn").instance();
		btev.get_node("VBoxContainer/NomEvent").text = ev[1]["title"];
		btev.get_node("VBoxContainer/HBoxContainer/Date").text = String(ev[1]["date"]["day"])+"/"+String(ev[1]["date"]["month"])+"/"+String(ev[1]["date"]["year"]);
		btev.get_node("VBoxContainer/HBoxContainer/Heure").text = Global.float_to_heure_str(ev[1]["heure_deb"]) + " - " + Global.float_to_heure_str(ev[1]["heure_fin"]);
		btev.modulate = ev[1]["color"];
		btev.connect("pressed", self, "on_bt_clicked", [ev[1]]);
		$VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer.add_child(btev);
	$VBoxContainer/ScrollContainer/VBoxContainer/Bt_voir_tout.visible = false;

func _on_Bt_create_pressed():
	Global.active_object = null;
	Global.go_to_page("res://pages/events/Create_Event.tscn", false);

func on_bt_clicked(ev):
	Global.active_object = ev;
	Global.go_to_page("res://pages/events/Create_Event.tscn", false);

func _on_Bt_voir_tout_pressed():
	tout_afficher();

func _on_Bt_voir_events_passes_pressed():
	Global.go_to_page("res://pages/events/page_events_passés.tscn", false);
