var SimpleSceneVRSample;
(function (SimpleSceneVRSample_1) {
    var Vector2 = Laya.Vector2;
    var Vector3 = Laya.Vector3;
    var Vector4 = Laya.Vector4;
    var Event = Laya.Event;
    var Sprite3D = Laya.Sprite3D;
    var SimpleSceneVRSample = (function () {
        function SimpleSceneVRSample() {
            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
            Laya.Stat.show();
            var scene = Laya.stage.addChild(new Laya.VRScene());
            var camera = new Laya.VRCamera(0.03, 0, 0, 0.1, 100);
            scene.currentCamera = scene.addChild(camera);
            scene.currentCamera.transform.translate(new Vector3(0.3, 0.3, 0.6));
            scene.currentCamera.transform.rotate(new Vector3(-12, 0, 0), true, false);
            scene.currentCamera.addComponent(VRCameraMoveScript);
            this.loadScene(scene, camera);
        }
        SimpleSceneVRSample.prototype.loadScene = function (scene, camera) {
            var _this = this;
            var root = scene.addChild(new Sprite3D());
            root.transform.localScale = new Vector3(10, 10, 10);
            var skySprite3D = scene.addChild(new Laya.Sprite3D());
            var skySampleScript = skySprite3D.addComponent(SkySampleScript);
            skySampleScript.skySprite = skySprite3D;
            skySampleScript.cameraSprite = camera;
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var skySprite3d0 = skySprite3D.addChild(new Sprite3D());
            skySprite3d0.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00IT006M.v3f.lh");
            skySprite3d0.once(Laya.Event.HIERARCHY_LOADED, this, function (sprite) {
                _this.setMeshParams(sprite, Laya.Material.RENDERMODE_SKY, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0), null);
            });
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var skySprite3d1 = skySprite3D.addChild(new Sprite3D());
            skySprite3d1.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00IT007M.v3f.lh");
            skySprite3d1.once(Laya.Event.HIERARCHY_LOADED, this, function (sprite) {
                _this.setMeshParams(sprite, Laya.Material.RENDERMODE_SKY, new Vector4(1.0, 1.0, 1.0, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0), null);
            });
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var singleFaceTransparent0 = root.addChild(new Sprite3D());
            singleFaceTransparent0.once(Event.HIERARCHY_LOADED, this, function (sprite) {
                this.setMeshParams(sprite, Laya.Material.RENDERMODE_CUTOUT, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });
            singleFaceTransparent0.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00IT004M.v3f.lh");
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var singleFaceTransparent1 = root.addChild(new Sprite3D());
            singleFaceTransparent1.once(Event.HIERARCHY_LOADED, this, function (sprite) {
                this.setMeshParams(sprite, Laya.Material.RENDERMODE_CUTOUT, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });
            singleFaceTransparent1.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00IT003M000.v3f.lh");
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var meshSprite3d0 = root.addChild(new Sprite3D());
            meshSprite3d0.once(Event.HIERARCHY_LOADED, this, function (sprite) {
                this.setMeshParams(sprite, Laya.Material.RENDERMODE_OPAQUE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });
            meshSprite3d0.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00IT001M000.v3f.lh");
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var meshSprite3d1 = root.addChild(new Sprite3D());
            meshSprite3d1.once(Event.HIERARCHY_LOADED, this, function (sprite) {
                this.setMeshParams(sprite, Laya.Material.RENDERMODE_OPAQUE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });
            meshSprite3d1.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00IT002M000.v3f.lh");
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var meshSprite3d2 = root.addChild(new Sprite3D());
            meshSprite3d2.once(Event.HIERARCHY_LOADED, this, function (sprite) {
                this.setMeshParams(sprite, Laya.Material.RENDERMODE_OPAQUE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });
            meshSprite3d2.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00IT008M.v3f.lh");
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var meshSprite3d3 = root.addChild(new Sprite3D());
            meshSprite3d3.once(Event.HIERARCHY_LOADED, this, function (sprite) {
                this.setMeshParams(sprite, Laya.Material.RENDERMODE_OPAQUE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });
            meshSprite3d3.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00MP003M.v3f.lh");
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var doubleFaceTransparent = root.addChild(new Sprite3D());
            doubleFaceTransparent.once(Event.HIERARCHY_LOADED, this, function (sprite) {
                this.setMeshParams(doubleFaceTransparent, Laya.Material.RENDERMODE_CUTOUTDOUBLEFACE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });
            doubleFaceTransparent.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00IT005M.v3f.lh");
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var terrainSpirit0 = root.addChild(new Sprite3D());
            terrainSpirit0.once(Event.HIERARCHY_LOADED, this, function (sprite) {
                this.setMeshParams(terrainSpirit0, Laya.Material.RENDERMODE_OPAQUE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6823, 0.6549, 0.6352), new Vector2(25.0, 25.0), "TERRAIN");
            });
            terrainSpirit0.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00MP001M.v3f.lh");
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var terrainSpirit1 = root.addChild(new Sprite3D());
            terrainSpirit1.once(Event.HIERARCHY_LOADED, this, function (sprite) {
                this.setMeshParams(terrainSpirit1, Laya.Material.RENDERMODE_OPAQUE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6823, 0.6549, 0.6352), new Vector2(25.0, 25.0), "TERRAIN");
            });
            terrainSpirit1.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00MP002M.v3f.lh");
        };
        SimpleSceneVRSample.prototype.setMeshParams = function (spirit3D, renderMode, albedo, ambientColor, uvScale, shaderName) {
            if (shaderName === void 0) { shaderName = null; }
            if (spirit3D instanceof Laya.MeshSprite3D) {
                var meshSprite = spirit3D;
                var mesh = meshSprite.meshFilter.sharedMesh;
                if (mesh != null) {
                    //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
                    mesh.once(Event.LOADED, this, function (mesh) {
                        for (var i = 0; i < meshSprite.meshRender.shadredMaterials.length; i++) {
                            var material = meshSprite.meshRender.shadredMaterials[i];
                            material.once(Event.LOADED, null, function (mat) {
                                var transformUV = new Laya.TransformUV();
                                transformUV.tiling = uvScale;
                                (shaderName) && (mat.setShaderName(shaderName));
                                mat.transformUV = transformUV;
                                mat.ambientColor = ambientColor;
                                mat.albedo = albedo;
                                mat.renderMode = renderMode;
                            });
                        }
                    });
                }
            }
            for (var i = 0; i < spirit3D._childs.length; i++)
                this.setMeshParams(spirit3D._childs[i], renderMode, albedo, ambientColor, uvScale, shaderName);
        };
        return SimpleSceneVRSample;
    }());
    SimpleSceneVRSample_1.SimpleSceneVRSample = SimpleSceneVRSample;
})(SimpleSceneVRSample || (SimpleSceneVRSample = {}));
new SimpleSceneVRSample.SimpleSceneVRSample();
