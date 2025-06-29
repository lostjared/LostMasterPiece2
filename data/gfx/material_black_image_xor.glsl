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
in vec2 iResolution_;
uniform vec2 iResolution;
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
    vec4 color2;
    color2 = texture(mat_textTexture, tc);
    if(color[0] < 0.1 && color[1] < 0.1 && color[2] < 0.1) {
        ivec3 source;
        for(int i = 0; i < 3; ++i) {
            source[i] = int(255 * color2[i]);
        }
        vec4 value = vec4(alpha_r, alpha_g, alpha_b, 1.0);
        
        color = (color2*alpha) * value * alpha;
    }
    else {
        ivec4 source_color = ivec4(color * 255);
        ivec4 final_color = ivec4(color2 * 255);
        color = xor_RGB(final_color, source_color);
    }
}







