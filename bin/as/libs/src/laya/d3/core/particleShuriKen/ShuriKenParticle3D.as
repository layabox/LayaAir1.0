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
		public static var SHADERDEFINE_RENDERMODE_BILLBOARD:int;
		public static var SHADERDEFINE_RENDERMODE_STRETCHEDBILLBOARD:int;
		public static var SHADERDEFINE_RENDERMODE_HORIZONTALBILLBOARD:int;
		public static var SHADERDEFINE_RENDERMODE_VERTICALBILLBOARD:int;
		public static var SHADERDEFINE_RENDERMODE_MESH:int;
		public static var SHADERDEFINE_RANDOMCOLOROVERLIFETIME:int;
		public static var SHADERDEFINE_COLOROVERLIFETIME:int;
		public static var SHADERDEFINE_VELOCITYOVERLIFETIMECONSTANT:int;
		public static var SHADERDEFINE_VELOCITYOVERLIFETIMECURVE:int;
		public static var SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCONSTANT:int;
		public static var SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCURVE:int;
		public static var SHADERDEFINE_TEXTURESHEETANIMATIONCURVE:int;
		public static var SHADERDEFINE_TEXTURESHEETANIMATIONRANDOMCURVE:int;
		public static var SHADERDEFINE_ROTATIONOVERLIFETIME:int;
		public static var SHADERDEFINE_ROTATIONOVERLIFETIMESEPERATE:int;
		public static var SHADERDEFINE_ROTATIONOVERLIFETIMECONSTANT:int;
		public static var SHADERDEFINE_ROTATIONOVERLIFETIMECURVE:int;
		public static var SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCONSTANTS:int;
		public static var SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCURVES:int;
		public static var SHADERDEFINE_SIZEOVERLIFETIMECURVE:int;
		public static var SHADERDEFINE_SIZEOVERLIFETIMECURVESEPERATE:int;
		public static var SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVES:int;
		public static var SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVESSEPERATE:int;
		
		public static const WORLDPOSITION:int = 0;
		public static const WORLDROTATIONMATRIX:int = 1;
		public static const POSITIONSCALE:int = 4;//TODO:是否可以从2开始
		public static const SIZESCALE:int = 5;
		public static const SCALINGMODE:int = 6;
		public static const GRAVITY:int = 7;
		public static const THREEDSTARTROTATION:int = 8;
		public static const STRETCHEDBILLBOARDLENGTHSCALE:int = 9;
		public static const STRETCHEDBILLBOARDSPEEDSCALE:int = 10;
		public static const SIMULATIONSPACE:int = 11;
		public static const CURRENTTIME:int = 12;
		
		//VelocityOverLifetime
		public static const VOLVELOCITYCONST:int = 13;
		public static const VOLVELOCITYGRADIENTX:int = 14;
		public static const VOLVELOCITYGRADIENTY:int = 15;
		public static const VOLVELOCITYGRADIENTZ:int = 16;
		public static const VOLVELOCITYCONSTMAX:int = 17;
		public static const VOLVELOCITYGRADIENTXMAX:int = 18;
		public static const VOLVELOCITYGRADIENTYMAX:int = 19;
		public static const VOLVELOCITYGRADIENTZMAX:int = 20;
		public static const VOLSPACETYPE:int = 21;
		
		//ColorOverLifetime
		public static const COLOROVERLIFEGRADIENTALPHAS:int = 22;
		public static const COLOROVERLIFEGRADIENTCOLORS:int = 23;
		public static const MAXCOLOROVERLIFEGRADIENTALPHAS:int = 24;
		public static const MAXCOLOROVERLIFEGRADIENTCOLORS:int = 25;
		
		//SizeOverLifetime
		public static const SOLSIZEGRADIENT:int = 26;
		public static const SOLSIZEGRADIENTX:int = 27;
		public static const SOLSIZEGRADIENTY:int = 28;
		public static const SOLSizeGradientZ:int = 29;
		public static const SOLSizeGradientMax:int = 30;
		public static const SOLSIZEGRADIENTXMAX:int = 31;
		public static const SOLSIZEGRADIENTYMAX:int = 32;
		public static const SOLSizeGradientZMAX:int = 33;
		
		//RotationOverLifetime
		public static const ROLANGULARVELOCITYCONST:int = 34;
		public static const ROLANGULARVELOCITYCONSTSEPRARATE:int = 35;
		public static const ROLANGULARVELOCITYGRADIENT:int = 36;
		public static const ROLANGULARVELOCITYGRADIENTX:int = 37;
		public static const ROLANGULARVELOCITYGRADIENTY:int = 38;
		public static const ROLANGULARVELOCITYGRADIENTZ:int = 39;
		public static const ROLANGULARVELOCITYGRADIENTW:int = 40;
		public static const ROLANGULARVELOCITYCONSTMAX:int = 41;
		public static const ROLANGULARVELOCITYCONSTMAXSEPRARATE:int = 42;
		public static const ROLANGULARVELOCITYGRADIENTMAX:int = 43;
		public static const ROLANGULARVELOCITYGRADIENTXMAX:int = 44;
		public static const ROLANGULARVELOCITYGRADIENTYMAX:int = 45;
		public static const ROLANGULARVELOCITYGRADIENTZMAX:int = 46;
		public static const ROLANGULARVELOCITYGRADIENTWMAX:int = 47;
		
		//TextureSheetAnimation
		public static const TEXTURESHEETANIMATIONCYCLES:int = 48;
		public static const TEXTURESHEETANIMATIONSUBUVLENGTH:int = 49;
		public static const TEXTURESHEETANIMATIONGRADIENTUVS:int = 50;
		public static const TEXTURESHEETANIMATIONGRADIENTMAXUVS:int = 51;
		
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