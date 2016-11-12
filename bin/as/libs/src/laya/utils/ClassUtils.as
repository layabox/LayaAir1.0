package laya.utils {
	import laya.display.Graphics;
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.maths.Matrix;
	import laya.net.Loader;
	/**
	 * <code>ClassUtils</code> 是一个类工具类。
	 */
	public class ClassUtils {
		/**
		 * @private
		 */
		private static const DrawTypeDic:Object = {"Rect": ["drawRect", [["x", 0], ["y", 0], ["width", 0], ["height", 0], ["fillColor", null], ["lineColor", null], ["lineWidth", 1]]], "Circle": ["drawCircle", [["x", 0], ["y", 0], ["radius", 0], ["fillColor", null], ["lineColor", null], ["lineWidth", 1]]], "Pie": ["drawPie", [["x", 0], ["y", 0], ["radius", 0], ["startAngle", 0], ["endAngle", 0], ["fillColor", null], ["lineColor", null], ["lineWidth", 1]]], "Image": ["drawTexture", [["x", 0], ["y", 0], ["width", 0], ["height", 0]]], "Texture": ["drawTexture", [["skin", null], ["x", 0], ["y", 0], ["width", 0], ["height", 0]], 1, "_adptTextureData"], "FillTexture": ["fillTexture", [["skin", null], ["x", 0], ["y", 0], ["width", 0], ["height", 0], ["repeat", null]], 1, "_adptTextureData"], "FillText": ["fillText", [["text", ""], ["x", 0], ["y", 0], ["font", null], ["color", null], ["textAlign", null]], 1], "Line": ["drawLine", [["x", 0], ["y", 0], ["toX", 0], ["toY", 0], ["lineColor", null], ["lineWidth", 0]], 0, "_adptLineData"], "Lines": ["drawLines", [["x", 0], ["y", 0], ["points", ""], ["lineColor", null], ["lineWidth", 0]], 0, "_adptLinesData"], "Curves": ["drawCurves", [["x", 0], ["y", 0], ["points", ""], ["lineColor", null], ["lineWidth", 0]], 0, "_adptLinesData"], "Poly": ["drawPoly", [["x", 0], ["y", 0], ["points", ""], ["fillColor", null], ["lineColor", null], ["lineWidth", 1]], 0, "_adptLinesData"]};
		/**
		 * @private
		 */
		private static var _temParam:Array = [];
		
		public static var _classMap:Object = /*[STATIC SAFE]*/ {'Sprite': 'laya.display.Sprite', 'Text': 'laya.display.Text', 'Animation': 'laya.display.Animation', 'Skeleton': 'laya.ani.bone.Skeleton', 'Particle2D': 'laya.particle.Particle2D', 'div': 'laya.html.dom.HTMLDivElement', 'img': 'laya.html.dom.HTMLImageElement', 'span': 'laya.html.dom.HTMLElement', 'br': 'laya.html.dom.HTMLBrElement', 'style': 'laya.html.dom.HTMLStyleElement', 'font': 'laya.html.dom.HTMLElement', 'a': 'laya.html.dom.HTMLElement', '#text': 'laya.html.dom.HTMLElement'}
		
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
		public static var getClass:Function = function(className:String):* {
			var classObject:* = _classMap[className] || className;
			if (classObject is String)
				return Laya["__classmap"][classObject];
			return classObject;
		}
		
		/**
		 * 根据名称创建 Class 实例。
		 * @param	className 类名。
		 * @return	返回类的实例。
		 */
		public static function getInstance(className:String):* {
			var compClass:* = getClass(className);
			if (compClass)
				return new compClass();
			else
				trace("[error] Undefined class:", className);
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
		public static function createByJson(json:*, node:* = null, root:Node = null, customHandler:Handler = null, instanceHandler:Handler = null):* {
			if (json is String)
				json = JSON.parse(json);
			var props:Object = json.props;
			
			if (!node) {
				node = instanceHandler ? instanceHandler.runWith(json.instanceParams) : getInstance(props.runtime || json.type);
				if (!node)
					return null;
			}
			
			var child:Array = json.child;
			if (child) {
				for (var i:int = 0, n:int = child.length; i < n; i++) {
					var data:Object = child[i];
					if ((data.props.name === "render" || data.props.renderType === "render") && node["_$set_itemRender"])
						node.itemRender = data;
					else {
						if (data.type == "Graphic") {
							addGraphicsToSprite(data, node);
						} else if (isDrawType(data.type)) {
							addGraphicToSprite(data, node, true);
						} else {
							var tChild:* = createByJson(data, null, root, customHandler, instanceHandler)
							if (data.type == "Script") {
								tChild["owner"] = node;
							} else if (data.props.renderType == "mask") {
								node.mask = tChild;
							} else {
								node.addChild(tChild);
							}
						}
					}
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
			
			if (node["created"])
				node.created();
			
			return node;
		}
		
		/**
		 * 将graphic对象添加到Sprite上
		 * @param graphicO graphic对象描述
		 * @param sprite
		 *
		 */
		public static function addGraphicsToSprite(graphicO:Object, sprite:Sprite):void {
			var graphics:Array;
			graphics = graphicO.child;
			if (!graphics || graphics.length < 1)
				return;
			var g:Graphics;
			g = _getGraphicsFromSprite(graphicO, sprite);
			var ox:int = 0;
			var oy:int = 0;
			if (graphicO.props) {
				ox = _getObjVar(graphicO.props, "x", 0);
				oy = _getObjVar(graphicO.props, "y", 0);
			}
			if (ox != 0 && oy != 0) {
				g.translate(ox, oy);
			}
			var i:int, len:int;
			len = graphics.length;
			for (i = 0; i < len; i++) {
				_addGraphicToGraphics(graphics[i], g);
			}
			if (ox != 0 && oy != 0) {
				g.translate(-ox, -oy);
			}
		}
		
		/**
		 * 将graphic绘图指令添加到sprite上
		 * @param graphicO 绘图指令描述
		 * @param sprite
		 *
		 */
		public static function addGraphicToSprite(graphicO:Object, sprite:Sprite, isChild:Boolean = false):void {
			
			var g:Graphics;
			g = isChild ? _getGraphicsFromSprite(graphicO, sprite) : sprite.graphics;
			_addGraphicToGraphics(graphicO, g);
		
		}
		
		/**
		 * @private
		 */
		private static function _getGraphicsFromSprite(dataO:Object, sprite:Sprite):Graphics {
			var g:Graphics;
			if (!dataO || !dataO.props)
				return sprite.graphics;
			var propsName:String;
			propsName = dataO.props.renderType;
			switch (propsName) {
			case "hit": 
			case "unHit":
				
				var hitArea:HitArea;
				if (!sprite.hitArea) {
					sprite.hitArea = new HitArea();
				}
				hitArea = sprite.hitArea;
				if (!hitArea[propsName]) {
					hitArea[propsName] = new Graphics();
				}
				g = hitArea[propsName];
				break;
			default:
				
			}
			if (!g)
				g = sprite.graphics;
			return g;
		}
		
		/**
		 * @private
		 */
		private static function _getTransformData(propsO:Object):Matrix {
			var m:Matrix;
			
			if (propsO.hasOwnProperty("pivotX") || propsO.hasOwnProperty("pivotY")) {
				m = m || new Matrix();
				m.translate(-_getObjVar(propsO, "pivotX", 0), -_getObjVar(propsO, "pivotY", 0));
			}
			
			var sx:Number = _getObjVar(propsO, "scaleX", 1), sy:Number = _getObjVar(propsO, "scaleY", 1);
			var rotate:Number = _getObjVar(propsO, "rotation", 0);
			var skewX:Number = _getObjVar(propsO, "skewX", 0);
			var skewY:Number = _getObjVar(propsO, "skewY", 0);
			
			if (sx != 1 || sy != 1 || rotate != 0) {
				m = m || new Matrix();
				m.scale(sx, sy);
				m.rotate(rotate * 0.0174532922222222);
			}
			
			return m;
		}
		
		/**
		 * @private
		 */
		private static function _addGraphicToGraphics(graphicO:Object, graphic:Graphics):void {
			
			var propsO:Object;
			propsO = graphicO.props;
			if (!propsO)
				return;
			var drawConfig:Object;
			drawConfig = DrawTypeDic[graphicO.type];
			if (!drawConfig)
				return;
			
			var g:Graphics;
			g = graphic;
			var m:Matrix;
			
			var params:* = _getParams(propsO, drawConfig[1], drawConfig[2], drawConfig[3]);
			m = _tM;
			if (m||_alpha!=1) {
				g.save();
				if(m)
				g.transform(m);
				if (_alpha != 1)
				g.alpha(_alpha);
			}
			g[drawConfig[0]].apply(g, params);
			if (m||_alpha!=1) {
				g.restore();
			}
		
		}
		
		/**
		 * @private
		 */
		private static function _adptLineData(params:Array):Array {
			params[2] = parseFloat(params[0]) + parseFloat(params[2]);
			params[3] = parseFloat(params[1]) + parseFloat(params[3]);
			return params;
		}
		
		/**
		 * @private
		 */
		private static function _adptTextureData(params:Array):Array {
			params[0] = Loader.getRes(params[0]);
			return params;
		}
		
		/**
		 * @private
		 */
		private static function _adptLinesData(params:Array):Array {
			params[2] = _getPointListByStr(params[2]);
			return params;
		}
		
		/**
		 * @private
		 */
		public static function isDrawType(type:String):Boolean {
			if (type == "Image")
				return false;
			return DrawTypeDic.hasOwnProperty(type);
		}
		
		/**
		 * @private
		 */
		private static var _tM:Matrix;
		private static var _alpha:Number;
		/**
		 * @private
		 */
		private static function _getParams(obj:Object, params:Array, xPos:int = 0, adptFun:String = null):Array {
			var rst:*;//Array
			rst = _temParam;
			rst.length = params.length;
			var i:int, len:int;
			len = params.length;
			for (i = 0; i < len; i++) {
				
				rst[i] = _getObjVar(obj, params[i][0], params[i][1]);
			}
			_alpha = _getObjVar(obj, "alpha", 1);
			var m:Matrix;
			m = _getTransformData(obj);
			if (m) {
				if (!xPos) xPos = 0;
				
				m.translate(rst[xPos], rst[xPos + 1]);
				rst[xPos] = rst[xPos + 1] = 0;
				_tM = m;
				
			} else {
				_tM = null;
			}
			if (adptFun && ClassUtils[adptFun]) {
				rst = ClassUtils[adptFun](rst);
			}
			return rst;
		}
		
		/**
		 * @private
		 */
		public static function _getPointListByStr(str:String):Array {
			var pointArr:Array;
			pointArr = str.split(",");
			var i:int, len:int;
			len = pointArr.length;
			for (i = 0; i < len; i++) {
				pointArr[i] = parseFloat(pointArr[i]);
			}
			return pointArr;
		}
		
		/**
		 * @private
		 */
		private static function _getObjVar(obj:Object, key:String, noValue:*):* {
			if (obj.hasOwnProperty(key)) {
				return obj[key];
			}
			return noValue;
		}
	}
}