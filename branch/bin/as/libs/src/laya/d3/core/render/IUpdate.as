package laya.d3.core.render {
	
	/**
	 * <code>IUpdate</code> 接口用于实现3D对象的更新相关功能。
	 */
	public interface IUpdate {
		function _update(state:RenderState):void;
	}
}