package vupx.states.internalStates;

class VupxIntro extends VpState {
    private var text:VpText;
    private var engineBasesSprite:VpSprite;

    private var initialState:VpState;

    public function new(initialState:VpState):Void {
        super();
        this.initialState = initialState;
    }

    override public function create():Void {
        super.create();

        engineBasesSprite = new VpSprite(0, 0);
        engineBasesSprite.loadImage(VpStorage.getRomFSPath() + "VUPX_ASSETS/images/engineBases.png");
        engineBasesSprite.center();
        engineBasesSprite.y -= 70;
        engineBasesSprite.alpha = 0;
        add(engineBasesSprite);
        
        text = new VpText(0, 0, "Vupx Engine", VpConstants.VUPX_SPARTAN_MB_EXTB_FONT_PATH, 90);
        text.center();
        text.y += 70;
        text.alpha = 0;
        add(text);

        var text2 = new VpText(0, 0, "Version " + VupxEngine.VERSION, VpConstants.VUPX_SPARTAN_MB_EXTB_FONT_PATH, 35);
        text2.center(CENTER_X);
        text2.y += 480;
        text2.alpha = 0;
        add(text2);

        VpTimer.after(1.5, function() {
            VpTween.tween(text, {alpha: 1}, 1.4, VpEase.linear);
        });

        VpTimer.after(2, function() {
            VpTween.tween(text2, {alpha: 0.6}, 1.4, VpEase.linear);
            VpTween.tween(engineBasesSprite, {
                        alpha: 0.4,
                        x: engineBasesSprite.x - 30,
                    }, 1.4, VpEase.linear, {
                        onComplete: function(tween) {
                            VpTimer.after(2, function () {
                                VpTween.tween(engineBasesSprite, {alpha: 0}, 1.2, VpEase.linear);
                                VpTween.tween(text2, {alpha: 0}, 1.2, VpEase.linear);
                                VpTween.tween(text, {alpha: 0}, 1.2, VpEase.linear, {
                                    onComplete: function(tween) {
                                        VpTimer.after(1, function () {
                                            Vupx.switchState(this.initialState);
                                        });
                                    }});
                            });
                        }
                    });
        });
    }
}