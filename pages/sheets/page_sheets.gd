extends Control

func _on_Bt_Fiches_pressed():
	Global.go_to_page("res://pages/sheets/page_dossiers_sheets.tscn", false);

func _on_Bt_Quiz_pressed():
	Global.go_to_page("res://pages/sheets/quiz/page_prepare_quiz.tscn", false);
