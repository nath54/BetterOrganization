extends Node

var page: String = "home";
var main_nav: Node = null;

var data: Data;
var active_object = null;
var active_elt = null; # For sheets, because active_object is already used

const DATA_PATH: String = "user://data.json";
const SETTINGS_PATH: String = "user://settings.json";

var file: File = File.new();
var dire: Directory = Directory.new();

var tt_crt_period: int = 1;

var current_dir: PoolStringArray = [];

var quiz_repeat: bool = true;
var quiz_max_q: int = -1;
var quiz_mode: int = 0; # 0 = cartes, 1 = écrire

var ancient_page: String = "";

var current_date: Dictionary = OS.get_date();
var cdar: Array = [current_date["year"], current_date["month"], current_date["day"]];

var cal: Calendar = Calendar.new();

const langs: Array = ["fr", "en", "es"];

const default_settings: Dictionary = {
	"font_size": 100, # %
	"language": 0,
	"data_path": DATA_PATH,
	"type_page_princip": 0,
	"theme_app": 0,
	"deb_lat": "\\[",
	"end_lat": "\\]"
};

var settings: Dictionary = default_settings;

var original_font_sizes: Dictionary = {};

var already_modif_fonts: Array = [];

func resize_aux(node: Node) -> void:
	#
	if (node is Label) or (node is Button) or (node is LineEdit) or (node is TextEdit):
		var font: Font = node.get_font("font");
		var sf: String = font.to_string();
		if not sf in original_font_sizes.keys():
			original_font_sizes[sf] = font.size;
		if not font in already_modif_fonts:
			# print("Node: ", node, "  font : ", font, "sf : ", sf);
			font.size = float(original_font_sizes[sf]) * float(settings["font_size"]) / 100.0;
			already_modif_fonts.append(font);
	#
	for c in node.get_children():
		resize_aux(c);

func resize_all_fonts() -> void:
	already_modif_fonts = [];
	resize_aux(get_tree().root);

func get_dict_at_path(path: Array) -> Dictionary:
	var cd: Dictionary = Global.data.directories;
	for i in range(len(path)):
		cd = cd[path[i]];
	return cd;

func get_cur_dir_dict() -> Dictionary:
	return get_dict_at_path(current_dir);

func get_next_free_sheet_name(dire: Dictionary) -> String:
	var i: int = 1;
	while "fiche"+String(i) in dire.keys():
		i += 1;
	return "fiche"+String(i);

func _ready() -> void:
	#
	if OS.get_name() == "Android":
		OS.request_permissions();
	#
	load_params();
	load_data();

func load_params() -> void:
	if file.file_exists(SETTINGS_PATH):
		# print("file exists");
		file.open(SETTINGS_PATH, File.READ);
		settings = JSON.parse(file.get_as_text()).result;
		file.close();
		for k in default_settings.keys():
			if not k in settings.keys():
				settings[k] = default_settings[k];
	#
	TranslationServer.set_locale(Global.langs[Global.settings["language"]]);

func save_params():
	file.open(SETTINGS_PATH, File.WRITE);
	file.store_string(JSON.print(settings));
	file.close();

func init_data() -> Data:
	var dt: Data = Data.new();
	dt.calendars.append(Calendrier.new("BaseCalendar"));
	return dt;

func empty_childs(node: Node) -> void:
	for c in node.get_children():
		c.queue_free();

func go_to_page(path: String, show_bar: bool=true) -> void:
	if main_nav != null:
		main_nav.really_change_page(path, show_bar);

func save_data() -> void:
	var dict: Dictionary = gidit._inst2dict(self.data);
	file.open(self.settings["data_path"], File.WRITE);
	file.store_string(JSON.print(dict));
	file.close();

func load_data() -> void:
	if file.file_exists(self.settings["data_path"]):
		# print("file exists");
		file.open(self.settings["data_path"], File.READ);
		var dict: Dictionary = JSON.parse(file.get_as_text()).result;
		file.close();
		data = gidit._dict2inst(dict);
		for c in data.calendars:
			var asup: Array = [];
			for e in c.elements:
				var cl = e["color"].split(",");
				e["color"] = Color(float(cl[0]), float(cl[1]), float(cl[2]))
			for e in c.events:
				# On marque les "vieux" évenements
				#print(e);
				#print("Distance DAY : ", cal.distance_days([e["date"]["year"], e["date"]["month"], e["date"]["day"]], cdar));
				if cal.distance_days([e["date"]["year"], e["date"]["month"], e["date"]["day"]], cdar) > Global.data.setting_period_delete_evnt:
					asup.append(e);
				var cl = e["color"].split(",");
				e["color"] = Color(float(cl[0]), float(cl[1]), float(cl[2]))
			# On supprime les "vieux" évenements
			for e in asup:
				c.elements.erase(e);
		#
		parcour_aux_sheets_with_func(self.data.directories, funcref(self, "diminush_time"));
		#
		Global.save_data();
	else:
		data = init_data();

func parcour_aux_sheets_with_func(d: Dictionary, fun: FuncRef):
	for de in d.keys():
		if typeof(d[de]) == TYPE_DICTIONARY:
			if d[de]["@type"] == "dir":
				parcour_aux_sheets_with_func(d[de], fun);
			elif d[de]["@type"] == "sheet":
				d[de] = fun.call_func(d[de]);

