extends Control

var cur_dir_dict = Global.get_cur_dir_dict();

# Called when the node enters the scene tree for the first time.
func _ready():
	print("READY : dir : ", Global.current_dir)
	$VBoxContainer/HBoxContainer/Label.text = "/"+Global.current_dir.join("/");
	draw_subdirs();

func draw_subdirs():
	if len(Global.current_dir) == 0:
		$VBoxContainer/Sous_Dossiers/Bt_prev_dir.visible = false;
		$VBoxContainer/HBoxContainer/Bt_Edit.visible = false;
	else:
		$VBoxContainer/Sous_Dossiers/Bt_prev_dir.visible = true;
		$VBoxContainer/HBoxContainer/Bt_Edit.visible = true;
	#
	for c in cur_dir_dict.keys():
		if c != "@type":
			if cur_dir_dict[c]["@type"] == "dir":
				var bt = preload("res://pages/sheets/Bt_Dossier.tscn").instance();
				bt.get_node("HBoxContainer/Label").text = c;
				bt.get_node("Button").connect("pressed", self, "_on_bt_dir_pressed", [c]);
				bt.rect_min_size.y = 55;
				$VBoxContainer/Sous_Dossiers.add_child(bt);
			elif cur_dir_dict[c]["@type"] == "sheet":
				# Its a sheet
				pass

func _on_bt_dir_pressed(dir_name: String):
	Global.current_dir = PoolStringArray(Array(Global.current_dir)+[dir_name]);
	Global.go_to_page("res://pages/sheets/page_dossiers_sheets.tscn", false);

func _on_Bt_back_pressed():
	Global.main_nav.really_change_page("res://pages/sheets/page_sheets.tscn");


func _on_Bt_Create_pressed():
	Global.active_object = null;
	Global.main_nav.really_change_page("res://pages/sheets/create_dossier.tscn", false);

func _on_Bt_Create_Sheet_pressed():
	Global.main_nav.really_change_page("res://pages/sheets/create_sheet.tscn", false);


func _on_Bt_prev_dir_pressed():
	if len(Global.current_dir) > 0:
		var arr = Array(Global.current_dir);
		arr.remove(len(arr)-1);
		Global.current_dir = PoolStringArray(arr);
		Global.go_to_page("res://pages/sheets/page_dossiers_sheets.tscn", false);





func _on_Bt_Edit_pressed():
	Global.active_object = Global.current_dir;
	Global.go_to_page("res://pages/sheets/create_dossier.tscn", false);
