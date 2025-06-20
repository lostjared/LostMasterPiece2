#version 330 core

out vec4 color;
in vec2 tc;

uniform sampler2D textTexture;
uniform float time_f;
uniform vec2 iResolution;

void main() {
    vec2 pos = tc;
    float time_t = mod(time_f, 3.0);
    pos.x = 1.0-tc.x;
    color = mix(texture(textTexture, tan(tc * time_t)), texture(textTexture, tan(pos * time_t)), 0.5);
}
