extends Control


var ss: Array = Global.get_all_fiches_selected();
var nb_elts: int = Global.get_fiches_sel_nb_elts(ss);

# Called when the node enters the scene tree for the first time.
func _ready():
	var ss: Array = Global.get_all_fiches_selected();
	var nb_elts: int = Global.get_fiches_sel_nb_elts(ss);
	$VBoxContainer/Nb_fiches.text = "Vous avez sélectionné "+String(len(ss))+" fiches";
	$VBoxContainer/Nb_elements.text = "Pour un total de "+String(nb_elts)+" élements";
	#
	$VBoxContainer/Repeat/CheckBox.pressed = Global.quiz_repeat;
	$VBoxContainer/Max_q/InpNbMaxQ.text = String(Global.quiz_max_q);
	$VBoxContainer/Mode/ModeOptBt.selected = Global.quiz_mode;
	#
	Global.resize_all_fonts();


func _on_Bt_back_pressed():
	Global.go_to_page("res://pages/sheets/page_sheets.tscn");


func _on_bt_preset_repeat_pressed():
	Global.quiz_repeat = true;
	Global.quiz_max_q = -1;
	$VBoxContainer/Repeat/CheckBox.pressed = Global.quiz_repeat;
	$VBoxContainer/Max_q/InpNbMaxQ.text = String(Global.quiz_max_q);


func _on_Bt_preset_10_q_no_repeat_pressed():
	Global.quiz_repeat = false;
	Global.quiz_max_q = 10;
	$VBoxContainer/Repeat/CheckBox.pressed = Global.quiz_repeat;
	$VBoxContainer/Max_q/InpNbMaxQ.text = String(Global.quiz_max_q);


func _on_Bt_lancer_pressed():
	if nb_elts > 0:
		Global.quiz_max_q = int($VBoxContainer/Max_q/InpNbMaxQ.text);
		Global.quiz_repeat = $VBoxContainer/Repeat/CheckBox.pressed;
		Global.quiz_mode = $VBoxContainer/Mode/ModeOptBt.selected;
		Global.go_to_page("res://pages/sheets/quiz/Page_quiz.tscn", false);
