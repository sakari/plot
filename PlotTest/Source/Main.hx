package;

import plot.Plot;
import flash.display.Sprite;
import flash.Lib;
import flash.display.StageQuality;
import sakari.random.distributions.Normal;

class Main extends Sprite {
    
	public function new () {
 		super ();
        Lib.current.stage.quality = StageQuality.BEST;
        var plot = new Plot(Lib.current.stage.stageWidth
                            , Lib.current.stage.stageHeight);
        addChild(plot);
        
        var dist = new Normal()
            .area(.9, 3, 5);
        var data = [for(i in 0 ... 100000) dist.generate()];
        plot
            .colour(0xff0000, 0.5)
            .data(data)
            .selectOver(3)
            .plot();
	}
}