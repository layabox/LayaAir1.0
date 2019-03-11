 package laya.layagl {
	 import laya.display.Sprite;
	 import laya.display.SpriteConst;
	 import laya.display.css.SpriteStyle;
	 import laya.maths.Rectangle;
	 import laya.resource.Context;
	 public class ConchSprite extends Sprite {
		/**cacheAs时，设置所有父对象缓存失效。 */
		//TODO:coverage
		public function parentRepaintForNative(type:int=SpriteConst.REPAINT_CACHE):void {
			var p:* = _parent;
			if ( p )
			{
				/*
				if ( ((_renderType & SpriteConst.CANVAS) == SpriteConst.CANVAS) || ((p._renderType & SpriteConst.CANVAS) == SpriteConst.CANVAS) )
				{
					this._conchData._int32Data[SpriteConst.POSREPAINT] |= type;
					type |= SpriteConst.REPAINT_NODE;
				}
				*/
				if (!((p._conchData._int32Data[SpriteConst.POSREPAINT]&type) == type)) {
					p._conchData._int32Data[SpriteConst.POSREPAINT] |=type;
					p.parentRepaintForNative(type);
				}
			}
		}
		
		//TODO:coverage
		public function renderToNative(context:Context, x:Number, y:Number):void {
			var layagl:* = context.gl;
			var nCurentFrameCount:int = LayaGL.getFrameCount() - 1;
			var iData:Float32Array = _conchData._int32Data;
			var nRepaint:int = iData[SpriteConst.POSREPAINT];
			if ( _children.length > 0 )
			{
				if ( nCurentFrameCount != iData[SpriteConst.POSFRAMECOUNT] || ( nRepaint > 0 && ((nRepaint & SpriteConst.REPAINT_NODE) == SpriteConst.REPAINT_NODE) ) )
				{
					layagl.blockStart(_conchData);
					_renderChilds(context);
					layagl.blockEnd(_conchData);
				}
				else
				{
					layagl.copyCmdBuffer( _conchData._int32Data[SpriteConst.POSBUFFERBEGIN], _conchData._int32Data[SpriteConst.POSBUFFEREND]);
				}
			}
			else
			{
				layagl.block(_conchData);
			}
		}
		
		public function writeBlockToNative():void
		{
			var layagl:* = LayaGL.instance;
			if ( _children.length > 0 )
			{
				layagl.blockStart(_conchData);
				_writeBlockChilds();
				layagl.blockEnd(_conchData);
			}
			else
			{
				layagl.block(_conchData);
			}
		}
		
		//TODO:coverage
		private function _renderChilds(context:Context):void 
		{
			var childs:Array = this._children, ele:*;
			var i:int=0, n:int = childs.length;
			var style:SpriteStyle = (this as Sprite)._style;
			if (style.viewport) {
				var rect:Rectangle = style.viewport;
				var left:Number = rect.x;
				var top:Number = rect.y;
				var right:Number = rect.right;
				var bottom:Number = rect.bottom;
				var _x:Number, _y:Number;
				
				for (; i < n; ++i) {
					if ((ele = childs[i])._visible && ((_x = ele._x) < right && (_x + ele.width) > left && (_y = ele._y) < bottom && (_y + ele.height) > top)) 
						ele.renderToNative(context);
				}
			} else {
				for (; i < n; ++i)
					(ele = childs[i])._visible && ele.renderToNative(context);
			}
		}
		
		private function _writeBlockChilds():void 
		{
			var childs:Array = this._children, ele:*;
			var i:int=0, n:int = childs.length;
			var style:SpriteStyle = (this as Sprite)._style;
			if (style.viewport) {
				var rect:Rectangle = style.viewport;
				var left:Number = rect.x;
				var top:Number = rect.y;
				var right:Number = rect.right;
				var bottom:Number = rect.bottom;
				var _x:Number, _y:Number;
				
				for (; i < n; ++i) {
					if ((ele = childs[i])._visible && ((_x = ele._x) < right && (_x + ele.width) > left && (_y = ele._y) < bottom && (_y + ele.height) > top)) 
						ele.writeBlockToNative();
				}
			} else {
				for (; i < n; ++i)
					(ele = childs[i])._visible && ele.writeBlockToNative();
			}
		}
		 
		/**cacheAs后，设置自己和父对象缓存失效。*/
		//TODO:coverage
		public function repaintForNative(type:int = SpriteConst.REPAINT_CACHE):void {
			/*
			if ( (_renderType & SpriteConst.CANVAS) == SpriteConst.CANVAS )
			{
				type |= SpriteConst.REPAINT_NODE;
			}
			*/
			if ( !( (this._conchData._int32Data[SpriteConst.POSREPAINT] & type ) == type))
			{
				this._conchData._int32Data[SpriteConst.POSREPAINT] |= type;
				parentRepaintForNative(type);
			}
			/*
			if (this._cacheStyle && this._cacheStyle.maskParent) {
				_cacheStyle.maskParent.repaint(type);
			}
			*/
		}
				
	 }
 }
