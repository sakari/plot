package plot;
import flash.display.Shape;
using Lambda;

class Plot extends Shape{
    private var data: Array<{x: Float, y: Float}>;
    private var w: Int;
    private var h: Int;

    public function new(width: Int, height: Int) {
        this.w = width;
        this.h = height;
        super();
	}

    public function plot(data:Array<{x: Float, y: Float}>) {
        this.data = data;
        this.construct();
    }

    private function construct() {
        var leftmost = this.data[0];
        var rightmost = this.data[this.data.length - 1];

        var topmost = this.data.fold(function(p, top) {
                if(p.y > top.y) return p;
                return top;
            }, leftmost);

        var bottommost = this.data.fold(function(p, bottom) {
                if(p.y < bottom.y) return p;
                return bottom;
            }, leftmost);

        var scaleX = this.w / (rightmost.x - leftmost.x);
        var scaleY = this.h / (topmost.y - bottommost.y);

        this.graphics.clear();
        this.graphics.lineStyle(2, 0x00ff00);
        this.graphics.drawRect(0, 0, this.w, this.h);
        this.graphics.lineStyle();
        this.graphics.beginFill(0xff0000);

        this.graphics.moveTo(0, (topmost.y - bottommost.y) * scaleY);
        this.graphics.lineTo(0, (topmost.y - (leftmost.y - bottommost.y)) * scaleY);
        for(point in this.data) {
            this.graphics.lineTo((point.x - leftmost.x) * scaleX
                                 , (topmost.y - point.y) * scaleY);
        }
        this.graphics.lineTo((rightmost.x - leftmost.x) * scaleX
                             , (topmost.y - bottommost.y) * scaleY);
        for(point in this.data) {
            this.graphics.drawCircle((point.x - leftmost.x) * scaleX
                                     , (topmost.y - point.y) * scaleY
                                     , 3);
        }
    }
}