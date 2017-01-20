var SimpleSceneSample;
(function (SimpleSceneSample_1) {
    var Vector2 = Laya.Vector2;
    var Vector3 = Laya.Vector3;
    var Vector4 = Laya.Vector4;
    var Event = Laya.Event;
    var Sprite3D = Laya.Sprite3D;
    var SimpleSceneSample = (function () {
        function SimpleSceneSample() {
            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
            Laya.Stat.show();
            var scene = Laya.stage.addChild(new Laya.Scene());
            var camera = new Laya.Camera(0, 0.1, 100);
            camera = scene.addChild(camera);
            camera.transform.translate(new Vector3(0.3, 0.3, 0.6));
            camera.transform.rotate(new Vector3(-12, 0, 0), true, false);
            camera.clearColor = null;
            camera.clearFlag = Laya.BaseCamera.CLEARFLAG_SKY;
            camera.addComponent(CameraMoveScript);
            this.loadScene(scene, camera);
        }
        SimpleSceneSample.prototype.loadScene = function (scene, camera) {
            var root = scene.addChild(new Sprite3D());
            root.transform.localScale = new Vector3(10, 10, 10);
            var skyBox = new Laya.SkyBox();
            camera.sky = skyBox;
            skyBox.textureCube = Laya.TextureCube.load("../../res/threeDimen/skyBox/skyCube.ltc");
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var singleFaceTransparent0 = root.addChild(Sprite3D.load("../../res/threeDimen/staticModel/simpleScene/B00IT004M.v3f.lh"));
            singleFaceTransparent0.once(Event.HIERARCHY_LOADED, this, function (sprite) {
                this.setMeshParams(sprite, Laya.StandardMaterial.RENDERMODE_CUTOUT, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var singleFaceTransparent1 = root.addChild(Sprite3D.load("../../res/threeDimen/staticModel/simpleScene/B00IT003M000.v3f.lh"));
            singleFaceTransparent1.once(Event.HIERARCHY_LOADED, this, function (sprite) {
                this.setMeshParams(sprite, Laya.StandardMaterial.RENDERMODE_CUTOUT, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var meshSprite3d0 = root.addChild(Sprite3D.load("../../res/threeDimen/staticModel/simpleScene/B00IT001M000.v3f.lh"));
            meshSprite3d0.once(Event.HIERARCHY_LOADED, this, function (sprite) {
                this.setMeshParams(sprite, Laya.StandardMaterial.RENDERMODE_OPAQUE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var meshSprite3d1 = root.addChild(Sprite3D.load("../../res/threeDimen/staticModel/simpleScene/B00IT002M000.v3f.lh"));
            meshSprite3d1.once(Event.HIERARCHY_LOADED, this, function (sprite) {
                this.setMeshParams(sprite, Laya.StandardMaterial.RENDERMODE_OPAQUE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var meshSprite3d2 = root.addChild(Sprite3D.load("../../res/threeDimen/staticModel/simpleScene/B00IT008M.v3f.lh"));
            meshSprite3d2.once(Event.HIERARCHY_LOADED, this, function (sprite) {
                this.setMeshParams(sprite, Laya.StandardMaterial.RENDERMODE_OPAQUE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var meshSprite3d3 = root.addChild(Sprite3D.load("../../res/threeDimen/staticModel/simpleScene/B00MP003M.v3f.lh"));
            meshSprite3d3.once(Event.HIERARCHY_LOADED, this, function (sprite) {
                this.setMeshParams(sprite, Laya.StandardMaterial.RENDERMODE_OPAQUE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var doubleFaceTransparent = root.addChild(Sprite3D.load("../../res/threeDimen/staticModel/simpleScene/B00IT005M.v3f.lh"));
            doubleFaceTransparent.once(Event.HIERARCHY_LOADED, this, function (sprite) {
                this.setMeshParams(doubleFaceTransparent, Laya.StandardMaterial.RENDERMODE_CUTOUTDOUBLEFACE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var terrainSpirit0 = root.addChild(Sprite3D.load("../../res/threeDimen/staticModel/simpleScene/B00MP001M.v3f.lh"));
            terrainSpirit0.once(Event.HIERARCHY_LOADED, this, function (sprite) {
                this.setMeshParams(terrainSpirit0, Laya.StandardMaterial.RENDERMODE_OPAQUE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6823, 0.6549, 0.6352), new Vector2(25.0, 25.0), "TERRAIN");
            });
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var terrainSpirit1 = root.addChild(Sprite3D.load("../../res/threeDimen/staticModel/simpleScene/B00MP002M.v3f.lh"));
            terrainSpirit1.once(Event.HIERARCHY_LOADED, this, function (sprite) {
                this.setMeshParams(terrainSpirit1, Laya.StandardMaterial.RENDERMODE_OPAQUE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6823, 0.6549, 0.6352), new Vector2(25.0, 25.0), "TERRAIN");
            });
        };
        SimpleSceneSample.prototype.setMeshParams = function (spirit3D, renderMode, albedo, ambientColor, uvScale, shaderName) {
            if (shaderName === void 0) { shaderName = null; }
            if (spirit3D instanceof Laya.MeshSprite3D) {
                var meshSprite = spirit3D;
                for (var i = 0; i < meshSprite.meshRender.sharedMaterials.length; i++) {
                    var mat = meshSprite.meshRender.sharedMaterials[i];
                    var transformUV = new Laya.TransformUV();
                    transformUV.tiling = uvScale;
                    (shaderName) && (mat.setShaderName(shaderName));
                    mat.transformUV = transformUV;
                    mat.ambientColor = ambientColor;
                    mat.albedo = albedo;
                    mat.renderMode = renderMode;
                }
            }
            for (var i = 0; i < spirit3D._childs.length; i++)
                this.setMeshParams(spirit3D._childs[i], renderMode, albedo, ambientColor, uvScale, shaderName);
        };
        return SimpleSceneSample;
    }());
    SimpleSceneSample_1.SimpleSceneSample = SimpleSceneSample;
})(SimpleSceneSample || (SimpleSceneSample = {}));
new SimpleSceneSample.SimpleSceneSample();
