extends Control


var t1: String;
var t2: String;

var side: int = 0; # 0 = col1,   1 = col2

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.active_elt == null:
		Global.go_to_page("res://pages/sheets/sheet_elt_list_mode2.tscn");
	#
	t1 = Global.active_object["data"][Global.active_elt][0];
	t2 = Global.active_object["data"][Global.active_elt][1];
	#
	$VBoxContainer/BoxEdit/TextEdit.text = t1;
	$VBoxContainer/BoxRender/RenderText.set_text(t1);
	$VBoxContainer/HBoxContainer/Label.text = Global.active_object["col1"];


func _on_Bt_hide_rendert_pressed():
	$VBoxContainer/BoxNoRender.visible = true;
	$VBoxContainer/BoxRender.visible = false;

func _on_Bt_hide_textedit_pressed():
	$VBoxContainer/BoxEdit.visible = false;
	$VBoxContainer/BoxNoEdit.visible = true;

func _on_Bt_show_render_pressed():
	$VBoxContainer/BoxNoRender.visible = false;
	$VBoxContainer/BoxRender.visible = true;

func _on_Bt_show_edit_pressed():
	$VBoxContainer/BoxEdit.visible = true;
	$VBoxContainer/BoxNoEdit.visible = false;

func _on_TextEdit_text_changed():
	if $VBoxContainer/BoxRender.visible:
		$VBoxContainer/BoxRender/RenderText.set_text($VBoxContainer/BoxEdit/TextEdit.text);

func _on_Bt_flip_pressed():
	if side == 0:
		t1 = $VBoxContainer/BoxEdit/TextEdit.text;
		side = 1;
	else:
		t2 = $VBoxContainer/BoxEdit/TextEdit.text;
		side = 0;
	#
	if side == 0:
		$VBoxContainer/BoxEdit/TextEdit.text = t1;
		$VBoxContainer/BoxRender/RenderText.set_text(t1);
		$VBoxContainer/HBoxContainer/Label.text = Global.active_object["col1"];
	else:
		$VBoxContainer/BoxEdit/TextEdit.text = t2;
		$VBoxContainer/BoxRender/RenderText.set_text(t2);
		$VBoxContainer/HBoxContainer/Label.text = Global.active_object["col2"];


func _on_Bt_retour_pressed():
	if side == 0:
		t1 = $VBoxContainer/BoxEdit/TextEdit.text;
	else:
		t2 = $VBoxContainer/BoxEdit/TextEdit.text;
	Global.active_object["data"][Global.active_elt][0] = t1;
	Global.active_object["data"][Global.active_elt][1] = t2;
	Global.get_cur_dir_dict()[Global.active_object["id"]] = Global.active_object;
	Global.save_data();
	Global.go_to_page("res://pages/sheets/sheet_elt_list_mode2.tscn");


func _on_Bt_delete_pressed():
	Global.active_object["data"].remove(Global.active_elt);
	Global.get_cur_dir_dict()[Global.active_object["id"]] = Global.active_object;
	Global.save_data();
	Global.go_to_page("res://pages/sheets/sheet_elt_list_mode2.tscn");
