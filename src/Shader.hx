import com.haxepunk.HXP;
import openfl.gl.*;

typedef ShaderSource = {
	var src:String;
	var fragment:Bool;
}

/**
 * GLSL Shader object
 */
class Shader
{

	/**
	 * Creates a new Shader
	 * @param sources  A list of glsl shader sources to compile and link into a program
	 */
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
			HXP.log(GL.getProgramInfoLog(program));
			HXP.log("VALIDATE_STATUS: " + GL.getProgramParameter(program, GL.VALIDATE_STATUS));
			HXP.log("ERROR: " + GL.getError());
			return;
		}
	}

	/**
	 * Compiles the shader source into a GlShader object and prints any errors
	 * @param source  The shader source code
	 * @param type    The type of shader to compile (fragment, vertex)
	 */
	private function compile(source:String, type:Int):GLShader
	{
		var shader = GL.createShader(type);
		GL.shaderSource(shader, source);
		GL.compileShader(shader);

		if (GL.getShaderParameter(shader, GL.COMPILE_STATUS) == 0)
		{
			HXP.log(GL.getShaderInfoLog(shader));
			return null;
		}

		return shader;
	}

	/**
	 * Return the attribute location in this shader
	 * @param a  The attribute name to find
	 */
	public inline function attribute(a:String):Int
	{
		return GL.getAttribLocation(program, a);
	}

	/**
	 * Return the uniform location in this shader
	 * @param a  The uniform name to find
	 */
	public inline function uniform(u:String):Int
	{
		return GL.getUniformLocation(program, u);
	}

	/**
	 * Bind the program for rendering
	 */
	public inline function bind()
	{
		GL.useProgram(program);
	}

	private var program:GLProgram;

}
