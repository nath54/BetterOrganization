extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Bt_Delete_pressed():
	pass # Replace with function body.


func _on_Bt_Cancel_pressed():
	Global.go_to_page("res://pages/sheets/page_dossiers_sheets.tscn");


func _on_Bt_Validate_pressed():
	pass # Replace with function body.
