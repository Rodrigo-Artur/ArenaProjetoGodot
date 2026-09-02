# ProjetoArena — Combate automático em Godot

**Português** | [English](README.en.md)

Protótipo de **arena de combate automático em 2D**, desenvolvido em **Godot 4.6 e GDScript**. Dois combatentes recebem personagens definidos por recursos, movimentam-se por física e causam dano por colisões corporais e de armas. Barras de vida, partículas de impacto e mensagens no console acompanham o combate.

O nome configurado no editor é **ProjetoArena**. O projeto Godot está dentro da pasta **`projeto-arena/`**; a cena inicial é `arena.tscn`.

> **Estado atual:** simulação automática, sem controle direto dos combatentes, menu ou tela de vitória. A importação e uma execução sem janela foram verificadas com Godot 4.6; a apresentação visual e a exportação não foram validadas nesta revisão.

## Recursos implementados

| Recurso | Comportamento |
| --- | --- |
| **Distribuição de personagens** | A lista `todos_personagens` é embaralhada e seus dois primeiros recursos são atribuídos a `Bola1` e `Bola2`. |
| **Movimento automático** | Impulso inicial em direção aleatória e normalização da velocidade durante a integração física. |
| **Arena física** | Limites formados por colisores estáticos; os combatentes têm gravidade desativada e material com restituição. |
| **Armas físicas** | Cada personagem instancia sua arma, conectada por `PinJoint2D`, com exceção de colisão entre arma e proprietário. |
| **Dano por contato** | Colisões entre combatentes causam dano corporal; colisões de arma aplicam o dano definido no recurso do personagem. |
| **Defesas aleatórias** | Esquiva evita dano e concede velocidade temporária; bloqueio evita dano sem conceder esse bônus. |
| **Vida e eliminação** | Cada combatente possui barra de HP. Ao chegar a zero ou menos, ele é removido e o dano de sua arma é zerado. |
| **Impactos** | A arma instancia partículas ao colidir, usando a cor do personagem. A cena de partículas é configurada para uma emissão e descarte ao terminar. |
| **Configuração por recursos** | Nome, cor, vida, velocidade, defesa, dano e cenas de arma/partículas são definidos em `StatusPersonagem`. |

## Como a simulação funciona

1. `arena.gd` embaralha os personagens e atribui um recurso a cada combatente.
2. Cada combatente recebe vida, cor e velocidade, instancia sua arma e parte em uma direção aleatória.
3. As colisões acionam ataques. Uma única rolagem determina se o alvo esquiva, bloqueia ou recebe o dano.
4. Ao esquivar, a velocidade passa para **velocidade base + 75** por **2 segundos**. Outra esquiva reinicia o tempo; o bônus não se acumula.
5. Ao ser eliminado, o combatente desaparece. Sua arma permanece como corpo físico, com dano zero.

A simulação **continua após uma eliminação**. Ainda não existe verificação de vencedor, encerramento de rodada ou reinício automático.

## Personagens e valores atuais

| Personagem | Recurso | Cor configurada |
| --- | --- | --- |
| **Lâmina Elétrica** | `personagem_eletrico.tres` | Amarelo/dourado |
| **Gelado** | `personagem_gelo.tres` | Azul |

Os dois recursos usam os mesmos valores padrão de `status_personagem.gd`:

| Atributo | Valor |
| --- | --- |
| Vida máxima | `100` |
| Velocidade base | `500` unidades por segundo |
| Dano da arma | `15` por evento de colisão válido, antes das defesas |
| Dano corporal | `5` por evento de colisão válido, antes das defesas |
| Chance de esquiva | `15%` |
| Chance de bloqueio | `20%` |
| Velocidade durante o bônus | `575` unidades por segundo |
| Duração do bônus | `2` segundos |

O bloqueio ocupa a faixa seguinte à esquiva na mesma rolagem. Com os padrões atuais, as probabilidades são **15% de esquiva, 20% de bloqueio e 65% de receber dano**.

