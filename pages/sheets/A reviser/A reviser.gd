extends Control



var lst_fiches: Array = []; # 0 = score, 1 = dic_fiche, 2 = path_fiche



# Called when the node enters the scene tree for the first time.
func _ready():
	Global.ancient_page = "res://pages/sheets/A reviser/A reviser.tscn";
	# On va trier toutes les fiches avec leur score
	# On parcours récursivement les fiches pour les traiter
	parcour_aux(Global.data.directories, []);
	# On trie
	lst_fiches.sort_custom(Global, "custom_arrdate2_sort");
	# 
	var nb: int = 0;
	for lf in lst_fiches:
		if lf[0] <= 0:
			var sum_known: float = 0;
			var nb_known: int = 0;
			var nb_unknown: int = 0;
			var f: Dictionary = lf[1];
			for e in f["data"]:
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
			bt.name = f["id"]+PoolStringArray(lf[2]).join("_");
			if f["active"]:
				bt.get_node("Bt_activ").modulate = Color(0,1,0);
				bt.get_node("Bt_activ").text = "1";
			else:
				bt.get_node("Bt_activ").modulate = Color(0.5, 0.5, 0.5);
				bt.get_node("Button/HBoxContainer/Label").text = "0";
			#bt.get_node("Button/HBoxContainer/Label").text = cur_dir_dict[c]["titre"];
			bt.get_node("Button").connect("pressed", self, "_on_bt_fiche_pressed", [lf]);
			bt.get_node("Bt_activ").connect("pressed", self, "_on_bt_fiche_activ_pressed", [lf]);
			bt.rect_min_size.y = 55;
			bt.set_text(f["titre"]);
			$VBoxContainer/ScrollContainer/VBoxContainer.add_child(bt);



func _on_bt_fiche_activ_pressed(lf: Array) -> void:
	Global.get_dict_at_path(lf[2])["active"] = not Global.get_dict_at_path(lf[2])["active"];
	Global.save_data();
	var bt:HBoxContainer = $VBoxContainer/ScrollContainer/VBoxContainer.get_node(lf[1]["id"]+PoolStringArray(lf[2]).join("_"));
	if Global.get_dict_at_path(lf[2])["active"]:
		bt.get_node("Bt_activ").modulate = Color(0,1,0);
		bt.get_node("Bt_activ").text = "1";
	else:
		bt.get_node("Bt_activ").modulate = Color(0.5, 0.5, 0.5);
		bt.get_node("Bt_activ").text = "0";


func _on_bt_fiche_pressed(lf: Array) -> void:
	Global.active_object = Global.get_dict_at_path(lf[2]);
	if (not "mode_aff" in Global.active_object.keys()) or Global.active_object["mode_aff"] == 1:
		Global.main_nav.really_change_page("res://pages/sheets/create_sheet.tscn", false);
	else:
		Global.main_nav.really_change_page("res://pages/sheets/sheet_elt_list_mode2.tscn", false);




func parcour_aux(dir: Dictionary, current_path: Array):
	for de in dir.keys():
		if typeof(dir[de]) == TYPE_DICTIONARY:
			if dir[de]["@type"] == "dir":
				parcour_aux(dir[de], current_path+[de]);
			elif dir[de]["@type"] == "sheet":
				lst_fiches.append([Global.get_fiche_knowledge_score(dir[de]), dir[de], current_path+[de]]);
	#




func _on_Bt_retour_pressed():
	Global.go_to_page("res://pages/sheets/page_sheets.tscn");
