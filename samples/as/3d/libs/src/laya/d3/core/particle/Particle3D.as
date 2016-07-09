package laya.d3.core.particle {
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.RenderObject;
	import laya.d3.core.render.RenderQuene;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Vector3;
	import laya.d3.resource.tempelet.ParticleTemplet3D;
	import laya.particle.ParticleSettings;
	
	/**
	 * <code>Particle3D</code> 3D粒子。
	 */
	public class Particle3D extends Sprite3D {
		/**粒子模板。*/
		public var templet:ParticleTemplet3D;
		
		/**
		 * 创建一个 <code>Particle3D</code> 实例。
		 * @param settings value 粒子配置。
		 */
		public function Particle3D(settings:ParticleSettings) {
			templet = new ParticleTemplet3D(settings);
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
			
			var preWorldTransformModifyID:int = state.worldTransformModifyID;
			
			state.worldTransformModifyID += transform._worldTransformModifyID;
			transform.getWorldMatrix(state.worldTransformModifyID);
			
			var o:RenderObject;
			if (templet.settings.blendState === 0)
				o = state.scene.getRenderObject(RenderQuene.DEPTHREAD_ALPHA_BLEND);
			else if (templet.settings.blendState === 1)
				o = state.scene.getRenderObject(RenderQuene.DEPTHREAD_ALPHA_ADDTIVE_BLEND);
			
			o.owner = state.owner = this;
			o.renderElement = templet;
			o.material = null;
			
			state.worldTransformModifyID = preWorldTransformModifyID;
			
			_childs.length && _updateChilds(state);
		}
	}

}