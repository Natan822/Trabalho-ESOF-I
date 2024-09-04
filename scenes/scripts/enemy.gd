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
const SPEED: float = 30.0
# Constante de força de pulo do personagem
const JUMP_FORCE: float = -400.0

# Controla animações do personagem
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
# Detecta colisao de personagem com parede
@onready var wall_detector: RayCast2D = $RayCast2DWall
# Detecta colisao de personagem com chão
@onready var ground_detector: RayCast2D = $RayCast2DGround

# Gravidade padrao do objeto 
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
# Estado inicial do personagem
var _state : State = State.IDLE

# Direção do movimento do personagem
var direction: int = -1

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
			animations.play("idle")
			
		State.WALKING_LEFT:
			animations.play("walk")
			
		State.WALKING_RIGHT:
			animations.play("walk")

func _physics_process(delta: float) -> void:
	
	# Adiciona a gravidade se o personagem nao estiver no chao
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if wall_detector.is_colliding() or !ground_detector.is_colliding():
		wall_detector.target_position.x *= -1
		direction *= -1
		animations.flip_h = !animations.flip_h
		
	velocity.x = SPEED * direction
	
	_update_state()
	_update_animation()
	
	move_and_slide()
