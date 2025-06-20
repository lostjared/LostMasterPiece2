#version 330

in vec2 tc;
out vec4 color;
uniform float time_f;
uniform sampler2D textTexture;
uniform sampler2D mat_textTexture;
uniform vec2 iResolution;

void main(void) {
    vec2 normPos = (gl_FragCoord.xy / iResolution.xy) * 2.0 - 1.0;
    float dist = length(normPos);
    float phase = sin(dist * 10.0 - time_f * 4.0);
    vec2 tcAdjusted = tc + (normPos * 0.305 * phase);
    vec4 color_textTexture = texture(textTexture, tcAdjusted);
    vec4 color_mat_textTexture = texture(mat_textTexture, tcAdjusted);
    color = mix(color_textTexture, color_mat_textTexture, 0.5);
}