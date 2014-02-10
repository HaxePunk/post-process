import com.haxepunk.HXP;

import openfl.Assets;
import openfl.gl.*;
import openfl.utils.Float32Array;
import openfl.display.OpenGLView;
import flash.geom.Rectangle;

class PostProcess extends OpenGLView
{

	public var renderTo:GLFramebuffer = null;

	public function new(fragmentShader:String, ?chain:PostProcess)
	{
		super();

		// create and bind the framebuffer
		framebuffer = GL.createFramebuffer();
		rebuild();

		var status = GL.checkFramebufferStatus(GL.FRAMEBUFFER);
		switch (status)
		{
			case GL.FRAMEBUFFER_INCOMPLETE_ATTACHMENT:
				trace("FRAMEBUFFER_INCOMPLETE_ATTACHMENT");
			case GL.FRAMEBUFFER_UNSUPPORTED:
				trace("GL_FRAMEBUFFER_UNSUPPORTED");
			case GL.FRAMEBUFFER_COMPLETE:
			default:
				trace("Check frame buffer: " + status);
		}

		buffer = GL.createBuffer();
		GL.bindBuffer(GL.ARRAY_BUFFER, buffer);
		GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(cast vertices), GL.STATIC_DRAW);
		GL.bindBuffer(GL.ARRAY_BUFFER, null);

		shader = new Shader([
			{ src: vertexShader, fragment: false },
			{ src: Assets.getText(fragmentShader), fragment: true }
		]);
		imageUniform = shader.uniform("uImage0");
		resolutionUniform = shader.uniform("uResolution");
		vertexSlot = shader.attribute("aVertex");
		texCoordSlot = shader.attribute("aTexCoord");

		if (chain != null) renderTo = chain.framebuffer;
	}

	public function enable()
	{
		var index = HXP.stage.numChildren;
		if (HXP.console.visible) index -= 1;
		if (index < 0) index = 0;
		HXP.stage.addChildAt(this, index); // add before the console is enabled
	}

	public function rebuild()
	{
		GL.bindFramebuffer(GL.FRAMEBUFFER, framebuffer);

		if (texture != null) GL.deleteTexture(texture);
		if (renderbuffer != null) GL.deleteRenderbuffer(renderbuffer);

		createTexture(HXP.windowWidth, HXP.windowHeight);
		createRenderbuffer(HXP.windowWidth, HXP.windowHeight);
		GL.bindFramebuffer(GL.FRAMEBUFFER, null);
	}

	private inline function createRenderbuffer(width:Int, height:Int)
	{
		// Bind the renderbuffer and create a depth buffer
		renderbuffer = GL.createRenderbuffer();
		GL.bindRenderbuffer(GL.RENDERBUFFER, renderbuffer);
		GL.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, width, height);

		// Specify renderbuffer as depth attachement
		GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, renderbuffer);
	}

	private inline function createTexture(width:Int, height:Int)
	{
		texture = GL.createTexture();
		GL.bindTexture(GL.TEXTURE_2D, texture);
		GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGB,  width, height,  0,  GL.RGB, GL.UNSIGNED_BYTE, null);

		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER , GL.LINEAR);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);

		// specify texture as color attachment
		GL.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, texture, 0);
	}

	public function capture()
	{
		GL.bindFramebuffer(GL.FRAMEBUFFER, framebuffer);

		GL.viewport(0, 0, HXP.windowWidth, HXP.windowHeight);
		GL.clear(GL.DEPTH_BUFFER_BIT | GL.COLOR_BUFFER_BIT);

		GL.disable(GL.DEPTH_TEST);
		GL.enable(GL.BLEND);
		GL.blendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
	}

	override public function render(rect:Rectangle)
	{
		GL.bindFramebuffer(GL.FRAMEBUFFER, renderTo);

		GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);

		shader.bind();

		GL.enableVertexAttribArray(vertexSlot);
		GL.enableVertexAttribArray(texCoordSlot);

		GL.activeTexture(GL.TEXTURE0);
		GL.bindTexture(GL.TEXTURE_2D, texture);
		GL.enable(GL.TEXTURE_2D);

		GL.bindBuffer(GL.ARRAY_BUFFER, buffer);
		GL.vertexAttribPointer(vertexSlot, 2, GL.FLOAT, false, 16, 0);
		GL.vertexAttribPointer(texCoordSlot, 2, GL.FLOAT, false, 16, 8);

		GL.uniform1i(imageUniform, 0);
		GL.uniform2f(resolutionUniform, HXP.windowWidth, HXP.windowHeight);

		GL.drawArrays(GL.TRIANGLES, 0, 6);

		GL.bindBuffer(GL.ARRAY_BUFFER, null);
		GL.disable(GL.TEXTURE_2D);
		GL.bindTexture(GL.TEXTURE_2D, null);

		GL.disableVertexAttribArray(vertexSlot);
		GL.disableVertexAttribArray(texCoordSlot);

		shader.unbind();

		// check gl error
		if (GL.getError() == GL.INVALID_FRAMEBUFFER_OPERATION)
		{
			trace("INVALID_FRAMEBUFFER_OPERATION!!");
		}
	}

	private var framebuffer:GLFramebuffer;
	private var renderbuffer:GLRenderbuffer;
	private var texture:GLTexture;

	private var shader:Shader;
	private var buffer:GLBuffer;

	private var vertexSlot:Int;
	private var texCoordSlot:Int;
	private var imageUniform:Int;
	private var resolutionUniform:Int;

	private static inline var vertexShader:String = "
#ifdef GL_ES
	precision mediump float;
#endif

attribute vec4 aVertex;

attribute vec2 aTexCoord;
varying vec2 vTexCoord;

void main() {
	vTexCoord = aTexCoord;
	gl_Position = vec4(aVertex.x, aVertex.y, 0.0, 1.0);
}";

	private static var vertices(get, never):Array<Float>;
	private static inline function get_vertices():Array<Float>
	{
		return [
			-1.0, -1.0, 0, 0,
			 1.0, -1.0, 1, 0,
			-1.0,  1.0, 0, 1,
			 1.0, -1.0, 1, 0,
			 1.0,  1.0, 1, 1,
			-1.0,  1.0, 0, 1
		];
	}

}
