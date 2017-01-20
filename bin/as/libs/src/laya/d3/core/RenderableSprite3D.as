package laya.d3.core {
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.OctreeNode;
	import laya.renders.Render;
	import laya.utils.Stat;
	
	/**
	 * <code>RenderableSprite3D</code> 类用于可渲染3D精灵的父类，抽象类不允许实例。
	 */
	public class RenderableSprite3D extends Sprite3D {
		
		/** @private */
		protected var _render:BaseRender;
		
		/**
		 * 创建一个 <code>RenderableSprite3D</code> 实例。
		 */
		public function RenderableSprite3D(name:String = null) {
			super(name)
		}
		
		/**
		 * @private 更新
		 * @param	state 渲染相关状态
		 */
		override public function _update(state:RenderState):void {
			state.owner = this;
			if (_enable) {
				_updateComponents(state);
				_render._updateOctreeNode();
				if (Render.isConchNode) {//NATIVE
					if (transform.worldNeedUpdate)
						_render.renderObject._conchRenderObject.matrix(transform.worldMatrix.elements);
					_render.renderObject._renderRuntime(state);
				}
				_lateUpdateComponents(state);
			}
			
			Stat.spriteCount++;
			_childs.length && _updateChilds(state);
		}
		
		/**
		 * <p>销毁此对象。</p>
		 * @param	destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			_render._destroy();
			_render = null;
		}
	
	}

}