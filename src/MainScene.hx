import com.haxepunk.Scene;

class MainScene extends Scene
{
	public override function begin()
	{
		addGraphic(com.haxepunk.graphics.Image.createRect(40, 40, 0xFFEECC), 0, 5, 5);
		addGraphic(com.haxepunk.graphics.Image.createRect(40, 40, 0x553388), 0, 55, 5);
		addGraphic(com.haxepunk.graphics.Image.createRect(90, 40, 0x158BAC), 0, 5, 55);
	}
}