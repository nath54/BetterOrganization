extends Control

func _ready():
	#
	Global.resize_all_fonts();

func _on_Bt_Fiches_pressed():
	Global.go_to_page("res://pages/sheets/page_dossiers_sheets.tscn", false);

func _on_Bt_Quiz_pressed():
	Global.go_to_page("res://pages/sheets/quiz/page_prepare_quiz.tscn", false);

func _on_Bt_A_reviser_pressed():
	Global.go_to_page("res://pages/sheets/A reviser/A reviser.tscn", false);

func _on_Bt_Search_pressed():
	Global.go_to_page("res://pages/sheets/Search/Search.tscn", false);
