#version 330 core
out vec4 color;
in vec2 tc;

uniform sampler2D textTexture;
uniform float time_f;
uniform vec2 iResolution;

void main(void) {
    vec2 center = vec2(0.5, 0.5);
    vec2 dir = tc - center;
    float factor = 0.5;
    dir.x *= factor;
    vec2 new_tc = center + dir;
    color = texture(textTexture, new_tc);
}

