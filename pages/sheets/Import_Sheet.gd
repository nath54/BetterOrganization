extends Control

var file_path: String = "";
var mode_export: int = 1; # 0 = CSV, 1 = JSON

# Called when the node enters the scene tree for the first time.
func _ready():
	$FileDialog.access = FileDialog.ACCESS_FILESYSTEM;
	$FileDialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS);
	$FileDialog.current_path = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS);
	$FileDialog.mode = FileDialog.MODE_OPEN_FILE; 
	#
	Global.resize_all_fonts();

func test_bon_format(sheet: Dictionary):
	return true;

func _on_Bt_back_pressed():
	Global.go_to_page("res://pages/sheets/page_dossiers_sheets.tscn");

func import_csv():
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
	var titre: String = $VBoxContainer/DETAILS_CSV/Titre/LineEdit.text;
	var sep_chars: String = $VBoxContainer/DETAILS_CSV/Sep_Char/LineEdit.text;
	var col1: String = $VBoxContainer/DETAILS_CSV/Col1/LineEdit.text;
	var col2: String = $VBoxContainer/DETAILS_CSV/Col2/LineEdit.text;
	var sheet: Dictionary = {
		"@type": "sheet",
		"id": titre, # NEVER CHANGE !
		"titre": titre, # DISPLAYED NAME
		"mode_aff": 1, # mode d'affichage 1 ou 2
		"sep_chars": sep_chars,
		"col1": col1,
		"col2": col2,
		"active": false,
		"data": [] # [col1, col2, knowledge lvl] # there will not be subelts or things like that (that would be for proof of a mathematical theorem for instance)
	};
	#
	var file = File.new();
	file.open(file_path, File.READ);
	var text: String = file.get_as_text();
	file.close();
	var rows: PoolStringArray = text.split(rsep);
	for r in rows:
		var col: PoolStringArray = r.split(csep);
		if len(col) != 2:
			return; # ERROR
		sheet["data"].append([col[0], col[1], -1]);
	#
	if titre in Global.get_cur_dir_dict().keys():
		var nb: int = 2;
		while titre+String(nb) in Global.get_cur_dir_dict().keys():
			nb+=1; # Pour éviter les doublons
		titre = titre+String(nb);
		sheet["id"] = titre;
	#
	Global.get_cur_dir_dict()[titre] = sheet;
	Global.save_data();
	Global.go_to_page("res://pages/sheets/page_dossiers_sheets.tscn");


func import_json():
	if file_path == "":
		return;
	#
	var file = File.new();
	file.open(file_path, File.READ);
	var res: JSONParseResult = JSON.parse(file.get_as_text());
	if res.error:
		file.close();
		return
	#
	var sheet: Dictionary = res.result;
	file.close();
	if not test_bon_format(sheet):
		return;
	#
	var titre: String = sheet["id"];
	if titre in Global.get_cur_dir_dict().keys():
		var nb: int = 2;
		while titre+String(nb) in Global.get_cur_dir_dict().keys():
			nb+=1; # Pour éviter les doublons
		titre = titre+String(nb);
		sheet["id"] = titre;
	#
	Global.get_cur_dir_dict()[titre] = sheet;
	Global.save_data();
	Global.go_to_page("res://pages/sheets/page_dossiers_sheets.tscn");

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

func _on_Bt_Import_pressed():
	if mode_export == 0:
		import_csv();
	else:
		import_json();
