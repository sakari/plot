package plot;
import flash.display.Sprite;
import flash.display.Shape;
import plot.Scaled;
import flash.events.MouseEvent;

class PlotSelection extends Sprite {
    var hitArea: Sprite;
    var selectRegion: Shape;
    var lowBorder: Null<Float>;
    var hiBorder: Null<Float>;
    var touchWidth: Float;
    var scaled: Scaled;
    var xAxis: Array<Float>;
    var yAxis: Array<Float>;

    function new(xAxis: Array<Float>, yAxis: Array<Float>, scaled: Scaled) {
        super();
        this.scaled = scaled;
        this.xAxis = xAxis;
        this.yAxis = yAxis;

        touchWidth = 10;
        hitArea = new Sprite();
        hitArea.graphics.beginFill(0x0000ff, 0);
        hitArea.graphics.drawRect(0, 0
                                  , scaled.translateX(xAxis[xAxis.length - 1])
                                  , scaled.translateY(yAxis[0]));
        
        hitArea.addEventListener(MouseEvent.MOUSE_DOWN, adjustSelectRegion);
        selectRegion = new Shape();
        addChild(selectRegion);
        addChild(hitArea);
    }

    private function drawSelectRegion() {
        var low = lowBorder, hi = hiBorder;
        selectRegion.graphics.clear();
        if(hiBorder == null && lowBorder == null) {
            return;
        }
        if(hiBorder == null) {
            hi = xAxis[xAxis.length - 1];
        }
        if(lowBorder == null) {
            low = xAxis[0];
        }

        selectRegion.graphics.beginFill(0x0000ff, .5);
        selectRegion.graphics.drawRect(scaled.translateX(low)
                                       , 0
                                       , scaled.translateX(hi) - scaled.translateX(low)
                                       , scaled.translateY(yAxis[0]));
        trace('low', low, 'hi', hi);
    }

    private function clearMoveListeners(e: MouseEvent) {
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveLowBorder);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHiBorder);
        stage.removeEventListener(MouseEvent.MOUSE_UP, clearMoveListeners);
    }

    private function startMoveLowBorder(e: MouseEvent) {
        stage.addEventListener(MouseEvent.MOUSE_MOVE, moveLowBorder);
        stage.addEventListener(MouseEvent.MOUSE_UP, clearMoveListeners);
        moveLowBorder(e);
    }

    private function startMoveHiBorder(e: MouseEvent) {
        stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHiBorder);
        stage.addEventListener(MouseEvent.MOUSE_UP, clearMoveListeners);
        moveHiBorder(e);
    }

    private function moveLowBorder(e: MouseEvent) {
        lowBorder = scaled.unscaleX(e.localX);
        drawSelectRegion();
    }

    private function moveHiBorder(e: MouseEvent) {
        hiBorder = scaled.unscaleX(e.localX);
        drawSelectRegion();
    }

    private function adjustSelectRegion(event: MouseEvent) {
        if(lowBorder != null && 
           Math.abs(event.localX - scaled.translateX(lowBorder)) < touchWidth) {
            return startMoveLowBorder(event);
        }
        if(hiBorder != null &&
           Math.abs(event.localX - scaled.translateX(hiBorder)) < touchWidth) {
            return startMoveHiBorder(event);
        }
        if(lowBorder == null) {
            return startMoveLowBorder(event);
        }
        if(hiBorder == null) {
            return startMoveHiBorder(event);
        }
        if(Math.abs(event.localX - scaled.translateX(hiBorder)) <
           Math.abs(event.localX - scaled.translateX(lowBorder))) {
            return startMoveHiBorder(event);
        }
        startMoveLowBorder(event);
    }
}