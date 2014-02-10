import com.haxepunk.Engine;
import com.haxepunk.HXP;

class Main extends Engine
{

	override public function init()
	{
#if debug
		HXP.console.enable();
#end

		HXP.scene = new MainScene();

#if !flash
		scanline = new PostProcess("shaders/scanline.frag");
		invert = new PostProcess("shaders/invert.frag", scanline);
		invert.enable();
		scanline.enable();
#end
	}

#if !flash
	override public function resize()
	{
		super.resize();
		if (scanline != null) scanline.rebuild();
		if (invert != null) invert.rebuild();
	}

	override public function render()
	{
		invert.capture();

		// render to a back buffer
		super.render();
	}

	var scanline:PostProcess;
	var invert:PostProcess;
#end

	public static function main() { new Main(); }

}
