#version 330 core
out vec4 color;
in vec2 tc;
uniform sampler2D textTexture;
uniform vec2 iResolution;
uniform float time_f;
uniform float value_alpha_r, value_alpha_g, value_alpha_b;

void main(void) {
    vec2 pos = tc;
    float time_t = mod(time_f, 10.0);
    pos = pos+sin(value_alpha_r * time_t);
    color = texture(textTexture, pos);
}
