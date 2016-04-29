package laya.webgl.shader.d2.filters {
	import laya.webgl.shader.Shader;
	/**
	 * @author wk
	 */
	public class GlowFilterShader  extends Shader
	{
		public function GlowFilterShader() 
		{
			var vs:String = __INCLUDESTR__("glowFilter.vert");
			var ps:String = __INCLUDESTR__("glowFilter.frag");
			super(vs, ps, "glowFilter");
			//this._params=[
			//{name:"position",vartype:"attribute",type:"POSITION"},
			//{name:"texcoord",vartype:"attribute",type:"UV"},
			//{name:"mmat",vartype:"uniform",type:"mat4"},
			//{name:"pmat",vartype:"uniform",type:"mat4"},
			//{name:"texture",vartype:"uniform",type:"sampler2D"}
			//]
		}
	}

}