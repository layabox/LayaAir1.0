///////////////////////////////////////////////////////////
//  BlurFilter.as
//  Macromedia ActionScript Implementation of the Class BlurFilter
//  Created on:      2015-9-18 下午7:10:26
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.filters
{
	import laya.display.Sprite;
	import laya.maths.Matrix;
	import laya.maths.Rectangle;
	import laya.renders.RenderContext;
	import laya.resource.Texture;
	import laya.system.System;
	import laya.utils.Browser;
	import laya.utils.Color;
	
	/**
	 *  发光滤镜
	 * @author ww
	 * @version 1.0
	 * @created  2015-9-18 下午7:10:26
	 */
	public class GlowFilter extends Filter
	{
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var _color:Color;		
		public var _blurX:Boolean=true;
		
		/**
		 *顺序R,G,B,A,blurWidth,offX,offY;
		 */
		public var elements:Float32Array=new Float32Array(9);
		
		/**
		 * 创建发光滤镜 
		 * @param color 颜色值 “#ffffff”格式
		 * @param blur 宽度
		 * @param offX x偏移
		 * @param offY y偏移
		 */
		public function GlowFilter(color:String,blur:Number=4,offX:Number=6,offY:Number=6)
		{
			//TODO:待优化
			WebGLFilter.enable();
//			this.type2=1;
			this.color=color;
			this.blur=blur;
			this.offX=offX;
			this.offY=offY;
			_action=System.createFilterAction(GLOW);
			_action.data=this;
		}
		
		
		override public function get type():int{return 0}

		public function get offY():Number
		{
			return elements[6];
		}

		public function set offY(value:Number):void
		{
			elements[6] = value;
		}


		public function get offX():Number
		{
			return elements[5];
		}

		public function set offX(value:Number):void
		{
			elements[5] = value;
		}

		public function get color():String
		{
			return _color.strColor;
		}

		public function set color(value:String):void
		{
			_color = Color.create(value);
		}

		public function get blur():Number
		{
			return elements[4];
		}

		public function set blur(value:Number):void
		{
			elements[4] = value;
		}

	}
}