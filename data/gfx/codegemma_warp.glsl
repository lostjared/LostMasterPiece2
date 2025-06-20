#version 330 core

in vec2 tc;
out vec4 color;

uniform float time_f;
uniform sampler2D textTexture;
uniform float alpha;
uniform vec2 iResolution;

const float PI = 3.14159265358979323846f;

void main(void) {
    // Calculate texture coordinates with warping and wrinkle effect
    vec2 texCoord = tc + vec2(time_f * 0.5, 0);
    texCoord.x = fract(texCoord.x); // Wrap texture horizontally
    texCoord.y += sin(time_f * 2.0) * 0.2; // Wrinkle effect

    // Calculate spiral angle based on texture coordinates
    float angle = atan(texCoord.y, texCoord.x) * 2.0;

    // Gradient colors based on spiral angle
    vec3 gradient = vec3(cos(angle), sin(angle), 0.5);

    // Apply texture and gradient
    color = texture(textTexture, texCoord) * vec4(gradient, alpha);
}
