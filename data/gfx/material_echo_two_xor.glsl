
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
    ivec3 source;
    for(int i = 0; i < 3; ++i) {
        source[i] = int(255 * color[i]);
    }
    vec4 color1x, color2x, color3x;
    vec4 mat_color;
    color1x = texture(mat_textTexture, tc/2);
    color2x = texture(mat_textTexture, tc/4);
    color3x = texture(mat_textTexture, tc/6);
    vec4 color2 = texture(textTexture, tc /0.9);
    vec4 color3 = texture(textTexture, tc/ 1.5);
    vec4 color4 = texture(textTexture, tc/ 2.0);
    color = (color * 0.4) + (color2 * 0.4) + (color3 * 0.4) + (color4 * 0.4) ;
    mat_color = (color1x * 0.4) + (color2x * 0.4) + (color3x * 0.4);
    color = color * mat_color;
    ivec3 int_color;
    for(int i = 0; i < 3; ++i) {
        int_color[i] = int(255 * color[i]);
        int_color[i] = int_color[i]^source[i];
        if(int_color[i] > 255)
            int_color[i] = int_color[i]%255;
        color[i] = float(int_color[i])/255;
    }
}




