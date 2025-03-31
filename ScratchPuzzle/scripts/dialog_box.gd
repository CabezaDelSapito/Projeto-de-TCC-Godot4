extends MarginContainer

@onready var text_label: Label = $label_margin/text_label
@onready var letter_timer_display: Timer = $letter_timer_display

const  MAX_WIDTH = 256

var text = ""
var letter_index = 0

var letter_display_timer = 0.07
var space_display_timer = 0.05
var punctuaction_display_timer = 0.02

signal text_display_finished()

func display_text(text_to_display: String):
	text = text_to_display
	text_label.text = text_to_display
	
	await resized
	
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		text_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized # para x
		await resized # para y
		custom_minimum_size.y = size.y
		
	global_position.x -= size.x / 2
	global_position.y -= size.y + 24
	text_label.text = ""
	display_letter()
	
func display_letter():
	# Se alcançou o fim do texto, emite o sinal e retorna
	if letter_index >= text.length():
		text_display_finished.emit()
		return
	
	# Exibe o caractere atual
	text_label.text += text[letter_index]
	letter_index += 1
	
	# Verifica se existe um próximo caractere
	if letter_index < text.length():
		match text[letter_index]:
			"!", "?", ",", ".":
				letter_timer_display.start(punctuaction_display_timer)
			" ":
				letter_timer_display.start(space_display_timer)
			_:
				letter_timer_display.start(letter_display_timer)
	else:
		text_display_finished.emit()


func _on_letter_timer_display_timeout():
	display_letter()
	
	
