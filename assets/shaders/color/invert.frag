#version 120

#ifdef GL_ES
    precision mediump float;
#endif

varying vec2 vTexCoord;
uniform sampler2D uImage0;

void main(void)
{
	vec4 color = texture2D(uImage0, vTexCoord);
    gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0) - color;
    gl_FragColor.a = color.a; // don't invert alpha
}
