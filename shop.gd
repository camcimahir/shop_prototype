extends Control

@onready var view_model = $viewModel
@onready var left_column = %List
@onready var middle_column = %character
@onready var weapon_info_box = %weaponInfo
@onready var currency_label = %currency

func _ready():
	# listen to signals from the viewmodel
	view_model.new_limb_selected.connect(on_new_limb_selected)
	view_model.change_weapon_info.connect(_on_change_weapon_info)
	view_model.update_currency.connect(_on_update_currency)
	view_model.visual_weapon_changed.connect(_on_visual_weapon_changed)
	
	# we can enable the commected line if we want hovering over limb to also select
	for button in middle_column.get_children():
		#button.focus_entered.connect(func(): view_model.select_limb(button.name))
		button.pressed.connect(func(): view_model.select_limb(button.name))
		
	_on_update_currency(view_model.model.currency)
	
	middle_column.get_node_or_null("head").grab_focus()
	# we initially select the head
	view_model.select_limb("head")

func on_new_limb_selected(_limb: String, weapons: Array):
	# empty the list of weapons shown
	for child in left_column.get_children():
		child.queue_free()
	
	# rewrite the list of weapons
	for weapon_id in weapons:
		var btn = Button.new()
		btn.text = weapon_id 
		left_column.add_child(btn)
		
		# show weapon info when hovering over
		btn.mouse_entered.connect(func(): view_model.display_weapon_info(weapon_id))
		btn.focus_entered.connect(func(): view_model.display_weapon_info(weapon_id))
		
		# click to purchase
		btn.pressed.connect(func(): view_model.equip_purchase_weapon(weapon_id))

func _on_change_weapon_info(weapon_name: String, information: String, cost: int, owned: bool):
	var status
	if owned:
		status = "OWNED"
	else:
		status = "COST: " + str(cost)
	
	weapon_info_box.text = "%s\n%s\n\n%s" % [weapon_name, information, status]

func _on_update_currency(currency: int):
	currency_label.text = "Money: " + str(currency)
	
func _on_visual_weapon_changed(limb: String, sprite_path: String):
	# this is the part we would use for when we add animations
	var limb_btn = middle_column.get_node_or_null("%" + limb)
	if limb_btn:
		limb_btn.texture_normal = load(sprite_path)

#			
# store what's equipped
# what limb is selected
# item's that are purchased
# try to figure out what my truths are
# add a currency 1 equals 1 weapon
# store currency as truth as well
# 
