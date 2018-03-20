package laya.particle
{
	
	import laya.particle.shader.value.ParticleShaderValue;
	import laya.resource.Texture;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.BlendMode;
	import laya.webgl.resource.WebGLImage;
	import laya.webgl.submit.ISubmit;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.VertexBuffer2D;

	/**
	 *  @private 
	 */
	public class ParticleTemplate2D extends ParticleTemplateWebGL implements ISubmit
	{
		private var _vertexBuffer2D:VertexBuffer2D;
		private var _indexBuffer2D:IndexBuffer2D;
		
		public static var activeBlendType:int = -1;
		public var x:Number=0;
		
		public var y:Number=0;
		protected var _blendFn:Function;
		public var sv:ParticleShaderValue = new ParticleShaderValue();
		
		private var _startTime:int;
		

		
		public function ParticleTemplate2D(parSetting:ParticleSetting)
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
			
			_vertexBuffer =_vertexBuffer2D= VertexBuffer2D.create( -1, WebGLContext.DYNAMIC_DRAW);
			_indexBuffer = _indexBuffer2D=IndexBuffer2D.create(WebGLContext.STATIC_DRAW );
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
		
		override protected function loadContent():void 
		{
			var indexes:Uint16Array = new Uint16Array(settings.maxPartices * 6);
			
			for (var i:int = 0; i < settings.maxPartices; i++) {
				indexes[i * 6 + 0] = (i * 4 + 0);
				indexes[i * 6 + 1] = (i * 4 + 1);
				indexes[i * 6 + 2] = (i * 4 + 2);
				
				indexes[i * 6 + 3] = (i * 4 + 0);
				indexes[i * 6 + 4] = (i * 4 + 2);
				indexes[i * 6 + 5] = (i * 4 + 3);
			}
			
			_indexBuffer2D.clear();
			_indexBuffer2D.append(indexes);
			_indexBuffer2D.upload();
		}
		
		override public function addNewParticlesToVertexBuffer():void 
		{
			_vertexBuffer2D.clear();
			_vertexBuffer2D.append(_vertices);
			
			var start:int;
			if (_firstNewElement < _firstFreeElement) {
				// 如果新增加的粒子在Buffer中是连续的区域，只upload一次
				start = _firstNewElement * 4 * _floatCountPerVertex * 4;
				_vertexBuffer2D.subUpload(start, start, start + (_firstFreeElement - _firstNewElement) * 4 * _floatCountPerVertex * 4);
			} else {
				//如果新增粒子区域超过Buffer末尾则循环到开头，需upload两次
				start = _firstNewElement * 4 * _floatCountPerVertex * 4;
				_vertexBuffer2D.subUpload(start, start, start + (settings.maxPartices - _firstNewElement) * 4 * _floatCountPerVertex * 4);
				
				if (_firstFreeElement > 0) {
					_vertexBuffer2D.setNeedUpload();
					_vertexBuffer2D.subUpload(0, 0, _firstFreeElement * 4 * _floatCountPerVertex * 4);
				}
			}
			_firstNewElement = _firstFreeElement;
		}
		
		
		public function renderSubmit():int
		{
			if (texture&&texture.loaded)
			{
				update(Laya.timer.delta);
				sv.u_CurrentTime=_currentTime;
				if (_firstNewElement != _firstFreeElement)
				{
					addNewParticlesToVertexBuffer();
				}
				
				blend();
				
				if (_firstActiveElement != _firstFreeElement)
				{
					var gl:WebGLContext = WebGL.mainContext;
					_vertexBuffer2D.bind(_indexBuffer2D);
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
		
		public function dispose():void
		{
			_vertexBuffer2D.dispose();
			_indexBuffer2D.dispose();
		}
	}
}