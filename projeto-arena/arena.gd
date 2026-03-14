extends Node2D

# Criamos uma lista (Array) que vai segurar nossos arquivos .tres
@export var todos_personagens: Array[StatusPersonagem] = []

# Pegamos a referência das nossas duas bolas na tela
@onready var bola_1 = $Bola1 # Se o nome do seu nó for diferente, mude aqui!
@onready var bola_2 = $Bola2

func _ready():
	# 1. Randomiza a semente (garante que cada partida seja realmente única)
	randomize()
	
	# 2. Embaralha a nossa lista de personagens
	todos_personagens.shuffle()
	
	# 3. Pega os dois primeiros da lista embaralhada (garantindo que nunca serão o mesmo)
	var personagem_p1 = todos_personagens[0]
	var personagem_p2 = todos_personagens[1]
	
	# 4. Envia os dados para as bolas! (Vamos criar essa função na bola agora)
	bola_1.receber_personagem(personagem_p1)
	bola_2.receber_personagem(personagem_p2)
