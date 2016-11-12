package laya.d3.core.particleShuriKen {
	import laya.d3.core.particleShuriKen.ShurikenParticleRender;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.particleShuriKen.ShurikenParticleMaterial;
	import laya.d3.core.particleShuriKen.emitter.ParticleBaseEmitter;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Vector3;
	import laya.d3.resource.Texture2D;
	import laya.display.Node;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.resource.WebGLImage;
	
	/**
	 * <code>Particle3D</code> 3D粒子。
	 */
	public class ShuriKenParticle3D extends Sprite3D {
		/**@private */
		private var _particleSystem:ShurikenParticleSystem;
		/** @private */
		private var _particleRender:ShurikenParticleRender;
		
		/**
		 * 获取粒子系统。
		 * @return  粒子系统。
		 */
		public function get particleSystem():ShurikenParticleSystem {
			return _particleSystem;
		}
		
		/**
		 * 获取粒子渲染器。
		 * @return  粒子渲染器。
		 */
		public function get particleRender():ShurikenParticleRender {
			return _particleRender;
		}
		
		/**
		 * 创建一个 <code>Particle3D</code> 实例。
		 * @param settings value 粒子配置。
		 */
		public function ShuriKenParticle3D(particleShapeEmitter:ParticleBaseEmitter, material:ShurikenParticleMaterial) {
			_particleRender = new ShurikenParticleRender(this);
			_particleRender.on(Event.MATERIAL_CHANGED, this, _onMaterialChanged);
			_particleRender.sharedMaterial = material;
			
			_particleSystem = new ShurikenParticleSystem();
			_particleSystem.particleShapeEmitter = particleShapeEmitter;
			
			_changeRenderObject(0);
			(_particleSystem.playOnAwake) && (particleShapeEmitter.play());
		}
		
		/** @private */
		private function _changeRenderObject(index:int):RenderElement {
			var renderObjects:Vector.<RenderElement> = _particleRender.renderCullingObject._renderElements;
			
			var renderElement:RenderElement = renderObjects[index];
			(renderElement) || (renderElement = renderObjects[index] = new RenderElement());
			renderElement._renderObject = _particleRender.renderCullingObject;
			
			var material:BaseMaterial = _particleRender.sharedMaterials[index];
			
			(material) || (material = ShurikenParticleMaterial.defaultMaterial);//确保有材质,由默认材质代替。
			
			var element:IRenderable = _particleSystem;
			renderElement._mainSortID = 0;
			renderElement._sprite3D = this;
			
			renderElement.renderObj = element;
			renderElement._material = material;
			return renderElement;
		}
		
		/** @private */
		private function _onMaterialChanged(_particleRender:ShurikenParticleRender, index:int, material:BaseMaterial):void {
			var renderElementCount:int = _particleRender.renderCullingObject._renderElements.length;
			(index < renderElementCount) && _changeRenderObject(index);
		}
		
		/** @private */
		override protected function _clearSelfRenderObjects():void {
			scene.removeFrustumCullingObject(_particleRender.renderCullingObject);
		}
		
		/** @private */
		override protected function _addSelfRenderObjects():void {
			scene.addFrustumCullingObject(_particleRender.renderCullingObject);
		}
		
		/**
		 * 更新粒子。
		 * @param state 渲染相关状态参数。
		 */
		public override function _update(state:RenderState):void {
			state.owner = this;
			_particleSystem.update(state);
			
			Stat.spriteCount++;
			_childs.length && _updateChilds(state);
		}
		
		override public function dispose():void {
			super.dispose();
			_particleRender.off(Event.MATERIAL_CHANGED, this, _onMaterialChanged);
		}
	
	}

}