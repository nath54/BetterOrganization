extends Control

var text: String = "";
var min_scale: float = 0.4;

func set_text(txt: String, label_color: Color = Color(1,1,1)):
	text = txt;
	if text.begins_with("/math "):
		$Control/Control/Control/Sprite.LatexExpression = text.substr(6);
		$Control/Control/Control/Sprite.Render();
		$Control/Control.visible = true;
		$Control/Label.visible = false;
		resize_sprite_max();
	else:
		$Control/Label.text = text;
		$Control/Label.add_color_override("font_color", label_color);
		$Control/Control.visible = false;
		$Control/Label.visible = true;


func resize_sprite_max():
	var sx:Vector2 = $Control/Control/Control/Sprite.texture.get_size();
	var cx:Vector2 = rect_size*0.90;
	#
	var dx: Vector2 = Vector2(cx.x/sx.x, cx.y/sx.y);
	var mine: float = min(dx.x, dx.y);
	if mine < min_scale:
		mine = min_scale;
		rect_min_size = sx*mine + Vector2(10, 10);
	$Control/Control/Control/Sprite.scale = Vector2(mine, mine);
	if get_parent() is Bt_elt_mode2:
		get_parent().changed = true;

