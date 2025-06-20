#version 330

in vec2 tc;
out vec4 color;
uniform sampler2D textTexture;
uniform sampler2D mat_textTexture;
uniform float time_f;

void main(void) {
    vec2 wave_tc = tc + vec2(sin(tc.y * 10.0 + time_f), cos(tc.x * 10.0 + time_f)) * 0.05;
    vec4 color_textTexture = texture(textTexture, wave_tc);
    vec4 color_mat_textTexture = texture(mat_textTexture, wave_tc);
    
    vec4 texture_color = mix(color_textTexture, color_mat_textTexture, 0.5);
    
    color = texture_color;
}
