package plot;

import flash.display.Sprite;
import flash.text.TextField;
import plot.Scaled;

using Lambda;

private typedef Label = {
 field: TextField
 , tick: Float 
}

class Axis extends Sprite {


    var horizontal: Bool;
    var scaled: Scaled;
    var labels: Array<Label>;

    public function new(ticks: Array<Float>
                        , scaled: Scaled
                        , horizontal: Bool) {
        super();
        this.scaled = scaled;
        this.horizontal = horizontal;
        trace('uuu');
        this.labels = Axis.makeLabels(ticks);
        trace('aa');
        this.construct();
    }

    static function makeLabels(ticks: Array<Float>): Array<Label>  {
        var labels = [];
        for(t in ticks) {
            var field = new TextField();
            field.text = '$t';
            labels.push({field: field, tick: t});
        }
        return labels;
    }

    function leftPad(): Float {
        return this.labels.fold(function(l: Label, max: Label) {
                if(l.field.textWidth > max.field.textWidth) return l;
                return max;
            }, this.labels[0]).field.textWidth + 5;
    }

    function bottomPad(): Float {
        return this.labels.fold(function(l: Label, max: Label) {
                if(l.field.textHeight > max.field.textHeight) return l;
                return max;
            }, this.labels[0]).field.textWidth;
    }

    function construct() {
        var pad = this.horizontal ? this.bottomPad() : -this.leftPad();
        this.graphics.lineStyle(1, 0x000000);
        for(label in this.labels) {
            if(this.horizontal)  {
                this.graphics.lineTo(this.scaled.translateX(label.tick), 0);
            } else {
                this.graphics.lineTo(0, this.scaled.translateY(label.tick));
            }
        }
        for(label in this.labels) {
            this.addChild(label.field);
            if(this.horizontal) {
                this.graphics.moveTo(this.scaled.translateX(label.tick), 0);
                this.graphics.lineTo(this.scaled.translateX(label.tick), -5); 
                label.field.x = this.scaled.translateX(label.tick);
                label.field.y = pad;
            } else {
                this.graphics.moveTo(0, this.scaled.translateY(label.tick));
                this.graphics.lineTo(5, this.scaled.translateY(label.tick)); 
                label.field.x = pad;
                label.field.y = this.scaled.translateY(label.tick);
            }

        }

    }
}