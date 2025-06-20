#version 330 core
in vec2 tc;
out vec4 color;
uniform float alpha_value;
uniform sampler2D textTexture;
uniform float time_f;


void main(void)
{
    color = texture(textTexture, tc);
    ivec3 source;
    for(int i = 0; i < 3; ++i) {
        source[i] = int(255 * color[i]);
    }
    vec2 cord1 = vec2(tc[0]/2, tc[1]/2);
    vec2 cord2 = vec2(tc[0]/4, tc[1]/4);
    vec2 cord3 = vec2(tc[0]/8, tc[1]/8);
    vec4 col1 = texture(textTexture, cord1);
    vec4 col2 = texture(textTexture, cord2);
    vec4 col3 = texture(textTexture, cord3);
    color[0] = color[0] * col1[0];
    color[1] = color[1] * col2[1];
    color[2] = color[2] * col3[2];
    ivec3 int_color;
    for(int i = 0; i < 3; ++i) {
        int_color[i] = int(255 * color[i]);
        int_color[i] = int_color[i]^source[i];
        if(int_color[i] > 255)
            int_color[i] = int_color[i]%255;
        color[i] = float(int_color[i])/255;
    }
}


