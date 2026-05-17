extends Node

enum Level { DEBUG, INFO, WARN, ERROR }

var current_level = Level.DEBUG

func debug(msg: String) -> void:
	if current_level <= Level.DEBUG:
		print("[DEBUG] ", msg)

func info(msg: String) -> void:
	if current_level <= Level.INFO:
		print("[INFO] ", msg)

func warn(msg: String) -> void:
	if current_level <= Level.WARN:
		push_warning("[WARN] " + msg)

func error(msg: String) -> void:
	if current_level <= Level.ERROR:
		push_error("[ERROR] " + msg)
