#version 330 core
out vec4 color;
in vec2 tc;

uniform sampler2D textTexture;
uniform vec2 iResolution;
uniform float time_f;

mat2 rotate(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return mat2(c, -s, s, c);
}

vec2 mirror(vec2 uv) {
    return abs(mod(uv, 2.0) - 1.0);
}

void main() {
    vec2 uv = tc * iResolution.xy;
    vec2 sectionSize = vec2(100.0);
    vec2 sectionIndex = floor(uv / sectionSize);
    vec2 localUV = mod(uv, sectionSize) / sectionSize;
    float angle = time_f + length(sectionIndex) * 0.5;
    localUV = rotate(angle) * (localUV - 0.5) + 0.5;
    localUV = mirror(localUV);
    vec2 texCoord = (sectionIndex + localUV) * sectionSize / iResolution.xy;
    color = texture(textTexture, texCoord);
}

