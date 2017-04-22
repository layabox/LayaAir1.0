package laya.d3.core.particleShuriKen.module {
	import laya.d3.core.IClone;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>GradientSize</code> 类用于创建渐变尺寸。
	 */
	public class GradientSize implements IClone {
		/**
		 * 通过渐变尺寸创建一个 <code>GradientSize</code> 实例。
		 * @param	gradient 渐变尺寸。
		 * @return  渐变尺寸。
		 */
		public static function createByGradient(gradient:GradientDataNumber):GradientSize {
			var gradientSize:GradientSize = new GradientSize();
			gradientSize._type = 0;
			gradientSize._separateAxes = false;
			gradientSize._gradient = gradient;
			return gradientSize;
		}
		
		/**
		 * 通过分轴渐变尺寸创建一个 <code>GradientSize</code> 实例。
		 * @param	gradientX 渐变尺寸X。
		 * @param	gradientY 渐变尺寸Y。
		 * @param	gradientZ 渐变尺寸Z。
		 * @return  渐变尺寸。
		 */
		public static function createByGradientSeparate(gradientX:GradientDataNumber, gradientY:GradientDataNumber, gradientZ:GradientDataNumber):GradientSize {
			var gradientSize:GradientSize = new GradientSize();
			gradientSize._type = 0;
			gradientSize._separateAxes = true;
			gradientSize._gradientX = gradientX;
			gradientSize._gradientY = gradientY;
			gradientSize._gradientZ = gradientZ;
			return gradientSize;
		}
		
		/**
		 * 通过随机双固定尺寸创建一个 <code>GradientSize</code> 实例。
		 * @param	constantMin 最小固定尺寸。
		 * @param	constantMax 最大固定尺寸。
		 * @return 渐变尺寸。
		 */
		public static function createByRandomTwoConstant(constantMin:Number, constantMax:Number):GradientSize {
			var gradientSize:GradientSize = new GradientSize();
			gradientSize._type = 1;
			gradientSize._separateAxes = false;
			gradientSize._constantMin = constantMin;
			gradientSize._constantMax = constantMax;
			return gradientSize;
		}
		
		/**
		 * 通过分轴随机双固定尺寸创建一个 <code>GradientSize</code> 实例。
		 * @param	constantMinSeparate 分轴最小固定尺寸.
		 * @param	constantMaxSeparate 分轴最大固定尺寸。
		 * @return   渐变尺寸。
		 */
		public static function createByRandomTwoConstantSeparate(constantMinSeparate:Vector3, constantMaxSeparate:Vector3):GradientSize {
			var gradientSize:GradientSize = new GradientSize();
			gradientSize._type = 1;
			gradientSize._separateAxes = true;
			gradientSize._constantMinSeparate = constantMinSeparate;
			gradientSize._constantMaxSeparate = constantMaxSeparate;
			return gradientSize;
		}
		
		/**
		 * 通过随机双渐变尺寸创建一个 <code>GradientSize</code> 实例。
		 * @param	gradientMin 最小渐变尺寸。
		 * @param	gradientMax 最大渐变尺寸。
		 * @return 渐变尺寸。
		 */
		public static function createByRandomTwoGradient(gradientMin:GradientDataNumber, gradientMax:GradientDataNumber):GradientSize {
			var gradientSize:GradientSize = new GradientSize();
			gradientSize._type = 2;
			gradientSize._separateAxes = false;
			gradientSize._gradientMin = gradientMin;
			gradientSize._gradientMax = gradientMax;
			return gradientSize;
		}
		
		/**
		 * 通过分轴随机双渐变尺寸创建一个 <code>GradientSize</code> 实例。
		 * @param	gradientXMin X轴最小渐变尺寸。
		 * @param	gradientXMax X轴最大渐变尺寸。
		 * @param	gradientYMin Y轴最小渐变尺寸。
		 * @param	gradientYMax Y轴最大渐变尺寸。
		 * @param	gradientZMin Z轴最小渐变尺寸。
		 * @param	gradientZMax Z轴最大渐变尺寸。
		 * @return  渐变尺寸。
		 */
		public static function createByRandomTwoGradientSeparate(gradientXMin:GradientDataNumber, gradientXMax:GradientDataNumber, gradientYMin:GradientDataNumber, gradientYMax:GradientDataNumber, gradientZMin:GradientDataNumber, gradientZMax:GradientDataNumber):GradientSize {
			var gradientSize:GradientSize = new GradientSize();
			gradientSize._type = 2;
			gradientSize._separateAxes = true;
			gradientSize._gradientXMin = gradientXMin;
			gradientSize._gradientXMax = gradientXMax;
			gradientSize._gradientYMin = gradientYMin;
			gradientSize._gradientYMax = gradientYMax;
			gradientSize._gradientZMin = gradientZMin;
			gradientSize._gradientZMax = gradientZMax;
			return gradientSize;
		}
		
		/**@private */
		private var _type:int;
		/**@private */
		private var _separateAxes:Boolean;
		
		/**@private */
		private var _gradient:GradientDataNumber;
		/**@private */
		private var _gradientX:GradientDataNumber;
		/**@private */
		private var _gradientY:GradientDataNumber;
		/**@private */
		private var _gradientZ:GradientDataNumber;
		
		/**@private */
		private var _constantMin:Number;
		/**@private */
		private var _constantMax:Number;
		/**@private */
		private var _constantMinSeparate:Vector3;
		/**@private */
		private var _constantMaxSeparate:Vector3;
		
		/**@private */
		private var _gradientMin:GradientDataNumber;
		/**@private */
		private var _gradientMax:GradientDataNumber;
		/**@private */
		private var _gradientXMin:GradientDataNumber;
		/**@private */
		private var _gradientXMax:GradientDataNumber;
		/**@private */
		private var _gradientYMin:GradientDataNumber;
		/**@private */
		private var _gradientYMax:GradientDataNumber;
		/**@private */
		private var _gradientZMin:GradientDataNumber;
		/**@private */
		private var _gradientZMax:GradientDataNumber;
		
		/**
		 *生命周期尺寸类型，0曲线模式，1随机双常量模式，2随机双曲线模式。
		 */
		public function get type():int {
			return _type;
		}
		
		/**
		 *是否分轴。
		 */
		public function get separateAxes():Boolean {
			return _separateAxes;
		}
		
		/**
		 * 渐变尺寸。
		 */
		public function get gradient():GradientDataNumber {
			return _gradient;
		}
		
		/**
		 * 渐变尺寸X。
		 */
		public function get gradientX():GradientDataNumber {
			return _gradientX;
		}
		
		/**
		 * 渐变尺寸Y。
		 */
		public function get gradientY():GradientDataNumber {
			return _gradientY;
		}
		
		/**
		 *渐变尺寸Z。
		 */
		public function get gradientZ():GradientDataNumber {
			return _gradientZ;
		}
		
		/**
		 *最小随机双固定尺寸。
		 */
		public function get constantMin():Number {
			return _constantMin;
		}
		
		/**
		 * 最大随机双固定尺寸。
		 */
		public function get constantMax():Number {
			return _constantMax;
		}
		
		/**
		 * 最小分轴随机双固定尺寸。
		 */
		public function get constantMinSeparate():Vector3 {
			return _constantMinSeparate;
		}
		
		/**
		 *  最小分轴随机双固定尺寸。
		 */
		public function get constantMaxSeparate():Vector3 {
			return _constantMaxSeparate;
		}
		
		/**
		 *渐变最小尺寸。
		 */
		public function get gradientMin():GradientDataNumber {
			return _gradientMin;
		}
		
		/**
		 * 渐变最大尺寸。
		 */
		public function get gradientMax():GradientDataNumber {
			return _gradientMax;
		}
		
		/**
		 * 渐变最小尺寸X。
		 */
		public function get gradientXMin():GradientDataNumber {
			return _gradientXMin;
		}
		
		/**
		 * 渐变最大尺寸X。
		 */
		public function get gradientXMax():GradientDataNumber {
			return _gradientXMax;
		}
		
		/**
		 * 渐变最小尺寸Y。
		 */
		public function get gradientYMin():GradientDataNumber {
			return _gradientYMin;
		}
		
		/**
		 *渐变最大尺寸Y。
		 */
		public function get gradientYMax():GradientDataNumber {
			return _gradientYMax;
		}
		
		/**
		 * 渐变最小尺寸Z。
		 */
		public function get gradientZMin():GradientDataNumber {
			return _gradientZMin;
		}
		
		/**
		 * 渐变最大尺寸Z。
		 */
		public function get gradientZMax():GradientDataNumber {
			return _gradientZMax;
		}
		
		/**
		 * 创建一个 <code>GradientSize,不允许new，请使用静态创建函数。</code> 实例。
		 */
		public function GradientSize() {
		}
		
		/**
		 * 获取最大尺寸。
		 */
		public function getMaxSizeInGradient():Number {
			var i:int, n:int;
			var maxSize:Number =-Number.MAX_VALUE;
			switch (_type) {
			case 0: 
				if (_separateAxes) {
					for (i = 0, n = _gradientX.gradientCount; i < n; i++)
						maxSize = Math.max(maxSize, _gradientX.getValueByIndex(i));
					for (i = 0, n = _gradientY.gradientCount; i < n; i++)
						maxSize = Math.max(maxSize, _gradientY.getValueByIndex(i));
						//TODO:除了RenderMode为MeshZ无效
				} else {
					for (i = 0, n = _gradient.gradientCount; i < n; i++)
						maxSize = Math.max(maxSize, _gradient.getValueByIndex(i));
				}
				break;
			case 1: 
				if (_separateAxes) {
					maxSize = Math.max(_constantMinSeparate.x, _constantMaxSeparate.x);
					maxSize = Math.max(maxSize, _constantMinSeparate.y);
					maxSize = Math.max(maxSize, _constantMaxSeparate.y);
					//TODO:除了RenderMode为MeshZ无效
				} else {
					maxSize = Math.max(_constantMin, _constantMax);
				}
				break;
			case 2: 
				if (_separateAxes) {
					for (i = 0, n = _gradientXMin.gradientCount; i < n; i++)
						maxSize = Math.max(maxSize, _gradientXMin.getValueByIndex(i));
					for (i = 0, n = _gradientXMax.gradientCount; i < n; i++)
						maxSize = Math.max(maxSize, _gradientXMax.getValueByIndex(i));
					
					for (i = 0, n = _gradientYMin.gradientCount; i < n; i++)
						maxSize = Math.max(maxSize, _gradientYMin.getValueByIndex(i));
					for (i = 0, n = _gradientZMax.gradientCount; i < n; i++)
						maxSize = Math.max(maxSize, _gradientZMax.getValueByIndex(i));
						//TODO:除了RenderMode为MeshZ无效
				} else {
					for (i = 0, n = _gradientMin.gradientCount; i < n; i++)
						maxSize = Math.max(maxSize, _gradientMin.getValueByIndex(i));
					for (i = 0, n = _gradientMax.gradientCount; i < n; i++)
						maxSize = Math.max(maxSize, _gradientMax.getValueByIndex(i));
				}
				break;
			}
			return maxSize;
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destGradientSize:GradientSize = destObject as GradientSize;
			destGradientSize._type = _type;
			destGradientSize._separateAxes = _separateAxes;
			_gradient.cloneTo(destGradientSize._gradient);
			_gradientX.cloneTo(destGradientSize._gradientX);
			_gradientY.cloneTo(destGradientSize._gradientY);
			_gradientZ.cloneTo(destGradientSize._gradientZ);
			destGradientSize._constantMin = _constantMin;
			destGradientSize._constantMax = _constantMax;
			_constantMinSeparate.cloneTo(destGradientSize._constantMinSeparate);
			_constantMaxSeparate.cloneTo(destGradientSize._constantMaxSeparate);
			_gradientMin.cloneTo(destGradientSize._gradientMin);
			_gradientMax.cloneTo(destGradientSize._gradientMax);
			_gradientXMin.cloneTo(destGradientSize._gradientXMin);
			_gradientXMax.cloneTo(destGradientSize._gradientXMax);
			_gradientYMin.cloneTo(destGradientSize._gradientYMin);
			_gradientYMax.cloneTo(destGradientSize._gradientYMax);
			_gradientZMin.cloneTo(destGradientSize._gradientZMin);
			_gradientZMax.cloneTo(destGradientSize._gradientZMax);
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destGradientSize:GradientSize = __JS__("new this.constructor()");
			cloneTo(destGradientSize);
			return destGradientSize;
		}
	
	}

}