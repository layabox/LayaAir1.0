package physicsModule {
	import common.CameraMoveScript;
	import common.ColliderScript;
	import common.DrawBoxColliderScript;
	import laya.d3.component.Rigidbody;
    import laya.d3.component.physics.BoxCollider;
    import laya.d3.component.physics.MeshCollider;
    import laya.d3.component.physics.SphereCollider;
    import laya.d3.core.Camera;
    import laya.d3.core.Layer;
    import laya.d3.core.MeshSprite3D;
    import laya.d3.core.PhasorSpriter3D;
	import laya.d3.core.SkinnedMeshSprite3D;
    import laya.d3.core.Sprite3D;
    import laya.d3.core.light.DirectionLight;
    import laya.d3.core.material.StandardMaterial;
    import laya.d3.core.render.RenderState;
    import laya.d3.core.scene.Scene;
	import laya.d3.math.OrientedBoundBox;
    import laya.d3.math.Plane;
    import laya.d3.math.Quaternion;
    import laya.d3.math.Ray;
    import laya.d3.math.Vector2;
    import laya.d3.math.Vector3;
    import laya.d3.math.Vector4;
    import laya.d3.resource.Texture2D;
    import laya.d3.resource.models.BoxMesh;
    import laya.d3.resource.models.CapsuleMesh;
    import laya.d3.resource.models.CylinderMesh;
    import laya.d3.resource.models.Mesh;
    import laya.d3.resource.models.PlaneMesh;
    import laya.d3.resource.models.SphereMesh;
	import laya.d3.shader.ShaderCompile3D;
    import laya.d3.utils.Physics;
    import laya.d3.utils.RaycastHit;
    import laya.display.Stage;
    import laya.events.Event;
	import laya.events.Keyboard;
    import laya.events.MouseManager;
    import laya.ui.Label;
    import laya.utils.Browser;
	import laya.utils.Handler;
    import laya.utils.Stat;
    import laya.utils.Tween;
    import laya.webgl.WebGLContext;
    
    public class ColiderDemo {
        
		/**键盘的上下左右控制猴子位移**/
		private var scene:Scene;
        private var camera:Camera;
		private var layaMonkey:Sprite3D;
		private var layaMonkeyMeshSprite3D:SkinnedMeshSprite3D;
		private var _tempUnitX1:Vector3 = new Vector3(0, 0, -0.1);
		private var _tempUnitX2:Vector3 = new Vector3(0, 0, 0.1);
		private var _tempUnitX3:Vector3 = new Vector3(-0.1, 0, 0);
		private var _tempUnitX4:Vector3 = new Vector3(0.1, 0, 0);
		private var collider:Sprite3D;
		private var debug:Boolean = true;
		
        public function ColiderDemo() {

            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Stage.SCALE_FULL;
            Laya.stage.screenMode = Stage.SCREEN_NONE;
            Stat.show();
			
			//预加载所有资源
			var resource:Array = [
				{url: "../../../../res/threeDimen/scene/ColliderScene/ColliderDemo.ls", clas: Scene, priority: 1}, 
				{url: "../../../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh", clas: Sprite3D, priority: 1}
			];
			
			Laya.loader.create(resource, Handler.create(this, onLoadFinish));
        }
		
		public function onLoadFinish():void{
			
			scene = Laya.stage.addChild(Scene.load("../../../../res/threeDimen/scene/ColliderScene/ColliderDemo.ls")) as Scene;
			
            //初始化照相机
            camera = scene.addChild(new Camera(0, 0.1, 100)) as Camera;
            camera.transform.translate(new Vector3(0, 6, 13));
            camera.transform.rotate(new Vector3(-15, 0, 0), true, false);
            camera.addComponent(CameraMoveScript);
			
			//加载猴子
			layaMonkey = scene.addChild(Sprite3D.load("../../../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh")) as Sprite3D;
			layaMonkey.transform.position = new Vector3(0, 0, 1);
			layaMonkey.transform.scale = new Vector3(8, 8, 8);
			
			layaMonkeyMeshSprite3D = layaMonkey.getChildAt(0).getChildByName("LayaMonkey") as SkinnedMeshSprite3D;
			//添加盒型碰撞器
			var boxCollider:BoxCollider = layaMonkeyMeshSprite3D.addComponent(BoxCollider) as BoxCollider;
			boxCollider.setFromBoundBox(layaMonkeyMeshSprite3D.meshFilter.sharedMesh.boundingBox);
			layaMonkeyMeshSprite3D.camera = camera;
			//添加碰撞事件脚本
			layaMonkeyMeshSprite3D.addComponent(common.ColliderScript);
			//添加刚体组件
			layaMonkeyMeshSprite3D.addComponent(Rigidbody);
			//添加键盘事件
			Laya.stage.on(Event.KEY_DOWN, this, onKeyDown);
			
			collider = scene.getChildByName("Collider") as MeshSprite3D;
			collider.active = false;
			
			//是否开启debug模式
			Laya.stage.on(Event.MOUSE_UP, this, drawCollider);
		}
		
		private function onKeyDown(e:Event = null):void
		{
			if (e.keyCode == Keyboard.UP)
				layaMonkey.transform.translate(_tempUnitX1);
			else if (e.keyCode == Keyboard.DOWN)
				layaMonkey.transform.translate(_tempUnitX2);
			else if (e.keyCode == Keyboard.LEFT)
				layaMonkey.transform.translate(_tempUnitX3);
			else if (e.keyCode == Keyboard.RIGHT)
				layaMonkey.transform.translate(_tempUnitX4);
		}
		
		private function drawCollider():void{
			
			if (!debug){
				collider.active = false;
				layaMonkeyMeshSprite3D.removeComponentByType(DrawBoxColliderScript);
				debug = true;
			}
			else{
				collider.active = true;
				layaMonkeyMeshSprite3D.addComponent(DrawBoxColliderScript);
				debug = false;
			}
		}
    }
}
