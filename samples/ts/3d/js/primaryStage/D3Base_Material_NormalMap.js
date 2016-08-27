var Material_NormalMap;
(function (Material_NormalMap_1) {
    var Vector3 = Laya.Vector3;
    var Material_NormalMap = (function () {
        function Material_NormalMap() {
            var _this = this;
            this.rotation = new Vector3(0, 0.01, 0);
            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
            Laya.Stat.show();
            var scene = Laya.stage.addChild(new Laya.Scene());
            scene.shadingMode = Laya.BaseScene.PIXEL_SHADING;
            scene.currentCamera = (scene.addChild(new Laya.Camera(0, 0.1, 100)));
            scene.currentCamera.transform.translate(new Vector3(0, 0.8, 1.6));
            scene.currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);
            scene.currentCamera.addComponent(CameraMoveScript);
            var directionLight = scene.addChild(new Laya.DirectionLight());
            directionLight.direction = new Vector3(0, -0.8, -1);
            directionLight.ambientColor = new Vector3(0.7, 0.6, 0.6);
            directionLight.specularColor = new Vector3(1.0, 1.0, 0.8);
            directionLight.diffuseColor = new Vector3(1, 1, 1);
            this.root = scene.addChild(new Laya.Sprite3D());
            this.root.transform.localScale = new Vector3(0.2, 0.2, 0.2);
            this.loadModel("../../res/threeDimen/staticModel/lizard/lizard-lizard_geo.lm", "../../res/threeDimen/staticModel/lizard/lizard_norm.png");
            this.loadModel("../../res/threeDimen/staticModel/lizard/lizard-eye_geo.lm", "../../res/threeDimen/staticModel/lizard/lizardeye_norm.png");
            this.loadModel("../../res/threeDimen/staticModel/lizard/lizard-rock_geo.lm", "../../res/threeDimen/staticModel/lizard/rock_norm.png");
            Laya.timer.frameLoop(1, this, function () {
                _this.root.transform.rotate(_this.rotation, true);
            });
        }
        Material_NormalMap.prototype.loadModel = function (meshPath, normalMapPath) {
            var normalTexture;
            var material;
            var mesh = Laya.Mesh.load(meshPath);
            var meshSprite = this.root.addChild(new Laya.MeshSprite3D(mesh));
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            mesh.once(Laya.Event.LOADED, null, function () {
                meshSprite.meshRender.shadredMaterials[0].once(Laya.Event.LOADED, null, function () {
                    material = meshSprite.meshRender.shadredMaterials[0];
                    (material && normalTexture) && (material.normalTexture = normalTexture);
                });
            });
            Laya.loader.load(normalMapPath, Laya.Handler.create(null, function (texture) {
                normalTexture = texture;
                (material && normalTexture) && (material.normalTexture = normalTexture);
            }));
        };
        return Material_NormalMap;
    }());
    Material_NormalMap_1.Material_NormalMap = Material_NormalMap;
})(Material_NormalMap || (Material_NormalMap = {}));
new Material_NormalMap.Material_NormalMap();
