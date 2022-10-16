extends Control

const jours: Array = ["lun", "mar", "mer", "jeu", "ven", "sam", "dim"];
const periods: Array = ["1 jour", "3 jours", "5 jours", "7 jours"];
const iperiods: Array = [0, 2, 4, 6];
var current_period: int = 1;
var cal: Calendar = Calendar.new();

var current_date = OS.get_date();

func aff_date():
	for i in range(7):
		get_node("VBoxContainer/ScrollContainer/HBoxContainer/j"+String(i)+"/day").text = jours[(current_date["weekday"]-1+i)%7];
	#
	var next_day: Dictionary = cal.avance_days(current_date["day"], current_date["month"], current_date["year"], iperiods[current_period]);
	$VBoxContainer/HBoxContainer2/HBoxContainer/interval.text = String(current_date["day"])+"/"+String(current_date["month"])+"/"+String(current_date["year"])+" - "+String(next_day["day"])+"/"+String(next_day["month"])+"/"+String(next_day["year"]);

func clear_timetable():
	for i in range(7):
		Global.empty_childs(get_node("VBoxContainer/ScrollContainer/HBoxContainer/j"+String(i)+"/j"));

func draw_timetable():
	var js = {0: [], 1: [],2: [],3: [],4: [],5: [],6: []};
	# On récupère tous les éléments
	for c in Global.data.calendars:
		if c.active:
			for e in c.elements:
				js[int(e["day"])].append([[e["heure_deb"], e["heure_fin"]], e]);
	# On va trier les élements de chaque jours
	for k in js.keys():
		js[k].sort_custom(Global, "custom_arrdate_sort");
	#
	var dec = current_date["weekday"];
	var mi = 8.0;
	var ma = 20.0;
	# On veut récupérer l'heure min et l'heure max globaux
	for i in range(iperiods[current_period]+1):
		for e in js[(i+dec)%7]:
			if e[0][0] < mi: mi = [0][0];
			if e[0][1] > ma: ma = e[0][1];
	# On va maintenant afficher chacun des elements
	for i in range(iperiods[current_period]+1):
		var cont: Panel = get_node("VBoxContainer/ScrollContainer/HBoxContainer/j"+String(i)+"/j");
		var hr = (cont.rect_size.y)/(ma-mi);
		for e in js[(i+dec)%7]:
			var py = (e[0][0]-mi)*hr;
			var ty = (e[0][1]-e[0][0])*hr;
			var px = 0;
			var tx = cont.rect_size.x;
			#
			var bt = preload("res://pages/timetable/ReferenceTTelt.tscn").instance();
			bt.get_node("VBoxContainer/Label").text = e[1]["title"];
			bt.get_node("VBoxContainer/HBoxContainer/Label").text = Global.float_to_heure_str(e[0][0])+"-"+Global.float_to_heure_str(e[0][1])
			cont.add_child(bt);
			bt.rect_size = Vector2(tx, ty);
			bt.rect_min_size = Vector2(tx, ty);
			bt.rect_position = Vector2(px, py);
			#

func _ready():
	aff_date();
	draw_timetable();
	get_tree().get_root().connect("size_changed", self, "_on_resized")

func update_period():
	for i in range(7):
		get_node("VBoxContainer/ScrollContainer/HBoxContainer/j"+String(i)).visible = (i<=iperiods[current_period]);


func _on_Bt_manage_pressed():
	Global.go_to_page("res://pages/timetable/gerer_edt.tscn");


func _on_Bt_Create_pressed():
	Global.active_object = null;
	Global.go_to_page("res://pages/timetable/Create_Element.tscn");


func _on_Bt_period_pressed():
	current_period = (current_period+1)%len(periods);
	$VBoxContainer/HBoxContainer2/Bt_period.text = periods[current_period];
	var next_day: Dictionary = Calendar.new().avance_days(current_date["day"], current_date["month"], current_date["year"], iperiods[current_period]);
	$VBoxContainer/HBoxContainer2/HBoxContainer/interval.text = String(current_date["day"])+"/"+String(current_date["month"])+"/"+String(current_date["year"])+" - "+String(next_day["day"])+"/"+String(next_day["month"])+"/"+String(next_day["year"]);
	update_period();
	clear_timetable();
	draw_timetable();


func _on_Bt_before_pressed():
	current_date = cal.avance_days(current_date["day"], current_date["month"], current_date["year"], -(iperiods[current_period]+1));
	aff_date();
	clear_timetable();
	draw_timetable();

func _on_Bt_after_pressed():
	current_date = cal.avance_days(current_date["day"], current_date["month"], current_date["year"], iperiods[current_period]+1);
	aff_date();
	clear_timetable();
	draw_timetable();


func _on_resized():
	clear_timetable();
	draw_timetable();
