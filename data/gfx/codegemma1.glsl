#version 330 core
in vec2 tc;
out vec4 color;
uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;
uniform vec4 iMouse;

float hash(vec2 p){
    return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);
}
float noise(vec2 p){
    vec2 i=floor(p), f=fract(p);
    float a=hash(i), b=hash(i+vec2(1,0));
    float c=hash(i+vec2(0,1)), d=hash(i+vec2(1,1));
    vec2 u=f*f*(3.0-2.0*f);
    return mix(a,b,u.x)+(c-a)*u.y*(1.0-u.x)+(d-b)*u.x*u.y;
}
float fbm(vec2 p){
    float v=0.0, a=0.5;
    for(int i=0;i<6;i++){
        v+=a*noise(p);
        p*=2.0;
        a*=0.5;
    }
    return v;
}
vec2 rotate2d(vec2 p,float a){
    float s=sin(a), c=cos(a);
    return vec2(p.x*c - p.y*s, p.x*s + p.y*c);
}
vec2 swirl(vec2 uv,vec2 ctr,float s1,float s2,float d1,float d2){
    vec2 p=uv-ctr;
    p.x*=iResolution.x/iResolution.y;
    float r=length(p);
    float a=atan(p.y,p.x);
    a+=sin(r*s1 - time_f*d1)*1.2 + sin(r*s2 + time_f*d2)*0.8;
    float seg=12.0;
    float sec=6.2831853/seg;
    a=mod(a+sec*0.5,sec)-sec*0.5;
    vec2 w=vec2(cos(a),sin(a))*r;
    w.x/=iResolution.x/iResolution.y;
    return w+ctr;
}
vec2 kaleido(vec2 uv,vec2 ctr,float seg){
    vec2 p=uv-ctr;
    p.x*=iResolution.x/iResolution.y;
    float a=atan(p.y,p.x);
    float r=length(p);
    float s=6.2831853/seg;
    a=mod(a,s);
    a=abs(a-s*0.5);
    vec2 w=vec2(cos(a),sin(a))*r;
    w.x/=iResolution.x/iResolution.y;
    return w+ctr;
}
vec2 lens(vec2 uv){
    vec2 p=uv*2.0-1.0;
    float k1=0.3+0.2*sin(time_f*0.6);
    float k2=-0.2+0.2*cos(time_f*0.4);
    float r2=dot(p,p);
    p*=(1.0+k1*r2+k2*r2*r2);
    return p*0.5+0.5;
}
vec4 radialBlur(vec2 uv,int textTextureles){
    vec4 sum=vec4(0.0);
    vec2 dir=uv-vec2(0.5);
    for(int i=0;i<textTextureles;i++){
        float t=float(i)/float(textTextureles-1);
        sum+=texture(textTexture,uv-dir*t*0.3);
    }
    return sum/float(textTextureles);
}
float vignette(vec2 uv){
    vec2 d=uv-vec2(0.5);
    return smoothstep(0.9,0.4,length(d));
}
vec3 cloudLayer(vec2 uv){
    float c=fbm(uv*2.5 - time_f*0.2)*0.5 + 0.5;
    return vec3(c*0.8,c*0.9,c*1.0);
}
vec3 cosmicRays(vec2 uv,vec2 ctr){
    vec2 dir=normalize(ctr-uv);
    float cr=0.0;
    for(int i=0;i<8;i++){
        float t=float(i)/7.0;
        vec2 p=uv+dir*t*3.0;
        cr+=exp(-t*5.0)*fbm(p*4.0 + time_f*0.7);
    }
    return vec3(cr);
}
vec3 rainbow(float t){
    return 0.5 + 0.5*cos(vec3(0.0,2.0,4.0) + t);
}
void main(){
    vec2 uv=tc;
    vec2 ctr=(iMouse.z>0.0?iMouse.xy/iResolution:vec2(0.5));
    vec2 s1=swirl(uv,ctr,30.0,15.0,2.5,3.5);
    vec2 k1=kaleido(s1,ctr,16.0);
    vec2 l1=lens(k1);
    vec2 s2=swirl(l1,ctr+vec2(0.1),20.0,10.0,3.0,4.2);
    vec2 k2=kaleido(s2,ctr-vec2(0.1),20.0);
    vec2 l2=lens(k2);
    vec2 nOff=rotate2d(l2+vec2(noise(l2*10.0+time_f)*0.02),time_f*0.3);
    vec2 finalUV=mix(nOff,uv,0.02);
    vec4 orig=texture(textTexture,uv);
    vec4 warpTex=texture(textTexture,finalUV);
    vec4 blur=radialBlur(finalUV,10);
    vec3 clouds=cloudLayer(uv*1.8);
    vec3 rays=cosmicRays(uv,ctr)*0.8;
    vec3 grad=rainbow(time_f*4.0 + length(uv-ctr)*6.0);
    vec3 mix1=mix(warpTex.rgb,blur.rgb,0.6);
    vec3 mix2=mix(mix1,clouds,0.5);
    vec3 mix3=mix(mix2,rays,0.7);
    float b=pow(smoothstep(0.0,1.0,length(uv-ctr)),0.5);
    vec3 finalCol=mix(orig.rgb,mix3+grad*0.4,b);
    color=vec4(finalCol,1.0);
}
