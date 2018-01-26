package laya.ui {
	import laya.display.Animation;
	import laya.display.FrameAnimation;
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.events.Event;
	import laya.ui.Box;
	import laya.ui.Button;
	import laya.ui.CheckBox;
	import laya.ui.Component;
	import laya.ui.IItem;
	import laya.ui.IRender;
	import laya.ui.Image;
	import laya.ui.Label;
	import laya.ui.ProgressBar;
	import laya.ui.Radio;
	import laya.ui.RadioGroup;
	import laya.ui.Tab;
	import laya.utils.Browser;
	import laya.utils.ClassUtils;
	
	/**
	 * <code>View</code> 是一个视图类。
	 * @internal <p><code>View</code></p>
	 */
	public class View extends Box {
		
		/**存储UI配置数据(用于加载模式)。*/
		public static var uiMap:Object = {};
		/**UI类映射。*/
		public static var uiClassMap:Object = {"ViewStack": ViewStack, "LinkButton": Button, "TextArea": TextArea, "ColorPicker": ColorPicker, "Box": Box, "Button": Button, "CheckBox": CheckBox, "Clip": Clip, "ComboBox": ComboBox, "Component": Component, "HScrollBar": HScrollBar, "HSlider": HSlider, "Image": Image, "Label": Label, "List": List, "Panel": Panel, "ProgressBar": ProgressBar, "Radio": Radio, "RadioGroup": RadioGroup, "ScrollBar": ScrollBar, "Slider": Slider, "Tab": Tab, "TextInput": TextInput, "View": View, "VScrollBar": VScrollBar, "VSlider": VSlider, "Tree": Tree, "HBox": HBox, "VBox": VBox, "Sprite": Sprite, "Animation": Animation, "Text": Text, "FontClip": FontClip};
		/**@private UI视图类映射。*/
		protected static var viewClassMap:Object = {};
		/**@private */
		public var _idMap:Object;
		/**@private */
		public var _aniList:Array;
		
		/**@private */
		private static var _parseWatchData:RegExp = /\${(.*?)}/g;
		/**@private */
		private static var _parseKeyWord:RegExp = /[a-zA-Z_][a-zA-Z0-9_]*(?:(?:\.[a-zA-Z_][a-zA-Z0-9_]*)+)/g;
		/**@private */
		public var _watchMap:Object = { };
		/**@private */
		public static var _sheet:*;
		
		_regs()
		
		/**
		 * @private
		 * 向ClassUtils注册ui类
		 */
		private static function _regs():void {
			for (var key:String in uiClassMap) {
				ClassUtils.regClass(key, uiClassMap[key]);
			}			
		}
		
		/**
		 * @private
		 * 通过视图数据创建视图。
		 * @param uiView 视图数据信息。
		 */
		protected function createView(uiView:Object):void {
			if (uiView.animations && !this._idMap) this._idMap = {};
			createComp(uiView, this, this);
			
			if (uiView.animations) {
				var anilist:Array = [];
				var animations:Array = uiView.animations;
				var i:int, len:int = animations.length;
				var tAni:FrameAnimation;
				var tAniO:Object;
				for (i = 0; i < len; i++) {
					tAni = new FrameAnimation();
					tAniO = animations[i];
					tAni._setUp(_idMap, tAniO);
					//[IF-JS]this[tAniO.name] = tAni;
					tAni._setControlNode(this);
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
				_aniList = anilist;
			}
			
			if (_width > 0 && uiView.props.hitTestPrior == null && !mouseThrough) hitTestPrior = true;
		}
		
		/**
		 * @private
		 * 装载UI视图。用于加载模式。
		 * @param path UI资源地址。
		 */
		protected function loadUI(path:String):void {
			var uiView:Object = uiMap[path];
			uiView && createView(uiView);
		}
		
		/**
		 * 根据UI数据实例化组件。
		 * @param uiView UI数据。
		 * @param comp 组件本体，如果为空，会新创建一个。
		 * @param view 组件所在的视图实例，用来注册var全局变量，如果值为空则不注册。
		 * @return 一个 Component 对象。
		 */
		public static function createComp(uiView:Object, comp:* = null, view:View = null, dataMap:Array = null):* {
			comp = comp || getCompInstance(uiView);
			if (!comp) {
				console.warn("can not create:" + uiView.type);
				return null;
			}
			var child:Array = uiView.child;
			if (child) {
				var isList:Boolean = comp is List;
				for (var i:int = 0, n:int = child.length; i < n; i++) {
					var node:Object = child[i];
					if (comp.hasOwnProperty("itemRender") && (node.props.name == "render" || node.props.renderType === "render")) {
						IRender(comp).itemRender = node;
					} else if (node.type == "Graphic") {
						ClassUtils.addGraphicsToSprite(node, comp);
					} else if (ClassUtils.isDrawType(node.type)) {
						ClassUtils.addGraphicToSprite(node, comp, true);
					} else {	
						if (isList) {
							//收集数据绑定信息
							var arr:Array = [];
							var tChild:* = createComp(node, null, view, arr);
							if (arr.length) tChild["_$bindData"] = arr;
						}else {
							tChild = createComp(node, null, view, dataMap);
						}
						if (node.type == "Script") {
							if ("owner" in tChild) {
								tChild["owner"] = comp;
							} else if ("target" in tChild) {
								tChild["target"] = comp;
							}
						} else if (node.props.renderType == "mask" || node.props.name == "mask") {
							comp.mask = tChild;
						} else {
							tChild is Sprite && comp.addChild(tChild);
						}
					}
				}
			}
			
			var props:Object = uiView.props;
			for (var prop:String in props) {
				var value:String = props[prop];
				setCompValue(comp, prop, value, view, dataMap);
			}
			
			if (comp is IItem) IItem(comp).initItems();
			if (uiView.compId && view && view._idMap) {
				view._idMap[uiView.compId] = comp;
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
		private static function setCompValue(comp:*, prop:String, value:String, view:View = null, dataMap:Array = null):void {
			//属性赋值
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
			} else if (prop == "onClick") {
				var fun:Function = Browser.window.eval("(function(){" + value + "})");
				comp.on(Event.CLICK, view, fun);
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
		protected static function getCompInstance(json:Object):* {
			var runtime:String = json.props ? json.props.runtime : null;
			var compClass:Class;
			//[IF-SCRIPT]compClass = runtime ? (viewClassMap[runtime] || uiClassMap[runtime]|| Laya["__classmap"][runtime]) : uiClassMap[json.type];
			if (json.props && json.props.hasOwnProperty("renderType") && json.props["renderType"] == "instance") return compClass["instance"];
			return compClass ? new compClass() : null;
		}
		
		/**
		 * 注册组件类映射。
		 * <p>用于扩展组件及修改组件对应关系。</p>
		 * @param key 组件类的关键字。
		 * @param compClass 组件类对象。
		 */
		public static function regComponent(key:String, compClass:Class):void {
			uiClassMap[key] = compClass;
			ClassUtils.regClass(key, compClass);
		}
		
		/**
		 * 注册UI视图类的逻辑处理类。
		 * @internal 注册runtime解析。
		 * @param key UI视图类的关键字。
		 * @param compClass UI视图类对应的逻辑处理类。
		 */
		public static function regViewRuntime(key:String, compClass:Class):void {
			viewClassMap[key] = compClass;
		}
		
		/**
		 * <p>销毁此对象。</p>
		 * @param	destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			if (_aniList) _aniList.length = 0;
			_idMap = null;
			_aniList = null;
			_watchMap = null;
			super.destroy(destroyChild);
		}
		
		/**@private */
		public function changeData(key:String):void {
			var arr:Array = _watchMap[key];
			if (!arr) return;
			trace("change", key);
			for (var i:int = 0, n:int = arr.length; i < n; i++) {
				var watcher:DataWatcher = arr[i];
				watcher.exe(this);
			}
		}
	}
}
import laya.ui.Component;
import laya.ui.UIUtils;
import laya.ui.View;

class DataWatcher {
	public var comp:Component;
	public var prop:String;
	public var value:String;
	
	public function DataWatcher(comp:Component, prop:String, value:String):void {
		this.comp = comp;
		this.prop = prop;
		this.value = value;
	}
	
	public function exe(view:View):void {
		var fun:Function = UIUtils.getBindFun(value);
		this.comp[prop] = fun.call(this, view);
	}
}