package laya.d3Editor.material {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.SkinnedMeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.particleShuriKen.ShuriKenParticle3D;
	import laya.d3.core.particleShuriKen.ShurikenParticleMaterial;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.graphics.Vertex.VertexMesh;
	import laya.d3.graphics.Vertex.VertexShuriKenParticle;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.SubShader;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PickShader {
		/**@private */
		public static var PICK_SHADER_FLAG:String = "PICKTYPE";
		
		public static function initShader():void {
			var shader:Shader3D = Shader3D.add("GPUPick");
			
			var attributeMap:Object = {
				'a_Position': VertexMesh.MESH_POSITION0,
				'a_BoneWeights': VertexMesh.MESH_BLENDWEIGHT0, 
				'a_BoneIndices': VertexMesh.MESH_BLENDINDICES0};
			var uniformMap:Object = {
				'u_Bones':Shader3D.PERIOD_CUSTOM, 
				'u_MvpMatrix': Shader3D.PERIOD_SPRITE, 
				'u_PickColor': Shader3D.PERIOD_SPRITE};
			var vs:String = __INCLUDESTR__("shader/MeshPick.vs");
			var ps:String = __INCLUDESTR__("shader/MeshPick.ps");
			
			var subShader:SubShader = new SubShader(attributeMap, uniformMap,SkinnedMeshSprite3D.shaderDefines);
			shader.addSubShader(subShader);
			subShader.setFlag(PICK_SHADER_FLAG, "MESH");
			subShader.addShaderPass(vs,ps);
			
			
			attributeMap = {
				'a_CornerTextureCoordinate': VertexShuriKenParticle.PARTICLE_CORNERTEXTURECOORDINATE0, 
				'a_MeshPosition': VertexShuriKenParticle.PARTICLE_POSITION0,
				'a_MeshColor': VertexShuriKenParticle.PARTICLE_COLOR0, 
				'a_MeshTextureCoordinate': VertexShuriKenParticle.PARTICLE_TEXTURECOORDINATE0,
				'a_ShapePositionStartLifeTime': VertexShuriKenParticle.PARTICLE_SHAPEPOSITIONSTARTLIFETIME, 
				'a_DirectionTime': VertexShuriKenParticle.PARTICLE_DIRECTIONTIME, 
				'a_StartColor': VertexShuriKenParticle.PARTICLE_STARTCOLOR0, 
				'a_EndColor': VertexShuriKenParticle.PARTICLE_ENDCOLOR0, 
				'a_StartSize': VertexShuriKenParticle.PARTICLE_STARTSIZE, 
				'a_StartRotation0': VertexShuriKenParticle.PARTICLE_STARTROTATION, 
				'a_StartSpeed': VertexShuriKenParticle.PARTICLE_STARTSPEED, 
				'a_Random0': VertexShuriKenParticle.PARTICLE_RANDOM0, 
				'a_Random1': VertexShuriKenParticle.PARTICLE_RANDOM1, 
				'a_SimulationWorldPostion': VertexShuriKenParticle.PARTICLE_SIMULATIONWORLDPOSTION,
				'a_SimulationWorldRotation': VertexShuriKenParticle.PARTICLE_SIMULATIONWORLDROTATION};
			uniformMap = {
				'u_Tintcolor': Shader3D.PERIOD_MATERIAL, 
				'u_TilingOffset': Shader3D.PERIOD_MATERIAL,
				'u_texture':Shader3D.PERIOD_MATERIAL, 
				'u_WorldPosition': Shader3D.PERIOD_SPRITE, 
				'u_WorldRotation': Shader3D.PERIOD_SPRITE, 
				'u_PositionScale':Shader3D.PERIOD_SPRITE, 
				'u_SizeScale':Shader3D.PERIOD_SPRITE, 
				'u_ScalingMode': Shader3D.PERIOD_SPRITE, 
				'u_Gravity':Shader3D.PERIOD_SPRITE, 
				'u_ThreeDStartRotation': Shader3D.PERIOD_SPRITE, 
				'u_StretchedBillboardLengthScale':Shader3D.PERIOD_SPRITE, 
				'u_StretchedBillboardSpeedScale': Shader3D.PERIOD_SPRITE, 
				'u_SimulationSpace': Shader3D.PERIOD_SPRITE, 
				'u_CurrentTime':Shader3D.PERIOD_SPRITE, 
				'u_ColorOverLifeGradientAlphas':  Shader3D.PERIOD_SPRITE, 
				'u_ColorOverLifeGradientColors':Shader3D.PERIOD_SPRITE, 
				'u_MaxColorOverLifeGradientAlphas':  Shader3D.PERIOD_SPRITE, 
				'u_MaxColorOverLifeGradientColors':  Shader3D.PERIOD_SPRITE, 
				'u_VOLVelocityConst':  Shader3D.PERIOD_SPRITE,
				'u_VOLVelocityGradientX': Shader3D.PERIOD_SPRITE, 
				'u_VOLVelocityGradientY': Shader3D.PERIOD_SPRITE, 
				'u_VOLVelocityGradientZ': Shader3D.PERIOD_SPRITE, 
				'u_VOLVelocityConstMax': Shader3D.PERIOD_SPRITE, 
				'u_VOLVelocityGradientMaxX':  Shader3D.PERIOD_SPRITE, 
				'u_VOLVelocityGradientMaxY':  Shader3D.PERIOD_SPRITE, 
				'u_VOLVelocityGradientMaxZ': Shader3D.PERIOD_SPRITE, 
				'u_VOLSpaceType': Shader3D.PERIOD_SPRITE, 
				'u_SOLSizeGradient': Shader3D.PERIOD_SPRITE, 
				'u_SOLSizeGradientX':Shader3D.PERIOD_SPRITE, 
				'u_SOLSizeGradientY': Shader3D.PERIOD_SPRITE, 
				'u_SOLSizeGradientZ':Shader3D.PERIOD_SPRITE, 
				'u_SOLSizeGradientMax':  Shader3D.PERIOD_SPRITE, 
				'u_SOLSizeGradientMaxX':  Shader3D.PERIOD_SPRITE, 
				'u_SOLSizeGradientMaxY': Shader3D.PERIOD_SPRITE, 
				'u_SOLSizeGradientMaxZ': Shader3D.PERIOD_SPRITE, 
				'u_ROLAngularVelocityConst': Shader3D.PERIOD_SPRITE, 
				'u_ROLAngularVelocityConstSeprarate':  Shader3D.PERIOD_SPRITE, 
				'u_ROLAngularVelocityGradient': Shader3D.PERIOD_SPRITE, 
				'u_ROLAngularVelocityGradientX': Shader3D.PERIOD_SPRITE, 
				'u_ROLAngularVelocityGradientY': Shader3D.PERIOD_SPRITE, 
				'u_ROLAngularVelocityGradientZ': Shader3D.PERIOD_SPRITE, 
				'u_ROLAngularVelocityConstMax': Shader3D.PERIOD_SPRITE, 
				'u_ROLAngularVelocityConstMaxSeprarate':  Shader3D.PERIOD_SPRITE, 
				'u_ROLAngularVelocityGradientMax':  Shader3D.PERIOD_SPRITE, 
				'u_ROLAngularVelocityGradientMaxX':Shader3D.PERIOD_SPRITE, 
				'u_ROLAngularVelocityGradientMaxY': Shader3D.PERIOD_SPRITE, 
				'u_ROLAngularVelocityGradientMaxZ': Shader3D.PERIOD_SPRITE,
				'u_ROLAngularVelocityGradientMaxW': Shader3D.PERIOD_SPRITE, 
				'u_TSACycles':  Shader3D.PERIOD_SPRITE, 
				'u_TSASubUVLength':  Shader3D.PERIOD_SPRITE, 
				'u_TSAGradientUVs': Shader3D.PERIOD_SPRITE, 
				'u_TSAMaxGradientUVs': Shader3D.PERIOD_SPRITE,
				'u_PickColor': Shader3D.PERIOD_SPRITE,
				'u_CameraPosition':Shader3D.PERIOD_CAMERA, 
				'u_CameraDirection': Shader3D.PERIOD_CAMERA, 
				'u_CameraUp': Shader3D.PERIOD_CAMERA, 
				'u_View':  Shader3D.PERIOD_CAMERA, 
				'u_Projection':  Shader3D.PERIOD_CAMERA,
				'u_FogStart': Shader3D.PERIOD_SCENE, 
				'u_FogRange':  Shader3D.PERIOD_SCENE, 
				'u_FogColor':  Shader3D.PERIOD_SCENE};
			vs = __INCLUDESTR__("shader/ParticleShuriKenPick.vs");
			ps = __INCLUDESTR__("shader/ParticleShuriKenPick.ps");
			subShader = new SubShader(attributeMap, uniformMap,ShuriKenParticle3D.shaderDefines,ShurikenParticleMaterial.shaderDefines);
			shader.addSubShader(subShader);
			subShader.setFlag(PICK_SHADER_FLAG, "PARTICLE");
			subShader.addShaderPass(vs,ps);
			
			
			Shader3D.find("BLINNPHONG").getSubShaderAt(0).setFlag(PICK_SHADER_FLAG, "MESH");
			Shader3D.find("PARTICLESHURIKEN").getSubShaderAt(0).setFlag(PICK_SHADER_FLAG, "PARTICLE");
		}
		
		public function PickShader() {
		
		}
	
	}

}