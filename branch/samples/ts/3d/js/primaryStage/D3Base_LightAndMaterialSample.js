var LightAndMaterialSample;
(function (LightAndMaterialSample_1) {
    var Browser = Laya.Browser;
    var Vector3 = Laya.Vector3;
    var LightAndMaterialSample = (function () {
        function LightAndMaterialSample() {
            this.tempQuaternion = new Laya.Quaternion();
            this.tempVector3 = new Vector3();
            this.currentLightState = 0;
            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
            Laya.Stat.show();
            this.loadUI();
            this.scene = Laya.stage.addChild(new Laya.Scene());
            var camera = this.scene.addChild(new Laya.Camera(0, 0.1, 100));
            camera.transform.translate(new Laya.Vector3(0, 0.8, 1.0));
            camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
            camera.clearColor = null;
            var _this = this;
            this.directionLight = this.scene.addChild(new Laya.DirectionLight());
            this.directionLight.ambientColor = new Vector3(0.7, 0.6, 0.6);
            this.directionLight.specularColor = new Vector3(1.0, 1.0, 0.9);
            this.directionLight.diffuseColor = new Vector3(1, 1, 1);
            this.directionLight.direction = new Vector3(0, -1.0, -1.0);
            this.currentLight = this.directionLight;
            this.pointLight = new Laya.PointLight();
            this.pointLight.ambientColor = new Vector3(0.8, 0.5, 0.5);
            this.pointLight.specularColor = new Vector3(1.0, 1.0, 0.9);
            this.pointLight.diffuseColor = new Vector3(1, 1, 1);
            this.pointLight.transform.position = new Vector3(0.4, 0.4, 0.0);
            this.pointLight.attenuation = new Vector3(0.0, 0.0, 3.0);
            this.pointLight.range = 3.0;
            this.spotLight = new Laya.SpotLight();
            this.spotLight.ambientColor = new Vector3(1.0, 1.0, 0.8);
            this.spotLight.specularColor = new Vector3(1.0, 1.0, 0.8);
            this.spotLight.diffuseColor = new Vector3(1, 1, 1);
            this.spotLight.transform.position = new Vector3(0.0, 1.2, 0.0);
            this.spotLight.direction = new Vector3(-0.2, -1.0, 0.0);
            this.spotLight.attenuation = new Vector3(0.0, 0.0, 0.8);
            this.spotLight.range = 3.0;
            this.spotLight.spot = 32;
            this.scene.shadingMode = this.currentShadingMode;
            var grid = this.scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/grid/plane.lh"));
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            grid.once(Laya.Event.HIERARCHY_LOADED, null, function (sprite) {
                var meshSprite = sprite.getChildAt(0);
                for (var i = 0; i < meshSprite.meshRender.sharedMaterials.length; i++) {
                    var material = meshSprite.meshRender.sharedMaterials[i];
                    material.diffuseColor = new Vector3(0.7, 0.7, 0.7);
                    material.specularColor = new Laya.Vector4(0.2, 0.2, 0.2, 32);
                }
            });
            var sphere = this.scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/sphere/sphere.lh"));
            sphere.once(Laya.Event.HIERARCHY_LOADED, null, function () {
                sphere.transform.localScale = new Vector3(0.2, 0.2, 0.2);
                sphere.transform.localPosition = new Vector3(0.0, 0.0, 0.2);
            });
            this.skinMesh = this.scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/dude/dude-him.lm")));
            Laya.stage.timer.frameLoop(1, null, function () {
                switch (_this.currentLightState) {
                    case 0:
                        Laya.Quaternion.createFromYawPitchRoll(0.03, 0, 0, _this.tempQuaternion);
                        Vector3.transformQuat(_this.directionLight.direction, _this.tempQuaternion, _this.directionLight.direction);
                        break;
                    case 1:
                        Laya.Quaternion.createFromYawPitchRoll(0.03, 0, 0, _this.tempQuaternion);
                        Vector3.transformQuat(_this.pointLight.transform.position, _this.tempQuaternion, _this.tempVector3);
                        _this.pointLight.transform.position = _this.tempVector3;
                        break;
                    case 2:
                        Laya.Quaternion.createFromYawPitchRoll(0.03, 0, 0, _this.tempQuaternion);
                        Vector3.transformQuat(_this.spotLight.transform.position, _this.tempQuaternion, _this.tempVector3);
                        _this.spotLight.transform.position = _this.tempVector3;
                        Vector3.transformQuat(_this.spotLight.direction, _this.tempQuaternion, _this.spotLight.direction);
                        break;
                }
            });
        }
        LightAndMaterialSample.prototype.loadUI = function () {
            var _this = this;
            Laya.loader.load(["../../res/threeDimen/ui/button.png"], Laya.Handler.create(null, function () {
                _this.buttonLight = new Laya.Button();
                _this.buttonLight.skin = "../../res/threeDimen/ui/button.png";
                _this.buttonLight.label = "平行光";
                _this.buttonLight.labelBold = true;
                _this.buttonLight.labelSize = 20;
                _this.buttonLight.sizeGrid = "4,4,4,4";
                _this.buttonLight.size(120, 30);
                _this.buttonLight.scale(Browser.pixelRatio, Browser.pixelRatio);
                _this.buttonLight.pos(Laya.stage.width / 2 - _this.buttonLight.width * Browser.pixelRatio / 2, Laya.stage.height - 100 * Browser.pixelRatio);
                _this.buttonLight.on(Laya.Event.CLICK, _this, _this.onclickButtonLight);
                Laya.stage.addChild(_this.buttonLight);
                _this.shadingLight = new Laya.Button();
                _this.shadingLight.skin = "../../res/threeDimen/ui/button.png";
                _this.shadingLight.label = "像素着色";
                _this.shadingLight.labelBold = true;
                _this.shadingLight.labelSize = 20;
                _this.shadingLight.sizeGrid = "4,4,4,4";
                _this.shadingLight.size(120, 30);
                _this.shadingLight.scale(Browser.pixelRatio, Browser.pixelRatio);
                _this.shadingLight.pos(Laya.stage.width / 2 - _this.shadingLight.width * Browser.pixelRatio / 2, Laya.stage.height - 50 * Browser.pixelRatio);
                _this.shadingLight.on(Laya.Event.CLICK, _this, _this.onclickButtonShading);
                Laya.stage.addChild(_this.shadingLight);
                Laya.stage.on(Laya.Event.RESIZE, null, function () {
                    _this.buttonLight.pos(Laya.stage.width / 2 - _this.buttonLight.width * Browser.pixelRatio / 2, Laya.stage.height - 100 * Browser.pixelRatio);
                    _this.shadingLight.pos(Laya.stage.width / 2 - _this.shadingLight.width * Browser.pixelRatio / 2, Laya.stage.height - 50 * Browser.pixelRatio);
                });
            }));
        };
        LightAndMaterialSample.prototype.onclickButtonShading = function () {
            this.currentShadingMode++;
            (this.currentShadingMode > Laya.BaseScene.PIXEL_SHADING) && (this.currentShadingMode = Laya.BaseScene.VERTEX_SHADING);
            if (this.currentShadingMode == Laya.BaseScene.VERTEX_SHADING) {
                this.shadingLight.label = "顶点着色";
            }
            else {
                this.shadingLight.label = "像素着色";
            }
            this.scene.shadingMode = this.currentShadingMode;
        };
        LightAndMaterialSample.prototype.onclickButtonLight = function () {
            this.currentLightState++;
            (this.currentLightState > 2) && (this.currentLightState = 0);
            this.currentLight.removeSelf();
            switch (this.currentLightState) {
                case 0:
                    this.buttonLight.label = "平行光";
                    this.currentLight = this.directionLight;
                    this.scene.addChild(this.directionLight);
                    break;
                case 1:
                    this.buttonLight.label = "点光源";
                    this.currentLight = this.pointLight;
                    this.scene.addChild(this.pointLight);
                    break;
                case 2:
                    this.buttonLight.label = "聚光灯";
                    this.currentLight = this.spotLight;
                    this.scene.addChild(this.spotLight);
                    break;
            }
        };
        return LightAndMaterialSample;
    }());
    LightAndMaterialSample_1.LightAndMaterialSample = LightAndMaterialSample;
})(LightAndMaterialSample || (LightAndMaterialSample = {}));
new LightAndMaterialSample.LightAndMaterialSample();
