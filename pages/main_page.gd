extends Control

onready var ctr = $VSplitContainer/Control;

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.main_nav = self;
	Global.popup_confirm = $C_confirm_popup;
	$VSplitContainer/MainNavBar.connect("change_page", self, "change_page");
	Global.go_to_page("res://pages/home/page_home.tscn");

var pages = {
	"events": "res://pages/events/page_events.tscn",
	"todos": "res://pages/todos/page_todos.tscn",
	"home": "res://pages/home/page_home.tscn",
	"timetable": "res://pages/timetable/page_timetable.tscn",
	"sheets": "res://pages/sheets/page_sheets.tscn"
};

func change_page(page: String):
	really_change_page(pages[page]);
	Global.page = page;

func really_change_page(path: String, show_bar: bool = true):
	Global.empty_childs(ctr);
	var pg = load(path).instance();
	ctr.add_child(pg);
	#
	if show_bar:
		$VSplitContainer/MainNavBar.visible = true;
	else:
		$VSplitContainer/MainNavBar.visible = false;


func _on_Bt_cancel_pressed():
	$C_confirm_popup.visible = false;


