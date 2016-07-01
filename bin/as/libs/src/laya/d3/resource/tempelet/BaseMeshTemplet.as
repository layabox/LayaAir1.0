package laya.d3.resource.tempelet {
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.resource.Resource;
	
	/**
	 * ...
	 * @author ...
	 */
	
	/**抽象类。*/
	public class BaseMeshTemplet extends Resource {
		private var _subMeshCount:int;
		private var _boundingBox:BoundBox;
		private var _boundingSphere:BoundSphere;
		
		public function get subMeshCount():int {
			return _subMeshCount;
		}
		
		/**通常禁止修改其属性*/
		public function get boundingBox():BoundBox {
			return _boundingBox;
		}
		
		/**通常禁止修改其属性*/
		public function get boundingSphere():BoundSphere {
			return _boundingSphere;
		}
		
		/**请重载此方法。*/
		public function get positions():Array {
			throw new Error("未Override,请重载该属性！");
		}
		
		public function BaseMeshTemplet() {
		
		}
		
		/**请重载此方法。*/
		public function Render():void {
			throw new Error("未Override,请重载该方法！");
		}
		
		/**请重载此方法。*/
		public function RenderSubMesh(subMeshIndex:int):void {
			throw new Error("未Override,请重载该方法！");
		}
	
	}

}