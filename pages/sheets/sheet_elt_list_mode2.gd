extends Control

const col0: Color = Color(1, 0, 0);
const col1: Color = Color(0, 1, 0);
const colm1: Color = Color(0.5, 0.5, 0.5);

var today: Dictionary = OS.get_datetime();
var tdarr: Array = [today["year"], today["month"], today["day"]];

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.active_object == null:
		Global.go_to_page("res://pages/sheets/page_dossiers_sheets.tscn", false);
	Global.active_object["mode_aff"] = 2;
	if not "dim_active" in Global.active_object.keys():
		Global.active_object["dim_active"] = false;
		Global.active_object["dim_last"] = tdarr;
		Global.active_object["dim_vit"] = 0.25;
		
	save_dt();
	#
	$VBoxContainer/Cb_diminution/Cb_diminution.pressed = Global.active_object["dim_active"];
	$VBoxContainer/DIMINUTION.visible = Global.active_object["dim_active"];
	$VBoxContainer/DIMINUTION/LineEdit.text = String(Global.active_object["dim_vit"]);
	#
	$VBoxContainer/Titre/Title.text = Global.active_object["titre"];
	$VBoxContainer/Cols/Col1/col1.text = Global.active_object["col1"];
	$VBoxContainer/Cols/Col2/col2.text = Global.active_object["col2"];
	#
	var id_elt: int = 0;
	for elt in Global.active_object["data"]:
		var roelt:Control = preload("res://pages/sheets/Bt_elt_mode2.tscn").instance();
		roelt.anchor_top = 0;
		roelt.anchor_bottom = 1;
		roelt.anchor_left = 0;
		roelt.anchor_right = 1;
		roelt.get_node("Button").connect("pressed", self, "element_clicked", [id_elt]);
		# roelt.get_node("RenderText").set_text(elt[0]);
		if elt[2] == -1:
			roelt.get_node("Button").modulate = colm1;
		else:
			roelt.get_node("Button").modulate = Color(1.0-(elt[2]/10.0), elt[2]/10.0, 0);
		$VBoxContainer/ScrollContainer/Elements.add_child(roelt);
		roelt.set_text(elt[0]);
		id_elt += 1;
	#
	Global.resize_all_fonts();

func element_clicked(id_elt):
	Global.active_elt = id_elt;
	Global.go_to_page("res://pages/sheets/Feuille_Elt_mode2.tscn", false);

func save_dt():
	Global.get_cur_dir_dict()[Global.active_object["id"]] = Global.active_object;
	Global.save_data();

func on_element_changed(elt, roelt):
	var t1: String = roelt.get_node("C1/TextEdit").text;
	var t2: String = roelt.get_node("C2/TextEdit").text;
	#
	var id_elt = Global.active_object["data"].find(elt);
	if id_elt != -1:
		Global.get_cur_dir_dict()[Global.active_object["id"]]["data"][id_elt][0] = t1;
		Global.get_cur_dir_dict()[Global.active_object["id"]]["data"][id_elt][1] = t2;
		Global.save_data();

func delete_row_elt(elt, roelt):
	Global.active_object["data"].erase(elt);
	roelt.queue_free();
	save_dt();

func _on_Bt_back_pressed():
	if $VBoxContainer/Cb_diminution/Cb_diminution.pressed:
		Global.active_object["dim_active"] = true;
		Global.active_object["dim_last"] = tdarr;
		Global.active_object["dim_vit"] = 0.25;
		if Global.is_str_float($VBoxContainer/DIMINUTION/LineEdit.text):
			Global.active_object["dim_vit"] = float($VBoxContainer/DIMINUTION/LineEdit.text);
	else:
		Global.active_object["dim_active"] = false;
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
	#
	Global.popup_confirm.visible = true;
	Global.popup_confirm.get_node("Control/Panel/VBoxContainer/Texte").text = tr("KEY_VL_SUPPR")+" "+tr("KEY_CET_EVENT")+" ?";
	Global.disconnect_all_signals(Global.popup_confirm.get_node("Control/Panel/VBoxContainer/HBoxContainer/Bt_valider"));
	Global.popup_confirm.get_node("Control/Panel/VBoxContainer/HBoxContainer/Bt_valider").connect("pressed", self, "delete_aux");
	#

func delete_aux():
	Global.popup_confirm.get_node("Control/Panel/VBoxContainer/HBoxContainer/Bt_valider").disconnect("pressed", self, "delete_aux");
	Global.popup_confirm.visible = false;
	#
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
	Global.active_object["data"].append(["element col1", "element col1", -1]);
	save_dt();
	Global.active_elt = len(Global.active_object["data"])-1;
	Global.go_to_page("res://pages/sheets/Feuille_Elt_mode2.tscn", false);

func _on_Bt_toggle_mode_to_mode1_pressed():
	Global.go_to_page("res://pages/sheets/create_sheet.tscn", false);

func _on_Bt_Export_pressed():
	Global.go_to_page("res://pages/sheets/Export_Sheet.tscn");


func _on_Cb_diminution_toggled(button_pressed):
	$VBoxContainer/DIMINUTION.visible = button_pressed;
