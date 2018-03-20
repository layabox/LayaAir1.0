package laya.d3.component {
	import laya.ani.bone.canvasmesh.CacheAbleSkinMesh;
	import laya.d3.component.physics.Collider;
	import laya.d3.core.Sprite3D;
	import laya.events.Event;
	
	/**
	 * <code>Rigidbody</code> 类用于创建动画组件。
	 */
	public class Rigidbody extends Component3D {
		
		/**
		 * @inheritDoc
		 */
		override public function set enable(value:Boolean):void {
			if (_enable !== value) {
				var colliders:Vector.<Collider> = (_owner as Sprite3D)._colliders;
				for (var i:int = 0, n:int = colliders.length; i < n; i++) {
					var collider:Collider = colliders[i];
					collider._setIsRigidbody(value);
					var runtimeCollisonMap:Object = collider._runtimeCollisonMap;
					var runtimeCollisonTestMap:Object = collider._runtimeCollisonTestMap;
					if (!value) {
						for (var k:String in runtimeCollisonMap)
							delete runtimeCollisonTestMap[k];
					}
				}
				_enable = value;
				this.event(Event.ENABLE_CHANGED, _enable);
			}
		}
		
		/**
		 * 创建一个 <code>Rigidbody</code> 实例。
		 */
		public function Rigidbody() {
		
		}
	
	}

}