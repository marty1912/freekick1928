RSRC                    Shader            ��������                                                  resource_local_to_scene    resource_name    code    script           local://Shader_dmrta �          Shader          t  shader_type spatial;
render_mode skip_vertex_transform, cull_disabled;
render_mode vertex_lighting;
//render_mode depth_draw_opaque;

#include "res://addons/godot-polyliner/shaders/include/polyliner_inc.gdshaderinc"

uniform float line_width = 0.1;
uniform sampler2D width_curve : source_color;
uniform bool tangent_facing = false;
uniform bool rounded = false;

varying float is_end;
void vertex(){
	VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX,1.0)).xyz;
	NORMAL = mat3(MODELVIEW_MATRIX) * NORMAL;
	TANGENT = mat3(MODELVIEW_MATRIX) * TANGENT;
	
	quick_line(line_width,rounded);
	
	float line_length = UV2.x;
	UV.x = 1.0-UV.x;
	UV2 = UV;
	UV2.x *= line_length;
	
	if (rounded) {
		float uv_correct = is_end*line_width;
		UV.x += uv_correct;
		UV2.x += uv_correct;
	}
}

uniform sampler2D albedo_tex : source_color;
uniform bool tex_stretch = true;
uniform vec2 tex_scale = vec2(1.0,1.0);

uniform vec4 color : source_color = vec4(vec3(1.0),1.0);
uniform float metallic  : hint_range(0.0,1.0,0.005) = 0.0;
uniform float specular  : hint_range(0.0,1.0,0.005) = 0.5;
uniform float roughness : hint_range(0.0,1.0,0.005) = 0.5;

uniform bool tube_normal = true;
void fragment() {
	if (!FRONT_FACING) { NORMAL = -NORMAL; }
	
	if (tube_normal && !tangent_facing) { 
		NORMAL_MAP = getLineTubeNormal(UV,is_end,rounded);
	}
	
	if (rounded && abs(is_end) > 0.0001) {
		// pure heuristics
		float softner = magic_aa(6000.0,VERTEX,VIEWPORT_SIZE);
		softner *= (1.0/line_width) * (min(abs(is_end)*2.0,1.0));
		ALPHA *= smoothstep(1.0,1.0+softner,getDistToLineCenter(UV,is_end));
	}
	
	vec2 uv_alb = UV2;
	if (tex_stretch) {
		uv_alb = UV;
	}
	uv_alb *= tex_scale;
	
	vec4 alb_sample = texture(albedo_tex,uv_alb);
	
	ALBEDO = alb_sample.rgb * color.rgb;
	ALPHA = alb_sample.a * color.a;
	SPECULAR = specular;
	ROUGHNESS = roughness;
	METALLIC = metallic;
	ALPHA_SCISSOR_THRESHOLD = 0.001; // comment out for alpha blending
}       RSRC