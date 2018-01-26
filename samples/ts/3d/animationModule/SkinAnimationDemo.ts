class SkinAnimationDemo {
    private changeActionButton: Laya.Button;
    private zombieAnimator: Laya.Animator;
    private curStateIndex: number = 0;
    private clipName: Array<any> = ["walk", "attack", "left_fall", "right_fall", "back_fall"];
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        var scene: Laya.Scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

        var camera: Laya.Camera = (scene.addChild(new Laya.Camera(0, 0.1, 1000))) as Laya.Camera;
        camera.transform.translate(new Laya.Vector3(0, 1.5, 4));
        camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);
        camera.addComponent(CameraMoveScript);

        var directionLight: Laya.DirectionLight = scene.addChild(new Laya.DirectionLight()) as Laya.DirectionLight;
        directionLight.direction = new Laya.Vector3(0, -0.8, -1);
        directionLight.color = new Laya.Vector3(1, 1, 1);

        var plane: Laya.Sprite3D = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/Zombie/new/Plane.lh")) as Laya.Sprite3D;

        var zombie: Laya.Sprite3D = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/Zombie/new/Zombie.lh")) as Laya.Sprite3D;
        zombie.once(Laya.Event.HIERARCHY_LOADED, this, function (): void {
            //获取Animator动画组件
            this.zombieAnimator = zombie.getChildAt(0).getComponentByType(Laya.Animator);
            this.loadUI();
        });
    }
    private loadUI(): void {
        Laya.loader.load(["../../res/threeDimen/ui/button.png"], Laya.Handler.create(this, function (): void {

            this.changeActionButton = Laya.stage.addChild(new Laya.Button("../../res/threeDimen/ui/button.png", "切换动作")) as Laya.Button;
            this.changeActionButton.size(160, 40);
            this.changeActionButton.labelBold = true;
            this.changeActionButton.labelSize = 30;
            this.changeActionButton.sizeGrid = "4,4,4,4";
            this.changeActionButton.scale(Laya.Browser.pixelRatio, Laya.Browser.pixelRatio);
            this.changeActionButton.pos(Laya.stage.width / 2 - this.changeActionButton.width * Laya.Browser.pixelRatio / 2, Laya.stage.height - 100 * Laya.Browser.pixelRatio);
            this.changeActionButton.on(Laya.Event.CLICK, this, function (): void {
                //根据名称播放动画
                this.zombieAnimator.play(this.clipName[++this.curStateIndex % this.clipName.length]);
            });
        }));
    }
}
new SkinAnimationDemo;