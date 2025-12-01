#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP number spin_time;
extern MY_HIGHP_OR_MEDIUMP vec4 colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 colour_2;
extern MY_HIGHP_OR_MEDIUMP vec4 colour_3;
extern MY_HIGHP_OR_MEDIUMP number contrast;
extern MY_HIGHP_OR_MEDIUMP number spin_amount;

#define PI 3.14159265359

MY_HIGHP_OR_MEDIUMP number t;

#define saturate(x) clamp(x, 0., 1.)

MY_HIGHP_OR_MEDIUMP number vmax(MY_HIGHP_OR_MEDIUMP vec3 v) {
	return max(max(v.x, v.y), v.z);
}

MY_HIGHP_OR_MEDIUMP number fBox(MY_HIGHP_OR_MEDIUMP vec3 p, MY_HIGHP_OR_MEDIUMP vec3 b) {
	MY_HIGHP_OR_MEDIUMP vec3 d = abs(p) - b;
	return length(max(d, vec3(0))) + vmax(min(d, vec3(0)));
}

MY_HIGHP_OR_MEDIUMP number fLineSegment(MY_HIGHP_OR_MEDIUMP vec3 p, MY_HIGHP_OR_MEDIUMP vec3 a, MY_HIGHP_OR_MEDIUMP vec3 b) {
	MY_HIGHP_OR_MEDIUMP vec3 ab = b - a;
	MY_HIGHP_OR_MEDIUMP number t = saturate(dot(p - a, ab) / dot(ab, ab));
	return length((ab*t + a) - p);
}

MY_HIGHP_OR_MEDIUMP number fCapsule(MY_HIGHP_OR_MEDIUMP vec3 p, MY_HIGHP_OR_MEDIUMP vec3 a, MY_HIGHP_OR_MEDIUMP vec3 b, MY_HIGHP_OR_MEDIUMP number r) {
	return fLineSegment(p, a, b) - r;
}

MY_HIGHP_OR_MEDIUMP number fPlane(MY_HIGHP_OR_MEDIUMP vec3 p, MY_HIGHP_OR_MEDIUMP vec3 n, MY_HIGHP_OR_MEDIUMP number distanceFromOrigin) {
    return dot(p, n) + distanceFromOrigin;
}

MY_HIGHP_OR_MEDIUMP number fPlane(MY_HIGHP_OR_MEDIUMP vec3 p, MY_HIGHP_OR_MEDIUMP vec3 a, MY_HIGHP_OR_MEDIUMP vec3 b, MY_HIGHP_OR_MEDIUMP vec3 c, MY_HIGHP_OR_MEDIUMP vec3 inside, MY_HIGHP_OR_MEDIUMP number distanceFromOrigin) {
    MY_HIGHP_OR_MEDIUMP vec3 n = normalize(cross(c - b, a - b));
    MY_HIGHP_OR_MEDIUMP number d = -dot(a, n);
    
    if (dot(n, inside) + d > 0.) {
        n = -n;
        d = -d;
    }

    return fPlane(p, n, d + distanceFromOrigin);
}

MY_HIGHP_OR_MEDIUMP number fOpIntersectionRound(MY_HIGHP_OR_MEDIUMP number a, MY_HIGHP_OR_MEDIUMP number b, MY_HIGHP_OR_MEDIUMP number r) {
	MY_HIGHP_OR_MEDIUMP number m = max(a, b);
	if ((-a < r) && (-b < r)) {
		return max(m, -(r - sqrt((r+a)*(r+a) + (r+b)*(r+b))));
	} else {
		return m;
	}
}

