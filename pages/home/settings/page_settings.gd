extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/FontSize/InpFontSize.value = Global.settings["font_size"];
	$VBoxContainer/FontSize/FontSize.text = String(Global.settings["font_size"])+"%";
	$VBoxContainer/Langue/OptionButton.selected = Global.settings["language"];
	$VBoxContainer/DataLoc/DataPath.text = Global.settings["data_path"];
	$VBoxContainer/DebLat/LineEdit.text = Global.settings["deb_lat"];
	$VBoxContainer/EndLat/LineEdit.text = Global.settings["end_lat"];
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
	Global.settings["font_size"] = float($VBoxContainer/FontSize/InpFontSize.value);
	Global.settings["language"] = $VBoxContainer/Langue/OptionButton.selected;
	Global.settings["deb_lat"] = $VBoxContainer/DebLat/LineEdit.text;
	Global.settings["end_lat"] = $VBoxContainer/EndLat/LineEdit.text;
	TranslationServer.set_locale(Global.langs[Global.settings["language"]]);
	if $VBoxContainer/DataLoc/DataPath.text != Global.settings["data_path"]:
		# On supprime l'ancien fichier de data
		var dir: Directory = Directory.new();
		dir.remove(Global.settings["data_path"]);
		# On change le parametre
		Global.settings["data_path"] = $VBoxContainer/DataLoc/DataPath.text;
		# On sauvegarde à nouveau le fichier
		Global.save_data();
	#
	Global.save_params();
	Global.go_to_page("res://pages/home/settings/page_settings.tscn", false);


func _on_InpFontSize_value_changed(value):
	$VBoxContainer/FontSize/FontSize.text = String(value)+"%";
