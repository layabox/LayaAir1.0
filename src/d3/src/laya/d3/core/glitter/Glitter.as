package laya.d3.core.glitter {
	import laya.d3.core.GlitterRender;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.GlitterMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.tempelet.GlitterTemplet;
	import laya.display.Node;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.resource.WebGLImage;
	
	/**
	 * <code>Glitter</code> 类用于创建闪光。
	 */
	public class Glitter extends Sprite3D {
		/** @private */
		private var _templet:GlitterTemplet;
		/** @private */
		private var _glitterRender:GlitterRender;
		
		/**
		 * 获取闪光模板。
		 * @return  闪光模板。
		 */
		public function get templet():GlitterTemplet {
			return _templet;
		}
		
		/**
		 * 获取刀光渲染器。
		 * @return  刀光渲染器。
		 */
		public function get glitterRender():GlitterRender {
			return _glitterRender;
		}
		
		/**
		 * 创建一个 <code>Glitter</code> 实例。
		 *  @param	settings 配置信息。
		 */
		public function Glitter() {
			_glitterRender = new GlitterRender(this);
			_glitterRender.on(Event.MATERIAL_CHANGED, this, _onMaterialChanged);
			
			var material:GlitterMaterial = new GlitterMaterial();
			
			_glitterRender.sharedMaterial = material;
			_templet = new GlitterTemplet(this);
			
			material.renderMode = BaseMaterial.RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE;
			
			_changeRenderObject(0);
		
		}
		
		/** @private */
		private function _changeRenderObject(index:int):RenderElement {
			var renderObjects:Vector.<RenderElement> = _glitterRender.renderObject._renderElements;
			
			var renderElement:RenderElement = renderObjects[index];
			(renderElement) || (renderElement = renderObjects[index] = new RenderElement());
			renderElement._renderObject = _glitterRender.renderObject;
			
			var material:BaseMaterial = _glitterRender.sharedMaterials[index];
			(material) || (material = GlitterMaterial.defaultMaterial);//确保有材质,由默认材质代替。
			
			var element:IRenderable = _templet;
			renderElement._mainSortID = 0;
			renderElement._sprite3D = this;
			
			renderElement.renderObj = element;
			renderElement._material = material;
			return renderElement;
		}
		
		/** @private */
		private function _onMaterialChanged(_glitterRender:GlitterRender, index:int, material:BaseMaterial):void {
			var renderElementCount:int = _glitterRender.renderObject._renderElements.length;
			(index < renderElementCount) && _changeRenderObject(index);
		}
		
		/** @private */
		override protected function _clearSelfRenderObjects():void {
			scene.removeFrustumCullingObject(_glitterRender.renderObject);
		}
		
		/** @private */
		override protected function _addSelfRenderObjects():void {
			scene.addFrustumCullingObject(_glitterRender.renderObject);
		}
		
		/**
		 * @private
		 * 更新闪光。
		 * @param	state 渲染状态参数。
		 */
		public override function _update(state:RenderState):void {
			_templet._update(state.elapsedTime);
			state.owner = this;
			
			Stat.spriteCount++;
			_childs.length && _updateChilds(state);
		}
		
		/**
		 * @private
		 */
		override public function _prepareShaderValuetoRender(view:Matrix4x4, projection:Matrix4x4, projectionView:Matrix4x4):void {
			_setShaderValueMatrix4x4(Sprite3D.WORLDMATRIX, transform.worldMatrix);
			var projViewWorld:Matrix4x4 = getProjectionViewWorldMatrix(projectionView);
			_setShaderValueMatrix4x4(Sprite3D.MVPMATRIX, projViewWorld);
		}
		
		/**
		 * 通过位置添加刀光。
		 * @param position0 位置0。
		 * @param position1 位置1。
		 */
		public function addGlitterByPositions(position0:Vector3, position1:Vector3):void {
			_templet.addVertexPosition(position0, position1);
		}
		
		/**
		 * 通过位置和速度添加刀光。
		 * @param position0 位置0。
		 * @param velocity0 速度0。
		 * @param position1 位置1。
		 * @param velocity1 速度1。
		 */
		public function addGlitterByPositionsVelocitys(position0:Vector3, velocity0:Vector3, position1:Vector3, velocity1:Vector3):void {
			_templet.addVertexPositionVelocity(position0, velocity0, position1, velocity1);
		}
		
		override public function cloneTo(destObject:*):void {
			super.cloneTo(destObject);
			
			var destGlitter:Glitter = destObject as Glitter;
			var destTemplet:GlitterTemplet = destGlitter.templet;
			destTemplet.lifeTime = _templet.lifeTime;
			destTemplet.minSegmentDistance = _templet.minSegmentDistance;
			destTemplet.minInterpDistance = _templet.minInterpDistance;
			destTemplet.maxSlerpCount = _templet.maxSlerpCount;
			_templet.color.cloneTo(destTemplet.color);
			destTemplet._maxSegments = _templet._maxSegments;
			var destGlitterRender:GlitterRender = destGlitter._glitterRender;
			destGlitterRender.sharedMaterials = _glitterRender.sharedMaterials;
			destGlitterRender.enable = _glitterRender.enable;
		}
		
		/**
		 * <p>销毁此对象。</p>
		 * @param	destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			_glitterRender._destroy();
			_templet = null;
		}
	
	}
}