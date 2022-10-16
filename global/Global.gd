extends Node

var page: String = "home";
var main_nav: Node = null;

var data: Data;
var active_object;

const DATA_PATH: String = "user://data.tscn";

var file: File = File.new();
var dire: Directory = Directory.new();

func _ready():
	load_data();


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
	file.open(DATA_PATH, File.WRITE);
	file.store_string(JSON.print(dict));
	file.close();

func load_data() -> void:
	if file.file_exists(DATA_PATH):
		print("file exists");
		file.open(DATA_PATH, File.READ);
		var dict: Dictionary = JSON.parse(file.get_as_text()).result;
		file.close();
		data = gidit._dict2inst(dict);
		for c in data.calendars:
			for e in c.elements:
				var cl = e["color"].split(",");
				e["color"] = Color(float(cl[0]), float(cl[1]), float(cl[2]))
	else:
		data = init_data();

func percent_of_subtask(st):
	var nb_finis: float = 0;
	var total: float = 0
	for row in st:
		if row[1]:
			nb_finis += 1.0;
		total += 1.0;
	if total > 0:
		return nb_finis/total;
	else:
		return 0;

func custom_arrdate_sort(bar1, bar2):
	var ar1 = bar1[0];
	var ar2 = bar2[0];
	var l = min(len(ar1), len(ar2));
	for i in range(l):
		if ar1[i] > ar2[i]: return false;
		elif ar1[i] < ar2[i]: return true;
	return false;

func float_to_heure(h: float):
	var rh: int = floor(h);
	h = h - rh;
	var rm: int = h*60;
	return [rh, rm];

func float_to_heure_str(h: float):
	var r = float_to_heure(h);
	return String(r[0])+"h"+String(r[1]);

func str_heure_to_float(s: String):
	var hp: int = s.find("h");
	var rh: float = int(s.substr(0, hp));
	var rm: float = int(s.substr(hp+1, len(s)-hp-1));
	return rh+rm/60.0;

