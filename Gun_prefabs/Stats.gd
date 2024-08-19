extends Resource
class_name Stats

export (PackedScene) var bullet_path

#stats
var rot_speed = 1

var firerate = 0.0
var BulletSpread = 0.0
var reloadSpeed = 0.0
var damage = 0
var magazine = 0
var rarity = null

export (int) var min_dmg
export (int) var max_dmg

export (int) var min_mag
export (int) var max_mag

export (int) var min_accuracy
export (int) var max_accuracy

export (float) var min_firerate
export (float) var max_firerate

export (float) var min_reloadSpeed
export (float) var max_reloadSpeed

export (int) var Cost = 0
export (int) var rayLOS = 0

func compute():
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	rot_speed = rng.randi_range(2, 6)

	BulletSpread = rng.randi_range(min_accuracy, max_accuracy)
	magazine = rng.randi_range(min_mag, max_mag)
	damage = rng.randi_range(min_dmg, max_dmg)

	reloadSpeed = round_to_dec(rand_range(min_reloadSpeed, max_reloadSpeed), 2)
	firerate = round_to_dec(rand_range(min_firerate, max_firerate), 2)
	computeCost()

func computeCost():
	var frPm = (max_firerate * 3) / firerate
	var rsPm = (max_reloadSpeed * 3) / reloadSpeed
	var mag_per_money = (max_mag * 3) / magazine
	var damage_per_money = (max_dmg * 5) / damage
	var accuracy = -BulletSpread * 2
	
	Cost = rot_speed + -accuracy + mag_per_money + damage_per_money + rsPm + frPm + (rayLOS / 2)
	Cost = int(Cost)
	rarity_calc()

func rarity_calc():
	var a = calcPercentage(damage, max_dmg)
	var b = calcPercentage(magazine, max_mag)
	var c = calcPercentage(min_accuracy, BulletSpread)
	var d = calcPercentage(min_reloadSpeed, reloadSpeed)
	var e = calcPercentage(min_firerate, firerate)
	var sum = (a + b + c + d + e)
	var max_stats = sum / 5
	if max_stats >= 95:
		rarity = "legendary"
	elif max_stats >= 80:
		rarity = "epic"
	elif max_stats >= 70:
		rarity = "uncommon"
	elif max_stats >= 50:
		rarity = "common"
	elif max_stats <= 49:
		rarity = "shi - tier"


func calcPercentage(partialValue, totalValue):
  return int((float(partialValue) / totalValue) * 100)
	
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

























