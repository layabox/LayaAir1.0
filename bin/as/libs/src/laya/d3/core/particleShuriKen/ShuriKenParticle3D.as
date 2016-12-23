package laya.d3.core.particleShuriKen {
	import laya.d3.core.particleShuriKen.ShurikenParticleRender;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.particleShuriKen.ShurikenParticleMaterial;
	import laya.d3.core.particleShuriKen.module.ColorOverLifetime;
	import laya.d3.core.particleShuriKen.module.Emission;
	import laya.d3.core.particleShuriKen.module.GradientVelocity;
	import laya.d3.core.particleShuriKen.module.RotationOverLifetime;
	import laya.d3.core.particleShuriKen.module.SizeOverLifetime;
	import laya.d3.core.particleShuriKen.module.TextureSheetAnimation;
	import laya.d3.core.particleShuriKen.module.VelocityOverLifetime;
	import laya.d3.core.particleShuriKen.module.shape.BaseShape;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.resource.Texture2D;
	import laya.display.Node;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.resource.WebGLImage;
	
	/**
	 * <code>ShuriKenParticle3D</code> 3D粒子。
	 */
	public class ShuriKenParticle3D extends Sprite3D {
		public static const WORLDPOSITION:int = 0;
		public static const WORLDROTATIONMATRIX:int = 1;
		public static const POSITIONSCALE:int = 4;
		public static const SIZESCALE:int = 5;
		
		/** @private */
		private var _tempRotationMatrix:Matrix4x4 = new Matrix4x4();
		
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
		public function ShuriKenParticle3D(material:ShurikenParticleMaterial = null) {
			_particleRender = new ShurikenParticleRender(this);
			_particleRender.on(Event.MATERIAL_CHANGED, this, _onMaterialChanged);
			
			_particleSystem = new ShurikenParticleSystem(this);
			_changeRenderObject(0);
			
			(material) && (_particleRender.sharedMaterial = material);
		}
		
		/** @private */
		private function _changeRenderObject(index:int):RenderElement {
			var renderObjects:Vector.<RenderElement> = _particleRender.renderObject._renderElements;
			
			var renderElement:RenderElement = renderObjects[index];
			(renderElement) || (renderElement = renderObjects[index] = new RenderElement());
			renderElement._renderObject = _particleRender.renderObject;
			
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
			var renderElementCount:int = _particleRender.renderObject._renderElements.length;
			(index < renderElementCount) && _changeRenderObject(index);
		}
		
		/** @private */
		override protected function _clearSelfRenderObjects():void {
			scene.removeFrustumCullingObject(_particleRender.renderObject);
		}
		
		/** @private */
		override protected function _addSelfRenderObjects():void {
			scene.addFrustumCullingObject(_particleRender.renderObject);
		}
		
		/**
		 * 更新粒子。
		 * @param state 渲染相关状态参数。
		 */
		public override function _update(state:RenderState):void {
			state.owner = this;
			
			Stat.spriteCount++;
			_childs.length && _updateChilds(state);
		}
		
		override public function _prepareShaderValuetoRender(view:Matrix4x4, projection:Matrix4x4, projectionView:Matrix4x4):void {
			switch (particleSystem.simulationSpace) {
			case 0: //World
				_setShaderValueColor(WORLDPOSITION, Vector3.ZERO);//TODO是否可不传
				break;
			case 1: //Local
				_setShaderValueColor(WORLDPOSITION, transform.position);
				break;
			default: 
				throw new Error("ShurikenParticleMaterial: SimulationSpace value is invalid.");
			}
			
			Matrix4x4.createFromQuaternion(transform.rotation, _tempRotationMatrix);
			_setShaderValueMatrix4x4(WORLDROTATIONMATRIX, _tempRotationMatrix);
			
			switch (particleSystem.scaleMode) {
			case 0: 
				_setShaderValueColor(POSITIONSCALE, transform.scale);
				_setShaderValueColor(SIZESCALE, transform.scale);
				break;
			case 1: 
				_setShaderValueColor(POSITIONSCALE, transform.localScale);
				_setShaderValueColor(SIZESCALE, transform.localScale);
				break;
			case 2: 
				_setShaderValueColor(POSITIONSCALE, transform.scale);
				_setShaderValueColor(SIZESCALE, Vector3.ONE);
				break;
			}
		}
		
		/**
		 * @private
		 */
		override public function cloneTo(destObject:*):void {
			super.cloneTo(destObject);
			var destShuriKenParticle3D:ShuriKenParticle3D = destObject as ShuriKenParticle3D;
			var destParticleSystem:ShurikenParticleSystem = destShuriKenParticle3D._particleSystem;
			
			destParticleSystem.duration = _particleSystem.duration;
			destParticleSystem.looping = _particleSystem.looping;
			destParticleSystem.prewarm = _particleSystem.prewarm;
			destParticleSystem.startDelayType = _particleSystem.startDelayType;
			destParticleSystem.startDelay = _particleSystem.startDelay;
			destParticleSystem.startDelayMin = _particleSystem.startDelayMin;
			destParticleSystem.startDelayMax = _particleSystem.startDelayMax;
			
			destParticleSystem.startLifetimeType = _particleSystem.startLifetimeType;
			destParticleSystem.startLifetimeConstant = _particleSystem.startLifetimeConstant;
			_particleSystem.startLifeTimeGradient.cloneTo(destParticleSystem.startLifeTimeGradient);
			destParticleSystem.startLifetimeConstantMin = _particleSystem.startLifetimeConstantMin;
			destParticleSystem.startLifetimeConstantMax = _particleSystem.startLifetimeConstantMax;
			_particleSystem.startLifeTimeGradientMin.cloneTo(destParticleSystem.startLifeTimeGradientMin);
			_particleSystem.startLifeTimeGradientMax.cloneTo(destParticleSystem.startLifeTimeGradientMax);
			
			destParticleSystem.startSpeedType = _particleSystem.startSpeedType;
			destParticleSystem.startSpeedConstant = _particleSystem.startSpeedConstant;
			destParticleSystem.startSpeedConstantMin = _particleSystem.startSpeedConstantMin;
			destParticleSystem.startSpeedConstantMax = _particleSystem.startSpeedConstantMax;
			
			destParticleSystem.threeDStartSize = _particleSystem.threeDStartSize;
			destParticleSystem.startSizeType = _particleSystem.startSizeType;
			destParticleSystem.startSizeConstant = _particleSystem.startSizeConstant;
			_particleSystem.startSizeConstantSeparate.cloneTo(destParticleSystem.startSizeConstantSeparate);
			destParticleSystem.startSizeConstantMin = _particleSystem.startSizeConstantMin;
			destParticleSystem.startSizeConstantMax = _particleSystem.startSizeConstantMax;
			_particleSystem.startSizeConstantMinSeparate.cloneTo(destParticleSystem.startSizeConstantMinSeparate);
			_particleSystem.startSizeConstantMaxSeparate.cloneTo(destParticleSystem.startSizeConstantMaxSeparate);
			
			destParticleSystem.threeDStartRotation = _particleSystem.threeDStartRotation;
			destParticleSystem.startRotationType = _particleSystem.startRotationType;
			destParticleSystem.startRotationConstant = _particleSystem.startRotationConstant;
			_particleSystem.startRotationConstantSeparate.cloneTo(destParticleSystem.startRotationConstantSeparate);
			destParticleSystem.startRotationConstantMin = _particleSystem.startRotationConstantMin;
			destParticleSystem.startRotationConstantMax = _particleSystem.startRotationConstantMax;
			_particleSystem.startRotationConstantMinSeparate.cloneTo(destParticleSystem.startRotationConstantMinSeparate);
			_particleSystem.startRotationConstantMaxSeparate.cloneTo(destParticleSystem.startRotationConstantMaxSeparate);
			
			destParticleSystem.randomizeRotationDirection = _particleSystem.randomizeRotationDirection;
			
			destParticleSystem.startColorType = _particleSystem.startColorType;
			_particleSystem.startColorConstant.cloneTo(destParticleSystem.startColorConstant);
			_particleSystem.startColorConstantMin.cloneTo(destParticleSystem.startColorConstantMin);
			_particleSystem.startColorConstantMax.cloneTo(destParticleSystem.startColorConstantMax);
			
			_particleSystem.gravity.cloneTo(destParticleSystem.gravity);
			destParticleSystem.gravityModifier = _particleSystem.gravityModifier;
			destParticleSystem.simulationSpace = _particleSystem.simulationSpace;
			destParticleSystem.scaleMode = _particleSystem.scaleMode;
			destParticleSystem.playOnAwake = _particleSystem.playOnAwake;
			//destParticleSystem.autoRandomSeed = _particleSystem.autoRandomSeed;
			
			destParticleSystem.maxParticles = _particleSystem.maxParticles;
			
			var emission:Emission = _particleSystem.emission;
			(emission) && (destParticleSystem.emission = emission.clone());
			var shape:BaseShape = _particleSystem.shape;
			(shape) && (destParticleSystem.shape = shape.clone());
			var velocityOverLifetime:VelocityOverLifetime = _particleSystem.velocityOverLifetime;
			(velocityOverLifetime) && (destParticleSystem.velocityOverLifetime = velocityOverLifetime.clone());
			var colorOverLifetime:ColorOverLifetime = _particleSystem.colorOverLifetime;
			(colorOverLifetime) && (destParticleSystem.colorOverLifetime = colorOverLifetime.clone());
			var sizeOverLifetime:SizeOverLifetime = _particleSystem.sizeOverLifetime;
			(sizeOverLifetime) && (destParticleSystem.sizeOverLifetime = sizeOverLifetime.clone());
			var rotationOverLifetime:RotationOverLifetime = _particleSystem.rotationOverLifetime;
			(rotationOverLifetime) && (destParticleSystem.rotationOverLifetime = rotationOverLifetime.clone());
			var textureSheetAnimation:TextureSheetAnimation = _particleSystem.textureSheetAnimation;
			(textureSheetAnimation) && (destParticleSystem.textureSheetAnimation = textureSheetAnimation.clone());
			
			destParticleSystem.isPerformanceMode = _particleSystem.isPerformanceMode;
			
			var destParticleRender:ShurikenParticleRender = destShuriKenParticle3D._particleRender;
			destParticleRender.sharedMaterials = _particleRender.sharedMaterials;
			destParticleRender.enable = _particleRender.enable;
			destParticleRender.renderMode = _particleRender.renderMode;
			destParticleRender.stretchedBillboardCameraSpeedScale = _particleRender.stretchedBillboardCameraSpeedScale;
			destParticleRender.stretchedBillboardSpeedScale = _particleRender.stretchedBillboardSpeedScale;
			destParticleRender.stretchedBillboardLengthScale = _particleRender.stretchedBillboardLengthScale;
		}
		
		/**
		 * <p>销毁此对象。</p>
		 * @param	destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			_particleRender._destroy();
			_particleSystem._destroy();
			_particleRender = null;
			_particleSystem = null;
		}
	
	}

}