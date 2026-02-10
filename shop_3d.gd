extends Node3D

@onready var view_model: shopViewModel = $CanvasLayer/Shop/viewModel
@onready var left_column = $CanvasLayer/Shop/HBoxContainer/List 
@onready var weapon_info_box = $CanvasLayer/Shop/weaponInfo
@onready var currency_label = $CanvasLayer/Shop/currency

# references to the 3d body parts
@onready var head_mesh: MeshInstance3D = $character/Head
@onready var arms_mesh: MeshInstance3D = $character/Arms
@onready var torso_mesh: MeshInstance3D = $character/Torso
@onready var legs_mesh: MeshInstance3D = $character/Legs

# dual focus
var current_limb_index := 0
var current_weapon_index := 0

# order of the limb movement
const LIMB_ORDER = ["head", "arms", "torso", "legs"]

# This is for the coloring it will be changed once we have all the art
var highlight_material = StandardMaterial3D.new()

func _ready():

	#initalize the color for highlighting
	highlight_material.albedo_color = Color(1, 1, 0)
	highlight_material.emission_enabled = true
	highlight_material.emission = Color(0.5, 0.5, 0)

	#connect the signals
	view_model.new_limb_selected.connect(on_new_limb_selected)
	view_model.change_weapon_info.connect(_on_change_weapon_info)
	view_model.update_currency.connect(_on_update_currency)
	view_model.visual_weapon_changed.connect(_on_visual_weapon_changed)
	
	_on_update_currency(view_model.model.currency)
	view_model.select_limb("head") 
	
	
	var externalScene = load("res://test_scene.tscn").instantiate()
	var externalCamera = externalScene.get_node_or_null("Camera3D")
	if externalCamera:
		display_scene_on_screen(externalScene, externalCamera, screen1)


func _input(event):
	# up and down logic
	if event.is_action_pressed("ui_down") or event.is_action_pressed("ui_up"):
		var dir := 1 if event.is_action_pressed("ui_down") else -1

		current_limb_index = (current_limb_index + dir) % LIMB_ORDER.size()
		view_model.select_limb(LIMB_ORDER[current_limb_index])

	# left and right logic
	elif event.is_action_pressed("ui_right") or event.is_action_pressed("ui_left"):
		if left_column.get_child_count() == 0:
			return
		
		var dir = 1 if event.is_action_pressed("ui_right") else -1
		current_weapon_index = (current_weapon_index + dir) % left_column.get_child_count()
		_hover_weapon()

	# 
	elif event.is_action_pressed("ui_accept"):
		if left_column.get_child_count() == 0:
			return
			
		var btn := left_column.get_child(current_weapon_index)
		_on_weapon_button_pressed(btn.text)


func on_new_limb_selected(limb: String, weapons: Array):

	_update_3d_highlight(limb)

	for child in left_column.get_children():
		left_column.remove_child(child)
		child.queue_free()

	for weapon_id in weapons:
		var btn = Button.new()
		btn.focus_mode = Control.FOCUS_NONE
		btn.text = weapon_id 
		left_column.add_child(btn)
		
		# this shows weapoon info 
		btn.mouse_entered.connect(func(): view_model.display_weapon_info(weapon_id))
		btn.focus_entered.connect(func(): view_model.display_weapon_info(weapon_id))
		
	
		btn.pressed.connect(func(): _on_weapon_button_pressed(weapon_id))
		
	current_weapon_index = 0
	call_deferred("_hover_weapon")



# if we need to use two differnt buttons to purchase vs equip that weould be easy to immplement
func _on_weapon_button_pressed(weapon: String):
	
	if view_model.model.items_in_inventory.has(weapon):
		view_model.equip_weapon(weapon)
	else:
		
		if view_model.purchase_weapon(weapon):
			view_model.equip_weapon(weapon)

#same logic as the 2d version
func _on_change_weapon_info(weapon: String, information: String, cost: int, owned: bool):

	var status = "OWNED" if owned else "COST: " + str(cost)
	weapon_info_box.text = "%s\n%s\n\n%s" % [weapon, information, status]

