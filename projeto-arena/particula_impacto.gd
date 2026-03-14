extends GPUParticles2D

func _ready():
	# Assim que a partícula nasce no jogo, liga-se a emissão
	emitting = true
	
	# Quando terminar de emitir as faíscas, a própria partícula apaga-se da memória
	finished.connect(queue_free)
