extends Control

var text: String = "";
var multi: String = ""; # "" = no multi, other = multi
var min_scale: float = 0.4;
onready var hflow: HFlowContainer = $Control/HFlowContainer;

var dl: String = Global.settings["deb_lat"];
var el: String = Global.settings["end_lat"];

var changed: bool = false;
var count_changed: int = 0;

var parties: Array = []; # pour chaque élément : 0 = text, 1 = type (0=label, 1 = math)

func create_label(t: String) -> Label:
	var lbl: Label = Label.new();
	lbl.text = t;
	lbl.mouse_filter =Control.MOUSE_FILTER_IGNORE;
	lbl.add_color_override("font_color", Color(0, 0, 0));
	return lbl;

func create_math(t: String) -> Control:
	var ctr: Control = Control.new();
	ctr.name = "Control";
	ctr.mouse_filter = Control.MOUSE_FILTER_IGNORE;
	#
	var ctr2: Control = Control.new();
	ctr2.name = "Control";
	ctr2.mouse_filter = Control.MOUSE_FILTER_IGNORE;
	ctr2.anchor_left = 0.5;
	ctr2.anchor_top = 0.5;
	ctr2.anchor_bottom = 0.5;
	ctr2.anchor_right = 0.5;
	ctr.add_child(ctr2);
	var sprt: Sprite = Sprite.new();
	sprt.name = "Sprite";
	ctr2.add_child(sprt);
	sprt.set_script(load("res://addons/GodoTeX/LaTeX.cs"));
	sprt.FontSize = 80;
	sprt.scale = Vector2(0.25, 0.25);
	sprt.LatexExpression = t;
	sprt.Render();
	#
	sprt.position = Vector2(0,5.0*float(Global.settings["font_size"])/100.0);
	sprt.centered = true;
	ctr.rect_min_size = sprt.texture.size * sprt.scale;
	ctr.rect_min_size.y /= 2.0;
	return ctr;

func create_empty_row() -> Node:
	var lbl = Panel.new();
	lbl.modulate = Color(0, 0, 0, 0);
	lbl.rect_min_size.x = hflow.rect_size.x*1;
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE;
	return lbl;

func decompose_text(tt: String) -> void: # On est sur qu'il n'y a pas de latex dedans
	var at: PoolStringArray = tt.split("\n");
	for i in range(len(at)):
		if i != 0:
			parties.append(["", 2])
		var t: String = at[i];
		var ii: int = 0; # On va séparer les espaces en plusieurs sous label, pour avoir un meilleur rendu (? au coût de performances ?, je ne pense pas trop, a moins que le nombre d'espace ne soit bcp trop grand, mais faut faire exprès la quand même)
		if ii == -1:
			parties.append([t, 0]);
		else:
			while ii != -1:
				var nii:int = t.find(" ", ii+1);
				if nii != -1:
					parties.append([t.substr(ii, nii-ii), 0]);
				else:
					parties.append([t.substr(ii), 0]); # C'est la dernière partie sans espaces
				ii = nii;

func decompose_parties_base(txt: String) -> void:
	# On va décomposer le texte entre les différentes parties :
	# Une balise de math est séparée entre "\[" et "\]"
	# Si on trouve un "\[" et que l'on ne trouve pas de "\]" après, cela ne compte pas comme une balise de math
	var i0: int = 0; # current position on text
	var idm: int = txt.find(dl, i0);
	while idm != -1 and len(txt)-i0 > 1: # Tant qu'on en trouve:
		# On vérifie que la séquence n'est pas précédée d'un backslash => Annule la séquence
		if idm == 0 or txt[idm-1] != "\\":
			# On cherche s'il y a bien une balise de fermeture pour la séquence de math
			var ifm: int = txt.find(el, idm+len(dl));
			while ifm != -1 and txt[ifm-1] == "\\": # On en a trouvée une, mais elle est annulée par un '\'
				ifm = txt.find(el, ifm+len(el)); # Donc on en cherche une plus loin
			if ifm != -1:
				# On ajoute d'abord le text avant :
				decompose_text(txt.substr(i0, idm-i0));
				# On ajoute ensuite la partie de math
				parties.append([txt.substr(idm+len(dl), ifm-idm-len(el)), 1]);
				# On update le curseur dans notre texte
				i0 = ifm+len(el);
			else:
				# Il n'y a pas de parties de math
				# On ajoute tout le texte restant
				decompose_text(txt.substr(i0));
				i0 = len(txt);
		else:
			i0 = idm + len(dl);
		#
		idm = txt.find(dl, i0);
	#
	# On ajoute le texte restant s'il y en a un
	if len(txt)-i0 > 0:
		decompose_text(txt.substr(i0));

func set_text(txt: String, mult: String = ""):
	text = txt;
	multi = mult;
	# On nettoie ce qu'il pourrait y avoit avant
	Global.empty_childs(hflow);
	# On décompose
	parties = [];
	if multi == "":
		decompose_parties_base(txt);
	else:
		var pts: PoolStringArray = txt.split(multi);
		for i in range(len(pts)):
			if i != 0:
				parties.append([" "+tr("KEY_OR")+" ", 3, Color("#44075e")])
			#
			decompose_parties_base(pts[i]);
	# Maintenant, pour chaque partie, on va l'afficher
	for p in parties:
		if p[1] == 0: # label
			hflow.add_child(create_label(p[0]));
		elif p[1] == 1: # Maths
			hflow.add_child(create_math(p[0]));
		elif p[1] == 2: # Ligne vide
			hflow.add_child(create_empty_row());
		elif p[1] == 3: # label d'une couleur précise
			var lbl: Label = create_label(p[0]);
			lbl.add_color_override("font_color", p[2]);
			hflow.add_child(lbl);
	#
	changed = true;

func _process(delta):
	if changed:
		if count_changed < 10:
			if count_changed == 5:
				set_text(text, multi);
			count_changed += 1;
		else:
			count_changed = 0;
			changed = false;
			for c in hflow.get_children():
				if c is Control and not (c is Label or c is Panel):
					var sprt: Sprite = c.get_node("Control/Sprite");
					sprt.position = Vector2(0,5.0*float(Global.settings["font_size"])/100.0);
					sprt.centered = true;
					c.rect_min_size = sprt.texture.size * sprt.scale;
					c.rect_min_size.y /= 2.0;
			#
			$Control.rect_min_size = $Control/HFlowContainer.rect_size;
