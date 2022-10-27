extends Control



var todos_list = []; # 0 = date, 1 = event

# Called when the node enters the scene tree for the first time.
func _ready():
	for c in Global.data.calendars:
		if c.active:
			for td in c.todos:
				# On trie dans l'ordre chronologique*/
				todos_list.append([[td["date"]["year"], td["date"]["month"], td["date"]["day"]], td]);
	#
	if len(todos_list) == 0:
		pass
	else:
		Global.empty_childs($VBoxContainer/ScrollContainer/VBoxContainer);
		#
		todos_list.sort_custom(Global, "custom_arrdate_sort");
		#
		for td in todos_list:
			var bttd = preload("res://pages/todos/button_element.tscn").instance();
			bttd.get_node("VBoxContainer/Label").text = td[1]["title"];
			bttd.get_node("Button").connect("pressed", self, "on_bt_clicked", [td[1]]);
			var pc = Global.percent_of_subtask(td[1]["subtasks"]) * 100;
			bttd.get_node("VBoxContainer/HBoxContainer/ProgressBar").value = pc;
			bttd.get_node("VBoxContainer/HBoxContainer/Label").text = String(int(pc))+"% done";
			$VBoxContainer/ScrollContainer/VBoxContainer.add_child(bttd);
	#
	Global.resize_all_fonts();

func _on_Bt_create_pressed():
	Global.active_object = null;
	Global.go_to_page("res://pages/todos/Create_Todo.tscn", false);

func on_bt_clicked(td):
	Global.active_object = td;
	Global.go_to_page("res://pages/todos/Create_Todo.tscn", false);

