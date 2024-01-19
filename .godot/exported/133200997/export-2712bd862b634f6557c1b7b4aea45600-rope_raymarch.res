RSRC                    Shader            ��������                                                  resource_local_to_scene    resource_name    code    script           local://Shader_gbvwk �          Shader          �  shader_type spatial;
render_mode unshaded;

mat3 rotation3dX(float angle) {
	float s = sin(angle);
	float c = cos(angle);

	return mat3(
		vec3(1.0, 0.0, 0.0),
		vec3(0.0, c, s),
		vec3(0.0, -s, c)
	);
}

mat3 rotate(vec3 axis, float angle) {
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;
	
	vec3 xxx = vec3(oc * axis.x * axis.x + c * s,
					oc * axis.x * axis.y - axis.z * s, 
					oc * axis.z * axis.x + axis.y * s);
	
	vec3 yyy = vec3(oc * axis.x * axis.y + axis.z * s, 
					oc * axis.y * axis.y + c * s,
					oc * axis.y * axis.z - axis.x * s);
	
	vec3 zzz = vec3(oc * axis.z * axis.x - axis.y * s, 
					oc * axis.y * axis.z + axis.x * s,
					oc * axis.z * axis.z + c * s);
	
	return mat3(xxx,yyy,zzz);
}

float sdCylinder( vec3 p, float c ){
	return length(p.yz)-c;
}


varying vec3 eye_dir;
void vertex(){
	vec3 world_cam = INV_VIEW_MATRIX[3].xyz;
	vec3 world_vertex = (MODEL_MATRIX * vec4(VERTEX,1.0)).xyz;
	
	BINORMAL = cross(TANGENT,NORMAL);
	mat3 TBN = mat3(
		TANGENT,
		BINORMAL,
		NORMAL
	);
	mat3 world_TBN = mat3(MODEL_MATRIX) * TBN;
	
	eye_dir = (world_vertex - world_cam) * world_TBN;
}

float scene(vec3 p){
//	p -= vec3(0.0,-0.3,0.0);
//	p = rotate(vec3(0.0,1.0,0.0),p.x*0.04) * p;
	p = p*rotation3dX(p.x*4.14);
	float o1 = sdCylinder(p - vec3(0.0,-0.2,0.0),0.2);
	float o2 = sdCylinder(p - vec3(0.0,0.1,0.2),0.2);
	float o3 = sdCylinder(p - vec3(0.0,0.1,-0.2),0.2);
	
	float rope = min(o1,min(o2,o3));
	
	return rope;
}

vec3 getNormal( in vec3 p )
{
    const float h = 0.0001; // replace by an appropriate value
    const vec2 k = vec2(1,-1);
    return normalize( k.xyy*scene( p + k.xyy*h ) + 
                      k.yyx*scene( p + k.yyx*h ) + 
                      k.yxy*scene( p + k.yxy*h ) + 
                      k.xxx*scene( p + k.xxx*h ) );
}

float raymarch(vec3 ro, vec3 rd){
	float total_dist = 0.0;
	
	for(int i=0;i < 40;i++){
		vec3 ray = ro + (rd * total_dist);
		
		float dist = scene(ray);
		
		if (dist < 0.005){
			return total_dist;
		}
		
		total_dist += dist;
	}
	
	return -1.0;
}

float fakeao(vec3 p,vec3 n){
	vec3 delta = n*0.05;
	float output = scene(p+delta);
	output += scene(p+delta*0.5)*1.2;
	output += scene(p+delta*1.0)*1.4;
	output += scene(p+delta*2.0)*1.8;
	return 1.0-(exp(output));
}
vec2 hash22(vec2 p)
{
	vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
	p3 += dot(p3, p3.yzx+33.33);
	return fract((p3.xx+p3.yz)*p3.zy);
}
float ao(vec3 p, vec3 n, vec2 fragcoord)
{
	vec3 t = normalize(cross(n,vec3(0.0,1.0,0.0)));
	vec3 b = normalize(cross(t,n));
	
	float inv_t = 1.0/15.0;
	
	float occ = 0.0;
	for (int i=0;i<10;i++)
	{
		vec2  aa = ( hash22(fragcoord+TIME*float(i+1)) );
		float ra = sqrt(aa.y);
		float rx = ra*cos(6.2831*aa.x); 
		float ry = ra*sin(6.2831*aa.x);
		float rz = sqrt( 1.0-aa.y );
		vec3  dir = vec3( rx*t + ry*b + rz*n );
		vec3 no;
		float hit = raymarch(p+dir*0.2,dir);
		if (hit < 0.0)
			occ += inv_t;
	}
	
	return occ;
}

void fragment(){
	vec3 ro = vec3(UV,0.0);
	ro += vec3(0.0,-0.5,0.5);
	vec3 rd = normalize(eye_dir);
	
	float hit = raymarch(ro, rd);
	
	vec3 hitpos = ro + rd * hit;
	
	vec3 normal = getNormal(hitpos);
	float ao = ao(hitpos,normal,FRAGCOORD.xy);
	
	if (hit < 0.0)	discard;
	ALBEDO = vec3(1.0,0.5,0.0) *  (ao);
}       RSRC