module SimpleSceneSample {
    import Vector2 = Laya.Vector2;
    import Vector3 = Laya.Vector3;
    import Sprite3D = Laya.Sprite3D;

    export class SimpleSceneSample {

        constructor() {
            //是否抗锯齿
            //Config.isAntialias = true;
            Laya3D.init(0, 0);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
            Laya.Stat.show();

            var scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

            var camera = new Laya.Camera(new Laya.Viewport(0, 0, Laya.RenderState2D.width, Laya.RenderState2D.height), Math.PI / 3, 0, 0.1, 100);
            scene.currentCamera = scene.addChild(camera) as Laya.Camera;
            scene.currentCamera.transform.translate(new Vector3(0.3, 0.3, 0.6));
            scene.currentCamera.transform.rotate(new Vector3(-12, 0, 0), true, false);
            Laya.stage.on(Laya.Event.RESIZE, null, () => {
                (scene.currentCamera as Laya.Camera).viewport = new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height);
            });

            scene.currentCamera.addComponent(CameraMoveScript);

            this.loadScene(scene, camera);
        }

        private loadScene(scene: Laya.Scene, camera: Laya.Camera): void {
            var root: Sprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
            root.transform.localScale = new Vector3(10, 10, 10);

            var skySprite3D = scene.addChild(new Laya.Sprite3D()) as Laya.Sprite3D;
            var skySampleScript = skySprite3D.addComponent(SkySampleScript) as SkySampleScript;
            skySampleScript.skySprite = skySprite3D;
            skySampleScript.cameraSprite = camera;

            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var skySprite3d0: Sprite3D = skySprite3D.addChild(new Sprite3D()) as Sprite3D;
            skySprite3d0.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00IT006M.v3f.lh");
            skySprite3d0.once(Laya.Event.HIERARCHY_LOADED, this, (sprite) => {
                this.setMeshParams(skySprite3d0, false, false, 3.5, new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0), null, 0, true);
            });

            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var skySprite3d1: Sprite3D = skySprite3D.addChild(new Sprite3D()) as Sprite3D;
            skySprite3d1.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00IT007M.v3f.lh");
            skySprite3d1.once(Laya.Event.HIERARCHY_LOADED, this, (sprite) => {
                this.setMeshParams(skySprite3d1, false, true, 1.0, new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0), null, 0, true);
            });

            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var singleFaceTransparent0 = root.addChild(new Sprite3D()) as Sprite3D;
            singleFaceTransparent0.once(Laya.Event.HIERARCHY_LOADED, this, function (sprite: Sprite3D): void {
                this.setMeshParams(sprite, false, true, 3.5, new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });
            singleFaceTransparent0.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00IT004M.v3f.lh");


            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var singleFaceTransparent1 = root.addChild(new Sprite3D()) as Sprite3D;
            singleFaceTransparent1.once(Laya.Event.HIERARCHY_LOADED, this, function (sprite: Sprite3D): void {
                this.setMeshParams(sprite, false, true, 3.5, new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });
            singleFaceTransparent1.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00IT003M000.v3f.lh");

            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var meshSprite3d0 = root.addChild(new Sprite3D()) as Sprite3D;
            meshSprite3d0.once(Laya.Event.HIERARCHY_LOADED, this, function (sprite: Sprite3D): void {
                this.setMeshParams(sprite, false, false, 3.5, new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });
            meshSprite3d0.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00IT001M000.v3f.lh");

            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var meshSprite3d1 = root.addChild(new Sprite3D()) as Sprite3D;
            meshSprite3d1.once(Laya.Event.HIERARCHY_LOADED, this, function (sprite: Sprite3D): void {
                this.setMeshParams(sprite, false, false, 3.5, new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });
            meshSprite3d1.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00IT002M000.v3f.lh");

            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var meshSprite3d2 = root.addChild(new Sprite3D()) as Sprite3D;
            meshSprite3d2.once(Laya.Event.HIERARCHY_LOADED, this, function (sprite: Sprite3D): void {
                this.setMeshParams(sprite, false, false, 3.5, new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });
            meshSprite3d2.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00IT008M.v3f.lh");

            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var meshSprite3d3 = root.addChild(new Sprite3D()) as Sprite3D;
            meshSprite3d3.once(Laya.Event.HIERARCHY_LOADED, this, function (sprite: Sprite3D): void {
                this.setMeshParams(sprite, false, false, 3.5, new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });
            meshSprite3d3.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00MP003M.v3f.lh");

            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var doubleFaceTransparent = root.addChild(new Sprite3D()) as Sprite3D;
            doubleFaceTransparent.once(Laya.Event.HIERARCHY_LOADED, this, function (sprite: Sprite3D): void {
                this.setMeshParams(doubleFaceTransparent, true, true, 3.5, new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });
            doubleFaceTransparent.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00IT005M.v3f.lh");

            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var terrainSpirit0 = root.addChild(new Sprite3D()) as Sprite3D;
            terrainSpirit0.once(Laya.Event.HIERARCHY_LOADED, this, function (sprite: Sprite3D): void {
                this.setMeshParams(terrainSpirit0, false, false, 3.5, new Vector3(0.6823, 0.6549, 0.6352), new Vector2(25.0, 25.0), "TERRAIN");
            });
            terrainSpirit0.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00MP001M.v3f.lh");

            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var terrainSpirit1 = root.addChild(new Sprite3D()) as Sprite3D;
            terrainSpirit1.once(Laya.Event.HIERARCHY_LOADED, this, function (sprite: Sprite3D): void {
                this.setMeshParams(terrainSpirit1, false, false, 3.5, new Vector3(0.6823, 0.6549, 0.6352), new Vector2(19.0, 19.0), "TERRAIN");
            });
            terrainSpirit1.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00MP002M.v3f.lh");
        }

        private setMeshParams(spirit3D: Sprite3D, doubleFace: Boolean, alpha: Boolean, luminance: number, ambientColor: Vector3, uvScale: Vector2, shaderName: string = undefined, transparentMode: number = 0.0, isSky = false): void {
            if (spirit3D instanceof Laya.MeshSprite3D) {
                var meshSprite = spirit3D as Laya.MeshSprite3D;
                var mesh = meshSprite.mesh;
                if (mesh != null) {
                    //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
                    mesh.once(Laya.Event.LOADED, this, function (mesh: Laya.BaseMesh): void {
                        for (var i = 0; i < meshSprite.materials.length; i++) {
                            var material = meshSprite.materials[i];
                            material.once(Laya.Event.LOADED, null, function (mat: Laya.Material): void {
                                var transformUV = new Laya.TransformUV();
                                transformUV.tiling = uvScale;
                                (shaderName) && (mat.setShaderName(shaderName));
                                mat.transformUV = transformUV;
                                mat.ambientColor = ambientColor;
                                mat.luminance = luminance;
                                doubleFace && (mat.cullFace = false);
                                alpha && (mat.transparent = true);
                                isSky && (mat.isSky = true);
                                mat.transparentMode = transparentMode;
                            });

                        }
                    });
                }
            }
            for (var i = 0; i < spirit3D._childs.length; i++)
                this.setMeshParams(spirit3D._childs[i], doubleFace, alpha, luminance, ambientColor, uvScale, shaderName, transparentMode, isSky);
        }
    }
}
new SimpleSceneSample.SimpleSceneSample();