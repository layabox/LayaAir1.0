package laya.particle
{
	
	import laya.particle.shader.value.ParticleShaderValue;
	import laya.resource.Texture;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.utils.Timer;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.BlendMode;
	import laya.webgl.resource.WebGLImage;
	import laya.webgl.submit.ISubmit;

	/**
	 *  @private 
	 */
	public class ParticleTemplate2D extends ParticleTemplateWebGL implements ISubmit
	{
		public static var activeBlendType:int = -1;
		public var x:Number=0;
		
		public var y:Number=0;
		protected var _blendFn:Function;
		public var sv:ParticleShaderValue = new ParticleShaderValue();
		
		private var _startTime:int;
		public function ParticleTemplate2D(parSetting:ParticleSettings)
		{
			super(parSetting);
			var _this:ParticleTemplate2D = this;
			Laya.loader.load(settings.textureName, Handler.create(null, function(texture:Texture):void{
				(texture.bitmap as  WebGLImage).enableMerageInAtlas = false;
		       _this.texture = texture;
			}));
			sv.u_Duration=settings.duration;
			sv.u_Gravity=settings.gravity;
			sv.u_EndVelocity = settings.endVelocity;
			
			_blendFn = BlendMode.fns[parSetting.blendState]; //context._targets?BlendMode.targetFns[blendType]:BlendMode.fns[blendType];
			initialize();
			loadContent();
		}
		
		public function getRenderType():int{return -111}
		
		public 	function releaseRender():void{}
		
		override public function addParticleArray(position:Float32Array, velocity:Float32Array):void
		{
			// TODO Auto Generated method stub
			position[0]+=x;
			position[1]+=y;
			super.addParticleArray(position, velocity);
		}
		
		
		public function renderSubmit():int
		{
			if (texture&&texture.loaded)
			{
				update(Timer.delta);
				sv.u_CurrentTime=_currentTime;
				if (_firstNewElement != _firstFreeElement)
				{
					addNewParticlesToVertexBuffer();
				}
				
				blend();
				
				if (_firstActiveElement != _firstFreeElement)
				{
					var gl:WebGLContext = WebGL.mainContext;
					_vertexBuffer.bind(_indexBuffer);
					sv.u_texture = texture.source;
					sv.upload();
					
						
					if (_firstActiveElement < _firstFreeElement)
					{
						WebGL.mainContext.drawElements(WebGLContext.TRIANGLES, (_firstFreeElement - _firstActiveElement) * 6, WebGLContext.UNSIGNED_SHORT, _firstActiveElement * 6 * 2);
					}
					else
					{
						WebGL.mainContext.drawElements(WebGLContext.TRIANGLES, (settings.maxPartices - _firstActiveElement) * 6, WebGLContext.UNSIGNED_SHORT, _firstActiveElement * 6 * 2);
						if (_firstFreeElement > 0)
							WebGL.mainContext.drawElements(WebGLContext.TRIANGLES, _firstFreeElement * 6, WebGLContext.UNSIGNED_SHORT, 0);
					}
					
					Stat.drawCall++;
				}
				_drawCounter++;
			}
			return 1;
		}
		
		public function blend():void
		{
			if (BlendMode.activeBlendFunction !== _blendFn)
			{
				var gl:WebGLContext= WebGL.mainContext;
				gl.enable( WebGLContext.BLEND );
				_blendFn(gl);
				BlendMode.activeBlendFunction = _blendFn;
			}
		}
	}
}