MY_HIGHP_OR_MEDIUMP number fCone(MY_HIGHP_OR_MEDIUMP vec3 p, MY_HIGHP_OR_MEDIUMP number radius, MY_HIGHP_OR_MEDIUMP number height) {
	MY_HIGHP_OR_MEDIUMP vec2 q = vec2(length(p.xz), p.y);
	MY_HIGHP_OR_MEDIUMP vec2 tip = q - vec2(0, height);
	MY_HIGHP_OR_MEDIUMP vec2 mantleDir = normalize(vec2(height, radius));
	MY_HIGHP_OR_MEDIUMP number mantle = dot(tip, mantleDir);
	MY_HIGHP_OR_MEDIUMP number d = max(mantle, -q.y);
	MY_HIGHP_OR_MEDIUMP number projected = dot(tip, vec2(mantleDir.y, -mantleDir.x));
	
	if ((q.y > height) && (projected < 0.)) {
		d = max(d, length(tip));
	}
	
	if ((q.x > radius) && (projected > length(vec2(height, radius)))) {
		d = max(d, length(q - vec2(radius, 0)));
	}
	return d;
}

void pR(inout MY_HIGHP_OR_MEDIUMP vec2 p, MY_HIGHP_OR_MEDIUMP number a) {
    p = cos(a)*p + sin(a)*vec2(p.y, -p.x);
}

MY_HIGHP_OR_MEDIUMP number pReflect(inout MY_HIGHP_OR_MEDIUMP vec3 p, MY_HIGHP_OR_MEDIUMP vec3 planeNormal, MY_HIGHP_OR_MEDIUMP number offset) {
    MY_HIGHP_OR_MEDIUMP number t = dot(p, planeNormal)+offset;
    if (t < 0.) {
        p = p - (2.*t)*planeNormal;
    }
    return sign(t);
}

MY_HIGHP_OR_MEDIUMP number fOpUnionRound(MY_HIGHP_OR_MEDIUMP number a, MY_HIGHP_OR_MEDIUMP number b, MY_HIGHP_OR_MEDIUMP number r) {
	MY_HIGHP_OR_MEDIUMP number m = min(a, b);
	if ((a < r) && (b < r) ) {
		return min(m, r - sqrt((r-a)*(r-a) + (r-b)*(r-b)));
	} else {
	 return m;
	}
}

MY_HIGHP_OR_MEDIUMP vec3 bToC(MY_HIGHP_OR_MEDIUMP vec3 A, MY_HIGHP_OR_MEDIUMP vec3 B, MY_HIGHP_OR_MEDIUMP vec3 C, MY_HIGHP_OR_MEDIUMP vec3 barycentric) {
	return barycentric.x * A + barycentric.y * B + barycentric.z * C;
}

int Type=5;

MY_HIGHP_OR_MEDIUMP vec3 nc,pab,pbc,pca;
MY_HIGHP_OR_MEDIUMP vec3 icoF0;
MY_HIGHP_OR_MEDIUMP vec3 icoF1a;
MY_HIGHP_OR_MEDIUMP vec3 icoA0;
MY_HIGHP_OR_MEDIUMP vec3 icoB0;
MY_HIGHP_OR_MEDIUMP vec3 icoC0;
MY_HIGHP_OR_MEDIUMP vec3 icoA1;
MY_HIGHP_OR_MEDIUMP vec3 icoB1;
MY_HIGHP_OR_MEDIUMP vec3 icoC1;
MY_HIGHP_OR_MEDIUMP vec3 fold1;
MY_HIGHP_OR_MEDIUMP vec3 fold2;
MY_HIGHP_OR_MEDIUMP vec3 fold3;

void initIcosahedron() {
    MY_HIGHP_OR_MEDIUMP number cospin=cos(PI/number(Type)), scospin=sqrt(0.75-cospin*cospin);
    nc=vec3(-0.5,-cospin,scospin);
	pab=vec3(0.,0.,1.);
	pbc=vec3(scospin,0.,0.5);
	pca=vec3(0.,scospin,cospin);
	pbc=normalize(pbc);	pca=normalize(pca);

    MY_HIGHP_OR_MEDIUMP vec3 A = pbc;
    MY_HIGHP_OR_MEDIUMP vec3 C = reflect(A, normalize(cross(pab, pca)));
    MY_HIGHP_OR_MEDIUMP vec3 B = reflect(C, normalize(cross(pbc, pca)));
    
    icoF0 = pca;
    
	icoA0 = A;
	icoC0 = B;
	icoB0 = C;

    MY_HIGHP_OR_MEDIUMP vec3 p1 = bToC(A, B, C, vec3(.5, .0, .5));
    MY_HIGHP_OR_MEDIUMP vec3 p2 = bToC(A, B, C, vec3(.5, .5, .0));
    fold1 = normalize(cross(p1, p2));
    MY_HIGHP_OR_MEDIUMP vec3 A2 = reflect(A, fold1);
    MY_HIGHP_OR_MEDIUMP vec3 B2 = p1;
    MY_HIGHP_OR_MEDIUMP vec3 C2 = p2;
    
    icoF1a = pca;
    
    icoA1 = A2;
    icoB1 = normalize(B2);
    icoC1 = normalize(C2);
    p1 = bToC(A2, B2, C2, vec3(.5, .0, .5));
    p2 = bToC(A2, B2, C2, vec3(.5, .5, .0));
    fold2 = normalize(cross(p1, p2));
    p1 = bToC(A2, B2, C2, vec3(.0, .5, .5));
    fold3 = normalize(cross(p2, p1));
}

