package laya.flash 
{
	/**
	 * ...
	 * @author laya
	 */
	public class FlashCondition 
	{
		private var _script:String = null;
		
		public var  condition:Function;
		
		public function FlashCondition(script:String) 
		{
			_script = script.replace( /\r/g, "" );
			var _this:FlashCondition = this;
			condition=function():Boolean
			{
				return _this._calue(this);
			}
		}
		
		private function clipWords():void
		{
			
		}
		
		private function _calue(obj:*):Boolean
		{	
			var tobj : Object = obj as Object;
			if ( tobj.hasOwnProperty( _script ) ) {
				return tobj[_script];
			}else
				return false;
		}
	}

}

/*
 * var a=new FlashCondition("COLOR || BLUE");
 * var b={COLOR:1};
 * var bool=a.condition(b);
*/