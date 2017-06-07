module Materil_Reflect {
    import Vector3 = Laya.Vector3;
    import Vector4 = Laya.Vector4;

    export class Materil_Reflect {
        private material: Laya.StandardMaterial;

        constructor() {

            Laya3D.init(0, 0,true);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
            Laya.Stat.show();

            var scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

            var camera = (scene.addChild(new Laya.Camera(0, 0.1, 100))) as Laya.Camera;
            camera.transform.translate(new Laya.Vector3(0, 0.8, 1.5));
            camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
            camera.clearFlag = Laya.BaseCamera.CLEARFLAG_SKY;
            var skyBox = new Laya.SkyBox();
            camera.sky = skyBox;
            camera.addComponent(CameraMoveScript);

            var sprit = scene.addChild(new Laya.Sprite3D()) as Laya.Sprite3D;
            var textureCube = Laya.TextureCube.load("../../res/threeDimen/skyBox/skyCube.ltc");

            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            var mesh: Laya.Mesh = Laya.Mesh.load("../../res/threeDimen/staticModel/teapot/teapot-Teapot001.lm");
            var meshSprite = sprit.addChild(new Laya.MeshSprite3D(mesh)) as Laya.MeshSprite3D;
            mesh.once(Laya.Event.LOADED, this, () => {
                this.material = meshSprite.meshRender.sharedMaterials[0] as Laya.StandardMaterial;;
                this.material.albedo = new Vector4(0.0,0.0,0.0,0.0);
                this.material.renderMode = Laya.StandardMaterial.RENDERMODE_OPAQUEDOUBLEFACE;
                this.material.reflectTexture = textureCube;
            });
            meshSprite.transform.localPosition = new Vector3(-0.3, 0.0, 0.0);
            meshSprite.transform.localScale = new Vector3(0.5, 0.5, 0.5);
            meshSprite.transform.localRotation = new Laya.Quaternion(-0.7071068, 0.0, 0.0, 0.7071068);

            skyBox.textureCube = textureCube;

            Laya.timer.frameLoop(1, this, () => {
                meshSprite.transform.rotate(new Vector3(0, 0.01, 0), false);
            });
        }
    }
}
new Materil_Reflect.Materil_Reflect();