extends RigidBody2D

export(int) var graphic_pixel_size
export(bool) var does_explode
export(float) var speed_min
export(float) var speed_max

onready var ballgraphic = $TestBall
onready var cshape = $CShape
onready var bzone = $BulletZone

var iscale

func _ready():
	linear_velocity.x = rand_range(-200, 200)
	linear_velocity.y = 200
	iscale = ballgraphic.scale
	
	
	pass

func _physics_process(delta):
	var realsize = (graphic_pixel_size*ballgraphic.scale.x)/2
	if (transform.origin.x < -realsize):
		transform.origin.x = 256 + realsize - 2
	if (transform.origin.x > 256 + realsize):
		transform.origin.x = -realsize + 2
	angular_velocity = 0
	ballgraphic.scale = lerp(ballgraphic.scale, iscale, delta*3)
	if (linear_velocity.length() < speed_min):
		linear_velocity *= 1.1
	elif (linear_velocity.length() > speed_max):
		linear_velocity *= 0.9
	pass

func _on_BulletZone_area_entered(area):
	area.queue_free()
	linear_velocity *= 0.6
	linear_velocity += area.vel.rotated(area.rot) * 15
	iscale += Vector2.ONE * 0.1
	cshape.scale += Vector2.ONE * 0.25
	bzone.scale += Vector2.ONE * 0.25
	ballgraphic.scale *= 1.3
	if (iscale.x >= 0.8):
		queue_free()


func _on_TestBall_body_entered(body):
	ballgraphic.scale *= 1.05
	linear_velocity *= 1.2