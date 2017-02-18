package laya.utils {
	/*[IF-FLASH]*/import flash.utils.Dictionary;
	import laya.display.Node;
	
	
	/**
	 * <code>Tween</code>  是一个缓动类。使用实现目标对象属性的渐变。
	 */
	public class Tween {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/**@private */
		/*[IF-FLASH]*/ private static var tweenMap:flash.utils.Dictionary = new flash.utils.Dictionary(true);
		//[IF-JS] private static var tweenMap:Array = {};
		/**@private */
		private var _complete:Handler;
		/**@private */
		private var _target:*;
		/**@private */
		private var _ease:Function;
		/**@private */
		private var _props:Array;
		/**@private */
		private var _duration:int;
		/**@private */
		private var _delay:int;
		/**@private */
		private var _startTimer:int;
		/**@private */
		private var _usedTimer:int;
		/**@private */
		private var _usedPool:Boolean;
		/**@private 唯一标识，TimeLintLite用到*/
		public var gid:int = 0;
		/**更新回调，缓动数值发生变化时，回调变化的值*/
		public var update:Handler;
		
		/**
		 * 缓动对象的props属性到目标值。
		 * @param	target 目标对象(即将更改属性值的对象)。
		 * @param	props 变化的属性列表，比如{x:100,y:20,ease:Ease.backOut,complete:Handler.create(this,onComplete),update:new Handler(this,onComplete)}。
		 * @param	duration 花费的时间，单位毫秒。
		 * @param	ease 缓动类型，默认为匀速运动。
		 * @param	complete 结束回调函数。
		 * @param	delay 延迟执行时间。
		 * @param	coverBefore 是否覆盖之前的缓动。
		 * @param	autoRecover 是否自动回收，默认为true，缓动结束之后自动回收到对象池。
		 * @return	返回Tween对象。
		 */
		public static function to(target:*, props:Object, duration:int, ease:Function = null, complete:Handler = null, delay:int = 0, coverBefore:Boolean = false, autoRecover:Boolean = true):Tween {
			return Pool.getItemByClass("tween", Tween)._create(target, props, duration, ease, complete, delay, coverBefore, true, autoRecover, true);
		}
		
		/**
		 * 从props属性，缓动到当前状态。
		 * @param	target 目标对象(即将更改属性值的对象)。
		 * @param	props 变化的属性列表，比如{x:100,y:20,ease:Ease.backOut,complete:Handler.create(this,onComplete),update:new Handler(this,onComplete)}。
		 * @param	duration 花费的时间，单位毫秒。
		 * @param	ease 缓动类型，默认为匀速运动。
		 * @param	complete 结束回调函数。
		 * @param	delay 延迟执行时间。
		 * @param	coverBefore 是否覆盖之前的缓动。
		 * @param	autoRecover 是否自动回收，默认为true，缓动结束之后自动回收到对象池。
		 * @return	返回Tween对象。
		 */
		public static function from(target:*, props:Object, duration:int, ease:Function = null, complete:Handler = null, delay:int = 0, coverBefore:Boolean = false, autoRecover:Boolean = true):Tween {
			return Pool.getItemByClass("tween", Tween)._create(target, props, duration, ease, complete, delay, coverBefore, false, autoRecover, true);
		}
		
		/**
		 * 缓动对象的props属性到目标值。
		 * @param	target 目标对象(即将更改属性值的对象)。
		 * @param	props 变化的属性列表，比如{x:100,y:20,ease:Ease.backOut,complete:Handler.create(this,onComplete),update:new Handler(this,onComplete)}。
		 * @param	duration 花费的时间，单位毫秒。
		 * @param	ease 缓动类型，默认为匀速运动。
		 * @param	complete 结束回调函数。
		 * @param	delay 延迟执行时间。
		 * @param	coverBefore 是否覆盖之前的缓动。
		 * @return	返回Tween对象。
		 */
		public function to(target:*, props:Object, duration:int, ease:Function = null, complete:Handler = null, delay:int = 0, coverBefore:Boolean = false):Tween {
			return _create(target, props, duration, ease, complete, delay, coverBefore, true, false, true);
		}
		
		/**
		 * 从props属性，缓动到当前状态。
		 * @param	target 目标对象(即将更改属性值的对象)。
		 * @param	props 变化的属性列表，比如{x:100,y:20,ease:Ease.backOut,complete:Handler.create(this,onComplete),update:new Handler(this,onComplete)}。
		 * @param	duration 花费的时间，单位毫秒。
		 * @param	ease 缓动类型，默认为匀速运动。
		 * @param	complete 结束回调函数。
		 * @param	delay 延迟执行时间。
		 * @param	coverBefore 是否覆盖之前的缓动。
		 * @return	返回Tween对象。
		 */
		public function from(target:*, props:Object, duration:int, ease:Function = null, complete:Handler = null, delay:int = 0, coverBefore:Boolean = false):Tween {
			return _create(target, props, duration, ease, complete, delay, coverBefore, false, false, true);
		}
		
		/** @private */
		public function _create(target:*, props:Object, duration:int, ease:Function, complete:Handler, delay:int, coverBefore:Boolean, isTo:Boolean, usePool:Boolean, runNow:Boolean):Tween {
			if (!target) throw new Error("Tween:target is null");
			this._target = target;
			this._duration = duration;
			this._ease = ease || props.ease || easeNone;
			this._complete = complete || props.complete;
			this._delay = delay;
			this._props = [];
			this._usedTimer = 0;
			this._startTimer = Browser.now();
			this._usedPool = usePool;
			this.update = props.update;
			
			//判断是否覆盖			
			//[IF-JS]var gid:int = (target.$_GID || (target.$_GID = Utils.getGID()));
			/*[IF-FLASH]*/var gid:* = target;
			if (!tweenMap[gid]) {
				tweenMap[gid] = [this];
			} else {
				if (coverBefore) clearTween(target);
				tweenMap[gid].push(this);
			}
			
			if (runNow) {
				if (delay <= 0) firstStart(target, props, isTo);
				else Laya.timer.once(delay, this, firstStart, [target, props, isTo]);
			} else {
				_initProps(target, props, isTo);
			}
			return this;
		}
		
		private function firstStart(target:*, props:Object, isTo:Boolean):void {
			_initProps(target, props, isTo);
			_beginLoop();
		}
		
		private function _initProps(target:*, props:Object, isTo:Boolean):void {
			//初始化属性
			for (var p:String in props) {
				if (target[p] is Number) {
					var start:Number = isTo ? target[p] : props[p];
					var end:Number = isTo ? props[p] : target[p];
					this._props.push([p, start, end - start]);
				}
			}
		}
		
		private function _beginLoop():void {
			Laya.timer.frameLoop(1, this, _doEase);
		}
		
		/**执行缓动**/
		private function _doEase():void {
			_updateEase(Browser.now());
		}
		
		/**@private */
		public function _updateEase(time:Number):void {
			var target:* = this._target;
			
			//如果对象被销毁，则立即停止缓动
			/*[IF-FLASH]*/if (target is Node && target.destroyed) return clearTween(target);
			//[IF-JS]if (target.destroyed) return clearTween(target);
			
			var usedTimer:Number = this._usedTimer = time - this._startTimer - this._delay;
			if (usedTimer < 0) return;
			if (usedTimer >= this._duration) return complete();
			
			var ratio:Number = usedTimer > 0 ? this._ease(usedTimer, 0, 1, this._duration) : 0;
			var props:Array = this._props;
			for (var i:int, n:int = props.length; i < n; i++) {
				var prop:Array = props[i];
				target[prop[0]] = prop[1] + (ratio * prop[2]);
			}
			if (update) update.run();
		}
		
		/**设置当前执行比例**/
		public function set progress(v:Number):void {
			var uTime:Number = v * _duration;
			this._startTimer = Browser.now() - this._delay - uTime;
		}
		
		/**
		 * 立即结束缓动并到终点。
		 */
		public function complete():void {
			if (!this._target) return;
			//缓存当前属性
			var target:* = this._target;
			var props:* = this._props;
			var handler:Handler = this._complete;
			//设置终点属性
			for (var i:int, n:int = props.length; i < n; i++) {
				var prop:Array = props[i];
				target[prop[0]] = prop[1] + prop[2];
			}
			if (update) update.run();
			//清理
			clear();
			//回调
			handler && handler.run();
		}
		
		/**
		 * 暂停缓动，可以通过resume或restart重新开始。
		 */
		public function pause():void {
			Laya.timer.clear(this, _beginLoop);
			Laya.timer.clear(this, _doEase);
		}
		
		/**
		 * 设置开始时间。
		 * @param	startTime 开始时间。
		 */
		public function setStartTime(startTime:Number):void {
			_startTimer = startTime;
		}
		
		/**
		 * 清理指定目标对象上的所有缓动。
		 * @param	target 目标对象。
		 */
		public static function clearAll(target:Object):void {
			/*[IF-FLASH]*/if (!target)return;
			//[IF-JS]if (!target || !target.$_GID) return;
			/*[IF-FLASH]*/var tweens:Array = tweenMap[target];
			//[IF-JS]var tweens:Array = tweenMap[target.$_GID];
			if (tweens) {
				for (var i:int, n:int = tweens.length; i < n; i++) {
					tweens[i]._clear();
				}
				tweens.length = 0;
			}
		}
		
		/**
		 * 清理某个缓动。
		 * @param	tween 缓动对象。
		 */
		public static function clear(tween:Tween):void {
			tween.clear();
		}
		
		/**@private 同clearAll，废弃掉，尽量别用。*/
		public static function clearTween(target:Object):void {
			clearAll(target);
		}
		
		/**
		 * 停止并清理当前缓动。
		 */
		public function clear():void {
			if (this._target) {
				_remove();
				_clear();
			}
		}
		
		/**
		 * @private
		 */
		public function _clear():void {
			pause();
			Laya.timer.clear(this, firstStart);
			this._complete = null;
			this._target = null;
			this._ease = null;
			this._props = null;
			
			if (this._usedPool) {
				this.update = null;
				Pool.recover("tween", this);
			}
		}
		
		/** 回收到对象池。*/
		public function recover():void {
			_usedPool = true;
			_clear();
		}
		
		private function _remove():void {
			/*[IF-FLASH]*/var tweens:Array = tweenMap[this._target];
			//[IF-JS]var tweens:Array = tweenMap[this._target.$_GID];
			if (tweens) {
				for (var i:int, n:int = tweens.length; i < n; i++) {
					if (tweens[i] === this) {
						tweens.splice(i, 1);
						break;
					}
				}
			}
		}
		
		/**
		 * 重新开始暂停的缓动。
		 */
		public function restart():void {
			pause();
			this._usedTimer = 0;
			this._startTimer = Browser.now();
			var props:Array = this._props;
			for (var i:int, n:int = props.length; i < n; i++) {
				var prop:Array = props[i];
				this._target[prop[0]] = prop[1];
			}
			Laya.timer.once(this._delay, this, _beginLoop);
		}
		
		/**
		 * 恢复暂停的缓动。
		 */
		public function resume():void {
			if (this._usedTimer >= this._duration) return;
			this._startTimer = Browser.now() - this._usedTimer - this._delay;
			_beginLoop();
		}
		
		private static function easeNone(t:Number, b:Number, c:Number, d:Number):Number {
			return c * t / d + b;
		}
	}
}