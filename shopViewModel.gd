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
	emit_signal("update_currency", model.currency) # we might want to use call_deferred before we update currency
	pass
	
# so from here on out I have user actions that view script will call


func _get_weapon_from_array(id: String) -> shopModel.weapon:
	for weapon in model.weapon_data:
		if weapon.id == id:
			return weapon
	return null
	
func _limb_string_matches_enum(limb: String, limbType: shopModel.limbType) -> bool:
	match limb:
		"head": return limbType == shopModel.limbType.HEAD
		"arms": return limbType == shopModel.limbType.ARMS
		"torso": return limbType == shopModel.limbType.TORSO
		"legs": return limbType == shopModel.limbType.LEGS
	return false

func select_limb(limb: String):
	model.limb_selected = limb
	
	# we are holding legal items for the limb
	var possibleWeapons = []

	for weapon in model.weapon_data:
		if _limb_string_matches_enum(limb, weapon.limb_type):
			possibleWeapons.append(weapon.id)
	
	# call on the view to change the weapon list 
	#emit_signal("new_limb_selected", limb, possibleWeapons)
	new_limb_selected.emit(limb, possibleWeapons)
	
func display_weapon_info(weapon_id: String):
	# we will display this while hovering on the weapon
	var data = _get_weapon_from_array(weapon_id) 
	if data != null:
		var owned = model.items_in_inventory.has(weapon_id)
		
		emit_signal("change_weapon_info", weapon_id, data["detail"], data["cost"], owned)
		

func equip_weapon(weapon_id: String) -> bool:
	if model.items_in_inventory.has(weapon_id):
		var weapon = (_get_weapon_from_array(weapon_id))
		emit_signal("visual_weapon_changed", weapon.limb_type, weapon.spritePath)
		# change the data to equip
		model.weapon_equipped[weapon.limb_type] = weapon_id
		#shopModel.[data.limb_type] = weapon_id	
		return true
	else: return false

func purchase_weapon(weapon_id: String) -> bool:
	var data = _get_weapon_from_array(weapon_id)
	if data == null: return	false
	if model.items_in_inventory.has(weapon_id): return false
	
	if model.currency >= data.cost:
		model.currency-=data.cost
		model.items_in_inventory[weapon_id] = true
		# does it make a change to use model.limb_selected vs data.limb?
		model.weapon_equipped[data.limb_type] = weapon_id
		emit_signal("update_currency", model.currency)
		emit_signal("visual_weapon_changed", data.limb_type, data.spritePath)
		return true
	else:
		print("not enough money!!")
		return false
	
	
'''
func equip_purchase_weapon(weapon_id: String):
	var data = _get_weapon_from_array(weapon_id)
	if data == null: return # we might want to return an error to console saying no such item
	
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
'''
	
