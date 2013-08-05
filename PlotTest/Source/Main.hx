package;

import plot.Plot;
import flash.display.Sprite;
import flash.Lib;
import flash.display.StageQuality;

class Main extends Sprite {
	public function new () {
 		super ();
        Lib.current.stage.quality = StageQuality.BEST;
        var plot = new Plot(Lib.current.stage.stageWidth
                            , Lib.current.stage.stageHeight);
        addChild(plot);
        var data = [for(i in 0 ... 100000) Math.random() * 10];
        plot.plot(data);
	}
}