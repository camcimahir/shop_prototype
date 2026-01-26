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
const weapon_data = {
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
