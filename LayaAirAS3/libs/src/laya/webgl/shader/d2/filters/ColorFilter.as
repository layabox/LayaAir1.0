package laya.webgl.shader.d2.filters {
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.CONST3D2D;

	/**
	 * @author wk
	 */
	public class ColorFilter extends Shader
	{
		public function ColorFilter()
		{
			var vs:String = __INCLUDESTR__("colorFilter.vert");
			var ps:String = __INCLUDESTR__("colorFilter.frag");
			super(vs, ps, "colorFilter");
//			this._params=[
//			{name:"position",vartype:"attribute",type:"POSITION"},
//			{name:"texcoord",vartype:"attribute",type:"UV"},
//			{name:"mmat",vartype:"uniform",type:"mat4"},
//			{name:"pmat",vartype:"uniform",type:"mat4"},
//			{name:"texture",vartype:"uniform",type:"sampler2D"},
//			{name:"alpha",vartype:"uniform",type:"1f"},
//			{name:"u_colorMatrix", vartype:"uniform", type:"1fv"}
//			]
			
			/*灰度滤镜 请在使用时设置
			 value.u_colorMatrix = new Float32Array([0.3, 0.59, 0.11, 0, 0,
										   0.3, 0.59, 0.11, 0, 0, 
										   0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0]);
			 */
		}
		
	}

}