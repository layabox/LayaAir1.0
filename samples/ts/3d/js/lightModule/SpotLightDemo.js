var SpotLightDemo = /** @class */ (function () {
    function SpotLightDemo() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        this.scene = new Laya.Scene();
        Laya.stage.addChild(this.scene);
        this._quaternion = new Laya.Quaternion();
        this._position = new Laya.Vector3();
        var camera = (this.scene.addChild(new Laya.Camera(0, 0.1, 1000)));
        camera.transform.translate(new Laya.Vector3(0, 0.7, 1.3));
        camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);
        camera.addComponent(CameraMoveScript);
        //聚光灯
        var spotLight = this.scene.addChild(new Laya.SpotLight());
        spotLight.color = new Laya.Vector3(1, 1, 0);
        spotLight.transform.position = new Laya.Vector3(0.0, 1.2, 0.0);
        spotLight.direction = new Laya.Vector3(0.15, -1.0, 0.0);
        spotLight.attenuation = new Laya.Vector3(0.0, 0.0, 0.8);
        spotLight.range = 6.0;
        spotLight.spot = 32;
        var grid = this.scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/grid/plane.lh"));
        var layaMonkey = this.scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh"));
        layaMonkey.once(Laya.Event.HIERARCHY_LOADED, this, function () {
            var aniSprite3d = layaMonkey.getChildAt(0);
            var animator = aniSprite3d.getComponentByType(Laya.Animator);
            animator.play(null, 1.0, 115, 150);
        });
        Laya.timer.frameLoop(1, this, function () {
            Laya.Quaternion.createFromYawPitchRoll(0.025, 0, 0, this._quaternion);
            Laya.Vector3.transformQuat(spotLight.transform.position, this._quaternion, this._position);
            spotLight.transform.position = this._position;
            var _direction = spotLight.direction;
            Laya.Vector3.transformQuat(_direction, this._quaternion, _direction);
            spotLight.direction = _direction;
        });
    }
    return SpotLightDemo;
}());
new SpotLightDemo;
