extends Resource
class_name shopModel

# Currency
@export var currency: int = 10

# currently selected limb
@export var limb_selected: String = "head"

# shows true on items that have been purchased
@export var items_in_inventory: Dictionary = {}

enum limbType { HEAD, ARMS, TORSO, LEGS }

class weapon extends Resource:
	var id: String
	var limb_type: limbType
	var cost: int
	var detail: String
	var spritePath: String
	
	func _init(_id: String, _limb: limbType, _cost: int, _detail: String, _sprite: String):
		id = _id
		limb_type = _limb
		cost = _cost
		detail = _detail
		spritePath = _sprite

@export var weapon_equipped: Dictionary = {
	limbType.HEAD: "head_id",
	limbType.ARMS: "arm_id",
	limbType.TORSO: "torso_id",
	limbType.LEGS: "legs_id"

}

var weapon_data: Array[weapon]


func _init():
	#var weapon1 = weapon.new("headItem", limbType.HEAD, 1, "description for weapon", "res://headR.png")
# Head
	weapon_data.append(weapon.new("headItem", limbType.HEAD, 1, "information about head item. Loreeeee", "res://headR.png"))
	weapon_data.append(weapon.new("head_id", limbType.HEAD, 1, "Information", "res://head1.png"))

	# Arms
	weapon_data.append(weapon.new("gauntlet", limbType.ARMS, 1, "information and lore about gauntlet", "res://armsR.png"))
	weapon_data.append(weapon.new("arm_id", limbType.ARMS, 1, "Information", "res://arms1.png"))

	# Torso
	weapon_data.append(weapon.new("arc reactor", limbType.TORSO, 1, "information", "res://torsoR.png"))
	weapon_data.append(weapon.new("torso_id", limbType.TORSO, 1, "Information", "res://torso1.png"))

	# Legs
	weapon_data.append(weapon.new("sneakers", limbType.LEGS, 1, "information", "res://legsR.png"))
	weapon_data.append(weapon.new("legs_id", limbType.LEGS, 1, "Information", "res://legs1.png"))

# not sure if this part would work, but if it does it would be nice for readibility
#var weapon_detail: Dictionary = {
	#"headItem": "description for the head item."
#}



'''
extends Resource
class_name shopModel

# Currency
@export var currency: int = 10

# currently selected limb
@export var limb_selected: String = "head"

# shows true on items that have been purchased
@export var items_in_inventory: Dictionary = {}

# currently equipped weapons
@export var weapon_equipped: Dictionary = {
	"head": "head_id", #each weapon needs to have an id that the dictionary will show selected
	"arms": "arm_id", # for example you put "gauntlet"
	"torso": "torso_id",
	"legs": "legs_id"
}

#------ Weapon Data And Information ----------------
# I am not sure if we are gonna be using sprites here exactly
# and I am not exaclty sure how the animations would fit here
# I can also add extra info for "owned" that might make things eaiser
@export var weapon_data = {
	"headItem": {
		"limb": "head",
		"cost": 1,
		"detail": "information about head item. Loreeeee",
		"sprite": "res://headR.png" 
	}, 
	"gauntlet": {
		"limb": "arms",
		"cost": 1, 
		"detail": "information and lore about gauntlet",
		"sprite": "res://armsR.png"
	},
	"arc reactor": {
		"limb": "torso",
		"cost": 1, 
		"detail": "information", 
		"sprite": "res://torsoR.png"
	},
	"sneakers": {
		"limb": "legs",
		"cost": 1, 
		"detail": "information", 
		"sprite": "res://legsR.png"
	},
	"head_id": {
		"limb": "head",
		"cost": 1, 
		"detail": "Information", 
		"sprite": "res://head1.png"
	},
	"arm_id": {
		"limb": "arms",
		"cost": 1, 
		"detail": "Information", 
		"sprite": "res://arms1.png"
	},
	"torso_id": {
		"limb": "torso",
		"cost": 1, 
		"detail": "Information", 
		"sprite": "res://torso1.png"
	},
	"legs_id": {
		"limb": "legs",
		"cost": 1, 
		"detail": "Information", 
		"sprite": "res://legs1.png"
	},
}

'''
