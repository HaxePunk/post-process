import openfl.gl.*;

typedef ShaderSource = {
	var src:String;
	var fragment:Bool;
}

class Shader
{

	public function new(sources:Array<ShaderSource>)
	{
		program = GL.createProgram();

		for (source in sources)
		{
			var shader = compile(source.src, source.fragment ? GL.FRAGMENT_SHADER : GL.VERTEX_SHADER);
			if (shader == null) return;
			GL.attachShader(program, shader);
			GL.deleteShader(shader);
		}

		GL.linkProgram(program);

		if (GL.getProgramParameter(program, GL.LINK_STATUS) == 0)
		{
			trace(GL.getProgramInfoLog(program));
			trace("VALIDATE_STATUS: " + GL.getProgramParameter(program, GL.VALIDATE_STATUS));
			trace("ERROR: " + GL.getError());
			return;
		}
	}

	private function compile(source:String, type:Int):GLShader
	{
		var shader = GL.createShader(type);
		GL.shaderSource(shader, source);
		GL.compileShader(shader);

		if (GL.getShaderParameter(shader, GL.COMPILE_STATUS) == 0)
		{
			trace(GL.getShaderInfoLog(shader));
			return null;
		}

		return shader;
	}

	public function attribute(a:String):Int
	{
		return GL.getAttribLocation(program, a);
	}

	public function uniform(u:String):Int
	{
		return GL.getUniformLocation(program, u);
	}

	public inline function bind()
	{
		if (program == null) return;

		GL.useProgram(program);
	}

	public inline function unbind()
	{
		GL.useProgram(null);
	}

	private var program:GLProgram;

}
