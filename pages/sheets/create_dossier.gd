extends Control

var mode = "create";

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.active_object == null:
		mode = "create";
		$VBoxContainer/ScrollContainer/Inputs/VBoxContainer2.visible = false;
	else:
		mode = "edit";
		$VBoxContainer/ScrollContainer/Inputs/Titre/LineEdit.text = Global.current_dir[len(Global.current_dir)-1];
		$VBoxContainer/ScrollContainer/Inputs/VBoxContainer2.visible = true;
	#
	Global.resize_all_fonts();

func _on_Bt_Delete_pressed():
	#
	Global.popup_confirm.visible = true;
	Global.popup_confirm.get_node("Control/Panel/VBoxContainer/Texte").text = tr("KEY_VL_SUPPR")+" "+tr("KEY_CE_DIR")+" ?";
	Global.disconnect_all_signals(Global.popup_confirm.get_node("Control/Panel/VBoxContainer/HBoxContainer/Bt_valider"));
	Global.popup_confirm.get_node("Control/Panel/VBoxContainer/HBoxContainer/Bt_valider").connect("pressed", self, "delete_aux");
	#

func delete_aux():
	Global.popup_confirm.get_node("Control/Panel/VBoxContainer/HBoxContainer/Bt_valider").disconnect("pressed", self, "delete_aux");
	Global.popup_confirm.visible = false;
	#
	if len(Global.current_dir) > 0:
		var arr = Array(Global.current_dir);
		var last_dir = arr[len(arr)-1];
		arr.remove(len(arr)-1);
		Global.current_dir = PoolStringArray(arr);
		Global.get_cur_dir_dict().erase(last_dir);
		Global.save_data();
		Global.go_to_page("res://pages/sheets/page_dossiers_sheets.tscn", false);


func _on_Bt_Cancel_pressed():
	Global.go_to_page("res://pages/sheets/page_dossiers_sheets.tscn");

func test():
	if $VBoxContainer/ScrollContainer/Inputs/Titre/LineEdit.text == "":
		return false;
	if mode == "create":
		if $VBoxContainer/ScrollContainer/Inputs/Titre/LineEdit.text in Global.get_cur_dir_dict().keys():
			return false;
	return true;

func _on_Bt_Validate_pressed():
	if test():
		var title: String = $VBoxContainer/ScrollContainer/Inputs/Titre/LineEdit.text;
		if mode == "create":
			Global.get_cur_dir_dict()[title] = {"@type": "dir"};
			Global.save_data();
			Global.go_to_page("res://pages/sheets/page_dossiers_sheets.tscn", false);
		else:
			var arr = Array(Global.current_dir);
			var last_dir = arr[len(arr)-1];
			arr.remove(len(arr)-1);
			Global.current_dir = PoolStringArray(arr);
			Global.get_cur_dir_dict()[title] = Global.get_cur_dir_dict()[last_dir];
			Global.get_cur_dir_dict().erase(last_dir);
			Global.save_data();
			Global.current_dir = PoolStringArray(arr+[title]);
			Global.go_to_page("res://pages/sheets/page_dossiers_sheets.tscn", false);
			
		
