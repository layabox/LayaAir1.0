package laya.particle {
	import laya.display.Sprite;
	import laya.net.Loader;
	import laya.particle.emitter.Emitter2D;
	import laya.particle.emitter.EmitterBase;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.resource.Texture;
	import laya.utils.Handler;
	
	/**
	 * <code>Particle2D</code> 类是2D粒子播放类
	 *
	 */
	public class Particle2D extends Sprite {
		/**@private */
		private var _matrix4:Array = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];//默认4x4矩阵
		/**@private */
		private var _particleTemplate:ParticleTemplateBase;
		/**@private */
		private var _canvasTemplate:ParticleTemplateCanvas;
		/**@private */
		private var _emitter:EmitterBase;
		/**是否自动播放*/
		public var autoPlay:Boolean = true;
		
		/**
		 * 创建一个新的 <code>Particle2D</code> 类实例。
		 * @param setting 粒子配置数据
		 */
		public function Particle2D(setting:ParticleSetting) {
			if (setting) setParticleSetting(setting);
		}
		
		/**
		 * 设置 粒子文件地址
		 * @param path 粒子文件地址
		 */
		public function set url(url:String):void {
			load(url);
		}
		
		/**
		 * 加载粒子文件
		 * @param url 粒子文件地址
		 */
		public function load(url:String):void {
			Laya.loader.load(url, Handler.create(this, setParticleSetting), null, Loader.JSON);
		}
		
		/**
		 * 设置粒子配置数据
		 * @param settings 粒子配置数据
		 */
		public function setParticleSetting(setting:ParticleSetting):void {
			if (!setting) return stop();
			ParticleSetting.checkSetting(setting);
			//_renderType |= RenderSprite.CUSTOM;
			if(__JS__("!window.ConchParticleTemplate2D")||Render.isWebGL)customRenderEnable = true;//设置custom渲染
			if (Render.isWebGL) {
				_particleTemplate = new ParticleTemplate2D(setting);
				this.graphics._saveToCmd(Render.context._drawParticle, [_particleTemplate]);
			}
			else if (Render.isConchApp&&__JS__("window.ConchParticleTemplate2D")) {
				_particleTemplate = __JS__("new ConchParticleTemplate2D()");
				var _this:Particle2D = this;
				Laya.loader.load(setting.textureName, Handler.create(null, function(texture:Texture):void{
						__JS__("_this._particleTemplate.texture = texture");
						_this._particleTemplate.settings = setting;
						if (Render.isConchNode){
							__JS__("_this.graphics.drawParticle(_this._particleTemplate)");
						}
						else{
							_this.graphics._saveToCmd(Render.context._drawParticle, [_particleTemplate]);
						}
					})
				);
				_emitter = { start:function():void{ }} as EmitterBase;
				__JS__("this.play =this._particleTemplate.play.bind(this._particleTemplate)");
				__JS__("this.stop =this._particleTemplate.stop.bind(this._particleTemplate)");
				if (autoPlay) play();
				return;
			}
			else {
				_particleTemplate = _canvasTemplate = new ParticleTemplateCanvas(setting);
			}
			if (!_emitter) {
				_emitter = new Emitter2D(_particleTemplate);
			} else {
				(_emitter as Emitter2D).template = _particleTemplate;
			}
			if (autoPlay) {
				emitter.start();
				play();
			}
		}
		
		/**
		 * 获取粒子发射器
		 */
		public function get emitter():EmitterBase {
			return _emitter;
		}
		
		/**
		 * 播放
		 */
		public function play():void {
			timer.frameLoop(1, this, _loop);
		}
		
		/**
		 * 停止
		 */
		public function stop():void {
			timer.clear(this, _loop);
		}
		
		/**@private */
		private function _loop():void {
			advanceTime(1 / 60);
		}
		
		/**
		 * 时钟前进
		 * @param passedTime 时钟前进时间
		 */
		public function advanceTime(passedTime:Number = 1):void {
			if (_canvasTemplate) {
				_canvasTemplate.advanceTime(passedTime);
			}
			if (_emitter) {
				_emitter.advanceTime(passedTime);
			}
		}
		
		public override function customRender(context:RenderContext, x:Number, y:Number):void {
			if (Render.isWebGL) {
				_matrix4[0] = context.ctx._curMat.a;
				_matrix4[1] = context.ctx._curMat.b;
				_matrix4[4] = context.ctx._curMat.c;
				_matrix4[5] = context.ctx._curMat.d;
				_matrix4[12] = context.ctx._curMat.tx;
				_matrix4[13] = context.ctx._curMat.ty;
				var sv:* = (_particleTemplate as ParticleTemplate2D).sv;
				sv.u_mmat = _matrix4;
			}
			
			if (_canvasTemplate) {
				_canvasTemplate.render(context, x, y);
			}
		}
		
		override public function destroy(destroyChild:Boolean = true):void 
		{
			if ( _particleTemplate  is ParticleTemplate2D)
			 (_particleTemplate  as ParticleTemplate2D).dispose();
			super.destroy(destroyChild);
		}
	}
}