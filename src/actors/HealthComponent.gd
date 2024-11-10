extends Node
class_name HealthComponent

@export var max_health := 100
@export var current_health := 100

## Does the same as [signal HealthComponent.on_health_changed], but only gives you the difference.
## Also [signal HealthComponent.on_health_changed] is emmitted before this.
signal on_damaged(dmg_done: int)
## Is emmitted before [signal HealthComponent.on_damaged].
signal on_health_changed(new_hp: int, old_hp: int)
signal on_died()

# Prevents getting healed after dying.
var _is_dead := false

func damage(dmg: int):
	if dmg == 0 or _is_dead:
		return
	
	var prev = current_health
	current_health = clamp(current_health - dmg, 0, max_health)
	on_health_changed.emit(current_health, prev)
	on_damaged.emit(dmg)
	
	# health changed
	if prev != current_health:
		if current_health == 0:
			_is_dead = true
			on_died.emit()

func is_dead() -> bool:
	return _is_dead
