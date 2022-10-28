extends Control

class_name Bt_elt_mode2

var changed: bool = false;

func set_text(t: String):
	print("SET TEXT : ", t);
	$RenderText.set_text(t);
	changed = true;

func _process(delta):
	if changed:
		changed = false;
		rect_min_size.y = max($RenderText.get_node("Control/Label").rect_size.y, $RenderText.get_node("Control/Control/Control/Sprite").texture.size.y*$RenderText.get_node("Control/Control/Control/Sprite").scale.y) + 15;
