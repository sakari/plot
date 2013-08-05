package plot;
import flash.geom.Point;

class Scaled {
    private var w: Float;
    private var h: Float;
    private var min: Point;
    private var max: Point;
    private var x_scale: Float;
    private var y_scale: Float;

    public function new(opt: {width: Float, height: Float, min: Point, max: Point}) {
        this.w = opt.width;
        this.h = opt.height;
        this.min = opt.min;
        this.max = opt.max;

        this.x_scale = this.w / (this.max.x - this.min.x);
        this.y_scale = this.h / (this.max.y - this.min.y);
    }

    public function translate(x: Float, y: Float): Point {
        return new Point(this.translateX(x), this.translateY(y));
    }

    public function translateX(x): Float {
        if(x < this.min.x || x > this.max.x)
            throw 'point outside X range: $x';
        return Math.floor((x - this.min.x) * this.x_scale) + .5;
    }

    public function translateY(y): Float {
        if(y < this.min.y || y > this.max.y)
            throw 'point outside Y range: $y';
        return Math.floor((this.max.y - y) * this.y_scale) + .5;
    }

}