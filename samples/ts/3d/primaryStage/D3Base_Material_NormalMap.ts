module Material_NormalMap {

    import Vector3 = Laya.Vector3;

    export class Material_NormalMap {
        private root: Laya.Sprite3D;
        private rotation: Vector3 = new Vector3(0, 0.01, 0);

        constructor() {

            Laya3D.init(0, 0,true);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
            Laya.Stat.show();

            var scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

            var camera = (scene.addChild(new Laya.Camera(0, 0.1, 100))) as Laya.Camera;
            camera.transform.translate(new Laya.Vector3(0, 0.8, 1.6));
            camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
            camera.addComponent(CameraMoveScript);

            var directionLight = scene.addChild(new Laya.DirectionLight()) as Laya.DirectionLight;
            directionLight.direction = new Vector3(0, -0.8, -1);
            directionLight.ambientColor = new Vector3(0.7, 0.6, 0.6);
            directionLight.specularColor = new Vector3(1.0, 1.0, 0.8);
            directionLight.diffuseColor = new Vector3(1, 1, 1);

            this.root = scene.addChild(new Laya.Sprite3D()) as Laya.Sprite3D;
            this.root.transform.localScale = new Vector3(0.002, 0.002, 0.002);

            this.loadModel("../../res/threeDimen/staticModel/lizardCal/lizardCaclute-lizard_geo.lm", "../../res/threeDimen/staticModel/lizardCal/lizard_norm.png");
            this.loadModel("../../res/threeDimen/staticModel/lizardCal/lizardCaclute-eye_geo.lm", "../../res/threeDimen/staticModel/lizardCal/lizardeye_norm.png");
            this.loadModel("../../res/threeDimen/staticModel/lizardCal/lizardCaclute-rock_geo.lm", "../../res/threeDimen/staticModel/lizardCal/rock_norm.png");

            Laya.timer.frameLoop(1, this, () => {
                this.root.transform.rotate(this.rotation, true);
            });
        }

        public loadModel(meshPath: string, normalMapPath: string): void {
            var normalTexture: Laya.Texture;
            var material: Laya.StandardMaterial;

            var mesh: Laya.Mesh = Laya.Mesh.load(meshPath);
            var meshSprite: Laya.MeshSprite3D = this.root.addChild(new Laya.MeshSprite3D(mesh)) as Laya.MeshSprite3D;

            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            mesh.once(Laya.Event.LOADED, null, () => {
                meshSprite.meshRender.sharedMaterials[0].once(Laya.Event.LOADED, null, () => {
                    material = meshSprite.meshRender.sharedMaterials[0] as Laya.StandardMaterial;
                    (material && normalTexture) && (material.normalTexture = normalTexture);
                });
            });

            Laya.loader.load(normalMapPath, Laya.Handler.create(null, (texture) => {
                normalTexture = texture;
                (material && normalTexture) && (material.normalTexture = normalTexture);
            }));
        }

    }
}
new Material_NormalMap.Material_NormalMap();