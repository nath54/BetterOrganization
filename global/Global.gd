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
	else:
		data = init_data();



