package laya.utils {
	
	/**
	 * <p><code>Handler</code> 是事件处理器类。</p>
	 * <p>推荐使用 Handler.create() 方法从对象池创建，减少对象创建消耗。创建的 Handler 对象不再使用后，可以使用 Handler.recover() 将其回收到对象池，回收后不要再使用此对象，否则会导致不可预料的错误。</p>
	 * <p><b>注意：</b>由于鼠标事件也用本对象池，不正确的回收及调用，可能会影响鼠标事件的执行。</p>
	 */
	public class Handler {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/**@private handler对象池*/
		private static var _pool:Array = [];
		/**@private */
		private static var _gid:int = 1;
		
		/** 执行域(this)。*/
		public var caller:*;
		/** 处理方法。*/
		public var method:Function;
		/** 参数。*/
		public var args:Array;
		/** 表示是否只执行一次。如果为true，回调后执行recover()进行回收，回收后会被再利用，默认为false 。*/
		public var once:Boolean = false;
		
		/**@private */
		protected var _id:int = 0;
		
		/**
		 * 根据指定的属性值，创建一个 <code>Handler</code> 类的实例。
		 * @param	caller 执行域。
		 * @param	method 处理函数。
		 * @param	args 函数参数。
		 * @param	once 是否只执行一次。
		 */
		public function Handler(caller:* = null, method:Function = null, args:Array = null, once:Boolean = false) {
			this.setTo(caller, method, args, once);
		}
		
		/**
		 * 设置此对象的指定属性值。
		 * @param	caller 执行域(this)。
		 * @param	method 回调方法。
		 * @param	args 携带的参数。
		 * @param	once 是否只执行一次，如果为true，执行后执行recover()进行回收。
		 * @return  返回 handler 本身。
		 */
		public function setTo(caller:*, method:Function, args:Array, once:Boolean):Handler {
			_id = _gid++;
			this.caller = caller;
			this.method = method;
			this.args = args;
			this.once = once;
			return this;
		}
		
		/**
		 * 执行处理器。
		 */
		public function run():* {
			if (method == null) return null;
			var id:int = _id;
			var result:* = method.apply(caller, args);
			_id === id && once && recover();
			return result;
		}
		
		/**
		 * 执行处理器，携带额外数据。
		 * @param	data 附加的回调数据，可以是单数据或者Array(作为多参)。
		 */
		public function runWith(data:*):* {
			if (method == null) return null;
			var id:int = _id;
			if (data == null)
				var result:* = method.apply(caller, args);
			/*[IF-FLASH]*/
			else if (!args && !(data is Array)) result = method.call(caller, data);
			//[IF-JS] else if (!args && !data.unshift) result= method.call(caller, data);
			else if (args) result = method.apply(caller, args.concat(data));
			else result = method.apply(caller, data);
			_id === id && once && recover();
			return result;
		}
		
		/**
		 * 清理对象引用。
		 */
		public function clear():Handler {
			this.caller = null;
			this.method = null;
			this.args = null;
			return this;
		}
		
		/**
		 * 清理并回收到 Handler 对象池内。
		 */
		public function recover():void {
			if (_id > 0) {
				_id = 0;
				_pool.push(clear());
			}
		}
		
		/**
		 * 从对象池内创建一个Handler，默认会执行一次并立即回收，如果不需要自动回收，设置once参数为false。
		 * @param	caller 执行域(this)。
		 * @param	method 回调方法。
		 * @param	args 携带的参数。
		 * @param	once 是否只执行一次，如果为true，回调后执行recover()进行回收，默认为true。
		 * @return  返回创建的handler实例。
		 */
		public static function create(caller:*, method:Function, args:Array = null, once:Boolean = true):Handler {
			if (_pool.length) return _pool.pop().setTo(caller, method, args, once);
			return new Handler(caller, method, args, once);
		}
	}
}