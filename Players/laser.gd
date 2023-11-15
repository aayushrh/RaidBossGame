extends RayCast2D
var direction = 0
var duration = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	print("hi")
	position=Vector2.ZERO
	$Line2D.position=Vector2(-66.5,-30)
	$Line2D.width=0
	$Line2D.add_point(Vector2.ZERO)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#print(target_position)
	if(is_colliding()):
		$Line2D.set_point_position(1,Vector2(0,-(get_collision_point()-global_position).length())-$Line2D.position)
	else:
		$Line2D.set_point_position(1,target_position-$Line2D.position)
	if(duration>2.5):
		$Line2D.width+=.5
	else:
		$Line2D.width-=.5
	
	duration-=delta
	if(duration<=0):
		get_parent().remove_child(self)
