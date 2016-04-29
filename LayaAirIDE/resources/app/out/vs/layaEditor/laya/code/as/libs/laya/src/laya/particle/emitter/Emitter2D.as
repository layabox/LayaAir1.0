///////////////////////////////////////////////////////////
//  Emitter2D.as
//  Macromedia ActionScript Implementation of the Class Emitter2D
//  Created on:      2015-12-21 下午4:37:29
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.particle.emitter
{
	import laya.particle.ParticleSettings;
	import laya.particle.ParticleTemplate2D;
	import laya.particle.ParticleTemplateBase;
	import laya.particle.ParticleTemplateCanvas;
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-12-21 下午4:37:29
	 */
	public class Emitter2D extends EmitterBase
	{
		public var settiong:ParticleSettings;
		private var _posRange:Float32Array;
		private var _canvasTemplate:ParticleTemplateBase;
		private var _emitFun:Function;
		public function Emitter2D(_template:ParticleTemplateBase)
		{
			super();
			this._particleTemplate=_template;
			settiong=_template.settings;
			_posRange=settiong.positionVariance;
			if(_template is ParticleTemplate2D)
			{
				_emitFun=webGLEmit;
			}else 
			if(_template is ParticleTemplateCanvas)
			{
				_canvasTemplate=_template;
				_emitFun=canvasEmit;
			}
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