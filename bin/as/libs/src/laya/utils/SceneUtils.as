package laya.utils {
	import laya.Const;
	import laya.components.Component;
	import laya.display.FrameAnimation;
	import laya.display.Node;
	import laya.utils.ClassUtils;
	import laya.utils.WeakObject;
	
	/**
	 * @private 场景辅助类
	 */
	public class SceneUtils {
		/**@private */
		private static var _funMap:WeakObject = new WeakObject();
		/**@private */
		private static var _parseWatchData:RegExp = /\${(.*?)}/g;
		/**@private */
		private static var _parseKeyWord:RegExp = /[a-zA-Z_][a-zA-Z0-9_]*(?:(?:\.[a-zA-Z_][a-zA-Z0-9_]*)+)/g;
		/**@private */
		public static var _sheet:*;
		
		/**
		 * @private 根据字符串，返回函数表达式
		 */
		//TODO:coverage
		public static function getBindFun(value:String):Function {
			var fun:Function = _funMap.get(value);
			if (fun == null) {
				var temp:String = "\"" + value + "\"";
				temp = temp.replace(/^"\${|}"$/g, "").replace(/\${/g, "\"+").replace(/}/g, "+\"");
				var str:String = "(function(data){if(data==null)return;with(data){try{\nreturn " + temp + "\n}catch(e){}}})";
				fun = Laya._runScript(str);
				_funMap.set(value, fun);
			}
			return fun;
		}
		
		/**
		 * @private
		 * 通过视图数据创建视图。
		 * @param uiView 视图数据信息。
		 */
		//TODO:coverage
		public static function createByData(root:*, uiView:Object):* {
			var tInitTool:InitTool = InitTool.create();
			
			//递归创建节点
			root = createComp(uiView, root, root, null, tInitTool);
			root._setBit(Const.NOT_READY, true);
			if (root.hasOwnProperty("_idMap")) {
				root["_idMap"] = tInitTool._idMap;
			}
			
			//处理动画信息
			if (uiView.animations) {
				var anilist:Array = [];
				var animations:Array = uiView.animations;
				var i:int, len:int = animations.length;
				var tAni:FrameAnimation;
				var tAniO:Object;
				for (i = 0; i < len; i++) {
					tAni = new FrameAnimation();
					tAniO = animations[i];
					tAni._setUp(tInitTool._idMap, tAniO);
					root[tAniO.name] = tAni;
					tAni._setControlNode(root);
					switch (tAniO.action) {
					case 1: 
						tAni.play(0, false);
						break;
					case 2: 
						tAni.play(0, true);
						break;
					}
					anilist.push(tAni);
				}
				root._aniList = anilist;
			}
			
			//设置页面穿透
			if (root._$componentType === "Scene" && root._width > 0 && uiView.props.hitTestPrior == null && !root.mouseThrough)
				root.hitTestPrior = true;
			
			//设置组件
			tInitTool.beginLoad(root);
			return root;
		}
		
			
		public static function createInitTool():InitTool{
			return InitTool.create();
		}
			
		/**
		 * 根据UI数据实例化组件。
		 * @param uiView UI数据。
		 * @param comp 组件本体，如果为空，会新创建一个。
		 * @param view 组件所在的视图实例，用来注册var全局变量，如果值为空则不注册。
		 * @return 一个 Component 对象。
		 */
		public static function createComp(uiView:Object, comp:* = null, view:* = null, dataMap:Array = null, initTool:InitTool = null):* {
			if (uiView.type == "Scene3D"||uiView.type == "Sprite3D"){
				var outBatchSprits:Vector.<*> = new Vector.<*>();
				var scene3D:* =  Laya["Utils3D"]._createSceneByJsonForMaker(uiView, outBatchSprits, initTool);
				if (uiView.type == "Sprite3D")
					Laya["StaticBatchManager"].combine(scene3D, outBatchSprits);
				else
					Laya["StaticBatchManager"].combine(null, outBatchSprits);
				return scene3D;
			}
			
			comp = comp || getCompInstance(uiView);
			if (!comp) {
				if (uiView.props && uiView.props.runtime)
					console.warn("runtime not found:" + uiView.props.runtime);
				else
					console.warn("can not create:" + uiView.type);
				return null;
			}
			
			var child:Array = uiView.child;
			if (child) {
				var isList:Boolean = comp["_$componentType"] == "List";
				for (var i:int = 0, n:int = child.length; i < n; i++) {
					var node:Object = child[i];
					if (comp.hasOwnProperty("itemRender") && (node.props.name == "render" || node.props.renderType === "render")) {
						//如果list的itemRender
						comp["itemRender"] = node;
					} else if (node.type == "Graphic") {
						//绘制矢量图
						ClassUtils._addGraphicsToSprite(node, comp);
					} else if (ClassUtils._isDrawType(node.type)) {
						ClassUtils._addGraphicToSprite(node, comp, true);
					} else {
						if (isList) {
							//收集数据绑定信息
							var arr:Array = [];
							var tChild:* = createComp(node, null, view, arr, initTool);
							if (arr.length)
								tChild["_$bindData"] = arr;
						} else {
							tChild = createComp(node, null, view, dataMap, initTool);
						}
						
						//处理脚本
						if (node.type == "Script") {
							if (tChild is Component) {
								comp._addComponentInstance(tChild);
							} else {
								//兼容老版本
								if ("owner" in tChild) {
									tChild["owner"] = comp;
								} else if ("target" in tChild) {
									tChild["target"] = comp;
								}
							}
						} else if (node.props.renderType == "mask" || node.props.name == "mask") {
							comp.mask = tChild;
						} else {
							tChild is Node && comp.addChild(tChild);
						}
					}
				}
			}
			
			var props:Object = uiView.props;
			for (var prop:String in props) {
				var value:String = props[prop];
				if (value is String && (value.indexOf("@node:") >= 0 || value.indexOf("@Prefab:") >= 0)) {
					if (initTool) {
						initTool.addNodeRef(comp, prop, value);
					}
				} else
					setCompValue(comp, prop, value, view, dataMap);
			}
			
			if (comp._afterInited) {
				//if (initTool) {
				//initTool.addInitItem(comp);
				//} else {
				comp._afterInited();
					//}
			}
			
			if (uiView.compId && initTool && initTool._idMap) {
				initTool._idMap[uiView.compId] = comp;
			}
			
			return comp;
		}
		
		/**
		 * @private
		 * 设置组件的属性值。
		 * @param comp 组件实例。
		 * @param prop 属性名称。
		 * @param value 属性值。
		 * @param view 组件所在的视图实例，用来注册var全局变量，如果值为空则不注册。
		 */
		private static function setCompValue(comp:*, prop:String, value:String, view:* = null, dataMap:Array = null):void {
			//处理数据绑定
			if (value is String && value.indexOf("${") > -1) {
				_sheet || (_sheet = ClassUtils.getClass("laya.data.Table"));
				if (!_sheet) {
					console.warn("Can not find class Sheet");
					return;
				}
				//list的item处理
				if (dataMap) {
					dataMap.push(comp, prop, value);
				} else if (view) {
					if (value.indexOf("].") == -1) {
						//TODO
						value = value.replace(".", "[0].");
					}
					var watcher:DataWatcher = new DataWatcher(comp, prop, value);
					
					//执行第一次数据赋值
					watcher.exe(view);
					var one:Array, temp:Array;
					var str:String = value.replace(/\[.*?\]\./g, ".");
					while ((one = _parseWatchData.exec(str)) != null) {
						var key1:String = one[1];
						while ((temp = _parseKeyWord.exec(key1)) != null) {
							var key2:String = temp[0];
							var arr:Array = (view._watchMap[key2] || (view._watchMap[key2] = []));
							arr.push(watcher);
							//监听数据变化
							_sheet.I.notifer.on(key2, view, view.changeData, [key2]);
						}
						//TODO
						arr = (view._watchMap[key1] || (view._watchMap[key1] = []));
						arr.push(watcher);
						_sheet.I.notifer.on(key1, view, view.changeData, [key1]);
					}
						//trace(view._watchMap);
				}
				return;
			}
			
			if (prop === "var" && view) {
				view[value] = comp;
			} else {
				comp[prop] = (value === "true" ? true : (value === "false" ? false : value));
			}
		}
		
		/**
		 * @private
		 * 通过组建UI数据，获取组件实例。
		 * @param json UI数据。
		 * @return Component 对象。
		 */
		public static function getCompInstance(json:Object):* {
			if (json.type == "UIView") {
				if (json.props && json.props.pageData) {
					return createByData(null, json.props.pageData);
				}
			}
			var runtime:String = (json.props && json.props.runtime) || json.type;
			var compClass:Class = ClassUtils.getClass(runtime);
			if (!compClass) throw "Can not find class " + runtime;
			if (json.type === "Script" && compClass.prototype._doAwake) {
				var comp:* = Pool.createByClass(compClass);
				comp._destroyed = false;
				return comp;
			}
			if (json.props && json.props.hasOwnProperty("renderType") && json.props["renderType"] == "instance")
			{
				if (!compClass["instance"]) compClass["instance"] = new compClass();
				return compClass["instance"];
			}
				
			return new compClass();
		}
	}
}
import laya.Const;
import laya.components.Prefab;
import laya.display.Scene;
import laya.net.Loader;
import laya.utils.Handler;
import laya.utils.Pool;
import laya.utils.SceneUtils;

