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



uniform float restore_black;
in float restore_black_value;

void main(void)
{
    if(restore_black_value == 1.0 && texture(textTexture, tc) == vec4(0, 0, 0, 1))
        discard;
    color = texture(textTexture, tc);
    vec2 cord1 = vec2(tc[0]/2, tc[0]/2);
    vec2 cord2 = vec2(tc[0]/4, tc[0]/4);
    vec2 cord3 = vec2(tc[0]/8, tc[0]/8);
    vec4 col1 = texture(textTexture, cord1);
    vec4 col2 = texture(textTexture, cord2);
    vec2 p = gl_FragCoord.xy / 32;
    vec2 d = fract(p);
    color[1] = (color[1]+col1[1])*(d[0]+d[1]);
    color[2] = (color[2]+col2[2])*(d[0]+d[1]);
}

