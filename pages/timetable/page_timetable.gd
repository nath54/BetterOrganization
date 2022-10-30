extends Control

const jours: Array = ["KEY_LUN", "KEY_MAR", "KEY_MER", "KEY_JEU", "KEY_VEN", "KEY_SAM", "KEY_DIM"];
const periods: Array = ["KEY_1DAY", "KEY_3DAY", "KEY_5DAY", "KEY_7DAY"];
const iperiods: Array = [0, 2, 4, 6];
# Global.tt_crt_period
var cal: Calendar = Calendar.new();

var current_date = OS.get_date();

func aff_date():
	for i in range(7):
		get_node("VBoxContainer/ScrollContainer/HBoxContainer/j"+String(i)+"/day").text = tr(jours[(current_date["weekday"]-1+i)%7]);
	#
	var next_day: Dictionary = cal.avance_days(current_date["day"], current_date["month"], current_date["year"], iperiods[Global.tt_crt_period]);
	$VBoxContainer/HBoxContainer2/HBoxContainer/interval.text = String(current_date["day"])+"/"+String(current_date["month"])+"/"+String(current_date["year"])+" - "+String(next_day["day"])+"/"+String(next_day["month"])+"/"+String(next_day["year"]);

func clear_timetable():
	for i in range(7):
		Global.empty_childs(get_node("VBoxContainer/ScrollContainer/HBoxContainer/j"+String(i)+"/j"));

func draw_timetable():
	var next_day: Dictionary = cal.avance_days(current_date["day"], current_date["month"], current_date["year"], iperiods[Global.tt_crt_period])
	var cdar = [[current_date["year"], current_date["month"], current_date["day"]]];
	var ndar = [[next_day["year"], next_day["month"], next_day["day"]+1]];
	var js = {0: [], 1: [],2: [],3: [],4: [],5: [],6: []};
	var dec = current_date["weekday"];
	var jj: int;
	# print("BEGIN DRAW TIMETABLE : ", cdar, " - ", ndar);
	# On récupère tous les éléments
	for c in Global.data.calendars:
		if c.active:
			# Les élements hebdomadaires du calendrier
			for e in c.elements:
				jj = (int(e["day"]+1-dec)%7);
				if jj < 0: jj+=7;
				js[jj].append([[e["heure_deb"], e["heure_fin"]], e, "element"]);
			# Les évenements ponctuels du calendrier
			for ev in c.events:
				var evdar = [[ev["date"]["year"], ev["date"]["month"], ev["date"]["day"]]];
				var c1: bool = Global.custom_arrdate_sort(cdar, evdar);
				var c2: bool = Global.custom_arrdate_sort(evdar, ndar);
				# print(ev, "  c1 ", c1, "  c2 ", c2)
				if c1 and c2:
					var wd: int = (cal.get_weekday(ev["date"]["day"], ev["date"]["month"], ev["date"]["year"]-1))%7;
					jj = (int(wd+1-dec)%7);
					if jj < 0: jj+=7;
					js[jj].append([[ev["heure_deb"], ev["heure_fin"]], ev, "event"]);
	
	# On va trier les élements de chaque jours
	for k in js.keys():
		var arr: Array = js[k];
		arr.sort_custom(Global, "custom_arrdate_sort");
		js[k] = arr;
	#
	var mi = 8.0;
	var ma = 20.0;
	var blocks = {};
	var max_blocks = {}
	var nb_blocks: int;
	var collide: bool;
	#
	# On veut récupérer l'heure min et l'heure max globaux, et agencer les élements en blocs
	for i in range(iperiods[Global.tt_crt_period]+1):
		blocks[i] = [];
		nb_blocks = 0;
		for e in js[i]: # !!! PROBLEME D'INDICE ICI !!!!
			if e[0][0] < mi: mi = [0][0];
			if e[0][1] > ma: ma = e[0][1];
			# ajout blocks
			if nb_blocks == 0:
				blocks[i].append([e]);
				nb_blocks += 1;
			else:
				# Test collision
				collide = false;
				for be in blocks[i][nb_blocks-1]:
					if e[0][0] < be[0][1]:
						collide = true;
						break
				#
				if collide:
					blocks[i][nb_blocks-1].append(e);
				else:
					blocks[i].append([e]);
					nb_blocks += 1;
	#
	# Pour chaque blocks, on va calculer la position horizontale de chaque elt du block
	var j: int;
	var k: int;
	var l: int;
	var rempli: bool;
	for i in range(iperiods[Global.tt_crt_period]+1):
		max_blocks[i] = [];
		j = 0;
		for b in blocks[i]:
			max_blocks[i].append([0, []]); # 0 = nb tot de rangées
			l = 0;
			for e in b:
				if max_blocks[i][j][0] == 0:
					max_blocks[i][j][0] = 1;
					max_blocks[i][j][1].append(e);
				else:
					rempli = true; 
					k = 0;
					for eatt in max_blocks[i][j][1]:
						if e[0][0] >= eatt[0][1]:
							blocks[i][j][l][0].append(k);
							max_blocks[i][j][1][k] = e;
							rempli = false;
							break;
						k+=1;
					if rempli:
						max_blocks[i][j][0] += 1;
						max_blocks[i][j][1].append(e);
						blocks[i][j][l][0].append(k);
				l += 1;
			j+=1;
	# On va maintenant afficher les élements
	var px: float;
	var py: float;
	var tx: float;
	var ty: float;
	var hr: float;
	var hv: float;
	for i in range(iperiods[Global.tt_crt_period]+1):
		var cont: Panel = get_node("VBoxContainer/ScrollContainer/HBoxContainer/j"+String(i)+"/j");
		hr = (cont.rect_size.y)/(ma-mi);
		j = 0;
		for b in blocks[i]:
			hv = (cont.rect_size.x)/max_blocks[i][j][0];
			for e in b:
				# 
				py = (e[0][0]-mi)*hr;
				ty = (e[0][1]-e[0][0])*hr;
				if len(e[0]) <= 2:
					px = 0;
				else:
					px = e[0][2]*hv;
				tx = hv;
				#
				var bt = preload("res://pages/timetable/ReferenceTTelt.tscn").instance();
				bt.get_node("VBoxContainer/Label").text = e[1]["title"];
				bt.get_node("VBoxContainer/HBoxContainer/Label").text = Global.float_to_heure_str(e[0][0])+"-"+Global.float_to_heure_str(e[0][1])
				cont.add_child(bt);
				bt.rect_size = Vector2(tx, ty);
				bt.rect_min_size = Vector2(tx, ty);
				bt.rect_position = Vector2(px, py);
				bt.modulate = e[1]["color"];
				if e[2] == "element":
					bt.get_node("Button").connect("pressed", self, "_on_TTelt_pressed", [e[1]]);
			j += 1;

