package laya.d3.math {
	
	/**
	 * <code>Rand</code> 类用于通过128位整型种子创建随机数,算法来自:https://github.com/AndreasMadsen/xorshift。
	 */
	public class RandX {
		/**@private */
		private static var _CONVERTION_BUFFER:DataView = new DataView(new ArrayBuffer(8));
		
		/**@private */
		private var _state0U:Number;
		/**@private */
		private var _state0L:Number;
		/**@private */
		private var _state1U:Number;
		/**@private */
		private var _state1L:Number;
		
		/**基于时间种子的随机数。*/
		public static var defaultRand:RandX = __JS__("new Rand([0, Date.now() / 65536, 0, Date.now() % 65536])");
		
		/**
		 * 创建一个 <code>Rand</code> 实例。
		 * @param	seed  随机种子。
		 */
		public function RandX(seed:Array) {
			if (!(seed is Array) || seed.length !== 4)
				throw new Error('Rand:Seed must be an array with 4 numbers');
			
			_state0U = seed[0] | 0;
			_state0L = seed[1] | 0;
			_state1U = seed[2] | 0;
			_state1L = seed[3] | 0;
		}
		
		/**
		 * 通过2x32位的数组，返回64位的随机数。
		 * @return 64位的随机数。
		 */
		public function randomint():Array {
			// uint64_t s1 = s[0]
			var s1U:Number = _state0U, s1L:Number = _state0L;
			// uint64_t s0 = s[1]
			var s0U:Number = _state1U, s0L:Number = _state1L;
			
			// result = s0 + s1
			var sumL:Number = (s0L >>> 0) + (s1L >>> 0);
			var resU:Number = (s0U + s1U + (sumL / 2 >>> 31)) >>> 0;
			var resL:Number = sumL >>> 0;
			
			// s[0] = s0
			_state0U = s0U;
			_state0L = s0L;
			
			// - t1 = [0, 0]
			var t1U:Number = 0, t1L:Number = 0;
			// - t2 = [0, 0]
			var t2U:Number = 0, t2L:Number = 0;
			
			// s1 ^= s1 << 23;
			// :: t1 = s1 << 23
			var a1:Number = 23;
			var m1:Number = 0xFFFFFFFF << (32 - a1);
			t1U = (s1U << a1) | ((s1L & m1) >>> (32 - a1));
			t1L = s1L << a1;
			// :: s1 = s1 ^ t1
			s1U = s1U ^ t1U;
			s1L = s1L ^ t1L;
			
			// t1 = ( s1 ^ s0 ^ ( s1 >> 17 ) ^ ( s0 >> 26 ) )
			// :: t1 = s1 ^ s0
			t1U = s1U ^ s0U;
			t1L = s1L ^ s0L;
			// :: t2 = s1 >> 18
			var a2:Number = 18;
			var m2:Number = 0xFFFFFFFF >>> (32 - a2);
			t2U = s1U >>> a2;
			t2L = (s1L >>> a2) | ((s1U & m2) << (32 - a2));
			// :: t1 = t1 ^ t2
			t1U = t1U ^ t2U;
			t1L = t1L ^ t2L;
			// :: t2 = s0 >> 5
			var a3:Number = 5;
			var m3:Number = 0xFFFFFFFF >>> (32 - a3);
			t2U = s0U >>> a3;
			t2L = (s0L >>> a3) | ((s0U & m3) << (32 - a3));
			// :: t1 = t1 ^ t2
			t1U = t1U ^ t2U;
			t1L = t1L ^ t2L;
			
			// s[1] = t1
			_state1U = t1U;
			_state1L = t1L;
			
			// return result
			return [resU, resL];
		}
		
		/**
		 * 返回[0,1)之间的随机数。
		 * @return
		 */
		public function random():Number {
			// :: t2 = randomint()
			var t2:Array = this.randomint();
			var t2U:Number = t2[0];
			var t2L:Number = t2[1];
			
			// :: e = UINT64_C(0x3FF) << 52
			var eU:Number = 0x3FF << (52 - 32);
			var eL:Number = 0;
			
			// :: s = t2 >> 12
			var a1:Number = 12;
			var m1:Number = 0xFFFFFFFF >>> (32 - a1);
			var sU:Number = t2U >>> a1;
			var sL:Number = (t2L >>> a1) | ((t2U & m1) << (32 - a1));
			
			// :: x = e | s
			var xU:Number = eU | sU;
			var xL:Number = eL | sL;
			
			// :: double d = *((double *)&x)
			_CONVERTION_BUFFER.setUint32(0, xU, false);
			_CONVERTION_BUFFER.setUint32(4, xL, false);
			var d:Number = __JS__("Rand._CONVERTION_BUFFER.getFloat64(0, false)");
			
			// :: d - 1
			return d - 1;
		}
	}

}