MY_HIGHP_OR_MEDIUMP number pModIcosahedron(inout MY_HIGHP_OR_MEDIUMP vec3 p, int subdivisions) {
    p = abs(p);
	pReflect(p, nc, 0.);
    p.xy = abs(p.xy);
	pReflect(p, nc, 0.);
    p.xy = abs(p.xy);
	pReflect(p, nc, 0.);
    
    MY_HIGHP_OR_MEDIUMP number i = 0.;
    if (subdivisions > 0) {
        i += pReflect(p, fold1, 0.) / 2. + .5;
        if (subdivisions > 1) {
            pReflect(p, fold2, 0.);
            pReflect(p, fold3, 0.);
        }
    }

    return i;
}

MY_HIGHP_OR_MEDIUMP mat3 rotationMatrix(MY_HIGHP_OR_MEDIUMP vec3 axis, MY_HIGHP_OR_MEDIUMP number angle)
{
    axis = normalize(axis);
    MY_HIGHP_OR_MEDIUMP number s = sin(angle);
    MY_HIGHP_OR_MEDIUMP number c = cos(angle);
    MY_HIGHP_OR_MEDIUMP number oc = 1.0 - c;
    
    return mat3(
        oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
        oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
       
	 oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
    );
}

MY_HIGHP_OR_MEDIUMP vec3 pRoll(inout MY_HIGHP_OR_MEDIUMP vec3 p) {
    pR(p.yx, PI/3.);
    pR(p.yz, PI/-5.);
    
    MY_HIGHP_OR_MEDIUMP number angle = (t * ((PI*2.)/3.)) + (spin_time * 5.0 * spin_amount);
    MY_HIGHP_OR_MEDIUMP mat3 m = rotationMatrix(normalize(icoF1a), angle);
    p *= m;
    return p;
}

MY_HIGHP_OR_MEDIUMP number fCone(MY_HIGHP_OR_MEDIUMP vec3 p, MY_HIGHP_OR_MEDIUMP number radius, MY_HIGHP_OR_MEDIUMP number height, MY_HIGHP_OR_MEDIUMP vec3 direction) {
    p = reflect(p, normalize(mix(vec3(0,1,0), -direction, .5)));
    return fCone(p, radius, height);
}

MY_HIGHP_OR_MEDIUMP number fHolePart(
    MY_HIGHP_OR_MEDIUMP vec3 p,
    MY_HIGHP_OR_MEDIUMP vec3 a,
    MY_HIGHP_OR_MEDIUMP vec3 b,
    MY_HIGHP_OR_MEDIUMP vec3 c,
    MY_HIGHP_OR_MEDIUMP vec3 d,
    MY_HIGHP_OR_MEDIUMP number round,
    MY_HIGHP_OR_MEDIUMP number thick
) {
    MY_HIGHP_OR_MEDIUMP vec3 center = (a + b + c + d) / 4.;
    MY_HIGHP_OR_MEDIUMP number f0 = fPlane(p, a, b, c, center, thick);
    MY_HIGHP_OR_MEDIUMP number f1 = fPlane(p, a, c, d, center, thick);
    MY_HIGHP_OR_MEDIUMP number f = f0;
   	f = fOpIntersectionRound(f, f1, round);
   	return f;
}
    
