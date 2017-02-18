package laya.debug.tools.enginehook 
{
	import laya.utils.Browser;
	import laya.debug.tools.ClassTool;
	import laya.debug.tools.hook.FunHook;
	import laya.debug.tools.hook.VarHook;
	import laya.debug.tools.RunProfile;
	/**
	 * ...
	 * @author ww
	 */
	public class ClassCreateHook 
	{
		public static var I:ClassCreateHook = new ClassCreateHook();
		public function ClassCreateHook() 
		{
			
		}
		public static var isInited:Boolean = false;
		public function hookClass(clz:Class):void
		{
			if (isInited) return;
			isInited = true;
			var createFun:Function=function(sp:*):void
		    {
			    classCreated(sp,clz);
		    }
			FunHook.hook(clz, "call", createFun);
		}
		
	    public var createInfo:Object = { };
		public function classCreated(clz:Class,oClass:Class):void
		{
			var key:String;
			key = ClassTool.getNodeClassAndName(clz);
			var depth:int = 0;
			var tClz:Class;
			tClz = clz;
			while (tClz && tClz != oClass)
			{
				tClz = tClz.__super;
				depth++;
			} 
			
			if (!I.createInfo[key])
			{
				I.createInfo[key] = 0;
			}
			I.createInfo[key] = I.createInfo[key] + 1;
			//trace("create:",key,clz);
			//RunProfile.showClassCreate(key);
			RunProfile.run(key, depth+6);
			
			
		}
		public function getClassCreateInfo(clz:Class):Object
		{
			var key:String;
			key=ClassTool.getClassName(clz);
			return RunProfile.getRunInfo(key);
		}
	}

}