/**
 * @private 场景辅助类
 */
class DataWatcher {
	public var comp:*;
	public var prop:String;
	public var value:String;
	
	//TODO:coverage
	public function DataWatcher(comp:*, prop:String, value:String):void {
		this.comp = comp;
		this.prop = prop;
		this.value = value;
	}
	
	public function exe(view:*):void {
		var fun:Function = SceneUtils.getBindFun(value);
		this.comp[prop] = fun.call(this, view);
	}
}

/**
 * @private 场景辅助类
 */
class InitTool {
	/**@private */
	private var _nodeRefList:Array;
	/**@private */
	private var _initList:Array;
	private var _loadList:Array;
	/**@private */
	public var _idMap:Array;
	public var _scene:Scene;
	
	//TODO:coverage
	public function reset():void {
		_nodeRefList = null;
		_initList = null;
		_idMap = null;
		_loadList = null;
		_scene = null;
	}
	
	//TODO:coverage
	public function recover():void {
		reset();
		Pool.recover("InitTool", this);
	}
	
	public static function create():InitTool {
		var tool:InitTool = Pool.getItemByClass("InitTool", InitTool);
		tool._idMap = [];
		return tool;
	}
	
	//TODO:coverage
	public function addLoadRes(url:String, type:String = null):void {
		if (!_loadList) _loadList = [];
		if (!type) {
			_loadList.push(url);
		} else {
			_loadList.push({url: url, type: type});
		}
	}
	
