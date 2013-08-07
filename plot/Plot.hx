package plot;
import flash.display.Sprite;
import plot.Scaled;
import plot.PlotSelection;
import flash.geom.Point;
import flash.text.TextField;

using Lambda;

class Plot extends Sprite{
    var w: Int;
    var h: Int;
    var pad: Point;
    var fillRGB: Int;
    var fillAlpha: Float;
    var bucketed: Array<{x: Float, y: Float}>;
    var lowBorderAt: Null<Float>;
    var highBorderAt: Null<Float>;

    public function new(width: Int, height: Int) {
        this.w = width - 40;
        this.h = height - 40;
        this.pad = new Point(20, 20);
        super();
	}

    public function selectOver(p: Float): Plot{
        lowBorderAt = p;
        return this;
    }
    
    public function selectUnder(p: Float): Plot {
        highBorderAt = p;
        return this;
    }

    public function colour(rgb: Int, alpha: Float): Plot {
        this.fillRGB = rgb;
        this.fillAlpha = alpha;
        return this;
    }

    public function data(data: Array<Float>): Plot {
        this.bucketed = this.bucketize(data.copy());
        return this;
    }
    public function plot(): Void {
        this.construct(this.bucketed);
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
        var minimumBucket = 3 / (this.w / range);
        var bucketSize = Math.max((range / data.length) * 10, minimumBucket);

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

    private function plotSprite(scaled: Scaled 
                                , data: Array<{x: Float, y: Float}>
                                , start: Point
                                , end: Point): Sprite {

        var plot = new Sprite();
        plot.x = this.pad.x;
        plot.y = this.pad.y;
        plot.graphics.lineStyle();
        plot.graphics.beginFill(this.fillRGB, this.fillAlpha);

        plot.graphics.moveTo(scaled.translateX(start.x)
                             , scaled.translateY(start.y));
        for(point in data) {
            plot.graphics.lineTo(scaled.translateX(point.x)
                                 , scaled.translateY(point.y));
        }
        plot.graphics.lineTo(scaled.translateX(end.x)
                             , scaled.translateY(end.y));
        return plot;
    }

    private function xAxisPoints(data:Array<{x: Float, y: Float}>) {
        var leftmost = data[0];
        var rightmost = data[data.length - 1];

        return this.axisPoints( leftmost.x
                                , rightmost.x);        
    }

    private function yAxisPoints(data:Array<{x: Float, y: Float}>) {
        var topmost = data.fold(function(p, top) {
                if(p.y > top.y) return p;
                return top;
            }, data[0]);

        var bottommost = data.fold(function(p, bottom) {
                if(p.y < bottom.y) return p;
                return bottom;
            }, data[0]);
        return this.axisPoints( bottommost.y
                                , topmost.y);
    }

    private function xAxisSprite(xAxis, yAxis, scaled) {
        var sprite = new Axis(xAxis, scaled, true);
        sprite.x = this.pad.x + scaled.translateX(xAxis[0]) - .5;
        sprite.y = this.pad.y + scaled.translateY(yAxis[0]) - .5;
        return sprite;
    }

    private function yAxisSprite(xAxis, yAxis, scaled) {
        var sprite = new Axis(yAxis, scaled, false);
        sprite.x = this.pad.x + scaled.translateX(xAxis[0]) - .5;
        sprite.y = this.pad.y;
        return sprite;
    }

    private function addPlotSelectionSprite(xAxis, yAxis, scaled: Scaled) {
        if(lowBorderAt != null || highBorderAt != null) {
            if(lowBorderAt == null) {
                lowBorderAt = xAxis[0];
            }
            if(highBorderAt == null) {
                highBorderAt = xAxis[xAxis.length - 1];
            }
            var selection = new PlotSelection(scaled.translateX(highBorderAt) 
                                              - scaled.translateX(lowBorderAt)
                                              , scaled.translateY(yAxis[0])
                                              - scaled.translateY(yAxis[yAxis.length - 1]));
            selection.x = this.pad.x + scaled.translateX(lowBorderAt);
            selection.y = this.pad.y;
            addChild(selection);
        }
    }

    private function construct(data:Array<{x: Float, y: Float}>) {

        var xAxis = xAxisPoints(data);
        var yAxis = yAxisPoints(data);

        var scaled = new Scaled({ width: this.w 
                                  , height: this.h
                                  , min: new Point(xAxis[0], yAxis[0])
                                  , max: new Point(xAxis[xAxis.length - 1]
                                                   , yAxis[yAxis.length - 1])
            });
        this.addChild(plotSprite(scaled
                                 , data
                                 , new Point(xAxis[0], yAxis[0])
                                 , new Point(xAxis[xAxis.length - 1], yAxis[0])));

        addPlotSelectionSprite(xAxis, yAxis, scaled);
        this.addChild(xAxisSprite(xAxis, yAxis, scaled));
        this.addChild(yAxisSprite(xAxis, yAxis, scaled));
    }
}