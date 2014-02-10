#version 120

#ifdef GL_ES
    precision mediump float;
#endif

varying vec2 vTexCoord;
uniform sampler2D uImage0;

const float blurSizeH = 1.0 / 300.0;
const float blurSizeV = 1.0 / 200.0;

void main()
{
    vec4 sum = vec4(0.0);
    for (int x = -4; x <= 4; x++) {
        for (int y = -4; y <= 4; y++) {
            sum += texture2D(uImage0, vec2(vTexCoord.x + x * blurSizeH, vTexCoord.y + y * blurSizeV)) / 81.0;
        }
    }
    gl_FragColor = sum;
}