func _on_update_currency(currency: int):
	currency_label.text = "Money: " + str(currency)

func _on_visual_weapon_changed(limb_type_enum: int, sprite_path: String):
	
	var target_mesh: MeshInstance3D
	# this refers to the limb enum created in shopModel.gd
	match limb_type_enum:
		0: target_mesh = head_mesh
		1: target_mesh = arms_mesh
		2: target_mesh = torso_mesh 
		3: target_mesh = legs_mesh 
	
	# for now we are applying a kind of random color to it. This will need to change
	if target_mesh:

		var new_mat = StandardMaterial3D.new()
		new_mat.albedo_color = Color.from_hsv((sprite_path.hash() % 100) / 100.0, 0.8, 0.8)
		target_mesh.material_override = new_mat


# this is highlight logic it will probably be removed once we have the art
func _update_3d_highlight(limb_name: String):

	head_mesh.material_overlay = null
	arms_mesh.material_overlay = null
	torso_mesh.material_overlay = null
	legs_mesh.material_overlay = null
	
	match limb_name:
		"head": head_mesh.material_overlay = highlight_material
		"arms": arms_mesh.material_overlay = highlight_material
		"torso": torso_mesh.material_overlay = highlight_material
		"legs": legs_mesh.material_overlay = highlight_material


func _hover_weapon():
	_weapon_selected()
	_render_weapon_highlight()
		
func _update_weapon_visual_hover():
	for i in left_column.get_child_count():
		var b := left_column.get_child(i)
		b.modulate = Color.WHITE
	
	if current_weapon_index < left_column.get_child_count():
		left_column.get_child(current_weapon_index).modulate = Color(1, 1, 0)
		
func _force_top_weapon_hover():
	if left_column.get_child_count() == 0:
		return

	current_weapon_index = 0
	_hover_weapon()

# calls on display weapon info
func _weapon_selected():
	if left_column.get_child_count() == 0:
		print ("no childs")
		return
	
	# := is type inferred assingment
	var btn := left_column.get_child(current_weapon_index) as Button
	if btn:
		view_model.display_weapon_info(btn.text)
		

func _render_weapon_highlight():
	#make all the weapons white
	for i in left_column.get_child_count():
		left_column.get_child(i).modulate = Color.WHITE

	# apply color to the right one
	if current_weapon_index < left_column.get_child_count():
		left_column.get_child(current_weapon_index).modulate = Color(1, 1, 0)


@onready var screenFeed: SubViewport = %screenFeed
@onready var screen1: MeshInstance3D = %screen1

# this is dictionary that keeps track of the viewports For example: (screen1: screenFeed)
var screen_viewports = {}

func display_scene_on_screen(scene: Node, camera: Camera3D, screen: MeshInstance3D):
	if not scene or not camera or not screen:
		return

	# check to see if there are any other screens displayed here
	# if so remove them
	if screen_viewports.has(screen):
		var oldViewPort = screen_viewports[screen]
		if is_instance_valid(oldViewPort):
			oldViewPort.queue_free()
		screen_viewports.erase(screen)


	var viewport = SubViewport.new()
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS # this is what makes it live
	
	# we create the viewport in a way with this line
	viewport.own_world_3d = true
	
	# we add that viewport to our scene
	add_child(viewport)
	# we store it in our dictionary which will help when we are dealing with multiple screens
	screen_viewports[screen] = viewport

	# this is part that is a bit scary we detach the scene from its original parent
	# we have to do this because there can only be a single parent for a node
	# if this seems to be causing an error we can reattach it to the its parent node after we leave the shop
	var old_parent = scene.get_parent()
	if old_parent:
		old_parent.remove_child(scene)
		
	viewport.add_child(scene)
	
	camera.current = true
	
	var mat = StandardMaterial3D.new()
	var tex = viewport.get_texture()
	mat.albedo_texture = tex
	mat.emission_enabled = true
	mat.emission_texture = tex
	screen.material_override = mat
