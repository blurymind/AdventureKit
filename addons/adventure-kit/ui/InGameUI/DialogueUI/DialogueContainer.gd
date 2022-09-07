extends VBoxContainer

onready var dialog_label := $DialogLabel

func _ready() -> void:
	Rakugo.connect("say", self, "_on_say")
	Rakugo.connect("step", self, "_on_step")
	connect("visibility_changed" , self, "_on_visibility_changed")

func _on_say(character:Dictionary, text:String) -> void:
	dialog_label.markup_text = text
	show()

func _on_step():
	pass

func _on_visibility_changed() -> void:
	set_process(visible)

func _process(delta) -> void:
	var ui_accept := Input.is_action_just_pressed("ui_accept")
	if Rakugo.is_waiting_step() and ui_accept:
		Rakugo.do_step()

