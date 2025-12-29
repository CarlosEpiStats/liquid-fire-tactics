extends Node

var pools: Dictionary = {}

# Set up our pool inside the dictionary
func add_entry(key: String, prefab: PackedScene, prepopulate: int, max_count: int) -> bool:
	if pools.has(key):
		return false
	
	var data := PoolData.new()
	data.prefab = prefab
	data.max_count = max_count
	pools[key] = data
	for i in prepopulate:
		enqueue(create_instance(key, prefab))
	
	return true


# Add objects (back) to the pool
func enqueue(sender: Poolable):
	if sender == null or sender.is_pooled or not pools.has(sender.key):
		return
	
	var data: PoolData = pools[sender.key]
	if data.pool.size() >= data.max_count:
		sender.free()
		return
	
	data.pool.push_back(sender)
	if sender.get_parent():
		sender.get_parent().remove_child(sender)
	
	self.add_child(sender)
	sender.is_pooled = true
	sender.hide()


# Remove objects from the pool and add them to our scene
func dequeue(key: String) -> Poolable:
	if not pools.has(key):
		return null
	
	var data: PoolData = pools[key]
	if data.pool.size() == 0:
		return create_instance(key, data.prefab)
	
	var obj: Poolable = data.pool.pop_front()
	obj.is_pooled = false
	return obj


# Instantiate our objects before we add them to the pool
func create_instance(key: String, prefab: PackedScene) -> Poolable:
	var instance = prefab.instantiate()
	instance.set_script(Poolable)
	instance.key = key
	return instance


# Delete the specific pool if we are done with it
func clear_entry(key: String):
	if not pools.has(key):
		return
	
	var data: PoolData = pools[key]
	while data.pool.size() > 0:
		var obj: Poolable = data.pool.pop_front()
		obj.free()
	
	pools.erase(key)


# Allow us to modify the max entries any given pool can have
func set_max_count(key: String, max_count: int):
	if not pools.has(key):
		return
	
	pools[key].max_count = max_count
