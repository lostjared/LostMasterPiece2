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
uniform float value_alpha_r, value_alpha_g, value_alpha_b;
uniform float index_value;
uniform float time_f;
uniform vec2 iResolution;

uniform float restore_black;
in float restore_black_value;
in vec2 iResolution_;
uniform vec4 inc_valuex;
uniform vec4 inc_value;

void main(void)
{
    if(restore_black_value == 1.0 && texture(textTexture, tc) == vec4(0, 0, 0, 1))
        discard;
    color = texture(textTexture, tc);
    vec4 color_one = texture(textTexture, tc-0.01);
    vec4 color_two = texture(textTexture, tc-0.02);
    vec4 color_three = texture(textTexture, tc-0.03);
    
    vec4 color_off = color_one + color_two + color_three + color;
    
    color_off = color_off / 4;
    
    color = (color * 0.3) + (color_two * 0.5) + (color_one * 0.3);

    color = (0.5 * color) + (0.5 * color_off);
}




