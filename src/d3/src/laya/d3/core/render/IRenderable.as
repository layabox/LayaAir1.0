package laya.d3.core.render {
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	
	/**
	 * <code>IRender</code> 接口用于实现3D对象的渲染相关功能。
	 */
	public interface IRenderable {
		function get _vertexBufferCount():int;
		function get indexOfHost():int;
		function get triangleCount():int;
		
		function _getVertexBuffer(index:int = 0):VertexBuffer3D;
		function _getIndexBuffer():IndexBuffer3D;
		function _beforeRender(state:RenderState):Boolean;
		function _render(state:RenderState):void;
	}
}