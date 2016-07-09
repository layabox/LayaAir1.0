package laya.d3.core.glitter {
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.RenderObject;
	import laya.d3.core.render.RenderQuene;
	import laya.d3.core.render.RenderState;
	import laya.d3.resource.tempelet.GlitterTemplet;
	
	/**
	 * <code>Glitter</code> 类用于创建闪光。
	 */
	public class Glitter extends Sprite3D {
		/** @private */
		private var _templet:GlitterTemplet;
		
		/**
		 * 获取闪光模板。
		 * @return 闪光模板。
		 */
		public function get templet():GlitterTemplet {
			return _templet;
		}
		
		/**
		 * 创建一个 <code>Glitter</code> 实例。
		 *  @param	settings 配置信息。
		 */
		public function Glitter(settings:GlitterSettings) {
			_templet = new GlitterTemplet(settings);
		}
		
		/**
		 * @private
		 * 更新闪光。
		 * @param	state 渲染状态参数。
		 */
		public override function _update(state:RenderState):void {
			
			state.owner = this;
			
			var preWorldTransformModifyID:int = state.worldTransformModifyID;
			
			state.worldTransformModifyID += transform._worldTransformModifyID;
			transform.getWorldMatrix(state.worldTransformModifyID);
			
			var o:RenderObject = state.scene.getRenderObject(RenderQuene.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE);
			
			o.owner = state.owner = this;
			o.renderElement = _templet;
			o.material = null;
			
			state.worldTransformModifyID = preWorldTransformModifyID;
			
			_childs.length && _updateChilds(state);
		}
	}
}