extends Control

var text: String = "";

func set_text(txt: String):
	text = txt;
	if text.begins_with("/math "):
		$Control2/Control/Sprite.LatexExpression = text.substr(6);
		$Control2/Control/Sprite.Render();
		$Control.visible = true;
		$Label.visible = false;
	else:
		$Label.text = text;
		$Control.visible = false;
		$Label.visible = true;
