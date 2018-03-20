package laya.debug.tools {
	import laya.debug.tools.hook.FunHook;
	import laya.display.Node;
	import laya.maths.MathUtil;
	import laya.utils.Browser;
	
	/**
	 * ...
	 * @author ww
	 */
	public class GetSetProfile {
		
		private static var _inited:Boolean = false;
		private static var handlerO:Object;
		private static var noDisplayKeys:Object = {"conchModel": true};
		
		private static function removeNoDisplayKeys(arr:Array):void {
			var i:int;
			for (i = arr.length - 1; i >= 0; i--) {
				if (noDisplayKeys[arr[i]]) {
					arr.splice(i, 1);
				}
			}
		}
		private static const ALL:String = "ALL";
		private static var countDic:Object = {};
		private static function getClassCount(className:String):int
		{
			return countDic[className];
		}
		private static function addClassCount(className:String):void {
			if (!countDic[className]) {
				countDic[className] = 1;
			}
			else {
				countDic[className] = countDic[className] + 1;
			}
		}
		
		public static function init():void {
			if (_inited)
				return;
			_inited = true;
			var createFun:Function = function(sp:*):void {
				classCreated(sp);
			}
			FunHook.hook(Node, "call", null, createFun);
			handlerO = {};
			handlerO["get"] = function(target:*, key:*, receiver:*):* {
				trace("get", target, key, receiver);
				return __JS__("Reflect.get(target, key, receiver)");
			};
			handlerO["set"] = function(target:*, key:*, value:*, receiver:*):* {
				trace("set", target, key, value, receiver);
				return __JS__("Reflect.set(target, key, value, receiver)");
			}
		}
		private static var fromMe:Boolean = false;
		
		private static function classCreated(obj:Object, oClas:Class=null):void {
			if (fromMe)
				return;
			var className:String;
			className = ClassTool.getClassName(obj);
			addClassCount(className);
			addClassCount(ALL);
			IDTools.idObj(obj);
			var classDes:Array;
			classDes = hookClassDic[className];
			if (!classDes) {
				profileClass(obj["constructor"]);
				classDes = hookClassDic[className];
				if (!classDes)
					return;
			}
			
			hookObj2(obj, classDes);
		}
		
		private static function hookObj(obj:Object, keys:Array):void {
			
			var handler:Object = handlerO;
			__JS__("new Proxy(obj,handler)");
		}
		
		private static function hookObj2(obj:Object, keys:Array):void {
			
			var i:int, len:int;
			len = keys.length;
			for (i = 0; i < len; i++) {
				hookVar(obj, keys[i]);
			}
		}
		private static var hookClassDic:Object = {};
		
		private static function profileClass(clz:Class):void {
			var className:String;
			className = ClassTool.getClassName(clz);
			//Browser.window[className] = function() {
				//trace("aa")
			//};
			fromMe = true;
			var tO:Object = new clz();
			fromMe = false;
			var keys:Array;
			keys = ClassTool.getObjectDisplayAbleKeys(tO);
			keys = ObjectTools.getNoSameArr(keys);
			var i:int, len:int;
			len = keys.length;
			var tV:*;
			var key:String;
			for (i = len - 1; i >= 0; i--) {
				
				key = keys[i];
				tV = tO[key];
				if (tV is Function) {
					keys.splice(i, 1);
				}
			}
			
			len = keys.length;
			removeNoDisplayKeys(keys);
			hookClassDic[className] = keys;
		}
		
		private static function hookPrototype(tO:*, key:String):void {
			trace("hook:", key);
			try {
				hookVar(tO, key);
			}
			catch (e:*) {
				trace("fail", key);
			}
		
		}
		
		private static var infoDic:Object = {};
		
		private static function reportCall(obj:Object, name:String, type:String):void {
			IDTools.idObj(obj);
			var objID:int;
			objID = IDTools.getObjID(obj);
			var className:String;
			
			className = ClassTool.getClassName(obj);
			
			recordInfo(className, name, type, objID);
			recordInfo(ALL, name, type, objID);
		}
		
		private static function recordInfo(className:String, name:String, type:String, objID:int):void {
			var propCallsDic:Object;
			if (!infoDic[className]) {
				infoDic[className] = {};
			}
			propCallsDic = infoDic[className];
			var propCalls:Object;
			if (!propCallsDic[name]) {
				propCallsDic[name] = {};
			}
			propCalls = propCallsDic[name];
			var propCallO:Object;
			if (!propCalls[type]) {
				propCalls[type] = {};
			}
			propCallO = propCalls[type];
			if (!propCallO[objID]) {
				propCallO[objID] = 1;
				if (!propCallO["objCount"]) {
					propCallO["objCount"] = 1;
				}
				else {
					propCallO["objCount"] = propCallO["objCount"] + 1;
				}
			}
			else {
				propCallO[objID] = propCallO[objID] + 1;
			}
			if (!propCallO["count"]) {
				propCallO["count"] = 1;
			}
			else {
				propCallO["count"] = propCallO["count"] + 1;
			}
		}
		
		private static function showInfo():void {
			var rstO:Object;
			rstO = { };
			var rstO1:Object;
			rstO1 = { };
			var arr:Array;
			arr = [];
			var arr1:Array;
			arr1 = [];
			var className:String;
			var keyName:String;
			var type:String;
			for (className in infoDic)
			{
				var tClassO:Object;
				var tClassO1:Object;
				tClassO = infoDic[className];
				rstO[className]=tClassO1 = { };
				for (keyName in tClassO)
				{
					var tKeyO:Object;
					var tKeyO1:Object;
					tKeyO = tClassO[keyName];
					tClassO1[keyName]=tKeyO1 = { };
					for(type in tKeyO)
					{
						var tDataO:Object;
						var tDataO1:Object;
						tDataO = tKeyO[type];
						
						tDataO["rate"] = tDataO["objCount"] / getClassCount(className);
						tKeyO1[type] = tDataO["rate"];
						var tSKey:String;
						tSKey = className + "_" + keyName + "_" + type;
						rstO1[tSKey] = tDataO["rate"];
						if (className == ALL)
						{
							if (type == "get")
							{
								arr.push([tSKey,tDataO["rate"],tDataO["count"]]);
							}else
							{
								arr1.push([tSKey,tDataO["rate"],tDataO["count"]]);
							}
							
						}
					}
				}
			}
			trace(infoDic);
			trace(countDic);
			trace(rstO);
			trace(rstO1);
			trace("nodeCount:",getClassCount(ALL));

			trace("sort by rate");
			showStaticInfo(arr, arr1, "1");
			trace("sort by count");
			showStaticInfo(arr, arr1, "2");
		}
		
		private static function showStaticInfo(arr:Array, arr1:Array, sortKey:String):void
		{
			trace("get:");
			showStaticArray(arr,sortKey);
			trace("set:");
			showStaticArray(arr1,sortKey);
		}
		private static function showStaticArray(arr:Array,sortKey:String="1"):void
		{
			arr.sort(MathUtil.sortByKey(sortKey, true, true));
			var i:int, len:int;
			len = arr.length;
			var tArr:Array;
			for (i = 0; i < len; i++)
			{
				tArr = arr[i];
				trace(tArr[0],Math.floor(tArr[1]*100),tArr[2]);
			}
		}
		private static function hookVar(obj:Object, name:String, setHook:Array = null, getHook:Array = null):void {
			if (!setHook)
				setHook = [];
			if (!getHook)
				getHook = [];
			var preO:Object = obj;
			var preValue:*;
			var newKey:String = "___@" + newKey;
			var des:Object;
			des = ClassTool.getOwnPropertyDescriptor(obj, name);
			var ndes:Object = {};
			var mSet:Function = function(value:*):void {
				//trace("var hook set "+name+":",value);
				preValue = value;
			};
			
			var mGet:Function = function():* {
				//trace("var hook get"+name+":",preValue);
				return preValue;
			}
			
			var mSet1:Function = function(value:*):void {
				//trace("var hook set " + name + ":", value);
				var _t:* = __JS__("this");
				reportCall(_t, name, "set");
			};
			
			var mGet1:Function = function():* {
				var _t:* = __JS__("this");
				reportCall(_t, name, "get");
				return preValue;
			}
			
			getHook.push(mGet1);
			setHook.push(mSet1);
			
			while (!des && obj["__proto__"]) {
				
				obj = obj["__proto__"];
				des = ClassTool.getOwnPropertyDescriptor(obj, name);
				
			}
			if (des) {
				ndes.set = des.set ? des.set : mSet;
				ndes.get = des.get ? des.get : mGet;
				if (!des.get) {
					preValue = preO[name];
				}
				ndes.enumerable = des.enumerable;
				setHook.push(ndes.set);
				getHook.push(ndes.get);
				FunHook.hookFuns(ndes, "set", setHook);
				FunHook.hookFuns(ndes, "get", getHook, getHook.length - 1);
				//delete obj[name];
				ClassTool.defineProperty(preO, name, ndes);
			}
			if (!des) {
				//trace("get des fail add directly");
				ndes.set = mSet;
				ndes.get = mGet;
				preValue = preO[name];
				//ndes.enumerable=des.enumerable;
				setHook.push(ndes.set);
				getHook.push(ndes.get);
				FunHook.hookFuns(ndes, "set", setHook);
				FunHook.hookFuns(ndes, "get", getHook, getHook.length - 1);
				//delete obj[name];
				ClassTool.defineProperty(preO, name, ndes);
			}
		
		}
	}

}