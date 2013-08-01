package;

import plot.Plot;
import flash.display.Sprite;


class Main extends Sprite {
	public function new () {
 		super ();
        var plot = new Plot(300, 100);
        addChild(plot);
        var data = [1, 1.1, 1.5, 2, 2.2, 4, 5, 6.1];
        plot.plot(data);
	}
}