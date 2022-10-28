extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.active_object == null:
		Global.go_to_page("res://pages/sheets/page_dossiers_sheets.tscn", false);
	Global.active_object["mode_aff"] = 1;
	save_dt();
	#
	$VBoxContainer/Titre/Title.text = Global.active_object["titre"];
	$VBoxContainer/SepChar/SepChars.text = Global.active_object["sep_chars"];
	$VBoxContainer/Cols/Col1/col1.text = Global.active_object["col1"];
	$VBoxContainer/Cols/Col2/col2.text = Global.active_object["col2"];
	#
	for elt in Global.active_object["data"]:
		var roelt:RowSheetElement = preload("res://pages/sheets/Sheet_Element_Row_Ref.tscn").instance();
		roelt.set_val(elt[0], elt[1]);
		roelt.connect("delete_pressed", self, "delete_row_elt", [elt, roelt]);
		roelt.connect("element_changed", self, "on_element_changed", [elt, roelt]);
		$VBoxContainer/ScrollContainer/Elements.add_child(roelt);
	#
	Global.resize_all_fonts();

func save_dt():
	Global.get_cur_dir_dict()[Global.active_object["id"]] = Global.active_object;
	Global.save_data();

func on_element_changed(elt, roelt):
	var t1: String = roelt.text1;
	var t2: String = roelt.text2;
	#
	var id_elt = Global.active_object["data"].find(elt);
	# print("ID ELT : ", id_elt);
	if id_elt != -1:
		Global.get_cur_dir_dict()[Global.active_object["id"]]["data"][id_elt][0] = t1;
		Global.get_cur_dir_dict()[Global.active_object["id"]]["data"][id_elt][1] = t2;
		Global.save_data();

func delete_row_elt(elt, roelt):
	Global.active_object["data"].erase(elt);
	roelt.queue_free();
	save_dt();

func _on_Bt_back_pressed():
	save_dt();
	Global.go_to_page("res://pages/sheets/page_dossiers_sheets.tscn", false);

func _on_Bt_validate_titre_pressed():
	$VBoxContainer/Titre/Title.text = $VBoxContainer/Titre/TitleEdit.text;
	$VBoxContainer/Titre/Title.visible = true;
	$VBoxContainer/Titre/Bt_validate_titre.visible = false;
	$VBoxContainer/Titre/TitleEdit.visible = false;
	$VBoxContainer/Titre/Bt_edit_titre.visible = true;
	Global.active_object["titre"] = $VBoxContainer/Titre/TitleEdit.text;
	Global.save_data();

func _on_Bt_edit_titre_pressed():
	$VBoxContainer/Titre/TitleEdit.text =  $VBoxContainer/Titre/Title.text;
	$VBoxContainer/Titre/Title.visible = false;
	$VBoxContainer/Titre/Bt_validate_titre.visible = true;
	$VBoxContainer/Titre/TitleEdit.visible = true;
	$VBoxContainer/Titre/Bt_edit_titre.visible = false


func _on_Bt_delete_sheet_pressed():
	Global.get_cur_dir_dict().erase(Global.active_object["id"]);
	Global.save_data();
	#
	Global.go_to_page("res://pages/sheets/page_dossiers_sheets.tscn", false);


func _on_CheckBox_toggled(button_pressed: bool):
	$VBoxContainer/SepChar.visible = button_pressed;
	#

func _on_Bt_edit_col1_pressed():
	$VBoxContainer/Cols/Col1/edt_col1.text = $VBoxContainer/Cols/Col1/col1.text;
	$VBoxContainer/Cols/Col1/col1.visible = false;
	$VBoxContainer/Cols/Col1/edt_col1.visible = true;
	$VBoxContainer/Cols/Col1/Bt_edit_col1.visible = false;
	$VBoxContainer/Cols/Col1/Bt_validate_col1.visible = true;


func _on_Bt_validate_col1_pressed():
	$VBoxContainer/Cols/Col1/col1.text = $VBoxContainer/Cols/Col1/edt_col1.text;
	$VBoxContainer/Cols/Col1/col1.visible = true;
	$VBoxContainer/Cols/Col1/edt_col1.visible = false;
	$VBoxContainer/Cols/Col1/Bt_edit_col1.visible = true;
	$VBoxContainer/Cols/Col1/Bt_validate_col1.visible = false;
	Global.active_object["col1"] = $VBoxContainer/Cols/Col1/col1.text;
	Global.save_data();


func _on_Bt_edit_col2_pressed():
	$VBoxContainer/Cols/Col2/edt_col2.text = $VBoxContainer/Cols/Col2/col2.text;
	$VBoxContainer/Cols/Col2/col2.visible = false;
	$VBoxContainer/Cols/Col2/edt_col2.visible = true;
	$VBoxContainer/Cols/Col2/Bt_edit_col2.visible = false;
	$VBoxContainer/Cols/Col2/Bt_validate_col2.visible = true;


func _on_Bt_validate_col2_pressed():
	$VBoxContainer/Cols/Col2/col2.text = $VBoxContainer/Cols/Col2/edt_col2.text;
	$VBoxContainer/Cols/Col2/col2.visible = true;
	$VBoxContainer/Cols/Col2/edt_col2.visible = false;
	$VBoxContainer/Cols/Col2/Bt_edit_col2.visible = true;
	$VBoxContainer/Cols/Col2/Bt_validate_col2.visible = false;
	Global.active_object["col2"] = $VBoxContainer/Cols/Col2/col2.text;
	Global.save_data();

func _on_Bt_add_element_pressed():
	Global.active_object["data"].append(["", "", -1]);
	save_dt();
	var roelt:RowSheetElement = preload("res://pages/sheets/Sheet_Element_Row_Ref.tscn").instance();
	roelt.set_val("", "");
	roelt.connect("delete_pressed", self, "delete_row_elt", [Global.active_object["data"][len(Global.active_object["data"])-1], roelt]);
	$VBoxContainer/ScrollContainer/Elements.add_child(roelt);


func _on_Bt_toggle_mode_to_mode_2_pressed():
	Global.go_to_page("res://pages/sheets/sheet_elt_list_mode2.tscn", false);


func _on_Bt_Export_pressed():
	Global.go_to_page("res://pages/sheets/Export_Sheet.tscn");
