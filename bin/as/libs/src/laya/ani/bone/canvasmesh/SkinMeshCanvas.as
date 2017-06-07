package laya.ani.bone.canvasmesh 
{
	import laya.maths.Matrix;
	import laya.resource.Texture;

	/**
	 * @private
	 * Canvas版本的SkinMesh
	 */
	public class SkinMeshCanvas extends CanvasMeshRender
	{
		public function SkinMeshCanvas()
		{
			mesh = new MeshData();
		}
		
		public function init2(texture:Texture, vs:Array, ps:Array, verticles:Array, uvs:Array):void 
		{
			if (transform)
			{
				transform=null;
			} 
			var _ps:Array;
			if (ps) {
				_ps = ps;
			} else {
				_ps = [];
				_ps.push(0, 1, 3, 3, 1, 2);
			}
			mesh.texture = texture;
			mesh.indexes = _ps;
			mesh.vertices = verticles;
			mesh.uvs = uvs;
		}
		
		public static var _tempMatrix:Matrix=new Matrix();
		
		public function render(context:*, x:Number, y:Number):void
		{
			if(!mesh.texture) return;
			if(!transform)
			{
				transform=_tempMatrix;
				transform.identity();
				transform.translate(x, y);
				renderToContext(context);
				transform.translate(-x, -y);
				transform=null;
			}else
			{
				transform.translate(x, y);
				renderToContext(context);
				transform.translate(-x, -y);
			}
			
		}
	}

}