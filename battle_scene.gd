extends Control

signal pressedEnter

func _ready():
	setHealth($PlayerHUD/PlayerData/PlayerHealth, State.currentHealth, State.maxHealth)
	setHealth($EnemyContainer/EnemyHealth, 20, 20)
	$BattleText.hide()
	$PlayerActionsHUD.hide()
	display_text("Oh man, here comes this thing again. When will he learn?")

func _process(delta):
	pass

func display_text(text):
	$PlayerActionsHUD.hide()
	$BattleText.show()
	tickerSwitch(true)
	$BattleText/Label.text = text
	await pressedEnter
	tickerSwitch(false)
	$BattleText.hide()
	$PlayerActionsHUD.show()

func run():
	display_text("You are a coward. A cretin.\nYou may have run from this battle, but you can never run from the eyes of He who judges all.")
	await pressedEnter
	get_tree().quit()

func setHealth(progress_bar, currentHealth, maxHealth):
	progress_bar.value = currentHealth
	progress_bar.max_value = maxHealth
	progress_bar.get_node("Label").text = "HP: %d / %d" % [currentHealth, maxHealth]
	
func tickerSwitch(switch : bool):
	if switch:
		$FlickerTicker.start()
	else:
		$FlickerTicker.stop()
		$BattleText/Ticker.visible = false

func _input(event):
	if event.is_action_pressed("ui_select") || event.is_action_pressed("LeftMouse"):
		pressedEnter.emit()

func _on_flicker_ticker_timeout():
	$BattleText/Ticker.visible = !($BattleText/Ticker.visible)
	



func _on_run_pressed():
	run()
