extends HBoxContainer;

class_name RowSheetElement

signal delete_pressed;
signal element_changed;

# Called when the node enters the scene tree for the first time.
func _ready():
	compile();

func compile():
	print("Compile : ", $C1/TextEdit.text, "  ", $C2/TextEdit.text);
	# C1 : 
	if $C1/TextEdit.text.begins_with("/math "):
		$C1/C/C/Latex.LatexExpression =  $C1/TextEdit.text.substr(6);
		$C1/C/C/Latex.Render();
		$C1/C.visible = true;
		$C1/Text.visible = false;
	else:
		$C1/Text.text = $C1/TextEdit.text;
		$C1/C.visible = false;
		$C1/Text.visible = true;
	$C1/TextEdit.visible = false;
	# C2 : 
	if $C2/TextEdit.text.begins_with("/math "):
		$C2/C/C/Latex.LatexExpression =  $C2/TextEdit.text.substr(6);
		$C2/C/C/Latex.Render();
		$C2/C.visible = true;
		$C2/Text.visible = false;
	else:
		$C2/Text.text = $C2/TextEdit.text;
		$C2/C.visible = false;
		$C2/Text.visible = true;
	$C2/TextEdit.visible = false;
	#
	$C1/Bt_validate.visible = false;
	$C1/Bt_edit.visible = true;
	$C2/Bt_delete.visible = true;

func set_val(t1, t2):
	$C1/TextEdit.text = t1;
	$C2/TextEdit.text = t2;
	compile();

func _on_Bt_delete_pressed():
	emit_signal("delete_pressed");

func _on_Bt_validate_pressed():
	compile();
	emit_signal("element_changed")

func _on_Bt_edit_pressed():
	$C1/C.visible = false;
	$C1/Text.visible = false;
	$C1/TextEdit.visible = true;
	$C2/C.visible = false;
	$C2/Text.visible = false;
	$C2/TextEdit.visible = true;
	#
	$C1/Bt_validate.visible = true;
	$C1/Bt_edit.visible = false;
	$C2/Bt_delete.visible = false;
