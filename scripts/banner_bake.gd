# Poner "@tool" al inicio es crucial
# Esto hace que el script se ejecute en el editor.
@tool
extends Node

# 1. Arrastra tu nodo Viewport aquí desde el árbol de escena
@export var viewport_node: NodePath

# 2. Escribe la ruta donde quieres guardar la imagen
@export var save_path: String = "res://assets/images/banner.png"

var guardar_imagen_called: bool = false
# 3. Este 'bool' actuará como un botón
@export var guardar: bool = false:
	set(value):
		if value:
			guardar_imagen_called = true


func _ready() -> void:
	if guardar_imagen_called:
		guardar_imagen()

func guardar_imagen():
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame

	if not has_node(viewport_node):
		print("Error: No se encontró el nodo Viewport. Asegúrate de asignarlo en el inspector.")
		return

	var vp = get_node(viewport_node)

	# Obtén la textura que el Viewport ha renderizado
	var texture = vp.get_texture()
	if not texture:
		print("Error: El Viewport no tiene textura.")
		return

	# Convierte la textura en un objeto 'Image'
	var image = texture.get_image()
	if not image:
		print("Error: No se pudo obtener la imagen de la textura.")
		return

	# Guarda la imagen en la ruta especificada
	var error = image.save_png(save_path)
	
	if error == OK:
		print("¡Imagen guardada exitosamente en: ", save_path)
		# Importante: Actualiza el sistema de archivos para ver la imagen en Godot
		if Engine.is_editor_hint():
			var editor_fs = EditorInterface.get_resource_filesystem()
			editor_fs.scan()
	else:
		print("Error al guardar la imagen: ", error)
