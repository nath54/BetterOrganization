extends Node
class_name Calendrier

var title: String = "";

var active: bool = true;

var elements: Array = []; # [{"title": "", "jour": j dans [0::6], deb": heure(float), "fin": heure(float)}]

func _init(titre: String=""):
	self.title = titre;
