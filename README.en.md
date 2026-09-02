# ProjetoArena — Automatic combat in Godot

[Português](README.md) | **English**

A **2D automatic combat arena prototype** built with **Godot 4.6 and GDScript**. Two combatants receive resource-defined characters, move through physics, and deal damage through body and weapon collisions. Health bars, impact particles, and console messages track the fight.

The configured project name is **ProjetoArena**. The Godot project is inside **`projeto-arena/`**, and its main scene is `arena.tscn`.

> **Current status:** an automatic simulation without direct combatant controls, a menu, or a victory screen. Importing and a headless run were verified with Godot 4.6; visual presentation and exports were not validated during this review.

## Implemented features

| Feature | Behavior |
| --- | --- |
| **Character assignment** | The `todos_personagens` list is shuffled, and its first two resources are assigned to `Bola1` and `Bola2`. |
| **Automatic movement** | An initial impulse uses a random direction; speed is normalized during physics integration. |
| **Physics arena** | Static colliders form the boundaries; combatants have gravity disabled and use a bouncy physics material. |
| **Physics weapons** | Each character instantiates a weapon connected through `PinJoint2D`, with a collision exception between the weapon and its owner. |
| **Contact damage** | Combatant collisions deal body-contact damage; weapon collisions apply the damage configured in the character resource. |
| **Random defenses** | Dodging avoids damage and temporarily increases speed; blocking avoids damage without granting that bonus. |
| **Health and elimination** | Each combatant has an HP bar. At zero HP or below, it is removed and its weapon damage is set to zero. |
| **Impacts** | Weapons instantiate particles when colliding, using their character's color. The particle scene is configured for a single emission and cleanup on completion. |
| **Resource configuration** | Name, color, health, speed, defenses, damage, and weapon/particle scenes are defined in `StatusPersonagem`. |

## How the simulation works

1. `arena.gd` shuffles the characters and assigns a resource to each combatant.
2. Each combatant receives health, color, and speed, instantiates its weapon, and starts moving in a random direction.
3. Collisions trigger attacks. A single random roll determines whether the target dodges, blocks, or takes damage.
4. Dodging sets speed to **base speed + 75** for **2 seconds**. Another dodge restarts the timer; the bonus does not stack.
5. An eliminated combatant disappears. Its weapon remains as a physics body with zero damage.

The simulation **continues after an elimination**. Winner detection, round completion, and automatic restarting are not implemented.

## Current characters and values

| Character | Resource | Configured color |
| --- | --- | --- |
| **Lâmina Elétrica** (Electric Blade) | `personagem_eletrico.tres` | Yellow/gold |
| **Gelado** (Icy) | `personagem_gelo.tres` | Blue |

Both resources use the same default values from `status_personagem.gd`:

| Attribute | Value |
| --- | --- |
| Maximum health | `100` |
| Base speed | `500` units per second |
| Weapon damage | `15` per valid collision event, before defenses |
| Body-contact damage | `5` per valid collision event, before defenses |
| Dodge chance | `15%` |
| Block chance | `20%` |
| Speed during the bonus | `575` units per second |
| Bonus duration | `2` seconds |

Blocking occupies the range immediately after dodging in the same roll. With the current defaults, the probabilities are **15% dodge, 20% block, and 65% taking damage**.

The “Electric” and “Icy” names do not correspond to implemented elemental effects. Both characters use the same weapon and particle scenes. Active and passive ability name fields exist, but no mechanic executes them.

## Running and controls

### Prerequisites

