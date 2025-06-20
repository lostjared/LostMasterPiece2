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

vec4 xor_RGB(vec4 icolor, ivec4 isource) {
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
    color = texture(textTexture, tc);
    
    if(color[0] > 0.9 && color[1] > 0.9 && color[2] > 0.9) {
        vec4 color2 = texture(textTexture, tc /(0.9 + alpha));
        vec4 color3 = texture(textTexture, tc/ (1.5 + alpha));
        vec4 color4 = texture(textTexture, tc/ (2.0 + alpha));
        ivec4 source =ivec4(color * 255);
        color = (color * 0.4) + (color2 * 0.4) + (color3 * 0.4) + (color4 * 0.4) ;
        ivec4 blend = ivec4(color * 255);
        blend[0] = source[0] ^ blend[0];
        blend[1] = source[1] | blend[1];
        blend[2] = source[2] & blend[2];
        color = xor_RGB(blend, source);
    }
}



