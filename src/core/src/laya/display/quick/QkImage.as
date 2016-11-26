package laya.display.quick
{
	import laya.display.css.Style;
	import laya.display.Sprite;
	import laya.renders.RenderContext;
	import laya.resource.Texture;
	import laya.utils.Stat;
	
	/**
	 * ...
	 * @author laoxie
	 */
	public class QkImage  extends Sprite
	{
		private static const TYPE_WIDTH_DEF:int = 0x10;
		private static const TYPE_HEIGHT_DEF:int = 0x100;
		
		protected var _vbdata:Float32Array = new Float32Array(16);		
		protected var _renderKey:Number = -1;
		protected var _typedef:int = 0;
		protected var _tex:Texture = null;
		protected var _offsetX:Number = 0;
		protected var _offsetY:Number = 0;
		
		public function QkImage()
		{
			
		}
		
		public override function size(w:Number, h:Number):Sprite
		{
			_typedef |= TYPE_WIDTH_DEF | TYPE_HEIGHT_DEF;
			return super.size(w, h);
		}

		public override function set width(value:Number):void
		{
			_typedef |= TYPE_WIDTH_DEF;
			_changeType |= CHG_VIEW;
			super.width = value;
		}
		
		public override function set height(value:Number):void
		{
			_typedef |= TYPE_HEIGHT_DEF;
			_changeType |= CHG_VIEW;
			super.height = value;
		}
		
		public function offset(x:Number, y:Number):void
		{
			this._offsetX = 0;
			this._offsetY = 0;
		}
		
		public override function set alpha(value:Number):void {
			if (_style && _style.alpha !== value)
			{
				_renderKey = -1;
				super.alpha = value;
			}
		}
		
		protected function _preRender():void
		{
			var vbdata:Float32Array = _vbdata;
			
			if (_changeType & CHG_VIEW)
			{
				var _tf:Object = _style._tf;
				var _sx:Number = _tf.scaleX;
				var _sy:Number = _tf.scaleY;
				var translateX:Number = -_tf.translateX;
				var translateY:Number = -_tf.translateY;
				
				if (_tf.rotate === 0)
				{
					var px:Number = translateX* _sx;
					var py:Number = translateY *_sy;
					vbdata[0] = vbdata[12] = px;
					vbdata[1] = vbdata[5] = py;
					vbdata[4] = vbdata[8] = px + _width *_sx;
					vbdata[9] = vbdata[13] = py + _height *_sy;
				}
				else
				{					
					vbdata[0] = vbdata[12] = translateX;
					vbdata[1] = vbdata[5] = translateY;
					vbdata[4] = vbdata[8] = _width +translateX;
					vbdata[9] = vbdata[13] = _height+translateY;
					
					var angle:Number = _tf.rotate * 0.0174532922222222;// Math.PI / 180;
					var cos:Number = Math.cos(angle),sin:Number = Math.sin(angle);
					var xcos:Number = cos * _sx,ycos:Number = cos * _sy;
					var xsin:Number = sin * _sx,ysin:Number = sin * _sy;
					
					for (var i:int = 0; i < 16; i+=4) {
						var cx:Number = vbdata[i];
						var cy:Number = vbdata[i + 1];
						vbdata[i] = cx * xcos - cy * ysin;
						vbdata[i + 1] = cx * xsin + cy * ycos;
					}
				}
			}
			if (_changeType & CHG_TEXTURE)
			{
				var uv:Array = _tex.uv;
				vbdata[2] = uv[0];
				vbdata[3] = uv[1];
				vbdata[6] = uv[2];
				vbdata[7] = uv[3];
				vbdata[10] = uv[4];
				vbdata[11] = uv[5];
				vbdata[14] = uv[6];
				vbdata[15] = uv[7];
			}
			_changeType = 0;
		}
		
		public override function render(context:RenderContext, x:Number, y:Number):void {
			if (_tex)
			{
				_changeType && _preRender();

				var ctx:*= context.ctx;
				(_renderKey !== ctx._renderKey) && (_renderKey = ctx.willDrawTexture(_tex, alpha));
				_renderKey>0 && ctx.addTextureVb(_vbdata, x+_offsetX+_x, y+_offsetY+_y);
				Stat.spriteCount ++;
			}
		}
		
		public override function get texture():Texture
		{
			return _tex;
		}
		
		public override function set texture(tex:Texture):void
		{
			if (_tex !== tex)
			{
				_tex = tex;
				_changeType |= CHG_TEXTURE;
				if (tex)
				{
					_renderKey = -1;
					var vbdata:Float32Array = _vbdata;
					if (_width !== tex.width || _height !== tex.height)
					{
						_width = (_typedef & TYPE_WIDTH_DEF)?_width:tex.width;
						_height = (_typedef & TYPE_HEIGHT_DEF)?_height:tex.height;
						_changeType |= CHG_VIEW;
					}
				}
				else _renderKey = 0;
			}
		}
	}

}