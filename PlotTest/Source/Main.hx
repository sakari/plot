package;

import plot.Plot;
import flash.display.Sprite;
import flash.Lib;

class Main extends Sprite {
	public function new () {
 		super ();
        var plot = new Plot(Lib.current.stage.stageWidth
                            , Lib.current.stage.stageHeight);
        addChild(plot);
        var data = [for(i in 0 ... 1000) Math.random() * 100];
        plot.plot(data);
	}
}