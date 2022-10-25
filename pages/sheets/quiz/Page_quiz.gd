extends Control

const con_import: Dictionary = {
	-1: 8,
	0: 10,
	1: 7,
	2: 4,
	3: 3,
	4: 1
}

var state: int = 0; # 0 = rien, 1 = question, 2 = réponse, 3 = fini

var ss: Array = Global.get_all_fiches_selected();
var qsts: Array = []; # 0 = importance , 1 = col1, 2 = col2, 3 = id_sheet
var done: Array = [];
var id_q: int = -1;
var col_rep: int = 1;
var col_q: int = 0;
var nb_q: int = 0;
var score: float = 0;

var tot_tire: int = 0;

var rng := RandomNumberGenerator.new();

func aff_page(qc: bool = false, qe: bool = false, rc: bool = false, re: bool = false, fin:bool = false) -> void:
	$Question_mode_carte.visible = qc;
	$Question_mode_ecrire.visible = qe;
	$Reponse_mode_carte.visible = rc;
	$Reponse_mode_ecrire.visible = re;
	$Ecran_Fin.visible = fin;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize();
	# On va préparer les questions
	# On récupère tous les éléments
	var idsh: int = 0;
	for sh in ss:
		for e in sh["data"]:
			qsts.append([con_import[e[2]], e[0], e[1], idsh]);
			tot_tire += con_import[e[2]];
		idsh += 1;
	# On trie les éléments
	qsts.sort_custom(Global, "custom_arrdate2_sort");
	#

func suivant() -> void:
	if not state in [0, 2]:
		return;
	# On enlève la question précedente si pas de repetitions
	if not Global.quiz_repeat and id_q != -1:
		tot_tire -= qsts[id_q][0];
		qsts.remove(id_q);
	# Conditions ecran fin
	if len(qsts) == 0 or (Global.quiz_max_q > 0 and nb_q >= Global.quiz_max_q):
		ecran_fin();
	# On tire la prochaine question
	var a: int = rng.randi_range(0, tot_tire);
	var ii: int = 0;
	var st: int = qsts[0][0];
	while st < a and ii < len(qsts) - 1:
		ii += 1;
		st += qsts[ii][0];
	#
	id_q = ii;
	# On affiche la question
	if Global.quiz_mode == 0: # mode carte
		aff_page(true, false, false, false, false);
		$Question_mode_carte/VBoxContainer/RenderText.set_text(qsts[id_q][col_q+1]);
	else: # mode ecrire
		aff_page(false, true, false, false, false);
		$Question_mode_ecrire/VBoxContainer/RenderText.set_text(qsts[id_q][col_q+1]);
		$Question_mode_ecrire/VBoxContainer/Control/TextEdit.text = "";
		$Question_mode_ecrire/VBoxContainer/Control/HBoxContainer/Bt_Edit.emit_signal("pressed");
	state = 1;

func ecran_fin() -> void:
	aff_page(false, false, false, false, true);
	$Ecran_Fin/VBoxContainer/score.text = "Vous avez effectué "+String(nb_q)+" questions, avec une réussite de "+String(score/float(nb_q))+"%";


func _on_Bt_View_pressed():
	$Question_mode_ecrire/VBoxContainer/Control/HBoxContainer/Bt_View.visible = false;
	$Question_mode_ecrire/VBoxContainer/Control/HBoxContainer/Bt_Edit.visible = true;
	$Question_mode_ecrire/VBoxContainer/Control/TextEdit.visible = false;
	$Question_mode_ecrire/VBoxContainer/Control/RenderText.visible = true;
	$Question_mode_ecrire/VBoxContainer/Control/RenderText.set_text($Question_mode_ecrire/VBoxContainer/Control/TextEdit.text);


func _on_Bt_Edit_pressed():
	$Question_mode_ecrire/VBoxContainer/Control/HBoxContainer/Bt_View.visible = true;
	$Question_mode_ecrire/VBoxContainer/Control/HBoxContainer/Bt_Edit.visible = false;
	$Question_mode_ecrire/VBoxContainer/Control/TextEdit.visible = true;
	$Question_mode_ecrire/VBoxContainer/Control/RenderText.visible = false;




func _on_Bt_devoiler_cartes_pressed():
	if state != 1: return;
	#
	aff_page(false, false, true, false, false);
	$Reponse_mode_carte/VBoxContainer/RenderText.set_text(qsts[id_q][col_rep+1]);



func _on_Bt_eval0_pressed():
	pass # Replace with function body.


func _on_Bt_eval1_pressed():
	pass # Replace with function body.


func _on_Bt_eval2_pressed():
	pass # Replace with function body.


func _on_Bt_eval3_pressed():
	pass # Replace with function body.


func _on_Bt_eval4_pressed():
	pass # Replace with function body.




func _on_Bt_devoiler_ecrire_pressed():
	pass # Replace with function body.
