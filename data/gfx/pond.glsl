#version 330 core

in vec2 tc;
out vec4 color;

uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;

void main(void) {
    // Get the current pixel position in texture coordinates
    vec2 p = (tc * 2.0 - 1.0) * iResolution / 2.0;

    // Calculate the distance to the center of the texture
    float dist = length(p);

    // Adjust the distance based on the time parameter and a sinusoidal function
    float time = fmod(time_f, 10.0) / 5.0;
    dist *= sin(dist * time * 2.0 * 3.14);

    // textTexturele the texture at the modified distance
    vec4 texColor = texture(textTexture, p / dist);

    // Output the final color
    color = texColor;
}
