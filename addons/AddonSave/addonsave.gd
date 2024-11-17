extends Node

var data_in_folder = true      # true changes "user://" to "res://"
var folder_name = "PackageDelivery"  # Changed to "PackageDelivery" to reflect the folder name
var print_in_terminal = true    # if it changes to false, this script will not print

var screenshot_in_folder = true            # true changes "user://" to "res://"
var screenshot_folder_name = "screenshots"  # Folder name
var screenshot_print_in_terminal = true     # if it changes to false, this script will not print screenshot logs

var res_user = "user://"
var S_res_user = "user://"

var thread: Thread
var mutex
var queue = []
const MAX_QUEUE_LENGTH = 4

func _ready():
	# Set up resource paths based on data_in_folder flag
	if data_in_folder:
		res_user = "res://"
	
	# Setup for screenshot saving
	if screenshot_in_folder:
		S_res_user = "res://"
	
	# Initialize thread and mutex for screenshot saving
	thread = Thread.new()
	mutex = Mutex.new()

# Helper function to get the Documents folder path based on the operating system
func get_documents_path() -> String:
	var path = ""
	# Check the OS and get the path to the Documents folder
	if OS.get_name() == "Windows":
		path = OS.get_environment("USERPROFILE") + "/Documents/PackageDelivery/"
	elif OS.get_name() == "X11":  # Linux / Unix
		path = OS.get_environment("HOME") + "/Documents/PackageDelivery/"
	elif OS.get_name() == "MacOS":
		path = OS.get_environment("HOME") + "/Documents/PackageDelivery/"
	return path

# Folder creation function
func create_folder(resuser: String, folder: String):
	var path = DirAccess
	var documents_path = get_documents_path()  # Get the Documents path for PackageDelivery
	if !path.dir_exists_absolute(documents_path):
		path.open(documents_path)
		path.make_dir_absolute(documents_path)
		if print_in_terminal:
			print("Creating folder: " + documents_path)

# Save data to Documents/PackageDelivery folder
func save_data(data: Dictionary, profile: String = "save", typefile: String = ".sav"):
	var documents_path = get_documents_path()  # Get the Documents/PackageDelivery path
	create_folder(documents_path, folder_name)
	var thefile = FileAccess.open(documents_path + profile + typefile, FileAccess.WRITE)
	thefile.store_line(JSON.stringify(data))
	thefile.close()
	if print_in_terminal:
		print("Saved to Documents/PackageDelivery: " + str(data))

# Edit data from file in Documents/PackageDelivery folder
func edit_data(profile: String = "save", typefile: String = ".sav"):
	var documents_path = get_documents_path()  # Get the Documents/PackageDelivery path
	create_folder(documents_path, folder_name)
	var data = {}
	var path = str(documents_path + profile + typefile)
	if FileAccess.file_exists(path):
		var thefile = FileAccess.open(path, FileAccess.READ)
		if not thefile.eof_reached():
			var almost_data = JSON.parse_string(thefile.get_line())
			if almost_data != null:
				data = almost_data
	return data
