extends CharacterBody2D

# Enumerar estados do personagem
enum State {
	IDLE,          # Parado
	WALKING_LEFT,  # Andando para esquerda
	WALKING_RIGHT, # Andando para direita
	JUMPING,       # Pulando
	FALLING        # Caindo
}

# Constante de velocidade do personagem
const SPEED: float = 300.0
# Constante de força de pulo do personagem
const JUMP_FORCE: float = -350.0

var vidas: int = 3
var knockback_vector: Vector2 = Vector2.ZERO

# Controla animações do gnomo
@onready var animations_gnomo: AnimatedSprite2D = $AnimatedSprite2D
# Controla sprite do gnomo
@onready var sprite_gnomo: Sprite2D = $Sprite2D
# Controla sons do gnomo
@onready var sons: AudioStreamPlayer = $AudioStreamPlayer

# Gravidade padrao do objeto 
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
# Estado inicial do personagem
var _state : State = State.IDLE

# Atualiza estado atual do personagem
func _update_state() -> void:
	if velocity.y < 0:
		_state = State.JUMPING
		return
	
	if not is_on_floor():
		_state = State.FALLING
		return
	
	if velocity.x > 0:
		_state = State.WALKING_RIGHT
		return
		
	if velocity.x < 0:
		_state = State.WALKING_LEFT
		return
	
	_state = State.IDLE

# Executa animação de acordo com estado do personagem
func _update_animation() -> void:
	match _state:
		State.IDLE:
			animations_gnomo.play("idle")
			
		State.WALKING_LEFT:
			animations_gnomo.play("walk")
			
		State.WALKING_RIGHT:
			animations_gnomo.play("walk")
			
		State.JUMPING:
			animations_gnomo.frame = 1
			
		State.FALLING:
			pass

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if vidas > 0:
			if $RayCastLeft.is_colliding():
				take_damage(Vector2(400, -200))
			else:
				take_damage(Vector2(-400, -200))
		
func take_damage(knockback_force = Vector2.ZERO, duration = 0.25):
	vidas -= 1
	if vidas == 0:
		queue_free()
		get_tree().reload_current_scene()
	else:
		sons.stream = load("res://sounds/pulo/som pulo.MP3")
		sons.pitch_scale = 0.7
		sons.play(0.0)
		if knockback_force != Vector2.ZERO:
			knockback_vector = knockback_force
			
			var knockback_tween = get_tree().create_tween()
			knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration)
			animations_gnomo.modulate = Color(1, 0, 0, 1)
			knockback_tween.parallel().tween_property(animations_gnomo, "modulate", Color(1, 1, 1, 1), duration)

func _physics_process(delta):
	
	# Adiciona a gravidade se o player nao estiver no chao
	if not is_on_floor():
		velocity.y += gravity * delta

	# Se o player estiver no chao e for pressionado a tecla espaco aplica a jump_force
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		animations_gnomo.play("jump")
		sons.pitch_scale = 1.2
		sons.stream = load("res://sounds/pulo/som pulo.MP3")
		sons.play(0.0)
	
	# Movimenta o player de acordo com a tecla de direcao pressionada
	var direction = Input.get_axis("ui_left", "ui_right")
	# Está andando
	if direction:
		velocity.x = direction * SPEED
		
		# Andando para direita
		if direction == 1:
			animations_gnomo.flip_h = false
		
		# Andando para esquerda
		else:
			animations_gnomo.flip_h = true
		
	# Está parado
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	
	_update_state()
	_update_animation()
	# Exibe no console estado atual do personagem
	#print(str(State.keys()[_state]))
	move_and_slide()
