package laya.d3.core {
	import laya.d3.component.Animator;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.Vector4;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderDefines;
	import laya.display.Node;
	
	/**
	 * <code>RenderableSprite3D</code> 类用于可渲染3D精灵的父类，抽象类不允许实例。
	 */
	public class RenderableSprite3D extends Sprite3D {
		/**精灵级着色器宏定义,接收阴影。*/
		public static var SHADERDEFINE_RECEIVE_SHADOW:int;
		/**精灵级着色器宏定义,光照贴图便宜和缩放。*/
		public static var SHADERDEFINE_SCALEOFFSETLIGHTINGMAPUV:int;
		/**精灵级着色器宏定义,光照贴图。*/
		public static var SAHDERDEFINE_LIGHTMAP:int;
		
		/**着色器变量名，光照贴图缩放和偏移。*/
		public static var LIGHTMAPSCALEOFFSET:int=Shader3D.propertyNameToID("u_LightmapScaleOffset");
		/**着色器变量名，光照贴图。*/
		public static var LIGHTMAP:int=Shader3D.propertyNameToID("u_LightMap");
		/**拾取颜色。*/
		public static var PICKCOLOR:int=Shader3D.propertyNameToID("u_PickColor");
		
		public var pickColor:Vector4;
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines();
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_RECEIVE_SHADOW = shaderDefines.registerDefine("RECEIVESHADOW");
			SHADERDEFINE_SCALEOFFSETLIGHTINGMAPUV = shaderDefines.registerDefine("SCALEOFFSETLIGHTINGMAPUV");
			SAHDERDEFINE_LIGHTMAP = shaderDefines.registerDefine("LIGHTMAP");
		}
		
		/** @private */
		public var _render:BaseRender;
		
		/**
		 * 创建一个 <code>RenderableSprite3D</code> 实例。
		 */
		public function RenderableSprite3D(name:String) {
			super(name);
		}
		
		/** 
		 * @inheritDoc
		 */
		override protected function _onInActive():void {
			super._onInActive();
			var scene3D:Scene3D = _scene as Scene3D;
			scene3D._removeRenderObject(_render);
			(_render.castShadow) && (scene3D._removeShadowCastRenderObject(_render));
		
		}
		
		/** 
		 * @inheritDoc
		 */
		override protected function _onActive():void {
			super._onActive();
			var scene3D:Scene3D = _scene as Scene3D;
			scene3D._addRenderObject(_render);
			(_render.castShadow) && (scene3D._addShadowCastRenderObject(_render));
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onActiveInScene():void {
			super._onActiveInScene();
			
			if (Laya3D._editerEnvironment) {
				var scene:Scene3D = _scene as Scene3D;
				var pickColor:Vector4 = new Vector4();
				scene._allotPickColorByID(id, pickColor);
				scene._pickIdToSprite[id] = this;
				_render._shaderValues.setVector(RenderableSprite3D.PICKCOLOR, pickColor);
			}
		}
		
		/**
		 * @private
		 */
		public function _addToInitStaticBatchManager():void {
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _setBelongScene(scene:Node):void {
			super._setBelongScene(scene);
			_render._setBelongScene(scene as Scene3D);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _setUnBelongScene():void {
			_render._defineDatas.remove(RenderableSprite3D.SAHDERDEFINE_LIGHTMAP);
			super._setUnBelongScene();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _changeHierarchyAnimator(animator:Animator):void {
			if (_hierarchyAnimator) {
				var renderableSprites:Vector.<RenderableSprite3D> = _hierarchyAnimator._renderableSprites;
				renderableSprites.splice(renderableSprites.indexOf(this), 1);
			}
			if (animator)
				animator._renderableSprites.push(this);
			
			super._changeHierarchyAnimator(animator);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			_render._destroy();
			_render = null;
		}
	
	}

}