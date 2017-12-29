class ColiderDemo {
    /**键盘的上下左右控制猴子位移**/
		private scene:Laya.Scene;
        private camera:Laya.Camera;
		private layaMonkey:Laya.Sprite3D;
		private layaMonkeyMeshSprite3D:Laya.SkinnedMeshSprite3D;
		private _tempUnitX1:Laya.Vector3 = new Laya.Vector3(0, 0, -0.1);
		private _tempUnitX2:Laya.Vector3 = new Laya.Vector3(0, 0, 0.1);
		private _tempUnitX3:Laya.Vector3 = new Laya.Vector3(-0.1, 0, 0);
		private _tempUnitX4:Laya.Vector3 = new Laya.Vector3(0.1, 0, 0);
		private collider:Laya.Sprite3D;
		private debug:Boolean = true;
    constructor() {
        Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
            Laya.Stat.show();
			
			//预加载所有资源
			var resource:any = [
				{url: "../../res/threeDimen/scene/ColliderScene/ColliderDemo.ls", clas: Laya.Scene, priority: 1}, 
				{url: "../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh", clas: Laya.Sprite3D, priority: 1}
			];
			
			Laya.loader.create(resource, Laya.Handler.create(this, this.onLoadFinish));
    }
    public onLoadFinish():void{
			
			this.scene = Laya.stage.addChild(Laya.Scene.load("../../res/threeDimen/scene/ColliderScene/ColliderDemo.ls")) as Laya.Scene;
			
            //初始化照相机
            this.camera = this.scene.addChild(new Laya.Camera(0, 0.1, 100)) as Laya.Camera;
            this.camera.transform.translate(new Laya.Vector3(0, 6, 13));
            this.camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);
            this.camera.addComponent(CameraMoveScript);
			
			//加载猴子
			this.layaMonkey = this.scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh")) as Laya.Sprite3D;
			this.layaMonkey.transform.position = new Laya.Vector3(0, 0, 1);
			this.layaMonkey.transform.scale = new Laya.Vector3(8, 8, 8);
			
			this.layaMonkeyMeshSprite3D = this.layaMonkey.getChildAt(0).getChildByName("LayaMonkey") as Laya.SkinnedMeshSprite3D;
			//添加盒型碰撞器
			var boxCollider:Laya.BoxCollider = this.layaMonkeyMeshSprite3D.addComponent(Laya.BoxCollider) as Laya.BoxCollider;
			boxCollider.setFromBoundBox(this.layaMonkeyMeshSprite3D.meshFilter.sharedMesh.boundingBox);
			this.layaMonkeyMeshSprite3D.camera = this.camera;
			//添加碰撞事件脚本
			this.layaMonkeyMeshSprite3D.addComponent(ColliderScript);
			//添加刚体组件
			this.layaMonkeyMeshSprite3D.addComponent(Laya.Rigidbody);
			//添加键盘事件
			Laya.stage.on(Laya.Event.KEY_DOWN, this, this.onKeyDown);
			
			this.collider = this.scene.getChildByName("Collider") as Laya.MeshSprite3D;
			this.collider.active = false;
			
			//是否开启debug模式
			Laya.stage.on(Laya.Event.MOUSE_UP, this, this.drawCollider);
		}
		
		private onKeyDown(e:Laya.Event = null):void
		{
			if (e.keyCode == Laya.Keyboard.UP)
				this.layaMonkey.transform.translate(this._tempUnitX1);
			else if (e.keyCode == Laya.Keyboard.DOWN)
				this.layaMonkey.transform.translate(this._tempUnitX2);
			else if (e.keyCode == Laya.Keyboard.LEFT)
				this.layaMonkey.transform.translate(this._tempUnitX3);
			else if (e.keyCode == Laya.Keyboard.RIGHT)
				this.layaMonkey.transform.translate(this._tempUnitX4);
		}
		
		private drawCollider():void{
			
			if (!this.debug){
				this.collider.active = false;
				this.layaMonkeyMeshSprite3D.removeComponentByType(DrawBoxColliderScript);
				this.debug = true;
			}
			else{
				this.collider.active = true;
				this.layaMonkeyMeshSprite3D.addComponent(DrawBoxColliderScript);
				this.debug = false;
			}
		}
    }
}
new ColiderDemo();