func _on_TTelt_pressed(elt):
	Global.active_object = elt;
	Global.go_to_page("res://pages/timetable/Create_Element.tscn");

func _ready():
	aff_date();
	update_period();
	clear_timetable();
	draw_timetable();
	get_tree().get_root().connect("size_changed", self, "_on_resized")
	#
	Global.resize_all_fonts();

func update_period():
	$VBoxContainer/HBoxContainer2/Bt_period.text = periods[Global.tt_crt_period];
	for i in range(7):
		get_node("VBoxContainer/ScrollContainer/HBoxContainer/j"+String(i)).visible = (i<=iperiods[Global.tt_crt_period]);


func _on_Bt_manage_pressed():
	Global.go_to_page("res://pages/timetable/gerer_edt.tscn", false);


func _on_Bt_Create_pressed():
	Global.active_object = null;
	Global.go_to_page("res://pages/timetable/Create_Element.tscn");


func _on_Bt_period_pressed():
	Global.tt_crt_period = (Global.tt_crt_period+1)%len(periods);
	$VBoxContainer/HBoxContainer2/Bt_period.text = tr(periods[Global.tt_crt_period]);
	var next_day: Dictionary = Calendar.new().avance_days(current_date["day"], current_date["month"], current_date["year"], iperiods[Global.tt_crt_period]);
	$VBoxContainer/HBoxContainer2/HBoxContainer/interval.text = String(current_date["day"])+"/"+String(current_date["month"])+"/"+String(current_date["year"])+" - "+String(next_day["day"])+"/"+String(next_day["month"])+"/"+String(next_day["year"]);
	update_period();
	clear_timetable();
	draw_timetable();


func _on_Bt_before_pressed():
	current_date = cal.avance_days(current_date["day"], current_date["month"], current_date["year"], -(iperiods[Global.tt_crt_period]+1));
	aff_date();
	clear_timetable();
	draw_timetable();

func _on_Bt_after_pressed():
	current_date = cal.avance_days(current_date["day"], current_date["month"], current_date["year"], iperiods[Global.tt_crt_period]+1);
	aff_date();
	clear_timetable();
	draw_timetable();


func _on_resized():
	clear_timetable();
	draw_timetable();
