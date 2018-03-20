package laya.debug.tools
{
	import laya.display.Sprite;
	import laya.maths.Rectangle;
	import laya.renders.RenderSprite;
	import laya.resource.HTMLCanvas;
	import laya.resource.Texture;
	
	/**
	 * ...
	 * @author ww
	 */
	public class CanvasTools
	{
		
		public function CanvasTools()
		{
		
		}
		
		public static function createCanvas(width:int, height:int):HTMLCanvas
		{
			var rst:HTMLCanvas = new HTMLCanvas("2D");
			rst.getContext('2d');
			rst.size(width, height);
			return rst;
		}
		
		public static function renderSpriteToCanvas(sprite:Sprite, canvas:HTMLCanvas, offsetX:Number, offsetY:Number):void
		{
			RenderSprite.renders[sprite._renderType]._fun(sprite, canvas.context, offsetX, offsetY);
		}
		
		public static function getImageDataFromCanvas(canvas:HTMLCanvas, x:int = 0, y:int = 0, width:int = 0, height:int = 0):*
		{
			if (width <= 0)
				width = canvas.width;
			if (height <= 0)
				height = canvas.height;
			var imgdata:* = canvas.context.getImageData(x, y, width, height);
			return imgdata;
		}
		public static function getImageDataFromCanvasByRec(canvas:HTMLCanvas, rec:Rectangle):*
		{
			var imgdata:* = canvas.context.getImageData(rec.x, rec.y, rec.width, rec.height);
			return imgdata;
		}
		public static function getDifferCount(imageData1:*, imageData2:*):int
		{
			var data1:Array = imageData1.data;
			var data2:Array  = imageData2.data;
			var differCount:int;
			differCount = 0;
			walkImageData(imageData1, myWalkFun);
			return differCount;
			function myWalkFun(i:int, j:int, tarPos:int, data:Array):void
			{
				if (!isPoinSame(tarPos, data1, data2)) differCount++;
			}
		}
		public static function getDifferRate(imageData1:*, imageData2:*):Number
		{
			return getDifferCount(imageData1,imageData2)/(imageData1.width * imageData1.height);
		}
		public static function getCanvasDisRec(canvas:HTMLCanvas):Rectangle
		{
			var rst:Rectangle;
			rst = new Rectangle;
			var imgdata:*;
			imgdata = getImageDataFromCanvas(canvas, 0, 0);
			
			var maxX:int;
			var minX:int;
			var maxY:int;
			var minY:int;
			maxX = maxY = 0;
			minX = imgdata.width;
			minY = imgdata.height;
			var i:int, iLen:int;
			var j:int, jLen:int;
			iLen = imgdata.width;
			jLen = imgdata.height;
			var data:Array;
			data = imgdata.data;
			var tarPos:int = 0;
			
			for (j = 0; j < jLen; j++)
			{
				for (i = 0; i < iLen; i++)
				{
					if (!isEmptyPoint(data, tarPos))
					{
						if (minX > i)
							minX = i;
						if (maxX < i)
							maxX = i;
						if (minY > j)
							minY = j;
						if (maxY < j)
							maxY = j;
					}
					tarPos += 4;
				}
			}
			rst.setTo(minX, minY, maxX - minX+1, maxY - minY+1);
			return rst;
		}
		public static function fillCanvasRec(canvas:HTMLCanvas, rec:Rectangle, color:String):void
		{
			var ctx:*= canvas.context;
			ctx.fillStyle=color;
            ctx.fillRect(rec.x,rec.y,rec.width,rec.height);
		}
		public static function isEmptyPoint(data:Array, pos:int):Boolean
		{
			if (data[pos] == 0 && data[pos + 1] == 0 && data[pos + 2] == 0 && data[pos + 3] == 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public static function isPoinSame(pos:int, data1:Array, data2:Array):Boolean
		{
			if (data1[pos] == data2[pos] && data1[pos + 1] == data2[pos + 1] && data1[pos + 2] == data2[pos + 2] && data1[pos + 3] == data2[pos + 3])
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public static function walkImageData(imgdata:*, walkFun:Function):void
		{
			var i:int, iLen:int;
			var j:int, jLen:int;
			iLen = imgdata.width;
			jLen = imgdata.height;
			var tarPos:int = 0;
			var data:Array = imgdata.data;
			for (i = 0; i < iLen; i++)
			{
				for (j = 0; j < jLen; j++)
				{
					walkFun(i, j, tarPos, data);
					tarPos += 4;
				}
			}
		}
		
		public static function getSpriteByCanvas(canvas:HTMLCanvas):Sprite
		{
			var rst:Sprite;
			rst = new Sprite();
			rst.graphics.drawTexture(new Texture(canvas), 0, 0, canvas.width, canvas.height);
			return rst;
		}
		
		public static function renderSpritesToCanvas(canvas:HTMLCanvas, sprites:Array, offx:Number = 0, offy:Number = 0, startIndex:int = 0):void
		{
			var i:int, len:int;
			len = sprites.length;
			for (i = startIndex; i < len; i++)
			{
				renderSpriteToCanvas(sprites[i], canvas, offx, offy);
			}
		}
		
		public static function clearCanvas(canvas:HTMLCanvas):void
		{
			var preWidth:Number;
			var preHeight:Number;
			preWidth = canvas.width;
			preHeight = canvas.height;
			canvas.size(preWidth + 1, preHeight);
			canvas.size(preWidth, preHeight);
		}
		
		public static function getImagePixels(x:int, y:int, width:int, data:Array,colorLen:int=4):Array
		{
			var pos:int;
			pos = (x * width + y)*colorLen;
			var i:int, len:int;
			var rst:Array;
			rst = [];
			len = colorLen;
			for (i = 0; i < len; i++)
			{
				rst.push(data[pos+i]);
			}
			return rst;
		}
	}

}