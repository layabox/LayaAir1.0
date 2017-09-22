class DirectionLightDemo {
    private scene: Laya.Scene;
    private _quaternion: Laya.Quaternion;
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        this.scene = new Laya.Scene()
        Laya.stage.addChild(this.scene);

        this._quaternion = new Laya.Quaternion();
        var camera: Laya.Camera = (this.scene.addChild(new Laya.Camera(0, 0.1, 1000))) as Laya.Camera;
        camera.transform.translate(new Laya.Vector3(0, 0.7, 1.3));
        camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);
        camera.addComponent(CameraMoveScript);

        //方向光
        var directionLight: Laya.DirectionLight = this.scene.addChild(new Laya.DirectionLight()) as Laya.DirectionLight;
        directionLight.color = new Laya.Vector3(0.7, 0.6, 0.6);
        directionLight.direction = new Laya.Vector3(0, -1.0, -1.0);

        var grid: Laya.Sprite3D = this.scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/grid/plane.lh")) as Laya.Sprite3D;

        var layaMonkey: Laya.Sprite3D = this.scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh")) as Laya.Sprite3D;
        layaMonkey.once(Laya.Event.HIERARCHY_LOADED, this, function (): void {
            var aniSprite3d: Laya.Sprite3D = layaMonkey.getChildAt(0) as Laya.Sprite3D;
            var animator: Laya.Animator = aniSprite3d.getComponentByType(Laya.Animator) as Laya.Animator;
            animator.play(null, 1.0, 40, 70);
        });

        Laya.timer.frameLoop(1, this, function (): void {
            Laya.Quaternion.createFromYawPitchRoll(0.025, 0, 0, this._quaternion);
            var _direction: Laya.Vector3 = directionLight.direction;
            Laya.Vector3.transformQuat(_direction, this._quaternion, _direction);
            directionLight.direction = _direction;
        });
    }
}
new DirectionLightDemo;