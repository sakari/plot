package plot;
import flash.display.Sprite;
import plot.Scaled;
import flash.geom.Point;
import flash.text.TextField;

using Lambda;

class Plot extends Sprite{
    var w: Int;
    var h: Int;
    var pad: Point;

    public function new(width: Int, height: Int) {
        this.w = width;
        this.h = height;
        this.pad = new Point(20, 20);
        super();
	}

    public function plot(data:Array<Float>) {
        var bucketed = this.bucketize(data.copy());
        this.construct(bucketed);
    }

    private function axisUnit(range: Float): Float {
        var rangeScale = range / 10;
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
        var bucketSize = (range / data.length) * 10;

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
        var plot = new Sprite();
        plot.x = this.pad.x;
        plot.y = this.pad.y;
        this.addChild(plot);

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

        plot.graphics.clear();
        plot.graphics.lineStyle();
        plot.graphics.beginFill(0xff0000);
        
        plot.graphics.moveTo(scaled.translateX(xAxis[0])
                             , scaled.translateY(yAxis[0]));
        for(point in data) {
            plot.graphics.lineTo(scaled.translateX(point.x)
                                 , scaled.translateY(point.y));
        }
        plot.graphics.lineTo(scaled.translateX(xAxis[xAxis.length - 1]), 
                             scaled.translateY(yAxis[0]));

        plot.graphics.endFill();

        var x_axis_sprite = new Axis(xAxis, scaled, true);
        x_axis_sprite.x = this.pad.x + scaled.translateX(xAxis[0]);
        x_axis_sprite.y = this.pad.y + scaled.translateY(yAxis[0]);
        this.addChild(x_axis_sprite);

        var y_axis_sprite = new Axis(yAxis, scaled, false);
        y_axis_sprite.x = this.pad.x + scaled.translateX(xAxis[0]);
        y_axis_sprite.y = this.pad.y;
        this.addChild(y_axis_sprite);
    }
}