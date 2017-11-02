package laya.filters.webgl {
	import laya.display.Sprite;
	import laya.filters.BlurFilter;
	import laya.filters.Filter;
	import laya.maths.Matrix;
	import laya.maths.Rectangle;
	import laya.renders.RenderContext;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.submit.SubmitCMDScope;
	
	/**
	 * @private
	 */
	public class BlurFilterActionGL extends FilterActionGL {
		public var data:BlurFilter;
		
		public function BlurFilterActionGL() {
			super();
		}
		
		override public function get typeMix():int { return Filter.BLUR; }
		
		override public function setValueMix(shader:Value2D):void {
			shader.defines.add(data.type);
			var o:* = shader;
		}
		
		override public function apply3d(scope:SubmitCMDScope, sprite:Sprite, context:RenderContext, x:Number, y:Number):* {
			var b:Rectangle = scope.getValue("bounds");
			var shaderValue:Value2D = Value2D.create(ShaderDefines2D.TEXTURE2D, 0);
			shaderValue.setFilters([data]);
			var tMatrix:Matrix = Matrix.EMPTY;
			tMatrix.identity();
			context.ctx.drawTarget(scope, 0, 0, b.width, b.height, Matrix.EMPTY, "src", shaderValue);
			shaderValue.setFilters(null);
		}
		
		override public function setValue(shader:*):void {
			shader.strength = data.strength;//���shader�в����ã�����ע�͵���ʲô������ʾ��
			var sigma:Number = data.strength/3.0;//3������Ӱ���С��������=1��ʱ�򣬰뾶Ϊ3;
			var sigma2:Number = sigma*sigma;
			data.strength_sig2_2sig2_gauss1[0] = data.strength;
			//data.strength_sig2_2sig2_gauss1[1] = sigma;
			data.strength_sig2_2sig2_gauss1[1] = sigma2;			//��һЩԤ���㴫��shader�����Ч��
			data.strength_sig2_2sig2_gauss1[2] = 2.0*sigma2;
			data.strength_sig2_2sig2_gauss1[3] = 1.0/(2.0*Math.PI*sigma2);
			shader.strength_sig2_2sig2_gauss1 = data.strength_sig2_2sig2_gauss1;
		}
	}
}