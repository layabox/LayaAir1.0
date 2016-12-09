module SimpleSceneSample {
    import Vector2 = Laya.Vector2;
    import Vector3 = Laya.Vector3;
    import Vector4 = Laya.Vector4;
    import Event = Laya.Event;
    import Sprite3D = Laya.Sprite3D;

    export class SimpleSceneSample {

        constructor() {

            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
            Laya.Stat.show();

            var scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

            var camera = new Laya.Camera(0, 0.1, 100);
            camera = scene.addChild(camera) as Laya.Camera;
            camera.transform.translate(new Vector3(0.3, 0.3, 0.6));
            camera.transform.rotate(new Vector3(-12, 0, 0), true, false);
            camera.clearColor = null;
            camera.clearFlag = Laya.BaseCamera.CLEARFLAG_SKY;
            camera.addComponent(CameraMoveScript);

            this.loadScene(scene, camera);
        }

        private loadScene(scene:Laya.Scene, camera:Laya.Camera):void {
            var root:Sprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
            root.transform.localScale = new Vector3(10, 10, 10);

            var skyBox = new Laya.SkyBox();
            camera.sky = skyBox;
            skyBox.textureCube = Laya.TextureCube.load("../../res/threeDimen/skyBox/skyCube.ltc");

            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var singleFaceTransparent0:Sprite3D = root.addChild(Sprite3D.load("../../res/threeDimen/staticModel/simpleScene/B00IT004M.v3f.lh")) as Sprite3D;
            singleFaceTransparent0.once(Event.HIERARCHY_LOADED, this, function (sprite:Sprite3D):void {
                this.setMeshParams(sprite, Laya.BaseMaterial.RENDERMODE_CUTOUT, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });

            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var singleFaceTransparent1:Sprite3D = root.addChild(Sprite3D.load("../../res/threeDimen/staticModel/simpleScene/B00IT003M000.v3f.lh")) as Sprite3D;
            singleFaceTransparent1.once(Event.HIERARCHY_LOADED, this, function (sprite:Sprite3D):void {
                this.setMeshParams(sprite, Laya.BaseMaterial.RENDERMODE_CUTOUT, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });

            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var meshSprite3d0:Sprite3D = root.addChild(Sprite3D.load("../../res/threeDimen/staticModel/simpleScene/B00IT001M000.v3f.lh")) as Sprite3D;
            meshSprite3d0.once(Event.HIERARCHY_LOADED, this, function (sprite:Sprite3D):void {
                this.setMeshParams(sprite, Laya.BaseMaterial.RENDERMODE_OPAQUE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });

            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var meshSprite3d1:Sprite3D = root.addChild(Sprite3D.load("../../res/threeDimen/staticModel/simpleScene/B00IT002M000.v3f.lh")) as Sprite3D;
            meshSprite3d1.once(Event.HIERARCHY_LOADED, this, function (sprite:Sprite3D):void {
                this.setMeshParams(sprite, Laya.BaseMaterial.RENDERMODE_OPAQUE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });

            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var meshSprite3d2:Sprite3D = root.addChild(Sprite3D.load("../../res/threeDimen/staticModel/simpleScene/B00IT008M.v3f.lh")) as Sprite3D;
            meshSprite3d2.once(Event.HIERARCHY_LOADED, this, function (sprite:Sprite3D):void {
                this.setMeshParams(sprite, Laya.BaseMaterial.RENDERMODE_OPAQUE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });

            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var meshSprite3d3:Sprite3D = root.addChild(Sprite3D.load("../../res/threeDimen/staticModel/simpleScene/B00MP003M.v3f.lh")) as Sprite3D;
            meshSprite3d3.once(Event.HIERARCHY_LOADED, this, function (sprite:Sprite3D):void {
                this.setMeshParams(sprite, Laya.BaseMaterial.RENDERMODE_OPAQUE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });

            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var doubleFaceTransparent:Sprite3D = root.addChild(Sprite3D.load("../../res/threeDimen/staticModel/simpleScene/B00IT005M.v3f.lh")) as Sprite3D;
            doubleFaceTransparent.once(Event.HIERARCHY_LOADED, this, function (sprite:Sprite3D):void {
                this.setMeshParams(doubleFaceTransparent, Laya.BaseMaterial.RENDERMODE_CUTOUTDOUBLEFACE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
            });

            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var terrainSpirit0:Sprite3D = root.addChild(Sprite3D.load("../../res/threeDimen/staticModel/simpleScene/B00MP001M.v3f.lh")) as Sprite3D;
            terrainSpirit0.once(Event.HIERARCHY_LOADED, this, function (sprite:Sprite3D):void {
                this.setMeshParams(terrainSpirit0, Laya.BaseMaterial.RENDERMODE_OPAQUE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6823, 0.6549, 0.6352), new Vector2(25.0, 25.0), "TERRAIN");
            });

            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var terrainSpirit1:Sprite3D = root.addChild(Sprite3D.load("../../res/threeDimen/staticModel/simpleScene/B00MP002M.v3f.lh")) as Sprite3D;
            terrainSpirit1.once(Event.HIERARCHY_LOADED, this, function (sprite:Sprite3D):void {
                this.setMeshParams(terrainSpirit1, Laya.BaseMaterial.RENDERMODE_OPAQUE, new Vector4(3.5, 3.5, 3.5, 1.0), new Vector3(0.6823, 0.6549, 0.6352), new Vector2(25.0, 25.0), "TERRAIN");
            });
        }

        private  setMeshParams(spirit3D:Sprite3D, renderMode:number, albedo:Vector4, ambientColor:Vector3, uvScale:Vector2, shaderName:String = null):void {
            if (spirit3D instanceof Laya.MeshSprite3D) {
                var meshSprite = spirit3D as Laya.MeshSprite3D;
                for (var i = 0; i < meshSprite.meshRender.sharedMaterials.length; i++) {
                    var mat:Laya.Material = meshSprite.meshRender.sharedMaterials[i];
                    var transformUV:Laya.TransformUV = new Laya.TransformUV();
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
        }
    }
}
new SimpleSceneSample.SimpleSceneSample();