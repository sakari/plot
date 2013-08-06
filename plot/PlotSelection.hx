package plot;
import flash.display.Sprite;

class PlotSelection extends Sprite {
    function new(width: Float, height: Float) {
        super();
        this.graphics.beginFill(0x00ff00, .5);
        this.graphics.drawRect(0, 0, width, height);
    }
}