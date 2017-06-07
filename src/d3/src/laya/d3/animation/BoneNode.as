package laya.d3.animation {
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Vector3;
	import laya.maths.Matrix;
	
	/**
	 * <code>BoneNode</code> 类用于实现骨骼节点。
	 */
	public class BoneNode {
		/**@private */
		private var _name:String;
		/**@private */
		private var _childs:Vector.<BoneNode>;
		/**@private */
		private var _attchSprite3Ds:Vector.<Sprite3D>;
		
		/**@private */
		public var _transform:Matrix;
		
		/**
		 * 获取挂点精灵集合。
		 * @return 挂点精灵集合。
		 */
		public function get attchSprite3Ds():Vector.<Sprite3D> {
			return _attchSprite3Ds;
		}
		
		/**
		 * 创建一个新的 <code>BoneNode</code> 实例。
		 */
		public function BoneNode(name:String) {
			_childs = new Vector.<BoneNode>();
			_attchSprite3Ds = new Vector.<Sprite3D>();
			_transform = new Matrix();
			_name = name;
		}
		
		/**
		 * 添加子节点。
		 * @param	child  子节点。
		 */
		public function addChild(child:BoneNode):void {
			_childs.push(child);
		}
		
		/**
		 * 移除子节点。
		 * @param	child 子节点。
		 */
		public function removeChild(child:BoneNode):void {
			var index:int = _childs.indexOf(child);
			(index !== -1) && (_childs.splice(index, 1));
		}
	
	}

}