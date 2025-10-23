extends CanvasLayer

signal create(type: String)
signal start()

@onready var button_container: HBoxContainer = $Control/ButtonContainer

func _ready() -> void:
	for button in button_container.get_children():
		button.connect("pressed", _on_button_pressed.bind(button))


func _on_button_pressed(button: Button) -> void:
	if "And" in button.name:
		create.emit("and")
	if "Or" in button.name:
		create.emit("or")
	if "Xor" in button.name:
		create.emit("xor")
	if "Nand" in button.name:
		create.emit("nand")
	if "Nor" in button.name:
		create.emit("nor")
	if "Xnor" in button.name:
		create.emit("xnor")
	if "Not" in button.name:
		create.emit("not")
		


func _on_start_button_pressed() -> void:
	start.emit()
