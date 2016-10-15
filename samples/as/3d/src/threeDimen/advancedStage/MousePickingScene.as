package threeDimen.advancedStage {
	import laya.d3.core.Camera;
	import laya.d3.core.HeightMap;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.d3.core.PhasorSpriter3D;
	import laya.d3.core.scene.Scene;
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.math.Viewport;
	import laya.d3.utils.Physics;
	import laya.d3.utils.Picker;
	import laya.d3.utils.RaycastHit;
	import laya.display.Node;
	import laya.events.Event;
	import laya.renders.RenderContext;
	import laya.utils.Handler;
	import laya.webgl.utils.Buffer;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MousePickingScene extends Scene {
		private var meshCount:int = 0;
		private var phasorSpriter3D:PhasorSpriter3D;
		private var sprite3d:Sprite3D;
		private var vertices:Vector.<Vector.<Vector3>> = new Vector.<Vector.<Vector3>>();
		private var indexs:Vector.<Uint16Array> = new Vector.<Uint16Array>();
		private var ray:Ray;
		private var point:Vector2 = new Vector2();
		private var raycastHit:RaycastHit = new RaycastHit();
		private var  camera:Camera;
		
		public function MousePickingScene() {
			ray = new Ray(new Vector3(), new Vector3());
			
			phasorSpriter3D = new PhasorSpriter3D();
			
			 camera = (addChild(new Camera(0, 0.1, 100))) as Camera;
			camera.transform.translate(new Vector3(0, 0.8, 1.5));
			camera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			
			sprite3d = addChild(new Sprite3D()) as Sprite3D;
			sprite3d.once(Event.HIERARCHY_LOADED, null, function(spirit3D:Sprite3D):void {
				setMaterial(spirit3D);
			});
			sprite3d.loadHierarchy("../../../../res/threeDimen/staticModel/simpleScene/B00IT001M000.v3f.lh");
			sprite3d.transform.localScale = new Vector3(10, 10, 10);
		}
		
		private function setMaterial(spirit3D:Node):void {
			if (spirit3D is MeshSprite3D) {
				var meshSprite3D:MeshSprite3D = spirit3D as MeshSprite3D;
				var mesh:Mesh = meshSprite3D.meshFilter.sharedMesh as Mesh;
				if (mesh != null) {
					
					mesh.once(Event.LOADED, null, function():void {
						for (var i:int = 0; i < mesh.materials.length; i++)
							(mesh.materials[i] as StandardMaterial).albedo = new Vector4(3.0, 3.0, 3.0, 1.0);
					});
				}
			}
			for (var i:int = 0; i < spirit3D.numChildren; i++)
				setMaterial(spirit3D.getChildAt(i));
		}
		
		override public function lateRender(state:RenderState):void {
			super.lateRender(state);
			var projViewMat:Matrix4x4 = camera.projectionViewMatrix;
			
			point.elements[0] = Laya.stage.mouseX;
			point.elements[1] = Laya.stage.mouseY;
			
			camera.viewportPointToRay(point, ray);
			Physics.rayCast(ray, sprite3d, raycastHit);
			if (raycastHit.distance !== Number.MAX_VALUE) {
				var trianglePositions:Array = raycastHit.trianglePositions;
				var vertex1:Vector3 = trianglePositions[0];
				var vertex2:Vector3 = trianglePositions[1];
				var vertex3:Vector3 = trianglePositions[2];
				var v1X:Number = vertex1.x, v1Y:Number = vertex1.y, v1Z:Number = vertex1.z;
				var v2X:Number = vertex2.x, v2Y:Number = vertex2.y, v2Z:Number = vertex2.z;
				var v3X:Number = vertex3.x, v3Y:Number = vertex3.y, v3Z:Number = vertex3.z;
				var position:Vector3 = raycastHit.position;
				var pX:Number = position.x, pY:Number = position.y, pZ:Number = position.z;
				
				phasorSpriter3D.begin(WebGLContext.LINES, projViewMat, state);
				var original:Vector3 = ray.origin;
				phasorSpriter3D.line(original.x, original.y, original.z, 1.0, 0.0, 0.0, 1.0, 0, 0, 0, 1.0, 0.0, 0.0, 1.0);
				phasorSpriter3D.line(v1X, v1Y, v1Z, 1.0, 0.0, 0.0, 1.0, v2X, v2Y, v2Z, 1.0, 0.0, 0.0, 1.0);
				phasorSpriter3D.line(v2X, v2Y, v2Z, 1.0, 0.0, 0.0, 1.0, v3X, v3Y, v3Z, 1.0, 0.0, 0.0, 1.0);
				phasorSpriter3D.line(v3X, v3Y, v3Z, 1.0, 0.0, 0.0, 1.0, v1X, v1Y, v1Z, 1.0, 0.0, 0.0, 1.0);
				
				phasorSpriter3D.line(pX, pY, pZ, 1.0, 0.0, 0.0, 1.0, v2X, v2Y, v2Z, 1.0, 0.0, 0.0, 1.0);
				phasorSpriter3D.line(pX, pY, pZ, 1.0, 0.0, 0.0, 1.0, v3X, v3Y, v3Z, 1.0, 0.0, 0.0, 1.0);
				phasorSpriter3D.line(pX, pY, pZ, 1.0, 0.0, 0.0, 1.0, v1X, v1Y, v1Z, 1.0, 0.0, 0.0, 1.0);
				
				phasorSpriter3D.end();
			}
		}
	
	}

}