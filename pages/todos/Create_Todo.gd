extends Control


var titre = "";
var day = 0;
var month = 0;
var year = 0;

var mode = "create";

var subtasks = []; # ["task", true/false]

var original_cal = -1;
var cal = 0;

var td = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	#
	if Global.active_object == null:
		mode = "create";
		#
		var date = OS.get_datetime();
		day = date["day"];
		month = date["month"];
		year = date["year"];
		cal = 0;
		$VBoxContainer/Bt_suppr.visible = false;
	else:
		mode = "edit";
		#
		td = Global.active_object;
		day = td["date"]["day"];
		month = td["date"]["month"];
		year = td["date"]["year"];
		subtasks = td["subtasks"];
		#
		var i = 0;
		for c in Global.data.calendars:
			if td in c.todos:
				cal = i;
				original_cal = i;
				break;
			i+=1;
		#
		$VBoxContainer/Titre/LineEdit.text = td["title"];
		$VBoxContainer/Calendrier/OptionButton.selected = cal;
		$VBoxContainer/Date/Date.text = String(day) + "/"+ String(month) + "/" + String(year);
		var pc = Global.percent_of_subtask(subtasks) * 100.0;
		$VBoxContainer/percent/ProgressBar.value = pc;
		$VBoxContainer/percent/Label.text = String(int(pc));
	#
	display_date();
	#
	var i = 0;
	for c in Global.data.calendars:
		$VBoxContainer/Calendrier/OptionButton.add_item(c.title);
		#
		if i == cal:
			$VBoxContainer/Calendrier/OptionButton.selected = i;
		#
		i+=1;
	#
	i = 0;
	for st in subtasks:
		add_subtask_ui(st[0], st[1], i);
		i+=1;
	#
	Global.resize_all_fonts();

func add_subtask_ui(t, done, idx):
	var hb = HBoxContainer.new();
	var cb = CheckBox.new();
	var lb = Label.new();
	var bt = Button.new();
	cb.add_icon_override("checked", preload("res://res/ui/checkbox/checked2.png"));
	cb.add_icon_override("unchecked", preload("res://res/ui/checkbox/unchecked2.png"));
	#
	cb.pressed = done;
	lb.text = t;
	bt.text = "X";
	hb.add_child(cb);
	hb.add_child(lb);
	hb.add_child(bt);
	$VBoxContainer/subtasks.add_child(hb);
	bt.connect("pressed", self, "_on_delete_subtask", [idx, hb]);
	cb.connect("pressed", self, "_on_toggle_subtask", [idx, cb]);

func _on_delete_subtask(idx, ui_row):
	subtasks.remove(idx);
	ui_row.queue_free();
	var pc = Global.percent_of_subtask(subtasks) * 100.0;
	$VBoxContainer/percent/ProgressBar.value = pc;
	$VBoxContainer/percent/Label.text = String(int(pc))+"% done";

func _on_toggle_subtask(idx, cb):
	subtasks[idx][1] = cb.pressed;
	var pc = Global.percent_of_subtask(subtasks) * 100.0;
	$VBoxContainer/percent/ProgressBar.value = pc;
	$VBoxContainer/percent/Label.text = String(int(pc))+"% done";


func display_date():
	$VBoxContainer/Date/Date.text = String(day)+"/"+String(month)+"/"+String(year);


func _on_Bt_delete_pressed():
	for c in Global.data.calendars:
		if td in c.todos:
			c.todos.erase(td);
			break;
	Global.save_data();
	Global.go_to_page("res://pages/todos/page_todos.tscn");


func _on_Bt_cancel_pressed():
	Global.go_to_page("res://pages/todos/page_todos.tscn");

func test():
	if $VBoxContainer/Titre/LineEdit.text == "":
		return false;
	return true;


func _on_Bt_validate_pressed():
	if test():
		if mode == "create":
			Global.data.calendars[cal].todos.append({
				"title": $VBoxContainer/Titre/LineEdit.text,
				"description": "",
				"date": {"day": day, "month": month, "year": year},
				"subtasks": subtasks
			})
		elif mode == "edit":
			Global.data.calendars[original_cal].todos.erase(td);
			Global.data.calendars[cal].todos.append({
				"title": $VBoxContainer/Titre/LineEdit.text,
				"description": "",
				"date": {"day": day, "month": month, "year": year},
				"subtasks": subtasks
			});
		Global.save_data();
		Global.go_to_page("res://pages/todos/page_todos.tscn");
	


func _on_CalendarButton_date_selected(date_obj):
	day = date_obj.day();
	month = date_obj.month();
	year = date_obj.year();
	display_date();

func _on_Bt_add_subtask_pressed():
	var t: String = $"VBoxContainer/Add subtask/LineEdit".text;
	if t != "":
		subtasks.append([t, false]);
		add_subtask_ui(t, false, len(subtasks)-1);
		$"VBoxContainer/Add subtask/LineEdit".text = "";
	


func _on_OptionButton_item_selected(index):
	cal = index;
