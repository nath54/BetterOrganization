extends Node
class_name Calendrier

var title: String = "";

var active: bool = true;

var elements: Array = []; # [{"title": "", "jour": j dans [0::6], deb": heure(float), "fin": heure(float), "color": Color}]

var todos: Array = []; # {"title": "", "description": "", "date": Date};
var events: Array = []; # {"title": "", "description": "", "date": Date, "heure deb": heure(float), "heure fin": heure(float), "color": Color}


func _init(titre: String=""):
	self.title = titre;
