package laya.d3.utils {
	import laya.d3.component.physics.Collider;
	import laya.d3.component.physics.SphereCollider;
	import laya.d3.core.Layer;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Collision;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.utils.Stat;
	
	/**
	 * <code>Physics</code> 类用于简单物理检测。
	 */
	public class Physics {
		
		/** @private */
		private static var _outHitAllInfo:Vector.<RaycastHit> = new Vector.<RaycastHit>();
		/** @private */
		private static var _outHitInfo:RaycastHit = new RaycastHit();
		
		public function Physics() {
		}
		
		/**
		 * 在场景中投下可与所有碰撞器碰撞的一条光线,获取发生碰撞的第一个碰撞器。
		 * @param  ray        射线
		 * @param  outHitInfo 与该射线发生碰撞的第一个碰撞器的碰撞信息
		 * @param  distance   射线长度,默认为最大值 
		 * @param  layer      选定制定层内的碰撞器,其他层内碰撞器忽略
		 */
		public static function rayCast(ray:Ray, outHitInfo:RaycastHit, distance:Number = Number.MAX_VALUE, layer:int = 0):void {
			_outHitAllInfo.length = 0;
			var colliders:Vector.<Collider> = Layer.getLayerByNumber(layer)._colliders;
			for (var i:int = 0, n:int = colliders.length; i < n; i++) {
				
				colliders[i].raycast(ray, _outHitInfo, distance);
				if (_outHitInfo.distance !== -1 && _outHitInfo.distance <= distance) {
					var outHit:RaycastHit = new RaycastHit();
					_outHitInfo.cloneTo(outHit);
					_outHitAllInfo.push(outHit);
				}
			}
			
			if (_outHitAllInfo.length == 0) {
				outHitInfo.sprite3D = null;
				outHitInfo.distance = -1;
				return;
			}
			
			var minDistance:Number = Number.MAX_VALUE;
			var minIndex:Number = 0;
			for (var j:int = 0; j < _outHitAllInfo.length; j++) {
				if (_outHitAllInfo[j].distance < minDistance) {
					minDistance = _outHitAllInfo[j].distance;
					minIndex = j;
				}
			}
			_outHitAllInfo[minIndex].cloneTo(outHitInfo);
		}
		
		
		/**
		 * 在场景中投下可与所有碰撞器碰撞的一条光线,获取发生碰撞的所有碰撞器。
		 * @param  ray        射线
		 * @param  outHitAllInfo 与该射线发生碰撞的所有碰撞器的碰撞信息
		 * @param  distance   射线长度,默认为最大值 
		 * @param  layer      选定制定层内的碰撞器,其他层内碰撞器忽略
		 */
		public static function rayCastAll(ray:Ray, outHitAllInfo:Vector.<RaycastHit>, distance:Number = Number.MAX_VALUE, layer:int = 0):void {
			outHitAllInfo.length = 0;
			var colliders:Vector.<Collider> = Layer.getLayerByNumber(layer)._colliders;
			for (var i:int = 0, n:int = colliders.length; i < n; i++) {
				_outHitInfo.distance = -1;
				_outHitInfo.sprite3D = null;
				
				colliders[i].raycast(ray, _outHitInfo, distance);
				if (_outHitInfo.distance !== -1 && _outHitInfo.distance <= distance) {
					var outHit:RaycastHit = new RaycastHit();
					_outHitInfo.cloneTo(outHit);
					outHitAllInfo.push(outHit);
				}
			}
		}
	
	}
}
