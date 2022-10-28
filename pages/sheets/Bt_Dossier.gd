extends HBoxContainer

var changed: bool = false;

func set_text(t: String) -> void:
	$Button/HBoxContainer/Label.text = t;
	changed = true;

func _process(delta):
	if changed:
		rect_min_size.y = max($Button/HBoxContainer/Label.rect_size.y, $Button/HBoxContainer.rect_size.y)+15;
		changed = false;
	
