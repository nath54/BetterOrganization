extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/FontSize/InpFontSize.value = Global.settings["font_size"];
	$VBoxContainer/FontSize/FontSize.text = String(Global.settings["font_size"])+"%";
	$VBoxContainer/Langue/OptionButton.selected = Global.settings["language"];
	$VBoxContainer/DataLoc/DataPath.text = Global.settings["data_path"];
	#
	Global.resize_all_fonts();

func _on_Bt_path_edit_pressed():
	$VBoxContainer/DataLoc/InpDataPath.text = $VBoxContainer/DataLoc/DataPath.text;
	$VBoxContainer/DataLoc/DataPath.visible = false;
	$VBoxContainer/DataLoc/Bt_path_edit.visible = false;
	$VBoxContainer/DataLoc/InpDataPath.visible = true;
	$VBoxContainer/DataLoc/Bt_path_validate.visible = true;

func _on_Bt_path_validate_pressed():
	$VBoxContainer/DataLoc/DataPath.text = $VBoxContainer/DataLoc/InpDataPath.text;
	$VBoxContainer/DataLoc/DataPath.visible = true;
	$VBoxContainer/DataLoc/Bt_path_edit.visible = true;
	$VBoxContainer/DataLoc/InpDataPath.visible = false;
	$VBoxContainer/DataLoc/Bt_path_validate.visible = false;


func _on_Bt_retour_pressed():
	Global.go_to_page("res://pages/home/page_home.tscn");

func _on_Bt_apply_pressed():
	# TODO, sauvegarder les données et recharger la page
	Global.settings["font_size"] = $VBoxContainer/FontSize/InpFontSize.value;
	Global.settings["language"] = $VBoxContainer/Langue/OptionButton.selected;
	#
	Global.save_params();
	Global.go_to_page("res://pages/home/settings/page_settings.tscn", false);


func _on_InpFontSize_value_changed(value):
	$VBoxContainer/FontSize/FontSize.text = String(value)+"%";
