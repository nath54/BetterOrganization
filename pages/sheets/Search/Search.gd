extends Control

var elements: Array = []; # 0 = col1, 1 = col2, 2 = path_sheet, 3 = id_elt in sheet

var lst_fiches: Array = []; # 0 = dic_fiche, 1 = path_fiche


# Called when the node enters the scene tree for the first time.
func _ready():
	parcour_aux(Global.data.directories, []);
	for lf in lst_fiches:
		var i: int = 0;
		for r in lf[0]["data"]:
			elements.append([r[0], r[1], lf[1], i]);
			i += 1;
	#

func parcour_aux(dir: Dictionary, current_path: Array):
	for de in dir.keys():
		if typeof(dir[de]) == TYPE_DICTIONARY:
			if dir[de]["@type"] == "dir":
				parcour_aux(dir[de], current_path+[de]);
			elif dir[de]["@type"] == "sheet":
				lst_fiches.append([dir[de], current_path+[de]]);

func _on_Bt_retour_pressed():
	Global.go_to_page("res://pages/sheets/page_sheets.tscn");

func _on_Bt_search_pressed():
	Global.empty_childs($VBoxContainer/ScrollContainer/Results);
	var t: String = $VBoxContainer/Search/LineEdit.text.to_lower();
	#
	for e in elements:
		if t in e[0].to_lower() or t in e[1].to_lower():
			var bt = preload("res://pages/sheets/Bt_elt_mode2.tscn").instance();
			bt.get_node("Button").modulate = Color("#c6670f");
			bt.set_text(e[0]);
			bt.get_node("Button").connect("pressed", self, "on_bt_element_click", [e]);
			$VBoxContainer/ScrollContainer/Results.add_child(bt);

func on_bt_element_click(elt: Array):
	$AffElement/VBoxContainer/col1_l.text = Global.get_dict_at_path(elt[2])["col1"];
	$AffElement/VBoxContainer/col1_rt.set_text(elt[0]);
	$AffElement/VBoxContainer/col2_l.text = Global.get_dict_at_path(elt[2])["col2"];
	$AffElement/VBoxContainer/col2_rt.set_text(elt[1]);
	$VBoxContainer.visible = false;
	$AffElement.visible = true;

func _on_Bt_retour2_pressed():
	$VBoxContainer.visible = true;
	$AffElement.visible = false;
