class StandardMaterial_NormalMap {
    private scene: Laya.Scene;
    private rotation: Laya.Vector3;
    private normalMapUrl: Array<any> = ["../../res/threeDimen/staticModel/lizardCal/rock_norm.png", "../../res/threeDimen/staticModel/lizardCal/lizard_norm.png", "../../res/threeDimen/staticModel/lizardCal/lizard_norm.png"];
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        this.scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

        this.rotation = new Laya.Vector3(0, 0.01, 0);

        var camera: Laya.Camera = (this.scene.addChild(new Laya.Camera(0, 0.1, 100))) as Laya.Camera;
        camera.transform.translate(new Laya.Vector3(0, 0.6, 1.1));
        camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);

        var directionLight: Laya.DirectionLight = this.scene.addChild(new Laya.DirectionLight()) as Laya.DirectionLight;
        directionLight.direction = new Laya.Vector3(0, -0.8, -1);
        directionLight.color = new Laya.Vector3(1, 1, 1);

        Laya.loader.create("../../res/threeDimen/staticModel/lizardCal/lizardCaclute.lh", Laya.Handler.create(this, this.onComplete));
    }
    public onComplete(): void {

        var monster1: Laya.Sprite3D = this.scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/lizardCal/lizardCaclute.lh")) as Laya.Sprite3D;
        monster1.transform.position = new Laya.Vector3(-0.6, 0, 0);
        monster1.transform.localScale = new Laya.Vector3(0.002, 0.002, 0.002);

        var monster2: Laya.Sprite3D = Laya.Sprite3D.instantiate(monster1, this.scene, false, new Laya.Vector3(0.6, 0, 0));
        monster2.transform.localScale = new Laya.Vector3(0.002, 0.002, 0.002);
        for (var i: number = 0; i < monster2._childs.length; i++) {
            var meshSprite3D: Laya.MeshSprite3D = monster2._childs[i] as Laya.MeshSprite3D;
            var material: Laya.StandardMaterial = meshSprite3D.meshRender.material as Laya.StandardMaterial;
            //法线贴图
            material.normalTexture = Laya.Texture2D.load(this.normalMapUrl[i]);
        }

        Laya.timer.frameLoop(1, this, function (): void {
            monster1.transform.rotate(this.rotation);
            monster2.transform.rotate(this.rotation);
        });
    }
}
new StandardMaterial_NormalMap;