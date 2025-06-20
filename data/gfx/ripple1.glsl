#version 330 core

in vec2 tc;
out vec4 color;

uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;

const float PI = 3.14159265359;

void main(void) {
    vec2 uv = tc * 2.0 - 1.0;
    uv.x += sin(time_f * 4.0) * 0.1;
    uv.y += cos(time_f * 3.0) * 0.1;
    color = texture(textTexture, uv);
}
