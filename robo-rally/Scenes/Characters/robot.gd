extends CharacterBody2D

var player: String
var character: String

var card = preload("res://Scenes/UI/card.tscn")

var deck = []
var discard = []
var cards_in_hand = []
var current_permanent_upgrades = []
var current_temporary_upgrades = []
var upgrades_in_hand = []
