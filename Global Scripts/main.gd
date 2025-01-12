extends Node


@export var player : PackedScene
@export var map : PackedScene


func _ready() -> void:
	var upnp = UPNP.new()
	upnp.discover()
	upnp.add_port_mapping(9999)
	%PublicIP.text = upnp.query_external_address()


func _on_host_button_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(9999)
	multiplayer.multiplayer_peer = peer

	multiplayer.peer_disconnected.connect(remove_player)

	%Server.show()

	load_game()


func _on_join_button_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(%To.text, 9999)
	multiplayer.multiplayer_peer = peer

	multiplayer.connected_to_server.connect(load_game)
	multiplayer.server_disconnected.connect(connection_lost)


func _on_to_text_submitted(new_text: String) -> void:
	_on_join_button_pressed() 


func load_game():
	%Menu.hide()
	%MapInstance.add_child(map.instantiate())
	add_player.rpc(multiplayer.get_unique_id())


func connection_lost():
	%Menu.show()

	if %MapInstance.get_child(0):
		%MapInstance.get_child(0).queue_free()


@rpc("any_peer")
func add_player(id: int) -> void:
	# Check if the player with this ID already exists
	if %SpawnArea.has_node(str(id)):
		return
	
	var player_instance = player.instantiate()
	player_instance.name = str(id)  # Use the ID as the node name
	player_instance.set_player_id(id)  # Assign the ID to the player script
	%SpawnArea.add_child(player_instance)
	Global.players.append(player_instance)



@rpc("any_peer")
func remove_player(id: int) -> void:
	var player_node = %SpawnArea.get_node_or_null(str(id))
	if player_node:
		Global.players.erase(player_node)
		player_node.queue_free()
	


		
