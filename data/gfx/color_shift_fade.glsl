#version 330
in vec2 tc;
out vec4 color;
uniform float alpha_r;
uniform float alpha_g;
uniform float alpha_b;
in float current_index;
in float timeval;
uniform float alpha;
in vec3 vpos;
in vec4 optx_val;
uniform vec4 optx;
in vec4 random_value;
uniform vec4 random_var;
uniform float alpha_value;
uniform mat4 mv_matrix;
uniform mat4 proj_matrix;
uniform sampler2D textTexture;
uniform vec2 mat_size;
uniform vec4 inc_valuex;
uniform float value_alpha_r, value_alpha_g, value_alpha_b;
uniform float index_value;
uniform float time_f;
in vec2 iResolution_;
uniform vec2 iResolution;
uniform float restore_black;
in float restore_black_value;

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

void main(void)
{
    if(restore_black_value == 1.0 && texture(textTexture, tc) == vec4(0, 0, 0, 1))
        discard;
    color = texture(textTexture, tc);
    vec4 color2 = texture(textTexture, tc);
    vec2 st = (gl_FragCoord.xy / iResolution_.xy);
    float rnd = random(st);
    vec4 v = vec4(fract(inc_valuex.x/3), fract(inc_valuex.y/9)*0.5, fract(inc_valuex.z/3), 1);
    v *= 0.5;
    vec4 color1 = v * vec4(1, st*fract(timeval/alpha)*6.0, 1);
    color = color * color1 * 4.0;
}
