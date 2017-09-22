class SkinAnimation_Old {
	private zombie: Laya.Sprite3D;
	private changeActionButton: Laya.Button;
	private curStateIndex: number = 0;
	private skinAniUrl: Array<any> = [
		"../../res/threeDimen/skinModel/Zombie/old/Assets/Zombie/Model/z@walk-walk.lsani",
		"../../res/threeDimen/skinModel/Zombie/old/Assets/Zombie/Model/z@attack-attack.lsani",
		"../../res/threeDimen/skinModel/Zombie/old/Assets/Zombie/Model/z@left_fall-left_fall.lsani",
		"../../res/threeDimen/skinModel/Zombie/old/Assets/Zombie/Model/z@right_fall-right_fall.lsani",
		"../../res/threeDimen/skinModel/Zombie/old/Assets/Zombie/Model/z@back_fall-back_fall.lsani"
	];
	constructor() {
		Laya3D.init(0, 0, true);
		Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
		Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
		Laya.Stat.show();

		var scene: Laya.Scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

		var camera: Laya.Camera = (scene.addChild(new Laya.Camera(0, 0.01, 1000))) as Laya.Camera;
		camera.transform.translate(new Laya.Vector3(0, 1.5, 3));
		camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);

		var directionLight: Laya.DirectionLight = scene.addChild(new Laya.DirectionLight()) as Laya.DirectionLight;
		directionLight.direction = new Laya.Vector3(0, -0.8, -1);
		directionLight.color = new Laya.Vector3(1, 1, 1);

		var plane: Laya.Sprite3D = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/Zombie/old/Plane.lh")) as Laya.Sprite3D;

		this.zombie = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/Zombie/old/Zombie.lh")) as Laya.Sprite3D;
		this.zombie.once(Laya.Event.HIERARCHY_LOADED, this, function (): void {
			this.zombie.transform.rotation = new Laya.Quaternion(-0.7071068, 0, 0, -0.7071068);
			this.zombie.transform.position = new Laya.Vector3(0.3, 0, 0);
			this.addSkinComponent(this.zombie);
			this.loadUI();
		});
	}
	//遍历节点,添加SkinAnimation动画组件
	public addSkinComponent(spirit3D: Laya.Sprite3D): void {

		if (spirit3D instanceof Laya.MeshSprite3D) {
			var meshSprite3D: Laya.MeshSprite3D = spirit3D as Laya.MeshSprite3D;
			var skinAni: Laya.SkinAnimations = meshSprite3D.addComponent(Laya.SkinAnimations) as Laya.SkinAnimations;
			skinAni.templet = Laya.AnimationTemplet.load(this.skinAniUrl[0]);
			skinAni.player.play();
		}
		for (var i: number = 0, n: number = spirit3D._childs.length; i < n; i++)
			this.addSkinComponent(spirit3D._childs[i]);
	}

	//遍历节点,播放动画
	public playSkinAnimation(spirit3D: Laya.Sprite3D, index: number): void {

		if (spirit3D instanceof Laya.MeshSprite3D) {
			var meshSprite3D: Laya.MeshSprite3D = spirit3D as Laya.MeshSprite3D;
			var skinAni: Laya.SkinAnimations = meshSprite3D.getComponentByType(Laya.SkinAnimations) as Laya.SkinAnimations;
			skinAni.templet = Laya.AnimationTemplet.load(this.skinAniUrl[index]);
			skinAni.player.play();
		}
		for (var i: number = 0, n: number = spirit3D._childs.length; i < n; i++)
			this.playSkinAnimation(spirit3D._childs[i], index);
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
				this.playSkinAnimation(this.zombie, ++this.curStateIndex % this.skinAniUrl.length);
			});
		}));
	}
}
new SkinAnimation_Old;