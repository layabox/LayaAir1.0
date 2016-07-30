var Materil_Reflect;
(function (Materil_Reflect_1) {
    var Vector3 = Laya.Vector3;
    var Materil_Reflect = (function () {
        function Materil_Reflect() {
            var _this = this;
            //是否抗锯齿
            //Config.isAntialias = true;
            Laya3D.init(0, 0);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
            Laya.Stat.show();
            var scene = Laya.stage.addChild(new Laya.Scene());
            scene.shadingMode = Laya.BaseScene.PIXEL_SHADING;
            scene.currentCamera = (scene.addChild(new Laya.Camera(0, 0.1, 100)));
            scene.currentCamera.transform.translate(new Vector3(0, 0.8, 1.5));
            scene.currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);
            var sprit = scene.addChild(new Laya.Sprite3D());
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var mesh = Laya.Mesh.load("../../res/threeDimen/staticModel/teapot/teapot-Teapot001.lm");
            this.meshSprite = sprit.addChild(new Laya.MeshSprite3D(mesh));
            mesh.once(Laya.Event.LOADED, this, function () {
                _this.meshSprite.materials[0].once(Laya.Event.LOADED, _this, function () {
                    _this.material = _this.meshSprite.materials[0];
                    _this.material.luminance = 0;
                    _this.material.cullFace = false;
                    (_this.material && _this.reflectTexture) && (_this.material.reflectTexture = _this.reflectTexture);
                });
            });
            this.meshSprite.transform.localPosition = new Vector3(-0.3, 0.0, 0.0);
            this.meshSprite.transform.localScale = new Vector3(0.5, 0.5, 0.5);
            this.meshSprite.transform.localRotation = new Laya.Quaternion(-0.7071068, 0.0, 0.0, 0.7071068);
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var webGLImageCube = new Laya.WebGLImageCube(["../../res/threeDimen/skyBox/px.jpg", "../../res/threeDimen/skyBox/nx.jpg", "../../res/threeDimen/skyBox/py.jpg", "../../res/threeDimen/skyBox/ny.jpg", "../../res/threeDimen/skyBox/pz.jpg", "../../res/threeDimen/skyBox/nz.jpg"], 1024);
            webGLImageCube.on(Laya.Event.LOADED, this, function (imgCube) {
                _this.reflectTexture = new Laya.Texture(imgCube);
                imgCube.mipmap = true;
                (_this.material && _this.reflectTexture) && (_this.meshSprite.materials[0].reflectTexture = _this.reflectTexture);
            });
            Laya.timer.frameLoop(1, this, function () {
                _this.meshSprite.transform.rotate(new Vector3(0, 0.01, 0), false);
            });
        }
        return Materil_Reflect;
    }());
    Materil_Reflect_1.Materil_Reflect = Materil_Reflect;
})(Materil_Reflect || (Materil_Reflect = {}));
new Materil_Reflect.Materil_Reflect();
