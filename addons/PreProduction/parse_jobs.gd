@tool
extends Button

var path = "res://Data/Jobs/"

func _on_pressed():
	var error = DirAccess.make_dir_recursive_absolute(path)
	if error != 0:
		print("Error creating directory. Error Code: " + str(error))
	
	parse_starting_stats(get_data("res://Settings/job_starting_stats.csv"))
	parse_growth_stats(get_data("res://Settings/job_growth_stats.csv"))
		

func get_data(path: String):
	var main_data = {}
	var file = FileAccess.open(path, FileAccess.READ)
	while not file.eof_reached():
		var data_set = Array(file.get_csv_line())
		main_data[main_data.size()] = data_set
	
	file.close()
	return main_data

func parse_starting_stats(data):
	for item in data.keys():
		if item == 0:
			continue
		
		var elements: Array = data[item]
		var scene: PackedScene = get_or_create(elements[0])
		var job = scene.instantiate()
		
		for i in job.STAT_ORDER.size():
			job.base_stats[i] = int(elements[i + 1])
		
		var evade: StatModifierFeature = get_feature(job, StatTypes.Stat.EVD)
		evade.amount = int(elements[8])
		evade.name = "SMF_EVD"
		
		var res: StatModifierFeature = get_feature(job, StatTypes.Stat.RES)
		res.amount = int(elements[9])
		res.name = "SMF_RES"
		
		var move: StatModifierFeature = get_feature(job, StatTypes.Stat.MOV)
		move.amount = int(elements[10])
		move.name = "SMF_MOV"
		
		var jump: StatModifierFeature = get_feature(job, StatTypes.Stat.JMP)
		jump.amount = int(elements[11])
		jump.name = "SMF_JMP"
		
		scene.pack(job)
		ResourceSaver.save(scene, path + elements[0] + ".tscn")
	
	
func parse_growth_stats(data):
	for item in data.keys():
		if item == 0:
			continue
		
		var elements: Array = data[item]
		var scene: PackedScene = get_or_create(elements[0])
		var job = scene.instantiate()
		
		for i in job.STAT_ORDER.size():
			job.grow_stats[i] = float(elements[i + 1])
		
		scene.pack(job)
		ResourceSaver.save(scene, path + elements[0] + ".tscn")


func get_or_create(job_name: String):
	var full_path: String = path + job_name + ".tscn"
	if ResourceLoader.exists(full_path):
		return load(full_path)
	
	else:
		return create(full_path)


func create(full_path: String):
	var job := Job.new()
	job.name = "Job"
	var scene := PackedScene.new()
	scene.pack(job)
	ResourceSaver.save(scene, full_path)
	return scene


func get_feature(job: Job, type: StatTypes.Stat):
	var node_array: Array[Node] = job.get_children()
	var filtered_array = node_array.filter(func(node): return node is Feature)
	for smf in filtered_array:
		if smf.type == type:
			return smf
	
	var feature := StatModifierFeature.new()
	feature.type = type
	job.add_child(feature)
	feature.set_owner(job)
	return feature
