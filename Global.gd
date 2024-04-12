extends Node

var camera = null

var score = 0
var best_score = 0

func instance_node (node, location, parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance

func update_score(var delta):
	score += delta


func load_score():
	var save_file = File.new()
	if !save_file.file_exists("user://savegame2.save"):
		return
	save_file.open_encrypted_with_pass("user://savegame2.save", File.READ, "afsdfasdgawrhawo")
	
	var data = save_file.get_var()
	score = data["score"]
	best_score = data["best_score"]
	save_file.close()

func save_score():
	var save_file = File.new()
	save_file.open_encrypted_with_pass("user://savegame2.save", File.WRITE, "afsdfasdgawrhawo")
	
	if score > best_score:
		best_score = score
	
	var data = {
		"score" : score,
		"best_score" : best_score
	}
	save_file.store_var(data)
	save_file.close()
