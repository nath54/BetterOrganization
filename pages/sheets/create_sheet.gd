extends Control

var mode = "create";

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.active_object == null:
		mode = "create";
	else:
		mode = "edit";







func _on_Bt_back_pressed():
	Global.go_to_page("res://pages/sheets/page_dossiers_sheets.tscn", false);



func _on_Bt_validate_titre_pressed():
	$VBoxContainer/Titre/Title.text = $VBoxContainer/Titre/LineEdit.text;
	$VBoxContainer/Titre/Title.visible = true;
	$VBoxContainer/Titre/Bt_validate_titre.visible = false;
	$VBoxContainer/Titre/LineEdit.visible = false;
	$VBoxContainer/Titre/Bt_edit_titre.visible = true;


func _on_Bt_edit_titre_pressed():
	$VBoxContainer/Titre/LineEdit.text = $VBoxContainer/Titre/Title.text;
	$VBoxContainer/Titre/Title.visible = false;
	$VBoxContainer/Titre/Bt_validate_titre.visible = true;
	$VBoxContainer/Titre/LineEdit.visible = true;
	$VBoxContainer/Titre/Bt_edit_titre.visible = false


func _on_Bt_delete_sheet_pressed():
	# TODO
	pass
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
