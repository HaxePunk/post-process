import com.haxepunk.*;
import com.haxepunk.utils.*;

class Main extends Engine
{

	override public function init()
	{
#if debug
		HXP.console.enable();
#end

		HXP.scene = new MainScene();

		var radius = 1.2;

		blurH = new PostProcess("shaders/blur.frag");
		blurH.setUniform("radius", radius);
		blurH.setUniform("dirx", 1.0);
		blurH.setUniform("diry", 0.0);

		blurV = new PostProcess("shaders/blur.frag");
		blurV.setUniform("radius", radius);
		blurV.setUniform("dirx", 0.0);
		blurV.setUniform("diry", 1.0);

		blurH.enable(blurV);
		blurV.enable();
	}

	override public function resize()
	{
		super.resize();
		if (blurH != null) blurH.rebuild();
		if (blurV != null) blurV.rebuild();
	}

	override public function render()
	{
		blurH.capture();

		// render to a back buffer
		super.render();
	}

	override public function update()
	{
		if (Input.pressed(Key.F))
		{
			HXP.fullscreen = !HXP.fullscreen;
		}
		super.update();
	}

	private var blurH:PostProcess;
	private var blurV:PostProcess;

	public static function main() { new Main(); }

}
