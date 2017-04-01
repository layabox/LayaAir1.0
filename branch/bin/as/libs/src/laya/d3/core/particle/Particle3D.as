package laya.d3.core.particle {
	import laya.d3.core.ParticleRender;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.ParticleMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.tempelet.ParticleTemplet3D;
	import laya.display.Node;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.particle.ParticleSetting;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.resource.WebGLImage;
	
	/**
	 * <code>Particle3D</code> 3D粒子。
	 */
	public class Particle3D extends RenderableSprite3D {
		
		/**@private */
		private var _setting:ParticleSetting;
		
		/**@private 粒子模板。*/
		private var _templet:ParticleTemplet3D;
		
		/**
		 * 获取粒子模板。
		 * @return  粒子模板。
		 */
		public function get templet():ParticleTemplet3D {
			return _templet;
		}
		
		/**
		 * 获取粒子渲染器。
		 * @return  粒子渲染器。
		 */
		public function get particleRender():ParticleRender {
			return _render as ParticleRender;
		}
		
		/**
		 * 创建一个 <code>Particle3D</code> 实例。
		 * @param settings value 粒子配置。
		 */
		public function Particle3D(setting:ParticleSetting) {//暂不支持更换模板和初始化后修改混合状态。
			_setting = setting;//TODO:临时
			_render = new ParticleRender(this);
			_render.on(Event.MATERIAL_CHANGED, this, _onMaterialChanged);
			
			var material:ParticleMaterial = new ParticleMaterial();
			
			if (setting.textureName)
				material.diffuseTexture = Texture2D.load(setting.textureName);
			
			_render.sharedMaterial = material;
			_templet = new ParticleTemplet3D(this, setting);
			if (setting.blendState === 0)
				material.renderMode = ParticleMaterial.RENDERMODE_DEPTHREAD_TRANSPARENT;
			else if (setting.blendState === 1)
				material.renderMode = ParticleMaterial.RENDERMODE_DEPTHREAD_ADDTIVE;
			
			_changeRenderObject(0);
		}
		
		/** @private */
		private function _changeRenderObject(index:int):RenderElement {
			var renderObjects:Vector.<RenderElement> = _render.renderObject._renderElements;
			
			var renderElement:RenderElement = renderObjects[index];
			(renderElement) || (renderElement = renderObjects[index] = new RenderElement());
			renderElement._renderObject = _render.renderObject;
			
			var material:BaseMaterial = _render.sharedMaterials[index];
			(material) || (material = ParticleMaterial.defaultMaterial);//确保有材质,由默认材质代替。
			var element:IRenderable = _templet;
			renderElement._mainSortID = 0;
			renderElement._sprite3D = this;
			
			renderElement.renderObj = element;
			renderElement._material = material;
			return renderElement;
		}
		
		/** @private */
		private function _onMaterialChanged(particleRender:ParticleRender, index:int, material:BaseMaterial):void {
			var renderElementCount:int = particleRender.renderObject._renderElements.length;
			(index < renderElementCount) && _changeRenderObject(index);
		}
		
		/** @private */
		override protected function _clearSelfRenderObjects():void {
			scene.removeFrustumCullingObject(_render.renderObject);
		}
		
		/** @private */
		override protected function _addSelfRenderObjects():void {
			scene.addFrustumCullingObject(_render.renderObject);
		}
		
		/**
		 * @private
		 */
		override public function _prepareShaderValuetoRender(projectionView:Matrix4x4):void {
			_setShaderValueMatrix4x4(Sprite3D.WORLDMATRIX, transform.worldMatrix);
			var projViewWorld:Matrix4x4 = getProjectionViewWorldMatrix(projectionView);
			_setShaderValueMatrix4x4(Sprite3D.MVPMATRIX, projViewWorld);
		}
		
		override public function _update(state:RenderState):void 
		{
			_templet.update(state.elapsedTime);
			super._update(state);
		}
		
		/**
		 * 添加粒子。
		 * @param position 粒子位置。
		 *  @param velocity 粒子速度。
		 */
		public function addParticle(position:Vector3, velocity:Vector3):void {
			Vector3.add(transform.localPosition, position, position);
			_templet.addParticle(position, velocity);
		}
		
		override public function cloneTo(destObject:*):void {
			super.cloneTo(destObject);
			var destParticle3D:Particle3D = destObject as Particle3D;
			destParticle3D._templet = _templet;//TODO:待确认是否复用
			var destParticleRender:ParticleRender = destParticle3D._render as ParticleRender;
			var particleRender:ParticleRender = _render as ParticleRender;
			destParticleRender.sharedMaterials = particleRender.sharedMaterials;
			destParticleRender.enable = particleRender.enable;
		}
		
		/**
		 * <p>销毁此对象。</p>
		 * @param	destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			_templet = null;
		}
	}

}