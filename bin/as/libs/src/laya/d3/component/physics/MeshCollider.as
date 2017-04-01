package laya.d3.component.physics {
	import laya.d3.component.Component3D;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.d3.utils.Picker;
	import laya.d3.utils.RaycastHit;
	import laya.events.Event;
	
	/**
	 * <code>MeshCollider</code> 类用于创建网格碰撞器。
	 */
	public class MeshCollider extends Collider {
		/** @private */
		private static var _tempRay0:Ray = new Ray(new Vector3(), new Vector3());
		/** @private */
		private static var _tempVector30:Vector3 = new Vector3();
		/** @private */
		private static var _tempMatrix4x40:Matrix4x4 = new Matrix4x4();
		/** @private */
		private static var _tempRaycastHit:RaycastHit = new RaycastHit();
		
		/** @private */
		public var _transformBoundSphere:BoundSphere;
		/** @private */
		private var _mesh:BaseMesh;
		
		/**
		 * 获取碰撞器网格。
		 * @return 碰撞其网格。
		 */
		public function get mesh():BaseMesh {
			return _mesh;
		}
		
		/**
		 * 设置碰撞器网格。
		 * @param value 碰撞其网格。
		 */
		public function set mesh(value:BaseMesh):void {
			_mesh = value;
		}
		
		/**
		 * 创建一个 <code>SphereCollider</code> 实例。
		 */
		public function MeshCollider() {
			_transformBoundSphere = new BoundSphere(new Vector3(0, 0, 0), 0);
		}
		
		/**
		 * @private
		 */
		private function _raycastMesh(ray:Ray, sprite3D:Sprite3D, outHitInfo:RaycastHit, maxDistance:Number = Number.MAX_VALUE):Boolean {
			var worldMatrix:Matrix4x4 = sprite3D.transform.worldMatrix;
			
			var invertWorldMatrix:Matrix4x4 = _tempMatrix4x40;
			worldMatrix.invert(invertWorldMatrix);
			
			var rayOrigin:Vector3 = ray.origin;
			var rayDirection:Vector3 = ray.direction;
			
			var transformRay:Ray = _tempRay0;
			//世界坐标转换为局部坐标
			Vector3.transformCoordinate(rayOrigin, invertWorldMatrix, transformRay.origin);
			Vector3.TransformNormal(rayDirection, invertWorldMatrix, transformRay.direction);
			
			var curMinDistance:Number = Number.MAX_VALUE;
			for (var i:int = 0, n:int = _mesh.getRenderElementsCount(); i < n; i++) {
				var renderObj:IRenderable = _mesh.getRenderElement(i);
				var vertexBuffer:VertexBuffer3D = renderObj._getVertexBuffer(0);
				var vertexDatas:Float32Array = vertexBuffer.getData();
				var indexDatas:Uint16Array = renderObj._getIndexBuffer().getData();
				var elementRaycastHit:RaycastHit = _tempRaycastHit;
				
				var isHit:Boolean = Picker.rayIntersectsPositionsAndIndices(transformRay, vertexDatas, vertexBuffer.vertexDeclaration, indexDatas, elementRaycastHit);
				if (isHit) {
					Vector3.transformCoordinate(elementRaycastHit.position, worldMatrix, elementRaycastHit.position);
					
					var rayOriToPos:Vector3 = _tempVector30;
					Vector3.subtract(rayOrigin, elementRaycastHit.position, rayOriToPos);
					var distance:Number = Vector3.scalarLength(rayOriToPos);
					
					if ((distance < maxDistance) && (distance < curMinDistance)) {
						elementRaycastHit.distance = distance;
						elementRaycastHit.sprite3D = sprite3D;
						
						var trianglePositions:Array = elementRaycastHit.trianglePositions;
						Vector3.transformCoordinate(trianglePositions[0], worldMatrix, trianglePositions[0]);
						Vector3.transformCoordinate(trianglePositions[1], worldMatrix, trianglePositions[1]);
						Vector3.transformCoordinate(trianglePositions[2], worldMatrix, trianglePositions[2]);
						
						var triangleNormals:Array = elementRaycastHit.triangleNormals;
						Vector3.transformCoordinate(triangleNormals[0], worldMatrix, triangleNormals[0]);
						Vector3.transformCoordinate(triangleNormals[1], worldMatrix, triangleNormals[1]);
						Vector3.transformCoordinate(triangleNormals[2], worldMatrix, triangleNormals[2]);
						
						curMinDistance = distance;
						elementRaycastHit.cloneTo(outHitInfo);
						return true;
					}
					
					return false;
				}
				
			}
			
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _initialize(owner:Sprite3D):void {
			super._initialize(owner);
			if (_owner is MeshSprite3D) {
				var meshSprite3D:MeshSprite3D = owner as MeshSprite3D;
				_mesh = meshSprite3D.meshFilter.sharedMesh;
			}
		}
		
		/**
		 * 在场景中投下可与网格碰撞器碰撞的一条光线,获取发生碰撞的网格碰撞器信息。
		 * @param  ray        射线
		 * @param  outHitInfo 与该射线发生碰撞网格碰撞器的碰撞信息
		 * @param  distance   射线长度,默认为最大值 
		 */
		override public function raycast(ray:Ray, hitInfo:RaycastHit, maxDistance:Number = Number.MAX_VALUE):Boolean {
			if (_mesh == null || !_mesh.loaded)
				return false;
			
			var maxScale:Number;
			var transform:Transform3D = _owner.transform;
			var scale:Vector3 = transform.scale;
			if (scale.x >= scale.y && scale.x >= scale.z)
				maxScale = scale.x;
			else
				maxScale = scale.y >= scale.z ? scale.y : scale.z;
			
			var originalBoundSphere:BoundSphere = _mesh.boundingSphere;
			Vector3.transformCoordinate(originalBoundSphere.center, transform.worldMatrix, _transformBoundSphere.center);
			_transformBoundSphere.radius = originalBoundSphere.radius * maxScale;
			
			var distance:Number = _transformBoundSphere.intersectsRayPoint(ray, hitInfo.position);
			
			if (distance !== -1 && distance <= maxDistance && _raycastMesh(ray, _owner, hitInfo, maxDistance)) {
				return true;
			} else {
				hitInfo.distance = -1;
				hitInfo.sprite3D = null;
				return false;
			}
		}
	
	}

}
