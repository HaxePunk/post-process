#version 120

#ifdef GL_ES
	precision mediump float;
#endif

varying vec2 vTexCoord;
uniform vec2 uResolution;
uniform sampler2D uImage0;

void main()
{
	int scale = 1;
	if (mod(floor(vTexCoord.y * uResolution.y / scale), 2.0) == 0.0)
		gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
	else
		gl_FragColor = texture2D(uImage0, vTexCoord);
}
