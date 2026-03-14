extends RigidBody2D

var velocidade_constante = 500.0
var meu_status: StatusPersonagem
var hp_atual: float 

# --- NOVA VARIÁVEL: Cronômetro do Boost ---
var tempo_restante_boost: float = 0.0

@onready var barra_hp = $ProgressBar

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
	# --- NOVA LÓGICA DE DIREÇÃO ALEATÓRIA ---
	# TAU é uma constante matemática do Godot que equivale a 2 * PI (uma volta completa de 360º)
	# Sorteamos um ângulo qualquer dentro dessa volta.
	var angulo_aleatorio = randf_range(0.0, TAU)
	
	# Usamos cosseno(x) e seno(y) para converter esse ângulo numa direção (Vector2)
	# Depois, multiplicamos pela velocidade para dar a força do empurrão.
	var impulso = Vector2(cos(angulo_aleatorio), sin(angulo_aleatorio)) * velocidade_constante
	
	# Aplicamos o empurrão aleatório!
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
		body.aplicar_dano(10)

func aplicar_dano(valor: float):
	var rolagem = randf_range(0.0, 100.0)
	
	if rolagem <= meu_status.chance_esquiva:
		# 1. NÃO ACUMULATIVO: Em vez de somar (+=), nós definimos exatamente a Base + 50
		velocidade_constante = meu_status.velocidade_base + 150.0 
		
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
			queue_free()
