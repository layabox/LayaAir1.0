module Materil_Reflect {
    import Vector3 = Laya.Vector3;

    export class Materil_Reflect {
        private mesh: Laya.Mesh;
        private reflectTexture: Laya.Texture;
        private material: Laya.Material;

        constructor() {
            Laya.Laya3D.init(0, 0);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
            Laya.Stat.show();

            var scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;
            scene.shadingMode = Laya.BaseScene.PIXEL_SHADING;

            scene.currentCamera = (scene.addChild(new Laya.Camera(new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height), Math.PI / 3, 0, 0.1, 100))) as Laya.Camera;
            scene.currentCamera.transform.translate(new Vector3(0, 0.8, 1.5));
            scene.currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);
            Laya.stage.on(Laya.Event.RESIZE, null, () => {
                (scene.currentCamera as Laya.Camera).viewport = new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height);
            });

            var sprit = scene.addChild(new Laya.Sprite3D()) as Laya.Sprite3D;

            this.mesh = sprit.addChild(new Laya.Mesh()) as Laya.Mesh;
            this.mesh.on(Laya.Event.LOADED, this, function (): void {
                this.material = this.mesh.templet.materials[0];
                this.material.luminance = 0;
                this.material.cullFace = false;
                (this.material && this.reflectTexture) && (this.material.reflectTexture = this.reflectTexture);
            });
            this.mesh.load("threeDimen/staticModel/teapot/teapot-Teapot001.lm");
            this.mesh.transform.localPosition = new Vector3(-0.3, 0.0, 0.0);
            this.mesh.transform.localScale = new Vector3(0.5, 0.5, 0.5);
            this.mesh.transform.localRotation = new Laya.Quaternion(-0.7071068, 0.0, 0.0,0.7071068);
            
           	var webGLImageCube = new Laya.WebGLImageCube(["threeDimen/skyBox/px.jpg", "threeDimen/skyBox/nx.jpg", "threeDimen/skyBox/py.jpg", "threeDimen/skyBox/ny.jpg", "threeDimen/skyBox/pz.jpg", "threeDimen/skyBox/nz.jpg"], 1024);
			webGLImageCube.on(Laya.Event.LOADED, this, function(imgCube:Laya.WebGLImageCube):void {
				this.reflectTexture = new Laya.Texture(imgCube);
				imgCube.mipmap = true;
				(this.material && this.reflectTexture) && (this.mesh.templet.materials[0].reflectTexture = this.reflectTexture);
			});

            Laya.timer.frameLoop(1, this, () => {
                this.mesh.transform.rotate(new Vector3(0, 0.01, 0), false);
            });
        }
    }
}
new Materil_Reflect.Materil_Reflect();