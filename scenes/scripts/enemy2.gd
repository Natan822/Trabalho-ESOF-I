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
const SPEED: float = 40.0
# Constante de força de pulo do personagem
const JUMP_FORCE: float = -175.0

# Variável que controla animações do personagem
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
# Variável que detecta paredes
@onready var wall_detector: RayCast2D = $"RayCast2D(parede)"
# Variável que detecta chão
@onready var ground_detector: RayCast2D = $"RayCast2D(chao)"

# Gravidade padrao do objeto 
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity") / 3
# Estado inicial do personagem
var _state : State = State.IDLE

# Direção do movimento do personagem
var direction = -1

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
		State.JUMPING:
			animations.frame = 0
			
		State.FALLING:
			animations.frame = 1

func _physics_process(delta: float) -> void:
	
	# Adiciona a gravidade se o personagem nao estiver no chao
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = JUMP_FORCE
	
	
	if wall_detector.is_colliding():
		wall_detector.target_position.x *= -1
		ground_detector.target_position.x *= -1
		direction *= -1
		animations.flip_h = !animations.flip_h
	
	if  is_on_floor() and !ground_detector.is_colliding():
		wall_detector.target_position.x *= -1
		ground_detector.target_position.x *= -1
		direction *= -1
		animations.flip_h = !animations.flip_h
	
	velocity.x = SPEED * direction
	
	
	_update_state()
	_update_animation()
	
	move_and_slide()
