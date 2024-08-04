extends CharacterBody2D


const SPEED = 300.0
const JUMP_FORCE = -400.0

# Gravidade padrao do objeto 
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Adiciona a gravidade se o player nao estiver no chao
	if not is_on_floor():
		velocity.y += gravity * delta

	# se o player estiver no chao e for pressionado a tecla espaco aplica a jump_force
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE

	# movimenta o player de acordo com a tecla de direcao pressionada
	
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
