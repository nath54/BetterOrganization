extends Control

var file_path: String = "";
var mode_export: int = 1; # 0 = CSV, 1 = JSON

# Called when the node enters the scene tree for the first time.
func _ready():
	$FileDialog.access = FileDialog.ACCESS_FILESYSTEM;
	$FileDialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS);
	$FileDialog.current_path = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS);
	$FileDialog.mode = FileDialog.MODE_SAVE_FILE; 
	#
	Global.resize_all_fonts();



func _on_Bt_back_pressed():
	if Global.active_object == null:
		Global.go_to_page("res://pages/sheets/page_dossiers_sheets.tscn");
	else:
		if Global.active_object["mode_aff"] == 1:
			Global.go_to_page("res://pages/sheets/create_sheet.tscn");
		else:
			Global.go_to_page("res://pages/sheets/sheet_elt_list_mode2.tscn");


func export_csv():
	if file_path == "":
		return;
	#
	var rsep: String = $VBoxContainer/CSV_OPTION/Row_Sep/LineEdit.text;
	var csep: String = $VBoxContainer/CSV_OPTION/Col_Sep/LineEdit.text;
	if rsep == "\\n":
		rsep = "\n";
	if csep == "\\t":
		csep = "\t";
	#
	var text: String = "";
	var is_first: bool = true;
	for col in Global.active_object["data"]:
		if is_first: is_first = false;
		else: text += rsep;
		#
		text += col[0] + csep + col[1];
	#
	if not file_path.ends_with(".csv"):
		file_path += ".csv";
	#
	var file = File.new();
	file.open(file_path, File.WRITE);
	file.store_string(text);
	file.close();


func export_json():
	if file_path == "":
		return;
	#
	if not file_path.ends_with(".json"):
		file_path += ".json";
	#
	var file = File.new();
	file.open(file_path, File.WRITE);
	file.store_string(JSON.print(Global.active_object));
	file.close();

func _on_Bt_Export_pressed():
	if mode_export == 0:
		export_csv();
	else:
		export_json();

func _on_Bt_Path_pressed():
	$FileDialog.popup();

func _on_FileDialog_file_selected(p):
	file_path = p;
	$FileDialog.visible = false;
	$VBoxContainer/Chemin/PATH.text = p;


func _on_OptionButton_item_selected(index):
	mode_export = index;
	if mode_export == 0:
		$VBoxContainer/CSV_OPTION.visible = false;
	else:
		$VBoxContainer/CSV_OPTION.visible = true;
