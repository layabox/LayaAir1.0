package laya.d3.utils {
	import laya.d3.component.physics.Collider;
	import laya.d3.core.Layer;
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>Physics</code> 类用于简单物理检测。
	 */
	public class Physics {
		/** @private */
		private static var _outHitAllInfo:Vector.<RaycastHit> = new Vector.<RaycastHit>();
		/** @private */
		private static var _outHitInfo:RaycastHit = new RaycastHit();
		/** @private */
		public static var _layerCollsionMatrix:Array = [];
		
		/**碰撞管理器。*/
		public static var collisionManager:CollisionManager = new CollisionManager();
		/**重力值。*/
		public static var gravity:Vector3 = new Vector3(0, -9.81, 0);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			var maxCount:int = Layer.maxCount;
			_layerCollsionMatrix.length = maxCount;
			for (var i:int = 0; i < maxCount; i++) {
				var collArray:Array = [];
				var count:int = maxCount - i;
				collArray.length = count;
				for (var j:int = 0; j < count; j++)
					if (j === count - 1)
						collArray[j] = true;
					else
						collArray[j] = false;
				_layerCollsionMatrix[i] = collArray;
			}
		}
		
		/**
		 * 创建一个 <code>Physics</code> 实例。
		 */
		public function Physics() {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		}
		
		/**
		 * 是否忽略两个层之间所有碰撞器的碰撞检测。
		 * @param	layer1 层一。
		 * @param	layer2 层二。
		 * @param	ignore 是否忽略。
		 */
		public static function setLayerCollision(layer1:Layer, layer2:Layer, collison:Boolean):void {
			_layerCollsionMatrix[layer1.number][(Layer.maxCount - 1) - layer2.number] = collison;
		}
		
		/**
		 * 获取两个层之间是否忽略碰撞检测。
		 * @param	layer1 层一。
		 * @param	layer2 层二。
		 * @return	是否忽略。
		 */
		public static function getLayerCollision(layer1:Layer, layer2:Layer):Boolean {
			return _layerCollsionMatrix[layer1.number][(Layer.maxCount - 1) - layer2.number];
		}
		
		/**
		 * 是否忽略两个碰撞器的碰撞检测。
		 * @param	collider1 碰撞器一。
		 * @param	collider2 碰撞器二。
		 * @param	ignore 是否忽略。
		 */
		public static function setColliderCollision(collider1:Collider, collider2:Collider, collsion:Boolean):void {
			if (collsion) {
				delete collider1._ignoreCollisonMap[collider2.id];
				delete collider2._ignoreCollisonMap[collider1.id];
			} else {
				collider1._ignoreCollisonMap[collider2.id] = collider2;
				collider2._ignoreCollisonMap[collider1.id] = collider1;
			}
		}
		
		/**
		 * 获取是否忽略两个碰撞器的碰撞检测。
		 * @param	collider1 碰撞器一。
		 * @param	collider2 碰撞器二。
		 * @return	是否忽略。
		 */
		public static function getIColliderCollision(collider1:Collider, collider2:Collider):Boolean {
			return collider1._ignoreCollisonMap[collider2.id] ? true : false;
		}
		
		/**
		 * 在场景中投下可与所有碰撞器碰撞的一条光线,获取发生碰撞的第一个碰撞器。
		 * @param  ray        射线
		 * @param  outHitInfo 与该射线发生碰撞的第一个碰撞器的碰撞信息
		 * @param  distance   射线长度,默认为最大值
		 * @param  layer      选定制定层内的碰撞器,其他层内碰撞器忽略
		 */
		public static function rayCast(ray:Ray, outHitInfo:RaycastHit, distance:Number = 1.79e+308/*Number.MAX_VALUE*/, layer:int = 0):void {
			_outHitAllInfo.length = 0;
			var colliders:Vector.<Collider> = Layer.getLayerByNumber(layer)._colliders;
			for (var i:int = 0, n:int = colliders.length; i < n; i++) {
				var collider:Collider = colliders[i];
				if (collider.enable) {
					collider.raycast(ray, _outHitInfo, distance);
					if (_outHitInfo.distance !== -1 && _outHitInfo.distance <= distance) {
						var outHit:RaycastHit = new RaycastHit();
						_outHitInfo.cloneTo(outHit);
						_outHitAllInfo.push(outHit);
					}
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
		public static function rayCastAll(ray:Ray, outHitAllInfo:Vector.<RaycastHit>, distance:Number = 1.79e+308/*Number.MAX_VALUE*/, layer:int = 0):void {
			outHitAllInfo.length = 0;
			var colliders:Vector.<Collider> = Layer.getLayerByNumber(layer)._colliders;
			for (var i:int = 0, n:int = colliders.length; i < n; i++) {
				var collider:Collider = colliders[i];
				if (collider.enable) {
					_outHitInfo.distance = -1;
					_outHitInfo.sprite3D = null;
					collider.raycast(ray, _outHitInfo, distance);
					if (_outHitInfo.distance !== -1 && _outHitInfo.distance <= distance) {
						var outHit:RaycastHit = new RaycastHit();
						_outHitInfo.cloneTo(outHit);
						outHitAllInfo.push(outHit);
					}
				}
			}
		}
	
	}
}
