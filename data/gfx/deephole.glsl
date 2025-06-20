#version 330 core
in vec2 tc;
out vec4 color;
uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;

void main(void) {
    // Center coordinates and scale
    vec2 uv = tc * 2.0 - 1.0;

    // Polar coordinates conversion
    float radius = length(uv);
    float angle = atan(uv.y, uv.x);

    // Swirl effect parameters
    const float swirlStrength = 5.0;
    float swirlAmount = sin(time_f * swirlStrength) * radius;

    // Apply swirl effect
    vec2 offset = uv * radians(swirlAmount);
    vec2 distortedUV = uv + offset;

    // Mirror and tile pattern
    distortedUV = abs(fract(distortedUV * 1.5) * 2.0 - 1.0);

    // Final texture textTextureling with perspective warp
    vec2 finalUV = (distortedUV + 1.0) * 0.5;
    finalUV = fract(finalUV + vec2(time_f * 0.1, 0.0));

    color = texture(textTexture, finalUV);
}