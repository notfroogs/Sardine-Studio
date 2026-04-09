## A counter that displays words one at a time.
##
## The Countdown node is a label that displays, in order, any amount of 
## strings set in the [member counting_steps] property, and plays an animation for each. [br]
## Each string is shown for [member step_duration] seconds; once all the strings
## have appeared, the [signal counting_finished] signal is emitted.[br]
## Once the countdown finishes, the node hides on its own until [member start_counting]
## is called again.[br]
## [br]
## [b]Note[/b]: Any text written in the editor will be removed when [member start_counting]
## runs.
@tool
@icon("count_down.svg")
class_name CountDown
extends Label

## Emitted once the counter has shown all its steps
signal counting_finished

## The words that appear on screen at each step.
#ANCHOR:counting_steps
@export var counting_steps: Array[String]= ["3", "2", "1", "GO!"]
#END:counting_steps

## The duration of each step
@export_range(0.01, 2.0, 0.01, "or_greater", "suffix:seconds") var step_duration := 0.5
@export var autostart := false

var _tween : Tween


func _init() -> void:
	# set the vertical and horizontal alignments
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	# set the theme
	


func _ready() -> void:
	# if running in the editor, exit
	if Engine.is_editor_hint():
		return
	# If testing this scene, start counting
	if get_tree().current_scene == self or autostart:
		start_counting()


## Starts counting. If the label was hidden, it will show it.[br]
## Once the function finishes and all strings have been displayed, the label
## will auto-hide.
func start_counting():
	
	# make sure the counter is stopped
	stop_counting()
	
	# Ensure the countdown is visible
	show()
	
	_tween = create_tween()\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_BACK)
	
	# Cue all the tweens one after the other, one for each letter
	for current_text in counting_steps:
		# Pulse the label from half its scale to a full scale
		_tween.tween_property(self, "scale", Vector2.ONE, step_duration)\
			.from(Vector2.ONE * 0.5)
		
		# After the tween is over, set the text and move the pivot
		_tween.tween_callback(func():
			text = current_text
			# Every time the text changes, the label's size changes too. For
			# small, one letter texts, the effect isn't noticeable, but for longer
			# strings, the difference could be felt.
			# For proper scaling from the center, we ensure the pivot is in the 
			# middle. We recalculate this after each step
			pivot_offset = get_combined_minimum_size() / 2.0
		)
	
	# After all the counting steps are done, scale back the label to a smaller size
	# and wait a small fraction of a second before clearing everything
	_tween.tween_property(self, "scale", Vector2.ZERO, 0.2)\
		.set_ease(Tween.EASE_IN)\
		.set_delay(step_duration)
	# ... and emit a signal
	_tween.tween_callback(func():
		stop_counting()
		counting_finished.emit()
	)


## Stops the counter. You probably never need to call this, there is no reason
## to stop the counter before it finishes.
func stop_counting() -> void:
	# If there was a previous countdown before, kill it
	if _tween and _tween.is_valid(): 
		_tween.kill()
	# Ensure the countdown is empty in the beginning
	text = ""
	# Ensure the countdown is invisible
	visible = false
