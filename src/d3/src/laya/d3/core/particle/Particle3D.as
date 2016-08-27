package laya.d3.core.particle {
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderObject;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Vector3;
	import laya.d3.resource.tempelet.ParticleTemplet3D;
	import laya.display.Node;
	import laya.particle.ParticleSettings;
	
	/**
	 * <code>Particle3D</code> 3D粒子。
	 */
	public class Particle3D extends Sprite3D {
		/**粒子模板。*/
		public var templet:ParticleTemplet3D;
		/** @private */
		private var _renderObject:RenderObject;
		
		/**
		 * 创建一个 <code>Particle3D</code> 实例。
		 * @param settings value 粒子配置。
		 */
		public function Particle3D(settings:ParticleSettings) {
			templet = new ParticleTemplet3D(settings);
		}
		
		override public function _clearSelfRenderObjects():void {
			_renderObject.renderQneue.deleteRenderObj(_renderObject);
		}
		
		/**
		 * 添加粒子。
		 * @param position 粒子位置。
		 *  @param velocity 粒子速度。
		 */
		public function addParticle(position:Vector3, velocity:Vector3):void {
			Vector3.add(transform.localPosition, position, position);
			templet.addParticle(position, velocity);
		}
		
		/**
		 * 更新粒子。
		 * @param state 渲染相关状态参数。
		 */
		public override function _update(state:RenderState):void {
			templet.update(state.elapsedTime);//更新ParticleTemplet3D
			
			state.owner = this;
			
			if (active) {
				if (_renderObject) {
					var renderQueueIndex:int;
					if (templet.settings.blendState === 0)
						renderQueueIndex = RenderQueue.DEPTHREAD_ALPHA_BLEND;
					else if (templet.settings.blendState === 1)
						renderQueueIndex = RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND;
					
					var renderQueue:RenderQueue = state.scene.getRenderQueue(renderQueueIndex);
					if (_renderObject.renderQneue != renderQueue) {
						_renderObject.renderQneue.deleteRenderObj(_renderObject);
						_renderObject=_addRenderObject(state, renderQueueIndex);
					}
				} else {
					_renderObject=_addRenderObject(state, renderQueueIndex);
				}
			} else {
				_clearSelfRenderObjects();
			}
			
			_childs.length && _updateChilds(state);
		}
		
		private function _addRenderObject(state:RenderState, renderQueueIndex:int):RenderObject {
			var renderObj:RenderObject = state.scene.getRenderObject(renderQueueIndex);
			_renderObject = renderObj;
			
			var renderElement:IRenderable = templet;
			renderObj.mainSortID = 0;//根据MeshID排序，处理同材质合并处理。
			renderObj.triangleCount = renderElement.triangleCount;
			renderObj.owner = state.owner;
			
			renderObj.renderElement = renderElement;
			renderObj.material = null;
			return renderObj;
		}
	}

}