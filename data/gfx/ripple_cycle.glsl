#version 330
in vec2 tc;
out vec4 color;
uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;

void main(void) {
    vec2 normPos = gl_FragCoord.xy / iResolution.xy;
    float cycle = sin(time_f * 0.5);
    float movingPhase = normPos.x + cycle;
    float phase = sin(movingPhase * 10.0 - time_f * 2.0);
    vec2 tcAdjusted = tc + (vec2(phase, 0) * 0.302);
    color = texture(textTexture, tcAdjusted);
}
