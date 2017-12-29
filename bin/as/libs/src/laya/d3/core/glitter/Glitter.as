package laya.d3.core.glitter {
	import laya.d3.core.GlitterRender;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.GlitterMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Vector3;
	import laya.d3.resource.tempelet.GlitterTemplet;
	import laya.events.Event;
	
	/**
	 * <code>Glitter</code> 类用于创建闪光。
	 */
	public class Glitter extends RenderableSprite3D {
		/**@private 着色器变量名，当前时间。*/
		public static const CURRENTTIME:int = 2;
		/**@private 着色器变量名，声明周期。*/
		public static const DURATION:int = 3;
		
		/**
		 * 获取闪光模板。
		 * @return  闪光模板。
		 */
		public function get templet():GlitterTemplet {
			return _geometryFilter as GlitterTemplet;
		}
		
		/**
		 * 获取刀光渲染器。
		 * @return  刀光渲染器。
		 */
		public function get glitterRender():GlitterRender {
			return _render as GlitterRender;
		}
		
		/**
		 * 创建一个 <code>Glitter</code> 实例。
		 *  @param	settings 配置信息。
		 */
		public function Glitter() {
			_render = new GlitterRender(this);
			_render.on(Event.MATERIAL_CHANGED, this, _onMaterialChanged);
			
			var material:GlitterMaterial = new GlitterMaterial();
			
			_render.sharedMaterial = material;
			_geometryFilter = new GlitterTemplet(this);
			
			material.renderMode = GlitterMaterial.RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE;
			
			_changeRenderObject(0);
		
		}
		
		/** @private */
		private function _changeRenderObject(index:int):RenderElement {
			var renderObjects:Vector.<RenderElement> = _render._renderElements;
			
			var renderElement:RenderElement = renderObjects[index];
			(renderElement) || (renderElement = renderObjects[index] = new RenderElement());
			renderElement._render = _render;
			
			var material:BaseMaterial = _render.sharedMaterials[index];
			(material) || (material = GlitterMaterial.defaultMaterial);//确保有材质,由默认材质代替。
			
			var element:IRenderable = _geometryFilter as GlitterTemplet;
			renderElement._mainSortID = 0;
			renderElement._sprite3D = this;
			
			renderElement.renderObj = element;
			renderElement._material = material;
			return renderElement;
		}
		
		/** @private */
		private function _onMaterialChanged(_glitterRender:GlitterRender, index:int, material:BaseMaterial):void {
			var renderElementCount:int = _glitterRender._renderElements.length;
			(index < renderElementCount) && _changeRenderObject(index);
		}
		
		/** @private */
		override protected function _clearSelfRenderObjects():void {
			scene.removeFrustumCullingObject(_render);
		}
		
		/** @private */
		override protected function _addSelfRenderObjects():void {
			scene.addFrustumCullingObject(_render);
		}
		
		override public function _update(state:RenderState):void {
			(_geometryFilter as GlitterTemplet)._update(state.elapsedTime);
			super._update(state);
		}
		
		/**
		 * 通过位置添加刀光。
		 * @param position0 位置0。
		 * @param position1 位置1。
		 */
		public function addGlitterByPositions(position0:Vector3, position1:Vector3):void {
			(_geometryFilter as GlitterTemplet).addVertexPosition(position0, position1);
		}
		
		/**
		 * 通过位置和速度添加刀光。
		 * @param position0 位置0。
		 * @param velocity0 速度0。
		 * @param position1 位置1。
		 * @param velocity1 速度1。
		 */
		public function addGlitterByPositionsVelocitys(position0:Vector3, velocity0:Vector3, position1:Vector3, velocity1:Vector3):void {
			(_geometryFilter as GlitterTemplet).addVertexPositionVelocity(position0, velocity0, position1, velocity1);
		}
		
		override public function cloneTo(destObject:*):void {
			var destGlitter:Glitter = destObject as Glitter;
			var destTemplet:GlitterTemplet = destGlitter.templet;
			var templet:GlitterTemplet = _geometryFilter as GlitterTemplet;
			destTemplet.lifeTime = templet.lifeTime;
			destTemplet.minSegmentDistance = templet.minSegmentDistance;
			destTemplet.minInterpDistance = templet.minInterpDistance;
			destTemplet.maxSlerpCount = templet.maxSlerpCount;
			destTemplet._maxSegments = templet._maxSegments;
			var destGlitterRender:GlitterRender = destGlitter._render as GlitterRender;
			var glitterRender:GlitterRender = _render as GlitterRender;
			destGlitterRender.sharedMaterials = glitterRender.sharedMaterials;
			destGlitterRender.enable = glitterRender.enable;
			super.cloneTo(destObject);//父类函数在最后,组件应该最后赋值，否则获取材质默认值等相关函数会有问题
		}
		
		/**
		 * <p>销毁此对象。</p>
		 * @param	destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			if (destroyed)
				return;
			super.destroy(destroyChild);
			_geometryFilter._destroy();
			_geometryFilter = null;
		}
	
	}
}