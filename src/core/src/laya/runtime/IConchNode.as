package laya.runtime {
	import laya.display.Graphics;
	import laya.display.Graphics;
	import laya.resource.Context;
	/**
	 * @private
	 */
	public interface IConchNode {
		/**@private */
		function setRootNode():void;
		/**@private */
		function addChildAt(c:IConchNode, i:Number):void;
		/**@private */
		function removeChild(c:IConchNode):void;
		/**@private */
		function size(w:Number, h:Number):void;
		/**@private */
		function pos(x:Number, y:Number):void;
		/**@private */
		function pivot(x:Number, y:Number):void;
		/**@private */
		function scale(x:Number, y:Number):void;
		/**@private */
		function skew(x:Number, y:Number):void;
		/**@private */
		function rotate(r:Number):void;
		/**@private */
		function bgColor(bg:String):void;
		/**@private */
		function font(str:String):void;
		/**@private */
		function text(d:*):void;
		/**@private */
		function transform(a:Number, b:Number, c:Number, d:Number, tx:Number, ty:Number):void;
		/*function setTransform(a:Number,b:Number,c:Number,d:Number,tx:Number,ty:Number):void*/
		/**@private */
		function alpha(a:Number):void;
		/**@private */
		function setFilterMatrix(mat:Float32Array, alpha:Float32Array):void;
		/**@private */
		function visible(b:Boolean):void;
		/**@private */
		function blendMode(v:String):void;
		/**@private */
		function scrollRect(x:Number, y:Number, w:Number, h:Number):void;
		/**@private */
		function mask(node:IConchNode):void;
		/**@private */
		function graphics(g:Graphics):void;
		/**@private */
		function custom(context:Context):void;
		/**@private */
		function removeType(type:Number):void
		/**@private */
		function cacheAs(type:Number):void;
		/**@private */
		function border(color:String):void;
		/**@private */
		function optimizeScrollRect(b:Boolean):void;
		/**@private */
		function blurFilter(strength:Number):void;
		/**@private */
		function glowFilter(color:String, blur:Number, offX:Number, offY:Number):void;
		/**@private*/
		function repaint():void;
	}

}