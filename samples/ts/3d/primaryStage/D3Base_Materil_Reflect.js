var Materil_Reflect;
(function (Materil_Reflect_1) {
    var Vector3 = Laya.Vector3;
    var Vector4 = Laya.Vector4;
    var Materil_Reflect = (function () {
        function Materil_Reflect() {
            var _this = this;
            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
            Laya.Stat.show();
            var scene = Laya.stage.addChild(new Laya.Scene());
            scene.shadingMode = Laya.BaseScene.PIXEL_SHADING;
            var camera = (scene.addChild(new Laya.Camera(0, 0.1, 100)));
            camera.transform.translate(new Laya.Vector3(0, 1.8, 2.0));
            camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
            camera.clearFlag = Laya.BaseCamera.CLEARFLAG_SKY;
            var skyBox = new Laya.SkyBox();
            camera.sky = skyBox;
            camera.addComponent(CameraMoveScript);
            var sprit = scene.addChild(new Laya.Sprite3D());
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var mesh = Laya.Mesh.load("../../res/threeDimen/staticModel/teapot/teapot-Teapot001.lm");
            var meshSprite = sprit.addChild(new Laya.MeshSprite3D(mesh));
            mesh.once(Laya.Event.LOADED, this, function () {
                meshSprite.meshRender.sharedMaterials[0].once(Laya.Event.LOADED, _this, function () {
                    _this.material = meshSprite.meshRender.sharedMaterials[0];
                    ;
                    _this.material.albedo = new Vector4(0.0, 0.0, 0.0, 0.0);
                    _this.material.renderMode = Laya.BaseMaterial.RENDERMODE_OPAQUEDOUBLEFACE;
                    (_this.material && _this.cubeTexture) && (_this.material.reflectTexture = _this.cubeTexture);
                });
            });
            meshSprite.transform.localPosition = new Vector3(-0.3, 0.0, 0.0);
            meshSprite.transform.localScale = new Vector3(0.5, 0.5, 0.5);
            meshSprite.transform.localRotation = new Laya.Quaternion(-0.7071068, 0.0, 0.0, 0.7071068);
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            Laya.loader.load("../../res/threeDimen/skyBox/px.jpg,../../res/threeDimen/skyBox/nx.jpg,../../res/threeDimen/skyBox/py.jpg,../../res/threeDimen/skyBox/ny.jpg,../../res/threeDimen/skyBox/pz.jpg,../../res/threeDimen/skyBox/nz.jpg", Laya.Handler.create(this, function (texture) {
                this.cubeTexture = texture;
                (this.material && this.cubeTexture) && (meshSprite.meshRender.sharedMaterials[0].reflectTexture = texture);
                console.log(meshSprite.meshRender.sharedMaterials[0].reflectTexture);
                skyBox.textureCube = texture;
            }), null, Laya.Loader.TEXTURECUBE);
            Laya.timer.frameLoop(1, this, function () {
                meshSprite.transform.rotate(new Vector3(0, 0.01, 0), false);
            });
        }
        return Materil_Reflect;
    }());
    Materil_Reflect_1.Materil_Reflect = Materil_Reflect;
})(Materil_Reflect || (Materil_Reflect = {}));
new Materil_Reflect.Materil_Reflect();
