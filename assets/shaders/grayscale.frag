#version 120

#ifdef GL_ES
    precision mediump float;
#endif

varying vec2 vTexCoord;
uniform sampler2D uImage0;

void main(void)
{
    vec4 outColor = texture2D(uImage0, vTexCoord);
    float avg = (outColor.r + outColor.g + outColor.b) / 3.0;
    gl_FragColor = vec4(avg, avg, avg, 1.0);
}
