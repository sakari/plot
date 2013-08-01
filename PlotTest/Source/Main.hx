package;

import plot.Plot;
import flash.display.Sprite;


class Main extends Sprite {
	public function new () {
 		super ();
        var plot = new Plot(300, 100);
        addChild(plot);
        var data = new Array<{x: Float, y: Float}>();
        data.push({x: 1, y: 1});
        data.push({x: 2, y: 4});
        data.push({x: 3, y: 2});
        data.push({x: 4, y: 3});
        data.push({x: 5, y: 5});
        plot.plot(data);
	}
}