Os nomes “Elétrica” e “Gelado” não correspondem a efeitos elementais implementados. Ambos usam a mesma cena de arma e a mesma cena de partículas. Os campos de habilidade ativa e passiva existem, mas não são executados por nenhuma mecânica.

## Execução e controles

### Pré-requisitos

- [Godot 4.6 Standard](https://godotengine.org/download/archive/4.6-stable/), versão utilizada na verificação. O projeto usa GDScript e não precisa da edição .NET.
- Git, caso utilize o comando de clonagem.
- Para execução gráfica, hardware e drivers compatíveis com **Forward+**. No Windows, o projeto configura **Direct3D 12**. Consulte a [documentação dos renderizadores](https://docs.godotengine.org/en/4.6/tutorials/rendering/renderers.html) se precisar avaliar outra configuração.

Não há servidor, chave de API, banco de dados ou complemento externo para configurar.

### Pelo editor

1. Clone o repositório:

   ```bash
   git clone https://github.com/Rodrigo-Artur/ArenaProjetoGodot.git
   cd ArenaProjetoGodot
   ```

2. No gerenciador de projetos do Godot, selecione **Importar** e abra **`projeto-arena/project.godot`**.
3. Aguarde a importação dos recursos e abra o projeto.
4. Execute com **F5**. `arena.tscn` já está configurada como cena principal.
5. Observe as barras de vida e o painel **Saída / Output** do editor para acompanhar dano, defesas e eliminações.

| Ação | Como fazer |
| --- | --- |
| Iniciar a simulação | **F5** no editor |
| Parar | **F8** no editor |
| Iniciar uma nova rodada | Pare a execução e execute novamente |
| Movimentar ou atacar manualmente | Não há controles implementados; o combate é automático |

F5 e F8 são atalhos do editor. O projeto não define comandos de jogo para teclado, mouse ou controle.

### Pelo terminal

Com o executável do Godot disponível como `godot`, execute a partir da raiz do repositório:

```bash
# Abrir o editor e importar os recursos
godot --editor --path projeto-arena

# Executar a cena principal após a importação
godot --path projeto-arena
```

No Windows, também é possível chamar o executável diretamente no PowerShell, substituindo o caminho abaixo:

```powershell
& "C:\caminho\Godot_v4.6-stable_win64_console.exe" --path .\projeto-arena
```

## Personalização

### Alterar um personagem

Abra um arquivo `.tres` no Inspetor e ajuste as propriedades de `StatusPersonagem`:

- **Status:** `nome`, `hp_maximo`, `velocidade_base` e `cor_do_personagem`.
- **Defesas:** `chance_esquiva` e `chance_bloqueio`.
- **Arma e efeitos:** `cena_arma`, `dano_da_arma` e `cena_particula`.

Mantenha vida e velocidade positivas, percentuais entre 0 e 100 e a soma das chances de defesa em até 100. O código não valida esses limites automaticamente. O dano corporal e a duração/intensidade do bônus de esquiva estão nos scripts dos combatentes, não nos recursos.

### Adicionar outro personagem

1. Duplique um dos recursos de personagem `.tres` pelo Godot.
2. Altere nome, cor e atributos no Inspetor.
3. Abra `arena.tscn` e selecione o nó **Arena**.
4. Adicione o novo recurso à propriedade **Todos Personagens**.
5. Mantenha pelo menos **dois recursos válidos e distintos** nessa lista.

Adicionar personagens amplia o conjunto disponível para sorteio; a cena continua com **dois combatentes**. O código acessa diretamente as posições `0` e `1`, sem validar listas pequenas ou entradas duplicadas.

## Organização do projeto

```text
ArenaProjetoGodot/
├── README.md
└── projeto-arena/
    ├── project.godot
    ├── arena.tscn                 # Arena, combatentes, colisores e barras de HP
    ├── arena.gd                   # Sorteio e atribuição dos personagens
    ├── status_personagem.gd       # Recurso customizado StatusPersonagem
    ├── personagem_eletrico.tres   # Lâmina Elétrica
    ├── personagem_gelo.tres       # Gelado
    ├── rigid_body_2d.gd           # Comportamento de Bola1
    ├── bola_2.gd                  # Comportamento de Bola2
    ├── arma.tscn                  # Corpo físico e colisor da arma
    ├── arma.gd                    # Dano e geração de partículas
    ├── particula_impacto.tscn     # Efeito com GPUParticles2D
    ├── particula_impacto.gd       # Emissão e descarte do efeito
    └── icon.svg                  # Textura usada nos personagens e armas
```

`StatusPersonagem` estende `Resource`, permitindo editar atributos sem alterar os scripts de comportamento. As armas são adicionadas como filhas da arena e conectadas aos combatentes por juntas. As partículas também são instanciadas na arena.

`rigid_body_2d.gd` e `bola_2.gd` possuem conteúdo idêntico na versão analisada. Uma alteração em apenas um deles pode produzir comportamentos diferentes entre os dois combatentes.

## Verificação realizada

Foi utilizado **Godot `4.6.stable.official.89cea1439`**, no Windows:

- Importação do projeto pelo editor em modo sem janela, concluída com código de saída `0`.
- Execução da cena principal por **3.600 iterações com passo fixo de 60 FPS**, concluída com código de saída `0`.
- O registro dessa execução incluiu **22 eventos de dano recebido, 5 esquivas, 7 bloqueios e 1 eliminação**, sem erros ou avisos registrados.

Esses números descrevem uma única execução aleatória, sem garantir o mesmo resultado em outras rodadas. O teste valida carregamento e execução básica da lógica; não verifica aparência, renderização das partículas, desempenho gráfico ou exportação. O repositório não possui uma suíte de testes automatizados.

Para reproduzir a verificação básica, usando `godot` como nome do executável:

```bash
godot --headless --editor --path projeto-arena --quit
godot --headless --path projeto-arena --fixed-fps 60 --quit-after 3600
```

As opções estão descritas no [guia de linha de comando do Godot](https://docs.godotengine.org/en/4.6/tutorials/editor/command_line_tutorial.html).

## Limitações e próximos passos

- **Fluxo de partida:** faltam menu, seleção manual, pausa, resultado e reinício dentro do jogo.
- **Habilidades:** os nomes de habilidades ativa/passiva são campos sem implementação; não existem efeitos de gelo ou eletricidade.
- **Arma após eliminação:** permanece na arena como objeto físico e continua podendo gerar partículas, embora não cause dano.
- **Lógica duplicada:** os dois combatentes usam cópias do mesmo script.
- **Configuração sem validação:** quantidade de personagens, referências e faixas de atributos não são verificadas antes de iniciar.
- **Protótipo visual:** personagens e armas reutilizam `icon.svg`. Não há áudio, placar, histórico ou salvamento de partidas.
- **Distribuição:** não há `export_presets.cfg`; exportações precisam ser configuradas e verificadas para a plataforma escolhida.

Prioridades sugeridas, ainda não implementadas:

1. Consolidar os combatentes em uma cena/script reutilizável e validar os recursos antes de iniciar.
2. Definir o encerramento da rodada, o tratamento da arma do eliminado e a opção de reiniciar.
3. Implementar habilidades com comportamentos distintos e criar testes para dano, defesas e duração do bônus.
4. Trabalhar a apresentação visual, controlar o volume de mensagens no console e preparar uma exportação testada.

## Repositório e licença

Código disponível em [Rodrigo-Artur/ArenaProjetoGodot](https://github.com/Rodrigo-Artur/ArenaProjetoGodot). O repositório analisado não contém arquivo `LICENSE` próprio para o projeto.

Documentação baseada no commit [`e5bc3ca`](https://github.com/Rodrigo-Artur/ArenaProjetoGodot/tree/e5bc3ca2fabbe504acda91e6a8f9e919e0e4d52e).
