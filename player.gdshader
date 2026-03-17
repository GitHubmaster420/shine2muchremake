shader_type canvas_item;

uniform sampler2D tex;

uniform mat3 world_rot = mat3(vec3(1, 0, 0), vec3(0, 1, 0), vec3(0, 0, 1));
uniform mat3 player_rot = mat3(vec3(1, 0, 0), vec3(0, 1, 0), vec3(0, 0, 1));

uniform float size_inverse = 10.0;

vec3 rotate_around_axis(vec3 v, vec3 axis, float angle) {
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;

    return v * c +
           cross(axis, v) * s +
           axis * dot(axis, v) * oc;
}

vec3 circle_to_sphere(vec2 circle_uv){
	float alpha = atan(circle_uv.y, circle_uv.x);

	float circle_radius = 0.5;
	float d = length(circle_uv) / circle_radius * PI;

	vec3 rotate_around = vec3(cos(alpha), sin(alpha), 0);
	vec3 vector_to_rotate = vec3(0, 0, 1);

	vec3 rotated = rotate_around_axis(vector_to_rotate, rotate_around, d);

	return rotated;
}

vec2 sphere_to_uv(vec3 sphere_pos){
	//u = 0.5 + atan(z,x) / 2PI
	//v = 0.5 + asin(y)/PI
	float u = 0.5 + atan(sphere_pos.x, sphere_pos.z) / PI;
	float v = 0.5 + asin(sphere_pos.y) / PI;

	return vec2(u, v);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv_local = UV - vec2(0.5);
	uv_local = vec2(-uv_local.y, uv_local.x);
	if (length(uv_local) > 0.5){
		discard;
	}
	vec3 surface_location = circle_to_sphere(uv_local);
	surface_location = player_rot * world_rot  * surface_location;
	vec2 uv_sphere = sphere_to_uv(surface_location);
	uv_sphere -= vec2(0.5);
	
	uv_sphere *= size_inverse;
	if(uv_sphere.x < -0.5 || uv_sphere.x > 0.5 || uv_sphere.y < -0.5 || uv_sphere.y > 0.5){
		discard;
	}
	uv_sphere += vec2(0.5);
	
	

	COLOR = texture(tex, uv_sphere);
}
