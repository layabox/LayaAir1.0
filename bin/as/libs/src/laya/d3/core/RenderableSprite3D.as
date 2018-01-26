package laya.d3.core {
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.Scene;
	import laya.d3.shader.ShaderDefines;
	import laya.utils.Stat;
	
	/**
	 * <code>RenderableSprite3D</code> 类用于可渲染3D精灵的父类，抽象类不允许实例。
	 */
	public class RenderableSprite3D extends Sprite3D {
		///**精灵级着色器宏定义,接收阴影。*/
		//public static var SHADERDEFINE_RECEIVE_SHADOW:int;
		/**精灵级着色器宏定义,光照贴图便宜和缩放。*/
		public static var SHADERDEFINE_SCALEOFFSETLIGHTINGMAPUV:int = 0x2;
		/**精灵级着色器宏定义,光照贴图。*/
		public static var SAHDERDEFINE_LIGHTMAP:int = 0x4;
		
		/**着色器变量名，光照贴图缩放和偏移。*/
		public static const LIGHTMAPSCALEOFFSET:int = 2;
		/**着色器变量名，光照贴图缩。*/
		public static const LIGHTMAP:int = 3;
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines();
		
		/**
		 * @private
		 */
		public static function __init__():void {
			//SHADERDEFINE_RECEIVE_SHADOW = shaderDefines.registerDefine("RECEIVESHADOW");
			SHADERDEFINE_SCALEOFFSETLIGHTINGMAPUV = shaderDefines.registerDefine("SCALEOFFSETLIGHTINGMAPUV");
			SAHDERDEFINE_LIGHTMAP = shaderDefines.registerDefine("LIGHTMAP");
		}
		
		/** @private */
		public var _render:BaseRender;
		/** @private */
		public var _geometryFilter:GeometryFilter;//TODO:
		
		/**
		 * 创建一个 <code>RenderableSprite3D</code> 实例。
		 */
		public function RenderableSprite3D(name:String = null) {
			super(name)
		}
		
		/**
		 * @private
		 */
		public function _addToInitStaticBatchManager():void {
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _setBelongScene(scene:Scene):void {
			super._setBelongScene(scene);
			scene._renderableSprite3Ds.push(this);
			_render._applyLightMapParams();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _setUnBelongScene():void {
			var renderableSprite3Ds:Vector.<RenderableSprite3D> = _scene._renderableSprite3Ds;
			var index:int = renderableSprite3Ds.indexOf(this);
			renderableSprite3Ds.splice(index, 1);
			_render._removeShaderDefine(RenderableSprite3D.SAHDERDEFINE_LIGHTMAP);
			super._setUnBelongScene();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _update(state:RenderState):void {
			state.owner = this;
			if (_activeInHierarchy) {
				_updateComponents(state);
				_render._updateOctreeNode();//TODO:
				_lateUpdateComponents(state);
				
				Stat.spriteCount++;
				_childs.length && _updateChilds(state);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			_render._destroy();
			_render = null;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _updateConch(state:RenderState):void {//NATIVE
			state.owner = this;
			if (_activeInHierarchy) {
				_updateComponents(state);
				_render._updateOctreeNode();//TODO:
				//if (transform.worldNeedUpdate)
				//_render.renderObject._conchRenderObject.matrix(transform.worldMatrix.elements);
				//_render.renderObject._renderRuntime(state);
				
				_lateUpdateComponents(state);
				
				Stat.spriteCount++;
				_childs.length && _updateChildsConch(state);
			}
		}
	
	}

}