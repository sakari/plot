package;

import plot.Plot;
import flash.display.Sprite;


class Main extends Sprite {
	public function new () {
 		super ();
        var plot = new Plot(300, 300);
        addChild(plot);
        var data = [for(i in 0 ... 1000) Math.random() * 100];
        plot.plot(data);
	}
}