	/**@private */
	//TODO:coverage
	public function addNodeRef(node:*, prop:String, referStr:String):void {
		if (!_nodeRefList) _nodeRefList = [];
		_nodeRefList.push([node, prop, referStr]);
		if (referStr.indexOf("@Prefab:") >= 0) {
			addLoadRes(referStr.replace("@Prefab:", ""), Loader.PREFAB);
		}
	}
	
	/**@private */
	//TODO:coverage
	public function setNodeRef():void {
		if (!_nodeRefList) return;
		if (!_idMap) {
			_nodeRefList = null;
			return;
		}
		var i:int, len:int;
		len = _nodeRefList.length;
		var tRefInfo:Array;
		for (i = 0; i < len; i++) {
			tRefInfo = _nodeRefList[i];
			tRefInfo[0][tRefInfo[1]] = getReferData(tRefInfo[2]);
		}
		_nodeRefList = null;
	}
	
	/**@private */
	//TODO:coverage
	public function getReferData(referStr:String):* {
		if (referStr.indexOf("@Prefab:") >= 0) {
			var prefab:Prefab;
			prefab = Loader.getRes(referStr.replace("@Prefab:", ""));
			return prefab;
		} else if (referStr.indexOf("@arr:") >= 0) {
			referStr = referStr.replace("@arr:", "");
			var list:Array;
			list = referStr.split(",");
			var i:int, len:int;
			var tStr:String;
			len = list.length;
			for (i = 0; i < len; i++) {
				tStr = list[i];
				if (tStr) {
					list[i] = _idMap[tStr.replace("@node:", "")];
				} else {
					list[i] = null;
				}
			}
			return list;
		} else {
			return _idMap[referStr.replace("@node:", "")];
		}
	}
	
	/**@private */
	//TODO:coverage
	public function addInitItem(item:*):void {
		if (!_initList) _initList = [];
		_initList.push(item);
	}
	
	/**@private */
	//TODO:coverage
	public function doInits():void {
		if (!_initList) return;
		_initList = null;
	}
	
	/**@private */
	//TODO:coverage
	public function finish():void {
		this.setNodeRef();
		this.doInits();
		_scene._setBit(Const.NOT_READY, false);
		if (_scene.parent && _scene.parent.activeInHierarchy && _scene.active) _scene._processActive();
		_scene.event("onViewCreated");
		this.recover();
	}
	
	/**@private */
	//TODO:coverage
	public function beginLoad(scene:Scene):void {
		this._scene = scene;
		if (!_loadList || _loadList.length < 1) {
			finish();
		} else {
			Laya.loader.load(_loadList, Handler.create(this, finish));
		}
	}
}