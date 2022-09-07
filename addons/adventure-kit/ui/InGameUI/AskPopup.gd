extends Popup

onready var dialog_label := $VBoxContainer/AdvancedTextLabel
onready var answer_edit := $VBoxContainer/LineEdit
onready var accept_button := $VBoxContainer/AcceptButton

func _ready() -> void:
	Rakugo.connect("ask", self, "_on_ask")
	Rakugo.connect("step", self, "_on_step")
	answer_edit.connect("text_entered", self, "_on_answer_entered")
	connect("visibility_changed" , self, "_on_visibility_changed")
	accept_button.connect("pressed", self, "_on_accept_pressed")

func _on_step():
	pass

func _on_ask(character:Dictionary, question:String, default_answer:String) -> void:
	dialog_label.markup_text = question
	answer_edit.show()
	answer_edit.grab_focus()
	answer_edit.placeholder_text = default_answer

func _on_ask_entered(answer:String) -> void:
	answer_edit.hide()
	answer_edit.placeholder_text = ""
	answer_edit.text = ""
	Rakugo.ask_return(answer)

func _on_accept_pressed():
	_on_ask_entered(answer_edit.text)

func _process(delta) -> void:
	var ui_accept := Input.is_action_just_pressed("ui_accept")
	if Rakugo.is_waiting_step() and ui_accept:
		Rakugo.do_step()