class PointLightDemo {
    private scene: Laya.Scene;
    private _position: Laya.Vector3;
    private _quaternion: Laya.Quaternion;
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        this.scene = new Laya.Scene();
        Laya.stage.addChild(this.scene);

        this._position = new Laya.Vector3();
        this._quaternion = new Laya.Quaternion();

        var camera: Laya.Camera = (this.scene.addChild(new Laya.Camera(0, 0.1, 1000))) as Laya.Camera;
        camera.transform.translate(new Laya.Vector3(0, 0.7, 1.3));
        camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);
        camera.addComponent(CameraMoveScript);

        //点光
        var pointLight: Laya.PointLight = this.scene.addChild(new Laya.PointLight()) as Laya.PointLight;
        pointLight.color = new Laya.Vector3(0.1189446, 0.5907708, 0.7352941);
        pointLight.transform.position = new Laya.Vector3(0.4, 0.4, 0.0);
        pointLight.attenuation = new Laya.Vector3(0.0, 0.0, 3.0);
        pointLight.range = 3.0;

        var grid: Laya.Sprite3D = this.scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/grid/plane.lh")) as Laya.Sprite3D;

        var layaMonkey: Laya.Sprite3D = this.scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh")) as Laya.Sprite3D;
        layaMonkey.once(Laya.Event.HIERARCHY_LOADED, this, function (): void {
            var aniSprite3d: Laya.Sprite3D = layaMonkey.getChildAt(0) as Laya.Sprite3D;
            var animator: Laya.Animator = aniSprite3d.getComponentByType(Laya.Animator) as Laya.Animator;
            animator.play(null, 1.0, 75, 110);
        });

        Laya.timer.frameLoop(1, this, function (): void {

            Laya.Quaternion.createFromYawPitchRoll(0.025, 0, 0, this._quaternion);
            Laya.Vector3.transformQuat(pointLight.transform.position, this._quaternion, this._position);
            pointLight.transform.position = this._position;
        });
    }
}
new PointLightDemo;