#version 330 core
in vec2 tc;
out vec4 color;
uniform sampler2D textTexture;
uniform float time_f;
uniform vec2 iResolution;

vec3 rgb2yuv(vec3 c){
    return vec3(
        dot(c, vec3(0.299, 0.587, 0.114)),
        dot(c, vec3(-0.147, -0.289, 0.436)),
        dot(c, vec3(0.615, -0.515, -0.100))
    );
}
vec3 yuv2rgb(vec3 yuv){
    return vec3(
        yuv.x + 1.140 * yuv.z,
        yuv.x - 0.395 * yuv.y - 0.581 * yuv.z,
        yuv.x + 2.032 * yuv.y
    );
}
float rand(vec2 n){
    return fract(sin(dot(n, vec2(12.9898,78.233))) * 43758.5453);
}
vec3 compositeEffect(vec2 uv){
    vec2 px = vec2(1.0/iResolution.x, 1.0/iResolution.y);
    float jitter = (rand(vec2(time_f*50.0, uv.y*200.0)) * 2.0 - 1.0) * px.x * 1.5;
    uv.x += jitter;

    vec3 c = texture(textTexture, uv).rgb;
    vec3 yuv = rgb2yuv(c);

    float carrier = sin((uv.x*iResolution.x + time_f*240.0) * 3.14159 * 2.0 / 4.0);
    yuv.yz *= 0.7;
    yuv.y += carrier * 0.03;
    yuv.z += carrier * 0.03;

    float bleed = (texture(textTexture, uv + vec2(px.x*2,0)).r + texture(textTexture, uv - vec2(px.x*2,0)).r) * 0.5;
    yuv.x = mix(yuv.x, bleed, 0.05);

    vec3 outc = yuv2rgb(yuv);
    outc *= 1.0 + sin(time_f*60.0) * 0.005;

    float scan = sin(uv.y * iResolution.y * 1.5) * 0.1;
    outc -= scan;

    outc += (rand(uv * iResolution.xy) * 0.2 - 0.1) * 0.02;

    return clamp(outc, 0.0, 1.0);
}

void main(){
    color = vec4(compositeEffect(tc), 1.0);
}
