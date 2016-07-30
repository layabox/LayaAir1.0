package threeDimen.advancedStage {
	import laya.d3.core.Camera;
	import laya.d3.core.HeightMap;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.d3.core.PhasorSpriter3D;
	import laya.d3.core.scene.Scene;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.Material;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.math.Viewport;
	import laya.d3.utils.Picker;
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
		private var worldMats:Vector.<Matrix4x4> = new Vector.<Matrix4x4>();
		private var ray:Ray;
		
		private var vertex1:Vector3 = new Vector3();
		private var vertex2:Vector3 = new Vector3();
		private var vertex3:Vector3 = new Vector3();
		
		private var closeVertex1:Vector3 = new Vector3();
		private var closeVertex2:Vector3 = new Vector3();
		private var closeVertex3:Vector3 = new Vector3();
		private var point:Vector2 = new Vector2();
		
		public function MousePickingScene() {
			ray = new Ray(new Vector3(), new Vector3());
			
			phasorSpriter3D = new PhasorSpriter3D();
			
			currentCamera = (addChild(new Camera(0, 0.1, 100))) as Camera;
			currentCamera.transform.translate(new Vector3(0, 0.8, 1.5));
			currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			
			var sprite3d:Sprite3D = addChild(new Sprite3D()) as Sprite3D;
			sprite3d.once(Event.HIERARCHY_LOADED, null, function(spirit3D:Sprite3D):void {
				getMeshData(spirit3D);
			});
			sprite3d.loadHierarchy("../../../../res/threeDimen/staticModel/simpleScene/B00IT001M000.v3f.lh");
			sprite3d.transform.localScale = new Vector3(10, 10, 10);
		
		}
		
		private function getMeshData(spirit3D:Node):void {
			if (spirit3D is MeshSprite3D) {
				var meshSprite3D:MeshSprite3D = spirit3D as MeshSprite3D;
				var mesh:Mesh = meshSprite3D.mesh as Mesh;
				if (mesh != null) {
					
					mesh.once(Event.LOADED, null, function():void {
						meshLoaded(mesh);
						for (var i:int = 0; i < mesh.materials.length; i++)
							mesh.materials[i].luminance = 3.0;
					});
					worldMats.push(meshSprite3D.transform.worldMatrix);
				}
			}
			for (var i:int = 0; i < spirit3D.numChildren; i++)
				getMeshData(spirit3D.getChildAt(i));
		}
		
		
		
		private function meshLoaded(mesh:Mesh):void {
			var submesheCount:int = mesh.getSubMeshCount();
			
			var worldMat:Matrix4x4 = worldMats[meshCount];
			
			var positions:Vector.<Vector3> = mesh.positions;
			for (var i:int = 0; i < submesheCount; i++) {
				var subMesh:SubMesh = mesh.getSubMesh(i);
				
				var vertexBuffer:VertexBuffer3D = subMesh.getVertexBuffer();
				var verts:Float32Array = vertexBuffer.getData();
				var subMeshVertices:Vector.<Vector3> = new Vector.<Vector3>();
				
				for (var j:int = 0; j < verts.length; j += vertexBuffer.vertexDeclaration.vertexStride / 4) {
					var position:Vector3 = new Vector3(verts[j + 0], verts[j + 1], verts[j + 2]);
					
					Vector3.transformCoordinate(position, worldMat, position);
					subMeshVertices.push(position);
				}
				vertices.push(subMeshVertices);
				
				var ib:IndexBuffer3D = subMesh.getIndexBuffer();
				indexs.push(ib.getData());
			}
			meshCount++;
		}
		
		override public function lateRender(state:RenderState):void {
			super.lateRender(state);
			var camera:Camera = currentCamera as Camera;
			
			var projViewMat:Matrix4x4 = camera.projectionViewMatrix;
			
			point.elements[0] = Laya.stage.mouseX;
			point.elements[1] = Laya.stage.mouseY;
			
			camera.viewportPointToRay(point, ray);
			
			var closestIntersection:Number = Number.MAX_VALUE;
			for (var i:int = 0; i < vertices.length; i++) {
				
				var intersection:Number = Picker.rayIntersectsPositionsAndIndices(ray, vertices[i], indexs[i], vertex1, vertex2, vertex3);
				
				if (!isNaN(intersection) && intersection < closestIntersection) {
					closestIntersection = intersection;
					vertex1.cloneTo(closeVertex1);
					vertex2.cloneTo(closeVertex2);
					vertex3.cloneTo(closeVertex3);
					
				}
			}
			
			phasorSpriter3D.begin(WebGLContext.LINES, projViewMat, state);
			var original:Vector3 = ray.origin;
			phasorSpriter3D.line(original.x, original.y, original.z, 1.0, 0.0, 0.0, 1.0, 0, 0, 0, 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.line(closeVertex1.elements[0], closeVertex1.elements[1], closeVertex1.elements[2], 1.0, 0.0, 0.0, 1.0, closeVertex2.elements[0], closeVertex2.elements[1], closeVertex2.elements[2], 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.line(closeVertex2.elements[0], closeVertex2.elements[1], closeVertex2.elements[2], 1.0, 0.0, 0.0, 1.0, closeVertex3.elements[0], closeVertex3.elements[1], closeVertex3.elements[2], 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.line(closeVertex3.elements[0], closeVertex3.elements[1], closeVertex3.elements[2], 1.0, 0.0, 0.0, 1.0, closeVertex1.elements[0], closeVertex1.elements[1], closeVertex1.elements[2], 1.0, 0.0, 0.0, 1.0);
			phasorSpriter3D.end();
		}
	
	}

}