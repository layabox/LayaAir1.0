package laya.particle.emitter
{
	import laya.particle.ParticleSetting;
	import laya.particle.ParticleTemplate2D;
	import laya.particle.ParticleTemplateBase;
	import laya.particle.ParticleTemplateCanvas;
	
	/**
	 * 
	 * @private
	 */
	public class Emitter2D extends EmitterBase
	{
		public var setting:ParticleSetting;
		private var _posRange:Float32Array;
		private var _canvasTemplate:ParticleTemplateBase;
		private var _emitFun:Function;
		public function Emitter2D(_template:ParticleTemplateBase)
		{
			super();
			template = _template;
		}
		public function set template(template:ParticleTemplateBase):void
		{
			this._particleTemplate=template;
			if (!template) 
			{
				_emitFun = null;
				setting = null;
				_posRange = null;
			};
			setting=template.settings;
			_posRange=setting.positionVariance;
			if(_particleTemplate is ParticleTemplate2D)
			{
				_emitFun=webGLEmit;
			}else 
			if(_particleTemplate is ParticleTemplateCanvas)
			{
				_canvasTemplate=template;
				_emitFun=canvasEmit;
			}
		}
		public function get template():ParticleTemplateBase
		{
			return this._particleTemplate;
		}
		override public function emit():void
		{
			super.emit();
			if(_emitFun!=null)
			_emitFun();
		}
		
		public function getRandom(value:Number):Number
		{
			return (Math.random()*2-1)*value;
		}
		
		public function webGLEmit():void
		{
			var pos:Float32Array=new Float32Array(3);
			pos[0]=getRandom(_posRange[0]);
			pos[1]=getRandom(_posRange[1]);
			pos[2]=getRandom(_posRange[2]);
			var v:Float32Array=new Float32Array(3);
			v[0]=0;
			v[1]=0;
			v[2]=0;
			_particleTemplate.addParticleArray(pos,v);
		}
		public function canvasEmit():void
		{
			var pos:Float32Array=new Float32Array(3);
			pos[0]=getRandom(_posRange[0]);
			pos[1]=getRandom(_posRange[1]);
			pos[2]=getRandom(_posRange[2]);
			var v:Float32Array=new Float32Array(3);
			v[0]=0;
			v[1]=0;
			v[2]=0;
			_particleTemplate.addParticleArray(pos,v);
		}
		
	}
}