package laya.ui
{
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.resource.Texture;
	import laya.ui.AutoBitmap;
	import laya.ui.Clip;
	
	/**
	 * 
	 * 简单易用的位图字体类
	 * 
	 */	
	public class FontClip extends Clip
	{
		/**位图字体内容**/
		private var _sheet:String;
		/**数值*/
		protected var _valueArr:Array=[];
		/**文字排列方向，默认true 横向；false 竖向*/
		private var _xDirection:Boolean = true;
		/**@private */
		protected var _direction:String = "horizontal";
		/**X方向间隙*/
		protected var _spaceX:int;
		/**Y方向间隙*/
		protected var _spaceY:int;
		/**文字内容**/
		private var _strValue:String;
		/**文字内容数组**/
		private var _indexDir:Array = [];
		/**单个位图字体宽度**/
		/**
		 * @param url 位图字体图片url
		 * @param clipX 位图字体横向切片数量
		 * @param clipY 位图字体竖向切片数量
		 */		
		public function FontClip(url:String=null, clipX:int=1, clipY:int=1)
		{
			_clipX = clipX;
			_clipY = clipY;
			this.skin = url;
		}
		
		override protected function createChildren():void
		{
			_bitmap=new AutoBitmap();
			this.on(Event.LOADED,this,onClipLoaded);
		}
		
		/**
		 * 资源加载完毕 
		 */		
		private function onClipLoaded():void
		{
			callLater(changeValue);
		}
		
		public function get sheet():String{
			return _sheet;
		}
		/**
		 * 设置位图字体内容 
		 * @param value
		 */		
		public function set sheet(value:String):void
		{
			_indexDir =[];
			value = String(value + "");
			_sheet = value;
			for(var i:int=0;i<value.length;i++){
				_indexDir[value.charAt(i)] = i;
			}
		}
		
		public function get value():String
		{
			return _valueArr.join("");
		}
		/**
		 * 设置问题字体的显示内容 
		 * @param value
		 */		
		public function set value(value:String):void
		{
			value = String(value + "");
			_valueArr=value.split("");
			callLater(changeValue);
		}
		
		override public function get sources():Array
		{
			return _sources;
		}
		
		/**资源加载完成*/
		override public function set sources(value:Array):void
		{
			super.sources=value;
			callLater(changeValue);
		}
		
		/**
		 * 布局方向。
		 * <p>默认值为"horizontal"。</p>
		 * <p><b>取值：</b>
		 * <li>"horizontal"：表示水平布局。</li>
		 * <li>"vertical"：表示垂直布局。</li>
		 * </p>
		 */
		public function get direction():String {
			return _direction;
		}
		
		public function set direction(value:String):void {
			_direction = value;
			_xDirection=(value == "horizontal");
			callLater(changeValue);
		}
		
		/**X方向间隙*/
		public function get spaceX():int
		{
			return _spaceX;
		}
		
		public function set spaceX(value:int):void
		{
			_spaceX=value;
			if(_xDirection)
				callLater(changeValue);
		}
		
		/**Y方向间隙*/
		public function get spaceY():int
		{
			return _spaceY;
		}
		
		public function set spaceY(value:int):void
		{
			_spaceY=value;
			if(!_xDirection)
				callLater(changeValue);
		}
		
		/**渲染数值*/
		protected function changeValue():void
		{
			if(this.sources == null)
				return;
			this.graphics.clear();
			var texture:Texture;
			for(var i:int = 0,sz:int = _valueArr.length;i<sz;i++)
			{
				var index:int = _indexDir[_valueArr[i]];
				if (!this.sources[index]) continue;
				texture = this.sources[index];
				if(_xDirection)
				{//文字渲染方向-横向
					this.graphics.drawTexture(texture,i * (texture.width+spaceX),0,texture.width,texture.height);			
				}else
				{//文字渲染方向-竖向
					this.graphics.drawTexture(texture,0,i * (texture.height +spaceY),texture.width,texture.height);
				}
			}
			if (!texture) return;
			if(_xDirection)
			{//横向
				this.size(_valueArr.length*(texture.width + spaceX),texture.height);
			}else
			{//竖向
				this.size(texture.width,(texture.height + spaceY) * _valueArr.length);
			}
		}
		
		override public function dispose():void
		{
			_valueArr = null;
			_indexDir = null;
			this.graphics.clear();
			this.removeSelf();
			this.off(Event.LOADED,this,onClipLoaded);
			super.dispose();
		}
	}
}