extends Resource
class_name StatusPersonagem

# Status Base
@export var nome: String = "Personagem Desconhecido"
@export var hp_maximo: float = 100.0
@export var velocidade_base: float = 500.0
@export var cor_do_personagem: Color = Color(1, 1, 1) # Branco por padrão

# Deixamos o espaço preparado para as habilidades (podemos detalhar isto mais à frente)
@export var nome_habilidade_ativa: String = "Nenhuma"
@export var nome_habilidade_passiva: String = "Nenhuma"

# --- NOVOS STATUS DE DEFESA (%) ---
@export var chance_esquiva: float = 15.0 # 15% de chance padrão
@export var chance_bloqueio: float = 20.0 # 20% de chance padrão

# Usamos PackedScene para podermos arrastar um arquivo .tscn inteiro para cá!
# Usamos PackedScene para podermos arrastar um arquivo .tscn inteiro para cá!
@export var cena_arma: PackedScene 

# NOVO: Dano específico da arma deste personagem
@export var dano_da_arma: float = 15.0

@export var cena_particula: PackedScene
