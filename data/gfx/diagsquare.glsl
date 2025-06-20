#version 330 core
out vec4 color;
in vec2 tc;

uniform sampler2D textTexture;
uniform float time_f;
uniform vec2 iResolution;

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec2 uv = tc;
    float squareSize = 0.2;
    vec2 gridCoord = floor(uv / squareSize);
    vec2 localCoord = fract(uv / squareSize);

    float diag = mod(gridCoord.x + gridCoord.y, 2.0);
    vec4 texColor = texture(textTexture, uv);

    if (diag == 0.0) {
        float shift = sin(time_f + gridCoord.x * 0.5) * 0.1;
        localCoord.x += shift; 
        uv = fract(gridCoord * squareSize + localCoord);
        texColor = texture(textTexture, uv);
    }

    color = texColor;
}

