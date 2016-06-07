package laya.utils {
	import laya.display.Node;
	
	/**
	 * <code>ClassUtils</code> 是一个类工具类。
	 */
	public class ClassUtils {
		
		private static var _classMap:Object =/*[STATIC SAFE]*/ {'Sprite': 'laya.display.Sprite', 'Text': 'laya.display.Text', 'div': 'laya.html.dom.HTMLDivElement', 'img': 'laya.html.dom.HTMLImageElement', 'span': 'laya.html.dom.HTMLElement', 'br': 'laya.html.dom.HTMLBrElement', 'style': 'laya.html.dom.HTMLStyleElement', 'font': 'laya.html.dom.HTMLElement', 'a': 'laya.html.dom.HTMLElement', '#text': 'laya.html.dom.HTMLElement'}
		
		/**
		 * 注册 Class 映射。
		 * @param	className 映射的名字，或者类名简写。
		 * @param	classDef 类的全名或者类的引用，全名比如:"laya.display.Sprite"。
		 */
		public static function regClass(className:String, classDef:*):void {
			_classMap[className] = classDef;
		}
		
		/**
		 * 返回注册 Class 映射。
		 * @param	className 映射的名字。
		 */
		public static function getRegClass(className:String):* {
			return _classMap[className];
		}
		
		/**
		 * 根据名字返回类对象。
		 * @param	className 类名。
		 * @return
		 */
		public static function getClass(className:String):* {
			var classObject:* = _classMap[className] || className;
			if (classObject is String) return Laya["__classmap"][classObject];
			return classObject;
		}
		
		/**
		 * 根据名称创建 Class 实例。
		 * @param	className 类名。
		 * @return	返回类的实例。
		 */
		public static function getInstance(className:String):* {
			var compClass:* = getClass(className);
			if (compClass) return new compClass();
			else trace("[error] Undefined class:", className);
			return null;
		}
		
		/**
		 * 根据指定的 json 数据创建节点对象。
		 * 比如:
		 * {
		 * 	"type":"Sprite",
		 * 	"props":{
		 * 		"x":100,
		 * 		"y":50,
		 * 		"name":"item1",
		 * 		"scale":[2,2]
		 * 	},
		 * 	"customProps":{
		 * 		"x":100,
		 * 		"y":50,
		 * 		"name":"item1",
		 * 		"scale":[2,2]
		 * 	},
		 * 	"child":[
		 * 		{
		 * 			"type":"Text",
		 * 			"props":{
		 * 				"text":"this is a test",
		 * 				"var":"label",
		 * 				"rumtime":""
		 * 			}
		 * 		}
		 * 	]
		 * }
		 * @param	json json字符串或者Object对象。
		 * @param	node node节点，如果为空，则新创建一个。
		 * @param	root 根节点，用来设置var定义。
		 * @return	生成的节点。
		 */
		public static function createByJson(json:*, node:* = null, root:Node = null, customHandler:Handler = null):* {
			if (json is String) json = JSON.parse(json);
			var props:Object = json.props;
			
			if (!node) {
				node = getInstance(props.runtime || json.type);
				if (!node) return null;
			}
			
			var child:Array = json.child;
			if (child) {
				for (var i:int = 0, n:int = child.length; i < n; i++) {
					var data:Object = child[i];
					if (data.props.name === "render" && node["_$set_itemRender"]) node.itemRender = data;
					else node.addChild(createByJson(data, null, root, customHandler));
				}
			}
			
			if (props) {
				for (var prop:String in props) {
					var value:* = props[prop];
					if (prop === "var" && root) {
						root[value] = node;
					} else if (value is Array && node[prop] is Function) {
						node[prop].apply(node, value);
					} else {
						node[prop] = value;
					}
				}
			}
			
			var customProps:Object = json.customProps;
			if (customHandler && customProps) {
				for (prop in customProps) {
					value = customProps[prop];
					customHandler.runWith([node, prop, value]);
				}
			}
			
			if (node["created"]) node.created();
			
			return node;
		}
	}
}