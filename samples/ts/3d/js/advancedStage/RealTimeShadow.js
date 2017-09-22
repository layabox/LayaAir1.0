var RealTimeShadow = (function () {
    function RealTimeShadow() {
        this._quaternion = new Laya.Quaternion();
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        this.scene = Laya.stage.addChild(new Laya.Scene());
        var camera = (this.scene.addChild(new Laya.Camera(0, 0.1, 100)));
        camera.transform.translate(new Laya.Vector3(0, 0.7, 1.2));
        camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);
        var directionLight = this.scene.addChild(new Laya.DirectionLight());
        directionLight.ambientColor = new Laya.Vector3(0.7, 0.6, 0.6);
        directionLight.specularColor = new Laya.Vector3(1.0, 1.0, 1.0);
        directionLight.diffuseColor = new Laya.Vector3(1, 1, 1);
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
        Laya.timer.frameLoop(1, this, function () {
            Laya.Quaternion.createFromYawPitchRoll(0.025, 0, 0, this._quaternion);
            var _direction = directionLight.direction;
            Laya.Vector3.transformQuat(_direction, this._quaternion, _direction);
            directionLight.direction = _direction;
        });
    }
    RealTimeShadow.prototype.onComplete = function () {
        var grid = this.scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/grid/plane.lh"));
        //地面接收阴影
        grid.getChildAt(0).meshRender.receiveShadow = true;
        var staticLayaMonkey = this.scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/LayaMonkey/Assets/LayaMonkey/LayaMonkey-LayaMonkey.lm")));
        staticLayaMonkey.meshRender.material = Laya.StandardMaterial.load("../../res/threeDimen/skinModel/LayaMonkey/Assets/LayaMonkey/Materials/T_Diffuse.lmat");
        staticLayaMonkey.transform.position = new Laya.Vector3(0, 0, -0.5);
        staticLayaMonkey.transform.localScale = new Laya.Vector3(0.3, 0.3, 0.3);
        staticLayaMonkey.transform.rotation = new Laya.Quaternion(0.7071068, 0, 0, -0.7071067);
        //产生阴影
        staticLayaMonkey.meshRender.castShadow = true;
        var layaMonkey = this.scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh"));
        //产生阴影
        layaMonkey.getChildAt(0).getChildAt(0).skinnedMeshRender.castShadow = true;
        var mat = layaMonkey.getChildAt(0).getChildAt(0).skinnedMeshRender.material;
    };
    return RealTimeShadow;
}());
new RealTimeShadow;
