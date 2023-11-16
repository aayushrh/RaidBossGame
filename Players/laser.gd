extends RayCast2D
var direction = 0
var duration = 3
var width = 0
enum{
	RUN,
	ATTACK,
	ATTACKING
}

# Called when the node enters the scene tree for the first time.
func _ready():
	position=Vector2.ZERO
	$Line2D.width = width
	$Line2D.add_point(Vector2.ZERO)
	$Line2D.add_point(Vector2.ZERO)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#print(target_position)
	var temp = 0
	if(is_colliding()):
		temp = -(get_collision_point()-global_position).length()
		$Line2D.set_point_position(1,(Vector2(0,temp)-$Line2D.position))
		
	else:
		temp = -target_position.length()
		$Line2D.set_point_position(1,target_position-$Line2D.position)
	$Area2D/CollisionShape2D.shape.a = Vector2.ZERO
	$Area2D/CollisionShape2D.shape.b = Vector2(1,temp-1)
	if(duration>1.5):
		$Line2D.width*=1+2*delta
	else:
		$Line2D.width/=1+2*delta
	
	duration-=delta
	if(duration<=0):
		get_parent().state=RUN
		get_parent().remove_child(self)
