extends RigidBody2D

# O @export faz essa variável aparecer lá no painel Inspetor do Godot!
@export var direcao_inicial: Vector2 = Vector2(-400, 300)

var velocidade_constante = 500.0

func _ready():
	# Agora usamos a variável que definimos no painel
	apply_central_impulse(direcao_inicial)

func _integrate_forces(state):
	var velocidade_atual = state.linear_velocity.length()
	
	if velocidade_atual > 0:
		state.linear_velocity = state.linear_velocity.normalized() * velocidade_constante
