package source;

import vupx.Vupx;
import vupx.objects.VpText;
import vupx.states.VpState;

class TestState extends VpState {
	var txt:VpText;

	override public function create():Void {
		txt = new VpText(100, 100, "Hello World!", VpConstants.VUPX_DEFAULT_FONT_PATH, 32);
		txt.center();
		add(txt);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		var speed:Float = 200 * elapsed;

		if (Vupx.controller.isPressed(LEFT)) {
			txt.x -= speed;
		}
		else if (Vupx.controller.isPressed(RIGHT)) {
			txt.x += speed;
		}
		else if (Vupx.controller.isPressed(UP)) {
			txt.y += speed;
		} 
        else if (Vupx.controller.isPressed(DOWN)) {
			txt.y -= speed;
		}

		if (Vupx.controller.isPressed(Y)) {
			txt.rotationY += speed;
		}
		else if (Vupx.controller.isPressed(A)) {
			txt.rotationY -= speed;
		}
        else if (Vupx.controller.isPressed(X)) {
            txt.rotationX += speed;
        }
        else if (Vupx.controller.isPressed(B)) {
            txt.rotationX -= speed;
        }

        if (Vupx.controller.isPressed(ZR)) {
            txt.z += speed;
        }
        else if (Vupx.controller.isPressed(R)) {
            txt.z -= speed;
        }
	}
}