package laya.debug.tools
{
	
	
	/**
	 * XML转Object类
	 * @author ww
	 * 
	 */
	public class XML2Object {
		// Address of the XML file to be parsed
		
		
		private static var _arrays:Array;
		
		public static function parse(node:*,isFirst:Boolean=true):Object {
			var obj:Object = {};
			if(isFirst)
				obj.Name=node.localName;
			var numOfChilds:int = node.children.length;
			var childs:Array=[];
			var children:Object={};
			obj.c = children;
			obj.cList = childs;
			for(var i:int = 0; i<numOfChilds; i++) {
				var childNode:* = node.children[i];
				var childNodeName:String = childNode.localName;
				var value:*;
				var numOfAttributes:int
				value = parse(childNode,true);
				childs.push(value);
				if(children[childNodeName]) {
					if(getTypeof(children[childNodeName]) == "array") {
						children[childNodeName].push(value);
					} else {
						children[childNodeName] = [children[childNodeName], value];
					}
				} else if(isArray(childNodeName)) {
					children[childNodeName] = [value];
				} else {
					children[childNodeName] = value;
				}
			}
			
			numOfAttributes=0;
			if(node.attributes)
			{
				numOfAttributes = node.attributes.length;		
				var prop:Object={};
				obj.p=prop;
				for(i=0; i<numOfAttributes; i++) {
					//				trace(node.attributes()[i]);
					prop[node.attributes[i].name.toString()] = String(node.attributes[i].nodeValue);
				}
			}
			
			if(numOfChilds == 0) {
				if(numOfAttributes == 0) {
					obj = "";
				} else {
					//					obj._content = "";
				}
			}
			return obj;
		}
		public static function getArr(v:*):Array
		{
			if(!v) return [];
			if(getTypeof(v)=="array") return v;
			return [v];
		}
		public static function get arrays():Array {
			if(!_arrays) {
				_arrays = [];
			}
			return _arrays;
		}
		public static function set arrays(a:Array):void {
			_arrays = a;
		}
		private static function isArray(nodeName:String):Boolean {
			var numOfArrays:int = _arrays ? _arrays.length : 0;
			for(var i:int=0; i<numOfArrays; i++) {
				if(nodeName == _arrays[i]) {
					return true;
				}
			}
			return false;
		}
		private static function getTypeof(o:*):String {
			if(typeof(o) == "object") {
				if(o.length == null) {
					return "object";
				} else if(typeof(o.length) == "number") {
					return "array";
				} else {
					return "object";
				}
			} else {
				return typeof(o);
			}
		}
		
		
		
	}
}