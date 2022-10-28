extends Control

var cur_dir_dict = Global.get_cur_dir_dict();

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# print("READY : dir : ", Global.current_dir)
	$VBoxContainer/HBoxContainer/Label.text = "/"+Global.current_dir.join("/");
	draw_subdirs();
	#
	Global.resize_all_fonts();

func draw_subdirs() -> void:
	if len(Global.current_dir) == 0:
		$VBoxContainer/ScrollContainer/Sous_Dossiers/Bt_prev_dir.visible = false;
		$VBoxContainer/HBoxContainer/Bt_Edit.visible = false;
	else:
		$VBoxContainer/ScrollContainer/Sous_Dossiers/Bt_prev_dir.visible = true;
		$VBoxContainer/HBoxContainer/Bt_Edit.visible = true;
	#
	for c in cur_dir_dict.keys():
		if c != "@type":
			if cur_dir_dict[c]["@type"] == "dir":
				var bt = preload("res://pages/sheets/Bt_Dossier.tscn").instance();
				bt.name = c;
				var res = get_nb_active(cur_dir_dict[c]);
				var cl: Color = Color(0.5, 0.5, 0.5);
				if res[1] != 0:
					cl = Color(0.5, 0.5, 0.5)*(1.0-float(res[0])/float(res[1])) + Color(0, 1, 0)*float(res[0])/float(res[1]);
				bt.get_node("Bt_activ").modulate = cl;
				bt.get_node("Bt_activ").text = String(res[0])+"/"+String(res[1]);
				# bt.get_node("Button/HBoxContainer/Label").text = c;
				bt.get_node("Button").connect("pressed", self, "_on_bt_dir_pressed", [c]);
				bt.get_node("Bt_activ").connect("pressed", self, "_on_bt_dir_activ_pressed", [c]);
				bt.rect_min_size.y = 55;
				$VBoxContainer/ScrollContainer/Sous_Dossiers.add_child(bt);
				bt.set_text(c);
			elif cur_dir_dict[c]["@type"] == "sheet":
				var sum_known: float = 0;
				var nb_known: int = 0;
				var nb_unknown: int = 0;
				for e in cur_dir_dict[c]["data"]:
					if e[2] == -1:
						nb_unknown += 1;
					else:
						nb_known += 1;
						sum_known += e[2];
				var cl: Color;
				if nb_known + nb_unknown > 0:
					var know_moy: float = 0.0;
					if nb_known > 0:
						know_moy = sum_known / float(nb_known);
					cl = Color(0.5*nb_unknown/(nb_known+nb_unknown)+1*nb_known/(nb_known+nb_unknown)*(1-know_moy), 0.5*nb_known/(nb_known+nb_unknown)+1*nb_known/(nb_known+nb_unknown)*(know_moy), 0.5*nb_known/(nb_known+nb_unknown));
				else:
					cl = Color(1, 1, 1);
				#
				var bt = preload("res://pages/sheets/Bt_Fiche.tscn").instance();
				bt.name = c;
				if cur_dir_dict[c]["active"]:
					bt.get_node("Bt_activ").modulate = Color(0,1,0);
					bt.get_node("Bt_activ").text = "1";
				else:
					bt.get_node("Bt_activ").modulate = Color(0.5, 0.5, 0.5);
					bt.get_node("Button/HBoxContainer/Label").text = "0";
				#bt.get_node("Button/HBoxContainer/Label").text = cur_dir_dict[c]["titre"];
				bt.get_node("Button").connect("pressed", self, "_on_bt_fiche_pressed", [c]);
				bt.get_node("Bt_activ").connect("pressed", self, "_on_bt_fiche_activ_pressed", [c]);
				bt.rect_min_size.y = 55;
				bt.set_text(cur_dir_dict[c]["titre"]);
				$VBoxContainer/ScrollContainer/Sous_Dossiers.add_child(bt);


func get_nb_active(d_dict: Dictionary) -> Array:
	var nb: int = 0;
	var nb_tot: int = 0;
	for de in d_dict.keys():
		if typeof(d_dict[de]) == TYPE_DICTIONARY:
			if d_dict[de]["@type"] == "sheet":
				nb_tot += 1;
				if d_dict[de]["active"]: nb += 1;
			elif d_dict[de]["@type"] == "dir":
				var a = get_nb_active(d_dict[de]);
				nb += a[0];
				nb_tot += a[1];
	return [nb, nb_tot];


