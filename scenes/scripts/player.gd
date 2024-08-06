extends CharacterBody2D

# Constante de velocidade do personagem
const SPEED: float = 300.0
# Constante de força de pulo do personagem
const JUMP_FORCE: float = -400.0

# Variável que controla animações do gnomo
@onready var animations_gnomo: AnimatedSprite2D = $AnimatedSprite2D
# Variável que controla sprite do gnomo
@onready var sprite_gnomo: Sprite2D = $Sprite2D

# Gravidade padrao do objeto 
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Adiciona a gravidade se o player nao estiver no chao
	if not is_on_floor():
		velocity.y += gravity * delta

	# Se o player estiver no chao e for pressionado a tecla espaco aplica a jump_force
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
	
	# Movimenta o player de acordo com a tecla de direcao pressionada
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		sprite_gnomo.visible = false
		animations_gnomo.visible = true
		velocity.x = direction * SPEED
		
		# Andando para direita
		if direction == 1:
			sprite_gnomo.flip_h = false
			animations_gnomo.flip_h = false
		
		# Andando para esquerda
		else:
			sprite_gnomo.flip_h = true
			animations_gnomo.flip_h = true
			
		animations_gnomo.play("walk")
	# Está parado
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animations_gnomo.play("idle_novo")
		
	move_and_slide()
