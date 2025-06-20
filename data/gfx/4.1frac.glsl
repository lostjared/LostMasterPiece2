#version 330 core
in vec2 tc;
out vec4 color;
uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution; // [width, height]
uniform vec4 iMouse;      // [x, y, ...] in pixels

void main(void) {
    // Convert tc to pixel coordinates
    vec2 uv = tc * iResolution;
    
    // Mouse position in screen coordinates (pixels)
    vec2 mouse = iMouse.xy;

    // Radius of effect (in pixels)
    float radius = 120.0;

    // Distance from mouse
    float dist = length(uv - mouse);

    // How much to twist (max angle, in radians)
    float maxAngle = 2.5;

    // Twist amount falls off with distance (smoothly)
    float t = clamp(1.0 - dist / radius, 0.0, 1.0);
    t = smoothstep(0.0, 1.0, t);

    // Angle of rotation, time-varying
    float angle = maxAngle * t * sin(time_f * 1.5);

    // Direction from mouse to uv
    vec2 dir = uv - mouse;
    float len = length(dir);

    // Only twist inside the radius
    if(len < radius) {
        float a = atan(dir.y, dir.x) + angle;
        vec2 twisted = vec2(cos(a), sin(a)) * len;
        uv = mouse + twisted;
    }

    // Convert back to 0..1 for texture textTextureling
    vec2 final_uv = uv / iResolution;
    color = texture(textTexture, final_uv);
}
