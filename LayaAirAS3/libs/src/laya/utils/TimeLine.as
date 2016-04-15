package laya.utils {
	
	/**
	 * 根据时间去创建一个合理的动画效果
	 * @author ...
	 */
	public class TimeLine {
		
		private var _labelDic:Object;
		private var _tweenDic:Object = {};
		private var _tweenDataList:Array = [];
		private var _endTweenDataList:Array;//以结束时间进行排序
		private var _currTime:Number = 0;
		private var _lastTime:Number = 0;
		private var _startTime:Number = 0;
		/**当前动画数据播放到第几个了*/
		private var _index:int = 0;
		/**为TWEEN创建属于自己的唯一标识，方便管理*/
		private var _gidIndex:int = 0;
		/**保留所有对象第一次注册动画时的状态（根据时间跳转时，需要把对象的回复，再计算接下来的状态）*/
		private var _firstTweenDic:Object = {};
		/**是否需要排序*/
		private var _startSortKey:Boolean = false;
		private var _endSortKey:Boolean = false;
		/**是否循环*/
		private var _loopKey:Boolean = false;
		/**缩放动画播放的速度*/
		public var scale:Number = 1;
		
		/**
		 * 控制一个对象，从当前点移动到目标点
		 * @param	target		要控制的对象
		 * @param	props		要控制对象的属性
		 * @param	duration	对象TWEEN的时间
		 * @param	offset		相对于上一个对象，偏移多长时间（单位：毫秒）
		 */
		public function to(target:*, props:Object, duration:Number, ease:Function = null, offset:Number = 0):void {
			_create(target, props, duration, ease, offset, true);
		}
		
		/**
		 * 从props属性，缓动到当前状态
		 * @param	target		target 目标对象(即将更改属性值的对象)
		 * @param	props		要控制对象的属性
		 * @param	duration	对象TWEEN的时间
		 * @param	offset		相对于上一个对象，偏移多长时间（单位：毫秒）
		 */
		public function from(target:*, props:Object, duration:Number, ease:Function = null, offset:Number = 0):void {
			_create(target, props, duration, ease, offset, false);
		}
		
		private function _create(target:*, props:Object, duration:Number, ease:Function, offset:Number, isTo:Boolean):void {
			var gid:int = (target.$_GID || (target.$_GID = Utils.getGID()));
			//把对象的初始属性保留下来，方便跳转时，回复到初始状态
			if (_firstTweenDic[gid] == null) {
				var tSrcData:Object = {};
				tSrcData.diyTarget = target;
				for (var p:* in target) {
					tSrcData[p] = target[p];
				}
				_firstTweenDic[gid] = tSrcData;
			}
			var tTweenData:tweenData = new tweenData();
			tTweenData.isTo = isTo;
			tTweenData.type = 0;
			tTweenData.target = target;
			tTweenData.duration = duration;
			tTweenData.data = props;
			tTweenData.startTime = _startTime + offset;
			tTweenData.endTime = tTweenData.startTime + tTweenData.duration;
			tTweenData.ease = ease;
			_startTime = Math.max(tTweenData.endTime, _startTime);
			_tweenDataList.push(tTweenData);
			_startSortKey = true;
			_endSortKey = true;
		}
		
		/**
		 * 在时间队列中加入一个标签
		 * @param	label	标签名称
		 * @param	offset	标签相对于上个动画的偏移时间(单位：毫秒)
		 */
		public function add(label:String, offset:Number):void {
			var tTweenData:tweenData = new tweenData();
			tTweenData.type = 1;
			tTweenData.startTime = _startTime + offset;
			_labelDic || (_labelDic = {});
			_labelDic[label] = tTweenData;
		}
		
		/**
		 * 动画从整个动画的某一时间开始
		 * @param	time(单位：毫秒)
		 */
		public function gotoTime(time:Number):void {
			if (_tweenDataList == null || _tweenDataList.length == 0) return;
			var tTween:Tween;
			var tObject:Object;
			for (var p:* in _firstTweenDic) {
				tObject = _firstTweenDic[p];
				if (tObject) {
					for (var tDataP:* in tObject) {
						tObject.diyTarget[tDataP] = tObject[tDataP];
					}
				}
			}
			for (p in _tweenDic) {
				tTween = _tweenDic[p];
				tTween.clear();
				delete _tweenDic[p];
			}
			_index = 0;
			_gidIndex = 0;
			_currTime = time;
			_lastTime = Browser.now();
			var tTweenDataCopyList:Array;
			if (_endTweenDataList == null || _endSortKey) {
				_endSortKey = false;
				_endTweenDataList = tTweenDataCopyList = _tweenDataList.concat();
				//对数据排序
				function Compare(paraA:Object, paraB:Object):int {
					if (paraA.endTime > paraB.endTime) {
						return 1;
					} else if (paraA.endTime < paraB.endTime) {
						return -1;
					} else {
						return 0;
					}
				}
				tTweenDataCopyList.sort(Compare);
			} else {
				tTweenDataCopyList = _endTweenDataList
			}
			
			var tTweenData:tweenData;
			//叠加已经经过的关键帧数据
			for (var i:int = 0, n:int = tTweenDataCopyList.length; i < n; i++) {
				tTweenData = tTweenDataCopyList[i];
				if (tTweenData.type == 0) {
					if (time >= tTweenData.endTime) {
						_index = Math.max(_index, i + 1);
						//把经历过的属性加入到对象中
						var props:* = tTweenData.data;
						for (var tP:* in props) {
							if (tTweenData.isTo) {
								tTweenData.target[tP] = props[tP];
							}
						}
					} else {
						break;
					}
				}
			}
			//创建当前正在行动的TWEEN;
			for (i = 0, n = _tweenDataList.length; i < n; i++) {
				tTweenData = _tweenDataList[i];
				if (tTweenData.type == 0) {
					if (time >= tTweenData.startTime && time < tTweenData.endTime) {
						_index = Math.max(_index, i + 1);
						_gidIndex++;
						tTween = Pool.getItemByClass("tween", Tween);
						tTween._create(tTweenData.target, tTweenData.data, tTweenData.duration, tTweenData.ease, Handler.create(this, _animComplete, [_gidIndex]), 0, false, tTweenData.isTo, true, false);
						tTween.setStartTime(_currTime - (time - tTweenData.startTime));
						tTween.gid = _gidIndex;
						_tweenDic[_gidIndex] = tTween;
					}
				}
			}
		}
		
		/**
		 * 从指定的标签开始播
		 * @param	Label
		 */
		public function gotoLabel(Label:String):void {
			if (_labelDic == null) return;
			var tLabelData:tweenData = _labelDic[Label];
			if (tLabelData) {
				var tStartTime:Number = tLabelData.startTime;
				gotoTime(tStartTime);
			}
		}
		
		/**
		 * 暂停整个动画
		 */
		public function pause():void {
			Laya.timer.clear(this, _update);
		}
		
		/**
		 * 恢复暂停动画的播放
		 */
		public function resume():void {
			play(_currTime, _loopKey);
		}
		
		/**
		 * 播放动画
		 */
		public function play(timeOrLabel:* = 0, loop:Boolean = false):void {
			if (_startSortKey) {
				_startSortKey = false;
				//对数据排序
				function Compare(paraA:Object, paraB:Object):int {
					if (paraA.startTime > paraB.startTime) {
						return 1;
					} else if (paraA.startTime < paraB.startTime) {
						return -1;
					} else {
						return 0;
					}
				}
				_tweenDataList.sort(Compare);
			}
			if (timeOrLabel is String) {
				gotoLabel(timeOrLabel);
			} else {
				gotoTime(timeOrLabel);
			}
			_loopKey = loop;
			_lastTime = Browser.now();
			Laya.timer.frameLoop(1, this, _update, null, true);
		}
		
		/**
		 * 更新当前动画
		 */
		private function _update():void {
			if (_currTime >= _startTime) {
				if (_loopKey) {
					gotoTime(0);
					_complete();
				} else {
					return;
				}
			}
			
			var tNow:Number = Browser.now();
			var tFrameTime:Number = tNow - _lastTime;
			var tCurrTime:Number = _currTime += tFrameTime * scale;
			_lastTime = tNow;
			
			var tTween:Tween;
			if (_tweenDataList.length != 0 && _index < _tweenDataList.length) {
				var tTweenData:tweenData = _tweenDataList[_index];
				//创建TWEEN
				if (tCurrTime >= tTweenData.startTime) {
					_index++;
					_gidIndex++;
					tTween = new Tween();
					tTween._create(tTweenData.target, tTweenData.data, tTweenData.duration, tTweenData.ease, new Handler(this, _animComplete, [_gidIndex]), 0, false, tTweenData.isTo, true, false);
					tTween.setStartTime(tCurrTime);
					tTween.gid = _gidIndex;
					_tweenDic[_gidIndex] = tTween;
				}
			}
			
			for (var p:* in _tweenDic) {
				tTween = _tweenDic[p];
				tTween.updateEase(tCurrTime);
			}
		}
		
		/**
		 * 某个动画完成后，把动画从列表中删除
		 * @param	obj
		 */
		private function _animComplete(index:int):void {
			var tTween:Tween = _tweenDic[index];
			if (tTween) delete _tweenDic[index];
		}
		
		private function _complete():void {
		
		}
		
		/**
		 * 重置所有对象，复用对象的时候使用
		 */
		public function reset():void {
			var p:*;
			if (_labelDic) {
				for (p in _labelDic) {
					delete _labelDic[p];
				}
			}
			var tTween:Tween;
			for (p in _tweenDic) {
				tTween = _tweenDic[p];
				tTween.clear();
				delete _tweenDic[p];
			}
			for (p in _firstTweenDic) {
				delete _firstTweenDic[p];
			}
			_endTweenDataList = null;
			_tweenDataList.length = 0;
			_currTime = 0;
			_lastTime = 0;
			_startTime = 0;
			_index = 0;
			_gidIndex = 0;
			scale = 1;
			Laya.timer.clear(this, _update);
		}
		
		/**
		 * 彻底销毁
		 */
		public function destory():void {
			reset();
			_labelDic = null;
			_tweenDic = null;
			_tweenDataList = null;
			_firstTweenDic = null;
		}
	
	}

}

class tweenData {
	public var type:int = 0;//0代表TWEEN,1代表标签
	public var isTo:Boolean = true;
	public var startTime:Number;
	public var endTime:Number;
	public var target:*;
	public var duration:Number;
	public var ease:Function;
	public var data:*;
}