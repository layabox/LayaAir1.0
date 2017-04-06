///////////////////////////////////////////////////////////
//  ValueChanger.as
//  Macromedia ActionScript Implementation of the Class ValueChanger
//  Created on:      2015-12-30 下午5:12:53
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	import laya.display.Sprite;
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-12-30 下午5:12:53
	 */
	public class ValueChanger
	{
		public function ValueChanger()
		{
		}
		public var target:Object;
		public var key:String;
		
		private var _tValue:Number;
		public function get value():Number
		{
			if(target)
			{
				_tValue=target[key];
			}
			
			return _tValue;
		}
		public function set value(nValue:Number):void
		{
			_tValue=nValue;
			if(target)
			{
				target[key]=nValue;
			}
			
		}
		public function get dValue():Number
		{
			return value-preValue;
		}
		public function get scaleValue():Number
		{
			return value/preValue;
		}
		public var preValue:Number=0;
		public function record():void
		{
			preValue=value;
		}
		public function showValueByAdd(addValue:Number):void
		{
			value=preValue+addValue;
		}
		public function showValueByScale(scale:Number):void
		{
			value = preValue * scale;
		}
		public function recover():void
		{
			value=preValue;
		}
		public function dispose():void
		{
			target=null;
		}
		
		public static function create(target:Object,key:String):ValueChanger
		{
			var rst:ValueChanger;
			rst=new ValueChanger();
			rst.target=target;
			rst.key=key;
			return rst;
		}
	}
}