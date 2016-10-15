package laya.d3.core.glitter {
	import laya.d3.core.GlitterRender;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.GlitterMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
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
		public function Glitter(setting:GlitterSetting) {//暂不支持更换模板和初始化后修改混合状态。
			_glitterRender = new GlitterRender(this);
			_glitterRender.on(Event.MATERIAL_CHANGED, this, _onMaterialChanged);
			
			var material:GlitterMaterial = new GlitterMaterial();
			material.setShaderName("GLITTER");
			
			if (setting.texturePath)//预设纹理ShaderValue
			{
				Laya.loader.load(setting.texturePath, Handler.create(null, function(texture:Texture2D):void {
					material.diffuseTexture = texture;
				}), null, Loader.TEXTURE2D);
			}
			
			_glitterRender.sharedMaterial = material;
			_templet = new GlitterTemplet(this, setting);
			
			material.renderMode = BaseMaterial.RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE;
			
			_changeRenderObject(0);
		
		}
		
		/** @private */
		private function _changeRenderObject(index:int):RenderElement {
			var renderObjects:Vector.<RenderElement> = _glitterRender.renderCullingObject._renderElements;
			
			var renderElement:RenderElement = renderObjects[index];
			(renderElement) || (renderElement = renderObjects[index] = new RenderElement());
			renderElement._renderCullingObject = _glitterRender.renderCullingObject;
			
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
			var renderElementCount:int = _glitterRender.renderCullingObject._renderElements.length;
			(index < renderElementCount) && _changeRenderObject(index);
		}
		
		/** @private */
		override protected function _clearSelfRenderObjects():void {
			scene.removeFrustumCullingObject(_glitterRender.renderCullingObject);
		}
		
		/** @private */
		override protected function _addSelfRenderObjects():void {
			scene.addFrustumCullingObject(_glitterRender.renderCullingObject);
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
		
		override public function dispose():void {
			super.dispose();
			_glitterRender.off(Event.MATERIAL_CHANGED, this, _onMaterialChanged);
			_templet.dispose();
		
		}
	
	}
}