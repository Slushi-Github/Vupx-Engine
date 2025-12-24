package source;

import vupx.VupxEngine;

class Main {
	public static function main():Void {
		VupxEngine.init("ProjectExample", new TestState(), false);
	}
}