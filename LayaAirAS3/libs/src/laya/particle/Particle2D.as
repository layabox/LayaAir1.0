package laya.particle
{
	import laya.display.Sprite;
	import laya.particle.emitter.Emitter2D;
	import laya.particle.emitter.EmitterBase;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	
	/**
	 * <code>Particle2D</code> 类是2D粒子播放类
	 * 
	 */
	public class Particle2D extends Sprite
	{
		/**@private */
		private var _particleTemplate:ParticleTemplateBase;
		/**@private */
		private var _canvasTemplate:ParticleTemplateCanvas;
		/**@private */
		private var _emitter:EmitterBase;
		/**
		 * 创建一个新的 <code>Particle2D</code> 类实例。
		 * @param setting 粒子配置数据
		 * 
		 */
		public function Particle2D(setting:ParticleSettings)
		{
			if (Render.isWebGL)
			{
				_particleTemplate=new ParticleTemplate2D(setting);
			    this.graphics._saveToCmd(Render.context._drawParticle, [_particleTemplate]);
			}else
			{
				_particleTemplate =_canvasTemplate= new ParticleTemplateCanvas(setting);
				_renderType |= RenderSprite.CUSTOM;	
			}
			_emitter = new Emitter2D(_particleTemplate);
		}
		/**
		 * 获取粒子发射器 
		 * @return 
		 * 
		 */
		public function get emitter():EmitterBase
		{
			return _emitter;
		}
		/**
		 * 播放 
		 * 
		 */
		public function play():void
		{
			Laya.timer.frameLoop(1,this,_loop);
		}
		
		/**
		 * 停止 
		 * 
		 */
		public function stop():void
		{
			Laya.timer.clear(this,_loop);
		}
		/**@private */
		private function _loop():void
		{
			advanceTime(1/60);
		}
		
		/**
		 * 时钟前进 
		 * @param passedTime 时钟前进时间
		 * 
		 */
		public function advanceTime(passedTime:Number=1):void
		{
			if(_canvasTemplate)
			{
				_canvasTemplate.advanceTime(passedTime);
			}
			if (_emitter)
			{
				_emitter.advanceTime(passedTime);
			}	
		}
		/**@private */
		public override function customRender(context:RenderContext, x:Number, y:Number):void 
		{
            if (_canvasTemplate)
			{
				_canvasTemplate.render(context, x, y);
			}
		}
	}
}