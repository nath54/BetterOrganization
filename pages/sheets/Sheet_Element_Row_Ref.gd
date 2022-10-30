extends HBoxContainer;

class_name RowSheetElement

signal delete_pressed;
signal element_changed;

var text1: String = "";
var text2: String = "";

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func aff():
	if not Global.active_object["multi_active"]:
		$C1/RenderText.set_text(text1);
		$C2/RenderText2.set_text(text2);
	else:
		pass


func set_val(t1: String, t2: String):
	# print("SET VAL : ", t1, "  ", t2);
	text1 = t1;
	text2 = t2;
	$C1/RenderText.set_text(text1);
	$C2/RenderText2.set_text(text2);
	$C1/RenderText.visible = true;
	$C2/RenderText2.visible = true;
	$C1/TextEdit.visible = false;
	$C2/TextEdit.visible = false;
	$C1/Bt_validate.visible = false;
	$C1/Bt_edit.visible = true;
	$C2/Bt_delete.visible = true;

func _on_Bt_delete_pressed():
	emit_signal("delete_pressed");

func _on_Bt_validate_pressed():
	text1 = $C1/TextEdit.text;
	text2 = $C2/TextEdit.text;
	$C1/RenderText.set_text(text1);
	$C2/RenderText2.set_text(text2);
	$C1/RenderText.visible = true;
	$C2/RenderText2.visible = true;
	$C1/TextEdit.visible = false;
	$C2/TextEdit.visible = false;
	$C1/Bt_validate.visible = false;
	$C1/Bt_edit.visible = true;
	$C2/Bt_delete.visible = true;
	emit_signal("element_changed")

func _on_Bt_edit_pressed():
	$C1/TextEdit.text = text1;
	$C2/TextEdit.text = text2;
	$C1/RenderText.visible = false;
	$C2/RenderText2.visible = false;
	$C1/TextEdit.visible = true;
	$C2/TextEdit.visible = true;
	#
	$C1/Bt_validate.visible = true;
	$C1/Bt_edit.visible = false;
	$C2/Bt_delete.visible = false;
