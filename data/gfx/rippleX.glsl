#version 330 core
in vec2 tc;
out vec4 color;
uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;

void main(void) {
    // Calculate the current time
    float time = time_f * 0.01;

    // Calculate the center of the ripple
    vec2 center = iResolution / 2.0 - time / 2.0;

    // Get the texture coordinate relative to the center
    vec2 relTc = tc - center;

    // Calculate the distance from the center
    float dist = length(relTc);

    // Calculate the ripple effect based on the distance and time
    float ripple = sin(dist * 10.0 + time) / 2.0;

    // textTexturele the texture and apply the ripple effect
    color = texture(textTexture, tc);
    color += vec4(ripple, ripple, ripple, 0.0);
}

