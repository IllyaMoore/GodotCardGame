extends Node2D

var cards = []
var speed = 8000
var dragging_card = null

var cards_position = {
	"card0": Vector2(-500, 500),
	"card1": Vector2(-250, 500),
	"card2": Vector2(0, 500),
	"card3": Vector2(250, 500),
	"card4": Vector2(500, 500),
}

func _ready():
	cards = [$card0, $card1, $card2, $card3, $card4]
	for card in cards:
		card.position = cards_position[card.name]

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging_card = get_card_under_mouse()
			print(dragging_card)
		else:
			dragging_card = null

func _physics_process(delta):
	if dragging_card == null:
		return_card(delta)

func return_card(delta):
	for card in cards:
		var target = cards_position[card.name]
		var direction = (target - card.global_position).normalized()
		var distance = card.global_position.distance_to(target)
		var max_speed = distance / delta
		var velocity = direction * min(speed, max_speed)
		card.global_position += velocity * delta

func _process(_delta):
	if dragging_card != null:
		dragging_card.global_position = get_global_mouse_position()

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
		var collider = hit.get("collider")
		if collider:
			var card = collider.get_parent()
			if card and card.name.begins_with("card"):
				return card
	return null
