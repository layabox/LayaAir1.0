package laya.d3.resource.models {
	import laya.d3.core.render.RenderState;
	import laya.resource.Resource;
	
	/**
	 * <code>Sky</code> 类用于创建天空的父类，抽象类不允许实例。
	 */
	public class Sky extends Resource {
		public static const MVPMATRIX:String = "MVPMATRIX";
		public static const INTENSITY:String = "INTENSITY";
		public static const ALPHABLENDING:String = "ALPHABLENDING";
		public static const DIFFUSETEXTURE:String = "DIFFUSETEXTURE";
		
		public function Sky() {
			super();
		}
		
		public function _render(state:RenderState):void {
		
		}
	
	}

}