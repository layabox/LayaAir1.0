package laya.renders {
	import laya.Const;
	import laya.display.Sprite;
	import laya.display.SpriteConst;
	import laya.display.css.SpriteStyle;
	import laya.maths.Matrix;
	import laya.maths.Rectangle;
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.webgl.canvas.WebGLContext2D;
	
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
			
			
			/*
			var ctx:WebGLContext2D = context as WebGLContext2D;
			var ctxm:Matrix = ctx._curMat;
			ctxm.copyTo(curMat);
			//context.saveTransform(curMat);
			ctx.transformByMatrixNoSave(sprite.getTransform(), x, y);
			ctx.drawTexture(tex, -style.pivotX, -style.pivotY, sprite._width || tex.width, sprite._height || tex.height);
			curMat.copyTo(ctxm);
			//ctx.restoreTransform(curMat);
			*/
			
			context.saveTransform(curMat);
			context.transformByMatrix(sprite.transform, x, y);
			context.drawTexture(tex, -sprite.pivotX, -sprite.pivotY, sprite._width || tex.width, sprite._height || tex.height);
			context.restoreTransform(curMat);
			
			/*
			context.saveTransform(curMat);
			var w:int = sprite._width || tex.width;
			var h:int = sprite._height || tex.height;
			var mat:Matrix = sprite.transform;// (sprite as Object)._tfChanged?(sprite as Object)._adjustTransform():(sprite as Object)._transform;
			mat.tx += x; mat.ty += y;
			//(context as WebGLContext2D).drawTextureWithTransform(tex, -style.pivotX, -style.pivotY, w, h,mat,x,y,1,null,null);
			
			var ctx:WebGLContext2D = context;
			var curMat:Matrix = ctx._curMat;
			var tmpMat:Matrix = ctx._tmpMatrix;
			var transform = mat;
			//克隆transform,因为要应用tx，ty，这里不能修改原始的transform
			tmpMat.a = transform.a; tmpMat.b = transform.b; tmpMat.c = transform.c; tmpMat.d = transform.d; tmpMat.tx = transform.tx + x; tmpMat.ty = transform.ty + y;
			tmpMat._bTransform = transform._bTransform;
			if (transform && curMat._bTransform) {
				Matrix.mul(tmpMat, curMat, tmpMat);
				transform = tmpMat;
				transform._bTransform = true;
			}else {
				//如果curmat没有旋转。
				transform = tmpMat;
			}
			ctx._drawTextureM(tex, x, y, w,h, mat, 1,null);
			
			//var st = __JS__("performance.now()");
			//Laya.stage.perfdt += (__JS__("performance.now()")-st);
			context.restoreTransform(curMat);
			*/
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
				context.drawTexture(tex, x-style.pivotX+tex.offsetX, y-style.pivotY+tex.offsetY, sprite._width || tex.width, sprite._height || tex.height);
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
				context.drawTexture(tex, -style.pivotX+tex.offsetX, -style.pivotY+tex.offsetY, sprite._width || tex.width, sprite._height || tex.height);
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
			var textLastRender:Boolean = sprite._getBit(Const.DRAWCALL_OPTIMIZE) && context.drawCallOptimize(true);
			
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
			textLastRender && context.drawCallOptimize(false);
		}
		
		static public function drawLayaGL_drawNodes(sprite:Sprite, context:Context, x:Number, y:Number):void {
			
			var textLastRender:Boolean = sprite._getBit(Const.DRAWCALL_OPTIMIZE) && context.drawCallOptimize(true);
			
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
			
			textLastRender && context.drawCallOptimize(false);
		}
	}
}