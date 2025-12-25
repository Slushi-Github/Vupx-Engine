package source;

import vupx.core.VpConstants;
import vupx.objects.VpText;
import vupx.states.VpState;
import vupx.Vupx;

class TestState extends VpState {
	var txt:VpText;

	override public function create():Void {
		// Create a text object
		txt = new VpText(0, 0, "Hello World!", VpConstants.VUPX_DEFAULT_FONT_PATH, 32);
		txt.center(); // Center the text on the screen
		add(txt); // Add the text object to the state
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		var speed:Float = 200 * elapsed;

		// Move the text
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

		// Rotate the text
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

		// Move text in Z axis
        if (Vupx.controller.isPressed(ZR)) {
            txt.z += speed;
        }
        else if (Vupx.controller.isPressed(R)) {
            txt.z -= speed;
        }
	}
}