extends RigidBody2D

@export var direcao_inicial: Vector2 = Vector2(400, -300)

var velocidade_constante = 500.0
var meu_status: StatusPersonagem # Variável para guardar quem eu sou

# Apagamos a função _ready() antiga daqui, pois agora a bola só se move 
# QUANDO a Arena mandar.

func receber_personagem(novo_status: StatusPersonagem):
	meu_status = novo_status
	
	# Atualizamos a velocidade com base nos dados do personagem!
	velocidade_constante = meu_status.velocidade_base
	
	# Pinta a bola com a cor do personagem para sabermos quem é quem
	self.modulate = meu_status.cor_do_personagem
	
	# Agora sim, damos o empurrão inicial
	apply_central_impulse(direcao_inicial)

func _integrate_forces(state):
	var velocidade_atual = state.linear_velocity.length()
	
	if velocidade_atual > 0:
		state.linear_velocity = state.linear_velocity.normalized() * velocidade_constante
