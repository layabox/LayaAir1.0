package laya.d3.utils {
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.utils.Stat;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Physics {
		private static var _tempVector30:Vector3 = new Vector3();
		private static var _tempVector31:Vector3 = new Vector3();
		private static var _tempVector33:Vector3 = new Vector3();
		private static var _tempMatrix4x40:Matrix4x4 = new Matrix4x4();
		private static var _tempRaycastHit0:RaycastHit = new RaycastHit();
		
		public function Physics() {
		}
		
		public static function rayCastNode(ray:Ray, sprite3D:Sprite3D, outHitInfo:RaycastHit):void {//TODO:可能非Mesh
			if (sprite3D is MeshSprite3D) {
				var meshSprite3D:MeshSprite3D = sprite3D as MeshSprite3D;
				var worldMatrix:Matrix4x4 = sprite3D.transform.worldMatrix;
				
				var invertWorldMatrix:Matrix4x4 = _tempMatrix4x40;
				worldMatrix.invert(invertWorldMatrix);
				
				var preRayOrigin:Vector3 = _tempVector30;
				var preRayDirection:Vector3 = _tempVector31;
				var rayOrigin:Vector3 = ray.origin;
				var rayDirection:Vector3 = ray.direction;
				rayOrigin.cloneTo(preRayOrigin);
				rayDirection.cloneTo(preRayDirection);
				
				Vector3.transformCoordinate(rayOrigin, invertWorldMatrix, rayOrigin);
				Vector3.TransformNormal(rayDirection, invertWorldMatrix, rayDirection);
				Vector3.normalize(rayDirection,rayDirection);//TODO:方向不是单位向量，计算出具体有问题，为矢量长度分之一。
				
				var renderElements:Vector.<RenderElement> = meshSprite3D.meshRender.renderCullingObject._renderElements;
				for (var i:int = 0, iNum:int = renderElements.length; i < iNum; i++) {
					
					var renderObj:IRenderable = renderElements[i].renderObj;
					var vertexBuffer:VertexBuffer3D = renderObj._getVertexBuffer(0);
					var vertexDatas:Float32Array = vertexBuffer.getData();//TODO:可能有多个VB,没渲染到屏幕上可以不检测
					var indexDatas:Uint16Array = renderObj._getIndexBuffer().getData();
					var elementRaycastHit:RaycastHit = _tempRaycastHit0;
					
					var isHit:Boolean = Picker.rayIntersectsPositionsAndIndices(ray, vertexDatas, vertexBuffer.vertexDeclaration, indexDatas, elementRaycastHit);
					if (isHit) {
						Vector3.transformCoordinate(elementRaycastHit.position, worldMatrix, elementRaycastHit.position);
						
						var trianglePositions:Array = elementRaycastHit.trianglePositions;
						Vector3.transformCoordinate(trianglePositions[0], worldMatrix, trianglePositions[0]);
						Vector3.transformCoordinate(trianglePositions[1], worldMatrix, trianglePositions[1]);
						Vector3.transformCoordinate(trianglePositions[2], worldMatrix, trianglePositions[2]);
						
						var triangleNormals:Array = elementRaycastHit.triangleNormals;
						Vector3.transformCoordinate(triangleNormals[0], worldMatrix, triangleNormals[0]);//TODO:不一定有法线
						Vector3.transformCoordinate(triangleNormals[1], worldMatrix, triangleNormals[1]);
						Vector3.transformCoordinate(triangleNormals[2], worldMatrix, triangleNormals[2]);
						
						var rayOriToPos:Vector3 = _tempVector33;
						Vector3.subtract(preRayOrigin, elementRaycastHit.position, rayOriToPos);
						outHitInfo.distance = Vector3.scalarLength(rayOriToPos);
					}
					
					if (isHit && elementRaycastHit.distance < outHitInfo.distance) {
						elementRaycastHit.copy(outHitInfo);
					}
				}
				
				preRayOrigin.cloneTo(rayOrigin);
				preRayDirection.cloneTo(rayDirection);
			}
			
			for (var j:int = 0, jNum:int = sprite3D._childs.length; j < jNum; j++)
				rayCast(ray, sprite3D._childs[j], outHitInfo);
		}
		
		public static function rayCast(ray:Ray, sprite3D:Sprite3D, outHitInfo:RaycastHit):void {
			outHitInfo.position.toDefault();
			outHitInfo.distance = Number.MAX_VALUE;
			outHitInfo.trianglePositions[0].toDefault();
			outHitInfo.trianglePositions[1].toDefault();
			outHitInfo.trianglePositions[2].toDefault();
			outHitInfo.triangleNormals[0].toDefault();
			outHitInfo.triangleNormals[1].toDefault();
			outHitInfo.triangleNormals[2].toDefault();
			
			rayCastNode(ray, sprite3D, outHitInfo);
		}
	}

}