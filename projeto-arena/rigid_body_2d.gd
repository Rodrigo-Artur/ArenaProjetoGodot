extends RigidBody2D
# Variável para guardarmos a referência da arma instanciada
var minha_arma_instanciada: Node

var velocidade_constante = 500.0
var meu_status: StatusPersonagem
var hp_atual: float 

# --- NOVA VARIÁVEL: Cronômetro do Boost ---
var tempo_restante_boost: float = 0.0

@onready var barra_hp = $ProgressBar
@onready var junta = $PinJoint2D

func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_on_body_entered)

func receber_personagem(novo_status: StatusPersonagem):
	meu_status = novo_status
	velocidade_constante = meu_status.velocidade_base
	hp_atual = meu_status.hp_maximo 
	
	barra_hp.max_value = hp_atual
	barra_hp.value = hp_atual
	self.modulate = meu_status.cor_do_personagem
	
	if meu_status.cena_arma != null:
		# Guardamos a arma gerada na nossa nova variável
		minha_arma_instanciada = meu_status.cena_arma.instantiate()
		
		get_parent().add_child(minha_arma_instanciada)
		
		minha_arma_instanciada.global_position = self.global_position
		self.add_collision_exception_with(minha_arma_instanciada)
		
		junta.node_a = self.get_path()
		junta.node_b = minha_arma_instanciada.get_path()
		
		minha_arma_instanciada.modulate = meu_status.cor_do_personagem
		
		# --- NOVO: Passamos o dano do cartão para a arma real! ---
		minha_arma_instanciada.dano_da_arma = meu_status.dano_da_arma
		
		# --- NOVAS LINHAS AQUI ---
		minha_arma_instanciada.cena_particula = meu_status.cena_particula
		minha_arma_instanciada.cor_do_efeito = meu_status.cor_do_personagem

	var angulo_aleatorio = randf_range(0.0, TAU)
	var impulso = Vector2(cos(angulo_aleatorio), sin(angulo_aleatorio)) * velocidade_constante
	apply_central_impulse(impulso)

# --- NOVA FUNÇÃO: O Relógio do Jogo ---
func _process(delta):
	# Se o cronômetro do boost estiver rodando...
	if tempo_restante_boost > 0:
		tempo_restante_boost -= delta # Diminui o tempo conforme os frames passam
		
		# Quando o tempo zerar, voltamos à velocidade original
		if tempo_restante_boost <= 0:
			velocidade_constante = meu_status.velocidade_base
			print("⏱️ O boost de " + meu_status.nome + " acabou! Velocidade normalizada.")

func _integrate_forces(state):
	var velocidade_atual = state.linear_velocity.length()
	if velocidade_atual > 0:
		state.linear_velocity = state.linear_velocity.normalized() * velocidade_constante

func _on_body_entered(body: Node):
	if body.has_method("aplicar_dano"):
		# Reduzimos o dano base de quando as bolas batem cabeça com cabeça
		body.aplicar_dano(5.0)

func aplicar_dano(valor: float):
	var rolagem = randf_range(0.0, 100.0)
	
	if rolagem <= meu_status.chance_esquiva:
		# 1. NÃO ACUMULATIVO: Em vez de somar (+=), nós definimos exatamente a Base + 50
		velocidade_constante = meu_status.velocidade_base + 75.0 
		
		# 2. TEMPORÁRIO: Reiniciamos o cronômetro para 2 segundos. Se ele esquivar 
		# enquanto já estiver com boost, o cronômetro apenas volta para 2s.
		tempo_restante_boost = 2.0 
		print("💨 " + meu_status.nome + " ESQUIVOU! Boost de velocidade por 2s!")
		
	elif rolagem <= (meu_status.chance_esquiva + meu_status.chance_bloqueio):
		print("🛡️ " + meu_status.nome + " BLOQUEOU o ataque!")
		
	else:
		hp_atual -= valor
		barra_hp.value = hp_atual
		print("⚔️ " + meu_status.nome + " sofreu " + str(valor) + " de dano! HP: " + str(hp_atual))
		
		if hp_atual <= 0:
			print("--- 💀 " + meu_status.nome + " FOI DESTRUÍDO! ---")
			
			# NOVO: Antes da bola sumir, ela "desliga" a própria arma
			if minha_arma_instanciada != null:
				minha_arma_instanciada.dano_da_arma = 0.0
				
			queue_free()
