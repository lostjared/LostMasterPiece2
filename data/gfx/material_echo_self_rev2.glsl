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
uniform sampler2D mat_textTexture;
uniform float value_alpha_r, value_alpha_g, value_alpha_b;
uniform float index_value;
uniform float time_f;


uniform float restore_black;
in float restore_black_value;

vec4 reverse_vec(vec4 inputv) {
    vec4 rev;
    rev[0] = inputv[2];
    rev[1] = inputv[1];
    rev[2] = inputv[0];
    return rev;
}

void main(void)
{
    if(restore_black_value == 1.0 && texture(textTexture, tc) == vec4(0, 0, 0, 1))
        discard;
    color = texture(textTexture, tc);
    vec4 color2 = texture(textTexture, tc);
    vec4 color3 = texture(mat_textTexture, tc/3);
    vec4 color4 = texture(textTexture, tc/6);
    vec4 color5 = texture(mat_textTexture, tc/6);
    color = (color * 0.3) + (reverse_vec(color3) * 0.3) + (color2 * 0.3) + (reverse_vec(color5) * 0.3) + (color4 * 0.3);
}

