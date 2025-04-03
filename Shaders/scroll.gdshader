shader_type canvas_item;

uniform float speed = 0.25;
uniform bool x_movement = true;
uniform bool y_movement = true;

void vertex() {
	if (x_movement) UV.x += TIME * speed;
	if (y_movement) UV.y += TIME * speed;
}