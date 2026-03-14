extends RigidBody2D

var dano_da_arma: float = 0.0

# Novas variáveis para guardarmos qual é a partícula e a cor do dono desta arma
var cena_particula: PackedScene
var cor_do_efeito: Color

func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	# 1. GERA A PARTÍCULA INDEPENDENTEMENTE DO QUE A ARMA BATEU (Parede ou Bola)
	# 1. GERA A PARTÍCULA
	if cena_particula != null:
		print("✨ Partícula gerada!") # Adicionamos isto para termos a certeza!
		var efeito = cena_particula.instantiate()
		
		# CORREÇÃO: Apenas um get_parent() para colocar na Arena
		get_parent().add_child(efeito) 
		
		efeito.global_position = self.global_position
		efeito.modulate = cor_do_efeito

	# 2. APLICA O DANO APENAS SE FOR UM INIMIGO
	if dano_da_arma > 0 and body.has_method("aplicar_dano"):
		print("🔪 CORTADA! A arma causou " + str(dano_da_arma) + " de dano!")
		body.aplicar_dano(dano_da_arma)
