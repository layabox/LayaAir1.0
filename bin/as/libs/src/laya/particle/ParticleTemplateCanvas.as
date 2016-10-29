package laya.particle 
{

	import laya.events.Event;
	import laya.particle.particleUtils.PicTool;
	import laya.particle.particleUtils.CMDParticle;
	import laya.particle.particleUtils.CanvasShader;
	import laya.renders.RenderContext;
	import laya.resource.Texture;
	import laya.utils.Utils;

	/**
	 *  @private 
	 */
	public class ParticleTemplateCanvas  extends ParticleTemplateBase
	{
		/**
		 * 是否处于可播放状态
		 */
		private var _ready:Boolean=false;
		/**
		 * 贴图列表 
		 */
		public var  textureList:Array=[];
		/**
		 * 粒子列表 
		 */
		public var particleList:Array=[];		
		/**
		 * 贴图中心偏移x 
		 */		
		public var pX:int;
		/**
		 * 贴图中心偏移y
		 */		
		public var pY:int;	
		/**
		 * 当前活跃的粒子 
		 */
		public var activeParticles:Array=[];
		/**
		 * 粒子pool 
		 */
		public var deadParticles:Array=[];
		/**
		 * 粒子播放进度列表 
		 */
		public var iList:Array=[];
		/**
		 * 粒子系统使用的最大粒子数 
		 */
		protected var _maxNumParticles:int;  
		/**
		 * 纹理的宽度 
		 */
		public var textureWidth:Number;
		/**
		 * 宽度倒数 
		 */
		public var dTextureWidth:Number;
		/**
		 * 是否支持颜色变化 
		 */
		public var colorChange:Boolean=true;
		/**
		 * 采样步长 
		 */
		public var step:Number=1/60;
		
		/**
		 * 用于更新粒子状态的公用仿Shader对象 
		 */
		private var canvasShader:CanvasShader = new CanvasShader();
		
		public function ParticleTemplateCanvas(particleSetting:ParticleSetting) 
		{
		    super();
			settings = particleSetting;
			_maxNumParticles = particleSetting.maxPartices;
			texture=new Texture();
			texture.on(Event.LOADED,this,_textureLoaded);
			texture.load(particleSetting.textureName);		
		}
		private function _textureLoaded(e:Event):void
		{
			setTexture(texture);
			_ready=true;
		}
		
		public function clear(clearTexture:Boolean=true):void
		{
			deadParticles.length=0;
			activeParticles.length=0;
			textureList.length=0;
		}
		
		/**
		 * 设置纹理 
		 * @param texture
		 * 
		 */
		public function setTexture(texture:*):void
		{
			this.texture=texture;
			textureWidth=texture.width;
			dTextureWidth=1/textureWidth;
			pX=-texture.width*0.5;
			pY=-texture.height*0.5;
			textureList=changeTexture(texture,textureList);
			particleList.length=0;
			deadParticles.length=0;
			activeParticles.length=0;
		}
		
		public static function changeTexture(texture:*,rst:Array,settings:ParticleSetting=null):Array
		{
			if(!rst) rst=[];
			rst.length = 0;
			if (settings&&settings.colorComponentInter)
			{
				rst.push(texture, texture, texture);
			}else
			{
				Utils.copyArray(rst,PicTool.getRGBPic(texture));
			}
			
			return rst;
		}


		/**
		 * 创建一个粒子数据 
		 * @return 
		 * 
		 */
		private function _createAParticleData(position:Float32Array, velocity:Float32Array):CMDParticle
		{
			canvasShader.u_EndVelocity=settings.endVelocity;
			canvasShader.u_Gravity=settings.gravity;
			canvasShader.u_Duration=settings.duration;
			
			
			var particle:ParticleData;
			particle=ParticleData.Create(settings,position,velocity,0);
			
			canvasShader.a_Position = particle.position;
			canvasShader.a_Velocity = particle.velocity;
			canvasShader.a_StartColor = particle.startColor;
			canvasShader.a_EndColor = particle.endColor;
			canvasShader.a_SizeRotation=particle.sizeRotation;	
			canvasShader.a_Radius = particle.radius;
			canvasShader.a_Radian=particle.radian;
			canvasShader.a_AgeAddScale=particle.durationAddScale;
			canvasShader.oSize=textureWidth;
			
			var rst:CMDParticle=new CMDParticle();
			var i:int,len:Number=settings.duration/(1+particle.durationAddScale);
			var params:Array=[];
			var mStep:Number;
			
			for(i=0;i<len;i+=step)
			{
				params.push(canvasShader.getData(i));
				
			}	
			rst.id=particleList.length;
			particleList.push(rst);
			rst.setCmds(params);
			return rst;
		}
	
		override public function addParticleArray(position:Float32Array, velocity:Float32Array):void
		{
			if(!_ready) return;
			var tParticle:CMDParticle;
			if(particleList.length<_maxNumParticles)
			{
				tParticle=_createAParticleData(position,velocity);
				iList[tParticle.id]=0;
				activeParticles.push(tParticle);
			}else
			{
				if(deadParticles.length>0)
				{
					tParticle=deadParticles.pop();
					iList[tParticle.id]=0;
					activeParticles.push(tParticle);
				}
			}
		}
				
		public function advanceTime(passedTime:Number=1):void
		{
			if(!_ready) return;
			var particleList:Array=activeParticles;
			var pool:Array=deadParticles;
			var i:int,len:int=particleList.length;
			var tcmd:CMDParticle;
			var tI:int;
			var iList:Array=this.iList;
			for(i=len-1;i>-1;i--)
			{			
				tcmd=particleList[i];
				tI=iList[tcmd.id];
				if(tI>=tcmd.maxIndex)
				{
					tI=0;
					particleList.splice(i,1);
					pool.push(tcmd);
				}else
				{
					tI+=1;
				}
				iList[tcmd.id]=tI;
			}
		}
		
		public function render(context:RenderContext, x:Number, y:Number):void
		{
			if(!_ready) return;
			if(activeParticles.length<1) return;
			if (textureList.length < 2) return;
			if (settings.colorComponentInter)
			{
				noColorRender(context,x,y);
			}else
			{
				canvasRender(context,x,y);
			}
			
		}
		
		
		public  function noColorRender(context:RenderContext, x:Number, y:Number):void
		{
			//以下为渲染部分
			var particleList:Array=activeParticles;
			var i:int,len:int=particleList.length;
			var tcmd:CMDParticle;
			var tParam:Array;
			var tAlpha:Number;
			var px:Number = this.pX, py:Number = this.pY;
			var pw:Number=-px*2,ph:Number=-py*2;
			var tI:int;
			var textureList:Array=this.textureList;
			var iList:Array=this.iList;
			var preAlpha:Number;
			
			context.translate(x, y);
			preAlpha=context.ctx.globalAlpha;			
			for(i=0;i<len;i++)
			{
				tcmd=particleList[i];
				tI=iList[tcmd.id];	
				tParam = tcmd.cmds[tI];	
				if (!tParam) continue;
				if ( (tAlpha = tParam[1]) <= 0.01) continue;			
				context.setAlpha(preAlpha*tAlpha);
				context.drawTextureWithTransform(texture,px,py,pw,ph,tParam[2],1);			
			}
			context.setAlpha(preAlpha);
			context.translate(-x, -y);
		}
		public  function canvasRender(context:RenderContext, x:Number, y:Number):void
		{			
			//以下为渲染部分
			var particleList:Array=activeParticles;
			var i:int,len:int=particleList.length;
			var tcmd:CMDParticle;
			var tParam:Array;
			var tAlpha:Number;
			var px:Number = this.pX, py:Number = this.pY;
			var pw:Number=-px*2,ph:Number=-py*2;
			var tI:int;
			var textureList:Array=this.textureList;
			var iList:Array=this.iList;
			var preAlpha:Number;
			
			var preB:String;
			//			context.save();
			context.translate(x, y);
			preAlpha=context.ctx.globalAlpha;
			preB=context.ctx.globalCompositeOperation;
			
			
			context.blendMode("lighter");
			
			for(i=0;i<len;i++)
			{
				tcmd=particleList[i];
				tI=iList[tcmd.id];	
				tParam = tcmd.cmds[tI];	
				if (!tParam) continue;
				if ( (tAlpha = tParam[1]) <= 0.01) continue;
				
				context.save();
				context.transformByMatrix(tParam[2]);
				
				if(tParam[3]>0.01)
				{
					context.setAlpha(preAlpha*tParam[3]);
					context.drawTexture(textureList[0],px,py,pw,ph);
				}
				
				if(tParam[4]>0.01)
				{
					context.setAlpha(preAlpha*tParam[4]);
					context.drawTexture(textureList[1],px,py,pw,ph);
				} 
				
				if(tParam[5]>0.01)
				{
					context.setAlpha(preAlpha*tParam[5]);
					context.drawTexture(textureList[2],px,py,pw,ph);
				}
				
				context.restore();
			}
			context.setAlpha(preAlpha);
			context.translate(-x, -y);
			context.blendMode(preB);
			//			context.restore();
		}
	}

}