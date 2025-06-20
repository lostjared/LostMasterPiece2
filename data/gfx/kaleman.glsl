#version 330 core
in vec2 tc;
out vec4 color;
uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;
const float PI = 3.14159265;

void main(){
    vec2 uv = (gl_FragCoord.xy / iResolution.xy) * 2.0 - 1.0;
    uv.x *= iResolution.x / iResolution.y;
    float r = length(uv);
    float a = atan(uv.y, uv.x) + time_f * 0.3;
    float seg = 12.0;
    float da = PI * 2.0 / seg;
    a = mod(a, da);
    a = abs(a - da * 0.5);
    vec2 pola = vec2(cos(a), sin(a)) * r;
    vec2 coord = pola * 0.5 + 0.5;
    coord += 0.02 * vec2(sin(r * 15.0 - time_f), cos(r * 15.0 - time_f));
    coord = fract(coord);
    vec3 col = texture(textTexture, coord).rgb;
    float hue = fract(a / (PI * 2.0) + time_f * 0.15 + r * 0.25);
    float sat = 1.0;
    float val = r * 0.5 + 0.5;
    float c = val * sat;
    float x = c * (1.0 - abs(mod(hue * 6.0, 2.0) - 1.0));
    float m = val - c;
    vec3 rgb;
    if(hue < 1.0/6.0) rgb = vec3(c, x, 0);
    else if(hue < 2.0/6.0) rgb = vec3(x, c, 0);
    else if(hue < 3.0/6.0) rgb = vec3(0, c, x);
    else if(hue < 4.0/6.0) rgb = vec3(0, x, c);
    else if(hue < 5.0/6.0) rgb = vec3(x, 0, c);
    else rgb = vec3(c, 0, x);
    rgb += m;
    col = mix(col, rgb, 0.7);
    color = vec4(col, 1.0);
    color = mix(color, texture(textTexture, tc), 0.5);
}
