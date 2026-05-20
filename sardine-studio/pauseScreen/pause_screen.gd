extends Control

@onready var resume_button: Button = %ResumeButton
@onready var quit_button: Button = %QuitButton
@onready var help_button: Button = %HelpButton

func get_resume_button():
	return resume_button

func get_quit_button():
	return quit_button

func get_help_button():
	return help_button
