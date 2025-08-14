extends CanvasLayer

func update_state_debug(current_state_name: String) -> void:
	for checkbox in get_tree().get_nodes_in_group("state_checkboxes"):
		checkbox.button_pressed = (checkbox.name == current_state_name)
