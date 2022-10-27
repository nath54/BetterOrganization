extends Control

var text: String = "";

func set_text(txt: String, label_color: Color = Color(1,1,1)):
	text = txt;
	if text.begins_with("/math "):
		$Control/Control/Sprite.LatexExpression = text.substr(6);
		$Control/Control/Sprite.Render();
		$Control.visible = true;
		$Label.visible = false;
		resize_sprite_max();
	else:
		$Label.text = text;
		$Label.add_color_override("font_color", label_color);
		$Control.visible = false;
		$Label.visible = true;


func resize_sprite_max():
	var sx:Vector2 = $Control/Control/Sprite.texture.get_size();
	var cx:Vector2 = rect_size*0.85;
	#
	var dx: Vector2 = Vector2(cx.x/sx.x, cx.y/sx.y);
	var mine: float = min(dx.x, dx.y);
	$Control/Control/Sprite.scale = Vector2(mine, mine);

