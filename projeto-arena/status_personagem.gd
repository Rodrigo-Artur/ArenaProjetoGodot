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
