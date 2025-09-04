extends Area2D

class_name Table

@onready var rectangle_shape_2d = $CollisionShape2D.get_shape()

# Stats
var table_id : int
var customer: Customer
var host: GameplayHost
var order_time : int
var active_effects : Dictionary
var image : Image = load("res://game/assets/textures/gameplay_map_textures/floor_textures/test_floor_texture.png")
# Physics
var is_open : bool = true
var is_droppable : bool = false
var is_selectable : bool = true

#Signal
signal player_assigned_customer
signal customer_assigned
signal table_customer_reputation_calculate
signal send_spending

func initalise(id: int, host_data: GameplayHost) -> void:
	table_id = id
	host = host_data
	add_child(host)


func set_texture() -> void:
	var collision_shape_dimensions = rectangle_shape_2d.get_rect().size
	image.resize(collision_shape_dimensions.x, collision_shape_dimensions.y)
	var texture : ImageTexture = ImageTexture.create_from_image(image)
	$TextureRect.set_texture(texture)


func assign_customer(customer_data : Customer) -> void:
	customer = customer_data
	add_child(customer)
	close_table()
	host_and_customer_interaction()


func host_and_customer_interaction() -> void:
	order_time = customer.get_stats().get("order_duration")

	customer.initial_impressions(host.get_appearance())
	for i in order_time:
		$SpendingFrequencyTimer.start(customer.get_stats().get("spending_frequency"))
		$OrderTimer.start(1)
		print(customer)
		await $OrderTimer.timeout

	table_customer_reputation_calculate.emit(customer.get_calculated_reputation(), customer.get_type())
	open_table()
	print("Table Opened!")


func host_and_customer_progress() -> void:
	order_time = customer.get_stats()["order_duration"]
	host.update_status(customer.get_current_demand())
	customer.current_impressions(host.get_performance())
	print("Current Interaction Happened!")


func unhighlight() -> void:
	$Sprite2D.modulate = Color(0, 0, 0)


func open_table() -> void:
	is_selectable = true
	is_open = true


func close_table() -> void:
	is_selectable = false
	is_open = false


func get_table_id() -> int:
	return table_id


func get_customer() -> Customer:
	return customer


func get_host() -> GameplayHost:
	return host


func get_body_data(customer_id: int) -> void:
	player_assigned_customer.emit(table_id, customer_id)


func _on_order_timer_timeout() -> void:
	host_and_customer_progress()


func _on_spending_frequency_timer_timeout() -> void:
	var spending : int = customer.calculate_spending()
	send_spending.emit(spending, host.get_name())
	print("MONEYYYY")


func _on_body_entered(body: Customer) -> void:
	if is_open:
		body.current_drop_zone = self


func _on_body_exited(body: Customer) -> void:
	if body.current_drop_zone == self:
		body.current_drop_zone = null


func apply_special_on_host(special_name : String, effect_data : Dictionary, value : float, time: float, max_value : bool) -> void:
	host.set_stat(effect_data["big_stat"], effect_data["sub_stat"], value, time, max_value, false)
	print("Successfully Applying: ", special_name)
	if time == 0:
		print("Permanent Effect: ", special_name)
	else:
		print("Added Timer for Effect: ", special_name)
		var timer = Timer.new()
		add_child(timer)
		timer.start(time)
		await timer.timeout
		host.set_stat(effect_data["big_stat"], effect_data["sub_stat"], value, time, max_value, true)
		print("Effect Timeout: ", special_name)
	
	
func apply_special_on_customer(special_name : String, effect_data : Dictionary, value : float, time: float, max_value : bool) -> void:
	if not customer:
		print("Failed to apply ", special_name, " due to no customer at the table.")
		return
	customer.set_stat(effect_data["stat"], value, max_value, false)
	print("Applied: ", special_name)
	if time == 0:
		print("Permanent Customer Effect: ", special_name)
	else:
		print("Added Timer for Customer Effect: ", special_name)
		var timer = Timer.new()
		add_child(timer)
		timer.start(time)
		await timer.timeout
		customer.set_stat(effect_data["stat"], value, max_value, true)
		print("Effect Timeout: ", special_name)
		
		
