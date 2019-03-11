package laya.renders {
	import laya.display.Sprite;
	import laya.display.SpriteConst;
	import laya.display.css.SpriteStyle;
	import laya.maths.Matrix;
	import laya.maths.Rectangle;
	import laya.resource.Context;
	import laya.resource.Texture;
	
	/**
	 * @private
	 * 快速节点命令执行器
	 * 多个指令组合才有意义，单个指令没必要在下面加
	 */
	public class LayaGLQuickRunner {
		/*[FILEINDEX:10000]*/
		public static var map:* = {};
		private static var curMat:Matrix = new Matrix();
		
		public static function __init__():void {
			/*
			   glQuickMap["drawNode;"] = drawNode;
			   glQuickMap["drawNodes;"] = drawNodes;
			   glQuickMap["drawLayaGL;"] = drawLayaGL;
			   glQuickMap["drawLayaGL;drawNodes;"] = drawLayaGL_drawNodes;
			   glQuickMap["save;alpha;drawNode;restore;"] = save_alpha_drawNode_restore;
			   glQuickMap["save;alpha;drawLayaGL;restore;"] = save_alpha_drawLayaGL_restore;
			 */
			//glQuickMap["save;alpha;drawTextureWithGr;restore;"] = save_alpha_drawTextureWithGr_restore;
			//glQuickMap["save;transform;drawTextureWithGr;restore;"] = save_alpha_transform_drawTextureWithGr_restore;
			//glQuickMap["save;alpha;transform;drawTextureWithGr;restore;"] = save_alpha_transform_drawTextureWithGr_restore;
			//glQuickMap["drawTextureWithGr;"] = drawTextureWithGr;
			//glQuickMap["save;transform;drawNodes;restore;"] = save_transform_drawNodes_restore;
			//glQuickMap["save;transform;drawLayaGL;restore;"] = save_alpha_transform_drawLayaGL_restore;
			//glQuickMap["save;alpha;transform;drawLayaGL;restore;"] = save_alpha_transform_drawLayaGL_restore;
			//glQuickMap["save;alpha;transform;drawLayaGL;restore;"] = save_alpha_transform_drawLayaGL_restore;
			//map[SpriteConst.TEXTURE] = _drawTexture;
			map[SpriteConst.ALPHA | SpriteConst.TRANSFORM | SpriteConst.GRAPHICS] = alpha_transform_drawLayaGL;
			//map[ SpriteConst.GRAPHICS] = _drawLayaGL;
			map[SpriteConst.ALPHA | SpriteConst.GRAPHICS] = alpha_drawLayaGL;
			map[SpriteConst.TRANSFORM | SpriteConst.GRAPHICS] = transform_drawLayaGL;
			map[SpriteConst.TRANSFORM | SpriteConst.CHILDS] = transform_drawNodes;
			
			map[SpriteConst.ALPHA | SpriteConst.TRANSFORM | SpriteConst.TEXTURE] = alpha_transform_drawTexture;
			map[SpriteConst.ALPHA | SpriteConst.TEXTURE] = alpha_drawTexture;
			map[SpriteConst.TRANSFORM | SpriteConst.TEXTURE] = transform_drawTexture;
			map[SpriteConst.GRAPHICS | SpriteConst.CHILDS] = drawLayaGL_drawNodes;
		}
		
		static public function transform_drawTexture(sprite:Sprite, context:Context, x:Number, y:Number):void {
			var style:SpriteStyle = sprite._style;
			var tex:Texture = sprite.texture;
			
			context.saveTransform(curMat);
			context.transformByMatrix(sprite.transform, x, y);
			context.drawTexture(tex, -sprite.pivotX, -sprite.pivotY, sprite._width || tex.width, sprite._height || tex.height);
			context.restoreTransform(curMat);
		}

		//static public function _drawTexture(sprite:Sprite, context:Context, x:Number, y:Number):void {
			//var tex:Texture = sprite.texture;
			//context.drawTexture(tex, x-sprite.pivotX, y-sprite.pivotY, sprite._width || tex.width, sprite._height || tex.height);
		//}
		
		static public function alpha_drawTexture(sprite:Sprite, context:Context, x:Number, y:Number):void {
			var style:SpriteStyle = sprite._style;
			var alpha:Number;
			var tex:Texture = sprite.texture;
			if ((alpha = style.alpha) > 0.01 || sprite._needRepaint()) {
				var temp:Number = context.globalAlpha;
				context.globalAlpha *= alpha;
				context.drawTexture(tex, x-style.pivotX, y-style.pivotY, sprite._width || tex.width, sprite._height || tex.height);
				context.globalAlpha = temp;
			}
		}
		
		static public function alpha_transform_drawTexture(sprite:Sprite, context:Context, x:Number, y:Number):void {
			var style:SpriteStyle = sprite._style;
			var alpha:Number;
			var tex:Texture = sprite.texture;
			if ((alpha = style.alpha) > 0.01 || sprite._needRepaint()) {
				var temp:Number = context.globalAlpha;
				context.globalAlpha *= alpha;
				
				context.saveTransform(curMat);
				context.transformByMatrix(sprite.transform, x, y);
				context.drawTexture(tex, -style.pivotX, -style.pivotY, sprite._width || tex.width, sprite._height || tex.height);
				context.restoreTransform(curMat);
				
				context.globalAlpha = temp;
			}
		}
		
		static public function alpha_transform_drawLayaGL(sprite:Sprite, context:Context, x:Number, y:Number):void {
			var style:SpriteStyle = sprite._style;
			var alpha:Number;
			if ((alpha = style.alpha) > 0.01 || sprite._needRepaint()) {
				var temp:Number = context.globalAlpha;
				context.globalAlpha *= alpha;
				
				context.saveTransform(curMat);
				context.transformByMatrix(sprite.transform, x, y);
				sprite._graphics && sprite._graphics._render(sprite, context, -style.pivotX, -style.pivotY);
				context.restoreTransform(curMat);
				
				context.globalAlpha = temp;
			}
		}
		
		static public function alpha_drawLayaGL(sprite:Sprite, context:Context, x:Number, y:Number):void {
			var style:SpriteStyle = sprite._style;
			var alpha:Number;
			if ((alpha = style.alpha) > 0.01 || sprite._needRepaint()) {
				var temp:Number = context.globalAlpha;
				context.globalAlpha *= alpha;
				sprite._graphics && sprite._graphics._render(sprite, context, x-style.pivotX, y -style.pivotY);
				context.globalAlpha = temp;
			}
		}
		
		//static public function _drawLayaGL(sprite:Sprite, context:Context, x:Number, y:Number):void {
			//sprite._graphics._render(sprite, context, x, y);
		//}		
		
		static public function transform_drawLayaGL(sprite:Sprite, context:Context, x:Number, y:Number):void {
			var style:SpriteStyle = sprite._style;
			//var transform:Matrix = sprite.transform;
			
			//临时
			//if (transform) {
				context.saveTransform(curMat);
				context.transformByMatrix(sprite.transform, x, y);
				sprite._graphics && sprite._graphics._render(sprite, context, -style.pivotX, -style.pivotY);
				context.restoreTransform(curMat);
			//}else {
				//sprite._graphics && sprite._graphics._render(sprite, context, -style.pivotX, -style.pivotY);
			//}			
		}
		
		static public function transform_drawNodes(sprite:Sprite, context:Context, x:Number, y:Number):void {
			//var transform:Matrix = sprite.transform;
			var style:SpriteStyle = sprite._style;
			context.saveTransform(curMat);
			context.transformByMatrix(sprite.transform, x, y);
			
			//x = x-style.pivotX;
			//y = y - style.pivotY;
			
			x = -style.pivotX;
			y = -style.pivotY;
			
			var childs:Array = sprite._children, n:int = childs.length, ele:*;
			if (style.viewport) {
				var rect:Rectangle = style.viewport;
				var left:Number = rect.x;
				var top:Number = rect.y;
				var right:Number = rect.right;
				var bottom:Number = rect.bottom;
				var _x:Number, _y:Number;
				
				for (i = 0; i < n; ++i) {
					if ((ele = childs[i] as Sprite)._visible && ((_x = ele._x) < right && (_x + ele.width) > left && (_y = ele._y) < bottom && (_y + ele.height) > top)) {
						ele.render(context, x, y);
					}
				}
			} else {
				for (var i:int = 0; i < n; ++i)
					(ele = (childs[i] as Sprite))._visible && ele.render(context, x, y);
			}
			
			context.restoreTransform(curMat);
		}
		
		static public function drawLayaGL_drawNodes(sprite:Sprite, context:Context, x:Number, y:Number):void {
			var style:SpriteStyle = sprite._style;
			x = x-style.pivotX;
			y = y-style.pivotY;
			sprite._graphics && sprite._graphics._render(sprite, context, x, y);
			
			var childs:Array = sprite._children, n:int = childs.length, ele:*;
			if (style.viewport) {
				var rect:Rectangle = style.viewport;
				var left:Number = rect.x;
				var top:Number = rect.y;
				var right:Number = rect.right;
				var bottom:Number = rect.bottom;
				var _x:Number, _y:Number;
				
				for (i = 0; i < n; ++i) {
					if ((ele = childs[i] as Sprite)._visible && ((_x = ele._x) < right && (_x + ele.width) > left && (_y = ele._y) < bottom && (_y + ele.height) > top)) {
						ele.render(context, x, y);
					}
				}
			} else {
				for (var i:int = 0; i < n; ++i)
					(ele = (childs[i] as Sprite))._visible && ele.render(context, x, y);
			}
		}
	}
}