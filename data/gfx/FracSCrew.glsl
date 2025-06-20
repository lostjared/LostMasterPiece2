#version 330 core
in vec2 tc;
out vec4 color;
uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;
uniform vec4 iMouse;

float mandelbrot(vec2 c) {
    vec2 z = vec2(0.0);
    float m = 0.0;
    for(int i=0; i<48; ++i) {
        z = vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + c;
        if(dot(z,z) > 4.0) {
            m = float(i) / 48.0;
            break;
        }
    }
    return m;
}

void main() {
    // Mouse fallback
    vec2 mouse = iMouse.xy;
    if(iMouse.z <= 0.0) mouse = 0.5 * iResolution;

    // Goo area around mouse, covers a large region
    float bigRadius = min(iResolution.x, iResolution.y) * 0.52;
    vec2 fromMouse = (tc * iResolution - mouse) / bigRadius;

    // Fractal coordinate: follow mouse, animate
    float zoom = 0.6 + 0.33*sin(time_f * 0.23);
    float angle = time_f * 0.22;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    vec2 fractalCoord = rot * fromMouse * zoom + vec2(-0.8, 0.32*sin(time_f*0.2));
    float fractVal = mandelbrot(fractalCoord);

    // "Inside" the fractal is safe; outside gets goo
    float inside = smoothstep(0.17, 0.41, fractVal); // inside = 1, outside = 0

    // Goo is now OUTSIDE the fractal
    float gooMask = 1.0 - inside;

    // Make goo fade out near edge of area
    float falloff = smoothstep(1.0, 0.6, length(fromMouse));
    float strength = gooMask * falloff;

    // Distortion
    vec2 uv = tc * iResolution;
    if(strength > 0.01) {
        float w1 = sin(time_f*1.3 + fractVal*17.0) * 0.22 + sin(fractVal*15.0 + time_f) * 0.19;
        float w2 = cos(time_f*1.1 + fractVal*23.0) * 0.19 + cos(fractVal*19.0 - time_f*0.5) * 0.15;
        float swirl = 2.7 * strength * sin(time_f + fractVal * 8.0);

        vec2 d = uv - mouse;
        float len = length(d);

        float gooLen = len * (1.0 + strength * (0.41*w1 + 0.29*w2 + 0.36*sin(time_f+fractVal*22.0)));
        float gooAngle = atan(d.y, d.x) + swirl * (0.6 + 0.8*fractVal) + 0.73*strength*sin(time_f*1.5+fractVal*12.0);

        uv = mouse + vec2(cos(gooAngle), sin(gooAngle)) * gooLen;
    }

    color = texture(textTexture, uv / iResolution);
}
