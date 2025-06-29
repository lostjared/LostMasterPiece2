#version 330
in vec2 tc;
out vec4 color;
uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;

float pingPong(float x, float length) {
    float modVal = mod(x, length * 2.0);
    return modVal <= length ? modVal : length * 2.0 - modVal;
}

void main(void) {
    vec2 normPos = gl_FragCoord.xy / iResolution.xy;
    vec2 mirroredPos = vec2(
        abs(fract(normPos.x * 2.0) - 0.5) * 2.0,
        abs(fract(normPos.y * 2.0) - 0.5) * 2.0
    );

    float time_t = pingPong(time_f, 6.0) + 2.0;
    float cycle = sin(time_t * 0.5);
    float movingPhase = mirroredPos.x + mirroredPos.y + cycle;
    float phase = sin(movingPhase * 10.0 - time_f * 2.0);

    vec2 centeredPos = mirroredPos - 0.5;
    float radius = length(centeredPos);
    float angle = atan(centeredPos.y, centeredPos.x) + radius * 5.0 - time_f * 1.5;
    vec2 spiralOffset = radius * vec2(cos(angle), sin(angle));

    float wave = sin(mirroredPos.y * 10.0 + time_f * 2.0) * 0.02;
    vec2 waveOffset = vec2(sin(wave * time_t), 0);

    vec2 tcAdjusted = tc + vec2(phase * 0.302, phase * 0.302) + spiralOffset * 0.1 + waveOffset;
    color = texture(textTexture, tcAdjusted);
}
