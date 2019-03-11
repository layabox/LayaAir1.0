package laya.d3.component {
	import laya.d3.animation.AnimationClip;
	import laya.d3.animation.AnimatorStateScript;
	import laya.d3.core.IClone;
	import laya.events.Event;
	
	/**
	 * <code>AnimatorState</code> 类用于创建动作状态。
	 */
	public class AnimatorState implements IClone {
		/**@private */
		public var _clip:AnimationClip;
		/**@private */
		public var _nodeOwners:Vector.<KeyframeNodeOwner> = new Vector.<KeyframeNodeOwner>();//TODO:提出去
		/**@private */
		public var _currentFrameIndices:Int16Array;
		/**@private */
		public var _scripts:Vector.<AnimatorStateScript>;
		
		/**名称。*/
		public var name:String;
		/**动画播放速度,1.0为正常播放速度。*/
		public var speed:Number = 1.0;
		/**动作播放起始时间。*/
		public var clipStart:Number = 0.0;
		/**动作播放结束时间。*/
		public var clipEnd:Number = 1.0;
		
		/**
		 * 获取动作。
		 * @return 动作
		 */
		public function get clip():AnimationClip {
			return _clip;
		}
		
		/**
		 * 设置动作。
		 * @param value 动作。
		 */
		public function set clip(value:AnimationClip):void {
			_clip = value;
			_currentFrameIndices = new Int16Array(value._nodes.count);
			_resetFrameIndices();
		}
		
		/**
		 * 创建一个 <code>AnimatorState</code> 实例。
		 */
		public function AnimatorState() {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		}
		
		/**
		 * @private
		 */
		public function _resetFrameIndices():void {
			for (var i:int = 0, n:int = _currentFrameIndices.length; i < n; i++)
				_currentFrameIndices[i] = -1;//-1表示没到第0帧,首帧时间可能大于
		}
		
		/**
		 * 添加脚本。
		 * @param	type  组件类型。
		 * @return 脚本。
		 *
		 */
		public function addScript(type:Class):AnimatorStateScript {
			var script:AnimatorStateScript = new type();
			_scripts ||= new Vector.<AnimatorStateScript>();
			_scripts.push(script);
			return script;
		}
		
		/**
		 * 获取脚本。
		 * @param	type  组件类型。
		 * @return 脚本。
		 *
		 */
		public function getScript(type:Class):AnimatorStateScript {
			if (_scripts) {
				for (var i:int = 0, n:int = _scripts.length; i < n; i++) {
					var script:AnimatorStateScript = _scripts[i];
					if (script is type)
						return script;
				}
			}
			return null;
		}
		
		/**
		 * 获取脚本集合。
		 * @param	type  组件类型。
		 * @return 脚本集合。
		 *
		 */
		public function getScripts(type:Class):Vector.<AnimatorStateScript> {
			var coms:Vector.<AnimatorStateScript>;
			if (_scripts) {
				for (var i:int = 0, n:int = _scripts.length; i < n; i++) {
					var script:AnimatorStateScript = _scripts[i];
					if (script is type) {
						coms ||= new Vector.<AnimatorStateScript>();
						coms.push(script);
					}
				}
			}
			return coms;
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var dest:AnimatorState = destObject as AnimatorState;
			dest.name = name;
			dest.speed = speed;
			dest.clipStart = clipStart;
			dest.clipEnd = clipEnd;
			dest.clip = _clip;
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var dest:AnimatorState = __JS__("new this.constructor()");
			cloneTo(dest);
			return dest;
		}
	
	}

}