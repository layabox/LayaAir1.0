package laya.particle.particleUtils
{
	import laya.maths.MathUtil;
	import laya.maths.Matrix;
	
	/**
	 *  @private
	 */
	public class CanvasShader
	{
		
		
		public var u_Duration:Number;
		public var u_EndVelocity:Number;
		public var u_Gravity:Float32Array;
		
		
		public var a_Position:Float32Array;
		public var a_Velocity:Float32Array;
		public var a_StartColor:Float32Array;
		public var a_EndColor:Float32Array;	
		public var a_SizeRotation:Float32Array;
		public var a_Radius:Float32Array;
		public var a_Radian:Float32Array;
		public var a_AgeAddScale:Number;
		

		
		
		
		public var _color:Float32Array = new Float32Array(4);
		public var gl_Position:Float32Array;
		public var v_Color:Float32Array;
		
		public var oSize:Number;	
		public var _position:Float32Array = new Float32Array(3);
		
		public function CanvasShader()
		{
		
		}
		
		public function getLen(position:Float32Array):Number
		{
			return Math.sqrt(position[0] * position[0] + position[1] * position[1] + position[2] * position[2]);
		}

		public function ComputeParticlePosition(position:Float32Array, velocity:Float32Array, age:Number, normalizedAge:Number):Float32Array
		{	
			_position[0]=position[0];
			_position[1]=position[1];
			_position[2]=position[2];
			var startVelocity:Number = getLen(velocity); //起始标量速度
			var endVelocity:Number = startVelocity * u_EndVelocity; //结束标量速度
			
			var velocityIntegral:Number = startVelocity * normalizedAge + (endVelocity - startVelocity) * normalizedAge * normalizedAge / 2.0; //计算当前速度的标量（单位空间），vt=v0*t+(1/2)*a*(t^2)
			var lenVelocity:Number;
			lenVelocity = getLen(velocity);
			var i:int, len:int;
			len = 3;
			for (i = 0; i < len; i++)
			{
				_position[i] =_position[i] + (velocity[i] / lenVelocity) * velocityIntegral * u_Duration; //计算受自身速度影响的位置，转换标量到矢量    
				_position[i] += u_Gravity[i] * age * normalizedAge; //计算受重力影响的位置
			}
			
			var radius:Number = MathUtil.lerp(a_Radius[0], a_Radius[1], normalizedAge); //计算粒子受半径和角度影响（无需计算角度和半径时，可用宏定义优化屏蔽此计算）
			var radianHorizontal:Number = MathUtil.lerp(a_Radian[0],a_Radian[2],normalizedAge);
			var radianVertical:Number = MathUtil.lerp(a_Radian[1],a_Radian[3],normalizedAge);
			
			var r:Number = Math.cos(radianVertical) * radius;
			_position[1] += Math.sin(radianVertical) * radius;
			
			_position[0] += Math.cos(radianHorizontal) * r;
			_position[2] += Math.sin(radianHorizontal) * r;
			
			return new Float32Array([_position[0], _position[1], 0.0, 1.0]);
		
		}
		
		public function ComputeParticleSize(startSize:Number, endSize:Number, normalizedAge:Number):Number
		{
			var size:Number = MathUtil.lerp(startSize, endSize, normalizedAge);
			
			return size;
		
		}
		
		public function ComputeParticleRotation(rot:Number, age:Number):Number
		{
			return rot * age;
		
		}
		
		
		public function ComputeParticleColor(startColor:Float32Array, endColor:Float32Array, normalizedAge:Number):Float32Array
		{
			var rst:Float32Array = _color;
			MathUtil.lerpVector4(startColor, endColor, normalizedAge, rst);
			//硬编码设置，使粒子淡入很快，淡出很慢,6.7的缩放因子把置归一在0到1之间，可以谷歌x*(1-x)*(1-x)*6.7的制图表
			rst[3] =rst[3]* normalizedAge * (1.0 - normalizedAge) * (1.0 - normalizedAge) * 6.7;
			
			return rst;
		}
		
		public function clamp(value:Number,min:Number,max:Number):Number
		{
			if(value<min) return min;
			if(value>max) return max;
			return value;
		}
		
		public function getData(age:Number):Array
		{
			age *= 1.0 + a_AgeAddScale;
			var normalizedAge:Number = clamp(age / u_Duration, 0.0, 1.0);
			gl_Position = ComputeParticlePosition(a_Position, a_Velocity, age, normalizedAge); //计算粒子位置
			var pSize:Number = ComputeParticleSize(a_SizeRotation[0], a_SizeRotation[1], normalizedAge);
			var rotation:Number = ComputeParticleRotation(a_SizeRotation[2], age);
			
			
			v_Color =  ComputeParticleColor(a_StartColor,a_EndColor, normalizedAge);
			
			var matric:Matrix=new Matrix();
			var scale:Number;
			scale=pSize/oSize*2;
			//scale=1;
			matric.scale(scale,scale);
			matric.rotate(rotation);
			matric.setTranslate(gl_Position[0],-gl_Position[1]);
//			trace(gl_Position[0],-gl_Position[1]);
			var alpha:Number;
			alpha = v_Color[3];
			//trace("alpha:",alpha);
			//alpha=1;
			return [v_Color,alpha,matric,v_Color[0]*alpha,v_Color[1]*alpha,v_Color[2]*alpha];
			
		}
	}

}