#version 330 core
out vec4 color;
in vec2 tc;
uniform sampler2D textTexture;
uniform vec2 iResolution;
uniform float time_f;

void main(void) {
    vec2 normCoord = (tc * 2.0 - 1.0) * vec2(iResolution.x / iResolution.y, 1.0);

    if (normCoord.y < 0.0) {
        normCoord.y = -normCoord.y;
    }
    float dist = length(normCoord);
    float angle = atan(normCoord.y, normCoord.x);
    float spiralAmount = time_f;
    angle += spiralAmount;
    dist = mix(dist, 1.0 - dist, sin(spiralAmount * 0.5));
    vec2 spiralCoord = vec2(cos(angle), sin(angle)) * dist;

    float scale = 1.0 + sin(spiralAmount * 0.2) * 0.5;
    spiralCoord *= scale;
    spiralCoord = (spiralCoord / vec2(iResolution.x / iResolution.y, 1.0) + 1.0) / 2.0;

    color = texture(textTexture, spiralCoord);
}
