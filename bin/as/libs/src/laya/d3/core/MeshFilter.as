package laya.d3.core {
	import laya.d3.resource.models.BaseMesh;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	
	/**更换sharedMesh时触发。
	 * @eventType Event.MESH_CHANGED
	 * */
	[Event(name = "meshchanged", type = "laya.events.Event")]
	
	/**
	 * <code>MeshFilter</code> 类用于创建网格过滤器。
	 */
	public class MeshFilter extends EventDispatcher {
		/** @private */
		private var _owner:MeshSprite3D;
		
		/** @private */
		private var _sharedMesh:BaseMesh;
		
		/**
		 * 获取共享网格。
		 * @return 共享网格。
		 */
		public function get sharedMesh():BaseMesh {
			return _sharedMesh;
		}
		
		/**
		 * 设置共享网格。
		 * @return  value 共享网格。
		 */
		public function set sharedMesh(value:BaseMesh):void {
			var oldMesh:BaseMesh = _sharedMesh;
			_sharedMesh = value;
			event(Event.MESH_CHANGED, [this, oldMesh, value]);
		}
		
		/**
		 * 创建一个新的 <code>MeshFilter</code> 实例。
		 * @param mesh 网格数据。
		 */
		public function MeshFilter(owner:MeshSprite3D) {
		
			_owner = owner;
		}
		

	
	}

}