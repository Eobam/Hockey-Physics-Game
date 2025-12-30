extends Node2D


var api_key: String = "sk-hc-v1-30f1d55ebb0c44158bb67f50134fee65bb52a60169c248c4a004dfac70ac64d3"


var url: String = "https://ai.hackclub.com/proxy/v1/chat/completions"


var temperature: float = 0.5


var max_tokens: int = 1024


var headers := PackedStringArray([
	"Content-Type: application/json",
	"Authorization: Bearer " + api_key,
	"User-Agent: Godot"
])


var model: String = "openai/gpt-5-mini"


var messages: Array = []


var request: HTTPRequest



func _ready() -> void:
	request = HTTPRequest.new()

	add_child(request)

	request.request_completed.connect(_on_request_completed)

	dialogue_request("Tell me a joke")



func dialogue_request(player_dialogue: String) -> void:
	messages.append({
		"role": "user",
		"content": player_dialogue
	})

	var body := JSON.stringify({
		"model": model,
		"messages": messages,
		"temperature": temperature,
		"max_tokens": max_tokens
	})

	request.request(
		url,
		headers,
		HTTPClient.METHOD_POST,
		body
	)



func _on_request_completed(result, response_code, response_headers, body) -> void:
	print("REQUEST COMPLETE — STATUS:", response_code)

	var raw: String = body.get_string_from_utf8()
	print("RAW RESPONSE:")
	print(raw)

	var json := JSON.new()
	var parse_error := json.parse(raw)

	if parse_error != OK:
		print("JSON parse failed")
		return

	var data = json.data

	if not data.has("choices"):
		print("No choices field")
		return

	if data["choices"].size() == 0:
		print("Empty choices array")
		return

	var choice = data["choices"][0]

	if not choice.has("message"):
		print("No message field")
		return

	if not choice["message"].has("content"):
		print("No content field")
		return

	print("AI RESPONSE:")
	print(choice["message"]["content"])
