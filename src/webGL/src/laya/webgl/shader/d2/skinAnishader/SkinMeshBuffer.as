package laya.webgl.shader.d2.skinAnishader 
{
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.VertexBuffer2D;
	
	public class SkinMeshBuffer {
		
		public var ib:IndexBuffer2D;
		public var vb:VertexBuffer2D;
		
		public static var instance:SkinMeshBuffer;
		
		public function SkinMeshBuffer() {
			var gl:WebGLContext = WebGL.mainContext;
			ib = IndexBuffer2D.create(WebGLContext.DYNAMIC_DRAW);
			vb = VertexBuffer2D.create(8);
		}
		
		public static function getInstance():SkinMeshBuffer
		{
			return instance ||= new SkinMeshBuffer();
		}
		
		public function addSkinMesh(skinMesh:SkinMesh):void
		{
			//skinMesh.getData(vb, ib, vb.byteLength / 32);
			skinMesh.getData2(vb, ib, vb._byteLength / 32);
		}
		
	
		
		public function reset():void {
			this.vb.clear();
			this.ib.clear();
		}
	
	}

}