package laya.html.dom
{
	import laya.display.css.CSSStyle;
	import laya.display.ILayout;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.html.utils.Layout;
	import laya.net.Loader;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.resource.Texture;
	import laya.utils.Stat;
	
	/**
	 * @private
	 */
	public class HTMLImageElement extends HTMLElement 
	{
		private var _tex:Texture;
		private var _url:String;
		private var _renderArgs:Array = [];
		
		public function HTMLImageElement() 
		{
			super();
			style.block = true;
		}
		
		public function set src(url:String):void
		{
			url = formatURL(url);
			if (_url == url) return;
			_url = url;
			_tex = Loader.getRes(url)
			if (!_tex) {
				_tex = new Texture();
				_tex.load(url);
				Loader.cacheRes(url, _tex);
			}
			
			var tex:Texture = _tex=Loader.getRes(url);
			if (!tex) {
				_tex = tex=new Texture();
				tex.load(url);
				Loader.cacheRes(url, tex);
			}
			
			function onloaded():void
			{
				var style:CSSStyle = _style as CSSStyle;				
				var w:Number = style.widthed(this)? -1:_tex.width;
				var h:Number = style.heighted(this)? -1:_tex.height;
				
				if (!style.widthed(this) && _width != _tex.width )
				{
					width = _tex.width;
					parent && (parent as Sprite)._layoutLater();
				}

				if (!style.heighted(this) && _height != _tex.height )
				{
					height = _tex.height;
					parent && (parent as Sprite)._layoutLater();
				}
				if (Render.isConchApp)
				{
					_renderArgs[0] = _tex;
					_renderArgs[1] = x;
					_renderArgs[2] = y;
					_renderArgs[3] = width || _tex.width;
					_renderArgs[4] = height || _tex.height;
					graphics.drawTexture(_tex, 0, 0, _renderArgs[3], _renderArgs[4]);
					//context.ctx.drawTexture2(0, 0, style.translateX, style.translateY, transform, style.alpha, style.blendMode, _renderArgs);
				}
			}
			
			tex.loaded?onloaded():tex.on(Event.LOADED, null, onloaded);			
		}
		
		public override function _addToLayout(out:Vector.<ILayout>):void
		{
			!_style.absolute && out.push(this);
		}
		
		override public function render(context:RenderContext, x:Number, y:Number):void {

			if (!_tex || !_tex.loaded || !_tex.loaded || _width < 1 || _height < 1) return;
			
			Stat.spriteCount++;
			
			//tx:Texture, x:Number, y:Number, width:Number, height:Number
			_renderArgs[0] = _tex;
			_renderArgs[1] = this.x;
			_renderArgs[2] = this.y;
			_renderArgs[3] = width || _tex.width;
			_renderArgs[4] = height || _tex.height;
			context.ctx.drawTexture2(x, y, style.translateX, style.translateY, transform, style.alpha, style.blendMode, _renderArgs);
		}
	}

}