var ParticleShurikenSample;
(function (ParticleShurikenSample_1) {
    var ParticleShurikenSample = (function () {
        function ParticleShurikenSample() {
            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
            Laya.Stat.show();
            var scene = Laya.stage.addChild(new Laya.Scene());
            var camera = (scene.addChild(new Laya.Camera(0, 0.3, 1000)));
            camera.transform.translate(new Laya.Vector3(0, 0, 100));
            camera.clearColor = null;
            camera.addComponent(CameraMoveScript);
            var grid = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/grid/plane.lh"));
            grid.transform.localScale = new Laya.Vector3(100, 100, 100);
            var particleRoot = Laya.Sprite3D.load("../../res/threeDimen/particle/particleSystem0.lh");
            scene.addChild(particleRoot);
            var particle;
            particleRoot.once(Laya.Event.HIERARCHY_LOADED, null, function () {
                particle = scene.getChildAt(2).getChildAt(0);
                particle.transform.rotate(new Laya.Vector3(-60 / 180 * Math.PI, -50 / 180 * Math.PI, 90 / 180 * Math.PI));
                particle.transform.localPosition = new Laya.Vector3(0, 0, 0);
            });
        }
        return ParticleShurikenSample;
    }());
    ParticleShurikenSample_1.ParticleShurikenSample = ParticleShurikenSample;
})(ParticleShurikenSample || (ParticleShurikenSample = {}));
new ParticleShurikenSample.ParticleShurikenSample();
