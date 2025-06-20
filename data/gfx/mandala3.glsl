#version 330 core
in vec2 tc;
out vec4 color;
uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;

const float PI = 3.14159265359;

mat2 rot(float a) {
    float s = sin(a);
    float c = cos(a);
    return mat2(c, -s, s, c);
}

void main() {
    vec2 uv = tc * 2.0 - 1.0;
    uv.x *= iResolution.x / iResolution.y;

    float radius = length(uv);
    float angle = atan(uv.y, uv.x);

    float swirl = sin(time_f * 2.0) * (1.0 - radius);
    angle += swirl;

    float sides = 12.0;
    float segment = PI * 2.0 / sides;
    angle = mod(angle, segment);
    angle = abs(angle - segment * 0.5);

    vec2 p = vec2(cos(angle), sin(angle)) * radius;
    p = rot(time_f * 0.1) * p;

    vec2 textTextureleUV = p * 0.5 + 0.5;
    textTextureleUV = fract(textTextureleUV * 2.0);

    color = texture(textTexture, textTextureleUV);
}
