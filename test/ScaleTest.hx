package;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import flash.geom.Point;
import plot.Scaled;

class ScaleTest
{	
    var scaled: Scaled;

	@Before
	public function setup():Void {
        this.scaled = new Scaled({width: 10 
                             , height: 20
                             , min: new Point(1, 2) 
                             , max: new Point(3, 4)
            });
	}
	
	@After
	public function tearDown():Void
	{
	}
	
	
	@Test
	public function translate_keeps_x_axis(): Void
	{
        var translated = this.scaled.translate(1, 2);
        Assert.areEqual(0, translated.x);
	}

    @Test
    public function translate_flips_y_axis(): Void {
        var t = this.scaled.translate(1, 4);
        Assert.areEqual(0, t.y);
    }

    @Test
    public function translate_throws_for_points_under_the_minimum(): Void {
        var err = false;
        try {
            this.scaled.translate(0, 0);
        } catch(msg: String) {
            err = true;
        }
        Assert.isTrue(err);
    }

    @Test
    public function translate_throws_for_points_over_the_maximum(): Void {
        var err = false;
        try {
            this.scaled.translate(10, 10);
        } catch(msg: String) {
            err = true;
        }
        Assert.isTrue(err);
    }

    @Test
    public function translate_scales_the_point(): Void {
        var t = this.scaled.translate(3, 2);
        Assert.areEqual(10, t.x);
        Assert.areEqual(20, t.y);
    }

    
}