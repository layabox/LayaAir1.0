package laya.net {
	import laya.components.Prefab;
	import laya.events.Event;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.utils.Handler;
	import laya.utils.Utils;
	/**
	 * @private
	 * 场景资源加载器
	 */
	public class SceneLoader extends EventDispatcher {
		public static const LoadableExtensions:Object = {"scene": Loader.JSON, "scene3d": Loader.JSON, "ani": Loader.JSON, "ui": Loader.JSON, "prefab": Loader.PREFAB};
		public static const No3dLoadTypes:Object = {"png": true, "jpg": true, "txt": true};
		public var totalCount:int;
		private var _completeHandler:Handler;
		private var _toLoadList:Array;
		private var _isLoading:Boolean;
		private var _curUrl:String;
		
		public function SceneLoader() {
			_completeHandler = new Handler(this, onOneLoadComplete);
			reset();
		}
		
		public function reset():void {
			_toLoadList = [];
			_isLoading = false;
			totalCount = 0;
		}
		
		public function get leftCount():int {
			if (_isLoading) return _toLoadList.length + 1;
			return _toLoadList.length;
		}
		
		public function get loadedCount():int {
			return totalCount - leftCount;
		}
		
		public function load(url:*,is3D:Boolean=false,ifCheck:Boolean=true):void {
			if (url is Array) {
				var i:int, len:int;
				len = url.length;
				for (i = 0; i < len; i++) {
					_addToLoadList(url[i],is3D);
				}
			} else {
				_addToLoadList(url,is3D);
			}
			if(ifCheck)
			_checkNext();
		}
		
		private function _addToLoadList(url:String,is3D:Boolean=false):void {
			if (_toLoadList.indexOf(url) >= 0) return;
			if (Loader.getRes(url)) return;
			if (is3D)
			{
				_toLoadList.push({url:url});
			}else
			_toLoadList.push(url);
			totalCount++;
		}
		
		private function _checkNext():void {
			if (!_isLoading) {
				if (_toLoadList.length == 0) {
					event(Event.COMPLETE);
					return;
				}
				var tItem:Object;
				tItem = _toLoadList.pop();
				if (tItem is String)
				{
					loadOne(tItem);
				}else
				{
					loadOne(tItem.url, true);
				}
			}
		}
		
		private function loadOne(url:*,is3D:Boolean=false):void {
			_curUrl = url;
			var type:String = Utils.getFileExtension(_curUrl);
			if (is3D)
			{
				Laya.loader.create(url, _completeHandler);
			}else
			if (LoadableExtensions[type]) {
				Laya.loader.load(url, _completeHandler, null, LoadableExtensions[type]);
			} else if (url != AtlasInfoManager.getFileLoadPath(url) || No3dLoadTypes[type] || !LoaderManager.createMap[type]) {
				Laya.loader.load(url, _completeHandler);
			} else {
				Laya.loader.create(url, _completeHandler);
			}
		}
		
		private function onOneLoadComplete():void {
			_isLoading = false;
			if (!Loader.getRes(_curUrl)) {
				trace("Fail to load:", _curUrl);
			}
			var type:String = Utils.getFileExtension(_curUrl);
			if (LoadableExtensions[type]) {
				var dataO:Object;
				dataO = Loader.getRes(_curUrl);
				if (dataO&&(dataO is Prefab))
				{
					dataO = dataO.json;
				}
				if (dataO) {
					if (dataO.loadList)
					{
						load(dataO.loadList,false,false);
					}
					if (dataO.loadList3D)
					{
						load(dataO.loadList3D,true,false);
					}
				}
			}
			if (type == "sk")
			{
				load(_curUrl.replace(".sk",".png"),false,false);
			}
			event(Event.PROGRESS,getProgress());
			_checkNext();
		}
		
		public function getProgress():Number{
			return loadedCount / totalCount;
		}
	}

}