package laya.d3.utils 
{
	import laya.d3.math.Vector3;
	
	/**
	 * ...
	 * @author ...
	 */
	public class RaycastHit 
	{
		public var distance:Number;
		public var trianglePositions:Array;
		public var triangleNormals:Array;
		public var position:Vector3;
		
		public function RaycastHit() 
		{
			distance =Number.MAX_VALUE;
			trianglePositions = [new Vector3(),new Vector3(),new Vector3()];
			trianglePositions.length = 3;
			
			triangleNormals = [new Vector3(),new Vector3(),new Vector3()];
			triangleNormals.length = 3;
			
			position = new Vector3();
		}
		

		public function copy(dec:RaycastHit):void {
			dec.distance = distance;
			
			trianglePositions[0].cloneTo(dec.trianglePositions[0]);
			trianglePositions[1].cloneTo(dec.trianglePositions[1]);
			trianglePositions[2].cloneTo(dec.trianglePositions[2]);
			
			triangleNormals[0].cloneTo(dec.triangleNormals[0]);
			triangleNormals[1].cloneTo(dec.triangleNormals[1]);
			triangleNormals[2].cloneTo(dec.triangleNormals[2]);
			
			position.cloneTo(dec.position);
			
		}
		
	}

}