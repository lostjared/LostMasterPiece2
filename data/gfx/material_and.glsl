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

void main(void)
{
    if(restore_black_value == 1.0 && texture(textTexture, tc) == vec4(0, 0, 0, 1))
        discard;
    color = texture(textTexture, tc);
    ivec3 source;
    for(int i = 0; i < 3; ++i) {
        source[i] = int(255 * color[i]);
    }
    vec4 color2 = texture(mat_textTexture, tc);
    ivec3 mat_source;
    for(int i = 0; i < 3; ++i) {
        mat_source[i] = int(255 * color2[i]);
    }
    mat_source[0] = mat_source[0] & 0xF;
    mat_source[1] = mat_source[1] & 0xF0;
    mat_source[2] = mat_source[2] & 0xF;
    source = source + mat_source;
    ivec3 int_color;
    for(int i = 0; i < 3; ++i) {
        int_color[i] = int(255 * color[i]);
        int_color[i] = int_color[i]^source[i];
        if(int_color[i] > 255)
            int_color[i] = int_color[i]%255;
        color[i] = float(int_color[i])/255;
    }
}