MY_HIGHP_OR_MEDIUMP number fHole(
    MY_HIGHP_OR_MEDIUMP vec3 p,
    MY_HIGHP_OR_MEDIUMP vec3 a,
    MY_HIGHP_OR_MEDIUMP vec3 b,
    MY_HIGHP_OR_MEDIUMP vec3 c
) {
    MY_HIGHP_OR_MEDIUMP number w = 1.;
    MY_HIGHP_OR_MEDIUMP number h = 1.;
    MY_HIGHP_OR_MEDIUMP number round = .08;
    MY_HIGHP_OR_MEDIUMP number thick = .02;

	MY_HIGHP_OR_MEDIUMP number d = 1000.;
	MY_HIGHP_OR_MEDIUMP vec3 AB = mix(a, b, 0.5);
    MY_HIGHP_OR_MEDIUMP vec3 AAB = mix(a, b, w);
    MY_HIGHP_OR_MEDIUMP vec3 ABB = mix(a, b, 1. - w);
	MY_HIGHP_OR_MEDIUMP vec3 n = normalize(cross(a, b));
    MY_HIGHP_OR_MEDIUMP vec3 cn = dot(c, n) * n;
	MY_HIGHP_OR_MEDIUMP vec3 AF = c - cn * (1. - h);
    MY_HIGHP_OR_MEDIUMP vec3 AF2 = reflect(AF, n);
	MY_HIGHP_OR_MEDIUMP number part1 = fHolePart(p, vec3(0), AF2, AAB, AF, round, thick);
	MY_HIGHP_OR_MEDIUMP number part2 = fHolePart(p, vec3(0), AF2, ABB, AF, round, thick);
	MY_HIGHP_OR_MEDIUMP number hole = fOpIntersectionRound(part1, part2, round);
    return hole;
}

MY_HIGHP_OR_MEDIUMP number holes(MY_HIGHP_OR_MEDIUMP vec3 p, MY_HIGHP_OR_MEDIUMP number i) {
    MY_HIGHP_OR_MEDIUMP number d = 1000.;
    if (i > 0.) {  
        return min(d, fHole(p, icoC1, icoB1, icoF1a));
    }
    
    d = min(d, fHole(p, icoC1, icoB1, icoF1a));
    d = min(d, fHole(p, icoA1, icoB1, icoF1a));
    return d;
}

MY_HIGHP_OR_MEDIUMP number spikes(MY_HIGHP_OR_MEDIUMP vec3 p) {
    MY_HIGHP_OR_MEDIUMP number d = 1000.;
    d = min(d, fCone(p, .05, 1.3, icoF1a));
    d = min(d, fCone(p, .05, 1.7, icoA1));
    d = min(d, fCone(p, .05, 1.8, icoB1));
    return d;
}

MY_HIGHP_OR_MEDIUMP number shell(MY_HIGHP_OR_MEDIUMP vec3 p, MY_HIGHP_OR_MEDIUMP number i) {

    MY_HIGHP_OR_MEDIUMP number thick = .03;
    MY_HIGHP_OR_MEDIUMP number round = .015;

    MY_HIGHP_OR_MEDIUMP number d = length(p) - 1.;
    d = fOpUnionRound(d, spikes(p), .12);
	d = max(d, -(length(p) - (1. - thick)));
	MY_HIGHP_OR_MEDIUMP number h = holes(p, i);
    h = max(h, (length(p) - 1.1));
    d = fOpIntersectionRound(d, -h, round);
    return d;
}

MY_HIGHP_OR_MEDIUMP number model(MY_HIGHP_OR_MEDIUMP vec3 p) {
    pRoll(p);

    MY_HIGHP_OR_MEDIUMP number d = 1000.;
    MY_HIGHP_OR_MEDIUMP number i = 0.;
 
    i = pModIcosahedron(p, 1);
	d = min(d, shell(p, i)); 
    return d;
}

