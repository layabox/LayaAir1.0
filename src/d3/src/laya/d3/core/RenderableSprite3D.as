package laya.d3.core {
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.OctreeNode;
	import laya.d3.math.BoundBox;
	import laya.d3.math.Vector3;
	import laya.d3.shadowMap.ParallelSplitShadowMap;
	import laya.events.Event;
	import laya.renders.Render;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>RenderableSprite3D</code> 类用于可渲染3D精灵的父类，抽象类不允许实例。
	 */
	public class RenderableSprite3D extends Sprite3D {
		/**@private */
		private static var _tempBoundBoxCorners:Vector.<Vector3> = new Vector.<Vector3>[new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3()];
		
		/**@private */
		public static const SHADERDEFINE_SCALEOFFSETLIGHTINGMAPUV:int = 0x2;
		
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
		protected function _renderRenderableBoundBox():void {
			var linePhasor:PhasorSpriter3D = Laya3D._debugPhasorSprite;
			var boundBox:BoundBox = _render.boundingBox;
			var corners:Vector.<Vector3> = _tempBoundBoxCorners;
			boundBox.getCorners(corners);
			linePhasor.line(corners[0].x, corners[0].y, corners[0].z, 0.0, 1.0, 0.0, 1.0, corners[1].x, corners[1].y, corners[1].z, 0.0, 1.0, 0.0, 1.0);
			linePhasor.line(corners[2].x, corners[2].y, corners[2].z, 0.0, 1.0, 0.0, 1.0, corners[3].x, corners[3].y, corners[3].z, 0.0, 1.0, 0.0, 1.0);
			linePhasor.line(corners[4].x, corners[4].y, corners[4].z, 0.0, 1.0, 0.0, 1.0, corners[5].x, corners[5].y, corners[5].z, 0.0, 1.0, 0.0, 1.0);
			linePhasor.line(corners[6].x, corners[6].y, corners[6].z, 0.0, 1.0, 0.0, 1.0, corners[7].x, corners[7].y, corners[7].z, 0.0, 1.0, 0.0, 1.0);
			
			linePhasor.line(corners[0].x, corners[0].y, corners[0].z, 0.0, 1.0, 0.0, 1.0, corners[3].x, corners[3].y, corners[3].z, 0.0, 1.0, 0.0, 1.0);
			linePhasor.line(corners[1].x, corners[1].y, corners[1].z, 0.0, 1.0, 0.0, 1.0, corners[2].x, corners[2].y, corners[2].z, 0.0, 1.0, 0.0, 1.0);
			linePhasor.line(corners[2].x, corners[2].y, corners[2].z, 0.0, 1.0, 0.0, 1.0, corners[6].x, corners[6].y, corners[6].z, 0.0, 1.0, 0.0, 1.0);
			linePhasor.line(corners[3].x, corners[3].y, corners[3].z, 0.0, 1.0, 0.0, 1.0, corners[7].x, corners[7].y, corners[7].z, 0.0, 1.0, 0.0, 1.0);
			
			linePhasor.line(corners[0].x, corners[0].y, corners[0].z, 0.0, 1.0, 0.0, 1.0, corners[4].x, corners[4].y, corners[4].z, 0.0, 1.0, 0.0, 1.0);
			linePhasor.line(corners[1].x, corners[1].y, corners[1].z, 0.0, 1.0, 0.0, 1.0, corners[5].x, corners[5].y, corners[5].z, 0.0, 1.0, 0.0, 1.0);
			linePhasor.line(corners[4].x, corners[4].y, corners[4].z, 0.0, 1.0, 0.0, 1.0, corners[7].x, corners[7].y, corners[7].z, 0.0, 1.0, 0.0, 1.0);
			linePhasor.line(corners[5].x, corners[5].y, corners[5].z, 0.0, 1.0, 0.0, 1.0, corners[6].x, corners[6].y, corners[6].z, 0.0, 1.0, 0.0, 1.0);
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