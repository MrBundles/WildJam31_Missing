shader_type canvas_item;

uniform vec2 limit = vec2(0.0);
uniform bool h_orientation = false;
uniform bool greater_than = false;

void fragment(){
	vec2 uv_scaled = UV * vec2(textureSize(TEXTURE, 0));
	COLOR = texture(TEXTURE, UV);
	
	int perm = 0;
	
	if(h_orientation && greater_than && uv_scaled.x < limit.x){
		perm++;
	}else if(h_orientation && !greater_than && uv_scaled.x > limit.x){
		perm++;
	}else if(!h_orientation && greater_than && uv_scaled.y < limit.y){
		perm++;
	}else if(!h_orientation && !greater_than && uv_scaled.y > limit.y){
		perm++;
	}
	
	if(perm == 0){
		COLOR.a = texture(TEXTURE, UV).a;
	}
	else{
		COLOR.a = 0.0;
		}
}