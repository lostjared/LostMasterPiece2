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

vec4 xor_RGB(vec4 icolor, vec4 source) {
    ivec4 isource = ivec4(source * 255);
    ivec3 int_color;
    for(int i = 0; i < 3; ++i) {
        int_color[i] = int(255 * icolor[i]);
        int_color[i] = int_color[i]^isource[i];
        if(int_color[i] > 255)
            int_color[i] = int_color[i]%255;
        icolor[i] = float(int_color[i])/255;
    }
    icolor.a = 1.0;
return icolor;
}


void main(void)
{
    if(restore_black_value == 1.0 && texture(textTexture, tc) == vec4(0, 0, 0, 1))
        discard;
    color = (0.5 * texture(textTexture, tc)) + (0.5 * texture(mat_textTexture, tc));
    vec4 color2 = (0.5 * texture(textTexture, tc/2)) + (0.5 * texture(mat_textTexture, tc/2));
    vec4 color3 = (0.5 * texture(textTexture, tc/4)) + (0.5 * texture(mat_textTexture, tc/4));
    vec4 color4 = (0.5 * texture(textTexture, tc/6)) + (0.5 * texture(mat_textTexture, tc/6));
    
    color2 = xor_RGB(color, color2);
    color3 = xor_RGB(color3, color4);
    
    color = (color * 0.4) + (color2 * 0.4) + (color3 * 0.4);
}