const MY_HIGHP_OR_MEDIUMP number MAX_TRACE_DISTANCE = 10.0;
const MY_HIGHP_OR_MEDIUMP number INTERSECTION_PRECISION = 0.001;
const int NUM_OF_TRACE_STEPS = 100;

MY_HIGHP_OR_MEDIUMP vec2 opU( MY_HIGHP_OR_MEDIUMP vec2 d1, MY_HIGHP_OR_MEDIUMP vec2 d2 ){
    
    return (d1.x<d2.x) ?
	d1 : d2;
    
}

MY_HIGHP_OR_MEDIUMP vec2 map( MY_HIGHP_OR_MEDIUMP vec3 p ){  
    
    MY_HIGHP_OR_MEDIUMP vec2 res = vec2(model(p) ,1.);
    return res;
}

MY_HIGHP_OR_MEDIUMP number softshadow( in MY_HIGHP_OR_MEDIUMP vec3 ro, in MY_HIGHP_OR_MEDIUMP vec3 rd, in MY_HIGHP_OR_MEDIUMP number mint, in MY_HIGHP_OR_MEDIUMP number tmax )
{
    MY_HIGHP_OR_MEDIUMP number res = 1.0;
    MY_HIGHP_OR_MEDIUMP number t = mint;
    for( int i=0; i<16; i++ )
    {
        MY_HIGHP_OR_MEDIUMP number h = map( ro + rd*t ).x;
		res = min( res, 8.0*h/t );
        t += clamp( h, 0.02, 0.10 );
        if( h<0.001 || t>tmax ) break;
	}
    return clamp( res, 0.0, 1.0 );
}

MY_HIGHP_OR_MEDIUMP number calcAO( in MY_HIGHP_OR_MEDIUMP vec3 pos, in MY_HIGHP_OR_MEDIUMP vec3 nor )
{
    MY_HIGHP_OR_MEDIUMP number occ = 0.0;
    MY_HIGHP_OR_MEDIUMP number sca = 1.0;
	for( int i=0; i<5; i++ )
    {
        MY_HIGHP_OR_MEDIUMP number hr = 0.01 + 0.12*number(i)/4.0;
		MY_HIGHP_OR_MEDIUMP vec3 aopos =  nor * hr + pos;
        MY_HIGHP_OR_MEDIUMP number dd = map( aopos ).x;
        occ += -(dd-hr)*sca;
		sca *= 0.95;
    }
    return clamp( 1.0 - 3.0*occ, 0.0, 1.0 );    
}

const MY_HIGHP_OR_MEDIUMP number GAMMA = 2.2;
MY_HIGHP_OR_MEDIUMP vec3 gamma(MY_HIGHP_OR_MEDIUMP vec3 color, MY_HIGHP_OR_MEDIUMP number g)
{
    return pow(color, vec3(g));
}

MY_HIGHP_OR_MEDIUMP vec3 linearToScreen(MY_HIGHP_OR_MEDIUMP vec3 linearRGB)
{
    return gamma(linearRGB, 1.0 / GAMMA);
}

MY_HIGHP_OR_MEDIUMP vec3 doLighting(MY_HIGHP_OR_MEDIUMP vec3 col, MY_HIGHP_OR_MEDIUMP vec3 pos, MY_HIGHP_OR_MEDIUMP vec3 nor, MY_HIGHP_OR_MEDIUMP vec3 ref, MY_HIGHP_OR_MEDIUMP vec3 rd) {

    MY_HIGHP_OR_MEDIUMP number occ = calcAO( pos, nor );
	MY_HIGHP_OR_MEDIUMP vec3  lig = normalize( vec3(-0.6, 0.7, 0.5) );
    MY_HIGHP_OR_MEDIUMP number amb = clamp( 0.5+0.5*nor.y, 0.0, 1.0 );
	MY_HIGHP_OR_MEDIUMP number dif = clamp( dot( nor, lig ), 0.0, 1.0 );
	MY_HIGHP_OR_MEDIUMP number bac = clamp( dot( nor, normalize(vec3(-lig.x,0.0,-lig.z))), 0.0, 1.0 )*clamp( 1.0-pos.y,0.0,1.0);
	MY_HIGHP_OR_MEDIUMP number fre = pow( clamp(1.0+dot(nor,rd),0.0,1.0), 2.0 );
    
	dif *= softshadow( pos, lig, 0.02, 2.5 ) * (0.5 + contrast);

    MY_HIGHP_OR_MEDIUMP vec3 lin = vec3(0.0);
	lin += 1.20 * dif * colour_1.rgb;
    lin += 0.80 * amb * colour_2.rgb * occ;
    lin += 0.30 * bac * colour_3.rgb * occ;
    lin += 0.20 * fre * vec3(1.00,1.00,1.00) * occ;
	col = col * lin;

    return col;
}

