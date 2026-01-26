extends Node
class_name shopViewModel

# the view can see these signals and use them accordingly
signal new_limb_selected(limb: String, weaopns: Array)
signal change_weapon_info(name: String, information: String, cost: int, is_owned: bool)
signal update_currency(new_amount: int)
signal visual_weapon_changed(limb: String, sprite_path: String) # For the paper doll

# the data from shopModel
var model: shopModel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	model = shopModel.new()  # I think this makes sure we got the updated data
	#updating the currency
	emit_signal("update_currency", model.currency)
	pass
	
# so from here on out I have user actions that view script will call

func select_limb(limb: String):
	model.limb_selected = limb
	
	# we are holding legal items for the limb
	var possibleWeapons = []

	for weapon_id in model.weapon_data:
		#collect data only for the i'th weapon
		var data = model.weapon_data[weapon_id]
		#check if data has correct limb
		if data.has("limb") and data["limb"] == limb: 
			possibleWeapons.append(weapon_id) # add it to the list
	
	# call on the view to change the weapon list 
	emit_signal("new_limb_selected", limb, possibleWeapons)
	
func display_weapon_info(weapon_id: String):
	# we will display this while hovering on the weapon
	if model.weapon_data.has(weapon_id):
		var data = model.weapon_data[weapon_id] #get weapon data
		var owned = model.items_in_inventory.has(weapon_id)
		
		emit_signal("change_weapon_info", weapon_id, data["detail"], data["cost"], owned)

func equip_purchase_weapon(weapon_id: String):
	if not model.weapon_data.has(weapon_id): return # we might want to return an error to console saying no such item
	
	var data = model.weapon_data[weapon_id]
	if model.items_in_inventory.has(weapon_id):
		emit_signal("visual_weapon_changed", data.limb, data.sprite)
		# change the data to equip
		model.weapon_equipped[data.limb] = weapon_id
		return
	
	if model.currency >= data.cost:
		model.currency-=data.cost
		model.items_in_inventory[weapon_id] = true
		# does it make a change to use model.limb_selected vs data.limb?
		model.weapon_equipped[data.limb] = weapon_id
		emit_signal("update_currency", model.currency)
		emit_signal("visual_weapon_changed", data.limb, data.sprite)
		return
	else:
		print("not enough money!!")
		return 
	
	
