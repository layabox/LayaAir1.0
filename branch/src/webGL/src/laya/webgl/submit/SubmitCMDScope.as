package laya.webgl.submit {
	public class SubmitCMDScope
	{
		private var variables:*={};
		
		private static var POOL:Array=[];
		public function SubmitCMDScope()
		{
		}
		
		public function getValue(name:String):*
		{
			return variables[name];
		}
		
		public function addValue(name:String,value:*):*
		{
			return variables[name]=value;
		}
		
		public function setValue(name:String,value:*):*
		{
			if(variables.hasOwnProperty(name))
			{
				return variables[name]=value;
			}
			return null;
		}
		
		public function clear():void
		{
			for(var key:String in variables)
			{
				delete variables[key];
			}
		}
		
		public function recycle():void
		{
			clear();
			POOL.push(this);
		}
		
		public static function create():SubmitCMDScope
		{
			var scope:SubmitCMDScope=POOL.pop();
			scope||(scope=new SubmitCMDScope());
			return scope;
		}
		
	}
}