MY_HIGHP_OR_MEDIUMP vec2 calcIntersection( in MY_HIGHP_OR_MEDIUMP vec3 ro, in MY_HIGHP_OR_MEDIUMP vec3 rd ){
    
    MY_HIGHP_OR_MEDIUMP number h =  INTERSECTION_PRECISION*2.0;
    MY_HIGHP_OR_MEDIUMP number t = 0.0;
    MY_HIGHP_OR_MEDIUMP number res = -1.0;
    MY_HIGHP_OR_MEDIUMP number id = -1.;
	for( int i=0; i< NUM_OF_TRACE_STEPS ; i++ ){
        
        if( h < INTERSECTION_PRECISION || t > MAX_TRACE_DISTANCE ) break;
		MY_HIGHP_OR_MEDIUMP vec2 m = map( ro+rd*t );
        h = m.x;
        t += h;
        id = m.y;
	}

    if( t < MAX_TRACE_DISTANCE ) res = t;
    if( t > MAX_TRACE_DISTANCE ) id =-1.0;
	return vec2( res , id );
    
}

MY_HIGHP_OR_MEDIUMP mat3 calcLookAtMatrix( in MY_HIGHP_OR_MEDIUMP vec3 ro, in MY_HIGHP_OR_MEDIUMP vec3 ta, in MY_HIGHP_OR_MEDIUMP number roll )
{
    MY_HIGHP_OR_MEDIUMP vec3 ww = normalize( ta - ro );
	MY_HIGHP_OR_MEDIUMP vec3 uu = normalize( cross(ww,vec3(sin(roll),cos(roll),0.0) ) );
    MY_HIGHP_OR_MEDIUMP vec3 vv = normalize( cross(uu,ww));
    return mat3( uu, vv, ww );
}

void doCamera(out MY_HIGHP_OR_MEDIUMP vec3 camPos, out MY_HIGHP_OR_MEDIUMP vec3 camTar, in MY_HIGHP_OR_MEDIUMP number time) {
    MY_HIGHP_OR_MEDIUMP vec3 orient = normalize(vec3(.1, 1, 0.));
    MY_HIGHP_OR_MEDIUMP number zoom = 4.;
    camPos = zoom * orient;
    camTar = vec3(0);
}

MY_HIGHP_OR_MEDIUMP vec3 calcNormal( in MY_HIGHP_OR_MEDIUMP vec3 pos ){
    
    MY_HIGHP_OR_MEDIUMP vec3 eps = vec3( 0.001, 0.0, 0.0 );
	MY_HIGHP_OR_MEDIUMP vec3 nor = vec3(
        map(pos+eps.xyy).x - map(pos-eps.xyy).x,
        map(pos+eps.yxy).x - map(pos-eps.yxy).x,
        map(pos+eps.yyx).x - map(pos-eps.yyx).x );
	return normalize(nor);
}


#define PIXEL_SIZE_FAC 700.
#define SPIN_EASE 0.5

