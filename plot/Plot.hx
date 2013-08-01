package plot;
import flash.display.Shape;
using Lambda;

class Plot extends Shape{
    private var w: Int;
    private var h: Int;

    public function new(width: Int, height: Int) {
        this.w = width;
        this.h = height;
        super();
	}

    public function plot(data:Array<Float>) {
        var bucketed = this.bucketize(data.copy());
        trace(bucketed);
        this.construct(bucketed);
    }

    private function bucketize(data:Array<Float>): Array<{x: Float, y: Float}> {
        data.sort(function(a, b) {
                if(b > a) return -1;
                if(b < a) return 1;
                return 0;
            });
        var min = data[0];
        var max = data[data.length - 1];
        var range = max - min;
        var bucketSize = range / data.length;

        trace('Bucketsize', bucketSize, min, max);

        return data.fold(function(d, bucket: Array<{x: Float, y: Float}>) {
                var top = bucket[bucket.length - 1];
                if(top.x + bucketSize > d) {
                    top.y++;
                } else {
                    bucket.push({x: top.x + bucketSize, y: 1});
                }
                return bucket;
            }, [{x: min, y: 0.0}]);
    }

    private function construct(data:Array<{x: Float, y: Float}>) {
        var leftmost = data[0];
        var rightmost = data[data.length - 1];

        var topmost = data.fold(function(p, top) {
                if(p.y > top.y) return p;
                return top;
            }, leftmost);

        var bottommost = data.fold(function(p, bottom) {
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
        for(point in data) {
            this.graphics.lineTo((point.x - leftmost.x) * scaleX
                                 , (topmost.y - point.y) * scaleY);
        }
        this.graphics.lineTo((rightmost.x - leftmost.x) * scaleX
                             , (topmost.y - bottommost.y) * scaleY);
        for(point in data) {
            this.graphics.drawCircle((point.x - leftmost.x) * scaleX
                                     , (topmost.y - point.y) * scaleY
                                     , 3);
        }
    }
}