import com.haxepunk.Scene;

class MainScene extends Scene
{
	public override function begin()
	{
		addGraphic(com.haxepunk.graphics.Image.createRect(50, 50, 0xFFEECC), 0, 100, 150);
		addGraphic(com.haxepunk.graphics.Image.createRect(250, 150, 0x553388), 0, 100, 250);
		addGraphic(com.haxepunk.graphics.Image.createRect(150, 50, 0x158BAC), 0, 200, 50);
	}
}