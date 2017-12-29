package laya.d3.component.physics {
	import laya.d3.component.Component3D;
	import laya.d3.core.ComponentNode;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.core.render.IRenderable;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Collision;
	import laya.d3.math.ContainmentType;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.BaseMesh;
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
		/**@private */
		private static var _tempBoundBoxCorners:Vector.<Vector3> = new <Vector3>[new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3()];
		
		/** @private */
		private var _transformBoundingBox:BoundBox;
		/** @private */
		private var _mesh:BaseMesh;
		
		/**
		 * @private 只读,不允许修改。
		 */
		public function get _boundBox():BoundBox {
			_updateBoundBoxCollider();
			return _transformBoundingBox;
		}
		
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
			_transformBoundingBox = new BoundBox(new Vector3(), new Vector3());
			_needUpdate = false;
		}
		
		/**
		 * @private
		 */
		private function _updateBoundBoxCollider():void {
			if (_needUpdate) {
				var worldMat:Matrix4x4 = (_owner as MeshSprite3D).transform.worldMatrix;
				var corners:Vector.<Vector3> = _mesh.boundingBoxCorners;
				for (var i:int = 0; i < 8; i++)
					Vector3.transformCoordinate(corners[i], worldMat, _tempBoundBoxCorners[i]);
				BoundBox.createfromPoints(_tempBoundBoxCorners, _transformBoundingBox);
				_needUpdate = false;
			}
		}
		
		/**
		 * @private
		 */
		private function _raycastMesh(ray:Ray, sprite3D:Sprite3D, outHitInfo:RaycastHit, maxDistance:Number = 1.79e+308/*Number.MAX_VALUE*/):Boolean {
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
		 * @private
		 */
		private function _onWorldMatrixChanged():void {
			_needUpdate = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _initialize(owner:ComponentNode):void {
			super._initialize(owner);
			(owner as Sprite3D).transform.on(Event.WORLDMATRIX_NEEDCHANGE, this, _onWorldMatrixChanged);
			_needUpdate = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _getType():int {
			return 2;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _collisonTo(other:Collider):Boolean {
			var i:int, n:int;
			var positions:Vector.<Vector3> = mesh._positions;
			switch (other._getType()) {
			case 0://SphereCollider
				var otherSphere:SphereCollider = other as SphereCollider;
				if (Collision.sphereContainsBox(otherSphere.boundSphere, _boundBox) !== ContainmentType.Disjoint) {
					for (i = 0, n = positions.length; i < n; i++) {
						if (Collision.sphereContainsPoint(otherSphere.boundSphere, positions[i]) === ContainmentType.Contains)
							return true
					}
					return false;
				} else {
					return false;
				}
				break;
			case 1: //BoxCollider
				var otherBox:BoxCollider = other as BoxCollider;
				if (otherBox.boundBox.containsBoundBox(_boundBox) !== ContainmentType.Disjoint) {
					for (i = 0, n = positions.length; i < n; i++) {
						if (otherBox.boundBox.containsPoint(positions[i]) === ContainmentType.Contains)
							return true
					}
					return false;
					break;
				} else {
					return false;
				}
			
			case 2: //MeshCollider
				var otherMesh:MeshCollider = other as MeshCollider;
				if (Collision.intersectsBoxAndBox(otherMesh._boundBox, _boundBox) !== ContainmentType.Contains) {
					return true;//TODO:补充
				} else {
					return false;
				}
				
				throw new Error("MeshCollider:unknown collider type.");
				break;
			default: 
				throw new Error("MeshCollider:unknown collider type.");
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _cloneTo(dest:Component3D):void {
			var destCollider:MeshCollider = dest as MeshCollider;
			destCollider.mesh = _mesh;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function raycast(ray:Ray, hitInfo:RaycastHit, maxDistance:Number = 1.79e+308/*Number.MAX_VALUE*/):Boolean {
			if (_mesh == null || !_mesh.loaded)
				return false;
			var distance:Number = Collision.intersectsRayAndBoxRD(ray, _boundBox);
			if (distance !== -1 && distance <= maxDistance && _raycastMesh(ray, _owner as Sprite3D, hitInfo, maxDistance)) {
				return true;
			} else {
				hitInfo.distance = -1;
				hitInfo.sprite3D = null;
				return false;
			}
		}
	
	}

}
