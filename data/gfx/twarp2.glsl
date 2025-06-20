#version 330 core
out vec4 color;
in vec2 tc;

uniform sampler2D textTexture;
uniform float time_f;
uniform vec2 iResolution;

void main(void) {
    vec2 uv = tc;
    float warpX = tan(uv.y * 10.0 + time_f) * 0.1;
    float warpY = tan(uv.x * 10.0 + time_f) * 0.1;
    uv.x += warpX;
    uv.y += warpY;
    color = texture(textTexture, sin(uv * time_f));
}