func diminush_time(sd: Dictionary) -> Dictionary:
	var today: Dictionary = OS.get_datetime();
	var tdarr: Array = [today["year"], today["month"], today["day"]];
	if "dim_active" in sd.keys() and sd["dim_active"] == true:
		if not "dim_last" in sd.keys():
			sd["dim_last"] = tdarr;
		if not "dim_vit" in sd.keys():
			sd["dim_vit"] = 0.25;
		var time_since: int = cal.distance_days(tdarr, sd["dim_last"]);
		var qt: float = sd["dim_vit"] * time_since;
		for i in range(len(sd["data"])):
			sd["data"][i][2] = clamp(sd["data"][i][2]-qt, 0, 10);
	return sd; 


func percent_of_subtask(st: Array) -> float:
	var nb_finis: float = 0;
	var total: float = 0
	for row in st:
		if row[1]:
			nb_finis += 1.0;
		total += 1.0;
	if total > 0:
		return nb_finis/total;
	else:
		return 0.0;

func custom_arrdate_sort(bar1: Array, bar2: Array) -> bool:
	var ar1 = bar1[0];
	var ar2 = bar2[0];
	var l = min(len(ar1), len(ar2));
	for i in range(l):
		if ar1[i] > ar2[i]: return false;
		elif ar1[i] < ar2[i]: return true;
	return false;


# Décroissant, 1 seul elt
func custom_arrdate2_sort(ar1: Array, ar2: Array, sens_croissant:bool=false, max_e: int=1) -> bool:
	var l = min(len(ar1), len(ar2));
	if max_e != -1: l = min(l, max_e);
	#
	for i in range(l):
		if sens_croissant:
			if ar1[i] > ar2[i]: return false;
			elif ar1[i] < ar2[i]: return true;
		else:
			if ar1[i] < ar2[i]: return false;
			elif ar1[i] > ar2[i]: return true;
	# égalité, on ne permute pas les ojets
	return false;

func is_str_integer(t: String):
	if len(t) == 0:
		return false;
	#
	var pos: int = 0;
	for c in t:
		if c == "-":
			if pos != 0:
				return false;
		elif not (c in "0123456789"):
			return false;
		pos += 1;
	return true;

func is_str_float(t: String):
	if len(t) == 0:
		return false;
	var nb_point: int = 0;
	var last_c: String = "";
	var pos: int = 0;
	for c in t:
		if c == ".":
			nb_point += 1;
			if nb_point > 1:
				return false;
		elif c == "-":
			if pos != 0:
				return false;
		elif not (c in "0123456789"):
			return false;
		last_c = c;
		pos += 1;
	#
	if last_c == ".":
		return false;
	#
	return true;

func is_heure_str_bon_format(s: String) -> bool:
	var hp: int = s.find("h");
	if hp == -1:
		return false;
	var rh: String = s.substr(0, hp);
	var rm: String = s.substr(hp+1, len(s)-hp-1);
	if not (is_str_integer(rh) and (rm == "" or is_str_integer(rm))):
		return false;
	var h: int = int(rh);
	var m: int = 0;
	if rm != "": m = int(rm);
	if h < 0 or h >= 24: return false;
	if m < 0 or m >= 60: return false;
	return true;

func float_to_heure(h: float) -> Array:
	var rh: int = floor(h);
	h = h - rh;
	var rm: int = h*60;
	return [rh, rm];

func float_to_heure_str(h: float) -> String:
	var r = float_to_heure(h);
	var sh: String = String(r[0]);
	var sm: String = String(r[1]);
	#if len(sh) == 1: sh = "0"+sh;
	if len(sm) == 1: sm = "0"+sm;
	return sh+"h"+sm;

func str_heure_to_float(s: String) -> float:
	var hp: int = s.find("h");
	var rh: float = int(s.substr(0, hp));
	var rrm: String = s.substr(hp+1, len(s)-hp-1);
	var rm: float = 0;
	if rrm != "": rm = int(rrm);
	return rh+rm/60.0;

func gafs_aux(d: Dictionary, cur_path: Array) -> Array:
	var res: Array = [];
	for de in d.keys():
		if typeof(d[de]) == TYPE_DICTIONARY:
			if d[de]["@type"] == "dir":
				res += gafs_aux(d[de], cur_path+[de]);
			elif d[de]["@type"] == "sheet":
				if d[de]["active"]:
					d[de]["path"] = cur_path+[de];
					res.append(d[de]);
	return res;

func get_all_fiches_selected():
	return gafs_aux(self.data.directories, []);

func get_fiches_sel_nb_elts(afs: Array) -> int:
	var res:int = 0;
	for e in afs:
		res += len(e["data"]);
	return res;

func get_fiche_knowledge_score(fiche: Dictionary) -> float:
	if fiche["data"] == []: return 0.0;
	#
	var score: float = 0.0; # négatif = plutot mauvais, positif = plutot bon
	for row in fiche["data"]:
		score += row[2] - 5; # Compris entre -5 et 5
	score /= float(len(fiche["data"])); 
	return score; # Compris entre -5 et 5
