#version 330 core
in vec2 tc;
out vec4 color;
uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;
uniform vec4 iMouse;   // xy = mouse pixel coords

void main() {
    // normalized UVs
    vec2 uv    = tc;
    vec2 mouse = iMouse.xy / iResolution;

    // vector from mouse to this pixel
    vec2 d = uv - mouse;
    float dist = length(d);

    // warp amplitude pulses with time
    float strength = 0.2 + 0.1 * sin(time_f * 2.0);

    strength *= 50;

    // exponential fall-off so effect is local
    float warp = strength * exp(-dist * 10.0);

    // apply bulge: near the cursor we push pixels outward
    uv = mouse + d * (1.0 + warp);

    // keep us in bounds
    uv = clamp(uv, 0.0, 1.0);

    color = texture(textTexture, uv);

}
