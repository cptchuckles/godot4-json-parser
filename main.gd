extends PanelContainer


@onready var json_input := %JsonInput as TextEdit
@onready var convert_button := %ConvertButton as Button
@onready var clear_button := %ClearButton as Button
@onready var output_result := %OutputResult as RichTextLabel


func _ready() -> void:
	convert_button.pressed.connect(convert_json)
	clear_button.pressed.connect(json_input.clear)


func convert_json() -> void:
	var json = JSON.new()
	var err = json.parse(json_input.text)
	if err != OK:
		printerr("Failed to parse json: code %d" % err)
		output_result.text = "%d: %s" % [json.get_error_line(), json.get_error_message()]
		return

	var results: Array[String] = []

	if typeof(json.data) == TYPE_ARRAY:
		results.assign(json.data.map(func(e): return str(e)))
	elif typeof(json.data) == TYPE_DICTIONARY:
		results.assign(json.data.keys().map(func(key): return "“%s”: “%s”" % [key, str(json.data[key])]))
	else:
		printerr("Something went wrong (got object type %d)" % typeof(json.data))
		return

	output_result.text = "\n".join(results)
