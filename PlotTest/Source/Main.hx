package;

import plot.Plot;
import flash.display.Sprite;
import flash.Lib;
import flash.display.StageQuality;

class Main extends Sprite {
    function variable(): Float {
        var p = 0.0;
        for(i in 0...5) {
            p += Math.random() * 10.0;
        }
        return p / 5;
    }
	public function new () {
 		super ();
        Lib.current.stage.quality = StageQuality.BEST;
        var plot = new Plot(Lib.current.stage.stageWidth
                            , Lib.current.stage.stageHeight);
        addChild(plot);
        var data = [for(i in 0 ... 100000) variable()];
        plot.plot(data);
	}
}