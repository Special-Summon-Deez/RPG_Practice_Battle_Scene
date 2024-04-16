extends Control

signal pressedEnter

func _ready():
	$BattleText.hide()
	$PlayerActionsHUD.hide()
	display_text("Oh man, here comes this thing again. When will he learn?")

func _process(delta):
	pass

func display_text(text):
	$BattleText.show()
	tickerSwitch(true)
	$BattleText/Label.text = text
	await pressedEnter
	tickerSwitch(false)
	$BattleText.hide()
	$PlayerActionsHUD.show()
	
func _input(event):
	if event.is_action_pressed("ui_select") || event.is_action_pressed("LeftMouse"):
		pressedEnter.emit()
		
func tickerSwitch(switch : bool):
	if switch:
		$FlickerTicker.start()
	else:
		$FlickerTicker.stop()
		$BattleText/Ticker.visible = false

func _on_flicker_ticker_timeout():
	$BattleText/Ticker.visible = !($BattleText/Ticker.visible)
