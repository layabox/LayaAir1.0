package laya.particle
{
	
	import laya.display.Sprite;
	import laya.particle.shader.value.ParticleShaderValue;
	import laya.resource.Texture;
	import laya.utils.Stat;
	import laya.utils.Timer;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.BlendMode;
	import laya.webgl.submit.ISubmit;
	import laya.webgl.utils.Buffer;

	public class ParticleTemplate2D extends ParticleTemplateWebGL implements ISubmit
	{
		public static var activeBlendType:int = -1;
		
		public var x:Number=0;
		public var y:Number=0;
		public var blendType:int = 1;
		public var sv:ParticleShaderValue = new ParticleShaderValue();
		
		private var _startTime:int;
		public function ParticleTemplate2D(parSetting:ParticleSettings)
		{
			super(parSetting);
			texture=new Texture();
			texture.load(settings.textureName);
			sv.u_Duration=settings.duration;
			sv.u_Gravity=settings.gravity;
			sv.u_EndVelocity=settings.endVelocity;
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
			if (texture.loaded)
			{
				//for(var i:int=0;i<3;i++)
				//{
					//addParticleArray(new Float32Array([x,y,0]),new Float32Array([0,0,0]));
				//}
				update(Timer.DELTA);
				sv.u_CurrentTime=_currentTime;
				if (_firstNewElement != _firstFreeElement)
				{
					addNewParticlesToVertexBuffer();
				}
				blend();
				
				if (_firstActiveElement != _firstFreeElement)
				{
					var gl:WebGLContext = WebGL.mainContext;
					_vertexBuffer.bind();
					_indexBuffer.bind();
					_indexBuffer.upload_bind();
					_vertexBuffer.upload_bind();
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
			if (activeBlendType !== blendType)
			{
				var gl:WebGLContext= WebGL.mainContext;
				gl.enable( WebGLContext.BLEND );
				BlendMode.fns[blendType]( gl);
				activeBlendType = blendType;
			}
		}
	}
}