package plot;
import flash.display.Sprite;
import flash.display.Shape;
import plot.Scaled;
import flash.events.MouseEvent;

class PlotSelection extends Sprite {
    var hitArea: Sprite;
    function new(xAxis: Array<Float>, yAxis: Array<Float>, scaled: Scaled) {
        super();

        hitArea = new Sprite();
        hitArea.graphics.beginFill(0x0000ff, 0);
        hitArea.graphics.drawRect(0, 0
                                  , scaled.translateX(xAxis[xAxis.length - 1])
                                  , scaled.translateY(yAxis[0]));
        
        hitArea.addEventListener(MouseEvent.MOUSE_DOWN, fn);
        addChild(hitArea);
    }

    private function fn(event: MouseEvent) {
        trace(event.localX, event.localY);
    }
}