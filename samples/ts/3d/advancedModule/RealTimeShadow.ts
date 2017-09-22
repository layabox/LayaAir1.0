class RealTimeShadow {
    private _quaternion: Laya.Quaternion = new Laya.Quaternion();
    private scene: Laya.Scene;
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        this.scene = Laya.stage.addChild(new Laya.Scene());

        var camera: Laya.Camera = (this.scene.addChild(new Laya.Camera(0, 0.1, 100))) as Laya.Camera;
        camera.transform.translate(new Laya.Vector3(0, 0.7, 1.2));
        camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);

        var directionLight: Laya.DirectionLight = this.scene.addChild(new Laya.DirectionLight()) as Laya.DirectionLight;
        directionLight.color = new Laya.Vector3(0.7, 0.6, 0.6);
        directionLight.direction = new Laya.Vector3(0, -1.0, -1.0);

        //灯光开启阴影
        directionLight.shadow = true;
        //可见阴影距离
        directionLight.shadowDistance = 3;
        //生成阴影贴图尺寸
        directionLight.shadowResolution = 2048;
        //生成阴影贴图数量
        directionLight.shadowPSSMCount = 1;
        //模糊等级,越大越高,更耗性能
        directionLight.shadowPCFType = 3;

        Laya.loader.create([
            "../../res/threeDimen/staticModel/grid/plane.lh",
            "../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh"
        ], Laya.Handler.create(this, this.onComplete));

        Laya.timer.frameLoop(1, this, function (): void {
            Laya.Quaternion.createFromYawPitchRoll(0.025, 0, 0, this._quaternion);
            var _direction: Laya.Vector3 = directionLight.direction;
            Laya.Vector3.transformQuat(_direction, this._quaternion, _direction);
            directionLight.direction = _direction;
        });
    }
    private onComplete(): void {

        var grid: Laya.Sprite3D = this.scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/grid/plane.lh")) as Laya.Sprite3D;
        //地面接收阴影
        (grid.getChildAt(0) as Laya.MeshSprite3D).meshRender.receiveShadow = true;

        var staticLayaMonkey: Laya.MeshSprite3D = this.scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/LayaMonkey/Assets/LayaMonkey/LayaMonkey-LayaMonkey.lm"))) as Laya.MeshSprite3D;
        staticLayaMonkey.meshRender.material = Laya.StandardMaterial.load("../../res/threeDimen/skinModel/LayaMonkey/Assets/LayaMonkey/Materials/T_Diffuse.lmat");
        staticLayaMonkey.transform.position = new Laya.Vector3(0, 0, -0.5);
        staticLayaMonkey.transform.localScale = new Laya.Vector3(0.3, 0.3, 0.3);
        staticLayaMonkey.transform.rotation = new Laya.Quaternion(0.7071068, 0, 0, -0.7071067);
        //产生阴影
        staticLayaMonkey.meshRender.castShadow = true;

        var layaMonkey: Laya.Sprite3D = this.scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh")) as Laya.Sprite3D;
        //产生阴影
        (layaMonkey.getChildAt(0).getChildAt(0) as Laya.SkinnedMeshSprite3D).skinnedMeshRender.castShadow = true;

        var mat: Laya.StandardMaterial = (layaMonkey.getChildAt(0).getChildAt(0) as Laya.SkinnedMeshSprite3D).skinnedMeshRender.material as Laya.StandardMaterial;

    }
}
new RealTimeShadow;