package laya.d3.core.particleShuriKen {
	import laya.d3.core.RenderableSprite3D;
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
	import laya.d3.core.particleShuriKen.module.shape.SphereShape;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.BoundBox;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
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
	public class ShuriKenParticle3D extends RenderableSprite3D {
		public static var SHADERDEFINE_SPHERHBILLBOARD:int = 0x2;
		public static var SHADERDEFINE_STRETCHEDBILLBOARD:int = 0x4;
		public static var SHADERDEFINE_HORIZONTALBILLBOARD:int = 0x8;
		public static var SHADERDEFINE_VERTICALBILLBOARD:int = 0x10;
		public static var SHADERDEFINE_RANDOMCOLOROVERLIFETIME:int = 0x20;
		public static var SHADERDEFINE_COLOROVERLIFETIME:int = 0x40;
		public static var SHADERDEFINE_VELOCITYOVERLIFETIMECONSTANT:int = 0x80;
		public static var SHADERDEFINE_VELOCITYOVERLIFETIMECURVE:int = 0x100;
		public static var SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCONSTANT:int = 0x200;
		public static var SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCURVE:int = 0x400;
		public static var SHADERDEFINE_TEXTURESHEETANIMATIONCURVE:int = 0x800;
		public static var SHADERDEFINE_TEXTURESHEETANIMATIONRANDOMCURVE:int = 0x1000;
		public static var SHADERDEFINE_ROTATIONOVERLIFETIME:int = 0x2000;
		public static var SHADERDEFINE_ROTATIONOVERLIFETIMESEPERATE:int = 0x4000;
		public static var SHADERDEFINE_ROTATIONOVERLIFETIMECONSTANT:int = 0x8000;
		public static var SHADERDEFINE_ROTATIONOVERLIFETIMECURVE:int = 0x10000;
		public static var SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCONSTANTS:int = 0x20000;
		public static var SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCURVES:int = 0x40000;
		public static var SHADERDEFINE_SIZEOVERLIFETIMECURVE:int = 0x80000;
		public static var SHADERDEFINE_SIZEOVERLIFETIMECURVESEPERATE:int = 0x100000;
		public static var SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVES:int = 0x200000;
		public static var SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVESSEPERATE:int = 0x400000;
		
		public static const WORLDPOSITION:int = 0;
		public static const WORLDROTATIONMATRIX:int = 1;
		public static const POSITIONSCALE:int = 4;
		public static const SIZESCALE:int = 5;
		
		//VelocityOverLifetime
		public static const VOLVELOCITYCONST:int = 6;
		public static const VOLVELOCITYGRADIENTX:int = 7;
		public static const VOLVELOCITYGRADIENTY:int = 8;
		public static const VOLVELOCITYGRADIENTZ:int = 9;
		public static const VOLVELOCITYCONSTMAX:int = 10;
		public static const VOLVELOCITYGRADIENTXMAX:int = 11;
		public static const VOLVELOCITYGRADIENTYMAX:int = 12;
		public static const VOLVELOCITYGRADIENTZMAX:int = 13;
		public static const VOLSPACETYPE:int = 14;
		
		//ColorOverLifetime
		public static const COLOROVERLIFEGRADIENTALPHAS:int = 15;
		public static const COLOROVERLIFEGRADIENTCOLORS:int = 16;
		public static const MAXCOLOROVERLIFEGRADIENTALPHAS:int = 17;
		public static const MAXCOLOROVERLIFEGRADIENTCOLORS:int = 18;
		
		//SizeOverLifetime
		public static const SOLSIZEGRADIENT:int = 19;
		public static const SOLSIZEGRADIENTX:int = 20;
		public static const SOLSIZEGRADIENTY:int = 21;
		public static const SOLSizeGradientZ:int = 22;
		public static const SOLSizeGradientMax:int = 23;
		public static const SOLSIZEGRADIENTXMAX:int = 24;
		public static const SOLSIZEGRADIENTYMAX:int = 25;
		public static const SOLSizeGradientZMAX:int = 26;
		
		//RotationOverLifetime
		public static const ROLANGULARVELOCITYCONST:int = 27;
		public static const ROLANGULARVELOCITYCONSTSEPRARATE:int = 28;
		public static const ROLANGULARVELOCITYGRADIENT:int = 29;
		public static const ROLANGULARVELOCITYGRADIENTX:int = 30;
		public static const ROLANGULARVELOCITYGRADIENTY:int = 31;
		public static const ROLANGULARVELOCITYGRADIENTZ:int = 32;
		public static const ROLANGULARVELOCITYCONSTMAX:int = 33;
		public static const ROLANGULARVELOCITYCONSTMAXSEPRARATE:int = 34;
		public static const ROLANGULARVELOCITYGRADIENTMAX:int = 35;
		public static const ROLANGULARVELOCITYGRADIENTXMAX:int = 36;
		public static const ROLANGULARVELOCITYGRADIENTYMAX:int = 37;
		public static const ROLANGULARVELOCITYGRADIENTZMAX:int = 38;
		
		//TextureSheetAnimation
		public static const TEXTURESHEETANIMATIONCYCLES:int = 39;
		public static const TEXTURESHEETANIMATIONSUBUVLENGTH:int = 40;
		public static const TEXTURESHEETANIMATIONGRADIENTUVS:int = 41;
		public static const TEXTURESHEETANIMATIONGRADIENTMAXUVS:int = 42;
		
		/** @private */
		private var _tempRotationMatrix:Matrix4x4 = new Matrix4x4();
		
		/**
		 * 获取粒子系统。
		 * @return  粒子系统。
		 */
		public function get particleSystem():ShurikenParticleSystem {
			return _geometryFilter as ShurikenParticleSystem;
		}
		
		/**
		 * 获取粒子渲染器。
		 * @return  粒子渲染器。
		 */
		public function get particleRender():ShurikenParticleRender {
			return _render as ShurikenParticleRender;
		}
		
		/**
		 * 创建一个 <code>Particle3D</code> 实例。
		 * @param settings value 粒子配置。
		 */
		public function ShuriKenParticle3D(material:ShurikenParticleMaterial = null) {
			_render = new ShurikenParticleRender(this);
			_render.on(Event.MATERIAL_CHANGED, this, _onMaterialChanged);
			
			_geometryFilter = new ShurikenParticleSystem(this);
			_changeRenderObject(0);
			
			(material) && (_render.sharedMaterial = material);
		}
		
		/** @private */
		private function _changeRenderObject(index:int):RenderElement {
			var renderObjects:Vector.<RenderElement> = _render._renderElements;
			
			var renderElement:RenderElement = renderObjects[index];
			(renderElement) || (renderElement = renderObjects[index] = new RenderElement());
			renderElement._render = _render;
			
			var material:BaseMaterial = _render.sharedMaterials[index];
			
			(material) || (material = ShurikenParticleMaterial.defaultMaterial);//确保有材质,由默认材质代替。
			
			var element:IRenderable = _geometryFilter as ShurikenParticleSystem;
			renderElement._mainSortID = 0;
			renderElement._sprite3D = this;
			
			renderElement.renderObj = element;
			renderElement._material = material;
			return renderElement;
		}
		
		/** @private */
		private function _onMaterialChanged(_particleRender:ShurikenParticleRender, index:int, material:BaseMaterial):void {
			var renderElementCount:int = _particleRender._renderElements.length;
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
		
		/**
		 * @inheritDoc
		 */
		override public function _renderUpdate(projectionView:Matrix4x4):void {
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
				var scale:Vector3 = transform.scale;
				_setShaderValueColor(POSITIONSCALE, scale);
				_setShaderValueColor(SIZESCALE, scale);
				break;
			case 1: 
				var localScale:Vector3 = transform.localScale;
				_setShaderValueColor(POSITIONSCALE, localScale);
				_setShaderValueColor(SIZESCALE, localScale);
				break;
			case 2: 
				_setShaderValueColor(POSITIONSCALE, transform.scale);
				_setShaderValueColor(SIZESCALE, Vector3.ONE);
				break;
			}
			
			if (Laya3D.debugMode)
				_renderRenderableBoundBox();
		}
		
		/**
		 * @private
		 */
		override public function cloneTo(destObject:*):void {
			super.cloneTo(destObject);
			var destShuriKenParticle3D:ShuriKenParticle3D = destObject as ShuriKenParticle3D;
			var destParticleSystem:ShurikenParticleSystem = destShuriKenParticle3D._geometryFilter as ShurikenParticleSystem;
			(_geometryFilter as ShurikenParticleSystem).cloneTo(destParticleSystem);
			
			var destParticleRender:ShurikenParticleRender = destShuriKenParticle3D._render as ShurikenParticleRender;
			var particleRender:ShurikenParticleRender = _render as ShurikenParticleRender;
			destParticleRender.sharedMaterials = particleRender.sharedMaterials;
			destParticleRender.enable = particleRender.enable;
			destParticleRender.renderMode = particleRender.renderMode;
			destParticleRender.stretchedBillboardCameraSpeedScale = particleRender.stretchedBillboardCameraSpeedScale;
			destParticleRender.stretchedBillboardSpeedScale = particleRender.stretchedBillboardSpeedScale;
			destParticleRender.stretchedBillboardLengthScale = particleRender.stretchedBillboardLengthScale;
			destParticleRender.sortingFudge = particleRender.sortingFudge;
		}
		
		/**
		 * <p>销毁此对象。</p>
		 * @param	destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			(_geometryFilter as ShurikenParticleSystem)._destroy();
			_geometryFilter = null;
		}
	
	}

}