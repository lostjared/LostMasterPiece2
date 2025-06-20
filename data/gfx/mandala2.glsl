#version 330 core
in vec2 tc;
out vec4 color;
uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;

vec3 hsv(float h,float s,float v){
    float c=v*s;
    float x=c*(1.0-abs(mod(h*6.0,2.0)-1.0));
    float m=v-c;
    vec3 rgb;
    if(h<1.0/6.0) rgb=vec3(c,x,0);
    else if(h<2.0/6.0) rgb=vec3(x,c,0);
    else if(h<3.0/6.0) rgb=vec3(0,c,x);
    else if(h<4.0/6.0) rgb=vec3(0,x,c);
    else if(h<5.0/6.0) rgb=vec3(x,0,c);
    else rgb=vec3(c,0,x);
    return rgb+m;
}

void main(){
    vec4 tex=texture(textTexture,tc);
    vec2 uv=(gl_FragCoord.xy-0.5*iResolution.xy)/iResolution.y;
    float r=length(uv);
    float a=atan(uv.y,uv.x);
    float PI=3.14159265359;
    float TWO_PI=6.28318530718;
    int segments=8;
    float sector=TWO_PI/float(segments);
    float afold=mod(a,sector);
    afold=abs(afold-sector*0.5);
    float petals=cos(afold*float(segments)+time_f);
    float rings=cos(r*20.0-time_f);
    float brightness=petals*rings*0.5+0.5;
    float hue=fract(a/TWO_PI+time_f*0.1+r*0.05);
    vec3 mandala=hsv(hue,1.0,brightness);
    vec3 combined=mix(tex.rgb,mandala,0.5);
    color=vec4(combined,tex.a);
}
