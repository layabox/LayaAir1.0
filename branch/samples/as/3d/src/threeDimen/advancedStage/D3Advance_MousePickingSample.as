package threeDimen.advancedStage
{
	import laya.ani.AnimationTemplet;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.component.physics.BoxCollider;
	import laya.d3.component.physics.MeshCollider;
	import laya.d3.component.physics.SphereCollider;
	import laya.d3.core.Camera;
	import laya.d3.core.Layer;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.PhasorSpriter3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.light.PointLight;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.OrientedBoundBox;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SphereMesh;
	import laya.d3.utils.Physics;
	import laya.d3.utils.RaycastHit;
	import laya.display.Node;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.ui.Label;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	import threeDimen.common.CameraMoveScript;
	
	public class D3Advance_MousePickingSample
	{
		private var label:Label;
		
		public function D3Advance_MousePickingSample()
		{
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			label = new Label();
			label.text = "是否发生碰撞";
			label.pos(300, 100);
			label.fontSize = 60;
			label.color = "#40FF40";
			
			Laya.stage.addChild(new MousePickingScene(label));
			
			Laya.stage.addChild(label);
		}
	}
	
	class MousePickingScene extends Scene
	{
		private var curLabel:Label;
		private var ray:Ray = new Ray(new Vector3(0, 0, 0), new Vector3(0, 0, 0));
		private var point:Vector2 = new Vector2();
		private var camera:Camera;
		
		private var sprite3d1:MeshSprite3D;
		private var sprite3d2:MeshSprite3D;
		private var sprite3d3:MeshSprite3D;
		private var sprite3d4:MeshSprite3D;
		
		private var _outHitInfo:RaycastHit = new RaycastHit();
		private var _outHitAllInfo:Vector.<RaycastHit> = new Vector.<RaycastHit>();
		private var _posiV3:Vector3 = new Vector3();
		private var _scaleV3:Vector3 = new Vector3();
		private var _rotaV3:Vector3 = new Vector3(0, 1, 0);
		
		private var phasorSpriter3D:PhasorSpriter3D = new PhasorSpriter3D();
		
		private var sphereSprite3d:MeshSprite3D;
		private var sphereMesh:SphereMesh;
		private var obb:OrientedBoundBox;
		private var sphere:BoundSphere;
		private var _corners:Vector.<Vector3> = new Vector.<Vector3>();
		private var _scale:Number = 1;
		private var _scaleIndex:Number = -1;
		
		private var str1:String = "女巫 : 爱上一只村民 , 可惜家里没有 … … (MeshCollider)";
		private var str2:String = "村民 : 谁说癞蛤蟆吃不到天鹅肉，哼 ~  (MeshCollider)";
		private var str3:String = "小飞龙 : 别摸我，烦着呢 ！ (SphereCollider)";
		private var str4:String = "死胖子 : 不吃饱哪有力气减肥？ (BoxCollider)";
		private var str5:String = "旁白 : 秀恩爱，死得快！ (MeshCollider)";
		
		public function MousePickingScene(label:Label)
		{
			curLabel = label;
			
			_corners[0] = new Vector3();
			_corners[1] = new Vector3();
			_corners[2] = new Vector3();
			_corners[3] = new Vector3();
			_corners[4] = new Vector3();
			_corners[5] = new Vector3();
			_corners[6] = new Vector3();
			_corners[7] = new Vector3();
			
			//初始化照相机
			camera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			camera.transform.translate(new Vector3(0, 1, 3));
			//camera.addComponent(CameraMoveScript);
			camera.clearColor = null;
			
			//添加精灵到场景
			sprite3d1 = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/skinModel/NvWu/NvWu-shenminvwu.lm"))) as MeshSprite3D;
			sprite3d2 = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/skinModel/CunMinNan/CunMinNan-cunminnan.lm"))) as MeshSprite3D;
			sprite3d3 = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/skinModel/XiaoFeiLong/XiaoFeiLong-xiaofeilong.lm"))) as MeshSprite3D;
			sprite3d4 = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/skinModel/PangZi/PangZi-doubipangzi.lm"))) as MeshSprite3D;
			
			sprite3d1.transform.position = new Vector3(-0.6, 0, -0.2);
			sprite3d2.transform.position = new Vector3(0.1, 0, 0);
			sprite3d3.transform.position = new Vector3(-2.3, 0, 0);
			sprite3d4.transform.position = new Vector3(1.8, 0, 0);
			
			sprite3d1.name = str1;
			sprite3d2.name = str2;
			sprite3d3.name = str3;
			sprite3d4.name = str4;
			
			//指定精灵的层
			sprite3d1.layer = Layer.getLayerByNumber(10);
			sprite3d2.layer = Layer.getLayerByNumber(10);
			sprite3d3.layer = Layer.getLayerByNumber(13);
			sprite3d4.layer = Layer.getLayerByNumber(13);
			
			/**
			 * 给精灵添加碰撞器组件
			 * BoxCollider    : 盒型碰撞器
			 * SphereCollider : 球型碰撞器
			 * MeshCollider   : 网格碰撞器
			 */
			sprite3d1.addComponent(MeshCollider);
			sprite3d2.addComponent(MeshCollider);
			sprite3d3.addComponent(SphereCollider);
			sprite3d4.addComponent(BoxCollider);
		
			//用球模拟精灵的球体碰撞器
			sphereMesh = new SphereMesh(1, 32, 32);
			sphereSprite3d = scene.addChild(new MeshSprite3D(sphereMesh)) as MeshSprite3D;
			sprite3d3.meshFilter.sharedMesh.once(Event.LOADED, this, function():void{
				var mat:StandardMaterial = new StandardMaterial();
				mat.albedo = new Vector4(1, 1, 1, 0.5);
				mat.renderMode = 5;
				sphereSprite3d.meshRender.material = mat;
			});
			
		}
		
		override public function lateRender(state:RenderState):void
		{
			super.lateRender(state);
			
			//从屏幕空间生成射线
			point.elements[0] = Laya.stage.mouseX;
			point.elements[1] = Laya.stage.mouseY;
			camera.viewportPointToRay(point, ray);
			
			//变化小飞龙的缩放和位置，并更新其模拟碰撞器
			if(_scale >= 1)
				_scaleIndex = -1;
			else if (_scale <= 0.5){
				_scaleIndex = 1;
			}
			_scale += _scaleIndex * 0.005;
			
			var scaleV3E:Float32Array = _scaleV3.elements;
			scaleV3E[0] = scaleV3E[1] = scaleV3E[2] = _scale;
			sprite3d3.transform.localScale = _scaleV3;
			
			var posiV3E:Float32Array = _posiV3.elements;
			posiV3E[0] = -2.3;
			posiV3E[1] = _scale - 0.5;
			posiV3E[2] = 0;
			sprite3d3.transform.position = _posiV3;
			
			sphere = (sprite3d3.getComponentByIndex(0) as SphereCollider).boundSphere;
			sphereMesh.radius = sphere.radius;
			sphereSprite3d.transform.position = sphere.center;
			
			//旋转胖子，并得到obb包围盒顶点
			sprite3d4.transform.rotate(_rotaV3, true, false);
			obb = (sprite3d4.getComponentByIndex(0) as BoxCollider).boundBox;
			obb.getCorners(_corners);
			
			var str:String = "";
			
			//射线检测,射线相交的<所有物体>,最大检测距离30米,只检测第10层
			Physics.rayCastAll(ray, _outHitAllInfo, 30, 10);
			for (var i:int = 0; i < _outHitAllInfo.length; i++)
			{
				str += _outHitAllInfo[i].sprite3D.name + " ";
				if (_outHitAllInfo.length !== 1)
					str = str5;
			}
			
			//射线检测,射线相交的<最近物体>,最大检测距离30米,只检测第13层
			Physics.rayCast(ray, _outHitInfo, 30, 13);
			if (_outHitInfo.distance !== -1){
				str = _outHitInfo.sprite3D.name;
			}
			
			curLabel.text = str;
			
			phasorSpriter3D.begin(WebGLContext.LINES, state);
			
			//绘出射线
			phasorSpriter3D.line(ray.origin.x, ray.origin.y, ray.origin.z, 1.0, 0.0, 0.0, 1.0, 0, -1, 0, 1.0, 0.0, 0.0, 1.0);
			
			//绘出MeshCollider检测出物体的3角面
			for (var i:int = 0; i < _outHitAllInfo.length; i++){
				
				var trianglePositions = _outHitAllInfo[i].trianglePositions;
				var vertex1:Vector3 = trianglePositions[0];
				var vertex2:Vector3 = trianglePositions[1];
				var vertex3:Vector3 = trianglePositions[2];
				var v1X:Number = vertex1.x, v1Y:Number = vertex1.y, v1Z:Number = vertex1.z;
				var v2X:Number = vertex2.x, v2Y:Number = vertex2.y, v2Z:Number = vertex2.z;
				var v3X:Number = vertex3.x, v3Y:Number = vertex3.y, v3Z:Number = vertex3.z;

				phasorSpriter3D.line(v1X, v1Y, v1Z, 1.0, 0.0, 0.0, 1.0, v2X, v2Y, v2Z, 1.0, 0.0, 0.0, 1.0);
				phasorSpriter3D.line(v2X, v2Y, v2Z, 1.0, 0.0, 0.0, 1.0, v3X, v3Y, v3Z, 1.0, 0.0, 0.0, 1.0);
				phasorSpriter3D.line(v3X, v3Y, v3Z, 1.0, 0.0, 0.0, 1.0, v1X, v1Y, v1Z, 1.0, 0.0, 0.0, 1.0);
			}
			
			//绘出BoxCollider的OBB型包围盒
			phasorSpriter3D.line(_corners[0].x, _corners[0].y, _corners[0].z, 1.0, 0.0, 0.0, 1.0, _corners[1].x, _corners[1].y, _corners[1].z, 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.line(_corners[1].x, _corners[1].y, _corners[1].z, 1.0, 0.0, 0.0, 1.0, _corners[2].x, _corners[2].y, _corners[2].z, 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.line(_corners[2].x, _corners[2].y, _corners[2].z, 1.0, 0.0, 0.0, 1.0, _corners[3].x, _corners[3].y, _corners[3].z, 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.line(_corners[3].x, _corners[3].y, _corners[3].z, 1.0, 0.0, 0.0, 1.0, _corners[0].x, _corners[0].y, _corners[0].z, 1.0, 0.0, 0.0, 1.0);
			
			phasorSpriter3D.line(_corners[4].x, _corners[4].y, _corners[4].z, 1.0, 0.0, 0.0, 1.0, _corners[5].x, _corners[5].y, _corners[5].z, 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.line(_corners[5].x, _corners[5].y, _corners[5].z, 1.0, 0.0, 0.0, 1.0, _corners[6].x, _corners[6].y, _corners[6].z, 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.line(_corners[6].x, _corners[6].y, _corners[6].z, 1.0, 0.0, 0.0, 1.0, _corners[7].x, _corners[7].y, _corners[7].z, 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.line(_corners[7].x, _corners[7].y, _corners[7].z, 1.0, 0.0, 0.0, 1.0, _corners[4].x, _corners[4].y, _corners[4].z, 1.0, 0.0, 0.0, 1.0);
			
			phasorSpriter3D.line(_corners[0].x, _corners[0].y, _corners[0].z, 1.0, 0.0, 0.0, 1.0, _corners[4].x, _corners[4].y, _corners[4].z, 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.line(_corners[1].x, _corners[1].y, _corners[1].z, 1.0, 0.0, 0.0, 1.0, _corners[5].x, _corners[5].y, _corners[5].z, 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.line(_corners[2].x, _corners[2].y, _corners[2].z, 1.0, 0.0, 0.0, 1.0, _corners[6].x, _corners[6].y, _corners[6].z, 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.line(_corners[3].x, _corners[3].y, _corners[3].z, 1.0, 0.0, 0.0, 1.0, _corners[7].x, _corners[7].y, _corners[7].z, 1.0, 0.0, 0.0, 1.0);
			
			phasorSpriter3D.line(_corners[0].x, _corners[0].y, _corners[0].z, 1.0, 0.0, 0.0, 1.0, _corners[1].x, _corners[1].y, _corners[1].z, 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.line(_corners[1].x, _corners[1].y, _corners[1].z, 1.0, 0.0, 0.0, 1.0, _corners[2].x, _corners[2].y, _corners[2].z, 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.line(_corners[2].x, _corners[2].y, _corners[2].z, 1.0, 0.0, 0.0, 1.0, _corners[3].x, _corners[3].y, _corners[3].z, 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.line(_corners[3].x, _corners[3].y, _corners[3].z, 1.0, 0.0, 0.0, 1.0, _corners[0].x, _corners[0].y, _corners[0].z, 1.0, 0.0, 0.0, 1.0);
			
			phasorSpriter3D.line(_corners[4].x, _corners[4].y, _corners[4].z, 1.0, 0.0, 0.0, 1.0, _corners[5].x, _corners[5].y, _corners[5].z, 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.line(_corners[5].x, _corners[5].y, _corners[5].z, 1.0, 0.0, 0.0, 1.0, _corners[6].x, _corners[6].y, _corners[6].z, 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.line(_corners[6].x, _corners[6].y, _corners[6].z, 1.0, 0.0, 0.0, 1.0, _corners[7].x, _corners[7].y, _corners[7].z, 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.line(_corners[7].x, _corners[7].y, _corners[7].z, 1.0, 0.0, 0.0, 1.0, _corners[4].x, _corners[4].y, _corners[4].z, 1.0, 0.0, 0.0, 1.0);
			
			phasorSpriter3D.line(_corners[0].x, _corners[0].y, _corners[0].z, 1.0, 0.0, 0.0, 1.0, _corners[4].x, _corners[4].y, _corners[4].z, 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.line(_corners[1].x, _corners[1].y, _corners[1].z, 1.0, 0.0, 0.0, 1.0, _corners[5].x, _corners[5].y, _corners[5].z, 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.line(_corners[2].x, _corners[2].y, _corners[2].z, 1.0, 0.0, 0.0, 1.0, _corners[6].x, _corners[6].y, _corners[6].z, 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.line(_corners[3].x, _corners[3].y, _corners[3].z, 1.0, 0.0, 0.0, 1.0, _corners[7].x, _corners[7].y, _corners[7].z, 1.0, 0.0, 0.0, 1.0);
		
			phasorSpriter3D.end();
		
		}
	
	}
}
