#version 330 core
out vec4 color;
in vec2 tc;

uniform sampler2D textTexture;
uniform float time_f;
uniform vec2 iResolution;

void main(void) {
    vec2 uv = tc * iResolution;
    uv -= 0.5 * iResolution;
    float dist = length(uv);
    float angle = atan(uv.y, uv.x);
    float wave = sin(dist * 10.0 - time_f * 5.0 + angle * 5.0);
    vec4 texColor = texture(textTexture, tc);
    color = texColor * (0.5 + 0.5 * wave);
}
