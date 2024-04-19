extends Control

signal pressedEnter

@export var enemy : Resource = null

var currentPlayerHealth
var currentEnemyHealth

func _ready():
	setHealth($EnemyContainer/EnemyHealth, enemy.health, enemy.health)
	setHealth($PlayerHUD/PlayerData/PlayerHealth, State.currentHealth, State.maxHealth)
	$EnemyContainer/EnemySprite.texture = enemy.texture
	$BattleText.hide()
	$PlayerActionsHUD.hide()
	currentPlayerHealth = State.currentHealth
	currentEnemyHealth = enemy.health
	display_text("Oh man, here comes %s again. When will he learn?" % [enemy.name])
	await pressedEnter
	tickerSwitch(false)
	$BattleText.hide()
	$PlayerActionsHUD.show()

func _process(delta):
	pass

func display_text(text):
	$PlayerActionsHUD.hide()
	$BattleText.show()
	tickerSwitch(true)
	$BattleText/Label.text = text

func tickerSwitch(switch : bool):
	if switch:
		$FlickerTicker.start()
	else:
		$FlickerTicker.stop()
		$BattleText/Ticker.visible = false	

func run():
	display_text("You are a coward. A cretin.\nYou may have run from %s, but you can never run from the eyes of He who judges all." % [enemy.name]) 
	await pressedEnter
	get_tree().quit()

func setHealth(progress_bar, currentHealth, maxHealth):
	progress_bar.value = currentHealth
	progress_bar.max_value = maxHealth
	progress_bar.get_node("Label").text = "HP: %d / %d" % [currentHealth, maxHealth]
	
func enemyTurn():
	display_text("The %s attacks with all their might!" % [enemy.name])
	$AnimationPlayer.play("enemy_attack")
	await $AnimationPlayer.animation_finished
	await pressedEnter
	display_text("The %s dealt %s damage to you!" % [enemy.name, enemy.damage])
	await pressedEnter
	currentPlayerHealth = max(0, currentPlayerHealth - enemy.damage)
	setHealth($PlayerHUD/PlayerData/PlayerHealth, currentPlayerHealth, State.maxHealth)
	$BattleText.hide()
	$PlayerActionsHUD.show()
	

func _input(event):
	if event.is_action_pressed("ui_select") || event.is_action_released("LeftMouse"):
		pressedEnter.emit()

func _on_flicker_ticker_timeout():
	$BattleText/Ticker.visible = !($BattleText/Ticker.visible)

func _on_run_pressed():
	run()

func _on_attack_pressed():
	display_text("You attacked the %s." % [enemy.name])
	await pressedEnter
	currentEnemyHealth =  max(0, currentEnemyHealth - State.playerDamage)
	setHealth($EnemyContainer/EnemyHealth, currentEnemyHealth, enemy.health)
	$AnimationPlayer.play("enemy_damaged")
	display_text("You dealt %s damage to the %s!" % [State.playerDamage, enemy.name])
	await $AnimationPlayer.animation_finished
	await pressedEnter
	tickerSwitch(false)
	enemyTurn()