- [Godot 4.6 Standard](https://godotengine.org/download/archive/4.6-stable/), the version used for verification. The project uses GDScript and does not require the .NET edition.
- Git if you use the clone command.
- For graphical execution, hardware and drivers compatible with **Forward+**. On Windows, the project specifies **Direct3D 12**. See the [renderer documentation](https://docs.godotengine.org/en/4.6/tutorials/rendering/renderers.html) if you need to evaluate another configuration.

No server, API key, database, or external add-on needs to be configured.

### Using the editor

1. Clone the repository:

   ```bash
   git clone https://github.com/Rodrigo-Artur/ArenaProjetoGodot.git
   cd ArenaProjetoGodot
   ```

2. In Godot's project manager, select **Import** and open **`projeto-arena/project.godot`**.
3. Wait for resources to import and open the project.
4. Run with **F5**. `arena.tscn` is already configured as the main scene.
5. Watch the health bars and the editor's **Output** panel for damage, defenses, and eliminations.

| Action | How to do it |
| --- | --- |
| Start the simulation | **F5** in the editor |
| Stop | **F8** in the editor |
| Start another round | Stop execution and run again |
| Move or attack manually | No controls are implemented; combat is automatic |

F5 and F8 are editor shortcuts. The project defines no keyboard, mouse, or gamepad gameplay commands.

### Using the terminal

With the Godot executable available as `godot`, run these commands from the repository root:

```bash
# Open the editor and import resources
godot --editor --path projeto-arena

# Run the main scene after importing
godot --path projeto-arena
```

On Windows, you can also call the executable directly from PowerShell, replacing the path below:

```powershell
& "C:\path\Godot_v4.6-stable_win64_console.exe" --path .\projeto-arena
```

## Customization

### Modify a character

Open a `.tres` file in the Inspector and edit the `StatusPersonagem` properties:

- **Stats:** `nome`, `hp_maximo`, `velocidade_base`, and `cor_do_personagem`.
- **Defenses:** `chance_esquiva` and `chance_bloqueio`.
- **Weapon and effects:** `cena_arma`, `dano_da_arma`, and `cena_particula`.

Keep health and speed positive, percentages between 0 and 100, and the combined defense chances at or below 100. The code does not automatically validate these limits. Body-contact damage and the dodge bonus duration/magnitude are defined in the combatant scripts, rather than in the resources.

### Add another character

1. Duplicate one of the character `.tres` resources in Godot.
2. Change its name, color, and attributes in the Inspector.
3. Open `arena.tscn` and select the **Arena** node.
4. Add the resource to the **Todos Personagens** property.
5. Keep at least **two valid, distinct resources** in the list.

Adding characters expands the selection pool; the scene still contains **two combatants**. The code directly accesses positions `0` and `1` without validating short lists or duplicate entries.

## Project structure

```text
ArenaProjetoGodot/
├── README.md
└── projeto-arena/
    ├── project.godot
    ├── arena.tscn                 # Arena, combatants, colliders, and HP bars
    ├── arena.gd                   # Character selection and assignment
    ├── status_personagem.gd       # Custom StatusPersonagem resource
    ├── personagem_eletrico.tres   # Lâmina Elétrica
    ├── personagem_gelo.tres       # Gelado
    ├── rigid_body_2d.gd           # Bola1 behavior
    ├── bola_2.gd                  # Bola2 behavior
    ├── arma.tscn                  # Weapon physics body and collider
    ├── arma.gd                    # Damage and particle generation
    ├── particula_impacto.tscn     # GPUParticles2D effect
    ├── particula_impacto.gd       # Effect emission and cleanup
    └── icon.svg                  # Texture used for characters and weapons
```

`StatusPersonagem` extends `Resource`, allowing attributes to be edited without changing behavior scripts. Weapons are added as children of the arena and connected to combatants through joints. Particles are also instantiated in the arena.

`rigid_body_2d.gd` and `bola_2.gd` have identical contents in the reviewed version. Changing only one can cause different behavior between the two combatants.

## Verification performed

Verification used **Godot `4.6.stable.official.89cea1439`** on Windows:

- Headless editor import completed with exit code `0`.
- The main scene ran for **3,600 iterations at a fixed 60 FPS**, completing with exit code `0`.
- That run logged **22 damage-received events, 5 dodges, 7 blocks, and 1 elimination**, with no recorded errors or warnings.

These counts describe one random run and do not guarantee the same outcome in other rounds. The check covers loading and basic logic execution; it does not verify appearance, particle rendering, graphics performance, or exports. The repository has no automated test suite.

To repeat the basic check, using `godot` as the executable name:

```bash
godot --headless --editor --path projeto-arena --quit
godot --headless --path projeto-arena --fixed-fps 60 --quit-after 3600
```

The options are documented in the [Godot command-line guide](https://docs.godotengine.org/en/4.6/tutorials/editor/command_line_tutorial.html).

## Limitations and next steps

- **Match flow:** there is no menu, manual character selection, pause, result screen, or in-game restart.
- **Abilities:** active/passive ability names are fields without implementation; there are no ice or electricity effects.
- **Weapon after elimination:** it remains in the arena as a physics object and can still generate particles, although it no longer deals damage.
- **Duplicated logic:** both combatants use copies of the same script.
- **Unvalidated configuration:** character count, references, and attribute ranges are not checked before starting.
- **Prototype visuals:** characters and weapons reuse `icon.svg`. There is no audio, scoreboard, history, or match saving.
- **Distribution:** there is no `export_presets.cfg`; exports need to be configured and verified for the selected platform.

Suggested priorities, not yet implemented:

1. Consolidate combatants into a reusable scene/script and validate resources before starting.
2. Define round completion, handling of an eliminated combatant's weapon, and a restart option.
3. Implement abilities with distinct behavior and add tests for damage, defenses, and bonus duration.
4. Improve visual presentation, control console message volume, and prepare a tested export.

## Repository and license

Source code is available at [Rodrigo-Artur/ArenaProjetoGodot](https://github.com/Rodrigo-Artur/ArenaProjetoGodot). The reviewed repository does not contain a project-level `LICENSE` file.

Documentation based on commit [`e5bc3ca`](https://github.com/Rodrigo-Artur/ArenaProjetoGodot/tree/e5bc3ca2fabbe504acda91e6a8f9e919e0e4d52e).
