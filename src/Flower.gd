extends StaticBody2D

enum { POT, SAPLING, LEAVES, BLOSSOMED }

var pot_texture = preload("res://assets/pot.png")
var sapling_texture = preload("res://assets/sapling.png")
var leaves_texture = preload("res://assets/leaves.png")
var blossomed_texture = preload("res://assets/blossomed.png")

var status
var sprite
var game_controller

var decay_time
var water_level = 0

var counter

var timer
var ms_timer

export var plant_timer = 1.5

var ms_wait_time = 0.01

var current_time

func _ready():
    sprite = get_node("Sprite")
    counter = get_node("Counter")

    current_time = plant_timer

    timer = Timer.new()
    add_child(timer)
    
    timer.connect("timeout", self, "on_Timer_timeout")
    timer.set_wait_time(plant_timer)
    timer.set_one_shot(false)

    #ms_timer = Timer.new();
    #add_child(ms_timer)

    #ms_timer.connect("timeout", self, "on_MSTimer_timeout")
    #ms_timer.set_wait_time(ms_wait_time)
    #ms_timer.set_one_shot(false)


    game_controller = get_parent().get_parent()
    status = POT

func add_water():
    if water_level == 0:
        timer.start()
        #ms_timer.start()
        current_time = plant_timer

    if water_level < 3:
        water_level += 1


func on_MSTimer_timeout():
    if current_time <= 0:
        current_time = plant_timer

    counter.text = str(current_time)

    current_time -= ms_wait_time

func on_Timer_timeout():
    if water_level == 0:
        decay()

    if water_level >= 1 && water_level <= 2:
        grow()

    if water_level >= 3:
        sprite.texture = pot_texture
        status = POT

    if water_level > 0:
        water_level -= 1

func decay():
    match status:
        SAPLING:
            sprite.texture = pot_texture
            status = POT
        LEAVES:
            sprite.texture = sapling_texture
            status = SAPLING
        BLOSSOMED:
            sprite.texture = leaves_texture
            status = LEAVES


func grow():
    match status:
        POT:
            sprite.texture = sapling_texture
            status = SAPLING
            game_controller.points += 1
        SAPLING:
            sprite.texture = leaves_texture
            status = LEAVES
            game_controller.points += 2
        LEAVES:
            sprite.texture = blossomed_texture
            status = BLOSSOMED
            game_controller.points += 4
        BLOSSOMED:
            pass
