extends Control

var cur_dir_dict = Global.get_cur_dir_dict();

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("READY : dir : ", Global.current_dir)
	$VBoxContainer/HBoxContainer/Label.text = "/"+Global.current_dir.join("/");
	draw_subdirs();

func draw_subdirs() -> void:
	if len(Global.current_dir) == 0:
		$VBoxContainer/Sous_Dossiers/Bt_prev_dir.visible = false;
		$VBoxContainer/HBoxContainer/Bt_Edit.visible = false;
	else:
		$VBoxContainer/Sous_Dossiers/Bt_prev_dir.visible = true;
		$VBoxContainer/HBoxContainer/Bt_Edit.visible = true;
	#
	for c in cur_dir_dict.keys():
		if c != "@type":
			if cur_dir_dict[c]["@type"] == "dir":
				var bt = preload("res://pages/sheets/Bt_Dossier.tscn").instance();
				bt.get_node("HBoxContainer/Label").text = c;
				bt.get_node("Button").connect("pressed", self, "_on_bt_dir_pressed", [c]);
				bt.rect_min_size.y = 55;
				$VBoxContainer/Sous_Dossiers.add_child(bt);
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
				bt.get_node("HBoxContainer/Label").text = c;
				bt.get_node("Button").connect("pressed", self, "_on_bt_fiche_pressed", [c]);
				bt.rect_min_size.y = 55;
				$VBoxContainer/Sous_Dossiers.add_child(bt);
				

func _on_bt_fiche_pressed(fiche_name: String) -> void:
	Global.active_object = cur_dir_dict[fiche_name];
	Global.main_nav.really_change_page("res://pages/sheets/create_sheet.tscn", false);


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
		"titre": titre,
		"sep_chars": "||",
		"col1": "Col1",
		"col2": "Col2",
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
