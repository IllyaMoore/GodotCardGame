extends Node2D

#card deck
var cards = []

var cards_position = {
	0: Vector2(-500, 500),
	1: Vector2(-250, 500),
	2: Vector2(0, 500),
	3: Vector2(250, 500),
	4: Vector2(500, 500),
}

var dragging_card = null

# cards start up position
func _ready():
	cards = [$card0, $card1, $card2, $card3, $card4]
	
	for i in range(cards.size()):
		cards[i].position = cards_position[i]
		

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging_card = get_card_under_mouse()
			print(dragging_card)
		else:
			dragging_card = null

func _on_Button_mouse_entered():
	print("Миша зайшла на ноду:", self.name)
	

# card moovement
func _process(_delta):
	
	if dragging_card != null:
		get_card_under_mouse().position = get_global_mouse_position()

	
func get_card_under_mouse():
	var mouse_pos = get_global_mouse_position()
	var space_state = get_world_2d().direct_space_state

	var params = PhysicsPointQueryParameters2D.new()
	params.position = mouse_pos
	params.collide_with_areas = true
	params.collide_with_bodies = true
	params.collision_mask = 0xFFFFFFFF

	var result = space_state.intersect_point(params)

	for hit in result:
		var collider = hit["collider"]
		var card = collider.get_parent()
		if card.name.begins_with("card"):
			return card
	return null
