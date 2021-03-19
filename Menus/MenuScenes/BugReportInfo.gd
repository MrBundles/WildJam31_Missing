extends Node

# signals --------------------------------------


# variables --------------------------------------
var username = ""
var severity = 0
var description = ""

var form_url = "https://docs.google.com/forms/d/e/1FAIpQLSeIO7wkvO-CXKIixU40StsL7H4W57KzglqzIEOJLC0PwLj3pQ/formResponse"
var headers = ["Content-Type: application/x-www-form-urlencoded"]
var http = HTTPClient.new()


# main functions --------------------------------------
func _ready():
	GSM.connect("send_bug_report", self, "_on_send_bug_report")
	
	pass


func _process(delta):
	pass


# helper functions --------------------------------------


# set/get functions --------------------------------------


# signal functions --------------------------------------
func _on_send_bug_report():
	#populate additional info
	var version : float = GVM.version
	var date = OS.get_date()
	var time = OS.get_time()
	var level = GVM.game_scene
	
	var host_os_name = OS.get_name()
	var host_model_name = OS.get_model_name()
	
	var my_data = {
		"entry.588370581" : str(version),
		"entry.606529848_year" : date.year,
		"entry.606529848_month" : date.month,
		"entry.606529848_day" : date.day,
		"entry.1983335027_hour" : str(time.hour).pad_zeros(2),
		"entry.1983335027_minute" : str(time.minute).pad_zeros(2),
		"entry.955132142" : level,
		"entry.1889711528" : username,
		"entry.2013703327" : severity,
		"entry.657287764" : description.http_escape().replace("%A", " ").http_unescape(),
		"entry.958543560" : host_os_name,
		"entry.857849159" : host_model_name
		}
	var headers_pool = PoolStringArray(headers)
	var my_data_ready = http.query_string_from_dict(my_data)
	var result = $HTTPRequest.request(form_url, headers_pool, false, http.METHOD_POST, my_data_ready)
	
	#reset all user inputs
	$Username/LineEdit.text = ""
	$Severity/OptionButton.selected = 0
	$BugDescription/TextEdit.text = ""


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print("Result: " + str(result) + "    Respons Code: " + str(response_code) + "    Headers: " + str(headers) + "    Body: " + str(body))


func _on_Username_text_changed(new_text):
	username = new_text


func _on_Severity_item_selected(index):
	severity = index


func _on_Description_text_changed():
	description = $BugDescription/TextEdit.text
