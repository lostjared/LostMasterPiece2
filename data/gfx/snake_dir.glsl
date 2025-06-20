
#version 330 core
out vec4 color;
in vec2 tc;

uniform sampler2D textTexture;
uniform float time_f;
uniform vec2 iResolution;
uniform float alpha;

vec4 snake1() {
    vec2 uv = tc * iResolution;
    float wave = sin(uv.x * 0.05 + time_f * 2.0) * 0.05;
    vec2 shiftedUV = vec2(uv.x, uv.y + wave * iResolution.y);
    vec4 texColor = texture(textTexture, shiftedUV / iResolution);
    return texColor;
}

vec4 snake2() {
    vec2 uv = tc * iResolution;
    float wave = sin(uv.y * 0.05 + time_f * 2.0) * 0.05;
    vec2 shiftedUV = vec2(uv.x + wave * iResolution.x, uv.y);
    vec4 texColor = texture(textTexture, shiftedUV / iResolution);
    return texColor;
}

void main(void) {
    float time_t = mod(time_f, 10);
    color = sin(mix(snake1(), snake2(), 0.5) * (alpha * time_t));
    color.a = 1.0;
}
