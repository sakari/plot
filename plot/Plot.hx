package plot;
import flash.display.Shape;
import plot.Scaled;
import flash.geom.Point;

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
        this.construct(bucketed);
    }

    private function axisUnit(range: Float): Float {
        var rangeScale = range / 100;
        var log = Math.log(rangeScale) / Math.log(10);
        return Math.pow(10, Math.round(log));
    }

    private function axisPoints(min: Float, max: Float): Array<Float> {
        var unit = this.axisUnit(max - min);
        var points = [];
        var count = Math.floor(min / unit);
        while(count * unit < max) {
            points.push(count++ * unit);
        } 
        points.push(count * unit);
        return points;
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

        var xAxis = this.axisPoints( leftmost.x
                                    , rightmost.x);
        var yAxis = this.axisPoints( bottommost.y
                                    , topmost.y);

        var scaled = new Scaled({ width: this.w 
                                  , height: this.h
                                  , min: new Point(xAxis[0], yAxis[0])
                                  , max: new Point(xAxis[xAxis.length - 1]
                                                   , yAxis[yAxis.length - 1])
            });

        this.graphics.clear();
        this.graphics.lineStyle(2, 0x00ff00);
        this.graphics.drawRect(0, 0, this.w, this.h);

        this.graphics.lineStyle();
        this.graphics.beginFill(0xff0000);
        
        this.graphics.moveTo(scaled.translateX(xAxis[0]), scaled.translateY(yAxis[0]));
        for(point in data) {
            this.graphics.lineTo(scaled.translateX(point.x)
                                 , scaled.translateY(point.y));
        }
        this.graphics.lineTo(scaled.translateX(xAxis[xAxis.length - 1]), 
                             scaled.translateY(yAxis[0]));
        for(point in data) {
            this.graphics.drawCircle(scaled.translateX(point.x)
                                     , scaled.translateY(point.y)
                                     , 3);
        }

        this.graphics.endFill();

        this.graphics.lineStyle(4, 0x000000);        
        this.graphics.moveTo(scaled.translateX(xAxis[0])
                             , scaled.translateY(yAxis[0]));
        for(tick in xAxis) {
            this.graphics.lineTo(scaled.translateX(tick)
                                 , scaled.translateY(yAxis[0]));
        }
        this.graphics.lineStyle(4, 0x0000ff);        
        this.graphics.moveTo(scaled.translateX(xAxis[0])
                             , scaled.translateY(yAxis[0]));
        for(tick in yAxis) {
            this.graphics.lineTo(scaled.translateX(xAxis[0])
                                 , scaled.translateY(tick));
        }
    }
}