vec4 background_fs_effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    MY_HIGHP_OR_MEDIUMP number pixel_size = length(love_ScreenSize.xy)/PIXEL_SIZE_FAC;
    MY_HIGHP_OR_MEDIUMP vec2 uv = (floor(screen_coords.xy*(1./pixel_size))*pixel_size - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy) - vec2(0.12, 0.);
    MY_HIGHP_OR_MEDIUMP number uv_len = length(uv);
    MY_HIGHP_OR_MEDIUMP number speed = (spin_time*SPIN_EASE*0.2) + 302.2;
    MY_HIGHP_OR_MEDIUMP number new_pixel_angle = (atan(uv.y, uv.x)) + speed - SPIN_EASE*20.*(1.*spin_amount*uv_len + (1. - 1.*spin_amount));
    MY_HIGHP_OR_MEDIUMP vec2 mid = (love_ScreenSize.xy/length(love_ScreenSize.xy))/2.;
    uv = (vec2((uv_len * cos(new_pixel_angle) + mid.x), (uv_len * sin(new_pixel_angle) + mid.y)) - mid);
    uv *= 30.;
    speed = time*(2.);
    MY_HIGHP_OR_MEDIUMP vec2 uv2 = vec2(uv.x+uv.y);

    for(int i=0; i < 5; i++) {
		uv2 += sin(max(uv.x, uv.y)) + uv;
		uv  += 0.5*vec2(cos(5.1123314 + 0.353*uv2.y + speed*0.131121),sin(uv2.x - 0.113*speed));
		uv  -= 1.0*cos(uv.x + uv.y) - 1.0*sin(uv.x*0.711 - uv.y);
	}

    MY_HIGHP_OR_MEDIUMP number contrast_mod = (0.25*contrast + 0.5*spin_amount + 1.2);
    MY_HIGHP_OR_MEDIUMP number paint_res =min(2., max(0.,length(uv)*(0.035)*contrast_mod));
    MY_HIGHP_OR_MEDIUMP number c1p = max(0.,1. - contrast_mod*abs(1.-paint_res));
    MY_HIGHP_OR_MEDIUMP number c2p = max(0.,1. - contrast_mod*abs(paint_res));
    MY_HIGHP_OR_MEDIUMP number c3p = 1. - min(1., c1p + c2p);
    MY_HIGHP_OR_MEDIUMP vec4 ret_col = (0.3/contrast)*colour_1 + (1. - 0.3/contrast)*(colour_1*c1p + colour_2*c2p + vec4(c3p*colour_3.rgb, c3p*colour_1.a));

    return ret_col;
}


vec4 render_combined( MY_HIGHP_OR_MEDIUMP vec2 res , MY_HIGHP_OR_MEDIUMP vec3 ro , MY_HIGHP_OR_MEDIUMP vec3 rd, vec4 original_colour, Image texture, vec2 texture_coords, vec2 screen_coords ){

  if( res.y > -.5 ){
    MY_HIGHP_OR_MEDIUMP vec3 pos = ro + rd * res.x;
	MY_HIGHP_OR_MEDIUMP vec3 norm = calcNormal( pos );
    MY_HIGHP_OR_MEDIUMP vec3 ref = reflect(rd, norm);
      
	MY_HIGHP_OR_MEDIUMP vec3 color = doLighting(colour_1.rgb, pos, norm, ref, rd);
    color = linearToScreen(color);
    return vec4(color,1.0);
  } else {
    return background_fs_effect(original_colour, texture, texture_coords, screen_coords);
  }
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    t = time;
    t = mod(t/4., 1.);   

    initIcosahedron();

    MY_HIGHP_OR_MEDIUMP vec2 fragCoord = vec2(screen_coords.x, love_ScreenSize.y - screen_coords.y);
    MY_HIGHP_OR_MEDIUMP vec2 p = (-love_ScreenSize.xy + 2.0*fragCoord.xy)/love_ScreenSize.y;

    MY_HIGHP_OR_MEDIUMP vec3 ro = vec3( 0., 0., 2.);
    MY_HIGHP_OR_MEDIUMP vec3 ta = vec3( 0. , 0. , 0. );
    
    doCamera(ro, ta, time);
    
    MY_HIGHP_OR_MEDIUMP mat3 camMat = calcLookAtMatrix( ro, ta, 0.0 );
    
    MY_HIGHP_OR_MEDIUMP vec3 rd = normalize( camMat * vec3(p.xy,2.0) );
    
    MY_HIGHP_OR_MEDIUMP vec2 res = calcIntersection( ro , rd  );
    
    return render_combined( res , ro , rd, colour, texture, texture_coords, screen_coords );
}