func _on_bt_fiche_activ_pressed(fiche_name: String) -> void:
	cur_dir_dict[fiche_name]["active"] = not cur_dir_dict[fiche_name]["active"];
	Global.save_data();
	var bt:HBoxContainer = $VBoxContainer/ScrollContainer/Sous_Dossiers.get_node(fiche_name);
	if cur_dir_dict[fiche_name]["active"]:
		bt.get_node("Bt_activ").modulate = Color(0,1,0);
		bt.get_node("Bt_activ").text = "1";
	else:
		bt.get_node("Bt_activ").modulate = Color(0.5, 0.5, 0.5);
		bt.get_node("Bt_activ").text = "0";


func _on_bt_dir_activ_pressed(dir_name: String) -> void:
	for dd in cur_dir_dict[dir_name].keys():
		if typeof(cur_dir_dict[dir_name][dd]) == TYPE_DICTIONARY:
			if cur_dir_dict[dir_name][dd]["@type"] == "sheet":
				cur_dir_dict[dir_name][dd]["active"] = not cur_dir_dict[dir_name][dd]["active"];
	Global.save_data();
	var res = get_nb_active(cur_dir_dict[dir_name]);
	var bt:HBoxContainer = $VBoxContainer/ScrollContainer/Sous_Dossiers.get_node(dir_name);
	var cl: Color = Color(0.5, 0.5, 0.5);
	if res[1] != 0:
		cl = Color(0.5, 0.5, 0.5)*(1.0-float(res[0])/float(res[1])) + Color(0, 1, 0)*float(res[0])/float(res[1]);
	bt.get_node("Bt_activ").modulate = cl;
	bt.get_node("Bt_activ").text = String(res[0])+"/"+String(res[1]);

func _on_bt_fiche_pressed(fiche_name: String) -> void:
	Global.active_object = cur_dir_dict[fiche_name];
	if (not "mode_aff" in Global.active_object.keys()) or Global.active_object["mode_aff"] == 1:
		Global.main_nav.really_change_page("res://pages/sheets/create_sheet.tscn", false);
	else:
		Global.main_nav.really_change_page("res://pages/sheets/sheet_elt_list_mode2.tscn", false);


func _on_bt_dir_pressed(dir_name: String) -> void:
	Global.current_dir = PoolStringArray(Array(Global.current_dir)+[dir_name]);
	Global.go_to_page("res://pages/sheets/page_dossiers_sheets.tscn", false);

func _on_Bt_back_pressed():
	Global.main_nav.really_change_page("res://pages/sheets/page_sheets.tscn");


func _on_Bt_Create_pressed() -> void:
	Global.active_object = null;
	Global.main_nav.really_change_page("res://pages/sheets/create_dossier.tscn", false);

func _on_Bt_Create_Sheet_pressed() -> void:
	var d: Dictionary = Global.get_cur_dir_dict();
	var titre: String = Global.get_next_free_sheet_name(d);
	d[titre] = {
		"@type": "sheet",
		"id": titre, # NEVER CHANGE !
		"titre": titre, # DISPLAYED NAME
		"mode_aff": 1, # mode d'affichage 1 ou 2
		"sep_chars": "||",
		"col1": "Col1",
		"col2": "Col2",
		"active": false,
		"data": [] # [col1, col2, knowledge lvl] # there will not be subelts or things like that (that would be for proof of a mathematical theorem for instance)
	};
	Global.active_object = d[titre];
	Global.save_data();
	Global.main_nav.really_change_page("res://pages/sheets/create_sheet.tscn", false);

func _on_Bt_prev_dir_pressed() -> void:
	if len(Global.current_dir) > 0:
		var arr = Array(Global.current_dir);
		arr.remove(len(arr)-1);
		Global.current_dir = PoolStringArray(arr);
		Global.go_to_page("res://pages/sheets/page_dossiers_sheets.tscn", false);

func _on_Bt_Edit_pressed() -> void:
	Global.active_object = Global.current_dir;
	Global.go_to_page("res://pages/sheets/create_dossier.tscn", false);


func _on_Bt_import_sheet_pressed():
	Global.go_to_page("res://pages/sheets/Import_Sheet.tscn");
