
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var AnimationPlayer=laya.ani.AnimationPlayer,AnimationState=laya.ani.AnimationState,AtlasResourceManager=laya.webgl.atlas.AtlasResourceManager;
	var Buffer=laya.webgl.utils.Buffer,Buffer2D=laya.webgl.utils.Buffer2D,Byte=laya.utils.Byte,ClassUtils=laya.utils.ClassUtils;
	var EmitterBase=laya.particle.emitter.EmitterBase,Event=laya.events.Event,EventDispatcher=laya.events.EventDispatcher;
	var Handler=laya.utils.Handler,IndexBuffer2D=laya.webgl.utils.IndexBuffer2D,KeyframesAniTemplet=laya.ani.KeyframesAniTemplet;
	var Loader=laya.net.Loader,Node=laya.display.Node,ParticleSettings=laya.particle.ParticleSettings,ParticleShader=laya.particle.shader.ParticleShader;
	var ParticleTemplateWebGL=laya.particle.ParticleTemplateWebGL,Rectangle=laya.maths.Rectangle,Render=laya.renders.Render;
	var RenderContext=laya.renders.RenderContext,RenderSprite=laya.renders.RenderSprite,RenderState2D=laya.webgl.utils.RenderState2D;
	var Resource=laya.resource.Resource,RunDriver=laya.utils.RunDriver,Shader=laya.webgl.shader.Shader,ShaderDefines=laya.webgl.shader.ShaderDefines;
	var Sprite=laya.display.Sprite,Stat=laya.utils.Stat,Texture=laya.resource.Texture,URL=laya.net.URL,ValusArray=laya.webgl.utils.ValusArray;
	var VertexBuffer2D=laya.webgl.utils.VertexBuffer2D,WebGL=laya.webgl.WebGL,WebGLContext=laya.webgl.WebGLContext;
	var WebGLContext2D=laya.webgl.canvas.WebGLContext2D,WebGLImage=laya.webgl.resource.WebGLImage,WebGLImageCube=laya.webgl.resource.WebGLImageCube;
	var WebGLRenderTarget=laya.webgl.resource.WebGLRenderTarget;
	Laya.interface('laya.d3.graphics.IVertex');
	Laya.interface('laya.d3.core.render.IUpdate');
	Laya.interface('laya.d3.core.render.IRenderable');
	/**
	*<code>Glitter</code> 类用于创建闪光配置信息。
	*/
	//class laya.d3.core.glitter.GlitterSettings
	var GlitterSettings=(function(){
		function GlitterSettings(){
			this.texturePath=null;
			this.lifeTime=0.5;
			this.minSegmentDistance=0.1;
			this.minInterpDistance=0.6;
			this.maxSlerpCount=128;
			this.maxSegments=200;
			this.color=new Vector4(1.0,1.0,1.0,1.0);
		}

		__class(GlitterSettings,'laya.d3.core.glitter.GlitterSettings');
		return GlitterSettings;
	})()


	/**
	*<code>SplineCurvePositionVelocity</code> 类用于通过顶点和速度创建闪光插值。
	*/
	//class laya.d3.core.glitter.SplineCurvePositionVelocity
	var SplineCurvePositionVelocity=(function(){
		function SplineCurvePositionVelocity(){
			this._tempVector30=new Vector3();
			this._tempVector31=new Vector3();
			this._tempVector32=new Vector3();
			this._a=new Vector3();
			this._b=new Vector3();
			this._c=new Vector3();
			this._d=new Vector3();
		}

		__class(SplineCurvePositionVelocity,'laya.d3.core.glitter.SplineCurvePositionVelocity');
		var __proto=SplineCurvePositionVelocity.prototype;
		/**
		*初始化插值所需信息。
		*@param position0 顶点0的位置。
		*@param velocity0 顶点0的速度。
		*@param position1 顶点1的位置。
		*@param velocity1 顶点1的速度。
		*/
		__proto.Init=function(position0,velocity0,position1,velocity1){
			position0.cloneTo(this._d);
			velocity0.cloneTo(this._c);
			Vector3.scale(position0,2.0,this._a);
			Vector3.scale(position1,2.0,this._tempVector30);
			Vector3.subtract(this._a,this._tempVector30,this._a);
			Vector3.add(this._a,velocity0,this._a);
			Vector3.add(this._a,velocity1,this._a);
			Vector3.scale(position1,3.0,this._b);
			Vector3.scale(position0,3.0,this._tempVector30);
			Vector3.subtract(this._b,this._tempVector30,this._b);
			Vector3.subtract(this._b,velocity1,this._b);
			Vector3.scale(velocity0,2.0,this._tempVector30);
			Vector3.subtract(this._b,this._tempVector30,this._b);
		}

		/**
		*初始化插值所需信息。
		*@param t 插值比例
		*@param out 输出结果
		*/
		__proto.Slerp=function(t,out){
			Vector3.scale(this._a,t *t *t,this._tempVector30);
			Vector3.scale(this._b,t *t,this._tempVector31);
			Vector3.scale(this._c,t,this._tempVector32);
			Vector3.add(this._tempVector30,this._tempVector31,out);
			Vector3.add(out,this._tempVector32,out);
			Vector3.add(out,this._d,out);
		}

		return SplineCurvePositionVelocity;
	})()


	/**
	*<code>HeightMap</code> 类用于实现高度图数据。
	*/
	//class laya.d3.core.HeightMap
	var HeightMap=(function(){
		function HeightMap(width,height,maxHeight){
			this._datas=null;
			this._w=0;
			this._h=0;
			this._maxHeight=NaN;
			this._datas=[];
			this._w=width;
			this._h=height;
			this._maxHeight=maxHeight;
		}

		__class(HeightMap,'laya.d3.core.HeightMap');
		var __proto=HeightMap.prototype;
		/**@private */
		__proto._inBounds=function(row,col){
			return row >=0 && row < this._h && col >=0 && col < this._w;
		}

		/**
		*获取高度。
		*@param row 列数。
		*@param col 行数。
		*@return 高度。
		*/
		__proto.getHeight=function(row,col){
			if (this._inBounds(row,col))
				return this._datas[row][col];
			else
			return 0;
		}

		/**
		*获取宽度。
		*@return value 宽度。
		*/
		__getset(0,__proto,'width',function(){
			return this._w;
		});

		/**
		*获取高度。
		*@return value 高度。
		*/
		__getset(0,__proto,'height',function(){
			return this._h;
		});

		/**
		*最大高度。
		*@return value 最大高度。
		*/
		__getset(0,__proto,'maxHeight',function(){
			return this._maxHeight;
		});

		HeightMap.creatFromMesh=function(mesh,width,height,outCellSize){
			var vertices=[];
			var indexs=[];
			var submesheCount=mesh.getSubMeshCount();
			for (var i=0;i < submesheCount;i++){
				var subMesh=mesh.getSubMesh(i);
				var vertexBuffer=subMesh.getVertexBuffer();
				var verts=vertexBuffer.getData();
				var subMeshVertices=[];
				for (var j=0;j < verts.length;j+=vertexBuffer.vertexDeclaration.vertexStride / 4){
					var position=new Vector3(verts[j+0],verts[j+1],verts[j+2]);
					subMeshVertices.push(position);
				}
				vertices.push(subMeshVertices);
				var ib=subMesh.getIndexBuffer();
				indexs.push(ib.getData());
			};
			var boundingBox=mesh.boundingBox;
			var minX=boundingBox.min.x;
			var minZ=boundingBox.min.z;
			var maxX=boundingBox.max.x;
			var maxZ=boundingBox.max.z;
			var maxY=boundingBox.max.y;
			var widthSize=maxX-minX;
			var heightSize=maxZ-minZ;
			var cellWidth=outCellSize.elements[0]=widthSize / (width-1);
			var cellHeight=outCellSize.elements[1]=heightSize / (height-1);
			var heightMap=new HeightMap(width,height,maxY);
			var ray=HeightMap._tempRay;
			var rayDirE=ray.direction.elements;
			rayDirE[0]=0;
			rayDirE[1]=-1;
			rayDirE[2]=0;
			var heightOffset=0.1;
			var rayY=maxY+heightOffset;
			ray.origin.elements[1]=rayY;
			for (var w=0;w < width;w++){
				var posZ=minZ+w *cellHeight;
				heightMap._datas[w]=[];
				for (var h=0;h < height;h++){
					var posX=minX+h *cellWidth;
					var rayOriE=ray.origin.elements;
					rayOriE[0]=posX;
					rayOriE[2]=posZ;
					var closestIntersection=HeightMap._getPosition(ray,vertices,indexs);
					heightMap._datas[w][h]=(closestIntersection===Number.MAX_VALUE)? NaN :rayY-closestIntersection;
				}
			}
			return heightMap;
		}

		HeightMap._getPosition=function(ray,vertices,indexs){
			var closestIntersection=Number.MAX_VALUE;
			for (var i=0;i < vertices.length;i++){
				var subMeshVertices=vertices[i];
				var subMeshIndexes=indexs[i];
				for (var j=0;j < subMeshIndexes.length;j+=3){
					var vertex1=subMeshVertices[subMeshIndexes[j+0]];
					var vertex2=subMeshVertices[subMeshIndexes[j+1]];
					var vertex3=subMeshVertices[subMeshIndexes[j+2]];
					var intersection=Picker.rayIntersectsTriangle(ray,vertex1,vertex2,vertex3);
					if (!isNaN(intersection)&& intersection < closestIntersection){
						closestIntersection=intersection;
					}
				}
			}
			return closestIntersection;
		}

		__static(HeightMap,
		['_tempRay',function(){return this._tempRay=new Ray(new Vector3(),new Vector3());}
		]);
		return HeightMap;
	})()


	/**
	*<code>Layer</code> 类用于实现遮罩层。
	*/
	//class laya.d3.core.Layer
	var Layer=(function(){
		function Layer(){
			this._id=0;
			this._number=0;
			this._mask=0;
			this._active=true;
			this._visible=true;
			this.name=null;
			this._id=Layer._uniqueIDCounter;
			Layer._uniqueIDCounter++;
			if (this._id > 1+31)
				throw new Error("不允许创建Layer，请参考函数getLayerByNumber、getLayerByMask、getLayerByName！");
		}

		__class(Layer,'laya.d3.core.Layer');
		var __proto=Layer.prototype;
		/**
		*获取编号。
		*@return 编号。
		*/
		__getset(0,__proto,'number',function(){
			return this._number;
		});

		/**
		*获取蒙版值。
		*@return 蒙版值。
		*/
		__getset(0,__proto,'mask',function(){
			return this._mask;
		});

		/**
		*设置是否激活。
		*@param value 是否激活。
		*/
		/**
		*获取是否激活。
		*@return 是否激活。
		*/
		__getset(0,__proto,'active',function(){
			return this._active;
			},function(value){
			if (this._number===29 || this._number==30)
				return;
			this._active=value;
			if (value)
				Layer._activeLayers=Layer._activeLayers | this.mask;
			else
			Layer._activeLayers=Layer._activeLayers & ~this.mask;
		});

		/**
		*设置是否显示。
		*@param value 是否显示。
		*/
		/**
		*获取是否显示。
		*@return 是否显示。
		*/
		__getset(0,__proto,'visible',function(){
			return this._visible;
			},function(value){
			if (this._number===29 || this._number==30)
				return;
			this._visible=value;
			if (value)
				Layer._visibleLayers=Layer._visibleLayers | this.mask;
			else
			Layer._visibleLayers=Layer._visibleLayers & ~this.mask;
		});

		/**
		*设置Layer激活层。
		*@param value 激活层。
		*/
		/**
		*获取Layer激活层。
		*@return 激活层。
		*/
		__getset(1,Layer,'activeLayers',function(){
			return Layer._activeLayers;
			},function(value){
			Layer._activeLayers=value | Layer.getLayerByNumber(29).mask | Layer.getLayerByNumber(30).mask;
			for (var i=0;i < Layer._layerList.length;i++){
				var layer=Layer._layerList[i];
				layer._active=(layer._mask & Layer._activeLayers)!==0;
			}
		});

		/**
		*设置Layer显示层。
		*@param value 显示层。
		*/
		/**
		*获取Layer显示层。
		*@return 显示层。
		*/
		__getset(1,Layer,'visibleLayers',function(){
			return Layer._visibleLayers;
			},function(value){
			Layer._visibleLayers=value | Layer.getLayerByNumber(29).mask | Layer.getLayerByNumber(30).mask;
			for (var i=0;i < Layer._layerList.length;i++){
				var layer=Layer._layerList[i];
				layer._visible=(layer._mask & Layer._visibleLayers)!==0;
			}
		});

		Layer.__init__=function(){
			Layer._layerList.length=31;
			for (var i=0;i < 31;i++){
				var layer=new Layer();
				Layer._layerList[i]=layer;
				if (i===0)
					layer.name="Default Layer";
				else if (i===29)
				layer.name="Reserved Layer0";
				else if (i===30)
				layer.name="Reserved Layer1";
				else
				layer.name="Layer-"+i;
				layer._number=i;
				layer._mask=Math.pow(2,i);
			}
			Layer._activeLayers=2147483647;
			Layer._visibleLayers=2147483647;
			Layer._currentCameraCullingMask=2147483647;
			Layer.currentCreationLayer=Layer._layerList[0];
		}

		Layer.getLayerByNumber=function(number){
			if (number < 0 || number > 30)
				throw new Error("无法返回指定Layer，该number超出范围！");
			return Layer._layerList[number];
		}

		Layer.getLayerByMask=function(mask){
			for (var i=0;i < 31;i++){
				if (Layer._layerList[i].mask===mask)
					return Layer._layerList[i];
			}
			throw new Error("无法返回指定Layer,该mask不存在");
		}

		Layer.getLayerByName=function(name){
			for (var i=0;i < 31;i++){
				if (Layer._layerList[i].name===name)
					return Layer._layerList[i];
			}
			throw new Error("无法返回指定Layer,该name不存在");
		}

		Layer.isActive=function(mask){
			return (mask & Layer._activeLayers)!=0;
		}

		Layer.isVisible=function(mask){
			return (mask & Layer._currentCameraCullingMask & Layer._visibleLayers)!=0;
		}

		Layer._uniqueIDCounter=1;
		Layer._layerCount=31;
		Layer._layerList=[];
		Layer._activeLayers=0;
		Layer._visibleLayers=0;
		Layer._currentCameraCullingMask=0;
		Layer.currentCreationLayer=null
		return Layer;
	})()


	/**
	*@private
	*<code>PhasorSpriter3D</code> 类用于创建矢量笔刷。
	*/
	//class laya.d3.core.PhasorSpriter3D
	var PhasorSpriter3D=(function(){
		function PhasorSpriter3D(){
			this._tempInt0=0;
			this._tempInt1=0;
			this._tempUint0=0;
			this._tempUint1=0;
			this._tempUint2=0;
			this._tempUint3=0;
			this._tempUint4=0;
			this._tempUint5=0;
			this._tempUint6=0;
			this._tempUint7=0;
			this._tempNumver0=NaN;
			this._tempNumver1=NaN;
			this._tempNumver2=NaN;
			this._tempNumver3=NaN;
			this._floatSizePerVer=7;
			this._defaultBufferSize=600 *this._floatSizePerVer;
			this._vb=null;
			this._posInVBData=0;
			this._ib=null;
			this._posInIBData=0;
			this._primitiveType=NaN;
			this._hasBegun=false;
			this._numVertsPerPrimitive=0;
			this._renderState=null;
			this._sharderNameID=0;
			this._shader=null;
			this._posShaderValue=[3,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,28,0];
			this._colorShaderValue=[4,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,28,12];
			this._vbData=new Float32Array(this._defaultBufferSize);
			this._ibData=new Uint16Array(this._defaultBufferSize);
			this._wvpMatrix=new Matrix4x4();
			;
			this._vb=new VertexBuffer2D(-1,/*laya.webgl.WebGLContext.DYNAMIC_DRAW*/0x88E8);
			this._ib=new IndexBuffer2D();
			this._sharderNameID=Shader.nameKey.get("SIMPLE");
		}

		__class(PhasorSpriter3D,'laya.d3.core.PhasorSpriter3D');
		var __proto=PhasorSpriter3D.prototype;
		__proto.line=function(startX,startY,startZ,startR,startG,startB,startA,endX,endY,endZ,endR,endG,endB,endA){
			if (!this._hasBegun || this._primitiveType!==/*laya.webgl.WebGLContext.LINES*/0x0001)
				this.drawLinesException();
			if (this._posInVBData+2 *this._floatSizePerVer > this._vbData.length || this._posInIBData+2 > this._ibData.length)
				this.flush();
			this._tempUint0=this._posInVBData / this._floatSizePerVer;
			this.addVertex(startX,startY,startZ,startR,startG,startB,startA);
			this.addVertex(endX,endY,endZ,endR,endG,endB,endA);
			this.addIndexes(this._tempUint0,this._tempUint0+1);
			return this;
		}

		__proto.circle=function(radius,numberOfPoints,r,g,b,a){
			if (!this._hasBegun || (this._primitiveType!==/*laya.webgl.WebGLContext.LINES*/0x0001))
				this.drawLinesException();
			this._tempUint0=numberOfPoints *2;
			if (this._posInVBData+this._tempUint0 *this._floatSizePerVer > this._vbData.length || this._posInIBData+2 *this._tempUint0 > this._ibData.length)
				this.flush();
			this._tempUint1=this._posInVBData / this._floatSizePerVer;
			for (this._tempNumver0=0,this._tempInt0=0;this._tempNumver0 < 3.1416 *2;this._tempNumver0=this._tempNumver0+(3.1416 / numberOfPoints),this._tempInt0++){
				this.addVertex(Math.sin(this._tempNumver0)*radius,Math.cos(this._tempNumver0)*radius,0,r,g,b,a);
				if (this._tempInt0===0){
					this.addIndexes(this._tempUint1);
					}else if (this._tempInt0===this._tempUint0-1){
					this._tempUint2=this._tempUint1+this._tempInt0;
					this.addIndexes(this._tempUint2,this._tempUint2,this._tempUint1);
					}else {
					this._tempUint2=this._tempUint1+this._tempInt0;
					this.addIndexes(this._tempUint2,this._tempUint2);
				}
			}
			return this;
		}

		__proto.plane=function(positionX,positionY,positionZ,width,height,r,g,b,a){
			if (!this._hasBegun || this._primitiveType!==/*laya.webgl.WebGLContext.TRIANGLES*/0x0004)
				this.drawTrianglesException();
			if (this._posInVBData+4 *this._floatSizePerVer > this._vbData.length || this._posInIBData+6 > this._ibData.length)
				this.flush();
			this._tempNumver0=width / 2;
			this._tempNumver1=height / 2;
			this._tempUint0=this._posInVBData / this._floatSizePerVer;
			this.addVertex(positionX-this._tempNumver0,positionY+this._tempNumver1,positionZ,r,g,b,a);
			this.addVertex(positionX+this._tempNumver0,positionY+this._tempNumver1,positionZ,r,g,b,a);
			this.addVertex(positionX-this._tempNumver0,positionY-this._tempNumver1,positionZ,r,g,b,a);
			this.addVertex(positionX+this._tempNumver0,positionY-this._tempNumver1,positionZ,r,g,b,a);
			this._tempUint1=this._tempUint0+1;
			this._tempUint2=this._tempUint0+2;
			this.addIndexes(this._tempUint0,this._tempUint1,this._tempUint2,this._tempUint2,this._tempUint1,this._tempUint0+3);
			return this;
		}

		__proto.box=function(positionX,positionY,positionZ,width,height,depth,r,g,b,a){
			if (!this._hasBegun || this._primitiveType!==/*laya.webgl.WebGLContext.TRIANGLES*/0x0004)
				this.drawTrianglesException();
			if (this._posInVBData+8 *this._floatSizePerVer > this._vbData.length || this._posInIBData+36 > this._ibData.length)
				this.flush();
			this._tempNumver0=width / 2;
			this._tempNumver1=height / 2;
			this._tempNumver2=depth / 2;
			this._tempUint0=this._posInVBData / this._floatSizePerVer;
			this.addVertex(positionX-this._tempNumver0,positionY+this._tempNumver1,positionZ+this._tempNumver2,r,g,b,a);
			this.addVertex(positionX+this._tempNumver0,positionY+this._tempNumver1,positionZ+this._tempNumver2,r,g,b,a);
			this.addVertex(positionX-this._tempNumver0,positionY-this._tempNumver1,positionZ+this._tempNumver2,r,g,b,a);
			this.addVertex(positionX+this._tempNumver0,positionY-this._tempNumver1,positionZ+this._tempNumver2,r,g,b,a);
			this.addVertex(positionX+this._tempNumver0,positionY+this._tempNumver1,positionZ-this._tempNumver2,r,g,b,a);
			this.addVertex(positionX-this._tempNumver0,positionY+this._tempNumver1,positionZ-this._tempNumver2,r,g,b,a);
			this.addVertex(positionX+this._tempNumver0,positionY-this._tempNumver1,positionZ-this._tempNumver2,r,g,b,a);
			this.addVertex(positionX-this._tempNumver0,positionY-this._tempNumver1,positionZ-this._tempNumver2,r,g,b,a);
			this._tempUint1=this._tempUint0+1;
			this._tempUint2=this._tempUint0+2;
			this._tempUint3=this._tempUint0+3;
			this._tempUint4=this._tempUint0+4;
			this._tempUint5=this._tempUint0+5;
			this._tempUint6=this._tempUint0+6;
			this._tempUint7=this._tempUint0+7;
			this.addIndexes(this._tempUint0,this._tempUint1,this._tempUint2,this._tempUint2,this._tempUint1,this._tempUint3,
			this._tempUint4,this._tempUint5,this._tempUint6,this._tempUint6,this._tempUint5,this._tempUint7,
			this._tempUint5,this._tempUint0,this._tempUint7,this._tempUint7,this._tempUint0,this._tempUint2,
			this._tempUint1,this._tempUint4,this._tempUint3,this._tempUint3,this._tempUint4,this._tempUint6,
			this._tempUint5,this._tempUint4,this._tempUint0,this._tempUint0,this._tempUint4,this._tempUint1,
			this._tempUint2,this._tempUint3,this._tempUint7,this._tempUint7,this._tempUint3,this._tempUint6);
			return this;
		}

		__proto.cone=function(radius,length,Slices,r,g,b,a){
			if (!this._hasBegun || this._primitiveType!==/*laya.webgl.WebGLContext.TRIANGLES*/0x0004)
				this.drawTrianglesException();
			if (this._posInVBData+(2 *Slices+2)*this._floatSizePerVer > this._vbData.length || this._posInIBData+6 *Slices > this._ibData.length)
				this.flush();
			this._tempUint0=this._posInVBData;
			this._tempUint1=this._posInVBData / this._floatSizePerVer;
			this._tempNumver0=Math.PI *2 / Slices;
			this.addVertexIndex(0,length,0,r,g,b,a,this._tempUint0);
			this.addVertexIndex(0,0,0,r,g,b,a,this._tempUint0+this._floatSizePerVer);
			this._tempInt0=2;
			this._tempNumver1=0;
			for (this._tempInt1=0;this._tempInt1 < Slices;this._tempInt1++){
				this._tempNumver2=Math.cos(this._tempNumver1);
				this._tempNumver3=Math.sin(this._tempNumver1);
				this.addVertexIndex(radius *this._tempNumver2,0,radius *this._tempNumver3,r,g,b,a,this._tempUint0+this._tempInt0 *this._floatSizePerVer);
				this.addIndexes(this._tempUint1,this._tempUint1+this._tempInt0);
				if (this._tempInt1==Slices-1)
					this.addIndexes(this._tempUint1+2);
				else
				this.addIndexes(this._tempUint1+this._tempInt0+1);
				this.addVertexIndex(radius *this._tempNumver2,0,radius *this._tempNumver3,r,g,b,a,this._tempUint0+(this._tempInt0+Slices)*this._floatSizePerVer);
				this.addIndexes(this._tempUint1+1);
				if (this._tempInt1==Slices-1)
					this.addIndexes(this._tempUint1+Slices+2);
				else
				this.addIndexes(this._tempUint1+this._tempInt0+Slices+1);
				this.addIndexes(this._tempUint1+this._tempInt0+Slices);
				this._tempInt0++;
				this._tempNumver1+=this._tempNumver0;
			}
			return this;
		}

		__proto.boudningBoxLine=function(minX,minY,minZ,maxX,maxY,maxZ,r,g,b,a){
			if (!this._hasBegun || this._primitiveType!==/*laya.webgl.WebGLContext.LINES*/0x0001)
				this.drawLinesException();
			if (this._posInVBData+8 *this._floatSizePerVer > this._vbData.length || this._posInIBData+48 > this._ibData.length)
				this.flush();
			this._tempUint0=this._posInVBData / this._floatSizePerVer;
			this.addVertex(minX,maxY,maxZ,r,g,b,a);
			this.addVertex(maxX,maxY,maxZ,r,g,b,a);
			this.addVertex(minX,minY,maxZ,r,g,b,a);
			this.addVertex(maxX,minY,maxZ,r,g,b,a);
			this.addVertex(maxX,maxY,minZ,r,g,b,a);
			this.addVertex(minX,maxY,minZ,r,g,b,a);
			this.addVertex(maxX,minY,minZ,r,g,b,a);
			this.addVertex(minX,minY,minZ,r,g,b,a);
			this._tempUint1=this._tempUint0+1;
			this._tempUint2=this._tempUint0+2;
			this._tempUint3=this._tempUint0+3;
			this._tempUint4=this._tempUint0+4;
			this._tempUint5=this._tempUint0+5;
			this._tempUint6=this._tempUint0+6;
			this._tempUint7=this._tempUint0+7;
			this.addIndexes(this._tempUint0,this._tempUint1,this._tempUint1,this._tempUint3,this._tempUint3,this._tempUint2,this._tempUint2,this._tempUint0,
			this._tempUint4,this._tempUint5,this._tempUint5,this._tempUint7,this._tempUint7,this._tempUint6,this._tempUint6,this._tempUint4,
			this._tempUint5,this._tempUint0,this._tempUint0,this._tempUint2,this._tempUint2,this._tempUint7,this._tempUint7,this._tempUint5,
			this._tempUint1,this._tempUint4,this._tempUint4,this._tempUint6,this._tempUint6,this._tempUint3,this._tempUint3,this._tempUint1,
			this._tempUint5,this._tempUint4,this._tempUint4,this._tempUint1,this._tempUint1,this._tempUint0,this._tempUint0,this._tempUint5,
			this._tempUint2,this._tempUint3,this._tempUint3,this._tempUint6,this._tempUint6,this._tempUint7,this._tempUint7,this._tempUint2);
			return this;
		}

		__proto.addVertex=function(x,y,z,r,g,b,a){
			if (!this._hasBegun)
				this.addVertexIndexException();
			this._vbData[this._posInVBData]=x,this._vbData[this._posInVBData+1]=y,this._vbData[this._posInVBData+2]=z;
			this._vbData[this._posInVBData+3]=r,this._vbData[this._posInVBData+4]=g,this._vbData[this._posInVBData+5]=b,this._vbData[this._posInVBData+6]=a;
			this._posInVBData+=this._floatSizePerVer;
			return this;
		}

		__proto.addVertexIndex=function(x,y,z,r,g,b,a,index){
			if (!this._hasBegun)
				this.addVertexIndexException();
			this._vbData[index]=x,this._vbData[index+1]=y,this._vbData[index+2]=z;
			this._vbData[index+3]=r,this._vbData[index+4]=g,this._vbData[index+5]=b,this._vbData[index+6]=a;
			index+=this._floatSizePerVer;
			if (index > this._posInVBData)
				this._posInVBData=index;
			return this;
		}

		__proto.addIndexes=function(__indexes){
			var indexes=arguments;
			if (!this._hasBegun)
				this.addVertexIndexException();
			for (var i=0;i < indexes.length;i++){
				this._ibData[this._posInIBData]=indexes[i];
				this._posInIBData++;
			}
			return this;
		}

		__proto.begin=function(primitive,wvpMatrix,renState){
			if (this._hasBegun)
				this.beginException0();
			if (primitive!==/*laya.webgl.WebGLContext.LINES*/0x0001 && primitive!==/*laya.webgl.WebGLContext.TRIANGLES*/0x0004)
				this.beginException1();
			this._primitiveType=primitive;
			this._wvpMatrix=wvpMatrix;
			this._renderState=renState;
			this._hasBegun=true;
			return this;
		}

		__proto.end=function(){
			if (!this._hasBegun)
				this.endException();
			this.flush();
			this._hasBegun=false;
			return this;
		}

		__proto.flush=function(){
			if (this._posInVBData===0)
				return;
			this._ib.clear();
			this._ib.append(this._ibData);
			this._vb.clear();
			this._vb.append(this._vbData);
			this._vb.bind_upload(this._ib);
			var presz=this._renderState.shaderValue.length;
			var predef=this._renderState.shaderDefs.getValue();
			this._shader=this.getShader(this._renderState);
			this._renderState.shaderValue.pushValue(/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION",this._posShaderValue,-1);
			this._renderState.shaderValue.pushValue(/*laya.d3.graphics.VertexElementUsage.COLOR0*/"COLOR",this._colorShaderValue,-1);
			this._renderState.shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.MVPMATRIX*/"MVPMATRIX",this._wvpMatrix.elements,-1);
			this._renderState.shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.LUMINANCE*/"LUMINANCE",1.0,-1);
			this._shader.uploadArray(this._renderState.shaderValue.data,this._renderState.shaderValue.length,null);
			this._renderState.shaderDefs.setValue(predef);
			this._renderState.shaderValue.length=presz;
			Stat.drawCall++;
			WebGL.mainContext.drawElements(this._primitiveType,this._posInIBData,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,0);
			this._posInIBData=0;
			this._posInVBData=0;
		}

		__proto.getShader=function(state){
			var preDef=state.shaderDefs._value;
			state.shaderDefs._value=preDef & (~(/*laya.d3.shader.ShaderDefines3D.POINTLIGHT*/0x80 | /*laya.d3.shader.ShaderDefines3D.SPOTLIGHT*/0x100 | /*laya.d3.shader.ShaderDefines3D.DIRECTIONLIGHT*/0x40));
			state.shaderDefs.add(/*laya.d3.shader.ShaderDefines3D.COLOR*/0x20);
			var nameID=state.shaderDefs.getValue()| state.shadingMode+this._sharderNameID */*laya.webgl.shader.Shader.SHADERNAME2ID*/0.0002;
			var shader=this._shader ? this._shader :Shader.getShader(nameID);
			return shader || (shader=Shader.withCompile(this._sharderNameID,state.shadingMode,state.shaderDefs.toNameDic(),nameID,null));
		}

		__proto.addVertexIndexException=function(){
			throw new Error("请先调用begin()函数");
		}

		__proto.beginException0=function(){
			throw new Error("调用begin()前请确保已成功调用end()！");
		}

		__proto.beginException1=function(){
			throw new Error("只支持“LINES”和“TRIANGLES”两种基元！");
		}

		__proto.endException=function(){
			throw new Error("调用end()前请确保已成功调用begin()！");
		}

		__proto.drawLinesException=function(){
			throw new Error("您必须确保在此之前已调用bengin()且使用“LINES”基元！");
		}

		__proto.drawTrianglesException=function(){
			throw new Error("您必须确保在此之前已调用bengin()且使用“TRIANGLES”基元！");
		}

		return PhasorSpriter3D;
	})()


	/**
	*<code>RenderClip</code> 类用于实现渲染裁剪。
	*/
	//class laya.d3.core.render.RenderClip
	var RenderClip=(function(){
		/**
		*创建一个 <code>RenderClip</code> 实例。
		*/
		function RenderClip(){}
		__class(RenderClip,'laya.d3.core.render.RenderClip');
		var __proto=RenderClip.prototype;
		/**
		*处理3D物理是否可见。
		*@param o 3D精灵。
		*/
		__proto.view=function(o){
			return true;
		}

		return RenderClip;
	})()


	/**
	*<code>RenderConfig</code> 类用于实现渲染配置。
	*/
	//class laya.d3.core.render.RenderConfig
	var RenderConfig=(function(){
		function RenderConfig(){
			this.depthTest=true;
			this.depthMask=1;
			this.blend=false;
			this.cullFace=true;
			this.sFactor=/*laya.webgl.WebGLContext.ONE*/1;
			this.dFactor=/*laya.webgl.WebGLContext.ZERO*/0;
			this.frontFace=/*laya.webgl.WebGLContext.CW*/0x0900;
		}

		__class(RenderConfig,'laya.d3.core.render.RenderConfig');
		return RenderConfig;
	})()


	/**
	*<code>RenderObject</code> 类用于实现渲染物体。
	*/
	//class laya.d3.core.render.RenderObject
	var RenderObject=(function(){
		function RenderObject(){
			this.renderQneue=null;
			this.type=0;
			this.owner=null;
			this.renderElement=null;
			this.material=null;
			this.tag=null;
			this.mainSortID=0;
			this.triangleCount=0;
		}

		__class(RenderObject,'laya.d3.core.render.RenderObject');
		return RenderObject;
	})()


	/**
	*<code>RenderQuene</code> 类用于实现渲染队列。
	*/
	//class laya.d3.core.render.RenderQueue
	var RenderQueue=(function(){
		function RenderQueue(renderConfig){
			this._id=0;
			this._changed=false;
			this._needSort=false;
			this._renderObjects=null;
			this._staticRenderObjects=null;
			this._staticLength=0;
			this._mergeRenderObjects=null;
			this._merageLength=0;
			this._renderConfig=null;
			this._staticBatchManager=null;
			this._id=++RenderQueue._uniqueIDCounter;
			this._changed=false;
			this._needSort=false;
			this._renderConfig=renderConfig;
			this._renderObjects=[];
			this._staticRenderObjects=[];
			this._staticLength=0;
			this._mergeRenderObjects=[];
			this._merageLength=0;
			this._staticBatchManager=new StaticBatchManager();
		}

		__class(RenderQueue,'laya.d3.core.render.RenderQueue');
		var __proto=RenderQueue.prototype;
		__proto._getStaticRenderObj=function(){
			var o=this._staticRenderObjects[this._staticLength++];
			return o || (this._staticRenderObjects[this._staticLength-1]=new RenderObject());
		}

		/**
		*重置并清空队列。
		*/
		__proto._reset=function(){
			this._staticLength=0;
			this._merageLength=0;
			this._staticBatchManager._reset();
		}

		/**
		*@private
		*更新组件preRenderUpdate函数
		*@param state 渲染相关状态
		*/
		__proto._preRenderUpdateComponents=function(sprite3D,state){
			for (var i=0;i < sprite3D.componentsCount;i++){
				var component=sprite3D.getComponentByIndex(i);
				(!component.started)&& (component._start(state),component.started=true);
				(component.isActive)&& (component._preRenderUpdate(state));
			}
		}

		/**
		*@private
		*更新组件postRenderUpdate函数
		*@param state 渲染相关状态
		*/
		__proto._postRenderUpdateComponents=function(sprite3D,state){
			for (var i=0;i < sprite3D.componentsCount;i++){
				var component=sprite3D.getComponentByIndex(i);
				(!component.started)&& (component._start(state),component.started=true);
				(component.isActive)&& (component._postRenderUpdate(state));
			}
		}

		/**
		*@private
		*应用渲染状态到显卡。
		*@param gl WebGL上下文。
		*/
		__proto._setState=function(gl){
			WebGLContext.setDepthTest(gl,this._renderConfig.depthTest);
			WebGLContext.setDepthMask(gl,this._renderConfig.depthMask);
			WebGLContext.setBlend(gl,this._renderConfig.blend);
			WebGLContext.setBlendFunc(gl,this._renderConfig.sFactor,this._renderConfig.dFactor);
			WebGLContext.setCullFace(gl,this._renderConfig.cullFace);
			WebGLContext.setFrontFaceCCW(gl,this._renderConfig.frontFace);
		}

		/**
		*@private
		*准备渲染队列。
		*@param state 渲染状态。
		*/
		__proto._preRender=function(state){
			if (this._changed){
				this._changed=false;
				this._reset();
				this._needSort && (this._renderObjects.sort(RenderQueue._sort));
				var lastIsStatic=false;
				var lastMaterial;
				var lastVertexDeclaration;
				var lastCanMerage=false;
				var curStaticBatch;
				var currentRenderObjIndex=0;
				var renderObj;
				var renderElement;
				var isStatic=false;
				var lastRenderObj;
				var batchObject;
				var vb;
				for (var i=0,n=this._renderObjects.length;i < n;i++){
					renderObj=this._renderObjects[i];
					renderElement=renderObj.renderElement;
					isStatic=renderObj.owner.isStatic;
					vb=renderElement.getVertexBuffer(0);
					if ((lastMaterial===renderObj.material)&& (lastVertexDeclaration===vb.vertexDeclaration)&& lastIsStatic && isStatic && (renderElement.VertexBufferCount===1)&& renderObj.owner.visible){
						if (!lastCanMerage){
							curStaticBatch=this._staticBatchManager.getStaticBatchQneue(lastVertexDeclaration,lastMaterial);
							lastRenderObj=this._renderObjects[i-1];
							if (!curStaticBatch.addRenderObj(lastRenderObj)|| !curStaticBatch.addRenderObj(renderObj)){
								this._mergeRenderObjects[this._merageLength++]=this._renderObjects[currentRenderObjIndex];
								lastCanMerage=false;
								}else {
								batchObject=this._getStaticRenderObj();
								batchObject.renderElement=curStaticBatch;
								batchObject.type=1;
								this._mergeRenderObjects[this._merageLength-1]=batchObject;
								lastCanMerage=true;
							}
							}else {
							if (!curStaticBatch.addRenderObj(renderObj)){
								this._mergeRenderObjects[this._merageLength++]=this._renderObjects[currentRenderObjIndex];
								lastCanMerage=false;
							}
						}
						}else {
						this._mergeRenderObjects[this._merageLength++]=this._renderObjects[currentRenderObjIndex];
						lastCanMerage=false;
					}
					currentRenderObjIndex++;
					lastIsStatic=isStatic;
					lastMaterial=renderObj.material;
					lastVertexDeclaration=vb.vertexDeclaration;
				}
				this._staticBatchManager._garbageCollection();
				this._staticBatchManager._finsh();
			}
		}

		/**
		*@private
		*渲染队列。
		*@param state 渲染状态。
		*/
		__proto._render=function(state){
			var preShaderValue=state.shaderValue.length;
			var renObj;
			for (var i=0,n=this._merageLength;i < n;i++){
				renObj=this._mergeRenderObjects[i];
				var preShadeDef=0;
				if (renObj.type===0){
					var owner=renObj.owner;
					state.owner=owner;
					state.renderObj=renObj;
					preShadeDef=state.shaderDefs.getValue();
					this._preRenderUpdateComponents(owner,state);
					(owner.visible)&& (renObj.renderElement._render(state));
					this._postRenderUpdateComponents(owner,state);
					state.shaderDefs.setValue(preShadeDef);
					}else if (renObj.type===1){
					state.owner=null;
					state.renderObj=renObj;
					preShadeDef=state.shaderDefs.getValue();
					(renObj.renderElement._render(state));
					state.shaderDefs.setValue(preShadeDef);
				}
				state.shaderValue.length=preShaderValue;
			}
		}

		/**
		*获取队列中的渲染物体。
		*@return gl 渲染物体。
		*/
		__proto.getRenderObj=function(){
			this._changed=true;
			this._needSort=true;
			var o=new RenderObject();
			this._renderObjects.push(o);
			o.renderQneue=this;
			return o;
		}

		/**
		*删除渲染物体。
		*@param renderObj 渲染物体。
		*/
		__proto.deleteRenderObj=function(renderObj){
			this._changed=true;
			var index=this._renderObjects.indexOf(renderObj);
			if (index!==-1){
				this._renderObjects.splice(index,1);
				renderObj.renderQneue=null;
			}
		}

		/**
		*获取唯一标识ID(通常用于优化或识别)。
		*/
		__getset(0,__proto,'id',function(){
			return this._id;
		});

		RenderQueue._sort=function(a,b){
			var id=a.mainSortID-b.mainSortID;
			return (a.owner.isStatic && b.owner.isStatic && id===0)? a.triangleCount-b.triangleCount :id;
		}

		RenderQueue._uniqueIDCounter=0;
		RenderQueue.NONEWRITEDEPTH=0;
		RenderQueue.OPAQUE=1;
		RenderQueue.OPAQUE_DOUBLEFACE=2;
		RenderQueue.ALPHA_BLEND=3;
		RenderQueue.ALPHA_BLEND_DOUBLEFACE=4;
		RenderQueue.ALPHA_ADDTIVE_BLEND=5;
		RenderQueue.ALPHA_ADDTIVE_BLEND_DOUBLEFACE=6;
		RenderQueue.DEPTHREAD_ALPHA_BLEND=7;
		RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE=8;
		RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND=9;
		RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE=10;
		return RenderQueue;
	})()


	/**
	*<code>RenderState</code> 类用于实现渲染状态。
	*/
	//class laya.d3.core.render.RenderState
	var RenderState=(function(){
		function RenderState(){
			this._shadingMode=0;
			this.elapsedTime=NaN;
			this.loopCount=0;
			this.context=null;
			this.scene=null;
			this.owner=null;
			this.renderObj=null;
			this.camera=null;
			this.viewMatrix=null;
			this.projectionMatrix=null;
			this.projectionViewMatrix=null;
			this.viewport=null;
			this.worldTransformModifyID=NaN;
			this.worldShaderValue=new ValusArray;
			this.shaderValue=new ValusArray;
			this.shaderDefs=new ShaderDefines3D();
			this.renderClip=new RenderClip();
			this.reset();
		}

		__class(RenderState,'laya.d3.core.render.RenderState');
		var __proto=RenderState.prototype;
		/**
		*重置。
		*/
		__proto.reset=function(){
			this.worldShaderValue.length=0;
			this.shaderValue.length=0;
			this.shaderDefs.setValue(0);
			(WebGL.frameShaderHighPrecision)&& (this.shaderDefs.setValue(/*laya.d3.shader.ShaderDefines3D.FSHIGHPRECISION*/0x100000));
		}

		/**
		*设置着色模式。
		*@param value 着色模式
		*/
		/**
		*获取着色模式。
		*@return 着色模式
		*/
		__getset(0,__proto,'shadingMode',function(){
			return this._shadingMode;
			},function(value){
			this.shaderDefs.remove(value==0x04 ? 0x08 :0x04);
			this.shaderDefs.add(value);
			this._shadingMode=value;
		});

		RenderState.VERTEXSHADERING=0x04;
		RenderState.PIXELSHADERING=0x08;
		RenderState.clientWidth=0;
		RenderState.clientHeight=0;
		return RenderState;
	})()


	/**
	*<code>Transform3D</code> 类用于实现3D变换。
	*/
	//class laya.d3.core.Transform3D
	var Transform3D=(function(){
		function Transform3D(owner){
			this._owner=null;
			this._preWorldTransformModifyID=-1;
			this._localUpdate=false;
			this._worldTransformModifyID=0;
			this._parent=null;
			this._localPosition=new Vector3();
			this._localRotation=new Quaternion(0,0,0,1);
			this._localScale=new Vector3(1,1,1);
			this._localMatrix=new Matrix4x4();
			this._position=new Vector3();
			this._rotation=new Quaternion(0,0,0,1);
			this._scale=new Vector3(1,1,1);
			this._worldMatrix=new Matrix4x4();
			this._forward=new Vector3();
			this._up=new Vector3();
			this._right=new Vector3();
			this._tempMatrix0=new Matrix4x4();
			this._tempQuaternion0=new Quaternion();
			this._tempVector30=new Vector3();
			this._owner=owner;
		}

		__class(Transform3D,'laya.d3.core.Transform3D');
		var __proto=Transform3D.prototype;
		/**
		*平移变换。
		*@param translation 移动距离。
		*@param isLocal 是否局部空间。
		*/
		__proto.translate=function(translation,isLocal){
			(isLocal===void 0)&& (isLocal=true);
			if (isLocal){
				Matrix4x4.createFromQuaternion(this.localRotation,this._tempMatrix0);
				Vector3.transformCoordinate(translation,this._tempMatrix0,this._tempVector30);
				Vector3.add(this.localPosition,this._tempVector30,this._localPosition);
				this.localPosition=this._localPosition;
				}else {
				Vector3.add(this.position,translation,this._position);
				this.position=this._position;
			}
		}

		/**
		*旋转变换。
		*@param rotations 旋转幅度。
		*@param isLocal 是否局部空间。
		*@param isRadian 是否弧度制。
		*/
		__proto.rotate=function(rotation,isLocal,isRadian){
			(isLocal===void 0)&& (isLocal=true);
			(isRadian===void 0)&& (isRadian=true);
			var rot;
			if (!isRadian){
				Vector3.scale(rotation,Math.PI / 180,this._tempVector30);
				rot=this._tempVector30;
				}else {
				rot=rotation;
			}
			Quaternion.createFromYawPitchRoll(rot.y,rot.x,rot.z,this._tempQuaternion0);
			if (isLocal){
				Quaternion.multiply(this.localRotation,this._tempQuaternion0,this._localRotation);
				this.localRotation=this._localRotation;
				}else {
				Quaternion.multiply(this._tempQuaternion0,this.rotation,this._rotation);
				this.rotation=this._rotation;
			}
		}

		/**
		*获得世界变换矩阵。
		*@param transformModifyID 变换标识id。
		*@return 世界变换矩阵。
		*/
		__proto.getWorldMatrix=function(transformModifyID){
			if (transformModifyID===-2 || (transformModifyID >=0 && this._preWorldTransformModifyID===transformModifyID)){
				return this._worldMatrix;
			}
			if (this._parent !=null)
				Matrix4x4.multiply(this._parent.getWorldMatrix(transformModifyID===-1 ?-1 :-2),this.localMatrix,this._worldMatrix);
			else
			this.localMatrix.cloneTo(this._worldMatrix);
			transformModifyID >=0 && (this._preWorldTransformModifyID=transformModifyID);
			return this._worldMatrix;
		}

		/**
		*@private
		*/
		__proto._updateLocalMatrix=function(){
			Matrix4x4.createAffineTransformation(this._localPosition,this._localRotation,this._localScale,this._localMatrix);
		}

		/**
		*@private
		*/
		__proto._onLocalTransform=function(){
			this._localUpdate=true;
		}

		/**
		*@private
		*/
		__proto._onWorldTransform=function(){
			this._worldTransformModifyID+=0.01 / this._owner.id;
		}

		/**
		*设置局部矩阵。
		*@param value 局部矩阵。
		*/
		/**
		*获取局部矩阵。
		*@return 局部矩阵。
		*/
		__getset(0,__proto,'localMatrix',function(){
			if (this._localUpdate){
				this._updateLocalMatrix();
				this._localUpdate=false;
			}
			return this._localMatrix;
			},function(value){
			this._localMatrix=value;
			this._localMatrix.decompose(this._localPosition,this._localRotation,this._localScale);
			this._onWorldTransform();
		});

		/**
		*设置局部位置。
		*@param value 局部位置。
		*/
		/**
		*获取局部位置。
		*@return 局部位置。
		*/
		__getset(0,__proto,'localPosition',function(){
			return this._localPosition;
			},function(value){
			this._localPosition=value;
			this._onLocalTransform();
			this._onWorldTransform();
		});

		/**
		*设置世界位置。
		*@param value 世界位置。
		*/
		/**
		*获取世界位置。
		*@return 世界位置。
		*/
		__getset(0,__proto,'position',function(){
			if (this._parent!==null){
				var worldMatElem=this.worldMatrix.elements;
				this._position.elements[0]=worldMatElem[12];
				this._position.elements[1]=worldMatElem[13];
				this._position.elements[2]=worldMatElem[14];
				}else {
				this._localPosition.cloneTo(this._position);
			}
			return this._position;
			},function(value){
			if (this._parent!==null){
				this._parent.worldMatrix.invert(this._tempMatrix0);
				Vector3.transformCoordinate(value,this._tempMatrix0,this._localPosition);
				this.localPosition=this._localPosition;
				}else {
				value.cloneTo(this._localPosition);
				this.localPosition=this._localPosition;
			}
		});

		/**
		*设置世界矩阵。
		*@param value 世界矩阵。
		*/
		/**
		*获取世界矩阵。
		*@return 世界矩阵。
		*/
		__getset(0,__proto,'worldMatrix',function(){
			this.getWorldMatrix(-1);
			return this._worldMatrix;
			},function(value){
			if (this._parent===null)
				this.localMatrix=value;
			else {
				this._parent.worldMatrix.invert(this._localMatrix);
				Matrix4x4.multiply(this._localMatrix,value,this._localMatrix);
				this.localMatrix=this._localMatrix;
			}
		});

		/**
		*设置局部旋转。
		*@param value 局部旋转。
		*/
		/**
		*获取局部旋转。
		*@return 局部旋转。
		*/
		__getset(0,__proto,'localRotation',function(){
			return this._localRotation;
			},function(value){
			this._localRotation=value;
			this._localRotation.normalize(this._localRotation);
			this._onLocalTransform();
			this._onWorldTransform();
		});

		/**
		*设置世界旋转。
		*@param value 世界旋转。
		*/
		/**
		*获取世界旋转。
		*@return 世界旋转。
		*/
		__getset(0,__proto,'rotation',function(){
			if (this._parent!==null){
				this.worldMatrix.decompose(this._position,this._rotation,this._scale);
				}else {
				this._localRotation.cloneTo(this._rotation);
			}
			return this._rotation;
			},function(value){
			if (this._parent!==null){
				this._parent.rotation.invert(this._tempQuaternion0);
				Quaternion.multiply(value,this._tempQuaternion0,this._localRotation);
				this.localRotation=this._localRotation;
				}else {
				value.cloneTo(this._localRotation);
				this.localRotation=this._localRotation;
			}
		});

		/**
		*设置局部缩放。
		*@param value 局部缩放。
		*/
		/**
		*获取局部缩放。
		*@return 局部缩放。
		*/
		__getset(0,__proto,'localScale',function(){
			return this._localScale;
			},function(value){
			this._localScale=value;
			this._onLocalTransform();
			this._onWorldTransform();
		});

		/**
		*获取世界缩放。
		*@return 世界缩放。
		*/
		__getset(0,__proto,'scale',function(){
			if (this._parent!==null){
				Vector3.multiply(this._parent.scale,this._localScale,this._scale);
				}else {
				this._localScale.cloneTo(this._scale);
			}
			return this._scale;
		});

		/**
		*设置局部空间的旋转角度。
		*@param value 欧拉角的旋转值，顺序为x、y、z。
		*/
		__getset(0,__proto,'localRotationEuler',null,function(value){
			Quaternion.createFromYawPitchRoll(value.y,value.x,value.z,this._localRotation);
			this._onLocalTransform();
			this._onWorldTransform();
		});

		/**
		*设置局部空间的旋转角度。
		*@param 欧拉角的旋转值，顺序为x、y、z。
		*/
		__getset(0,__proto,'rotationEuler',null,function(value){
			Quaternion.createFromYawPitchRoll(value.y,value.x,value.z,this._rotation);
			this.rotation=this._rotation;
		});

		/**
		*获取向前方向。
		*@return 向前方向。
		*/
		__getset(0,__proto,'forward',function(){
			var worldMatElem=this.worldMatrix.elements;
			this._forward.elements[0]=-worldMatElem[8];
			this._forward.elements[1]=-worldMatElem[9];
			this._forward.elements[2]=-worldMatElem[10];
			return this._forward;
		});

		/**
		*获取向上方向。
		*@return 向上方向。
		*/
		__getset(0,__proto,'up',function(){
			var worldMatElem=this.worldMatrix.elements;
			this._up.elements[0]=worldMatElem[4];
			this._up.elements[1]=worldMatElem[5];
			this._up.elements[2]=worldMatElem[6];
			return this._up;
		});

		/**
		*获取向右方向。
		*@return 向右方向。
		*/
		__getset(0,__proto,'right',function(){
			var worldMatElem=this.worldMatrix.elements;
			this._right.elements[0]=worldMatElem[0];
			this._right.elements[1]=worldMatElem[1];
			this._right.elements[2]=worldMatElem[2];
			return this._right;
		});

		return Transform3D;
	})()


	/**
	*@private
	*<code>StaticBatch</code> 类用于创建静态批处理。
	*/
	//class laya.d3.graphics.StaticBatch
	var StaticBatch=(function(){
		function StaticBatch(vertexDeclaration,material){
			this._currentVertexCount=0;
			this._currentIndexCount=0;
			this._elementCount=0;
			this._vertexDeclaration=null;
			this._material=null;
			this._vertexDatas=null;
			this._indexDatas=null;
			this._vertexBuffer=null;
			this._indexBuffer=null;
			this._lastRenderObjects=null;
			this._renderObjects=null;
			this._renderOwners=null;
			this._needReMerage=false;
			this._elementCount=0;
			this._vertexDeclaration=vertexDeclaration;
			this._material=material;
			this._lastRenderObjects=[];
			this._renderObjects=[];
			this._renderOwners=[];
			this._needReMerage=false;
		}

		__class(StaticBatch,'laya.d3.graphics.StaticBatch');
		var __proto=StaticBatch.prototype;
		Laya.imps(__proto,{"laya.d3.core.render.IRenderable":true})
		__proto.getVertexBuffer=function(index){
			(index===void 0)&& (index=0);
			if (index===0)
				return this._vertexBuffer;
			else
			return null;
		}

		__proto.getIndexBuffer=function(){
			return this._indexBuffer;
		}

		__proto.getBakedVertexs=function(index,transform){
			return null;
		}

		__proto.getBakedIndices=function(){
			return null;
		}

		__proto._reset=function(){
			this._renderObjects.length=0;
			this._renderOwners.length=0;
			this._currentIndexCount=0;
			this._currentVertexCount=0;
		}

		__proto._finsh=function(){
			if (!this._needReMerage && this._lastRenderObjects.length !=this._renderObjects.length){
				this._needReMerage=true;
			}
			if (this._needReMerage){
				this._needReMerage=false;
				var curMerVerCount=0;
				var curMerIndCount=0;
				this._elementCount=0;
				this._vertexDatas=new Float32Array(this._vertexDeclaration.vertexStride / 4 *this._currentVertexCount);
				this._indexDatas=new Uint16Array(this._currentIndexCount);
				if (!this._vertexBuffer){
					this._vertexBuffer=VertexBuffer3D.create(this._vertexDeclaration,this._currentVertexCount,/*laya.webgl.WebGLContext.DYNAMIC_DRAW*/0x88E8);
					this._indexBuffer=IndexBuffer3D.create(/*laya.d3.graphics.IndexBuffer3D.INDEXTYPE_USHORT*/"ushort",this._currentIndexCount,/*laya.webgl.WebGLContext.DYNAMIC_DRAW*/0x88E8);
					}else {
					this._vertexBuffer.dispose();
					this._indexBuffer.dispose();
					this._vertexBuffer=VertexBuffer3D.create(this._vertexDeclaration,this._currentVertexCount,/*laya.webgl.WebGLContext.DYNAMIC_DRAW*/0x88E8);
					this._indexBuffer=IndexBuffer3D.create(/*laya.d3.graphics.IndexBuffer3D.INDEXTYPE_USHORT*/"ushort",this._currentIndexCount,/*laya.webgl.WebGLContext.DYNAMIC_DRAW*/0x88E8);
				}
				for (var i=0;i < this._renderObjects.length;i++){
					var renderObj=this._renderObjects[i];
					var subVertexDatas=renderObj.getBakedVertexs(0,this._renderOwners[i].transform.getWorldMatrix(-2));
					var subIndexDatas=renderObj.getBakedIndices();
					var indexOffset=curMerVerCount / (this._vertexDeclaration.vertexStride / 4);
					var indexStart=curMerIndCount;
					var indexEnd=indexStart+subIndexDatas.length;
					this._indexDatas.set(subIndexDatas,curMerIndCount);
					for (var k=indexStart;k < indexEnd;k++)
					this._indexDatas[k]=indexOffset+this._indexDatas[k];
					curMerIndCount+=subIndexDatas.length;
					this._vertexDatas.set(subVertexDatas,curMerVerCount);
					curMerVerCount+=subVertexDatas.length;
					this._elementCount+=subIndexDatas.length;
				}
				this._vertexBuffer.setData(this._vertexDatas);
				this._indexBuffer.setData(this._indexDatas);
			}
			this._lastRenderObjects=this._renderObjects.slice();
		}

		__proto._getShader=function(state,vertexBuffer,material){
			if (!material)
				return null;
			var def=0;
			var shaderAttribute=vertexBuffer.vertexDeclaration.shaderAttribute;
			(shaderAttribute.UV)&& (def |=material.shaderDef);
			(shaderAttribute.COLOR)&& (def |=/*laya.d3.shader.ShaderDefines3D.COLOR*/0x20);
			(state.scene.enableFog)&& (def |=/*laya.d3.shader.ShaderDefines3D.FOG*/0x20000);
			def > 0 && state.shaderDefs.addInt(def);
			var shader=material.getShader(state);
			return shader;
		}

		__proto.addRenderObj=function(renderObj){
			var renderElement=renderObj.renderElement;
			var indexbuffer=renderElement.getIndexBuffer();
			var indexCount=this._currentIndexCount+indexbuffer.byteLength / indexbuffer.indexTypeByteCount;
			var vertexCount=this._currentVertexCount+renderElement.getVertexBuffer().byteLength / this._vertexDeclaration.vertexStride;
			if (vertexCount > StaticBatch.maxVertexCount || indexCount > StaticBatch.maxIndexCount)
				return false;
			this._renderObjects.push(renderElement);
			this._renderOwners.push(renderObj.owner);
			if (!this._needReMerage && this._lastRenderObjects.indexOf(renderElement)===-1)
				this._needReMerage=true;
			this._currentIndexCount=indexCount;
			this._currentVertexCount=vertexCount;
			return true;
		}

		__proto._render=function(state){
			var vb=this._vertexBuffer;
			var ib=this._indexBuffer;
			var material=this._material;
			if (material.normalTexture && !vb.vertexDeclaration.shaderAttribute[ /*laya.d3.graphics.VertexElementUsage.TANGENT0*/"TANGENT0"]){
				var vertexDatas=vb.getData();
				var newVertexDatas=Utils3D.GenerateTangent(vertexDatas,vb.vertexDeclaration.vertexStride / 4,vb.vertexDeclaration.shaderAttribute[ /*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"][4] / 4,vb.vertexDeclaration.shaderAttribute[ /*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV"][4] / 4,ib.getData());
				var vertexDeclaration=Utils3D.getVertexTangentDeclaration(vb.vertexDeclaration.getVertexElements());
				var newVB=VertexBuffer3D.create(vertexDeclaration,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4);
				newVB.setData(newVertexDatas);
				vb.dispose();
				this._vertexBuffer=vb=newVB;
			}
			vb._bind();
			ib._bind();
			if (material){
				var shader=this._getShader(state,vb,material);
				var presz=state.shaderValue.length;
				state.shaderValue.pushArray(vb.vertexDeclaration.shaderValues);
				state.shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.MATRIX1*/"MATRIX1",Matrix4x4.DEFAULT.elements,-1);
				state.shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.MVPMATRIX*/"MVPMATRIX",state.projectionViewMatrix.elements,state.camera.transform._worldTransformModifyID+state.camera._projectionMatrixModifyID);
				if (!material.upload(state,null,shader)){
					state.shaderValue.length=presz;
					return false;
				}
				state.shaderValue.length=presz;
			}
			state.context.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,this._elementCount,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,0);
			Stat.drawCall++;
			Stat.trianglesFaces+=this._elementCount / 3;
			return true;
		}

		__getset(0,__proto,'VertexBufferCount',function(){
			return 1;
		});

		__getset(0,__proto,'indexOfHost',function(){
			return 0;
		});

		__getset(0,__proto,'triangleCount',function(){
			return this._indexBuffer.indexCount/3;
		});

		__getset(0,__proto,'currentVertexCount',function(){
			return this._currentVertexCount;
		});

		__getset(0,__proto,'currentIndexCount',function(){
			return this._currentIndexCount;
		});

		StaticBatch.maxVertexCount=65535;
		StaticBatch.maxIndexCount=120000;
		return StaticBatch;
	})()


	/**
	*@private
	*<code>StaticBatchManager</code> 类用于创建静态批处理管理员。
	*/
	//class laya.d3.graphics.StaticBatchManager
	var StaticBatchManager=(function(){
		function StaticBatchManager(){
			this._keys=null;
			this._useFPS=null;
			this._staticBatchs=null;
			this._keys=[];
			this._useFPS=[];
			this._staticBatchs=[];
		}

		__class(StaticBatchManager,'laya.d3.graphics.StaticBatchManager');
		var __proto=StaticBatchManager.prototype;
		__proto.getStaticBatchQneue=function(_vertexDeclaration,material){
			var staticBatch;
			var key=material.id */*laya.d3.graphics.VertexDeclaration._maxVertexDeclarationBit*/1000+_vertexDeclaration.id;
			if (this._keys.indexOf(key)===-1){
				this._keys.push(key);
				this._useFPS.push(Stat.loopCount);
				staticBatch=new StaticBatch(_vertexDeclaration,material);
				this._staticBatchs.push(staticBatch);
				}else {
				var index=this._keys.indexOf(key);
				this._useFPS[index]=Stat.loopCount;
				staticBatch=this._staticBatchs[index];
			}
			return staticBatch;
		}

		/**@private 通常应在所有getStaticBatchQneue函数相关操作结束后执行,不必逐帧执行。*/
		__proto._garbageCollection=function(){
			for (var i=0;i < this._keys.length;i++){
				if (this._useFPS[i] < Stat.loopCount){
					this._keys.splice(i,1);
					this._useFPS.splice(i,1);
					this._staticBatchs.splice(i,1);
					i--;
				}
			}
		}

		/**重置*/
		__proto._reset=function(){
			for (var i=0;i < this._keys.length;i++){
				this._staticBatchs[i]._reset();
			}
		}

		/**刷新*/
		__proto._finsh=function(){
			for (var i=0;i < this._keys.length;i++){
				this._staticBatchs[i]._finsh();
			}
		}

		__proto.dispose=function(){
			this._keys.length=0;
			this._useFPS.length=0;
			this._staticBatchs.length=0;
		}

		StaticBatchManager.maxVertexDeclaration=1000;
		__static(StaticBatchManager,
		['maxMaterialCount',function(){return this.maxMaterialCount=Math.floor(2147483647 / 1000);}
		]);
		return StaticBatchManager;
	})()


	/**
	*...
	*@author ...
	*/
	//class laya.d3.graphics.VertexDeclaration
	var VertexDeclaration=(function(){
		function VertexDeclaration(vertexStride,vertexElements){
			this._id=0;
			this._shaderValues=null;
			this._shaderAttribute=null;
			this._vertexStride=0;
			this._vertexElements=null;
			this._id=++VertexDeclaration._uniqueIDCounter;
			if (this._id > VertexDeclaration.maxVertexDeclaration)
				throw new Error("VertexDeclaration: VertexDeclaration count should not large than ",VertexDeclaration.maxVertexDeclaration);
			this._shaderAttribute={};
			this._shaderValues=new ValusArray();
			this._vertexStride=vertexStride;
			this._vertexElements=vertexElements;
			for (var i=0;i < vertexElements.length;i++){
				var vertexElement=vertexElements[i];
				var attributeName=vertexElement.elementUsage;
				var value=[VertexDeclaration._getTypeSize(vertexElement.elementFormat)/ 4,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,this._vertexStride,vertexElement.offset];
				this._shaderValues.pushValue(attributeName,value,-1);
				this._shaderAttribute[attributeName]=value;
			}
		}

		__class(VertexDeclaration,'laya.d3.graphics.VertexDeclaration');
		var __proto=VertexDeclaration.prototype;
		//临时
		__proto.getVertexElements=function(){
			return this._vertexElements.slice();
		}

		__proto.unBinding=function(){}
		/**
		*获取唯一标识ID(通常用于优化或识别)。
		*@return 唯一标识ID
		*/
		__getset(0,__proto,'id',function(){
			return this._id;
		});

		__getset(0,__proto,'shaderAttribute',function(){
			return this._shaderAttribute;
		});

		__getset(0,__proto,'shaderValues',function(){
			return this._shaderValues;
		});

		__getset(0,__proto,'vertexStride',function(){
			return this._vertexStride;
		});

		VertexDeclaration._getTypeSize=function(format){
			switch (format){
				case /*laya.d3.graphics.VertexElementFormat.Single*/"single":
					return 4;
				case /*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2":
					return 8;
				case /*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3":
					return 12;
				case /*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4":
					return 16;
				case /*laya.d3.graphics.VertexElementFormat.Color*/"volor":
					return 4;
				case /*laya.d3.graphics.VertexElementFormat.Byte4*/"byte4":
					return 4;
				case /*laya.d3.graphics.VertexElementFormat.Short2*/"short2":
					return 4;
				case /*laya.d3.graphics.VertexElementFormat.Short4*/"short4":
					return 8;
				case /*laya.d3.graphics.VertexElementFormat.NormalizedShort2*/"normalizedshort2":
					return 4;
				case /*laya.d3.graphics.VertexElementFormat.NormalizedShort4*/"normalizedshort4":
					return 8;
				case /*laya.d3.graphics.VertexElementFormat.HalfVector2*/"halfvector2":
					return 4;
				case /*laya.d3.graphics.VertexElementFormat.HalfVector4*/"halfvector4":
					return 8;
				}
			return 0;
		}

		VertexDeclaration.getVertexStride=function(vertexElements){
			var curStride=0;
			for (var i=0;i < vertexElements.Length;i++){
				var element=vertexElements[i];
				var stride=element.offset+VertexDeclaration._getTypeSize(element.elementFormat);
				if (curStride < stride){
					curStride=stride;
				}
			}
			return curStride;
		}

		VertexDeclaration._maxVertexDeclarationBit=1000;
		VertexDeclaration._uniqueIDCounter=1;
		__static(VertexDeclaration,
		['maxVertexDeclaration',function(){return this.maxVertexDeclaration=2147483647-Math.floor(2147483647 / 1000)*1000;}
		]);
		return VertexDeclaration;
	})()


	/**
	*<code>VertexElement</code> 类用于创建顶点结构分配。
	*/
	//class laya.d3.graphics.VertexElement
	var VertexElement=(function(){
		function VertexElement(offset,elementFormat,elementUsage){
			this.offset=0;
			this.elementFormat=null;
			this.elementUsage=null;
			this.offset=offset;
			this.elementFormat=elementFormat;
			this.elementUsage=elementUsage;
		}

		__class(VertexElement,'laya.d3.graphics.VertexElement');
		return VertexElement;
	})()


	/**
	*...
	*@author ...
	*/
	//class laya.d3.graphics.VertexElementFormat
	var VertexElementFormat=(function(){
		function VertexElementFormat(){};
		__class(VertexElementFormat,'laya.d3.graphics.VertexElementFormat');
		VertexElementFormat.Single="single";
		VertexElementFormat.Vector2="vector2";
		VertexElementFormat.Vector3="vector3";
		VertexElementFormat.Vector4="vector4";
		VertexElementFormat.Color="volor";
		VertexElementFormat.Byte4="byte4";
		VertexElementFormat.Short2="short2";
		VertexElementFormat.Short4="short4";
		VertexElementFormat.NormalizedShort2="normalizedshort2";
		VertexElementFormat.NormalizedShort4="normalizedshort4";
		VertexElementFormat.HalfVector2="halfvector2";
		VertexElementFormat.HalfVector4="halfvector4";
		return VertexElementFormat;
	})()


	/**
	*...
	*@author ...
	*/
	//class laya.d3.graphics.VertexElementUsage
	var VertexElementUsage=(function(){
		function VertexElementUsage(){};
		__class(VertexElementUsage,'laya.d3.graphics.VertexElementUsage');
		VertexElementUsage.POSITION0="POSITION";
		VertexElementUsage.COLOR0="COLOR";
		VertexElementUsage.TEXTURECOORDINATE0="UV";
		VertexElementUsage.NORMAL0="NORMAL";
		VertexElementUsage.BINORMAL0="BINORMAL";
		VertexElementUsage.TANGENT0="TANGENT0";
		VertexElementUsage.BLENDINDICES0="BLENDINDICES";
		VertexElementUsage.BLENDWEIGHT0="BLENDWEIGHT";
		VertexElementUsage.DEPTH0="DEPTH";
		VertexElementUsage.FOG0="FOG";
		VertexElementUsage.POINTSIZE0="POINTSIZE";
		VertexElementUsage.SAMPLE0="SAMPLE";
		VertexElementUsage.TESSELLATEFACTOR0="TESSELLATEFACTOR";
		VertexElementUsage.COLOR1="COLOR1";
		VertexElementUsage.NEXTTEXTURECOORDINATE0="NEXTUV";
		VertexElementUsage.TEXTURECOORDINATE1="UV1";
		VertexElementUsage.NEXTTEXTURECOORDINATE1="NEXTUV1";
		VertexElementUsage.CORNERTEXTURECOORDINATE0="CORNERTEXTURECOORDINATE";
		VertexElementUsage.VELOCITY0="VELOCITY";
		VertexElementUsage.STARTCOLOR0="STARTCOLOR";
		VertexElementUsage.ENDCOLOR0="ENDCOLOR";
		VertexElementUsage.SIZEROTATION0="SIZEROTATION";
		VertexElementUsage.RADIUS0="RADIUS";
		VertexElementUsage.RADIAN0="RADIAN";
		VertexElementUsage.AGEADDSCALE0="AGEADDSCALE";
		VertexElementUsage.TIME0="TIME";
		return VertexElementUsage;
	})()


	/**
	*<code>VertexPositionNormalColorTangent</code> 类用于创建粒子顶点结构。
	*/
	//class laya.d3.graphics.VertexGlitter
	var VertexGlitter=(function(){
		function VertexGlitter(position,textureCoordinate,time){
			this._position=null;
			this._textureCoordinate0=null;
			this._time=NaN;
			this._position=position;
			this._textureCoordinate0=textureCoordinate;
			this._time=time;
		}

		__class(VertexGlitter,'laya.d3.graphics.VertexGlitter');
		var __proto=VertexGlitter.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'time',function(){
			return this._time;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexGlitter._vertexDeclaration;
		});

		__getset(1,VertexGlitter,'vertexDeclaration',function(){
			return VertexGlitter._vertexDeclaration;
		});

		__static(VertexGlitter,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(24,
			[new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV"),
			new VertexElement(20,/*laya.d3.graphics.VertexElementFormat.Single*/"single",/*laya.d3.graphics.VertexElementUsage.TIME0*/"TIME")]);}
		]);
		return VertexGlitter;
	})()


	/**
	*<code>VertexPositionNormalColorTangent</code> 类用于创建粒子顶点结构。
	*/
	//class laya.d3.graphics.VertexParticle
	var VertexParticle=(function(){
		function VertexParticle(cornerTextureCoordinate,position,velocity,startColor,endColor,sizeRotation,radius,radian,ageAddScale,time){
			this._cornerTextureCoordinate=null;
			this._position=null;
			this._velocity=null;
			this._startColor=null;
			this._endColor=null;
			this._sizeRotation=null;
			this._radius=null;
			this._radian=null;
			this._ageAddScale=NaN;
			this._time=NaN;
			this._cornerTextureCoordinate=cornerTextureCoordinate;
			this._position=position;
			this._velocity=velocity;
			this._startColor=startColor;
			this._endColor=endColor;
			this._sizeRotation=sizeRotation;
			this._radius=radius;
			this._radian=radian;
			this._ageAddScale=ageAddScale;
			this._time=time;
		}

		__class(VertexParticle,'laya.d3.graphics.VertexParticle');
		var __proto=VertexParticle.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'cornerTextureCoordinate',function(){
			return this._cornerTextureCoordinate;
		});

		__getset(0,__proto,'velocity',function(){
			return this._velocity;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'radius',function(){
			return this._radius;
		});

		__getset(0,__proto,'startColor',function(){
			return this._startColor;
		});

		__getset(0,__proto,'endColor',function(){
			return this._endColor;
		});

		__getset(0,__proto,'radian',function(){
			return this._radian;
		});

		__getset(0,__proto,'sizeRotation',function(){
			return this._sizeRotation;
		});

		__getset(0,__proto,'ageAddScale',function(){
			return this._ageAddScale;
		});

		__getset(0,__proto,'time',function(){
			return this._time;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexParticle._vertexDeclaration;
		});

		__getset(1,VertexParticle,'vertexDeclaration',function(){
			return VertexParticle._vertexDeclaration;
		});

		__static(VertexParticle,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(116,
			[new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.CORNERTEXTURECOORDINATE0*/"CORNERTEXTURECOORDINATE"),
			new VertexElement(16,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(28,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.VELOCITY0*/"VELOCITY"),
			new VertexElement(40,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.STARTCOLOR0*/"STARTCOLOR"),
			new VertexElement(56,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.ENDCOLOR0*/"ENDCOLOR"),
			new VertexElement(72,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.SIZEROTATION0*/"SIZEROTATION"),
			new VertexElement(84,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.RADIUS0*/"RADIUS"),
			new VertexElement(92,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.RADIAN0*/"RADIAN"),
			new VertexElement(108,/*laya.d3.graphics.VertexElementFormat.Single*/"single",/*laya.d3.graphics.VertexElementUsage.AGEADDSCALE0*/"AGEADDSCALE"),
			new VertexElement(112,/*laya.d3.graphics.VertexElementFormat.Single*/"single",/*laya.d3.graphics.VertexElementUsage.TIME0*/"TIME")]);}
		]);
		return VertexParticle;
	})()


	/**
	*<code>VertexPositionNormalColor</code> 类用于创建位置、法线、颜色顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColor
	var VertexPositionNormalColor=(function(){
		function VertexPositionNormalColor(position,normal,color){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._position=position;
			this._normal=normal;
			this._color=color;
		}

		__class(VertexPositionNormalColor,'laya.d3.graphics.VertexPositionNormalColor');
		var __proto=VertexPositionNormalColor.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColor._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColor,'vertexDeclaration',function(){
			return VertexPositionNormalColor._vertexDeclaration;
		});

		__static(VertexPositionNormalColor,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(40,[
			new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"),
			new VertexElement(24,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.COLOR0*/"COLOR")]);}
		]);
		return VertexPositionNormalColor;
	})()


	/**
	*<code>VertexPositionNormalColorSkin</code> 类用于创建位置、法线、颜色、骨骼索引、骨骼权重顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColorSkin
	var VertexPositionNormalColorSkin=(function(){
		function VertexPositionNormalColorSkin(position,normal,color,blendIndex,blendWeight){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._blendIndex=null;
			this._blendWeight=null;
			this._position=position;
			this._normal=normal;
			this._color=color;
			this._blendIndex=blendIndex;
			this._blendWeight=blendWeight;
		}

		__class(VertexPositionNormalColorSkin,'laya.d3.graphics.VertexPositionNormalColorSkin');
		var __proto=VertexPositionNormalColorSkin.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorSkin._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColorSkin,'vertexDeclaration',function(){
			return VertexPositionNormalColorSkin._vertexDeclaration;
		});

		__static(VertexPositionNormalColorSkin,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(72,[
			new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"),
			new VertexElement(24,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.COLOR0*/"COLOR"),
			new VertexElement(40,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.BLENDWEIGHT0*/"BLENDWEIGHT"),
			new VertexElement(56,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.BLENDINDICES0*/"BLENDINDICES")]);}
		]);
		return VertexPositionNormalColorSkin;
	})()


	/**
	*<code>VertexPositionNormalColorSkin</code> 类用于创建位置、法线、颜色、骨骼索引、骨骼权重顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColorSkinTangent
	var VertexPositionNormalColorSkinTangent=(function(){
		function VertexPositionNormalColorSkinTangent(position,normal,color,tangent,blendIndex,blendWeight){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._blendIndex=null;
			this._blendWeight=null;
			this._tangent=null;
			this._position=position;
			this._normal=normal;
			this._color=color;
			this._tangent=tangent;
			this._blendIndex=blendIndex;
			this._blendWeight=blendWeight;
		}

		__class(VertexPositionNormalColorSkinTangent,'laya.d3.graphics.VertexPositionNormalColorSkinTangent');
		var __proto=VertexPositionNormalColorSkinTangent.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorSkinTangent._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColorSkinTangent,'vertexDeclaration',function(){
			return VertexPositionNormalColorSkinTangent._vertexDeclaration;
		});

		__static(VertexPositionNormalColorSkinTangent,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(84,[
			new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"),
			new VertexElement(24,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.COLOR0*/"COLOR"),
			new VertexElement(40,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.BLENDWEIGHT0*/"BLENDWEIGHT"),
			new VertexElement(56,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.BLENDINDICES0*/"BLENDINDICES"),
			new VertexElement(72,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.TANGENT0*/"TANGENT0")]);}
		]);
		return VertexPositionNormalColorSkinTangent;
	})()


	/**
	*<code>VertexPositionNormalColorTangent</code> 类用于创建位置、法线、颜色、切线顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColorTangent
	var VertexPositionNormalColorTangent=(function(){
		function VertexPositionNormalColorTangent(position,normal,color,tangent){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._tangent=null;
			this._position=position;
			this._normal=normal;
			this._color=color;
			this._tangent=tangent;
		}

		__class(VertexPositionNormalColorTangent,'laya.d3.graphics.VertexPositionNormalColorTangent');
		var __proto=VertexPositionNormalColorTangent.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorTangent._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColorTangent,'vertexDeclaration',function(){
			return VertexPositionNormalColorTangent._vertexDeclaration;
		});

		__static(VertexPositionNormalColorTangent,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(52,[
			new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"),
			new VertexElement(24,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.COLOR0*/"COLOR"),
			new VertexElement(40,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.TANGENT0*/"TANGENT0")]);}
		]);
		return VertexPositionNormalColorTangent;
	})()


	/**
	*<code>VertexPositionNormalColorTexture</code> 类用于创建位置、法线、颜色、纹理顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColorTexture
	var VertexPositionNormalColorTexture=(function(){
		function VertexPositionNormalColorTexture(position,normal,color,textureCoordinate){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._textureCoordinate=null;
			this._position=position;
			this._normal=normal;
			this._color=color;
			this._textureCoordinate=textureCoordinate;
		}

		__class(VertexPositionNormalColorTexture,'laya.d3.graphics.VertexPositionNormalColorTexture');
		var __proto=VertexPositionNormalColorTexture.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorTexture._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColorTexture,'vertexDeclaration',function(){
			return VertexPositionNormalColorTexture._vertexDeclaration;
		});

		__static(VertexPositionNormalColorTexture,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(48,[
			new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"),
			new VertexElement(24,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.COLOR0*/"COLOR"),
			new VertexElement(40,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV")]);}
		]);
		return VertexPositionNormalColorTexture;
	})()


	/**
	*<code>VertexPositionNormalColorTexture</code> 类用于创建位置、法线、颜色、纹理顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColorTexture0Texture1
	var VertexPositionNormalColorTexture0Texture1=(function(){
		function VertexPositionNormalColorTexture0Texture1(position,normal,color,textureCoordinate0,textureCoordinate1){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._textureCoordinate0=null;
			this._textureCoordinate1=null;
			this._position=position;
			this._normal=normal;
			this._color=color;
			this._textureCoordinate0=textureCoordinate0;
			this._textureCoordinate1=textureCoordinate1;
		}

		__class(VertexPositionNormalColorTexture0Texture1,'laya.d3.graphics.VertexPositionNormalColorTexture0Texture1');
		var __proto=VertexPositionNormalColorTexture0Texture1.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'textureCoordinate0',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'textureCoordinate1',function(){
			return this._textureCoordinate1;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorTexture0Texture1._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColorTexture0Texture1,'vertexDeclaration',function(){
			return VertexPositionNormalColorTexture0Texture1._vertexDeclaration;
		});

		__static(VertexPositionNormalColorTexture0Texture1,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(56,[
			new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"),
			new VertexElement(24,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.COLOR0*/"COLOR"),
			new VertexElement(40,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV"),
			new VertexElement(48,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE1*/"UV1")]);}
		]);
		return VertexPositionNormalColorTexture0Texture1;
	})()


	/**
	*<code>VertexPositionNormalColorTextureSkin</code> 类用于创建位置、法线、颜色、纹理、骨骼索引、骨骼权重顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColorTexture0Texture1Skin
	var VertexPositionNormalColorTexture0Texture1Skin=(function(){
		function VertexPositionNormalColorTexture0Texture1Skin(position,normal,color,textureCoordinate0,textureCoordinate1,blendIndex,blendWeight){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._textureCoordinate0=null;
			this._textureCoordinate1=null;
			this._blendIndex=null;
			this._blendWeight=null;
			this._position=position;
			this._normal=normal;
			this._color=color;
			this._textureCoordinate0=textureCoordinate0;
			this._textureCoordinate1=textureCoordinate1;
			this._blendIndex=blendIndex;
			this._blendWeight=blendWeight;
		}

		__class(VertexPositionNormalColorTexture0Texture1Skin,'laya.d3.graphics.VertexPositionNormalColorTexture0Texture1Skin');
		var __proto=VertexPositionNormalColorTexture0Texture1Skin.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'textureCoordinate0',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'textureCoordinate1',function(){
			return this._textureCoordinate1;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorTexture0Texture1Skin._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColorTexture0Texture1Skin,'vertexDeclaration',function(){
			return VertexPositionNormalColorTexture0Texture1Skin._vertexDeclaration;
		});

		__static(VertexPositionNormalColorTexture0Texture1Skin,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(88,[
			new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"),
			new VertexElement(24,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.COLOR0*/"COLOR"),
			new VertexElement(40,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV"),
			new VertexElement(48,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE1*/"UV1"),
			new VertexElement(56,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.BLENDWEIGHT0*/"BLENDWEIGHT"),
			new VertexElement(72,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.BLENDINDICES0*/"BLENDINDICES")]);}
		]);
		return VertexPositionNormalColorTexture0Texture1Skin;
	})()


	/**
	*<code>VertexPositionNormalTextureSkin</code> 类用于创建位置、法线、纹理、骨骼索引、骨骼权重顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColorTexture0Texture1SkinTangent
	var VertexPositionNormalColorTexture0Texture1SkinTangent=(function(){
		function VertexPositionNormalColorTexture0Texture1SkinTangent(){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._textureCoordinate0=null;
			this._textureCoordinate1=null;
			this._blendIndex=null;
			this._blendWeight=null;
			this._tangent=null;
		}

		__class(VertexPositionNormalColorTexture0Texture1SkinTangent,'laya.d3.graphics.VertexPositionNormalColorTexture0Texture1SkinTangent');
		var __proto=VertexPositionNormalColorTexture0Texture1SkinTangent.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__proto.VertexPositionNormalColorTexture0SkinTangent=function(position,normal,color,textureCoordinate0,textureCoordinate1,tangent,blendIndex,blendWeight){
			this._position=position;
			this._normal=normal;
			this._color=color;
			this._textureCoordinate0=textureCoordinate0;
			this._textureCoordinate1=textureCoordinate1;
			this._tangent=tangent;
			this._blendIndex=blendIndex;
			this._blendWeight=blendWeight;
		}

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'textureCoordinate0',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'textureCoordinate1',function(){
			return this._textureCoordinate1;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorTexture0Texture1SkinTangent._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColorTexture0Texture1SkinTangent,'vertexDeclaration',function(){
			return VertexPositionNormalColorTexture0Texture1SkinTangent._vertexDeclaration;
		});

		__static(VertexPositionNormalColorTexture0Texture1SkinTangent,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(100,[
			new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"),
			new VertexElement(24,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.COLOR0*/"COLOR"),
			new VertexElement(40,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV"),
			new VertexElement(48,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE1*/"UV1"),
			new VertexElement(56,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.BLENDWEIGHT0*/"BLENDWEIGHT"),
			new VertexElement(72,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.BLENDINDICES0*/"BLENDINDICES"),
			new VertexElement(88,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.TANGENT0*/"TANGENT0")]);}
		]);
		return VertexPositionNormalColorTexture0Texture1SkinTangent;
	})()


	/**
	*<code>VertexPositionNormalColorTextureTangent</code> 类用于创建位置、法线、颜色、纹理、切线顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColorTexture0Texture1Tangent
	var VertexPositionNormalColorTexture0Texture1Tangent=(function(){
		function VertexPositionNormalColorTexture0Texture1Tangent(){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._textureCoordinate0=null;
			this._textureCoordinate1=null;
			this._tangent=null;
		}

		__class(VertexPositionNormalColorTexture0Texture1Tangent,'laya.d3.graphics.VertexPositionNormalColorTexture0Texture1Tangent');
		var __proto=VertexPositionNormalColorTexture0Texture1Tangent.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__proto.VertexPositionNormalColorTexture0Tangent=function(position,normal,color,textureCoordinate0,textureCoordinate1,tangent){
			this._position=position;
			this._normal=normal;
			this._color=color;
			this._textureCoordinate0=textureCoordinate0;
			this._textureCoordinate1=textureCoordinate1;
			this._tangent=tangent;
		}

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'textureCoordinate0',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'textureCoordinate1',function(){
			return this._textureCoordinate1;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorTexture0Texture1Tangent._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColorTexture0Texture1Tangent,'vertexDeclaration',function(){
			return VertexPositionNormalColorTexture0Texture1Tangent._vertexDeclaration;
		});

		__static(VertexPositionNormalColorTexture0Texture1Tangent,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(68,[
			new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"),
			new VertexElement(24,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.COLOR0*/"COLOR"),
			new VertexElement(40,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV"),
			new VertexElement(48,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE1*/"UV1"),
			new VertexElement(56,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.TANGENT0*/"TANGENT0")]);}
		]);
		return VertexPositionNormalColorTexture0Texture1Tangent;
	})()


	/**
	*<code>VertexPositionNormalColorTextureSkin</code> 类用于创建位置、法线、颜色、纹理、骨骼索引、骨骼权重顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColorTextureSkin
	var VertexPositionNormalColorTextureSkin=(function(){
		function VertexPositionNormalColorTextureSkin(position,normal,color,textureCoordinate,blendIndex,blendWeight){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._textureCoordinate=null;
			this._blendIndex=null;
			this._blendWeight=null;
			this._position=position;
			this._normal=normal;
			this._color=color;
			this._textureCoordinate=textureCoordinate;
			this._blendIndex=blendIndex;
			this._blendWeight=blendWeight;
		}

		__class(VertexPositionNormalColorTextureSkin,'laya.d3.graphics.VertexPositionNormalColorTextureSkin');
		var __proto=VertexPositionNormalColorTextureSkin.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorTextureSkin._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColorTextureSkin,'vertexDeclaration',function(){
			return VertexPositionNormalColorTextureSkin._vertexDeclaration;
		});

		__static(VertexPositionNormalColorTextureSkin,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(80,[
			new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"),
			new VertexElement(24,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.COLOR0*/"COLOR"),
			new VertexElement(40,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV"),
			new VertexElement(48,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.BLENDWEIGHT0*/"BLENDWEIGHT"),
			new VertexElement(64,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.BLENDINDICES0*/"BLENDINDICES")]);}
		]);
		return VertexPositionNormalColorTextureSkin;
	})()


	/**
	*<code>VertexPositionNormalTextureSkin</code> 类用于创建位置、法线、纹理、骨骼索引、骨骼权重顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColorTextureSkinTangent
	var VertexPositionNormalColorTextureSkinTangent=(function(){
		function VertexPositionNormalColorTextureSkinTangent(position,normal,color,textureCoordinate,tangent,blendIndex,blendWeight){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._textureCoordinate=null;
			this._blendIndex=null;
			this._blendWeight=null;
			this._tangent=null;
			this._position=position;
			this._normal=normal;
			this._color=color;
			this._textureCoordinate=textureCoordinate;
			this._tangent=tangent;
			this._blendIndex=blendIndex;
			this._blendWeight=blendWeight;
		}

		__class(VertexPositionNormalColorTextureSkinTangent,'laya.d3.graphics.VertexPositionNormalColorTextureSkinTangent');
		var __proto=VertexPositionNormalColorTextureSkinTangent.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorTextureSkinTangent._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColorTextureSkinTangent,'vertexDeclaration',function(){
			return VertexPositionNormalColorTextureSkinTangent._vertexDeclaration;
		});

		__static(VertexPositionNormalColorTextureSkinTangent,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(92,[
			new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"),
			new VertexElement(24,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.COLOR0*/"COLOR"),
			new VertexElement(40,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV"),
			new VertexElement(48,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.BLENDWEIGHT0*/"BLENDWEIGHT"),
			new VertexElement(64,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.BLENDINDICES0*/"BLENDINDICES"),
			new VertexElement(80,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.TANGENT0*/"TANGENT0")]);}
		]);
		return VertexPositionNormalColorTextureSkinTangent;
	})()


	/**
	*<code>VertexPositionNormalColorTextureTangent</code> 类用于创建位置、法线、颜色、纹理、切线顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColorTextureTangent
	var VertexPositionNormalColorTextureTangent=(function(){
		function VertexPositionNormalColorTextureTangent(position,normal,color,textureCoordinate,tangent){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._textureCoordinate=null;
			this._tangent=null;
			this._position=position;
			this._normal=normal;
			this._color=color;
			this._textureCoordinate=textureCoordinate;
			this._tangent=tangent;
		}

		__class(VertexPositionNormalColorTextureTangent,'laya.d3.graphics.VertexPositionNormalColorTextureTangent');
		var __proto=VertexPositionNormalColorTextureTangent.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorTextureTangent._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColorTextureTangent,'vertexDeclaration',function(){
			return VertexPositionNormalColorTextureTangent._vertexDeclaration;
		});

		__static(VertexPositionNormalColorTextureTangent,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(60,[
			new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"),
			new VertexElement(24,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.COLOR0*/"COLOR"),
			new VertexElement(40,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV"),
			new VertexElement(48,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.TANGENT0*/"TANGENT0")]);}
		]);
		return VertexPositionNormalColorTextureTangent;
	})()


	/**
	*<code>VertexPositionNormalTexture</code> 类用于创建位置、法线、纹理顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalTexture
	var VertexPositionNormalTexture=(function(){
		function VertexPositionNormalTexture(position,normal,textureCoordinate){
			this._position=null;
			this._normal=null;
			this._textureCoordinate=null;
			this._position=position;
			this._normal=normal;
			this._textureCoordinate=textureCoordinate;
		}

		__class(VertexPositionNormalTexture,'laya.d3.graphics.VertexPositionNormalTexture');
		var __proto=VertexPositionNormalTexture.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalTexture._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalTexture,'vertexDeclaration',function(){
			return VertexPositionNormalTexture._vertexDeclaration;
		});

		__static(VertexPositionNormalTexture,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(32,[
			new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"),
			new VertexElement(24,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV")]);}
		]);
		return VertexPositionNormalTexture;
	})()


	/**
	*<code>VertexPositionNormalTexture</code> 类用于创建位置、法线、纹理顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalTexture0Texture1
	var VertexPositionNormalTexture0Texture1=(function(){
		function VertexPositionNormalTexture0Texture1(position,normal,textureCoordinate0,textureCoordinate1){
			this._position=null;
			this._normal=null;
			this._textureCoordinate0=null;
			this._textureCoordinate1=null;
			this._position=position;
			this._normal=normal;
			this._textureCoordinate0=textureCoordinate0;
			this._textureCoordinate1=textureCoordinate1;
		}

		__class(VertexPositionNormalTexture0Texture1,'laya.d3.graphics.VertexPositionNormalTexture0Texture1');
		var __proto=VertexPositionNormalTexture0Texture1.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'textureCoordinate0',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'textureCoordinate1',function(){
			return this._textureCoordinate1;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalTexture0Texture1._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalTexture0Texture1,'vertexDeclaration',function(){
			return VertexPositionNormalTexture0Texture1._vertexDeclaration;
		});

		__static(VertexPositionNormalTexture0Texture1,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(40,[
			new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"),
			new VertexElement(24,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV"),
			new VertexElement(32,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE1*/"UV1")]);}
		]);
		return VertexPositionNormalTexture0Texture1;
	})()


	/**
	*<code>VertexPositionNormalColorTextureSkin</code> 类用于创建位置、法线、颜色、纹理、骨骼索引、骨骼权重顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalTexture0Texture1Skin
	var VertexPositionNormalTexture0Texture1Skin=(function(){
		function VertexPositionNormalTexture0Texture1Skin(position,normal,textureCoordinate0,textureCoordinate1,blendIndex,blendWeight){
			this._position=null;
			this._normal=null;
			this._textureCoordinate0=null;
			this._textureCoordinate1=null;
			this._blendIndex=null;
			this._blendWeight=null;
			this._position=position;
			this._normal=normal;
			this._textureCoordinate0=textureCoordinate0;
			this._textureCoordinate1=textureCoordinate1;
			this._blendIndex=blendIndex;
			this._blendWeight=blendWeight;
		}

		__class(VertexPositionNormalTexture0Texture1Skin,'laya.d3.graphics.VertexPositionNormalTexture0Texture1Skin');
		var __proto=VertexPositionNormalTexture0Texture1Skin.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'textureCoordinate0',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'textureCoordinate1',function(){
			return this._textureCoordinate1;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalTexture0Texture1Skin._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalTexture0Texture1Skin,'vertexDeclaration',function(){
			return VertexPositionNormalTexture0Texture1Skin._vertexDeclaration;
		});

		__static(VertexPositionNormalTexture0Texture1Skin,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(72,[
			new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"),
			new VertexElement(24,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV"),
			new VertexElement(32,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE1*/"UV1"),
			new VertexElement(40,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.BLENDWEIGHT0*/"BLENDWEIGHT"),
			new VertexElement(56,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.BLENDINDICES0*/"BLENDINDICES")]);}
		]);
		return VertexPositionNormalTexture0Texture1Skin;
	})()


	/**
	*<code>VertexPositionNormalTextureSkin</code> 类用于创建位置、法线、纹理、骨骼索引、骨骼权重顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalTexture0Texture1SkinTangent
	var VertexPositionNormalTexture0Texture1SkinTangent=(function(){
		function VertexPositionNormalTexture0Texture1SkinTangent(){
			this._position=null;
			this._normal=null;
			this._textureCoordinate0=null;
			this._textureCoordinate1=null;
			this._blendIndex=null;
			this._blendWeight=null;
			this._tangent=null;
		}

		__class(VertexPositionNormalTexture0Texture1SkinTangent,'laya.d3.graphics.VertexPositionNormalTexture0Texture1SkinTangent');
		var __proto=VertexPositionNormalTexture0Texture1SkinTangent.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__proto.VertexPositionNormalTexture0SkinTangent=function(position,normal,textureCoordinate0,textureCoordinate1,tangent,blendIndex,blendWeight){
			this._position=position;
			this._normal=normal;
			this._textureCoordinate0=textureCoordinate0;
			this._textureCoordinate1=textureCoordinate1;
			this._tangent=tangent;
			this._blendIndex=blendIndex;
			this._blendWeight=blendWeight;
		}

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'textureCoordinate0',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'textureCoordinate1',function(){
			return this._textureCoordinate1;
		});

		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalTexture0Texture1SkinTangent._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalTexture0Texture1SkinTangent,'vertexDeclaration',function(){
			return VertexPositionNormalTexture0Texture1SkinTangent._vertexDeclaration;
		});

		__static(VertexPositionNormalTexture0Texture1SkinTangent,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(84,[
			new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"),
			new VertexElement(24,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV"),
			new VertexElement(32,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE1*/"UV1"),
			new VertexElement(40,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.BLENDWEIGHT0*/"BLENDWEIGHT"),
			new VertexElement(56,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.BLENDINDICES0*/"BLENDINDICES"),
			new VertexElement(72,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.TANGENT0*/"TANGENT0")]);}
		]);
		return VertexPositionNormalTexture0Texture1SkinTangent;
	})()


	/**
	*<code>VertexPositionNormalTextureTangent</code> 类用于创建位置、法线、纹理、切线顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalTexture0Texture1Tangent
	var VertexPositionNormalTexture0Texture1Tangent=(function(){
		function VertexPositionNormalTexture0Texture1Tangent(){
			this._position=null;
			this._normal=null;
			this._textureCoordinate0=null;
			this._textureCoordinate1=null;
			this._tangent=null;
		}

		__class(VertexPositionNormalTexture0Texture1Tangent,'laya.d3.graphics.VertexPositionNormalTexture0Texture1Tangent');
		var __proto=VertexPositionNormalTexture0Texture1Tangent.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__proto.VertexPositionNormalTexture0Tangent=function(position,normal,textureCoordinate0,textureCoordinate1,tangent){
			this._position=position;
			this._normal=normal;
			this._textureCoordinate0=textureCoordinate0;
			this._textureCoordinate1=textureCoordinate1;
			this._tangent=tangent;
		}

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'textureCoordinate0',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'textureCoordinate1',function(){
			return this._textureCoordinate1;
		});

		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalTexture0Texture1Tangent._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalTexture0Texture1Tangent,'vertexDeclaration',function(){
			return VertexPositionNormalTexture0Texture1Tangent._vertexDeclaration;
		});

		__static(VertexPositionNormalTexture0Texture1Tangent,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(52,[
			new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"),
			new VertexElement(24,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV"),
			new VertexElement(32,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE1*/"UV1"),
			new VertexElement(40,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.TANGENT0*/"TANGENT0")]);}
		]);
		return VertexPositionNormalTexture0Texture1Tangent;
	})()


	/**
	*<code>VertexPositionNormalColorTextureSkin</code> 类用于创建位置、法线、颜色、纹理、骨骼索引、骨骼权重顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalTextureSkin
	var VertexPositionNormalTextureSkin=(function(){
		function VertexPositionNormalTextureSkin(position,normal,textureCoordinate,blendIndex,blendWeight){
			this._position=null;
			this._normal=null;
			this._textureCoordinate=null;
			this._blendIndex=null;
			this._blendWeight=null;
			this._position=position;
			this._normal=normal;
			this._textureCoordinate=textureCoordinate;
			this._blendIndex=blendIndex;
			this._blendWeight=blendWeight;
		}

		__class(VertexPositionNormalTextureSkin,'laya.d3.graphics.VertexPositionNormalTextureSkin');
		var __proto=VertexPositionNormalTextureSkin.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalTextureSkin._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalTextureSkin,'vertexDeclaration',function(){
			return VertexPositionNormalTextureSkin._vertexDeclaration;
		});

		__static(VertexPositionNormalTextureSkin,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(64,[
			new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"),
			new VertexElement(24,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV"),
			new VertexElement(32,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.BLENDWEIGHT0*/"BLENDWEIGHT"),
			new VertexElement(48,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.BLENDINDICES0*/"BLENDINDICES")]);}
		]);
		return VertexPositionNormalTextureSkin;
	})()


	/**
	*<code>VertexPositionNormalTextureSkin</code> 类用于创建位置、法线、纹理、骨骼索引、骨骼权重顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalTextureSkinTangent
	var VertexPositionNormalTextureSkinTangent=(function(){
		function VertexPositionNormalTextureSkinTangent(position,normal,textureCoordinate,tangent,blendIndex,blendWeight){
			this._position=null;
			this._normal=null;
			this._textureCoordinate=null;
			this._blendIndex=null;
			this._blendWeight=null;
			this._tangent=null;
			this._position=position;
			this._normal=normal;
			this._textureCoordinate=textureCoordinate;
			this._tangent=tangent;
			this._blendIndex=blendIndex;
			this._blendWeight=blendWeight;
		}

		__class(VertexPositionNormalTextureSkinTangent,'laya.d3.graphics.VertexPositionNormalTextureSkinTangent');
		var __proto=VertexPositionNormalTextureSkinTangent.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalTextureSkinTangent._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalTextureSkinTangent,'vertexDeclaration',function(){
			return VertexPositionNormalTextureSkinTangent._vertexDeclaration;
		});

		__static(VertexPositionNormalTextureSkinTangent,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(76,[
			new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"),
			new VertexElement(24,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV"),
			new VertexElement(32,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.BLENDWEIGHT0*/"BLENDWEIGHT"),
			new VertexElement(48,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.BLENDINDICES0*/"BLENDINDICES"),
			new VertexElement(64,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.TANGENT0*/"TANGENT0")]);}
		]);
		return VertexPositionNormalTextureSkinTangent;
	})()


	/**
	*<code>VertexPositionNormalTextureTangent</code> 类用于创建位置、法线、纹理、切线顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalTextureTangent
	var VertexPositionNormalTextureTangent=(function(){
		function VertexPositionNormalTextureTangent(position,normal,textureCoordinate,tangent){
			this._position=null;
			this._normal=null;
			this._textureCoordinate=null;
			this._tangent=null;
			this._position=position;
			this._normal=normal;
			this._textureCoordinate=textureCoordinate;
			this._tangent=tangent;
		}

		__class(VertexPositionNormalTextureTangent,'laya.d3.graphics.VertexPositionNormalTextureTangent');
		var __proto=VertexPositionNormalTextureTangent.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalTextureTangent._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalTextureTangent,'vertexDeclaration',function(){
			return VertexPositionNormalTextureTangent._vertexDeclaration;
		});

		__static(VertexPositionNormalTextureTangent,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(44,[
			new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"),
			new VertexElement(24,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV"),
			new VertexElement(32,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.TANGENT0*/"TANGENT0")]);}
		]);
		return VertexPositionNormalTextureTangent;
	})()


	/**
	*@private
	*<code>LoadModel</code> 类用于模型加载。
	*/
	//class laya.d3.loaders.LoadModel
	var LoadModel=(function(){
		function LoadModel(data,mesh,materials,url){
			this._strings=['BLOCK','DATA',"STRINGS"];
			this._materials=null;
			this._fileData=null;
			this._readData=null;
			this._mesh=null;
			this._BLOCK={count:0};
			this._DATA={offset:0,size:0};
			this._STRINGS={offset:0,size:0};
			this._shaderAttributes=null;
			this._mesh=mesh;
			this._materials=materials;
			this._onLoaded(data,url);
		}

		__class(LoadModel,'laya.d3.loaders.LoadModel');
		var __proto=LoadModel.prototype;
		/**
		*@private
		*/
		__proto._onLoaded=function(data,url){
			var preBasePath=URL.basePath;
			URL.basePath=URL.getPath(URL.formatURL(url));
			this._fileData=data;
			this._readData=new Byte(this._fileData);
			this._readData.pos=0;
			var version=this._readData.readUTFString();
			this.READ_BLOCK();
			for (var i=0;i < this._BLOCK.count;i++){
				var index=this._readData.getUint16();
				var blockName=this._strings[index];
				var fn=this["READ_"+blockName];
				if (fn==null)throw new Error("model file err,no this function:"+index+" "+blockName);
				if (!fn.call(this))break ;
			}
			URL.basePath=preBasePath;
			return this._mesh;
		}

		__proto.onError=function(){}
		/**
		*@private
		*/
		__proto._readString=function(){
			return this._strings[this._readData.getUint16()];
		}

		__proto.READ_BLOCK=function(){
			var n=this._readData.getUint16();
			this._BLOCK.count=this._readData.getUint16();
			return true;
		}

		__proto.READ_DATA=function(){
			this._DATA.offset=this._readData.getUint32();
			this._DATA.size=this._readData.getUint32();
			return true;
		}

		__proto.READ_STRINGS=function(){
			this._STRINGS.offset=this._readData.getUint16();
			this._STRINGS.size=this._readData.getUint16();
			var ofs=this._readData.pos;
			this._readData.pos=this._STRINGS.offset+this._DATA.offset;
			for (var i=0;i < this._STRINGS.size;i++){
				this._strings[i]=this._readData.readUTFString();
			}
			this._readData.pos=ofs;
			return true;
		}

		__proto.READ_MATERIAL=function(){
			var i=0,n=0;
			var index=this._readData.getUint16();
			var shaderName=this._readString();
			var url=this._readString();
			if (url!=="null"){
				url=URL.formatURL(url);
				var material=Resource.materialCache[url];
				if (material){
					this._materials[index]=material;
					}else {
					material=this._materials[index]=Resource.materialCache[url]=new Material();
					material.setShaderName(shaderName);
					var loader=new Loader();
					var onComp=function (data){
						var preBasePath=URL.basePath;
						URL.basePath=URL.getPath(URL.formatURL(url));
						ClassUtils.createByJson(data,material,null,Handler.create(null,Utils3D._parseMaterial,null,false));
						URL.basePath=preBasePath;
						material.loaded=true;
						material.event(/*laya.events.Event.LOADED*/"loaded",material);
					}
					loader.once(/*laya.events.Event.COMPLETE*/"complete",null,onComp);
					loader.load(url,/*laya.net.Loader.JSON*/"json");
				}
				}else {
				this._materials[index]=new Material();
			}
			return true;
		}

		__proto.READ_MESH=function(){
			var name=this._readString();
			return true;
		}

		__proto.READ_SUBMESH=function(){
			var className=this._readString();
			var material=this._readData.getUint8();
			var bufferAttribute=this._readString();
			this._shaderAttributes=bufferAttribute.match(LoadModel._attrReg);
			var ibofs=this._readData.getUint32();
			var ibsize=this._readData.getUint32();
			var vbIndicesofs=this._readData.getUint32();
			var vbIndicessize=this._readData.getUint32();
			var vbofs=this._readData.getUint32();
			var vbsize=this._readData.getUint32();
			var boneDicofs=this._readData.getUint32();
			var boneDicsize=this._readData.getUint32();
			var arrayBuffer=this._readData.__getBuffer();
			var submesh=new SubMesh(this._mesh);
			submesh.material=material;
			submesh.verticesIndices=new Uint32Array(arrayBuffer.slice(vbIndicesofs+this._DATA.offset,vbIndicesofs+this._DATA.offset+vbIndicessize));
			var vertexDeclaration=this._getVertexDeclaration();
			var vb=VertexBuffer3D.create(vertexDeclaration,vbsize / vertexDeclaration.vertexStride,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4,true);
			var vbStart=vbofs+this._DATA.offset;
			var vbArrayBuffer=arrayBuffer.slice(vbStart,vbStart+vbsize);
			vb.setData(new Float32Array(vbArrayBuffer));
			submesh.setVB(vb);
			var vertexElements=vb.vertexDeclaration.getVertexElements();
			for (var i=0;i < vertexElements.length;i++)
			submesh._bufferUsage[(vertexElements [i]).elementUsage]=vb;
			var ib=IndexBuffer3D.create(/*laya.d3.graphics.IndexBuffer3D.INDEXTYPE_USHORT*/"ushort",ibsize / 2,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4,true);
			var ibStart=ibofs+this._DATA.offset;
			var ibArrayBuffer=arrayBuffer.slice(ibStart,ibStart+ibsize);
			ib.setData(new Uint16Array(ibArrayBuffer));
			submesh.setIB(ib,ibsize / 2);
			var boneDicArrayBuffer=arrayBuffer.slice(boneDicofs+this._DATA.offset,boneDicofs+this._DATA.offset+boneDicsize);
			submesh._setBoneDic(new Uint8Array(boneDicArrayBuffer));
			this._mesh.add(submesh);
			return true;
		}

		__proto.READ_DATAAREA=function(){
			return false;
		}

		__proto._getVertexDeclaration=function(){
			var position=false,normal=false,color=false,texcoord0=false,texcoord1=false,blendWeight=false,blendIndex=false;
			for (var i=0;i < this._shaderAttributes.length;i+=8){
				switch (this._shaderAttributes[i]){
					case "POSITION":
						position=true;
						break ;
					case "NORMAL":
						normal=true;
						break ;
					case "COLOR":
						color=true;
						break ;
					case "UV":
						texcoord0=true;
						break ;
					case "UV1":
						texcoord1=true;
						break ;
					case "BLENDWEIGHT":
						blendWeight=true;
						break ;
					case "BLENDINDICES":
						blendIndex=true;
						break ;
					}
			};
			var vertexDeclaration;
			if (position && normal && color && texcoord0 && texcoord1 && blendWeight && blendIndex)
				vertexDeclaration=VertexPositionNormalColorTexture0Texture1Skin.vertexDeclaration;
			else if (position && normal && texcoord0 && texcoord1 && blendWeight && blendIndex)
			vertexDeclaration=VertexPositionNormalTexture0Texture1Skin.vertexDeclaration;
			else if (position && normal && color && texcoord0 && blendWeight && blendIndex)
			vertexDeclaration=VertexPositionNormalColorTextureSkin.vertexDeclaration;
			else if (position && normal && texcoord0 && blendWeight && blendIndex)
			vertexDeclaration=VertexPositionNormalTextureSkin.vertexDeclaration;
			else if (position && normal && color && blendWeight && blendIndex)
			vertexDeclaration=VertexPositionNormalColorSkin.vertexDeclaration;
			else if (position && normal && color && texcoord0 && texcoord1)
			vertexDeclaration=VertexPositionNormalColorTexture0Texture1.vertexDeclaration;
			else if (position && normal && texcoord0 && texcoord1)
			vertexDeclaration=VertexPositionNormalTexture0Texture1.vertexDeclaration;
			else if (position && normal && color && texcoord0)
			vertexDeclaration=VertexPositionNormalColorTexture.vertexDeclaration;
			else if (position && normal && texcoord0)
			vertexDeclaration=VertexPositionNormalTexture.vertexDeclaration;
			else if (position && normal && color)
			vertexDeclaration=VertexPositionNormalColor.vertexDeclaration;
			return vertexDeclaration;
		}

		__getset(0,__proto,'mesh',function(){
			return this._mesh;
		});

		LoadModel._attrReg=new RegExp("(\\w+)|([:,;])","g");
		return LoadModel;
	})()


	/**
	*<code>BoundBox</code> 类用于创建包围盒。
	*/
	//class laya.d3.math.BoundBox
	var BoundBox=(function(){
		function BoundBox(min,max){
			this.min=null;
			this.max=null;
			this.min=min;
			this.max=max;
		}

		__class(BoundBox,'laya.d3.math.BoundBox');
		var __proto=BoundBox.prototype;
		/**
		*获取包围盒的8个角顶点。
		*@param corners 返回顶点的输出队列。
		*/
		__proto.GetCorners=function(corners){
			corners.length=8;
			var mine=this.min.elements;
			var maxe=this.max.elements;
			var minX=mine[0];
			var minY=mine[1];
			var minZ=mine[2];
			var maxX=maxe[0];
			var maxY=maxe[1];
			var maxZ=maxe[2];
			corners[0]=new Vector3(minX,maxY,maxZ);
			corners[1]=new Vector3(maxX,maxY,maxZ);
			corners[2]=new Vector3(maxX,minY,maxZ);
			corners[3]=new Vector3(minX,minY,maxZ);
			corners[4]=new Vector3(minX,maxY,minZ);
			corners[5]=new Vector3(maxX,maxY,minZ);
			corners[6]=new Vector3(maxX,minY,minZ);
			corners[7]=new Vector3(minX,minY,minZ);
		}

		BoundBox.fromPoints=function(points,out){
			if (points==null)
				throw new Error("points");
			var min=new Vector3(Number.MAX_VALUE);
			var max=new Vector3(-Number.MAX_VALUE);
			for (var i=0;i < points.length;++i){
				Vector3.min(min,points[i],min);
				Vector3.max(max,points[i],max);
			}
			out.min=min;
			out.max=max;
		}

		return BoundBox;
	})()


	/**
	*<code>BoundSphere</code> 类用于创建包围球。
	*/
	//class laya.d3.math.BoundSphere
	var BoundSphere=(function(){
		function BoundSphere(center,radius){
			this.center=null;
			this.radius=NaN;
			this.center=center;
			this.radius=radius;
		}

		__class(BoundSphere,'laya.d3.math.BoundSphere');
		BoundSphere.fromSubPoints=function(points,start,count,out){
			if (points==null){
				throw new Error("points");
			}
			if (start < 0 || start >=points.length){
				throw new Error("start"+start+"Must be in the range [0, "+(points.length-1)+"]");
			}
			if (count < 0 || (start+count)> points.length){
				throw new Error("count"+count+"Must be in the range <= "+points.length+"}");
			};
			var upperEnd=start+count;
			var center=BoundSphere._tempVector3;
			center.elements[0]=0;
			center.elements[1]=0;
			center.elements[2]=0;
			for (var i=start;i < upperEnd;++i){
				Vector3.add(points[i],center,center);
			}
			Vector3.scale(center,1 / count,center);
			var radius=0.0;
			for (i=start;i < upperEnd;++i){
				var distance=Vector3.distanceSquared(center,points[i]);
				if (distance > radius)
					radius=distance;
			}
			radius=Math.sqrt(radius);
			out.center=center;
			out.radius=radius;
		}

		BoundSphere.fromPoints=function(points,out){
			if (points==null){
				throw new Error("points");
			}
			BoundSphere.fromSubPoints(points,0,points.length,out);
		}

		__static(BoundSphere,
		['_tempVector3',function(){return this._tempVector3=new Vector3();}
		]);
		return BoundSphere;
	})()


	/**
	*<code>Collision</code> 类用于检测碰撞。
	*/
	//class laya.d3.math.Collision
	var Collision=(function(){
		/**
		*创建一个 <code>Collision</code> 实例。
		*/
		function Collision(){}
		__class(Collision,'laya.d3.math.Collision');
		Collision.distancePlaneToPoint=function(plane,point){
			var dot=Vector3.dot(plane.normal,point);
			return dot-plane.distance;
		}

		Collision.distanceBoxToPoint=function(box,point){
			var boxMine=box.min.elements;
			var boxMineX=boxMine[0];
			var boxMineY=boxMine[1];
			var boxMineZ=boxMine[2];
			var boxMaxe=box.max.elements;
			var boxMaxeX=boxMaxe[0];
			var boxMaxeY=boxMaxe[1];
			var boxMaxeZ=boxMaxe[2];
			var pointe=point.elements;
			var pointeX=pointe[0];
			var pointeY=pointe[1];
			var pointeZ=pointe[2];
			var distance=0;
			if (pointeX < boxMineX)
				distance+=(boxMineX-pointeX)*(boxMineX-pointeX);
			if (pointeX > boxMaxeX)
				distance+=(boxMaxeX-pointeX)*(boxMaxeX-pointeX);
			if (pointeY < boxMineY)
				distance+=(boxMineY-pointeY)*(boxMineY-pointeY);
			if (pointeY > boxMaxeY)
				distance+=(boxMaxeY-pointeY)*(boxMaxeY-pointeY);
			if (pointeZ < boxMineZ)
				distance+=(boxMineZ-pointeZ)*(boxMineZ-pointeZ);
			if (pointeZ > boxMaxeZ)
				distance+=(boxMaxeZ-pointeZ)*(boxMaxeZ-pointeZ);
			return Math.sqrt(distance);
		}

		Collision.distanceBoxToBox=function(box1,box2){
			var box1Mine=box1.min.elements;
			var box1MineX=box1Mine[0];
			var box1MineY=box1Mine[1];
			var box1MineZ=box1Mine[2];
			var box1Maxe=box1.max.elements;
			var box1MaxeX=box1Maxe[0];
			var box1MaxeY=box1Maxe[1];
			var box1MaxeZ=box1Maxe[2];
			var box2Mine=box2.min.elements;
			var box2MineX=box2Mine[0];
			var box2MineY=box2Mine[1];
			var box2MineZ=box2Mine[2];
			var box2Maxe=box2.max.elements;
			var box2MaxeX=box2Maxe[0];
			var box2MaxeY=box2Maxe[1];
			var box2MaxeZ=box2Maxe[2];
			var distance=0;
			if (box1MineX > box2MaxeX){
				var delta=box1MineX-box2MaxeX;
				distance+=delta *delta;
			}
			else if(box2MineX > box1MaxeX){
				var delta=box2MineX-box1MaxeX;
				distance+=delta *delta;
			}
			if (box1MineY > box2MaxeY){
				var delta=box1MineY-box2MaxeY;
				distance+=delta *delta;
			}
			else if(box2MineY > box1MaxeY){
				var delta=box2MineY-box1MaxeY;
				distance+=delta *delta;
			}
			if (box1MineZ > box2MaxeZ){
				var delta=box1MineZ-box2MaxeZ;
				distance+=delta *delta;
			}
			else if(box2MineZ > box1MaxeZ){
				var delta=box2MineZ-box1MaxeZ;
				distance+=delta *delta;
			}
			return Math.sqrt(distance);
		}

		Collision.distanceSphereToPoint=function(sphere,point){
			var distance=Math.sqrt(Vector3.distanceSquared(sphere.center,point));
			distance-=sphere.radius;
			return Math.max(distance,0);
		}

		Collision.distanceSphereToSphere=function(sphere1,sphere2){
			var distance=Math.sqrt(Vector3.distanceSquared(sphere1.center,sphere2.center));
			distance-=sphere1.radius+sphere2.radius;
			return Math.max(distance,0);
		}

		Collision.intersectsRayAndPoint=function(ray,point){
			Vector3.subtract(ray.origin,point,Collision._tempV30);
			var b=Vector3.dot(Collision._tempV30,ray.direction);
			var c=Vector3.dot(Collision._tempV30,Collision._tempV30)-MathUtils3D.zeroTolerance;
			if (c > 0 && b > 0)
				return false;
			var discriminant=b *b-c;
			if (discriminant < 0)
				return false;
			return true;
		}

		Collision.intersectsRayAndRay=function(ray1,ray2,out){
			var ray1o=ray1.origin;
			var ray1oe=ray1o.elements;
			var ray1oeX=ray1oe[0];
			var ray1oeY=ray1oe[1];
			var ray1oeZ=ray1oe[2];
			var ray1d=ray1.direction;
			var ray1de=ray1d.elements;
			var ray1deX=ray1de[0];
			var ray1deY=ray1de[1];
			var ray1deZ=ray1de[2];
			var ray2o=ray2.origin;
			var ray2oe=ray2o.elements;
			var ray2oeX=ray2oe[0];
			var ray2oeY=ray2oe[1];
			var ray2oeZ=ray2oe[2];
			var ray2d=ray2.direction;
			var ray2de=ray2d.elements;
			var ray2deX=ray2de[0];
			var ray2deY=ray2de[1];
			var ray2deZ=ray2de[2];
			Vector3.cross(ray1d,ray2d,Collision._tempV30);
			var tempV3e=Collision._tempV30.elements;
			var denominator=Vector3.scalarLength(Collision._tempV30);
			if (MathUtils3D.isZero(denominator)){
				if (MathUtils3D.nearEqual(ray2oeX,ray1oeX)&& MathUtils3D.nearEqual(ray2oeY,ray1oeY)&& MathUtils3D.nearEqual(ray2oeZ,ray1oeZ)){
					out=Vector3.ZERO;
					return true;
				}
			}
			denominator=denominator *denominator;
			var m11=ray2oeX-ray1oeX;
			var m12=ray2oeY-ray1oeY;
			var m13=ray2oeZ-ray1oeZ;
			var m21=ray2deX;
			var m22=ray2deY;
			var m23=ray2deZ;
			var m31=tempV3e[0];
			var m32=tempV3e[1];
			var m33=tempV3e[2];
			var dets=m11 *m22 *m33+m12 *m23 *m31+m13 *m21 *m32-m11 *m23 *m32-m12 *m21 *m33-m13 *m22 *m31;
			m21=ray1deX;
			m22=ray1deY;
			m23=ray1deZ;
			var dett=m11 *m22 *m33+m12 *m23 *m31+m13 *m21 *m32-m11 *m23 *m32-m12 *m21 *m33-m13 *m22 *m31;
			var s=dets / denominator;
			var t=dett / denominator;
			Vector3.scale(ray1d,s,Collision._tempV30);
			Vector3.scale(ray2d,s,Collision._tempV31);
			Vector3.add(ray1o,Collision._tempV30,Collision._tempV32);
			Vector3.add(ray2o,Collision._tempV31,Collision._tempV33);
			var point1e=Collision._tempV32.elements;
			var point2e=Collision._tempV33.elements;
			if (!MathUtils3D.nearEqual(point2e[0],point1e[0])|| !MathUtils3D.nearEqual(point2e[1],point1e[1])|| !MathUtils3D.nearEqual(point2e[2],point1e[2])){
				out=Vector3.ZERO;
				return false;
			}
			out=Collision._tempV32;
			return true;
		}

		Collision.intersectsRayAndPlaneRD=function(ray,plane,out){
			var planeNor=plane.normal;
			var direction=Vector3.dot(planeNor,ray.direction);
			if (MathUtils3D.isZero(direction)){
				out=0;
				return false;
			};
			var position=Vector3.dot(planeNor,ray.origin);
			out=(-plane.distance-position)/ direction;
			if (out < 0){
				out=0;
				return false;
			}
			return true;
		}

		Collision.intersectsRayAndPlaneRP=function(ray,plane,out){
			var distance=NaN;
			if (!Collision.intersectsRayAndPlaneRD(ray,plane,distance)){
				out=Vector3.ZERO;
				return false;
			}
			Vector3.scale(ray.direction,distance,Collision._tempV30);
			Vector3.add(ray.origin,Collision._tempV30,Collision._tempV31);
			out=Collision._tempV31;
			return true;
		}

		Collision.intersectsRayAndBoxRD=function(ray,box,out){
			var rayoe=ray.origin.elements;;
			var rayoeX=rayoe[0];
			var rayoeY=rayoe[1];
			var rayoeZ=rayoe[2];
			var rayde=ray.direction.elements;
			var raydeX=rayde[0];
			var raydeY=rayde[1];
			var raydeZ=rayde[2];
			var boxMine=box.min.elements;
			var boxMineX=boxMine[0];
			var boxMineY=boxMine[1];
			var boxMineZ=boxMine[2];
			var boxMaxe=box.max.elements;
			var boxMaxeX=boxMaxe[0];
			var boxMaxeY=boxMaxe[1];
			var boxMaxeZ=boxMaxe[2];
			out=0;
			var tmax=MathUtils3D.MaxValue;
			if (MathUtils3D.isZero(raydeX)){
				if (rayoeX < boxMineX || rayoeX > boxMaxeX){
					out=0;
					return false;
				}
				}else{
				var inverse=1 / raydeX;
				var t1=(boxMineX-rayoeX)*inverse;
				var t2=(boxMaxeX-rayoeX)*inverse;
				if (t1 > t2){
					var temp=t1;
					t1=t2;
					t2=temp;
				}
				out=Math.max(t1,out);
				tmax=Math.min(t2,tmax);
				if (out > tmax){
					out=0;
					return false;
				}
			}
			if (MathUtils3D.isZero(raydeY)){
				if (rayoeY < boxMineY || rayoeY > boxMaxeY){
					out=0;
					return false;
				}
				}else{
				var inverse=1 / raydeY;
				var t1=(boxMineY-rayoeY)*inverse;
				var t2=(boxMaxeY-rayoeY)*inverse;
				if (t1 > t2){
					var temp=t1;
					t1=t2;
					t2=temp;
				}
				out=Math.max(t1,out);
				tmax=Math.min(t2,tmax);
				if (out > tmax){
					out=0;
					return false;
				}
			}
			if (MathUtils3D.isZero(raydeZ)){
				if (rayoeZ < boxMineZ || rayoeZ > boxMaxeZ){
					out=0;
					return false;
				}
				}else{
				var inverse=1 / raydeZ;
				var t1=(boxMineZ-rayoeZ)*inverse;
				var t2=(boxMaxeZ-rayoeZ)*inverse;
				if (t1 > t2){
					var temp=t1;
					t1=t2;
					t2=temp;
				}
				out=Math.max(t1,out);
				tmax=Math.min(t2,tmax);
				if (out > tmax){
					out=0;
					return false;
				}
			}
			return true;
		}

		Collision.intersectsRayAndBoxRP=function(ray,box,out){
			var distance=NaN;
			if (!Collision.intersectsRayAndBoxRD(ray,box,distance)){
				out=Vector3.ZERO;
				return false;
			}
			Vector3.scale(ray.direction,distance,Collision._tempV30);
			Vector3.add(ray.origin,Collision._tempV30,Collision._tempV31);
			out=Collision._tempV31;
			return true;
		}

		Collision.intersectsRayAndSphereRD=function(ray,sphere,out){
			var sphereR=sphere.radius;
			Vector3.subtract(ray.origin,sphere.center,Collision._tempV30);
			var b=Vector3.dot(Collision._tempV30,ray.direction);
			var c=Vector3.dot(Collision._tempV30,Collision._tempV30)-(sphereR *sphereR);
			if (c > 0 && b > 0){
				out=0;
				return false;
			};
			var discriminant=b *b-c;
			if (discriminant < 0){
				out=0;
				return false;
			}
			out=-b-Math.sqrt(discriminant);
			if (out < 0)
				out=0;
			return true;
		}

		Collision.intersectsRayAndSphereRP=function(ray,sphere,out){
			var distance=NaN;
			if (!Collision.intersectsRayAndSphereRD(ray,sphere,distance)){
				out=Vector3.ZERO;
				return false;
			}
			Vector3.scale(ray.direction,distance,Collision._tempV30);
			Vector3.add(ray.origin,Collision._tempV30,Collision._tempV31);
			out=Collision._tempV31;
			return true;
		}

		Collision.intersectsPlaneAndPoint=function(plane,point){
			var distance=Vector3.dot(plane.normal,point)+plane.distance;
			if (distance > 0)
				return Plane.PlaneIntersectionType_Front;
			else if (distance < 0)
			return Plane.PlaneIntersectionType_Back;
			else
			return Plane.PlaneIntersectionType_Intersecting;
		}

		Collision.intersectsPlaneAndPlane=function(plane1,plane2){
			Vector3.cross(plane1.normal,plane2.normal,Collision._tempV30);
			var denominator=Vector3.dot(Collision._tempV30,Collision._tempV30);
			if (MathUtils3D.isZero(denominator))
				return false;
			return true;
		}

		Collision.intersectsPlaneAndPlaneRL=function(plane1,plane2,line){
			var plane1nor=plane1.normal;
			var plane2nor=plane2.normal;
			Vector3.cross(plane1nor,plane2nor,Collision._tempV34);
			var denominator=Vector3.dot(Collision._tempV34,Collision._tempV34);
			if (MathUtils3D.isZero(denominator))
				return false;
			Vector3.scale(plane2nor,plane1.distance,Collision._tempV30);
			Vector3.scale(plane1nor,plane2.distance,Collision._tempV31);
			Vector3.subtract(Collision._tempV30,Collision._tempV31,Collision._tempV32);
			Vector3.cross(Collision._tempV32,Collision._tempV34,Collision._tempV33);
			Vector3.normalize(Collision._tempV34,Collision._tempV34);
			line=new Ray(Collision._tempV33,Collision._tempV34);
			return true;
		}

		Collision.intersectsPlaneAndBox=function(plane,box){
			var planeD=plane.distance;
			var planeNor=plane.normal;
			var planeNore=planeNor.elements;
			var planeNoreX=planeNore[0];
			var planeNoreY=planeNore[1];
			var planeNoreZ=planeNore[2];
			var boxMine=box.min.elements;
			var boxMineX=boxMine[0];
			var boxMineY=boxMine[1];
			var boxMineZ=boxMine[2];
			var boxMaxe=box.max.elements;
			var boxMaxeX=boxMaxe[0];
			var boxMaxeY=boxMaxe[1];
			var boxMaxeZ=boxMaxe[2];
			Collision._tempV30.elements[0]=(planeNoreX > 0)? boxMineX :boxMaxeX;
			Collision._tempV30.elements[1]=(planeNoreY > 0)? boxMineY :boxMaxeY;
			Collision._tempV30.elements[2]=(planeNoreZ > 0)? boxMineZ :boxMaxeZ;
			Collision._tempV31.elements[0]=(planeNoreX > 0)? boxMaxeX :boxMineX;
			Collision._tempV31.elements[1]=(planeNoreY > 0)? boxMaxeY :boxMineY;
			Collision._tempV31.elements[2]=(planeNoreZ > 0)? boxMaxeZ :boxMineZ;
			var distance=Vector3.dot(planeNor,Collision._tempV30);
			if (distance+planeD > 0)
				return Plane.PlaneIntersectionType_Front;
			distance=Vector3.dot(planeNor,Collision._tempV31);
			if (distance+planeD < 0)
				return Plane.PlaneIntersectionType_Back;
			return Plane.PlaneIntersectionType_Intersecting;
		}

		Collision.intersectsPlaneAndSphere=function(plane,sphere){
			var sphereR=sphere.radius;
			var distance=Vector3.dot(plane.normal,sphere.center)+plane.distance;
			if (distance > sphereR)
				return Plane.PlaneIntersectionType_Front;
			if (distance <-sphereR)
				return Plane.PlaneIntersectionType_Back;
			return Plane.PlaneIntersectionType_Intersecting;
		}

		Collision.intersectsBoxAndBox=function(box1,box2){
			var box1Mine=box1.min.elements;
			var box1MineY=box1Mine[1];
			var box1MineZ=box1Mine[2];
			var box1Maxe=box1.max.elements;
			var box1MaxeY=box1Maxe[1];
			var box1MaxeZ=box1Maxe[2];
			var box2Mine=box2.min.elements;
			var box2MineY=box2Mine[1];
			var box2MineZ=box2Mine[2];
			var box2Maxe=box2.max.elements;
			var box2MaxeY=box2Maxe[1];
			var box2MaxeZ=box2Maxe[2];
			if (box1Mine[0] > box2Maxe[0] || box2Mine[0] > box1Maxe[0])
				return false;
			if (box1Mine[1] > box2Maxe[1] || box2Mine[1] > box1Maxe[1])
				return false;
			if (box1Mine[2] > box2Maxe[2] || box2Mine[2] > box1Maxe[2])
				return false;
			return true;
		}

		Collision.intersectsBoxAndSphere=function(box,sphere){
			var sphereC=sphere.center;
			var sphereR=sphere.radius;
			Vector3.Clamp(sphereC,box.min,box.max,Collision._tempV30);
			var distance=Vector3.distanceSquared(sphereC,Collision._tempV30);
			return distance <=sphereR *sphereR;
		}

		Collision.intersectsSphereAndSphere=function(sphere1,sphere2){
			var radiisum=sphere1.radius+sphere2.radius;
			return Vector3.distanceSquared(sphere1.center,sphere2.center)<=radiisum *radiisum;
		}

		__static(Collision,
		['_tempV30',function(){return this._tempV30=new Vector3();},'_tempV31',function(){return this._tempV31=new Vector3();},'_tempV32',function(){return this._tempV32=new Vector3();},'_tempV33',function(){return this._tempV33=new Vector3();},'_tempV34',function(){return this._tempV34=new Vector3();}
		]);
		return Collision;
	})()


	/**
	*<code>MathUtils</code> 类用于创建数学工具。
	*/
	//class laya.d3.math.MathUtils3D
	var MathUtils3D=(function(){
		/**
		*创建一个 <code>MathUtils</code> 实例。
		*/
		function MathUtils3D(){}
		__class(MathUtils3D,'laya.d3.math.MathUtils3D');
		MathUtils3D.isZero=function(v){
			return Math.abs(v)< MathUtils3D.zeroTolerance;
		}

		MathUtils3D.nearEqual=function(n1,n2){
			if (MathUtils3D.isZero(n1-n2))
				return true;
			return false;
		}

		__static(MathUtils3D,
		['zeroTolerance',function(){return this.zeroTolerance=1e-6;},'MaxValue',function(){return this.MaxValue=3.40282347e+38;},'MinValue',function(){return this.MinValue=-3.40282347e+38;}
		]);
		return MathUtils3D;
	})()


	/**
	*<code>Matrix3x3</code> 类用于创建3x3矩阵。
	*/
	//class laya.d3.math.Matrix3x3
	var Matrix3x3=(function(){
		function Matrix3x3(){
			//this.elements=null;
			var e=this.elements=new Float32Array(9);
			e[0]=1;
			e[1]=0;
			e[2]=0;
			e[3]=0;
			e[4]=1;
			e[5]=0;
			e[6]=0;
			e[7]=0;
			e[8]=1;
		}

		__class(Matrix3x3,'laya.d3.math.Matrix3x3');
		var __proto=Matrix3x3.prototype;
		/**
		*计算3x3矩阵的行列式
		*@return 矩阵的行列式
		*/
		__proto.determinant=function(){
			var f=this.elements;
			var a00=f[0],a01=f[1],a02=f[2];
			var a10=f[3],a11=f[4],a12=f[5];
			var a20=f[6],a21=f[7],a22=f[8];
			return a00 *(a22 *a11-a12 *a21)+a01 *(-a22 *a10+a12 *a20)+a02 *(a21 *a10-a11 *a20);
		}

		/**
		*通过一个二维向量转换3x3矩阵
		*@param tra 转换向量
		*@param out 输出矩阵
		*/
		__proto.translate=function(trans,out){
			var e=out.elements;
			var f=this.elements;
			var g=trans.elements;
			var a00=f[0],a01=f[1],a02=f[2];
			var a10=f[3],a11=f[4],a12=f[5];
			var a20=f[6],a21=f[7],a22=f[8];
			var x=g[0],y=g[1];
			e[0]=a00;
			e[1]=a01;
			e[2]=a02;
			e[3]=a10;
			e[4]=a11;
			e[5]=a12;
			e[6]=x *a00+y *a10+a20;
			e[7]=x *a01+y *a11+a21;
			e[8]=x *a02+y *a12+a22;
		}

		/**
		*根据指定角度旋转3x3矩阵
		*@param rad 旋转角度
		*@param out 输出矩阵
		*/
		__proto.rotate=function(rad,out){
			var e=out.elements;
			var f=this.elements;
			var a00=f[0],a01=f[1],a02=f[2];
			var a10=f[3],a11=f[4],a12=f[5];
			var a20=f[6],a21=f[7],a22=f[8];
			var s=Math.sin(rad);
			var c=Math.cos(rad);
			e[0]=c *a00+s *a10;
			e[1]=c *a01+s *a11;
			e[2]=c *a02+s *a12;
			e[3]=c *a10-s *a00;
			e[4]=c *a11-s *a01;
			e[5]=c *a12-s *a02;
			e[6]=a20;
			e[7]=a21;
			e[8]=a22;
		}

		/**
		*根据制定缩放3x3矩阵
		*@param scale 缩放值
		*@param out 输出矩阵
		*/
		__proto.scale=function(scale,out){
			var e=out.elements;
			var f=this.elements;
			var g=scale.elements;
			var x=g[0],y=g[1];
			e[0]=x *f[0];
			e[1]=x *f[1];
			e[2]=x *f[2];
			e[3]=y *f[3];
			e[4]=y *f[4];
			e[5]=y *f[5];
			e[6]=f[6];
			e[7]=f[7];
			e[8]=f[8];
		}

		/**
		*计算3x3矩阵的逆矩阵
		*@param out 输出的逆矩阵
		*/
		__proto.invert=function(out){
			var e=out.elements;
			var f=this.elements;
			var a00=f[0],a01=f[1],a02=f[2];
			var a10=f[3],a11=f[4],a12=f[5];
			var a20=f[6],a21=f[7],a22=f[8];
			var b01=a22 *a11-a12 *a21;
			var b11=-a22 *a10+a12 *a20;
			var b21=a21 *a10-a11 *a20;
			var det=a00 *b01+a01 *b11+a02 *b21;
			if (!det){
				out=null;
			}
			det=1.0 / det;
			e[0]=b01 *det;
			e[1]=(-a22 *a01+a02 *a21)*det;
			e[2]=(a12 *a01-a02 *a11)*det;
			e[3]=b11 *det;
			e[4]=(a22 *a00-a02 *a20)*det;
			e[5]=(-a12 *a00+a02 *a10)*det;
			e[6]=b21 *det;
			e[7]=(-a21 *a00+a01 *a20)*det;
			e[8]=(a11 *a00-a01 *a10)*det;
		}

		/**
		*计算3x3矩阵的转置矩阵
		*@param out 输出矩阵
		*/
		__proto.transpose=function(out){
			var e=out.elements;
			var f=this.elements;
			if (out===this){
				var a01=f[1],a02=f[2],a12=f[5];
				e[1]=f[3];
				e[2]=f[6];
				e[3]=a01;
				e[5]=f[7];
				e[6]=a02;
				e[7]=a12;
				}else {
				e[0]=f[0];
				e[1]=f[3];
				e[2]=f[6];
				e[3]=f[1];
				e[4]=f[4];
				e[5]=f[7];
				e[6]=f[2];
				e[7]=f[5];
				e[8]=f[8];
			}
		}

		/**设置已有的矩阵为单位矩阵*/
		__proto.identity=function(){
			var e=this.elements;
			e[0]=1;
			e[1]=0;
			e[2]=0;
			e[3]=0;
			e[4]=1;
			e[5]=0;
			e[6]=0;
			e[7]=0;
			e[8]=1;
		}

		/**
		*克隆一个3x3矩阵
		*@param out 输出的3x3矩阵
		*/
		__proto.cloneTo=function(out){
			var i,s,d;
			s=this.elements;
			d=out.elements;
			if (s===d){
				return;
			}
			for (i=0;i < 9;++i){
				d[i]=s[i];
			}
		}

		/**
		*从一个3x3矩阵复制
		*@param sou 源3x3矩阵
		*/
		__proto.copyFrom=function(sou){
			var i,s,d;
			s=sou.elements;
			d=this.elements;
			if (s===d){
				return;
			}
			for (i=0;i < 9;++i){
				d[i]=s[i];
			}
		}

		/**
		*从一个数组复制
		*@param sou 源Float32Array数组
		*/
		__proto.copyFromArray=function(sou){
			var i,d;
			d=this.elements;
			if (sou===d){
				return;
			}
			for (i=0;i < 9;++i){
				d[i]=sou[i];
			}
		}

		Matrix3x3.createFromTranslation=function(trans,out){
			var e=out.elements;
			var g=trans.elements;
			out[0]=1;
			out[1]=0;
			out[2]=0;
			out[3]=0;
			out[4]=1;
			out[5]=0;
			out[6]=g[0];
			out[7]=g[1];
			out[8]=1;
		}

		Matrix3x3.createFromRotation=function(rad,out){
			var e=out.elements;
			var s=Math.sin(rad),c=Math.cos(rad);
			e[0]=c;
			e[1]=s;
			e[2]=0;
			e[3]=-s;
			e[4]=c;
			e[5]=0;
			e[6]=0;
			e[7]=0;
			e[8]=1;
		}

		Matrix3x3.createFromScaling=function(scale,out){
			var e=out.elements;
			var g=scale.elements;
			e[0]=g[0];
			e[1]=0;
			e[2]=0;
			e[3]=0;
			e[4]=g[1];
			e[5]=0;
			e[6]=0;
			e[7]=0;
			e[8]=1;
		}

		Matrix3x3.createFromMatrix4x4=function(sou,out){
			out[0]=sou[0];
			out[1]=sou[1];
			out[2]=sou[2];
			out[3]=sou[4];
			out[4]=sou[5];
			out[5]=sou[6];
			out[6]=sou[8];
			out[7]=sou[9];
			out[8]=sou[10];
		}

		Matrix3x3.multiply=function(left,right,out){
			var e=out.elements;
			var f=left.elements;
			var g=right.elements;
			var a00=f[0],a01=f[1],a02=f[2];
			var a10=f[3],a11=f[4],a12=f[5];
			var a20=f[6],a21=f[7],a22=f[8];
			var b00=g[0],b01=g[1],b02=g[2];
			var b10=g[3],b11=g[4],b12=g[5];
			var b20=g[6],b21=g[7],b22=g[8];
			e[0]=b00 *a00+b01 *a10+b02 *a20;
			e[1]=b00 *a01+b01 *a11+b02 *a21;
			e[2]=b00 *a02+b01 *a12+b02 *a22;
			e[3]=b10 *a00+b11 *a10+b12 *a20;
			e[4]=b10 *a01+b11 *a11+b12 *a21;
			e[5]=b10 *a02+b11 *a12+b12 *a22;
			e[6]=b20 *a00+b21 *a10+b22 *a20;
			e[7]=b20 *a01+b21 *a11+b22 *a21;
			e[8]=b20 *a02+b21 *a12+b22 *a22;
		}

		Matrix3x3.DEFAULT=new Matrix3x3();
		return Matrix3x3;
	})()


	/**
	*<code>Matrix4x4</code> 类用于创建4x4矩阵。
	*/
	//class laya.d3.math.Matrix4x4
	var Matrix4x4=(function(){
		function Matrix4x4(){
			//this.elements=null;
			var e=this.elements=new Float32Array(16);
			e[0]=e[5]=e[10]=e[15]=1;
		}

		__class(Matrix4x4,'laya.d3.math.Matrix4x4');
		var __proto=Matrix4x4.prototype;
		/**
		*分解矩阵
		*@param translation 平移
		*@param rotation 旋转
		*@param scale 缩放
		*@return 是否成功
		*/
		__proto.decompose=function(translation,rotation,scale){
			var me=this.elements;
			var te=translation.elements;
			var re=rotation.elements;
			var se=scale.elements;
			te[0]=me[12];
			te[1]=me[13];
			te[2]=me[14];
			se[0]=Math.sqrt((me[0] *me[0])+(me[1] *me[1])+(me[2] *me[2]));
			se[1]=Math.sqrt((me[4] *me[4])+(me[5] *me[5])+(me[6] *me[6]));
			se[2]=Math.sqrt((me[8] *me[8])+(me[9] *me[9])+(me[10] *me[10]));
			if (MathUtils3D.isZero(se[0])|| MathUtils3D.isZero(se[1])|| MathUtils3D.isZero(se[2])){
				re[0]=re[1]=re[2]=0;
				re[3]=1;
				return false;
			};
			var rotationmatrix=new Matrix4x4();
			var rme=rotationmatrix.elements;
			rme[0]=me[0] / se[0];
			rme[1]=me[1] / se[0];
			rme[2]=me[2] / se[0];
			rme[4]=me[4] / se[1];
			rme[5]=me[5] / se[1];
			rme[6]=me[6] / se[1];
			rme[8]=me[8] / se[2];
			rme[9]=me[9] / se[2];
			rme[10]=me[10] / se[2];
			rotationmatrix[15]=1;
			Quaternion.createFromMatrix4x4(rotationmatrix,rotation);
			return true;
		}

		/**归一化矩阵 */
		__proto.normalize=function(){
			var v=this.elements;
			var c=v[0],d=v[1],e=v[2],g=Math.sqrt(c *c+d *d+e *e);
			if (g){
				if (g==1)
					return;
				}else {
				v[0]=0;
				v[1]=0;
				v[2]=0;
				return;
			}
			g=1 / g;
			v[0]=c *g;
			v[1]=d *g;
			v[2]=e *g;
		}

		/**计算矩阵的转置矩阵*/
		__proto.transpose=function(){
			var e,t;
			e=this.elements;
			t=e[1];
			e[1]=e[4];
			e[4]=t;
			t=e[2];
			e[2]=e[8];
			e[8]=t;
			t=e[3];
			e[3]=e[12];
			e[12]=t;
			t=e[6];
			e[6]=e[9];
			e[9]=t;
			t=e[7];
			e[7]=e[13];
			e[13]=t;
			t=e[11];
			e[11]=e[14];
			e[14]=t;
			return this;
		}

		/**
		*计算一个矩阵的逆矩阵
		*@param out 输出矩阵
		*/
		__proto.invert=function(out){
			var ae=this.elements;
			var oe=out.elements;
			var a00=ae[0],a01=ae[1],a02=ae[2],a03=ae[3],a10=ae[4],a11=ae[5],a12=ae[6],a13=ae[7],a20=ae[8],a21=ae[9],a22=ae[10],a23=ae[11],a30=ae[12],a31=ae[13],a32=ae[14],a33=ae[15],
			b00=a00 *a11-a01 *a10,b01=a00 *a12-a02 *a10,b02=a00 *a13-a03 *a10,b03=a01 *a12-a02 *a11,b04=a01 *a13-a03 *a11,b05=a02 *a13-a03 *a12,b06=a20 *a31-a21 *a30,b07=a20 *a32-a22 *a30,b08=a20 *a33-a23 *a30,b09=a21 *a32-a22 *a31,b10=a21 *a33-a23 *a31,b11=a22 *a33-a23 *a32,
			det=b00 *b11-b01 *b10+b02 *b09+b03 *b08-b04 *b07+b05 *b06;
			if (Math.abs(det)===0.0){
				return;
			}
			det=1.0 / det;
			oe[0]=(a11 *b11-a12 *b10+a13 *b09)*det;
			oe[1]=(a02 *b10-a01 *b11-a03 *b09)*det;
			oe[2]=(a31 *b05-a32 *b04+a33 *b03)*det;
			oe[3]=(a22 *b04-a21 *b05-a23 *b03)*det;
			oe[4]=(a12 *b08-a10 *b11-a13 *b07)*det;
			oe[5]=(a00 *b11-a02 *b08+a03 *b07)*det;
			oe[6]=(a32 *b02-a30 *b05-a33 *b01)*det;
			oe[7]=(a20 *b05-a22 *b02+a23 *b01)*det;
			oe[8]=(a10 *b10-a11 *b08+a13 *b06)*det;
			oe[9]=(a01 *b08-a00 *b10-a03 *b06)*det;
			oe[10]=(a30 *b04-a31 *b02+a33 *b00)*det;
			oe[11]=(a21 *b02-a20 *b04-a23 *b00)*det;
			oe[12]=(a11 *b07-a10 *b09-a12 *b06)*det;
			oe[13]=(a00 *b09-a01 *b07+a02 *b06)*det;
			oe[14]=(a31 *b01-a30 *b03-a32 *b00)*det;
			oe[15]=(a20 *b03-a21 *b01+a22 *b00)*det;
		}

		/**设置矩阵为单位矩阵*/
		__proto.identity=function(){
			var e=this.elements;
			e[1]=e[2]=e[3]=e[4]=e[6]=e[7]=e[8]=e[9]=e[11]=e[12]=e[13]=e[14]=0;
			e[0]=e[5]=e[10]=e[15]=1;
		}

		/**
		*克隆一个4x4矩阵
		*@param out 输出的4x4矩阵
		*/
		__proto.cloneTo=function(out){
			var i,s,d;
			s=this.elements;
			d=out.elements;
			if (s===d){
				return;
			}
			for (i=0;i < 16;++i){
				d[i]=s[i];
			}
		}

		/**
		*从一个4x4矩阵复制
		*@param sou 源4x4矩阵
		*/
		__proto.copyFrom=function(sou){
			var i,s,d;
			s=sou.elements;
			d=this.elements;
			if (s===d){
				return;
			}
			for (i=0;i < 16;++i){
				d[i]=s[i];
			}
		}

		/**
		*从一个数组复制
		*@param sou 源Float32Array数组
		*/
		__proto.copyFromArray=function(sou){
			var i,d;
			d=this.elements;
			if (sou===d){
				return;
			}
			for (i=0;i < 16;++i){
				d[i]=sou[i];
			}
		}

		Matrix4x4.createRotationX=function(rad,out){
			var oe=out.elements;
			var s=Math.sin(rad),c=Math.cos(rad);
			oe[1]=oe[2]=oe[3]=oe[4]=oe[7]=oe[8]=oe[11]=oe[12]=oe[13]=oe[14]=0;
			oe[0]=oe[15]=1;
			oe[5]=oe[10]=c;
			oe[6]=s;
			oe[9]=-s;
		}

		Matrix4x4.createRotationY=function(rad,out){
			var oe=out.elements;
			var s=Math.sin(rad),c=Math.cos(rad);
			oe[1]=oe[3]=oe[4]=oe[6]=oe[7]=oe[9]=oe[11]=oe[12]=oe[13]=oe[14]=0;
			oe[5]=oe[15]=1;
			oe[0]=oe[10]=c;
			oe[2]=-s;
			oe[8]=s;
		}

		Matrix4x4.createRotationZ=function(rad,out){
			var oe=out.elements;
			var s=Math.sin(rad),c=Math.cos(rad);
			oe[2]=oe[3]=oe[6]=oe[7]=oe[8]=oe[9]=oe[11]=oe[12]=oe[13]=oe[14]=0;
			oe[10]=oe[15]=1;
			oe[0]=oe[5]=c;
			oe[1]=s;
			oe[4]=-s;
		}

		Matrix4x4.createTranslate=function(trans,out){
			var te=trans.elements;
			var oe=out.elements;
			oe[4]=oe[8]=oe[1]=oe[9]=oe[2]=oe[6]=oe[3]=oe[7]=oe[11]=0;
			oe[0]=oe[5]=oe[10]=oe[15]=1;
			oe[12]=te[0];
			oe[13]=te[1];
			oe[14]=te[2];
		}

		Matrix4x4.createScaling=function(scale,out){
			var se=scale.elements;
			var oe=out.elements;
			oe[0]=se[0];
			oe[5]=se[1];
			oe[10]=se[2];
			oe[1]=oe[4]=oe[8]=oe[12]=oe[9]=oe[13]=oe[2]=oe[6]=oe[14]=oe[3]=oe[7]=oe[11]=0;
			oe[15]=1;
		}

		Matrix4x4.multiply=function(left,right,out){
			var i,e,a,b,ai0,ai1,ai2,ai3;
			e=out.elements;
			a=left.elements;
			b=right.elements;
			if (e===b){
				b=new Float32Array(16);
				for (i=0;i < 16;++i){
					b[i]=e[i];
				}
			}
			for (i=0;i < 4;i++){
				ai0=a[i];
				ai1=a[i+4];
				ai2=a[i+8];
				ai3=a[i+12];
				e[i]=ai0 *b[0]+ai1 *b[1]+ai2 *b[2]+ai3 *b[3];
				e[i+4]=ai0 *b[4]+ai1 *b[5]+ai2 *b[6]+ai3 *b[7];
				e[i+8]=ai0 *b[8]+ai1 *b[9]+ai2 *b[10]+ai3 *b[11];
				e[i+12]=ai0 *b[12]+ai1 *b[13]+ai2 *b[14]+ai3 *b[15];
			}
		}

		Matrix4x4.createFromQuaternion=function(rotation,out){
			var e=out.elements;
			var q=rotation.elements;
			var x=q[0],y=q[1],z=q[2],w=q[3];
			var x2=x+x;
			var y2=y+y;
			var z2=z+z;
			var xx=x *x2;
			var yx=y *x2;
			var yy=y *y2;
			var zx=z *x2;
			var zy=z *y2;
			var zz=z *z2;
			var wx=w *x2;
			var wy=w *y2;
			var wz=w *z2;
			e[0]=1-yy-zz;
			e[1]=yx+wz;
			e[2]=zx-wy;
			e[3]=0;
			e[4]=yx-wz;
			e[5]=1-xx-zz;
			e[6]=zy+wx;
			e[7]=0;
			e[8]=zx+wy;
			e[9]=zy-wx;
			e[10]=1-xx-yy;
			e[11]=0;
			e[12]=0;
			e[13]=0;
			e[14]=0;
			out[15]=1;
		}

		Matrix4x4.createAffineTransformation=function(trans,rot,scale,out){
			var te=trans.elements;
			var re=rot.elements;
			var se=scale.elements;
			var oe=out.elements;
			var x=re[0],y=re[1],z=re[2],w=re[3],x2=x+x,y2=y+y,z2=z+z;
			var xx=x *x2,xy=x *y2,xz=x *z2,yy=y *y2,yz=y *z2,zz=z *z2;
			var wx=w *x2,wy=w *y2,wz=w *z2,sx=se[0],sy=se[1],sz=se[2];
			oe[0]=(1-(yy+zz))*sx;
			oe[1]=(xy+wz)*sx;
			oe[2]=(xz-wy)*sx;
			oe[3]=0;
			oe[4]=(xy-wz)*sy;
			oe[5]=(1-(xx+zz))*sy;
			oe[6]=(yz+wx)*sy;
			oe[7]=0;
			oe[8]=(xz+wy)*sz;
			oe[9]=(yz-wx)*sz;
			oe[10]=(1-(xx+yy))*sz;
			oe[11]=0;
			oe[12]=te[0];
			oe[13]=te[1];
			oe[14]=te[2];
			oe[15]=1;
		}

		Matrix4x4.createLookAt=function(eye,center,up,out){
			var ee=eye.elements;
			var ce=center.elements;
			var ue=up.elements;
			var oe=out.elements;
			var x0,x1,x2,y0,y1,y2,z0,z1,z2,len,eyex=ee[0],eyey=ee[1],eyez=ee[2],upx=ue[0],upy=ue[1],upz=ue[2],centerx=ce[0],centery=ce[1],centerz=ce[2];
			if (Math.abs(eyex-centerx)< MathUtils3D.zeroTolerance && Math.abs(eyey-centery)< MathUtils3D.zeroTolerance && Math.abs(eyez-centerz)< MathUtils3D.zeroTolerance){
				out.identity();
				return;
			}
			z0=eyex-centerx;
			z1=eyey-centery;
			z2=eyez-centerz;
			len=1 / Math.sqrt(z0 *z0+z1 *z1+z2 *z2);
			z0 *=len;
			z1 *=len;
			z2 *=len;
			x0=upy *z2-upz *z1;
			x1=upz *z0-upx *z2;
			x2=upx *z1-upy *z0;
			len=Math.sqrt(x0 *x0+x1 *x1+x2 *x2);
			if (!len){
				x0=x1=x2=0;
				}else {
				len=1 / len;
				x0 *=len;
				x1 *=len;
				x2 *=len;
			}
			y0=z1 *x2-z2 *x1;
			y1=z2 *x0-z0 *x2;
			y2=z0 *x1-z1 *x0;
			len=Math.sqrt(y0 *y0+y1 *y1+y2 *y2);
			if (!len){
				y0=y1=y2=0;
				}else {
				len=1 / len;
				y0 *=len;
				y1 *=len;
				y2 *=len;
			}
			oe[0]=x0;
			oe[1]=y0;
			oe[2]=z0;
			oe[3]=0;
			oe[4]=x1;
			oe[5]=y1;
			oe[6]=z1;
			oe[7]=0;
			oe[8]=x2;
			oe[9]=y2;
			oe[10]=z2;
			oe[11]=0;
			oe[12]=-(x0 *eyex+x1 *eyey+x2 *eyez);
			oe[13]=-(y0 *eyex+y1 *eyey+y2 *eyez);
			oe[14]=-(z0 *eyex+z1 *eyey+z2 *eyez);
			oe[15]=1;
		}

		Matrix4x4.createPerspective=function(fov,aspect,near,far,out){
			var oe=out.elements;
			var f=1.0 / Math.tan(fov / 2),nf=1 / (near-far);
			oe[0]=f / aspect;
			oe[5]=f;
			oe[10]=(far+near)*nf;
			oe[11]=-1;
			oe[14]=(2 *far *near)*nf;
			oe[1]=oe[2]=oe[3]=oe[4]=oe[6]=oe[7]=oe[8]=oe[9]=oe[12]=oe[13]=oe[15]=0;
		}

		Matrix4x4.createOrthogonal=function(left,right,bottom,top,near,far,out){
			var oe=out.elements;
			var lr=1 / (left-right);
			var bt=1 / (bottom-top);
			var nf=1 / (near-far);
			oe[1]=oe[2]=oe[3]=oe[4]=oe[6]=oe[7]=oe[8]=oe[9]=oe[11]=0;
			oe[15]=1;
			oe[0]=-2 *lr;
			oe[5]=-2 *bt;
			oe[10]=2 *nf;
			oe[12]=(left+right)*lr;
			oe[13]=(top+bottom)*bt;
			oe[14]=(far+near)*nf;
		}

		Matrix4x4.TEMP=new Matrix4x4();
		Matrix4x4.DEFAULT=new Matrix4x4();
		return Matrix4x4;
	})()


	/**
	*<code>Plane</code> 类用于创建平面。
	*/
	//class laya.d3.math.Plane
	var Plane=(function(){
		function Plane(v3,d){
			this.normal=null;
			this.distance=NaN;
			this.normal=v3;
			this.distance=d;
		}

		__class(Plane,'laya.d3.math.Plane');
		Plane.createPlaneBy3P=function(point1,point2,point3){
			var point1e=point1.elements;
			var point2e=point2.elements;
			var point3e=point3.elements;
			var x1=point2e[0]-point1e[0];
			var y1=point2e[1]-point1e[1];
			var z1=point2e[2]-point1e[2];
			var x2=point3e[0]-point1e[0];
			var y2=point3e[1]-point1e[1];
			var z2=point3e[2]-point1e[2];
			var yz=(y1 *z2)-(z1 *y2);
			var xz=(z1 *x2)-(x1 *z2);
			var xy=(x1 *y2)-(y1 *x2);
			var invPyth=1 / (Math.sqrt((yz *yz)+(xz *xz)+(xy *xy)));
			var x=yz *invPyth;
			var y=xz *invPyth;
			var z=xy *invPyth;
			var TEMPVec3e=Plane._TEMPVec3.elements;
			TEMPVec3e[0]=x;
			TEMPVec3e[1]=y;
			TEMPVec3e[2]=z;
			var d=-((x *point1e[0])+(y *point1e[1])+(z *point1e[2]));
			var plane=new Plane(Plane._TEMPVec3,d);
			return plane;
		}

		Plane.PlaneIntersectionType_Back=-1;
		Plane.PlaneIntersectionType_Front=1;
		Plane.PlaneIntersectionType_Intersecting=0;
		__static(Plane,
		['_TEMPVec3',function(){return this._TEMPVec3=new Vector3();}
		]);
		return Plane;
	})()


	/**
	*<code>Quaternion</code> 类用于创建四元数。
	*/
	//class laya.d3.math.Quaternion
	var Quaternion=(function(){
		function Quaternion(x,y,z,w){
			this.elements=new Float32Array(4);
			(x===void 0)&& (x=0);
			(y===void 0)&& (y=0);
			(z===void 0)&& (z=0);
			(w===void 0)&& (w=1);
			this.elements[0]=x;
			this.elements[1]=y;
			this.elements[2]=z;
			this.elements[3]=w;
		}

		__class(Quaternion,'laya.d3.math.Quaternion');
		var __proto=Quaternion.prototype;
		/**
		*根据缩放值缩放四元数
		*@param scale 缩放值
		*@param out 输出四元数
		*/
		__proto.scaling=function(scaling,out){
			var e=out.elements;
			var f=this.elements;
			e[0]=f[0] *scaling;
			e[1]=f[1] *scaling;
			e[2]=f[2] *scaling;
			e[3]=f[3] *scaling;
		}

		/**
		*归一化四元数
		*@param out 输出四元数
		*/
		__proto.normalize=function(out){
			var e=out.elements;
			var f=this.elements;
			var x=f[0],y=f[1],z=f[2],w=f[3];
			var len=x *x+y *y+z *z+w *w;
			if (len > 0){
				len=1 / Math.sqrt(len);
				e[0]=x *len;
				e[1]=y *len;
				e[2]=z *len;
				e[3]=w *len;
			}
		}

		/**
		*计算四元数的长度
		*@return 长度
		*/
		__proto.length=function(){
			var f=this.elements;
			var x=f[0],y=f[1],z=f[2],w=f[3];
			return Math.sqrt(x *x+y *y+z *z+w *w);
		}

		/**
		*根据绕X轴的角度旋转四元数
		*@param rad 角度
		*@param out 输出四元数
		*/
		__proto.rotateX=function(rad,out){
			var e=out.elements;
			var f=this.elements;
			rad *=0.5;
			var ax=f[0],ay=f[1],az=f[2],aw=f[3];
			var bx=Math.sin(rad),bw=Math.cos(rad);
			e[0]=ax *bw+aw *bx;
			e[1]=ay *bw+az *bx;
			e[2]=az *bw-ay *bx;
			e[3]=aw *bw-ax *bx;
		}

		/**
		*根据绕Y轴的制定角度旋转四元数
		*@param rad 角度
		*@param out 输出四元数
		*/
		__proto.rotateY=function(rad,out){
			var e=out.elements;
			var f=this.elements;
			rad *=0.5;
			var ax=f[0],ay=f[1],az=f[2],aw=f[3],by=Math.sin(rad),bw=Math.cos(rad);
			e[0]=ax *bw-az *by;
			e[1]=ay *bw+aw *by;
			e[2]=az *bw+ax *by;
			e[3]=aw *bw-ay *by;
		}

		/**
		*根据绕Z轴的制定角度旋转四元数
		*@param rad 角度
		*@param out 输出四元数
		*/
		__proto.rotateZ=function(rad,out){
			var e=out.elements;
			var f=this.elements;
			rad *=0.5;
			var ax=f[0],ay=f[1],az=f[2],aw=f[3],bz=Math.sin(rad),bw=Math.cos(rad);
			e[0]=ax *bw+ay *bz;
			e[1]=ay *bw-ax *bz;
			e[2]=az *bw+aw *bz;
			e[3]=aw *bw-az *bz;
		}

		/**
		*分解四元数到欧拉角（顺序为Yaw、Pitch、Roll），参考自http://xboxforums.create.msdn.com/forums/p/4574/23988.aspx#23988,问题绕X轴翻转超过±90度时有，会产生瞬间反转
		*@param quaternion 源四元数
		*@param out 欧拉角值
		*/
		__proto.getYawPitchRoll=function(out){
			Vector3.transformQuat(Vector3.ForwardRH,this,Quaternion.TEMPVector31);
			Vector3.transformQuat(Vector3.Up,this,Quaternion.TEMPVector32);
			var upe=Quaternion.TEMPVector32.elements;
			Quaternion.angleTo(Vector3.ZERO,Quaternion.TEMPVector31,Quaternion.TEMPVector33);
			var anglee=Quaternion.TEMPVector33.elements;
			if (anglee[0]==Math.PI / 2){
				anglee[1]=Quaternion.arcTanAngle(upe[2],upe[0]);
				anglee[2]=0;
				}else if (anglee[0]==-Math.PI / 2){
				anglee[1]=Quaternion.arcTanAngle(-upe[2],-upe[0]);
				anglee[2]=0;
				}else {
				Matrix4x4.createRotationY(-anglee[1],Quaternion.TEMPMatrix0);
				Matrix4x4.createRotationX(-anglee[0],Quaternion.TEMPMatrix1);
				Vector3.transformCoordinate(Quaternion.TEMPVector32,Quaternion.TEMPMatrix0,Quaternion.TEMPVector32);
				Vector3.transformCoordinate(Quaternion.TEMPVector32,Quaternion.TEMPMatrix1,Quaternion.TEMPVector32);
				anglee[2]=Quaternion.arcTanAngle(upe[1],-upe[0]);
			}
			if (anglee[1] <=-Math.PI)
				anglee[1]=Math.PI;
			if (anglee[2] <=-Math.PI)
				anglee[2]=Math.PI;
			if (anglee[1] >=Math.PI && anglee[2] >=Math.PI){
				anglee[1]=0;
				anglee[2]=0;
				anglee[0]=Math.PI-anglee[0];
			};
			var oe=out.elements;
			oe[0]=anglee[1];
			oe[1]=anglee[0];
			oe[2]=anglee[2];
		}

		/**
		*求四元数的逆
		*@param out 输出四元数
		*/
		__proto.invert=function(out){
			var e=out.elements;
			var f=this.elements;
			var a0=f[0],a1=f[1],a2=f[2],a3=f[3];
			var dot=a0 *a0+a1 *a1+a2 *a2+a3 *a3;
			var invDot=dot ? 1.0 / dot :0;
			e[0]=-a0 *invDot;
			e[1]=-a1 *invDot;
			e[2]=-a2 *invDot;
			e[3]=a3 *invDot;
		}

		/**
		*设置四元数为单位算数
		*@param out 输出四元数
		*/
		__proto.identity=function(){
			var e=this.elements;
			e[0]=0;
			e[1]=0;
			e[2]=0;
			e[3]=1;
		}

		/**
		*克隆一个四元数
		*@param out 输出的四元数
		*/
		__proto.cloneTo=function(out){
			var i,s,d;
			s=this.elements;
			d=out.elements;
			if (s===d){
				return;
			}
			for (i=0;i < 4;++i){
				d[i]=s[i];
			}
		}

		/**
		*从一个四元数复制
		*@param sou 源四元数
		*/
		__proto.copyFrom=function(sou){
			var i,s,d;
			s=sou.elements;
			d=this.elements;
			if (s===d){
				return;
			}
			for (i=0;i < 4;++i){
				d[i]=s[i];
			}
		}

		/**
		*从一个数组复制
		*@param sou 源Float32Array数组
		*/
		__proto.copyFromArray=function(sou){
			var i,d;
			d=this.elements;
			if (sou===d){
				return;
			}
			for (i=0;i < 4;++i){
				d[i]=sou[i];
			}
		}

		/**
		*获取四元数的x值
		*/
		__getset(0,__proto,'x',function(){
			return this.elements[0];
		});

		/**
		*获取四元数的y值
		*/
		__getset(0,__proto,'y',function(){
			return this.elements[1];
		});

		/**
		*获取四元数的z值
		*/
		__getset(0,__proto,'z',function(){
			return this.elements[2];
		});

		/**
		*获取四元数的w值
		*/
		__getset(0,__proto,'w',function(){
			return this.elements[3];
		});

		Quaternion.createFromYawPitchRoll=function(yaw,pitch,roll,out){
			var halfRoll=roll *0.5;
			var halfPitch=pitch *0.5;
			var halfYaw=yaw *0.5;
			var sinRoll=Math.sin(halfRoll);
			var cosRoll=Math.cos(halfRoll);
			var sinPitch=Math.sin(halfPitch);
			var cosPitch=Math.cos(halfPitch);
			var sinYaw=Math.sin(halfYaw);
			var cosYaw=Math.cos(halfYaw);
			var oe=out.elements;
			oe[0]=(cosYaw *sinPitch *cosRoll)+(sinYaw *cosPitch *sinRoll);
			oe[1]=(sinYaw *cosPitch *cosRoll)-(cosYaw *sinPitch *sinRoll);
			oe[2]=(cosYaw *cosPitch *sinRoll)-(sinYaw *sinPitch *cosRoll);
			oe[3]=(cosYaw *cosPitch *cosRoll)+(sinYaw *sinPitch *sinRoll);
		}

		Quaternion.multiply=function(left,right,out){
			var le=left.elements;
			var re=right.elements;
			var oe=out.elements;
			var lx=le[0];
			var ly=le[1];
			var lz=le[2];
			var lw=le[3];
			var rx=re[0];
			var ry=re[1];
			var rz=re[2];
			var rw=re[3];
			var a=(ly *rz-lz *ry);
			var b=(lz *rx-lx *rz);
			var c=(lx *ry-ly *rx);
			var d=(lx *rx+ly *ry+lz *rz);
			oe[0]=(lx *rw+rx *lw)+a;
			oe[1]=(ly *rw+ry *lw)+b;
			oe[2]=(lz *rw+rz *lw)+c;
			oe[3]=lw *rw-d;
		}

		Quaternion.arcTanAngle=function(x,y){
			if (x==0){
				if (y==1)
					return Math.PI / 2;
				return-Math.PI / 2;
			}
			if (x > 0)
				return Math.atan(y / x);
			if (x < 0){
				if (y > 0)
					return Math.atan(y / x)+Math.PI;
				return Math.atan(y / x)-Math.PI;
			}
			return 0;
		}

		Quaternion.angleTo=function(from,location,angle){
			Vector3.subtract(location,from,Quaternion.TEMPVector30);
			Vector3.normalize(Quaternion.TEMPVector30,Quaternion.TEMPVector30);
			angle.elements[0]=Math.asin(Quaternion.TEMPVector30.y);
			angle.elements[1]=Quaternion.arcTanAngle(-Quaternion.TEMPVector30.z,-Quaternion.TEMPVector30.x);
		}

		Quaternion.createFromAxisAngle=function(axis,rad,out){
			var e=out.elements;
			var f=axis.elements;
			rad=rad *0.5;
			var s=Math.sin(rad);
			e[0]=s *f[0];
			e[1]=s *f[1];
			e[2]=s *f[2];
			e[3]=Math.cos(rad);
		}

		Quaternion.createFromMatrix3x3=function(sou,out){
			var e=out.elements;
			var f=sou.elements;
			var fTrace=f[0]+f[4]+f[8];
			var fRoot;
			if (fTrace > 0.0){
				fRoot=Math.sqrt(fTrace+1.0);
				e[3]=0.5 *fRoot;
				fRoot=0.5 / fRoot;
				e[0]=(f[5]-f[7])*fRoot;
				e[1]=(f[6]-f[2])*fRoot;
				e[2]=(f[1]-f[3])*fRoot;
				}else {
				var i=0;
				if (f[4] > f[0])
					i=1;
				if (f[8] > f[i *3+i])
					i=2;
				var j=(i+1)% 3;
				var k=(i+2)% 3;
				fRoot=Math.sqrt(f[i *3+i]-f[j *3+j]-f[k *3+k]+1.0);
				e[i]=0.5 *fRoot;
				fRoot=0.5 / fRoot;
				e[3]=(f[j *3+k]-f[k *3+j])*fRoot;
				e[j]=(f[j *3+i]+f[i *3+j])*fRoot;
				e[k]=(f[k *3+i]+f[i *3+k])*fRoot;
			}
			return;
		}

		Quaternion.createFromMatrix4x4=function(mat,out){
			var me=mat.elements;
			var oe=out.elements;
			var sqrt;
			var half;
			var scale=me[0]+me[5]+me[10];
			if (scale > 0.0){
				sqrt=Math.sqrt(scale+1.0);
				oe[3]=sqrt *0.5;
				sqrt=0.5 / sqrt;
				oe[0]=(me[6]-me[9])*sqrt;
				oe[1]=(me[8]-me[2])*sqrt;
				oe[2]=(me[1]-me[4])*sqrt;
				}else if ((me[0] >=me[5])&& (me[0] >=me[10])){
				sqrt=Math.sqrt(1.0+me[0]-me[5]-me[10]);
				half=0.5 / sqrt;
				oe[0]=0.5 *sqrt;
				oe[1]=(me[1]+me[4])*half;
				oe[2]=(me[2]+me[8])*half;
				oe[3]=(me[6]-me[9])*half;
				}else if (me[5] > me[10]){
				sqrt=Math.sqrt(1.0+me[5]-me[0]-me[10]);
				half=0.5 / sqrt;
				oe[0]=(me[4]+me[1])*half;
				oe[1]=0.5 *sqrt;
				oe[2]=(me[9]+me[6])*half;
				oe[3]=(me[8]-me[2])*half;
				}else {
				sqrt=Math.sqrt(1.0+me[10]-me[0]-me[5]);
				half=0.5 / sqrt;
				oe[0]=(me[8]+me[2])*half;
				oe[1]=(me[9]+me[6])*half;
				oe[2]=0.5 *sqrt;
				oe[3]=(me[1]-me[4])*half;
			}
		}

		Quaternion.slerp=function(left,right,t,out){
			var a=left.elements;
			var b=right.elements;
			var oe=out.elements;
			var ax=a[0],ay=a[1],az=a[2],aw=a[3],bx=b[0],by=b[1],bz=b[2],bw=b[3];
			var omega,cosom,sinom,scale0,scale1;
			cosom=ax *bx+ay *by+az *bz+aw *bw;
			if (cosom < 0.0){
				cosom=-cosom;
				bx=-bx;
				by=-by;
				bz=-bz;
				bw=-bw;
			}
			if ((1.0-cosom)> 0.000001){
				omega=Math.acos(cosom);
				sinom=Math.sin(omega);
				scale0=Math.sin((1.0-t)*omega)/ sinom;
				scale1=Math.sin(t *omega)/ sinom;
				}else {
				scale0=1.0-t;
				scale1=t;
			}
			oe[0]=scale0 *ax+scale1 *bx;
			oe[1]=scale0 *ay+scale1 *by;
			oe[2]=scale0 *az+scale1 *bz;
			oe[3]=scale0 *aw+scale1 *bw;
			return oe;
		}

		Quaternion.lerp=function(left,right,t,out){
			var e=out.elements;
			var f=left.elements;
			var g=right.elements;
			var ax=f[0],ay=f[1],az=f[2],aw=f[3];
			e[0]=ax+t *(g[0]-ax);
			e[1]=ay+t *(g[1]-ay);
			e[2]=az+t *(g[2]-az);
			e[3]=aw+t *(g[3]-aw);
		}

		Quaternion.add=function(left,right,out){
			var e=out.elements;
			var f=left.elements;
			var g=right.elements;
			e[0]=f[0]+g[0];
			e[1]=f[1]+g[1];
			e[2]=f[2]+g[2];
			e[3]=f[3]+g[3];
		}

		Quaternion.dot=function(left,right){
			var f=left.elements;
			var g=right.elements;
			return f[0] *g[0]+f[1] *g[1]+f[2] *g[2]+f[3] *g[3];
		}

		Quaternion.DEFAULT=new Quaternion();
		__static(Quaternion,
		['TEMPVector30',function(){return this.TEMPVector30=new Vector3();},'TEMPVector31',function(){return this.TEMPVector31=new Vector3();},'TEMPVector32',function(){return this.TEMPVector32=new Vector3();},'TEMPVector33',function(){return this.TEMPVector33=new Vector3();},'TEMPMatrix0',function(){return this.TEMPMatrix0=new Matrix4x4();},'TEMPMatrix1',function(){return this.TEMPMatrix1=new Matrix4x4();}
		]);
		return Quaternion;
	})()


	/**
	*<code>Ray</code> 类用于创建射线。
	*/
	//class laya.d3.math.Ray
	var Ray=(function(){
		function Ray(origin,direction){
			this.origin=null;
			this.direction=null;
			this.origin=origin;
			this.direction=direction;
		}

		__class(Ray,'laya.d3.math.Ray');
		return Ray;
	})()


	/**
	*<code>Vector2</code> 类用于创建二维向量。
	*/
	//class laya.d3.math.Vector2
	var Vector2=(function(){
		function Vector2(x,y){
			this.elements=new Float32Array(2);
			(x===void 0)&& (x=0);
			(y===void 0)&& (y=0);
			var v=this.elements;
			v[0]=x;
			v[1]=y;
		}

		__class(Vector2,'laya.d3.math.Vector2');
		var __proto=Vector2.prototype;
		/**
		*从一个克隆二维向量克隆。
		*@param v 源二维向量。
		*/
		__proto.clone=function(v){
			var out=this.elements,s=v.elements;
			out[0]=s[0];
			out[1]=s[1];
		}

		/**
		*获取X轴坐标。
		*@return x X轴坐标。
		*/
		__getset(0,__proto,'x',function(){
			return this.elements[0];
		});

		/**
		*获取Y轴坐标。
		*@return y Y轴坐标。
		*/
		__getset(0,__proto,'y',function(){
			return this.elements[1];
		});

		__static(Vector2,
		['ZERO',function(){return this.ZERO=new Vector2(0.0,0.0);},'ONE',function(){return this.ONE=new Vector2(1.0,1.0);}
		]);
		return Vector2;
	})()


	/**
	*<code>Vector3</code> 类用于创建三维向量。
	*/
	//class laya.d3.math.Vector3
	var Vector3=(function(){
		function Vector3(x,y,z){
			this.elements=new Float32Array(3);
			(x===void 0)&& (x=0);
			(y===void 0)&& (y=0);
			(z===void 0)&& (z=0);
			var v=this.elements;
			v[0]=x;
			v[1]=y;
			v[2]=z;
		}

		__class(Vector3,'laya.d3.math.Vector3');
		var __proto=Vector3.prototype;
		/**
		*从一个三维向量复制。
		*@param v 源向量。
		*/
		__proto.copyFrom=function(v){
			var e=this.elements,s=v.elements;
			e[0]=s[0];
			e[1]=s[1];
			e[2]=s[2];
			return this;
		}

		/**
		*克隆三维向量。
		*@return 输出三维向量。
		*/
		__proto.clone=function(){
			var out=new Vector3();
			var oe=out.elements,s=this.elements;
			oe[0]=s[0];
			oe[1]=s[1];
			oe[2]=s[2];
			return out;
		}

		/**
		*克隆三维向量。
		*@param dest 输出三维向量。
		*/
		__proto.cloneTo=function(dest){
			var oe=dest.elements,s=this.elements;
			oe[0]=s[0];
			oe[1]=s[1];
			oe[2]=s[2];
		}

		/**
		*设置X轴坐标。
		*@param x X轴坐标。
		*/
		/**
		*获取X轴坐标。
		*@return x X轴坐标。
		*/
		__getset(0,__proto,'x',function(){
			return this.elements[0];
			},function(value){
			this.elements[0]=value;
		});

		/**
		*设置Y轴坐标。
		*@param y Y轴坐标。
		*/
		/**
		*获取Y轴坐标。
		*@return y Y轴坐标。
		*/
		__getset(0,__proto,'y',function(){
			return this.elements[1];
			},function(value){
			this.elements[1]=value;
		});

		/**
		*设置Z轴坐标。
		*@param z Z轴坐标。
		*/
		/**
		*获取Z轴坐标。
		*@return z Z轴坐标。
		*/
		__getset(0,__proto,'z',function(){
			return this.elements[2];
			},function(value){
			this.elements[2]=value;
		});

		Vector3.distanceSquared=function(value1,value2){
			var value1e=value1.elements;
			var value2e=value2.elements;
			var x=value1e[0]-value2e[0];
			var y=value1e[1]-value2e[1];
			var z=value1e[2]-value2e[2];
			return (x *x)+(y *y)+(z *z);
		}

		Vector3.min=function(a,b,out){
			var e=out.elements;
			var f=a.elements;
			var g=b.elements
			e[0]=Math.min(f[0],g[0]);
			e[1]=Math.min(f[1],g[1]);
			e[2]=Math.min(f[2],g[2]);
		}

		Vector3.max=function(a,b,out){
			var e=out.elements;
			var f=a.elements;
			var g=b.elements
			e[0]=Math.max(f[0],g[0]);
			e[1]=Math.max(f[1],g[1]);
			e[2]=Math.max(f[2],g[2]);
		}

		Vector3.transformQuat=function(source,rotation,out){
			var destination=out.elements;
			var se=source.elements;
			var re=rotation.elements;
			var x=se[0],y=se[1],z=se[2],qx=re[0],qy=re[1],qz=re[2],qw=re[3],
			ix=qw *x+qy *z-qz *y,iy=qw *y+qz *x-qx *z,iz=qw *z+qx *y-qy *x,iw=-qx *x-qy *y-qz *z;
			destination[0]=ix *qw+iw *-qx+iy *-qz-iz *-qy;
			destination[1]=iy *qw+iw *-qy+iz *-qx-ix *-qz;
			destination[2]=iz *qw+iw *-qz+ix *-qy-iy *-qx;
		}

		Vector3.scalarLength=function(a){
			var f=a.elements;
			var x=f[0],y=f[1],z=f[2];
			return Math.sqrt(x *x+y *y+z *z);
		}

		Vector3.normalize=function(s,out){
			var se=s.elements;
			var oe=out.elements;
			var x=se[0],y=se[1],z=se[2];
			var len=x *x+y *y+z *z;
			if (len > 0){
				len=1 / Math.sqrt(len);
				oe[0]=se[0] *len;
				oe[1]=se[1] *len;
				oe[2]=se[2] *len;
			}
		}

		Vector3.multiply=function(a,b,out){
			var e=out.elements;
			var f=a.elements;
			var g=b.elements
			e[0]=f[0] *g[0];
			e[1]=f[1] *g[1];
			e[2]=f[2] *g[2];
		}

		Vector3.scale=function(a,b,out){
			var e=out.elements;
			var f=a.elements;
			e[0]=f[0] *b;
			e[1]=f[1] *b;
			e[2]=f[2] *b;
		}

		Vector3.lerp=function(a,b,t,out){
			var e=out.elements;
			var f=a.elements;
			var g=b.elements;
			var ax=f[0],ay=f[1],az=f[2];
			e[0]=ax+t *(g[0]-ax);
			e[1]=ay+t *(g[1]-ay);
			e[2]=az+t *(g[2]-az);
		}

		Vector3.transformV3ToV3=function(vector,transform,result){
			var intermediate=new Vector4();
			Vector3.transformV3ToV4(vector,transform,intermediate);
			var intermediateElem=intermediate.elements;
			var resultElem=result.elements;
			resultElem[0]=intermediateElem[0];
			resultElem[1]=intermediateElem[1];
			resultElem[2]=intermediateElem[2];
		}

		Vector3.transformV3ToV4=function(vector,transform,result){
			var vectorElem=vector.elements;
			var vectorX=vectorElem[0];
			var vectorY=vectorElem[1];
			var vectorZ=vectorElem[2];
			var transformElem=transform.elements;
			var resultElem=result.elements;
			resultElem[0]=(vectorX *transformElem[0])+(vectorY *transformElem[4])+(vectorZ *transformElem[8])+transformElem[12];
			resultElem[1]=(vectorX *transformElem[1])+(vectorY *transformElem[5])+(vectorZ *transformElem[9])+transformElem[13];
			resultElem[2]=(vectorX *transformElem[2])+(vectorY *transformElem[6])+(vectorZ *transformElem[10])+transformElem[14];
			resultElem[3]=(vectorX *transformElem[3])+(vectorY *transformElem[7])+(vectorZ *transformElem[11])+transformElem[15];
		}

		Vector3.transformCoordinate=function(coordinate,transform,result){
			var vectorElem=Vector3.TEMPVec4.elements;
			var coordinateElem=coordinate.elements;
			var coordinateX=coordinateElem[0];
			var coordinateY=coordinateElem[1];
			var coordinateZ=coordinateElem[2];
			var transformElem=transform.elements;
			vectorElem[0]=(coordinateX *transformElem[0])+(coordinateY *transformElem[4])+(coordinateZ *transformElem[8])+transformElem[12];
			vectorElem[1]=(coordinateX *transformElem[1])+(coordinateY *transformElem[5])+(coordinateZ *transformElem[9])+transformElem[13];
			vectorElem[2]=(coordinateX *transformElem[2])+(coordinateY *transformElem[6])+(coordinateZ *transformElem[10])+transformElem[14];
			vectorElem[3]=1.0 / ((coordinateX *transformElem[3])+(coordinateY *transformElem[7])+(coordinateZ *transformElem[11])+transformElem[15]);
			var resultElem=result.elements;
			resultElem[0]=vectorElem[0] *vectorElem[3];
			resultElem[1]=vectorElem[1] *vectorElem[3];
			resultElem[2]=vectorElem[2] *vectorElem[3];
		}

		Vector3.Clamp=function(value,min,max,out){
			var valuee=value.elements;
			var x=valuee[0];
			var y=valuee[1];
			var z=valuee[2];
			var mine=min.elements;
			var mineX=mine[0];
			var mineY=mine[1];
			var mineZ=mine[2];
			var maxe=max.elements;
			var maxeX=maxe[0];
			var maxeY=maxe[1];
			var maxeZ=maxe[2];
			var oute=out.elements;
			x=(x > maxeX)? maxeX :x;
			x=(x < mineX)? mineX :x;
			y=(y > maxeY)? maxeY :y;
			y=(y < mineY)? mineY :y;
			z=(z > maxeZ)? maxeZ :z;
			z=(z < mineZ)? mineZ :z;
			oute[0]=x;
			oute[1]=y;
			oute[2]=z;
		}

		Vector3.add=function(a,b,out){
			var e=out.elements;
			var f=a.elements;
			var g=b.elements
			e[0]=f[0]+g[0];
			e[1]=f[1]+g[1];
			e[2]=f[2]+g[2];
		}

		Vector3.subtract=function(a,b,o){
			var oe=o.elements;
			var ae=a.elements;
			var be=b.elements;
			oe[0]=ae[0]-be[0];
			oe[1]=ae[1]-be[1];
			oe[2]=ae[2]-be[2];
		}

		Vector3.cross=function(a,b,o){
			var ae=a.elements;
			var be=b.elements;
			var oe=o.elements;
			var ax=ae[0],ay=ae[1],az=ae[2],bx=be[0],by=be[1],bz=be[2];
			oe[0]=ay *bz-az *by;
			oe[1]=az *bx-ax *bz;
			oe[2]=ax *by-ay *bx;
		}

		Vector3.dot=function(a,b){
			var ae=a.elements;
			var be=b.elements;
			var r=(ae[0] *be[0])+(ae[1] *be[1])+(ae[2] *be[2]);
			return r;
		}

		__static(Vector3,
		['TEMPVec4',function(){return this.TEMPVec4=new Vector4();},'ZERO',function(){return this.ZERO=new Vector3(0.0,0.0,0.0);},'ONE',function(){return this.ONE=new Vector3(1.0,1.0,1.0);},'UnitX',function(){return this.UnitX=new Vector3(1,0,0);},'UnitY',function(){return this.UnitY=new Vector3(0,1,0);},'UnitZ',function(){return this.UnitZ=new Vector3(0,0,1);},'ForwardRH',function(){return this.ForwardRH=new Vector3(0,0,-1);},'ForwardLH',function(){return this.ForwardLH=new Vector3(0,0,1);},'Up',function(){return this.Up=new Vector3(0,1,0);}
		]);
		return Vector3;
	})()


	/**
	*<code>Vector4</code> 类用于创建四维向量。
	*/
	//class laya.d3.math.Vector4
	var Vector4=(function(){
		function Vector4(x,y,z,w){
			this.elements=new Float32Array(4);
			(x===void 0)&& (x=0);
			(y===void 0)&& (y=0);
			(z===void 0)&& (z=0);
			(w===void 0)&& (w=0);
			var v=this.elements;
			v[0]=x;
			v[1]=y;
			v[2]=z;
			v[3]=w;
		}

		__class(Vector4,'laya.d3.math.Vector4');
		var __proto=Vector4.prototype;
		/**
		*从一个四维向量复制。
		*@param v 源向量。
		*/
		__proto.copyFrom=function(v){
			var e=this.elements,s=v.elements;
			e[0]=s[0];
			e[1]=s[1];
			e[2]=s[2];
			e[3]=s[3];
			return this;
		}

		/**
		*获取X轴坐标。
		*@return x X轴坐标。
		*/
		__getset(0,__proto,'x',function(){
			return this.elements[0];
		});

		/**
		*获取Y轴坐标。
		*@return y Y轴坐标。
		*/
		__getset(0,__proto,'y',function(){
			return this.elements[1];
		});

		/**
		*获取Z轴坐标。
		*@return z Z轴坐标。
		*/
		__getset(0,__proto,'z',function(){
			return this.elements[2];
		});

		/**
		*获取W轴坐标。
		*@return w W轴坐标。
		*/
		__getset(0,__proto,'w',function(){
			return this.elements[3];
		});

		Vector4.lerp=function(a,b,t,out){
			var e=out.elements;
			var f=a.elements;
			var g=b.elements;
			var ax=f[0],ay=f[1],az=f[2],aw=f[3];
			e[0]=ax+t *(g[0]-ax);
			e[1]=ay+t *(g[1]-ay);
			e[2]=az+t *(g[2]-az);
			e[3]=aw+t *(g[3]-aw);
		}

		__static(Vector4,
		['ZERO',function(){return this.ZERO=new Vector4();}
		]);
		return Vector4;
	})()


	/**
	*<code>Viewport</code> 类用于创建视口。
	*/
	//class laya.d3.math.Viewport
	var Viewport=(function(){
		function Viewport(x,y,width,height){
			//this.x=NaN;
			//this.y=NaN;
			//this.width=NaN;
			//this.height=NaN;
			//this.minDepth=NaN;
			//this.maxDepth=NaN;
			this.minDepth=-1.0;
			this.maxDepth=1.0;
			this.x=x;
			this.y=y;
			this.width=width;
			this.height=height;
		}

		__class(Viewport,'laya.d3.math.Viewport');
		var __proto=Viewport.prototype;
		/**
		*变换一个三维向量。
		*@param source 源三维向量。
		*@param matrix 变换矩阵。
		*@param vector 输出三维向量。
		*/
		__proto.project=function(source,matrix,out){
			Vector3.transformV3ToV3(source,matrix,out);
			var sourceEleme=source.elements;
			var matrixEleme=matrix.elements;
			var outEleme=out.elements;
			var a=(((sourceEleme[0] *matrixEleme[3])+(sourceEleme[1] *matrixEleme[7]))+(sourceEleme[2] *matrixEleme[11]))+matrixEleme[15];
			if (a!==1.0){
				outEleme[0]=outEleme[0] / a;
				outEleme[1]=outEleme[1] / a;
				outEleme[2]=outEleme[2] / a;
			}
			outEleme[0]=(((outEleme[0]+1.0)*0.5)*this.width)+this.x;
			outEleme[1]=(((-outEleme[1]+1.0)*0.5)*this.height)+this.y;
			outEleme[2]=(outEleme[2] *(this.maxDepth-this.minDepth))+this.minDepth;
		}

		/**
		*反变换一个三维向量。
		*@param source 源三维向量。
		*@param matrix 变换矩阵。
		*@param vector 输出三维向量。
		*/
		__proto.unprojectFromMat=function(source,matrix,out){
			var sourceEleme=source.elements;
			var matrixEleme=matrix.elements;
			var outEleme=out.elements;
			outEleme[0]=(((sourceEleme[0]-this.x)/ (this.width))*2.0)-1.0;
			outEleme[1]=-((((sourceEleme[1]-this.y)/ (this.height))*2.0)-1.0);
			var halfDepth=(this.maxDepth-this.minDepth)/ 2;
			outEleme[2]=(sourceEleme[2]-this.minDepth-halfDepth)/ halfDepth;
			var a=(((outEleme[0] *matrixEleme[3])+(outEleme[1] *matrixEleme[7]))+(outEleme[2] *matrixEleme[11]))+matrixEleme[15];
			Vector3.transformV3ToV3(out,matrix,out);
			if (a!==1.0){
				outEleme[0]=outEleme[0] / a;
				outEleme[1]=outEleme[1] / a;
				outEleme[2]=outEleme[2] / a;
			}
		}

		/**
		*反变换一个三维向量。
		*@param source 源三维向量。
		*@param projection 透视投影矩阵。
		*@param view 视图矩阵。
		*@param world 世界矩阵,可设置为null。
		*@param out 输出向量。
		*/
		__proto.unprojectFromWVP=function(source,projection,view,world,out){
			Matrix4x4.multiply(projection,view,Viewport._tempMatrix4x4);
			(world)&& (Matrix4x4.multiply(Viewport._tempMatrix4x4,world,Viewport._tempMatrix4x4));
			Viewport._tempMatrix4x4.invert(Viewport._tempMatrix4x4);
			this.unprojectFromMat(source,Viewport._tempMatrix4x4,out);
		}

		__static(Viewport,
		['_tempMatrix4x4',function(){return this._tempMatrix4x4=new Matrix4x4();}
		]);
		return Viewport;
	})()


	/**
	*@private
	*<code>SubMesh</code> 类用于创建子网格数据模板。
	*/
	//class laya.d3.resource.models.SubMesh
	var SubMesh=(function(){
		function SubMesh(mesh){
			this._ib=null;
			this._materialIndex=-1;
			this._numberIndices=0;
			this._vb=null;
			this._mesh=null;
			this._boneIndex=null;
			this._bufferUsage={};
			this._finalBufferUsageDic=null;
			this._isVertexbaked=false;
			this._indexOfHost=0;
			this.verticesIndices=null;
			this._mesh=mesh;
		}

		__class(SubMesh,'laya.d3.resource.models.SubMesh');
		var __proto=SubMesh.prototype;
		Laya.imps(__proto,{"laya.d3.core.render.IRenderable":true,"laya.resource.IDispose":true})
		__proto.getVertexBuffer=function(index){
			(index===void 0)&& (index=0);
			if (index===0)
				return this._vb;
			else
			return null;
		}

		__proto.getIndexBuffer=function(){
			return this._ib;
		}

		/**
		*@private
		*/
		__proto._getShader=function(state,vertexBuffer,material){
			if (!material)
				return null;
			var def=0;
			var shaderAttribute=vertexBuffer.vertexDeclaration.shaderAttribute;
			(shaderAttribute.UV)&& (def |=material.shaderDef);
			(shaderAttribute.COLOR)&& (def |=/*laya.d3.shader.ShaderDefines3D.COLOR*/0x20);
			(state.scene.enableFog)&& (def |=/*laya.d3.shader.ShaderDefines3D.FOG*/0x20000);
			def > 0 && state.shaderDefs.addInt(def);
			var shader=material.getShader(state);
			return shader;
		}

		/**
		*@private
		*渲染。
		*@param state 渲染状态。
		*/
		__proto._render=function(state){
			var mesh=this._mesh,vb=this._vb,ib=this._ib;
			var material=this.getMaterial((state.owner).shadredMaterials);
			if (material.normalTexture && !vb.vertexDeclaration.shaderAttribute[ /*laya.d3.graphics.VertexElementUsage.TANGENT0*/"TANGENT0"]){
				var vertexDatas=vb.getData();
				var newVertexDatas=Utils3D.GenerateTangent(vertexDatas,vb.vertexDeclaration.vertexStride / 4,vb.vertexDeclaration.shaderAttribute[ /*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"][4] / 4,vb.vertexDeclaration.shaderAttribute[ /*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV"][4] / 4,ib.getData());
				var vertexDeclaration=Utils3D.getVertexTangentDeclaration(vb.vertexDeclaration.getVertexElements());
				var newVB=VertexBuffer3D.create(vertexDeclaration,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4);
				newVB.setData(newVertexDatas);
				vb.dispose();
				vb=this._vb=newVB;
				this._bufferUsage[ /*laya.d3.graphics.VertexElementUsage.TANGENT0*/"TANGENT0"]=newVB;
			}
			if (ib===null)return false;
			vb._bind();
			ib._bind();
			if (material){
				var shader=this._getShader(state,vb,material);
				var presz=state.shaderValue.length;
				state.shaderValue.pushArray(vb.vertexDeclaration.shaderValues);
				var meshSprite=state.owner;
				var worldMat=meshSprite.transform.getWorldMatrix(-2);
				var worldTransformModifyID=state.renderObj.tag.worldTransformModifyID;
				state.shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.MATRIX1*/"MATRIX1",worldMat.elements,worldTransformModifyID);
				Matrix4x4.multiply(state.projectionViewMatrix,worldMat,state.owner.wvpMatrix);
				state.shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.MVPMATRIX*/"MVPMATRIX",meshSprite.wvpMatrix.elements,state.camera.transform._worldTransformModifyID+worldTransformModifyID+state.camera._projectionMatrixModifyID);
				if (!material.upload(state,this._finalBufferUsageDic,shader)){
					state.shaderValue.length=presz;
					return false;
				}
				state.shaderValue.length=presz;
			}
			state.context.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,this._numberIndices,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,0);
			Stat.drawCall++;
			Stat.trianglesFaces+=this._numberIndices / 3;
			return true;
		}

		/**
		*@private
		*/
		__proto._setBoneDic=function(boneDic){
			this._boneIndex=boneDic;
			this._mesh.disableUseFullBone();
		}

		/**
		*获取材质。
		*@param 材质队列。
		*@return 材质。
		*/
		__proto.getMaterial=function(materials){
			return this._materialIndex >=0 ? materials[this._materialIndex] :null;
		}

		/**
		*设置索引缓冲。
		*@param value 索引缓冲。
		*@param elementCount 索引的个数。
		*/
		__proto.setIB=function(value,elementCount){
			this._ib=value;
			this._numberIndices=elementCount;
		}

		/**
		*获取索引缓冲。
		*@return 索引缓冲。
		*/
		__proto.getIB=function(){
			return this._ib;
		}

		/**
		*设置顶点缓冲。
		*@param vb 顶点缓冲。
		*/
		__proto.setVB=function(vb){
			this._vb=vb;
		}

		/**
		*获取顶点缓冲。
		*@return 顶点缓冲。
		*/
		__proto.getVB=function(){
			return this._vb;
		}

		__proto.getBakedVertexs=function(index,transform){
			if (index===0){
				var byteSizeInFloat=4;
				var vb=this._vb;
				var bakedVertexes=vb.getData().slice();
				var vertexDeclaration=vb.vertexDeclaration;
				var positionOffset=vertexDeclaration.shaderAttribute[ /*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"][4] / byteSizeInFloat;
				var normalOffset=vertexDeclaration.shaderAttribute[ /*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"][4] / byteSizeInFloat;
				for (var i=0;i < bakedVertexes.length;i+=vertexDeclaration.vertexStride / byteSizeInFloat){
					var posOffset=i+positionOffset;
					var norOffset=i+normalOffset;
					Utils3D.transformVector3ArrayToVector3ArrayCoordinate(bakedVertexes,posOffset,transform,bakedVertexes,posOffset);
					Utils3D.transformVector3ArrayToVector3ArrayCoordinate(bakedVertexes,normalOffset,transform,bakedVertexes,normalOffset);
				}
				this._isVertexbaked=true;
				return bakedVertexes;
			}else
			return null;
		}

		__proto.getBakedIndices=function(){
			return this._ib.getData();
		}

		/**
		*<p>彻底清理资源。</p>
		*<p><b>注意：</b>会强制解锁清理。</p>
		*/
		__proto.dispose=function(){
			this._mesh=null;
			this._boneIndex=null;
			this._ib.dispose();
			this._vb.dispose();
		}

		__getset(0,__proto,'VertexBufferCount',function(){
			return 1;
		});

		/**
		*获取在宿主中的序列。
		*@return 序列。
		*/
		__getset(0,__proto,'indexOfHost',function(){
			return this._indexOfHost;
		});

		/**
		*设置材质
		*@param value 材质ID。
		*/
		/**
		*获取材质
		*@return 材质ID。
		*/
		__getset(0,__proto,'material',function(){
			return this._materialIndex;
			},function(value){
			this._materialIndex=value;
		});

		__getset(0,__proto,'triangleCount',function(){
			return this._ib.indexCount/3;
		});

		return SubMesh;
	})()


	/**
	*@private
	*<code>GlitterTemplet</code> 类用于创建闪光数据模板。
	*/
	//class laya.d3.resource.tempelet.GlitterTemplet
	var GlitterTemplet=(function(){
		function GlitterTemplet(glitterSetting){
			this.texture=null;
			this._vertices=null;
			this._vertexBuffer=null;
			this._floatCountPerVertex=6;
			this._firstActiveElement=0;
			this._firstNewElement=0;
			this._firstFreeElement=0;
			this._firstRetiredElement=0;
			this._currentTime=NaN;
			this._drawCounter=0;
			this._posShaderValue=[3,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,24,0];
			this._uvShaderValue=[2,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,24,12];
			this._timeShaderValue=[1,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,24,20];
			this._sharderNameID=0;
			this._shader=null;
			this.numPositionMode=0;
			this.numPositionVelocityMode=0;
			this._lastTime=NaN;
			this._needPatch=false;
			this._lastAddTime=NaN;
			this.scLeft=null;
			this.scRight=null;
			this.setting=null;
			this._tempVector0=new Vector3();
			this._tempVector1=new Vector3();
			this._tempVector2=new Vector3();
			this._tempVector3=new Vector3();
			this._shaderValue=new ValusArray();
			this.posModeLastPosition0=new Vector3();
			this.posModeLastPosition1=new Vector3();
			this.posModePosition0=new Vector3();
			this.posModePosition1=new Vector3();
			this.posVelModePosition0=new Vector3();
			this.posVelModeVelocity0=new Vector3();
			this.posVelModePosition1=new Vector3();
			this.posVelModeVelocity1=new Vector3();
			this._lastAddPos0=new Vector3();
			this._lastAddPos1=new Vector3();
			this._currentTime=this._lastTime=0;
			this.setting=glitterSetting;
			this.initialize();
			this.loadShaderParams();
			this.loadContent();
			this.scLeft=new SplineCurvePositionVelocity();
			this.scRight=new SplineCurvePositionVelocity();
		}

		__class(GlitterTemplet,'laya.d3.resource.tempelet.GlitterTemplet');
		var __proto=GlitterTemplet.prototype;
		Laya.imps(__proto,{"laya.d3.core.render.IRenderable":true})
		__proto.getBakedVertexs=function(index,transform){
			return null;
		}

		__proto.getBakedIndices=function(){
			return null;
		}

		__proto.getVertexBuffer=function(index){
			(index===void 0)&& (index=0);
			if (index===0)
				return this._vertexBuffer;
			else
			return null;
		}

		__proto.getIndexBuffer=function(){
			return null;
		}

		//插值器
		__proto.initialize=function(){
			this._vertices=new Float32Array(this.setting.maxSegments *this._floatCountPerVertex *2);
		}

		__proto.loadContent=function(){
			this._vertexBuffer=VertexBuffer3D.create(VertexGlitter.vertexDeclaration,this.setting.maxSegments *2,/*laya.webgl.WebGLContext.DYNAMIC_DRAW*/0x88E8);
		}

		__proto.loadShaderParams=function(){
			this._sharderNameID=Shader.nameKey.get("GLITTER");
			if (this.setting.texturePath){
				this._shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.DIFFUSETEXTURE*/"DIFFUSETEXTURE",null,-1);
				var _this=this;
				Laya.loader.load(this.setting.texturePath,Handler.create(null,function(texture){
					(texture.bitmap).enableMerageInAtlas=false;
					(texture.bitmap).mipmap=true;
					(texture.bitmap).repeat=true;
					_this.texture=texture;
				}));
			}
		}

		__proto.update=function(elapsedTime){
			this._currentTime+=elapsedTime / 1000;
			this.retireActiveGlitters();
			this.freeRetiredGlitters();
			if (this._firstActiveElement==this._firstFreeElement)
				this._currentTime=0;
			if (this._firstRetiredElement==this._firstActiveElement)
				this._drawCounter=0;
			this.updateTextureCoordinate();
		}

		//实时更新纹理坐标
		__proto._render=function(state){
			if (this.texture && this.texture.loaded){
				this.update(state.elapsedTime);
				if (this._firstNewElement !=this._firstFreeElement){
					this.addNewGlitterSegementToVertexBuffer();
				}
				if (this._firstActiveElement !=this._firstFreeElement){
					var gl=WebGL.mainContext;
					this._vertexBuffer.bindWithIndexBuffer(null);
					this._shader=this.getShader(state);
					var presz=this._shaderValue.length;
					this._shaderValue.pushArray(state.shaderValue);
					this._shaderValue.pushArray(this._vertexBuffer.vertexDeclaration.shaderValues);
					this._shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.UNICOLOR*/"UNICOLOR",this.setting.color.elements,-1);
					this._shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.MVPMATRIX*/"MVPMATRIX",state.projectionViewMatrix.elements,-1);
					this._shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.DURATION*/"DURATION",this.setting.lifeTime,-1);
					this._shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.LUMINANCE*/"LUMINANCE",1.0,-1);
					this._shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.CURRENTTIME*/"CURRENTTIME",this._currentTime,-1);
					this._shaderValue.data[1][0]=this.texture.source;
					this._shaderValue.data[1][1]=this.texture.bitmap.id;
					this._shader.uploadArray(this._shaderValue.data,this._shaderValue.length,null);
					this._shaderValue.length=presz;
					var drawVertexCount=0;
					if (this._firstActiveElement < this._firstFreeElement){
						drawVertexCount=(this._firstFreeElement-this._firstActiveElement)*2;
						WebGL.mainContext.drawArrays(/*laya.webgl.WebGLContext.TRIANGLE_STRIP*/0x0005,this._firstActiveElement *2,drawVertexCount);
						Stat.trianglesFaces+=drawVertexCount-2;
						Stat.drawCall++;
						}else {
						drawVertexCount=(this.setting.maxSegments-this._firstActiveElement)*2;
						WebGL.mainContext.drawArrays(/*laya.webgl.WebGLContext.TRIANGLE_STRIP*/0x0005,this._firstActiveElement *2,drawVertexCount);
						Stat.trianglesFaces+=drawVertexCount-2;
						Stat.drawCall++;
						if (this._firstFreeElement > 0){
							drawVertexCount=this._firstFreeElement *2;
							WebGL.mainContext.drawArrays(/*laya.webgl.WebGLContext.TRIANGLE_STRIP*/0x0005,0,drawVertexCount);
							Stat.trianglesFaces+=drawVertexCount-2;
							Stat.drawCall++;
						}
					}
				}
				this._drawCounter++;
			}
			return true;
		}

		__proto.addVertexPositionVelocity=function(position0,velocity0,position1,velocity1){
			if (this.numPositionVelocityMode===0){
				this.numPositionVelocityMode++;
				}else {
				var d=new Vector3();
				Vector3.subtract(position0,this.posVelModePosition0,d);
				var distance0=Vector3.scalarLength(d);
				Vector3.subtract(position1,this.posVelModePosition1,d);
				var distance1=Vector3.scalarLength(d);
				var slerpCount=0;
				if (distance0 < this.setting.minSegmentDistance && distance1 < this.setting.minSegmentDistance)
					return;
				slerpCount=1+Math.floor(Math.max(distance0,distance1)/ this.setting.minInterpDistance);
				if (slerpCount===1){
					this.addGlitter(position0,position1,this._currentTime);
					}else {
					slerpCount=Math.min(slerpCount,this.setting.maxSlerpCount);
					this.scLeft.Init(this.posVelModePosition0,this.posVelModeVelocity0,position0,velocity0);
					this.scRight.Init(this.posVelModePosition1,this.posVelModeVelocity1,position1,velocity1);
					var segment=1.0 / slerpCount;
					var addSegment=segment;
					for (var i=1;i <=slerpCount;i++){
						var pos0=this._tempVector0;
						this.scLeft.Slerp(addSegment,pos0);
						var pos1=this._tempVector1;
						this.scRight.Slerp(addSegment,pos1);
						var time=this._lastTime+(this._currentTime-this._lastTime)*i / slerpCount;
						this.addGlitter(pos0,pos1,time);
						addSegment+=segment;
					}
				}
			}
			this._lastTime=this._currentTime;
			position0.cloneTo(this.posVelModePosition0);
			velocity0.cloneTo(this.posVelModeVelocity0);
			position1.cloneTo(this.posVelModePosition1);
			velocity1.cloneTo(this.posVelModeVelocity1);
		}

		__proto.addVertexPosition=function(position0,position1){
			if (this.numPositionMode < 2){
				if (this.numPositionMode===0){
					position0.cloneTo(this.posModeLastPosition0);
					position1.cloneTo(this.posModeLastPosition1);
					}else {
					position0.cloneTo(this.posModePosition0);
					position1.cloneTo(this.posModePosition1);
				}
				this.numPositionMode++;
				}else {
				var v0=this._tempVector2;
				this.CalcVelocity(position0,this.posModeLastPosition0,v0);
				var v1=this._tempVector3;
				this.CalcVelocity(position1,this.posModeLastPosition1,v1);
				this.addVertexPositionVelocity(this.posModePosition0,v0,this.posModePosition1,v1);
				this.posModePosition0.cloneTo(this.posModeLastPosition0);
				this.posModePosition1.cloneTo(this.posModeLastPosition1);
				position0.cloneTo(this.posModePosition0);
				position1.cloneTo(this.posModePosition1);
			}
		}

		__proto.addNewGlitterSegementToVertexBuffer=function(){
			var start=0;
			if (this._firstActiveElement < this._firstFreeElement){
				start=this._firstActiveElement *2 *this._floatCountPerVertex;
				this._vertexBuffer.setData(this._vertices,start,start,(this._firstFreeElement-this._firstActiveElement)*2 *this._floatCountPerVertex);
				}else {
				start=this._firstActiveElement *2 *this._floatCountPerVertex;
				this._vertexBuffer.setData(this._vertices,start,start,(this.setting.maxSegments-this._firstActiveElement)*2 *this._floatCountPerVertex);
				if (this._firstFreeElement > 0){
					this._vertexBuffer.setData(this._vertices,0,0,this._firstFreeElement *2 *this._floatCountPerVertex);
				}
			}
			this._firstNewElement=this._firstFreeElement;
		}

		__proto.updateTextureCoordinate=function(){
			if (this._firstActiveElement < this._firstFreeElement){
				this.updateTextureCoordinateData(this._firstActiveElement,(this._firstFreeElement-this._firstActiveElement)*2);
				}else {
				this.updateTextureCoordinateData(this._firstActiveElement,(this.setting.maxSegments-this._firstActiveElement)*2);
				if (this._firstFreeElement > 0)
					this.updateTextureCoordinateData(0,this._firstFreeElement *2);
			}
		}

		__proto.updateTextureCoordinateData=function(start,count){
			for (var i=0;i < count;i+=2){
				var upVertexOffset=(start *2+i+0)*this._floatCountPerVertex;
				var downVertexOffset=(start *2+i+1)*this._floatCountPerVertex;
				this._vertices[upVertexOffset+3]=this._vertices[downVertexOffset+3]=(this._vertices[upVertexOffset+5]-this._currentTime)/ this.setting.lifeTime;
			}
		}

		//更新uv.x
		__proto.retireActiveGlitters=function(){
			var particleDuration=this.setting.lifeTime;
			while (this._firstActiveElement !=this._firstNewElement){
				var index=this._firstActiveElement *this._floatCountPerVertex *2+5;
				var particleAge=this._currentTime-this._vertices[index];
				if (particleAge < particleDuration)
					break ;
				this._vertices[index]=this._drawCounter;
				this._firstActiveElement++;
				if (this._firstActiveElement >=this.setting.maxSegments)
					this._firstActiveElement=0;
			}
		}

		__proto.freeRetiredGlitters=function(){
			while (this._firstRetiredElement !=this._firstActiveElement){
				var age=this._drawCounter-this._vertices[this._firstRetiredElement *this._floatCountPerVertex *2+5];
				if (age < 3)
					break ;
				this._firstRetiredElement++;
				if (this._firstRetiredElement >=this.setting.maxSegments)
					this._firstRetiredElement=0;
			}
		}

		__proto.addGlitter=function(position0,position1,time){
			if (this._needPatch){
				this._needPatch=false;
				this.addGlitter(this._lastAddPos0,this._lastAddPos1,this._lastAddTime);
			};
			var nextFreeParticle=this._firstFreeElement+1;
			if (nextFreeParticle >=this.setting.maxSegments){
				nextFreeParticle=0;
				position0.cloneTo(this._lastAddPos0);
				position1.cloneTo(this._lastAddPos1);
				this._lastAddTime=time;
				this._needPatch=true;
			}
			if (nextFreeParticle===this._firstRetiredElement)
				return;
			var position0e=position0.elements;
			var position1e=position1.elements;
			var j=0;
			var positionIndex=this._firstFreeElement *this._floatCountPerVertex *2;
			for (j=0;j < 3;j++)
			this._vertices[positionIndex+j]=position0e[j];
			this._vertices[positionIndex+3]=0.0;
			this._vertices[positionIndex+4]=0.0;
			this._vertices[positionIndex+5]=time;
			var nextPositionIndex=positionIndex+this._floatCountPerVertex;
			for (j=0;j < 3;j++)
			this._vertices[nextPositionIndex+j]=position1e[j];
			this._vertices[nextPositionIndex+3]=0.0;
			this._vertices[nextPositionIndex+4]=1.0;
			this._vertices[nextPositionIndex+5]=time;
			this._firstFreeElement=nextFreeParticle;
		}

		__proto.CalcVelocity=function(left,right,out){
			Vector3.subtract(left,right,out);
			Vector3.scale(out,0.5,out);
		}

		__proto.getShader=function(state){
			var shaderDefs=state.shaderDefs;
			var preDef=shaderDefs._value;
			var nameID=(shaderDefs._value | state.shadingMode)+this._sharderNameID */*laya.webgl.shader.Shader.SHADERNAME2ID*/0.0002;
			this._shader=Shader.withCompile(this._sharderNameID,state.shadingMode,state.shaderDefs.toNameDic(),nameID,null);
			shaderDefs._value=preDef;
			return this._shader;
		}

		__getset(0,__proto,'VertexBufferCount',function(){
			return 1;
		});

		__getset(0,__proto,'indexOfHost',function(){
			return 0;
		});

		__getset(0,__proto,'triangleCount',function(){
			var drawVertexCount=0;
			if (this._firstActiveElement < this._firstFreeElement){
				drawVertexCount=(this._firstFreeElement-this._firstActiveElement)*2-2;
				}else {
				drawVertexCount=(this.setting.maxSegments-this._firstActiveElement)*2-2;
				drawVertexCount+=this._firstFreeElement *2-2;
			}
			return drawVertexCount;
		});

		return GlitterTemplet;
	})()


	/**
	*@private
	*<code>Shader3D</code> 类用于创建3Dshader相关。
	*/
	//class laya.d3.shader.Shader3D
	var Shader3D=(function(){
		function Shader3D(){};
		__class(Shader3D,'laya.d3.shader.Shader3D');
		Shader3D.__init__=function(){
			Shader3D.SIMPLE=Shader.nameKey.add("SIMPLE");
			Shader3D.TERRAIN=Shader.nameKey.add("TERRAIN");
			Shader3D.PARTICLE=Shader.nameKey.add("PARTICLE");
			Shader3D.U3DPARTICLE=Shader.nameKey.add("U3DPARTICLE");
			Shader3D.GLITTER=Shader.nameKey.add("GLITTER");
			Shader3D.SIMPLE_EFFECT=Shader.nameKey.add("SIMPLE_EFFECT");
			Shader.addInclude("LightHelper.glsl","\nstruct DirectionLight\n{\n vec3 Direction;\n vec3 Diffuse;\n vec3 Ambient;\n vec3 Specular;\n};\n\nstruct PointLight\n{\n vec3 Diffuse;\n vec3 Ambient;\n vec3 Specular;\n vec3 Attenuation;\n vec3 Position;\n float Range;\n};\n\nstruct SpotLight\n{\n vec3 Diffuse;\n vec3 Ambient;\n vec3 Specular;\n vec3 Attenuation;\n vec3 Position;\n vec3 Direction;\n float Spot;\n float Range;\n};\n\n\nvoid  computeDirectionLight(in vec3 matDif,in vec3 matAmb,in vec4 matSpe,in DirectionLight dirLight,in vec3 normal,in vec3 toEye,out vec3 dif,out vec3 amb,out vec3 spec)\n{\n	dif=vec3(0.0);//不初始化在IOS中闪烁，PC中不会闪烁\n	amb=vec3(0.0);\n	spec=vec3(0.0);\n	vec3 lightVec=-normalize(dirLight.Direction);\n	\n	amb=matAmb*dirLight.Ambient;\n	\n	float  diffuseFactor=dot(lightVec, normal);\n	\n	if(diffuseFactor>0.0)\n	{\n	   vec3 v = reflect(-lightVec, normal);\n	   float specFactor = pow(max(dot(v, toEye), 0.0), matSpe.w);\n	   \n	   dif = diffuseFactor * matDif * dirLight.Diffuse;\n	   spec = specFactor * matSpe.rgb * dirLight.Specular;\n	}\n	\n}\n\nvoid computePointLight(in vec3 matDif,in vec3 matAmb,in vec4 matSpe,in PointLight poiLight, in vec3 pos,in vec3 normal,in vec3 toEye,out vec3 dif,out vec3 amb,out vec3 spec)\n{\n	dif=vec3(0.0);\n	amb=vec3(0.0);\n	spec=vec3(0.0);\n	vec3 lightVec = poiLight.Position - pos;\n		\n	float d = length(lightVec);\n	\n	if( d > poiLight.Range )\n		return;\n		\n	lightVec /= d; \n	\n	amb = matAmb * poiLight.Ambient;	\n\n	float diffuseFactor = dot(lightVec, normal);\n\n	if( diffuseFactor > 0.0 )\n	{\n		vec3 v= reflect(-lightVec, normal);\n		float specFactor = pow(max(dot(v, toEye), 0.0), matSpe.w);\n					\n		dif = diffuseFactor * matDif * poiLight.Diffuse;\n		spec = specFactor * matSpe.rgb * poiLight.Specular;\n	}\n\n	float attenuate = 1.0 / dot(poiLight.Attenuation, vec3(1.0, d, d*d));\n\n	dif *= attenuate;\n	spec*= attenuate;\n}\n\nvoid ComputeSpotLight(in vec3 matDif,in vec3 matAmb,in vec4 matSpe,in SpotLight spoLight,in vec3 pos, in vec3 normal,in vec3 toEye,out vec3 dif,out vec3 amb,out vec3 spec)\n{\n	amb = vec3(0.0);\n	dif =vec3(0.0);\n	spec= vec3(0.0);\n	vec3 lightVec = spoLight.Position - pos;\n		\n	float d = length(lightVec);\n	\n	if( d > spoLight.Range)\n		return;\n		\n	lightVec /= d; \n	\n	amb = matAmb * spoLight.Ambient;	\n\n	float diffuseFactor = dot(lightVec, normal);\n\n	if(diffuseFactor > 0.0)\n	{\n		vec3 v= reflect(-lightVec, normal);\n		float specFactor = pow(max(dot(v, toEye), 0.0), matSpe.w);\n					\n		dif = diffuseFactor * matDif * spoLight.Diffuse;\n		spec = specFactor * matSpe.rgb * spoLight.Specular;\n	}\n	\n	float spot = pow(max(dot(-lightVec, normalize(spoLight.Direction)), 0.0), spoLight.Spot);\n\n	float attenuate = spot/dot(spoLight.Attenuation, vec3(1.0, d, d*d));\n\n	amb *= spot;\n	dif *= attenuate;\n	spec*= attenuate;\n}\n\nvec3 NormalSampleToWorldSpace(vec3 normalMapSample, vec3 unitNormal, vec3 tangent)\n{\n	vec3 normalT = 2.0*normalMapSample - 1.0;\n\n	// Build orthonormal basis.\n	vec3 N = normalize(unitNormal);\n	vec3 T = normalize( tangent- dot(tangent, N)*N);\n	vec3 B = cross(T, N);\n\n	mat3 TBN = mat3(T, B, N);\n\n	// Transform from tangent space to world space.\n	vec3 bumpedNormal = TBN*normalT;\n\n	return bumpedNormal;\n}\n"/*__INCLUDESTR__e:/trank/libs/layaair/publish/layaairpublish/src/d3/src/laya/d3/shader/files/lighthelper.glsl*/);
			Shader.addInclude("VRHelper.glsl","\nvec4 DistortFishEye(vec4 p)\n{\n    vec2 v = p.xy / p.w;\n    float radius = length(v);// Convert to polar coords\n    if (radius > 0.0)\n    {\n      float theta = atan(v.y,v.x);\n      \n      radius = pow(radius, 0.93);// Distort:\n\n      v.x = radius * cos(theta);// Convert back to Cartesian\n      v.y = radius * sin(theta);\n      p.xy = v.xy * p.w;\n    }\n    return p;\n}"/*__INCLUDESTR__e:/trank/libs/layaair/publish/layaairpublish/src/d3/src/laya/d3/shader/files/vrhelper.glsl*/);
			var vs,ps;
			var shaderNameMap={
				'a_Position':/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION",
				'a_Color':/*laya.d3.graphics.VertexElementUsage.COLOR0*/"COLOR",
				'a_Normal':/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL",
				'a_Texcoord0':/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV",
				'a_Texcoord1':/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE1*/"UV1",
				'a_TexcoordNext0':/*laya.d3.graphics.VertexElementUsage.NEXTTEXTURECOORDINATE0*/"NEXTUV",
				'a_BoneWeights':/*laya.d3.graphics.VertexElementUsage.BLENDWEIGHT0*/"BLENDWEIGHT",
				'a_BoneIndices':/*laya.d3.graphics.VertexElementUsage.BLENDINDICES0*/"BLENDINDICES",
				'a_Tangent0':/*laya.d3.graphics.VertexElementUsage.TANGENT0*/"TANGENT0",
				'u_WorldMat':/*laya.webgl.utils.Buffer2D.MATRIX1*/"MATRIX1",
				'u_CameraPos':/*laya.webgl.utils.Buffer2D.CAMERAPOS*/"CAMERAPOS",
				'u_DiffuseTexture':/*laya.webgl.utils.Buffer2D.DIFFUSETEXTURE*/"DIFFUSETEXTURE",
				'u_SpecularTexture':/*laya.webgl.utils.Buffer2D.SPECULARTEXTURE*/"SPECULARTEXTURE",
				'u_NormalTexture':/*laya.webgl.utils.Buffer2D.NORMALTEXTURE*/"NORMALTEXTURE",
				'u_AmbientTexture':/*laya.webgl.utils.Buffer2D.AMBIENTTEXTURE*/"AMBIENTTEXTURE",
				'u_ReflectTexture':/*laya.webgl.utils.Buffer2D.REFLECTTEXTURE*/"REFLECTTEXTURE",
				'u_MvpMatrix':/*laya.webgl.utils.Buffer2D.MVPMATRIX*/"MVPMATRIX",
				'u_Bones':/*laya.webgl.utils.Buffer2D.MATRIXARRAY0*/"MATRIXARRAY0",
				'u_FogStart':/*laya.webgl.utils.Buffer2D.FOGSTART*/"FOGSTART",
				'u_FogRange':/*laya.webgl.utils.Buffer2D.FOGRANGE*/"FOGRANGE",
				'u_FogColor':/*laya.webgl.utils.Buffer2D.FOGCOLOR*/"FOGCOLOR",
				'u_Luminance':/*laya.webgl.utils.Buffer2D.LUMINANCE*/"LUMINANCE",
				'u_AlphaTestValue':/*laya.webgl.utils.Buffer2D.ALPHATESTVALUE*/"ALPHATESTVALUE",
				'u_UVMatrix':/*laya.webgl.utils.Buffer2D.MATRIX2*/"MATRIX2",
				'u_UVAge':/*laya.webgl.utils.Buffer2D.FLOAT0*/"FLOAT0",
				'u_UVAniAge':/*laya.webgl.utils.Buffer2D.UVAGEX*/"UVAGEX",
				'u_DirectionLight.Direction':/*laya.webgl.utils.Buffer2D.LIGHTDIRECTION*/"LIGHTDIRECTION",
				'u_DirectionLight.Diffuse':/*laya.webgl.utils.Buffer2D.LIGHTDIRDIFFUSE*/"LIGHTDIRDIFFUSE",
				'u_DirectionLight.Ambient':/*laya.webgl.utils.Buffer2D.LIGHTDIRAMBIENT*/"LIGHTDIRAMBIENT",
				'u_DirectionLight.Specular':/*laya.webgl.utils.Buffer2D.LIGHTDIRSPECULAR*/"LIGHTDIRSPECULAR",
				'u_PointLight.Position':/*laya.webgl.utils.Buffer2D.POINTLIGHTPOS*/"POINTLIGHTPOS",
				'u_PointLight.Range':/*laya.webgl.utils.Buffer2D.POINTLIGHTRANGE*/"POINTLIGHTRANGE",
				'u_PointLight.Attenuation':/*laya.webgl.utils.Buffer2D.POINTLIGHTATTENUATION*/"POINTLIGHTATTENUATION",
				'u_PointLight.Diffuse':/*laya.webgl.utils.Buffer2D.POINTLIGHTDIFFUSE*/"POINTLIGHTDIFFUSE",
				'u_PointLight.Ambient':/*laya.webgl.utils.Buffer2D.POINTLIGHTAMBIENT*/"POINTLIGHTAMBIENT",
				'u_PointLight.Specular':/*laya.webgl.utils.Buffer2D.POINTLIGHTSPECULAR*/"POINTLIGHTSPECULAR",
				'u_MaterialDiffuse':/*laya.webgl.utils.Buffer2D.MATERIALDIFFUSE*/"MATERIALDIFFUSE",
				'u_MaterialAmbient':/*laya.webgl.utils.Buffer2D.MATERIALAMBIENT*/"MATERIALAMBIENT",
				'u_MaterialSpecular':/*laya.webgl.utils.Buffer2D.MATERIALSPECULAR*/"MATERIALSPECULAR",
				'u_MaterialReflect':/*laya.webgl.utils.Buffer2D.MATERIALREFLECT*/"MATERIALREFLECT",
				'u_SpotLight.Position':/*laya.webgl.utils.Buffer2D.SPOTLIGHTPOS*/"SPOTLIGHTPOS",
				'u_SpotLight.Direction':/*laya.webgl.utils.Buffer2D.SPOTLIGHTDIRECTION*/"SPOTLIGHTDIRECTION",
				'u_SpotLight.Range':/*laya.webgl.utils.Buffer2D.SPOTLIGHTRANGE*/"SPOTLIGHTRANGE",
				'u_SpotLight.Spot':/*laya.webgl.utils.Buffer2D.SPOTLIGHTSPOT*/"SPOTLIGHTSPOT",
				'u_SpotLight.Attenuation':/*laya.webgl.utils.Buffer2D.SPOTLIGHTATTENUATION*/"SPOTLIGHTATTENUATION",
				'u_SpotLight.Diffuse':/*laya.webgl.utils.Buffer2D.SPOTLIGHTDIFFUSE*/"SPOTLIGHTDIFFUSE",
				'u_SpotLight.Ambient':/*laya.webgl.utils.Buffer2D.SPOTLIGHTAMBIENT*/"SPOTLIGHTAMBIENT",
				'u_SpotLight.Specular':/*laya.webgl.utils.Buffer2D.SPOTLIGHTSPECULAR*/"SPOTLIGHTSPECULAR"
			};
			vs="#include?DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT \"LightHelper.glsl\";\n\nattribute vec4 a_Position;\nuniform mat4 u_MvpMatrix;\n\n#include?VR \"VRHelper.glsl\";\n\n\n\n#ifdef DIFFUSEMAP||((DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&COLOR&&SPECULARMAP)\nattribute vec2 a_Texcoord0;\nvarying vec2 v_Texcoord0;\n  #ifdef MIXUV\n  attribute vec2 a_TexcoordNext0;\n  uniform float  u_UVAge;\n  #endif\n  #ifdef UVTRANSFORM\n  uniform mat4 u_UVMatrix;\n  #endif\n#endif\n\n#ifdef AMBIENTMAP\nattribute vec2 a_Texcoord1;\nvarying vec2 v_Texcoord1;\n#endif\n\n\n#ifdef COLOR\nattribute vec4 a_Color;\nvarying vec4 v_Color;\n#endif\n\n#ifdef BONE\nattribute vec4 a_BoneIndices;\nattribute vec4 a_BoneWeights;\nconst int c_MaxBoneCount = 24;\nuniform mat4 u_Bones[c_MaxBoneCount];\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP\nattribute vec3 a_Normal;\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP\nuniform mat4 u_WorldMat;\nuniform vec3 u_CameraPos;\n#endif\n\n#ifdef DIRECTIONLIGHT\nuniform DirectionLight u_DirectionLight;\n#endif\n\n#ifdef POINTLIGHT\nuniform PointLight u_PointLight;\n#endif\n\n#ifdef SPOTLIGHT\nuniform SpotLight u_SpotLight;\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT\nuniform vec3 u_MaterialDiffuse;\nuniform vec4 u_MaterialSpecular;\n\nvarying vec3 v_Diffuse;\nvarying vec3 v_Ambient;\nvarying vec3 v_Specular;\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||AMBIENTMAP\nuniform vec3 u_MaterialAmbient;\n#endif\n\n#ifdef FOG\nvarying float v_ToEyeLength;\n#endif\n\n#ifdef REFLECTMAP\nvarying vec3 v_ToEye;\nvarying vec3 v_Normal;\n#endif\n\n\nvoid main()\n{\n #ifdef BONE\n mat4 skinTransform=mat4(0.0);\n skinTransform += u_Bones[int(a_BoneIndices.x)] * a_BoneWeights.x;\n skinTransform += u_Bones[int(a_BoneIndices.y)] * a_BoneWeights.y;\n skinTransform += u_Bones[int(a_BoneIndices.z)] * a_BoneWeights.z;\n skinTransform += u_Bones[int(a_BoneIndices.w)] * a_BoneWeights.w;\n vec4 position=skinTransform*a_Position;\n   #ifdef VR\n   gl_Position = DistortFishEye(u_MvpMatrix * position);\n   #else\n   gl_Position = u_MvpMatrix * position;\n   #endif\n #else\n   #ifdef VR\n   gl_Position = DistortFishEye(u_MvpMatrix * a_Position);\n   #else\n   gl_Position = u_MvpMatrix * a_Position;\n   #endif\n #endif\n \n \n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP\n  #ifdef BONE\n  vec3 normal=normalize( mat3(u_WorldMat*skinTransform)*a_Normal);\n  #else\n  vec3 normal=normalize( mat3(u_WorldMat)*a_Normal);\n  #endif\n \n  #ifdef REFLECTMAP\n  v_Normal=normal;\n  #endif\n#endif\n \n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT\n  v_Diffuse=vec3(0.0);\n  v_Ambient=vec3(0.0);\n  v_Specular=vec3(0.0);\n  vec3 dif, amb, spe;\n#endif\n\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP\n  #ifdef BONE\n  vec3 positionWorld=(u_WorldMat*position).xyz;\n  #else\n  vec3 positionWorld=(u_WorldMat*a_Position).xyz;\n  #endif\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP\nvec3 toEye;\n  #ifdef FOG\n  toEye=u_CameraPos-positionWorld;\n  v_ToEyeLength=length(toEye);\n  toEye/=v_ToEyeLength;\n  #else\n  toEye=normalize(u_CameraPos-positionWorld);\n  #endif\n \n  #ifdef REFLECTMAP\n  v_ToEye=toEye;\n  #endif\n#endif\n \n#ifdef DIRECTIONLIGHT\ncomputeDirectionLight(u_MaterialDiffuse,u_MaterialAmbient,u_MaterialSpecular,u_DirectionLight,normal,toEye, dif, amb, spe);\nv_Diffuse+=dif;\nv_Ambient+=amb;\nv_Specular+=spe;\n#endif\n \n#ifdef POINTLIGHT\ncomputePointLight(u_MaterialDiffuse,u_MaterialAmbient,u_MaterialSpecular,u_PointLight,positionWorld,normal,toEye, dif, amb, spe);\nv_Diffuse+=dif;\nv_Ambient+=amb;\nv_Specular+=spe;\n#endif\n\n#ifdef SPOTLIGHT\nComputeSpotLight(u_MaterialDiffuse,u_MaterialAmbient,u_MaterialSpecular,u_SpotLight,positionWorld,normal,toEye, dif, amb, spe);\nv_Diffuse+=dif;\nv_Ambient+=amb;\nv_Specular+=spe;\n#endif\n  \n#ifdef DIFFUSEMAP||((DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&COLOR&&SPECULARMAP)\n  #ifdef MIXUV\n  v_Texcoord0=mix(a_Texcoord0,a_TexcoordNext0,u_UVAge);\n  #else\n  v_Texcoord0=a_Texcoord0;\n  #endif\n  #ifdef UVTRANSFORM\n  v_Texcoord0=(u_UVMatrix*vec4(v_Texcoord0,0.0,1.0)).xy;\n  #endif\n#endif\n\n#ifdef AMBIENTMAP\nv_Texcoord1=a_Texcoord1;\n#endif\n  \n#ifdef COLOR\nv_Color=a_Color;\n#endif\n}"/*__INCLUDESTR__e:/trank/libs/layaair/publish/layaairpublish/src/d3/src/laya/d3/shader/files/vertexsimpletextureskinnedmesh.vs*/;
			ps="#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\nuniform float u_Luminance;\n\n#ifdef ALPHATEST\nuniform float u_AlphaTestValue;\n#endif\n\n#ifdef DIFFUSEMAP\nuniform sampler2D u_DiffuseTexture;\n#endif\n\n#ifdef REFLECTMAP\nuniform samplerCube u_ReflectTexture;\nuniform vec3 u_MaterialReflect;\n#endif\n\n\n#ifdef DIFFUSEMAP||((DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&COLOR&&SPECULARMAP)\nvarying vec2 v_Texcoord0;\n#endif\n\n#ifdef AMBIENTMAP\nvarying vec2 v_Texcoord1;\nuniform sampler2D u_AmbientTexture;\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||AMBIENTMAP\nuniform vec3 u_MaterialAmbient;\n#endif\n\n#ifdef COLOR\nvarying vec4 v_Color;\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT\nvarying vec3 v_Diffuse;\nvarying vec3 v_Ambient;\nvarying vec3 v_Specular;\n  #ifdef (DIFFUSEMAP||COLOR)&&SPECULARMAP\n  uniform sampler2D u_SpecularTexture;\n  #endif\n#endif\n\n#ifdef FOG\nuniform float u_FogStart;\nuniform float u_FogRange;\nuniform vec3 u_FogColor;\nvarying float v_ToEyeLength;\n#endif\n\n#ifdef MIXUV\nuniform float  u_UVAniAge;\n#endif\n\n#ifdef REFLECTMAP\nvarying vec3 v_Normal;\nvarying vec3 v_ToEye;\n#endif\n\n\nvoid main()\n{\n #ifdef DIFFUSEMAP&&!COLOR\n gl_FragColor=texture2D(u_DiffuseTexture, v_Texcoord0);\n #endif \n \n #ifdef COLOR&&!DIFFUSEMAP\n gl_FragColor=v_Color;\n #endif \n \n #ifdef DIFFUSEMAP&&COLOR\n vec4 texColor=texture2D(u_DiffuseTexture, v_Texcoord0);\n gl_FragColor=texColor*v_Color;\n #endif\n \n #ifdef !DIFFUSEMAP&&!COLOR\n gl_FragColor=vec4(1.0,1.0,1.0,1.0);\n #endif \n \n #ifdef AMBIENTMAP\n gl_FragColor.rgb=gl_FragColor.rgb*(u_MaterialAmbient+texture2D(u_AmbientTexture, v_Texcoord1).rgb);\n #endif \n \n gl_FragColor.rgb=gl_FragColor.rgb*u_Luminance;\n  \n #ifdef ALPHATEST\n   if(gl_FragColor.a-u_AlphaTestValue<0.0)\n    discard;\n #endif\n \n \n #ifdef REFLECTMAP\n vec3 normal=normalize(v_Normal);\n #endif 	\n\n  \n #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT\n   #ifdef (DIFFUSEMAP||COLOR)&&SPECULARMAP\n   vec3 specular =v_Specular*texture2D(u_SpecularTexture,v_Texcoord0).rgb;\n   gl_FragColor =vec4( gl_FragColor.rgb*(v_Ambient + v_Diffuse)+specular,gl_FragColor.a);\n   #else\n   gl_FragColor =vec4( gl_FragColor.rgb*(v_Ambient + v_Diffuse)+v_Specular,gl_FragColor.a);\n   #endif\n #endif\n \n #ifdef REFLECTMAP\n vec3 incident = -v_ToEye;\n vec3 reflectionVector = reflect(incident,v_Normal);\n vec3 reflectionColor  = textureCube(u_ReflectTexture,reflectionVector).rgb;\n gl_FragColor.rgb += u_MaterialReflect*reflectionColor;\n #endif\n \n #ifdef FOG\n float lerpFact=clamp((v_ToEyeLength-u_FogStart)/u_FogRange,0.0,1.0);\n gl_FragColor.rgb=mix(gl_FragColor.rgb,u_FogColor,lerpFact);\n #endif\n}\n\n"/*__INCLUDESTR__e:/trank/libs/layaair/publish/layaairpublish/src/d3/src/laya/d3/shader/files/vertexsimpletextureskinnedmesh.ps*/;
			Shader.preCompile(Shader3D.SIMPLE,/*laya.d3.shader.ShaderDefines3D.VERTEXSHADERING*/0x1000 ,vs,ps,shaderNameMap);
			vs="#include?VR \"VRHelper.glsl\";\nattribute vec4 a_Position;\nuniform mat4 u_MvpMatrix;\n\n\n\n#ifdef DIFFUSEMAP||((DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&(COLOR&&SPECULARMAP||NORMALMAP))\nattribute vec2 a_Texcoord0;\nvarying vec2 v_Texcoord0;\n  #ifdef MIXUV\n  attribute vec2 a_TexcoordNext0;\n  uniform float  u_UVAge;\n  #endif\n  #ifdef UVTRANSFORM \n  uniform mat4 u_UVMatrix;\n  #endif\n#endif\n\n#ifdef AMBIENTMAP\nattribute vec2 a_Texcoord1;\nvarying vec2 v_Texcoord1;\n#endif\n\n#ifdef COLOR\nattribute vec4 a_Color;\nvarying vec4 v_Color;\n#endif\n\n#ifdef BONE\nattribute vec4 a_BoneIndices;\nattribute vec4 a_BoneWeights;\nconst int c_MaxBoneCount = 24;\nuniform mat4 u_Bones[c_MaxBoneCount];\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP\nattribute vec3 a_Normal;\nvarying vec3 v_Normal;\n#endif\n\n#ifdef (DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP)&&NORMALMAP\nattribute vec3 a_Tangent0;\nvarying vec3 v_Tangent0;\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP\nuniform mat4 u_WorldMat;\nvarying vec3 v_PositionWorld;\n#endif\n\n\nvoid main()\n{\n #ifdef BONE\n mat4 skinTransform=mat4(0.0);\n skinTransform += u_Bones[int(a_BoneIndices.x)] * a_BoneWeights.x;\n skinTransform += u_Bones[int(a_BoneIndices.y)] * a_BoneWeights.y;\n skinTransform += u_Bones[int(a_BoneIndices.z)] * a_BoneWeights.z;\n skinTransform += u_Bones[int(a_BoneIndices.w)] * a_BoneWeights.w;\n vec4 position=skinTransform*a_Position;\n   #ifdef VR\n   gl_Position = DistortFishEye(u_MvpMatrix * position);\n   #else\n   gl_Position = u_MvpMatrix * position;\n   #endif\n #else\n   #ifdef VR\n   gl_Position = DistortFishEye(u_MvpMatrix * a_Position);\n   #else\n   gl_Position = u_MvpMatrix * a_Position;\n   #endif\n #endif\n \n\n #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP\n mat3 worldMat;\n   #ifdef BONE\n   worldMat=mat3(u_WorldMat*skinTransform);\n   #else\n   worldMat=mat3(u_WorldMat);\n   #endif  \n v_Normal=worldMat*a_Normal;\n   #ifdef (DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&NORMALMAP\n   v_Tangent0=worldMat*a_Tangent0;\n   #endif\n #endif\n \n #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG\n   #ifdef BONE\n   v_PositionWorld=(u_WorldMat*position).xyz;\n   #else\n   v_PositionWorld=(u_WorldMat*a_Position).xyz;\n   #endif\n #endif\n \n#ifdef DIFFUSEMAP||((DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&(COLOR&&SPECULARMAP||NORMALMAP))\n  #ifdef MIXUV\n  v_Texcoord0=mix(a_Texcoord0,a_TexcoordNext0,u_UVAge);\n  #else\n  v_Texcoord0=a_Texcoord0;\n  #endif\n  #ifdef UVTRANSFORM\n  v_Texcoord0=(u_UVMatrix*vec4(v_Texcoord0,0.0,1.0)).xy;\n  #endif\n#endif\n\n#ifdef AMBIENTMAP\nv_Texcoord1=a_Texcoord1;\n#endif\n\n  \n#ifdef COLOR\nv_Color=a_Color;\n#endif\n}"/*__INCLUDESTR__e:/trank/libs/layaair/publish/layaairpublish/src/d3/src/laya/d3/shader/files/pixelsimpletextureskinnedmesh.vs*/;
			ps="#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\n#include?DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT \"LightHelper.glsl\";\n\nuniform float u_Luminance;\n\n#ifdef ALPHATEST\nuniform float u_AlphaTestValue;\n#endif\n\n#ifdef DIFFUSEMAP\nuniform sampler2D u_DiffuseTexture;\n#endif\n\n#ifdef REFLECTMAP\nuniform samplerCube u_ReflectTexture;\nuniform vec3 u_MaterialReflect;\n#endif\n\n#ifdef DIFFUSEMAP||((DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&(COLOR&&SPECULARMAP||NORMALMAP))\nvarying vec2 v_Texcoord0;\n#endif\n\n#ifdef AMBIENTMAP\nvarying vec2 v_Texcoord1;\nuniform sampler2D u_AmbientTexture;\n#endif\n\n#ifdef COLOR\nvarying vec4 v_Color;\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT\nuniform vec3 u_MaterialDiffuse;\nuniform vec4 u_MaterialSpecular;\n  #ifdef (DIFFUSEMAP||COLOR)&&SPECULARMAP \n  uniform sampler2D u_SpecularTexture;\n  #endif\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||AMBIENTMAP\nuniform vec3 u_MaterialAmbient;\n#endif\n\n#ifdef FOG\nuniform float u_FogStart;\nuniform float u_FogRange;\nuniform vec3 u_FogColor;\n#endif\n\n#ifdef MIXUV\nuniform float  u_UVAniAge;\n#endif\n\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP\nvarying vec3 v_Normal;\n#endif\n\n#ifdef (DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&NORMALMAP\nuniform sampler2D u_NormalTexture;\nvarying vec3 v_Tangent0;\n#endif\n\n#ifdef DIRECTIONLIGHT\nuniform DirectionLight u_DirectionLight;\n#endif\n\n#ifdef POINTLIGHT\nuniform PointLight u_PointLight;\n#endif\n\n#ifdef SPOTLIGHT\nuniform SpotLight u_SpotLight;\n#endif\n\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP\nuniform vec3 u_CameraPos;\nvarying vec3 v_PositionWorld;\n#endif\n\n\nvoid main()\n{\n  #ifdef DIFFUSEMAP&&!COLOR\n  gl_FragColor=texture2D(u_DiffuseTexture, v_Texcoord0);\n  #endif \n  \n  #ifdef COLOR&&!DIFFUSEMAP\n  gl_FragColor=v_Color;\n  #endif \n  \n  #ifdef DIFFUSEMAP&&COLOR\n  vec4 texColor=texture2D(u_DiffuseTexture, v_Texcoord0);\n  gl_FragColor=texColor*v_Color;\n  #endif\n  \n  #ifdef !DIFFUSEMAP&&!COLOR\n  gl_FragColor=vec4(1.0,1.0,1.0,1.0);\n  #endif \n  \n  #ifdef AMBIENTMAP\n  gl_FragColor.rgb=gl_FragColor.rgb*(u_MaterialAmbient+texture2D(u_AmbientTexture, v_Texcoord1).rgb);\n  #endif \n  \n  gl_FragColor.rgb=gl_FragColor.rgb*u_Luminance;\n  \n  #ifdef ALPHATEST\n  if(gl_FragColor.a-u_AlphaTestValue<0.0)\n    discard;\n  #endif\n  \n  \n  #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP\n  vec3 normal;\n    #ifdef (DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&NORMALMAP\n    vec3 normalMapSample = texture2D(u_NormalTexture, v_Texcoord0).rgb;\n	normal = normalize(NormalSampleToWorldSpace(normalMapSample, v_Normal, v_Tangent0));\n	#else\n	normal = normalize(v_Normal);\n    #endif\n  #endif\n	\n  #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT\n  vec3 diffuse = vec3(0.0);\n  vec3 ambient = vec3(0.0);\n  vec3 specular= vec3(0.0);\n  vec3 dif, amb, spe;\n  #endif\n  \n  #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP\n  vec3 toEye;\n    #ifdef FOG\n	toEye=u_CameraPos-v_PositionWorld;\n    float toEyeLength=length(toEye);\n    toEye/=toEyeLength;\n    #else\n	toEye=normalize(u_CameraPos-v_PositionWorld);\n    #endif\n  #endif\n	\n  #ifdef DIRECTIONLIGHT\n  computeDirectionLight(u_MaterialDiffuse,u_MaterialAmbient,u_MaterialSpecular,u_DirectionLight,normal,toEye, dif, amb, spe);\n  diffuse+=dif;\n  ambient+=amb;\n  specular+=spe;\n  #endif\n \n  #ifdef POINTLIGHT\n  computePointLight(u_MaterialDiffuse,u_MaterialAmbient,u_MaterialSpecular,u_PointLight,v_PositionWorld,normal,toEye, dif, amb, spe);\n  diffuse+=dif;\n  ambient+=amb;\n  specular+=spe;\n  #endif\n\n  #ifdef SPOTLIGHT\n  ComputeSpotLight(u_MaterialDiffuse,u_MaterialAmbient,u_MaterialSpecular,u_SpotLight,v_PositionWorld,normal,toEye, dif, amb, spe);\n  diffuse+=dif;\n  ambient+=amb;\n  specular+=spe;\n  #endif\n  \n\n  \n  \n  \n  #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT\n    #ifdef (DIFFUSEMAP||COLOR)&&SPECULARMAP\n    specular =specular*texture2D(u_SpecularTexture, v_Texcoord0).rgb;\n    #endif\n  gl_FragColor =vec4( gl_FragColor.rgb*(ambient + diffuse) + specular,gl_FragColor.a);\n  #endif\n  \n  #ifdef REFLECTMAP\n  vec3 incident = -toEye;\n  vec3 reflectionVector = reflect(incident,normal);\n  vec3 reflectionColor  = textureCube(u_ReflectTexture,reflectionVector).rgb;\n  gl_FragColor.rgb += u_MaterialReflect*reflectionColor;\n  #endif\n  \n  #ifdef FOG\n  float lerpFact=clamp((toEyeLength-u_FogStart)/u_FogRange,0.0,1.0);\n  gl_FragColor.rgb=mix(gl_FragColor.rgb,u_FogColor,lerpFact);\n  #endif\n}\n\n"/*__INCLUDESTR__e:/trank/libs/layaair/publish/layaairpublish/src/d3/src/laya/d3/shader/files/pixelsimpletextureskinnedmesh.ps*/;
			Shader.preCompile(Shader3D.SIMPLE,/*laya.d3.shader.ShaderDefines3D.PIXELSHADERING*/0x2000,vs,ps,shaderNameMap);
			shaderNameMap={
				'a_Position':/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION",
				'a_Texcoord':/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV",
				'u_FogStart':/*laya.webgl.utils.Buffer2D.FOGSTART*/"FOGSTART",
				'u_FogRange':/*laya.webgl.utils.Buffer2D.FOGRANGE*/"FOGRANGE",
				'u_FogColor':/*laya.webgl.utils.Buffer2D.FOGCOLOR*/"FOGCOLOR",
				'u_WorldMat':/*laya.webgl.utils.Buffer2D.MATRIX1*/"MATRIX1",
				'u_CameraPos':/*laya.webgl.utils.Buffer2D.CAMERAPOS*/"CAMERAPOS",
				'u_BlendTexture':/*laya.webgl.utils.Buffer2D.DIFFUSETEXTURE*/"DIFFUSETEXTURE",
				'u_LayerTexture0':/*laya.webgl.utils.Buffer2D.NORMALTEXTURE*/"NORMALTEXTURE",
				'u_LayerTexture1':/*laya.webgl.utils.Buffer2D.SPECULARTEXTURE*/"SPECULARTEXTURE",
				'u_LayerTexture2':/*laya.webgl.utils.Buffer2D.EMISSIVETEXTURE*/"EMISSIVETEXTURE",
				'u_LayerTexture3':/*laya.webgl.utils.Buffer2D.AMBIENTTEXTURE*/"AMBIENTTEXTURE",
				'u_MvpMatrix':/*laya.webgl.utils.Buffer2D.MVPMATRIX*/"MVPMATRIX",
				'u_Luminance':/*laya.webgl.utils.Buffer2D.LUMINANCE*/"LUMINANCE",
				'u_Ambient':/*laya.webgl.utils.Buffer2D.MATERIALAMBIENT*/"MATERIALAMBIENT",
				'u_UVMatrix':/*laya.webgl.utils.Buffer2D.MATRIX2*/"MATRIX2"
			};
			vs="#include?VR \"VRHelper.glsl\";\nattribute vec4 a_Position;\nuniform mat4 u_MvpMatrix;\nuniform mat4 u_UVMatrix;\n\n#ifdef DIFFUSEMAP&&NORMALMAP&&SPECULARMAP&&EMISSIVEMAP&&AMBIENTMAP\nattribute vec2 a_Texcoord;\nvarying vec2 v_Texcoord;\nvarying vec2 v_TiledTexcoord;\n#endif\n\n#ifdef FOG\nuniform mat4 u_WorldMat;\nvarying vec3 v_PositionWorld;\n#endif\n\n\nvoid main()\n{\n #ifdef VR\n gl_Position = DistortFishEye(u_MvpMatrix * a_Position);\n #else\n gl_Position = u_MvpMatrix * a_Position;\n #endif\n \n #ifdef FOG\n v_PositionWorld=(u_WorldMat*a_Position).xyz;\n #endif\n \n #ifdef DIFFUSEMAP&&NORMALMAP&&SPECULARMAP&&EMISSIVEMAP&&AMBIENTMAP\n v_Texcoord=a_Texcoord;\n v_TiledTexcoord=(u_UVMatrix*vec4(a_Texcoord,0.0,1.0)).xy;\n #endif\n}"/*__INCLUDESTR__e:/trank/libs/layaair/publish/layaairpublish/src/d3/src/laya/d3/shader/files/modelterrain.vs*/;
			ps="#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\nuniform float u_Luminance;\nuniform vec3 u_Ambient;\n\n#ifdef FOG\nuniform vec3 u_CameraPos;\nvarying vec3 v_PositionWorld;\n\nuniform float u_FogStart;\nuniform float u_FogRange;\nuniform vec3 u_FogColor;\n#endif\n\n#ifdef DIFFUSEMAP&&NORMALMAP&&SPECULARMAP&&EMISSIVEMAP&&AMBIENTMAP\n  varying vec2 v_Texcoord;\n  varying vec2 v_TiledTexcoord;\n  uniform sampler2D u_BlendTexture;\n  uniform sampler2D u_LayerTexture0;\n  uniform sampler2D u_LayerTexture1;\n  uniform sampler2D u_LayerTexture2;\n  uniform sampler2D u_LayerTexture3;\n#endif\n\nvoid main()\n{	\n  #ifdef DIFFUSEMAP&&NORMALMAP&&SPECULARMAP&&EMISSIVEMAP&&AMBIENTMAP\n  vec4 blend=texture2D(u_BlendTexture, v_Texcoord);\n  vec4 c0=texture2D(u_LayerTexture0, v_TiledTexcoord);\n  vec4 c1=texture2D(u_LayerTexture1, v_TiledTexcoord);\n  vec4 c2=texture2D(u_LayerTexture2, v_TiledTexcoord);\n  vec4 c3=texture2D(u_LayerTexture3, v_TiledTexcoord);\n  vec4 texColor = c0;\n  texColor = mix(texColor, c1, blend.r);\n  texColor = mix(texColor, c2, blend.g);\n  texColor = mix(texColor, c3, blend.b);\n  gl_FragColor=vec4(texColor.rgb*u_Ambient.rgb*blend.a*u_Luminance,1.0);\n  #endif \n  \n  #ifdef FOG\n  vec3 toEye=u_CameraPos-v_PositionWorld;\n  float toEyeLength=length(toEye);\n  \n  float lerpFact=clamp((toEyeLength-u_FogStart)/u_FogRange,0.0,1.0);\n  gl_FragColor.rgb=mix(gl_FragColor.rgb,u_FogColor,lerpFact);\n  #endif\n}\n\n"/*__INCLUDESTR__e:/trank/libs/layaair/publish/layaairpublish/src/d3/src/laya/d3/shader/files/modelterrain.ps*/;
			Shader.preCompile(Shader3D.TERRAIN,/*laya.d3.shader.ShaderDefines3D.VERTEXSHADERING*/0x1000 ,vs,ps,shaderNameMap);
			Shader.preCompile(Shader3D.TERRAIN,/*laya.d3.shader.ShaderDefines3D.PIXELSHADERING*/0x2000,vs,ps,shaderNameMap);
			shaderNameMap={
				'a_CornerTextureCoordinate':/*laya.d3.graphics.VertexElementUsage.CORNERTEXTURECOORDINATE0*/"CORNERTEXTURECOORDINATE",
				'a_Position':/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION",
				'a_Velocity':/*laya.d3.graphics.VertexElementUsage.VELOCITY0*/"VELOCITY",
				'a_StartColor':/*laya.d3.graphics.VertexElementUsage.STARTCOLOR0*/"STARTCOLOR",
				'a_EndColor':/*laya.d3.graphics.VertexElementUsage.ENDCOLOR0*/"ENDCOLOR",
				'a_SizeRotation':/*laya.d3.graphics.VertexElementUsage.SIZEROTATION0*/"SIZEROTATION",
				'a_Radius':/*laya.d3.graphics.VertexElementUsage.RADIUS0*/"RADIUS",
				'a_Radian':/*laya.d3.graphics.VertexElementUsage.RADIAN0*/"RADIAN",
				'a_AgeAddScale':/*laya.d3.graphics.VertexElementUsage.AGEADDSCALE0*/"AGEADDSCALE",
				'a_Time':/*laya.d3.graphics.VertexElementUsage.TIME0*/"TIME",
				'u_WorldMat':/*laya.webgl.utils.Buffer2D.MVPMATRIX*/"MVPMATRIX",
				'u_View':/*laya.webgl.utils.Buffer2D.MATRIX1*/"MATRIX1",
				'u_Projection':/*laya.webgl.utils.Buffer2D.MATRIX2*/"MATRIX2",
				'u_ViewportScale':/*laya.webgl.utils.Buffer2D.VIEWPORTSCALE*/"VIEWPORTSCALE",
				'u_CurrentTime':/*laya.webgl.utils.Buffer2D.CURRENTTIME*/"CURRENTTIME",
				'u_Duration':/*laya.webgl.utils.Buffer2D.DURATION*/"DURATION",
				'u_Gravity':/*laya.webgl.utils.Buffer2D.GRAVITY*/"GRAVITY",
				'u_EndVelocity':/*laya.webgl.utils.Buffer2D.ENDVELOCITY*/"ENDVELOCITY",
				'u_texture':/*laya.webgl.utils.Buffer2D.DIFFUSETEXTURE*/"DIFFUSETEXTURE"
			};
			Shader.preCompile(Shader3D.PARTICLE,/*laya.d3.shader.ShaderDefines3D.VERTEXSHADERING*/0x1000 ,ParticleShader.vs,ParticleShader.ps,shaderNameMap);
			Shader.preCompile(Shader3D.PARTICLE,/*laya.d3.shader.ShaderDefines3D.PIXELSHADERING*/0x2000,ParticleShader.vs,ParticleShader.ps,shaderNameMap);
			shaderNameMap={
				'a_CornerTextureCoordinate':/*laya.d3.graphics.VertexElementUsage.CORNERTEXTURECOORDINATE0*/"CORNERTEXTURECOORDINATE",
				'a_Position':/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION",
				'a_Velocity':/*laya.d3.graphics.VertexElementUsage.VELOCITY0*/"VELOCITY",
				'a_StartColor':/*laya.d3.graphics.VertexElementUsage.STARTCOLOR0*/"STARTCOLOR",
				'a_EndColor':/*laya.d3.graphics.VertexElementUsage.ENDCOLOR0*/"ENDCOLOR",
				'a_SizeRotation':/*laya.d3.graphics.VertexElementUsage.SIZEROTATION0*/"SIZEROTATION",
				'a_Radius':/*laya.d3.graphics.VertexElementUsage.RADIUS0*/"RADIUS",
				'a_Radian':/*laya.d3.graphics.VertexElementUsage.RADIAN0*/"RADIAN",
				'a_AgeAddScale':/*laya.d3.graphics.VertexElementUsage.AGEADDSCALE0*/"AGEADDSCALE",
				'a_Time':/*laya.d3.graphics.VertexElementUsage.TIME0*/"TIME",
				'u_WorldMat':/*laya.webgl.utils.Buffer2D.MVPMATRIX*/"MVPMATRIX",
				'u_View':/*laya.webgl.utils.Buffer2D.MATRIX1*/"MATRIX1",
				'u_Projection':/*laya.webgl.utils.Buffer2D.MATRIX2*/"MATRIX2",
				'u_ViewportScale':/*laya.webgl.utils.Buffer2D.VIEWPORTSCALE*/"VIEWPORTSCALE",
				'u_CurrentTime':/*laya.webgl.utils.Buffer2D.CURRENTTIME*/"CURRENTTIME",
				'u_Duration':/*laya.webgl.utils.Buffer2D.DURATION*/"DURATION",
				'u_Gravity':/*laya.webgl.utils.Buffer2D.GRAVITY*/"GRAVITY",
				'u_EndVelocity':/*laya.webgl.utils.Buffer2D.ENDVELOCITY*/"ENDVELOCITY",
				'u_texture':/*laya.webgl.utils.Buffer2D.DIFFUSETEXTURE*/"DIFFUSETEXTURE"
			};
			Shader.preCompile(Shader3D.U3DPARTICLE,/*laya.d3.shader.ShaderDefines3D.VERTEXSHADERING*/0x1000 ,ParticleShader.vs,ParticleShader.ps,shaderNameMap);
			Shader.preCompile(Shader3D.U3DPARTICLE,/*laya.d3.shader.ShaderDefines3D.PIXELSHADERING*/0x2000,ParticleShader.vs,ParticleShader.ps,shaderNameMap);
			shaderNameMap={
				'a_Position':/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION",
				'a_Texcoord0':/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV",
				'a_Time':/*laya.webgl.utils.Buffer2D.TIME*/"TIME",
				'u_Texture':/*laya.webgl.utils.Buffer2D.DIFFUSETEXTURE*/"DIFFUSETEXTURE",
				'u_MvpMatrix':/*laya.webgl.utils.Buffer2D.MVPMATRIX*/"MVPMATRIX",
				'u_Luminance':/*laya.webgl.utils.Buffer2D.LUMINANCE*/"LUMINANCE",
				'u_CurrentTime':/*laya.webgl.utils.Buffer2D.CURRENTTIME*/"CURRENTTIME",
				'u_Color':/*laya.webgl.utils.Buffer2D.UNICOLOR*/"UNICOLOR" ,
				'u_Duration':/*laya.webgl.utils.Buffer2D.DURATION*/"DURATION"
			};
			vs="attribute vec4 a_Position;\nattribute vec2 a_Texcoord0;\nattribute float a_Time;\n\nuniform mat4 u_MvpMatrix;\nuniform  float u_CurrentTime;\nuniform  vec4 u_Color;\nuniform float u_Duration;\n\nvarying vec2 v_Texcoord;\nvarying vec4 v_Color;\n\n\nvoid main()\n{\n  gl_Position = u_MvpMatrix * a_Position;\n  \n  float age = u_CurrentTime-a_Time;\n  float normalizedAge = clamp(age / u_Duration,0.0,1.0);\n   \n  v_Texcoord=a_Texcoord0;\n  \n  v_Color=u_Color;\n  v_Color.a*=1.0-normalizedAge;\n}\n"/*__INCLUDESTR__e:/trank/libs/layaair/publish/layaairpublish/src/d3/src/laya/d3/shader/files/glitter.vs*/;
			ps="#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\nuniform float u_Luminance;\nuniform sampler2D u_Texture;\n\nvarying vec2 v_Texcoord;\nvarying vec4 v_Color;\n\n\nvoid main()\n{	\n  gl_FragColor=texture2D(u_Texture, v_Texcoord)*v_Color;\n  gl_FragColor.rgb=gl_FragColor.rgb*u_Luminance;\n}\n\n"/*__INCLUDESTR__e:/trank/libs/layaair/publish/layaairpublish/src/d3/src/laya/d3/shader/files/glitter.ps*/;
			Shader.preCompile(Shader3D.GLITTER,/*laya.d3.shader.ShaderDefines3D.VERTEXSHADERING*/0x1000 ,vs,ps,shaderNameMap);
			Shader.preCompile(Shader3D.GLITTER,/*laya.d3.shader.ShaderDefines3D.PIXELSHADERING*/0x2000,vs,ps,shaderNameMap);
			shaderNameMap={
				'a_Position':/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION",
				'a_Color':/*laya.d3.graphics.VertexElementUsage.COLOR0*/"COLOR",
				'a_Texcoord0':/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV",
				'a_TexcoordNext0':/*laya.d3.graphics.VertexElementUsage.NEXTTEXTURECOORDINATE0*/"NEXTUV",
				'a_Texcoord1':/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE1*/"UV1",
				'a_TexcoordNext1':/*laya.d3.graphics.VertexElementUsage.NEXTTEXTURECOORDINATE1*/"NEXTUV1",
				'u_DiffuseTexture':/*laya.webgl.utils.Buffer2D.DIFFUSETEXTURE*/"DIFFUSETEXTURE",
				'u_SpecularTexture':/*laya.webgl.utils.Buffer2D.SPECULARTEXTURE*/"SPECULARTEXTURE",
				'u_MvpMatrix':/*laya.webgl.utils.Buffer2D.MVPMATRIX*/"MVPMATRIX",
				'u_FogStart':/*laya.webgl.utils.Buffer2D.FOGSTART*/"FOGSTART",
				'u_FogRange':/*laya.webgl.utils.Buffer2D.FOGRANGE*/"FOGRANGE",
				'u_FogColor':/*laya.webgl.utils.Buffer2D.FOGCOLOR*/"FOGCOLOR",
				'u_Luminance':/*laya.webgl.utils.Buffer2D.LUMINANCE*/"LUMINANCE",
				'u_UVAge':/*laya.webgl.utils.Buffer2D.FLOAT0*/"FLOAT0",
				'u_UVAniAge':/*laya.webgl.utils.Buffer2D.UVAGEX*/"UVAGEX"
			};
			vs="attribute vec4 a_Position;\nuniform mat4 u_MvpMatrix;\n\n#ifdef DIFFUSEMAP\nattribute vec2 a_Texcoord0;\nattribute vec2 a_Texcoord1;\nvarying vec2 v_Texcoord0;\nvarying vec2 v_Texcoord1;\n#ifdef MIXUV\nattribute vec2 a_TexcoordNext0;\nattribute vec2 a_TexcoordNext1;\nuniform float  u_UVAge;\n#endif\n#endif\n\n#ifdef COLOR\nattribute vec4 a_Color;\nvarying vec4 v_Color;\n#endif\n\n\nvoid main()\n{\n gl_Position = u_MvpMatrix * a_Position;\n \n \n #ifdef DIFFUSEMAP\n  #ifdef MIXUV\n  v_Texcoord0=mix(a_Texcoord0,a_TexcoordNext0,u_UVAge);\n   v_Texcoord1=mix(a_Texcoord1,a_TexcoordNext1,u_UVAge);\n  #else\n  v_Texcoord0=a_Texcoord0;\n  v_Texcoord1=a_Texcoord1;\n  #endif\n #endif\n  \n #ifdef COLOR\n v_Color=a_Color;\n #endif\n}"/*__INCLUDESTR__e:/trank/libs/layaair/publish/layaairpublish/src/d3/src/laya/d3/shader/files/simpleeffect.vs*/;
			ps="#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\nuniform float u_Luminance;\n\n#ifdef DIFFUSEMAP\nvarying vec2 v_Texcoord0;\nuniform sampler2D u_DiffuseTexture;\n#endif\n\n#ifdef SPECULARMAP \nvarying vec2 v_Texcoord1;\nuniform sampler2D u_SpecularTexture;\n#endif\n\n#ifdef COLOR\nvarying vec4 v_Color;\n#endif\n\n\n\n#ifdef FOG\nuniform float u_FogStart;\nuniform float u_FogRange;\nuniform vec3 u_FogColor;\n#endif\n\nvoid main()\n{\n  \n  #ifdef DIFFUSEMAP&&!COLOR\n  gl_FragColor=texture2D(u_DiffuseTexture, v_Texcoord0);\n  #endif \n  \n  #ifdef COLOR&&!DIFFUSEMAP\n  gl_FragColor=v_Color;\n  #endif \n  \n  #ifdef DIFFUSEMAP&&COLOR\n  vec4 texColor=texture2D(u_DiffuseTexture, v_Texcoord0);\n  gl_FragColor=texColor*v_Color;\n  #endif\n  \n  #ifdef SPECULARMAP \n  vec4 specularColor=texture2D(u_SpecularTexture, v_Texcoord1);\n  gl_FragColor=gl_FragColor*specularColor;\n  #endif\n \n  gl_FragColor.rgb=gl_FragColor.rgb*u_Luminance;\n  \n  #ifdef FOG\n  float lerpFact=clamp((toEyeLength-u_FogStart)/u_FogRange,0.0,1.0);\n  gl_FragColor.rgb=mix(gl_FragColor.rgb,u_FogColor,lerpFact);\n  #endif\n}\n\n"/*__INCLUDESTR__e:/trank/libs/layaair/publish/layaairpublish/src/d3/src/laya/d3/shader/files/simpleeffect.ps*/;
			Shader.preCompile(Shader3D.SIMPLE_EFFECT,/*laya.d3.shader.ShaderDefines3D.VERTEXSHADERING*/0x1000 ,vs,ps,shaderNameMap);
			vs="attribute vec4 a_Position;\nuniform mat4 u_MvpMatrix;\n\n#ifdef DIFFUSEMAP\nattribute vec2 a_Texcoord0;\nattribute vec2 a_Texcoord1;\nvarying vec2 v_Texcoord0;\nvarying vec2 v_Texcoord1;\n#ifdef MIXUV\nattribute vec2 a_TexcoordNext0;\nattribute vec2 a_TexcoordNext1;\nuniform float  u_UVAge;\n#endif\n#endif\n\n#ifdef COLOR\nattribute vec4 a_Color;\nvarying vec4 v_Color;\n#endif\n\n\nvoid main()\n{\n gl_Position = u_MvpMatrix * a_Position;\n \n \n #ifdef DIFFUSEMAP\n  #ifdef MIXUV\n  v_Texcoord0=mix(a_Texcoord0,a_TexcoordNext0,u_UVAge);\n   v_Texcoord1=mix(a_Texcoord1,a_TexcoordNext1,u_UVAge);\n  #else\n  v_Texcoord0=a_Texcoord0;\n  v_Texcoord1=a_Texcoord1;\n  #endif\n #endif\n  \n #ifdef COLOR\n v_Color=a_Color;\n #endif\n}"/*__INCLUDESTR__e:/trank/libs/layaair/publish/layaairpublish/src/d3/src/laya/d3/shader/files/simpleeffect.vs*/;
			ps="#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\nuniform float u_Luminance;\n\n#ifdef DIFFUSEMAP\nvarying vec2 v_Texcoord0;\nuniform sampler2D u_DiffuseTexture;\n#endif\n\n#ifdef SPECULARMAP \nvarying vec2 v_Texcoord1;\nuniform sampler2D u_SpecularTexture;\n#endif\n\n#ifdef COLOR\nvarying vec4 v_Color;\n#endif\n\n\n\n#ifdef FOG\nuniform float u_FogStart;\nuniform float u_FogRange;\nuniform vec3 u_FogColor;\n#endif\n\nvoid main()\n{\n  \n  #ifdef DIFFUSEMAP&&!COLOR\n  gl_FragColor=texture2D(u_DiffuseTexture, v_Texcoord0);\n  #endif \n  \n  #ifdef COLOR&&!DIFFUSEMAP\n  gl_FragColor=v_Color;\n  #endif \n  \n  #ifdef DIFFUSEMAP&&COLOR\n  vec4 texColor=texture2D(u_DiffuseTexture, v_Texcoord0);\n  gl_FragColor=texColor*v_Color;\n  #endif\n  \n  #ifdef SPECULARMAP \n  vec4 specularColor=texture2D(u_SpecularTexture, v_Texcoord1);\n  gl_FragColor=gl_FragColor*specularColor;\n  #endif\n \n  gl_FragColor.rgb=gl_FragColor.rgb*u_Luminance;\n  \n  #ifdef FOG\n  float lerpFact=clamp((toEyeLength-u_FogStart)/u_FogRange,0.0,1.0);\n  gl_FragColor.rgb=mix(gl_FragColor.rgb,u_FogColor,lerpFact);\n  #endif\n}\n\n"/*__INCLUDESTR__e:/trank/libs/layaair/publish/layaairpublish/src/d3/src/laya/d3/shader/files/simpleeffect.ps*/;
			Shader.preCompile(Shader3D.SIMPLE_EFFECT,/*laya.d3.shader.ShaderDefines3D.PIXELSHADERING*/0x2000,vs,ps,shaderNameMap);
		}

		Shader3D.SIMPLE=0;
		Shader3D.TERRAIN=0;
		Shader3D.PARTICLE=0;
		Shader3D.U3DPARTICLE=0;
		Shader3D.GLITTER=0;
		Shader3D.SIMPLE_EFFECT=0;
		return Shader3D;
	})()


	/**
	*<code>Picker</code> 类用于创建拾取。
	*/
	//class laya.d3.utils.Picker
	var Picker=(function(){
		/**
		*创建一个 <code>Picker</code> 实例。
		*/
		function Picker(){}
		__class(Picker,'laya.d3.utils.Picker');
		Picker.calculateCursorRay=function(point,viewPort,projectionMatrix,viewMatrix,world,out){
			var x=point.elements[0];
			var y=point.elements[1];
			var nearSource=Picker._tempVector30;
			var nerSourceE=nearSource.elements;
			nerSourceE[0]=x;
			nerSourceE[1]=y;
			nerSourceE[2]=viewPort.minDepth;
			var farSource=Picker._tempVector31;
			var farSourceE=farSource.elements;
			farSourceE[0]=x;
			farSourceE[1]=y;
			farSourceE[2]=viewPort.maxDepth;
			var nearPoint=out.origin;
			var farPoint=Picker._tempVector32;
			viewPort.unprojectFromWVP(nearSource,projectionMatrix,viewMatrix,world,nearPoint);
			viewPort.unprojectFromWVP(farSource,projectionMatrix,viewMatrix,world,farPoint);
			var outDire=out.direction.elements;
			outDire[0]=farPoint.x-nearPoint.x;
			outDire[1]=farPoint.y-nearPoint.y;
			outDire[2]=farPoint.z-nearPoint.z;
			Vector3.normalize(out.direction,out.direction);
		}

		Picker.rayIntersectsPositionsAndIndices=function(ray,positions,indices,outVertex0,outVertex1,outVertex2){
			var closestIntersection=Number.MAX_VALUE;
			for (var j=0;j < indices.length;j+=3){
				var vertex1=positions[indices[j+0]];
				var vertex2=positions[indices[j+1]];
				var vertex3=positions[indices[j+2]];
				var intersection=laya.d3.utils.Picker.rayIntersectsTriangle(ray,vertex1,vertex2,vertex3);
				if (!isNaN(intersection)&& intersection < closestIntersection){
					closestIntersection=intersection;
					vertex1.cloneTo(outVertex0);
					vertex2.cloneTo(outVertex1);
					vertex3.cloneTo(outVertex2);
				}
			}
			return closestIntersection;
		}

		Picker.rayIntersectsTriangle=function(ray,vertex1,vertex2,vertex3){
			var result;
			var edge1=Picker._tempVector30,edge2=Picker._tempVector31;
			Vector3.subtract(vertex2,vertex1,edge1);
			Vector3.subtract(vertex3,vertex1,edge2);
			var directionCrossEdge2=Picker._tempVector32;
			Vector3.cross(ray.direction,edge2,directionCrossEdge2);
			var determinant;
			determinant=Vector3.dot(edge1,directionCrossEdge2);
			if (determinant >-Number.MIN_VALUE && determinant < Number.MIN_VALUE){
				result=Number.NaN;
				return result;
			};
			var inverseDeterminant=1.0 / determinant;
			var distanceVector=Picker._tempVector33;
			Vector3.subtract(ray.origin,vertex1,distanceVector);
			var triangleU;
			triangleU=Vector3.dot(distanceVector,directionCrossEdge2);
			triangleU *=inverseDeterminant;
			if (triangleU < 0 || triangleU > 1){
				result=Number.NaN;
				return result;
			};
			var distanceCrossEdge1=Picker._tempVector34;
			Vector3.cross(distanceVector,edge1,distanceCrossEdge1);
			var triangleV;
			triangleV=Vector3.dot(ray.direction,distanceCrossEdge1);
			triangleV *=inverseDeterminant;
			if (triangleV < 0 || triangleU+triangleV > 1){
				result=Number.NaN;
				return result;
			};
			var rayDistance;
			rayDistance=Vector3.dot(edge2,distanceCrossEdge1);
			rayDistance *=inverseDeterminant;
			if (rayDistance < 0){
				result=Number.NaN;
				return result;
			}
			result=rayDistance;
			return result;
		}

		__static(Picker,
		['_tempVector30',function(){return this._tempVector30=new Vector3();},'_tempVector31',function(){return this._tempVector31=new Vector3();},'_tempVector32',function(){return this._tempVector32=new Vector3();},'_tempVector33',function(){return this._tempVector33=new Vector3();},'_tempVector34',function(){return this._tempVector34=new Vector3();}
		]);
		return Picker;
	})()


	//class laya.d3.utils.Size
	var Size=(function(){
		function Size(width,height){
			this._width=0;
			this._height=0;
			this._width=width;
			this._height=height;
		}

		__class(Size,'laya.d3.utils.Size');
		var __proto=Size.prototype;
		__getset(0,__proto,'width',function(){
			if (this._width===-1)
				return RenderState.clientWidth;
			return this._width;
		});

		__getset(0,__proto,'height',function(){
			if (this._height===-1)
				return RenderState.clientHeight;
			return this._height;
		});

		__getset(1,Size,'fullScreen',function(){
			return new Size(-1,-1);
		});

		return Size;
	})()


	/**
	*<code>Utils3D</code> 类用于创建3D工具。
	*/
	//class laya.d3.utils.Utils3D
	var Utils3D=(function(){
		function Utils3D(){};
		__class(Utils3D,'laya.d3.utils.Utils3D');
		Utils3D._getTexturePath=function(path){
			var extenIndex=path.length-4;
			if (path.indexOf(".dds")==extenIndex || path.indexOf(".tga")==extenIndex || path.indexOf(".exr")==extenIndex || path.indexOf(".DDS")==extenIndex || path.indexOf(".TGA")==extenIndex || path.indexOf(".EXR")==extenIndex)
				path=path.substr(0,extenIndex)+".png";
			return path=URL.formatURL(path);
		}

		Utils3D.GenerateTangent=function(vertexDatas,vertexStride,positionOffset,uvOffset,indices){
			var tangentElementCount=3;
			var newVertexStride=vertexStride+tangentElementCount;
			var tangentVertexDatas=new Float32Array(newVertexStride *(vertexDatas.length / vertexStride));
			for (var i=0;i < indices.length;i+=3){
				var index1=indices[i+0];
				var index2=indices[i+1];
				var index3=indices[i+2];
				var position1Offset=vertexStride *index1+positionOffset;
				var position1=Utils3D._tempVector3_0;
				position1.x=vertexDatas[position1Offset+0];
				position1.y=vertexDatas[position1Offset+1];
				position1.z=vertexDatas[position1Offset+2];
				var position2Offset=vertexStride *index2+positionOffset;
				var position2=Utils3D._tempVector3_1;
				position2.x=vertexDatas[position2Offset+0];
				position2.y=vertexDatas[position2Offset+1];
				position2.z=vertexDatas[position2Offset+2];
				var position3Offset=vertexStride *index3+positionOffset;
				var position3=Utils3D._tempVector3_2;
				position3.x=vertexDatas[position3Offset+0];
				position3.y=vertexDatas[position3Offset+1];
				position3.z=vertexDatas[position3Offset+2];
				var uv1Offset=vertexStride *index1+uvOffset;
				var UV1X=vertexDatas[uv1Offset+0];
				var UV1Y=vertexDatas[uv1Offset+1];
				var uv2Offset=vertexStride *index2+uvOffset;
				var UV2X=vertexDatas[uv2Offset+0];
				var UV2Y=vertexDatas[uv2Offset+1];
				var uv3Offset=vertexStride *index3+uvOffset;
				var UV3X=vertexDatas[uv3Offset+0];
				var UV3Y=vertexDatas[uv3Offset+1];
				var lengthP2ToP1=Utils3D._tempVector3_3;
				Vector3.subtract(position2,position1,lengthP2ToP1);
				var lengthP3ToP1=Utils3D._tempVector3_4;
				Vector3.subtract(position3,position1,lengthP3ToP1);
				Vector3.scale(lengthP2ToP1,UV3Y-UV1Y,lengthP2ToP1);
				Vector3.scale(lengthP3ToP1,UV2Y-UV1Y,lengthP3ToP1);
				var tangent=Utils3D._tempVector3_5;
				Vector3.subtract(lengthP2ToP1,lengthP3ToP1,tangent);
				Vector3.scale(tangent,1.0 / ((UV2X-UV1X)*(UV3Y-UV1Y)-(UV2Y-UV1Y)*(UV3X-UV1X)),tangent);
				var j=0;
				for (j=0;j < vertexStride;j++)
				tangentVertexDatas[newVertexStride *index1+j]=vertexDatas[vertexStride *index1+j];
				for (j=0;j < tangentElementCount;j++)
				tangentVertexDatas[newVertexStride *index1+vertexStride+j]=+tangent.elements[j];
				for (j=0;j < vertexStride;j++)
				tangentVertexDatas[newVertexStride *index2+j]=vertexDatas[vertexStride *index2+j];
				for (j=0;j < tangentElementCount;j++)
				tangentVertexDatas[newVertexStride *index2+vertexStride+j]=+tangent.elements[j];
				for (j=0;j < vertexStride;j++)
				tangentVertexDatas[newVertexStride *index3+j]=vertexDatas[vertexStride *index3+j];
				for (j=0;j < tangentElementCount;j++)
				tangentVertexDatas[newVertexStride *index3+vertexStride+j]=+tangent.elements[j];
			}
			for (i=0;i < tangentVertexDatas.length;i+=newVertexStride){
				var tangentStartIndex=newVertexStride *i+vertexStride;
				var t=Utils3D._tempVector3_6;
				t.x=tangentVertexDatas[tangentStartIndex+0];
				t.y=tangentVertexDatas[tangentStartIndex+1];
				t.z=tangentVertexDatas[tangentStartIndex+2];
				Vector3.normalize(t,t);
				tangentVertexDatas[tangentStartIndex+0]=t.x;
				tangentVertexDatas[tangentStartIndex+1]=t.y;
				tangentVertexDatas[tangentStartIndex+2]=t.z;
			}
			return tangentVertexDatas;
		}

		Utils3D.getVertexTangentDeclaration=function(vertexElements){
			var position=false,normal=false,color=false,texcoord=false,blendWeight=false,blendIndex=false;
			for (var i=0;i < vertexElements.length;i++){
				switch ((vertexElements [i]).elementUsage){
					case "POSITION":
						position=true;
						break ;
					case "NORMAL":
						normal=true;
						break ;
					case "COLOR":
						color=true;
						break ;
					case "UV":
						texcoord=true;
						break ;
					case "BLENDWEIGHT":
						blendWeight=true;
						break ;
					case "BLENDINDICES":
						blendIndex=true;
						break ;
					}
			};
			var vertexDeclaration;
			if (position && normal && color && texcoord && blendWeight && blendIndex)
				vertexDeclaration=VertexPositionNormalColorTextureSkinTangent.vertexDeclaration;
			else if (position && normal && texcoord && blendWeight && blendIndex)
			vertexDeclaration=VertexPositionNormalTextureSkinTangent.vertexDeclaration;
			else if (position && normal && color && blendWeight && blendIndex)
			vertexDeclaration=VertexPositionNormalColorSkinTangent.vertexDeclaration;
			else if (position && normal && color && texcoord)
			vertexDeclaration=VertexPositionNormalColorTextureTangent.vertexDeclaration;
			else if (position && normal && texcoord)
			vertexDeclaration=VertexPositionNormalTextureTangent.vertexDeclaration;
			else if (position && normal && color)
			vertexDeclaration=VertexPositionNormalColorTangent.vertexDeclaration;
			return vertexDeclaration;
		}

		Utils3D._parseHierarchyProp=function(node,prop,value){
			switch (prop){
				case "translate":
					node.transform.localPosition=new Vector3(value[0],value[1],value[2]);
					break ;
				case "rotation":
					node.transform.localRotation=new Quaternion(value[0],value[1],value[2],value[3]);
					break ;
				case "scale":
					node.transform.localScale=new Vector3(value[0],value[1],value[2]);
					break ;
				}
		}

		Utils3D._parseHierarchyNode=function(instanceParams){
			if (instanceParams)
				return new MeshSprite3D(Mesh.load(instanceParams.loadPath));
			else
			return new Sprite3D();
		}

		Utils3D._parseMaterial=function(material,prop,value){
			switch (prop){
				case "ambientColor":
					material.ambientColor=new Vector3(value[0],value[1],value[2]);
					break ;
				case "diffuseColor":
					material.diffuseColor=new Vector3(value[0],value[1],value[2]);
					break ;
				case "specularColor":
					material.specularColor=new Vector4(value[0],value[1],value[2],value[3]);
					break ;
				case "reflectColor":
					material.reflectColor=new Vector3(value[0],value[1],value[2]);
					break ;
				case "diffuseTexture":
					(value.texture2D)&& (Laya.loader.load(Utils3D._getTexturePath(value.texture2D),Handler.create(null,function(tex){
						(tex.bitmap).enableMerageInAtlas=false;
						(tex.bitmap).mipmap=true;
						(tex.bitmap).repeat=true;
						material.diffuseTexture=tex;
					})));
					break ;
				case "normalTexture":
					(value.texture2D)&& (Laya.loader.load(Utils3D._getTexturePath(value.texture2D),Handler.create(null,function(tex){
						(tex.bitmap).enableMerageInAtlas=false;
						(tex.bitmap).mipmap=true;
						(tex.bitmap).repeat=true;
						material.normalTexture=tex;
					})));
					break ;
				case "specularTexture":
					(value.texture2D)&& (Laya.loader.load(Utils3D._getTexturePath(value.texture2D),Handler.create(null,function(tex){
						(tex.bitmap).enableMerageInAtlas=false;
						(tex.bitmap).mipmap=true;
						(tex.bitmap).repeat=true;
						material.specularTexture=tex;
					})));
					break ;
				case "emissiveTexture":
					(value.texture2D)&& (Laya.loader.load(Utils3D._getTexturePath(value.texture2D),Handler.create(null,function(tex){
						(tex.bitmap).enableMerageInAtlas=false;
						(tex.bitmap).mipmap=true;
						(tex.bitmap).repeat=true;
						material.emissiveTexture=tex;
					})));
					break ;
				case "ambientTexture":
					(value.texture2D)&& (Laya.loader.load(Utils3D._getTexturePath(value.texture2D),Handler.create(null,function(tex){
						(tex.bitmap).enableMerageInAtlas=false;
						(tex.bitmap).mipmap=true;
						(tex.bitmap).repeat=true;
						material.ambientTexture=tex;
					})));
					break ;
				case "reflectTexture":
					(value.texture2D)&& (Laya.loader.load(Utils3D._getTexturePath(value.texture2D),Handler.create(null,function(tex){
						(tex.bitmap).enableMerageInAtlas=false;
						(tex.bitmap).mipmap=true;
						(tex.bitmap).repeat=true;
						material.reflectTexture=tex;
					})));
					break ;
				}
		}

		Utils3D._computeSkinAnimationData=function(bones,curData,exData,bonesDatas,animationDatas){
			var offset=0;
			var matOffset=0;
			var len=exData.length / 2;
			var i;
			var parentOffset;
			var boneLength=bones.length;
			for (i=0;i < boneLength;offset+=bones[i].keyframeWidth,matOffset+=16,i++){
				laya.d3.utils.Utils3D.rotationTransformScale(curData[offset+7],curData[offset+8],curData[offset+9],curData[offset+3],curData[offset+4],curData[offset+5],curData[offset+6],curData[offset+0],curData[offset+1],curData[offset+2],bonesDatas,matOffset);
				if (i !=0){
					parentOffset=bones[i].parentIndex *16;
					laya.d3.utils.Utils3D.mulMatrixByArray(bonesDatas,parentOffset,bonesDatas,matOffset,bonesDatas,matOffset);
				}
			}
			for (i=0;i < len;i+=16){
				laya.d3.utils.Utils3D.mulMatrixByArrayFast(bonesDatas,i,exData,len+i,animationDatas,i);
			}
		}

		Utils3D._computeRootAnimationData=function(bones,curData,animationDatas){
			var offset=0;
			var matOffset=0;
			var i;
			var parentOffset;
			var boneLength=bones.length;
			for (i=0;i < boneLength;offset+=bones[i].keyframeWidth,matOffset+=16,i++){
				laya.d3.utils.Utils3D.rotationTransformScale(curData[offset+7],curData[offset+8],curData[offset+9],curData[offset+3],curData[offset+4],curData[offset+5],curData[offset+6],curData[offset+0],curData[offset+1],curData[offset+2],animationDatas,matOffset);
				if (i !=0){
					parentOffset=bones[i].parentIndex *16;
					laya.d3.utils.Utils3D.mulMatrixByArray(animationDatas,parentOffset,animationDatas,matOffset,animationDatas,matOffset);
				}
			}
		}

		Utils3D.mulMatrixByArray=function(leftArray,leftOffset,rightArray,rightOffset,outArray,outOffset){
			var i,ai0,ai1,ai2,ai3;
			if (outArray===rightArray){
				rightArray=Utils3D._tempArray16_3;
				for (i=0;i < 16;++i){
					rightArray[i]=outArray[outOffset+i];
				}
				rightOffset=0;
			}
			for (i=0;i < 4;i++){
				ai0=leftArray[leftOffset+i];
				ai1=leftArray[leftOffset+i+4];
				ai2=leftArray[leftOffset+i+8];
				ai3=leftArray[leftOffset+i+12];
				outArray[outOffset+i]=ai0 *rightArray[rightOffset+0]+ai1 *rightArray[rightOffset+1]+ai2 *rightArray[rightOffset+2]+ai3 *rightArray[rightOffset+3];
				outArray[outOffset+i+4]=ai0 *rightArray[rightOffset+4]+ai1 *rightArray[rightOffset+5]+ai2 *rightArray[rightOffset+6]+ai3 *rightArray[rightOffset+7];
				outArray[outOffset+i+8]=ai0 *rightArray[rightOffset+8]+ai1 *rightArray[rightOffset+9]+ai2 *rightArray[rightOffset+10]+ai3 *rightArray[rightOffset+11];
				outArray[outOffset+i+12]=ai0 *rightArray[rightOffset+12]+ai1 *rightArray[rightOffset+13]+ai2 *rightArray[rightOffset+14]+ai3 *rightArray[rightOffset+15];
			}
		}

		Utils3D.mulMatrixByArrayFast=function(leftArray,leftOffset,rightArray,rightOffset,outArray,outOffset){
			var i,ai0,ai1,ai2,ai3;
			for (i=0;i < 4;i++){
				ai0=leftArray[leftOffset+i];
				ai1=leftArray[leftOffset+i+4];
				ai2=leftArray[leftOffset+i+8];
				ai3=leftArray[leftOffset+i+12];
				outArray[outOffset+i]=ai0 *rightArray[rightOffset+0]+ai1 *rightArray[rightOffset+1]+ai2 *rightArray[rightOffset+2]+ai3 *rightArray[rightOffset+3];
				outArray[outOffset+i+4]=ai0 *rightArray[rightOffset+4]+ai1 *rightArray[rightOffset+5]+ai2 *rightArray[rightOffset+6]+ai3 *rightArray[rightOffset+7];
				outArray[outOffset+i+8]=ai0 *rightArray[rightOffset+8]+ai1 *rightArray[rightOffset+9]+ai2 *rightArray[rightOffset+10]+ai3 *rightArray[rightOffset+11];
				outArray[outOffset+i+12]=ai0 *rightArray[rightOffset+12]+ai1 *rightArray[rightOffset+13]+ai2 *rightArray[rightOffset+14]+ai3 *rightArray[rightOffset+15];
			}
		}

		Utils3D.rotationTransformScale=function(tx,ty,tz,qx,qy,qz,qw,sx,sy,sz,outArray,outOffset){
			var re=Utils3D._tempArray16_0;
			var se=Utils3D._tempArray16_1;
			var tse=Utils3D._tempArray16_2;
			var x2=qx+qx;
			var y2=qy+qy;
			var z2=qz+qz;
			var xx=qx *x2;
			var yx=qy *x2;
			var yy=qy *y2;
			var zx=qz *x2;
			var zy=qz *y2;
			var zz=qz *z2;
			var wx=qw *x2;
			var wy=qw *y2;
			var wz=qw *z2;
			re[15]=1;
			re[0]=1-yy-zz;
			re[1]=yx+wz;
			re[2]=zx-wy;
			re[4]=yx-wz;
			re[5]=1-xx-zz;
			re[6]=zy+wx;
			re[8]=zx+wy;
			re[9]=zy-wx;
			re[10]=1-xx-yy;
			se[15]=1;
			se[0]=sx;
			se[5]=sy;
			se[10]=sz;
			var i,a,b,e,ai0,ai1,ai2,ai3;
			for (i=0;i < 4;i++){
				ai0=re[i];
				ai1=re[i+4];
				ai2=re[i+8];
				ai3=re[i+12];
				tse[i]=ai0;
				tse[i+4]=ai1;
				tse[i+8]=ai2;
				tse[i+12]=ai0 *tx+ai1 *ty+ai2 *tz+ai3;
			}
			for (i=0;i < 4;i++){
				ai0=tse[i];
				ai1=tse[i+4];
				ai2=tse[i+8];
				ai3=tse[i+12];
				outArray[i+outOffset]=ai0 *se[0]+ai1 *se[1]+ai2 *se[2]+ai3 *se[3];
				outArray[i+outOffset+4]=ai0 *se[4]+ai1 *se[5]+ai2 *se[6]+ai3 *se[7];
				outArray[i+outOffset+8]=ai0 *se[8]+ai1 *se[9]+ai2 *se[10]+ai3 *se[11];
				outArray[i+outOffset+12]=ai0 *se[12]+ai1 *se[13]+ai2 *se[14]+ai3 *se[15];
			}
		}

		Utils3D.transformVector3ArrayToVector3ArrayCoordinate=function(source,sourceOffset,transform,result,resultOffset){
			var vectorElem=Utils3D._tempArray4_0;
			var coordinateX=source[sourceOffset+0];
			var coordinateY=source[sourceOffset+1];
			var coordinateZ=source[sourceOffset+2];
			var transformElem=transform.elements;
			vectorElem[0]=(coordinateX *transformElem[0])+(coordinateY *transformElem[4])+(coordinateZ *transformElem[8])+transformElem[12];
			vectorElem[1]=(coordinateX *transformElem[1])+(coordinateY *transformElem[5])+(coordinateZ *transformElem[9])+transformElem[13];
			vectorElem[2]=(coordinateX *transformElem[2])+(coordinateY *transformElem[6])+(coordinateZ *transformElem[10])+transformElem[14];
			vectorElem[3]=1.0 / ((coordinateX *transformElem[3])+(coordinateY *transformElem[7])+(coordinateZ *transformElem[11])+transformElem[15]);
			result[resultOffset+0]=vectorElem[0] *vectorElem[3];
			result[resultOffset+1]=vectorElem[1] *vectorElem[3];
			result[resultOffset+2]=vectorElem[2] *vectorElem[3];
		}

		Utils3D.convert3DCoordTo2DScreenCoord=function(source,out){
			var se=source.elements;
			var oe=out.elements;
			oe[0]=-RenderState.clientWidth/2+se[0];
			oe[1]=RenderState.clientHeight/2-se[1];
			oe[2]=se[2];
		}

		Utils3D._tempVector3_0=new Vector3();
		Utils3D._tempVector3_1=new Vector3();
		Utils3D._tempVector3_2=new Vector3();
		Utils3D._tempVector3_3=new Vector3();
		Utils3D._tempVector3_4=new Vector3();
		Utils3D._tempVector3_5=new Vector3();
		Utils3D._tempVector3_6=new Vector3();
		Utils3D._tempArray4_0=new Float32Array(4);
		Utils3D._tempArray16_0=new Float32Array(16);
		Utils3D._tempArray16_1=new Float32Array(16);
		Utils3D._tempArray16_2=new Float32Array(16);
		Utils3D._tempArray16_3=new Float32Array(16);
		__static(Utils3D,
		['_typeToFunO',function(){return this._typeToFunO={"INT16":"writeInt16","SHORT":"writeInt16","UINT16":"writeUint16","UINT32":"writeUint32","FLOAT32":"writeFloat32","INT":"writeInt32","UINT":"writeUint32","BYTE":"writeByte","STRING":"writeUTFString"};}
		]);
		return Utils3D;
	})()


	/**
	*<code>Laya3D</code> 类用于初始化3D设置。
	*/
	//class Laya3D
	var Laya3D=(function(){
		/**
		*创建一个 <code>Laya3D</code> 实例。
		*/
		function Laya3D(){}
		__class(Laya3D,'Laya3D');
		Laya3D.init=function(width,height){
			if (!WebGL.enable()){
				alert("Laya3D init err,must support webGL!");
				return;
			}
			Loader.parserMap={"TextureCube":Laya3D._loadTextureCube};
			RunDriver.changeWebGLSize=function (width,height){
				WebGL.onStageResize(width,height);
				RenderState.clientWidth=width;
				RenderState.clientHeight=height;
			}
			Render.is3DMode=true;
			Laya.init(width,height);
			Layer.__init__();
			ShaderDefines3D.__init__();
			Shader3D.__init__();
			Component3D.__init__();
			Laya3D._regClassforJson();
		}

		Laya3D._regClassforJson=function(){
			ClassUtils.regClass("Sprite3D",Sprite3D);
			ClassUtils.regClass("MeshSprite3D",MeshSprite3D);
			ClassUtils.regClass("Material",Material);
		}

		Laya3D._loadTextureCube=function(loader){
			Laya.loader.load(loader.url,Handler.create(null,function(data){
				var preBasePath=URL.basePath;
				URL.basePath=URL.getPath(URL.formatURL(loader.url));
				var webGLImageCube=new WebGLImageCube([data.px,data.nx,data.py,data.ny,data.pz,data.nz],data.size);
				URL.basePath=preBasePath;
				webGLImageCube.on(/*laya.events.Event.LOADED*/"loaded",null,function(imgCube){
					var cubeTexture=new Texture(webGLImageCube);
					loader.endLoad(cubeTexture);
				});
			}),null,/*laya.net.Loader.JSON*/"json",1,false);
		}

		return Laya3D;
	})()


	/**
	*<code>Component3D</code> 类用于创建组件的父类。
	*/
	//class laya.d3.component.Component3D extends laya.events.EventDispatcher
	var Component3D=(function(_super){
		function Component3D(){
			this._id=0;
			this._cachedOwnerLayerMask=0;
			this._cachedOwnerEnable=false;
			this._enable=false;
			this._owner=null;
			this.started=false;
			Component3D.__super.call(this);
			this._id=Component3D._uniqueIDCounter;
			Component3D._uniqueIDCounter++;
		}

		__class(Component3D,'laya.d3.component.Component3D',_super);
		var __proto=Component3D.prototype;
		Laya.imps(__proto,{"laya.d3.core.render.IUpdate":true})
		/**
		*@private
		*owner蒙版变化事件处理。
		*@param mask 蒙版值。
		*/
		__proto._onLayerChanged=function(mask){
			this._cachedOwnerLayerMask=mask;
		}

		/**
		*@private
		*owner启用变化事件处理。
		*@param enable 是否启用。
		*/
		__proto._onEnableChanged=function(enable){
			this._cachedOwnerEnable=enable;
		}

		/**
		*@private
		*初始化组件。
		*@param owner 所属Sprite3D节点。
		*/
		__proto._initialize=function(owner){
			this._owner=owner;
			this.enable=true;
			this.started=false;
			this._cachedOwnerLayerMask=owner.layer.mask;
			this._owner.on(/*laya.events.Event.LAYER_CHANGED*/"layerchanged",this,this._onLayerChanged);
			this._cachedOwnerEnable=owner.enable;
			this._owner.on(/*laya.events.Event.ENABLED_CHANGED*/"enabledchanged",this,this._onEnableChanged);
			this._load(owner);
		}

		/**
		*@private
		*卸载组件。
		*/
		__proto._uninitialize=function(){
			this._unload(this.owner);
			this._owner.off(/*laya.events.Event.LAYER_CHANGED*/"layerchanged",this,this._onLayerChanged);
			this._owner.off(/*laya.events.Event.ENABLED_CHANGED*/"enabledchanged",this,this._onEnableChanged);
			this._owner=null;
		}

		/**
		*@private
		*载入组件时执行,可重写此函数。
		*/
		__proto._load=function(owner){}
		/**
		*@private
		*在任意第一次更新时执行,可重写此函数。
		*/
		__proto._start=function(state){}
		/**
		*@private
		*更新组件,可重写此函数。
		*@param state 渲染状态参数。
		*/
		__proto._update=function(state){}
		/**
		*@private
		*更新的最后阶段执行,可重写此函数。
		*@param state 渲染状态参数。
		*/
		__proto._lateUpdate=function(state){}
		/**
		*@private
		*渲染前设置组件相关参数,可重写此函数。
		*@param state 渲染状态参数。
		*/
		__proto._preRenderUpdate=function(state){}
		/**
		*@private
		*渲染的最后阶段执行,可重写此函数。
		*@param state 渲染状态参数。
		*/
		__proto._postRenderUpdate=function(state){}
		/**
		*@private
		*卸载组件时执行,可重写此函数。
		*/
		__proto._unload=function(owner){}
		/**
		*获取唯一标识ID。
		*@return 唯一标识ID。
		*/
		__getset(0,__proto,'id',function(){
			return this._id;
		});

		/**
		*获取所属Sprite3D节点。
		*@return 所属Sprite3D节点。
		*/
		__getset(0,__proto,'owner',function(){
			return this._owner;
		});

		/**
		*设置是否启用。
		*@param value 是否启动
		*/
		/**
		*获取是否启用。
		*@return 是否启动。
		*/
		__getset(0,__proto,'enable',function(){
			return this._enable;
			},function(value){
			if (this._enable!==value){
				this._enable=value;
				this.event(/*laya.events.Event.ENABLED_CHANGED*/"enabledchanged",this._enable);
			}
		});

		/**
		*获取是否激活。
		*@return 是否激活。
		*/
		__getset(0,__proto,'isActive',function(){
			return Layer.isActive(this._cachedOwnerLayerMask)&& this._cachedOwnerEnable && this._enable;
		});

		/**
		*获取是否可见。
		*@return 是否可见。
		*/
		__getset(0,__proto,'isVisible',function(){
			return Layer.isVisible(this._cachedOwnerLayerMask)&& this._cachedOwnerEnable && this._enable;
		});

		Component3D.__init__=function(){}
		Component3D._uniqueIDCounter=1;
		return Component3D;
	})(EventDispatcher)


	/**
	*<code>Material</code> 类用于创建材质。
	*/
	//class laya.d3.core.material.Material extends laya.events.EventDispatcher
	var Material=(function(_super){
		function Material(){
			this._id=0;
			this._renderQueue=0;
			this._texturesloaded=false;
			this._shader=null;
			this._sharderNameID=0;
			this._disableDefine=0;
			this._color=[];
			this._transparent=false;
			this._transparentMode=0;
			this._alphaTestValue=0.5;
			this._cullFace=true;
			this._transparentAddtive=false;
			this._luminance=1.0;
			this._transformUV=null;
			this._shaderDef=0;
			this._isSky=false;
			this.name=null;
			this.loaded=false;
			Material.__super.call(this);
			this._textures=[];
			this._texturesSharderIndex=[];
			this._otherSharderIndex=[];
			this._shaderValues=new ValusArray();
			this._id=++Material._uniqueIDCounter;
			if (this._id > Material.maxMaterialCount)
				throw new Error("Material: Material count should not large than ",Material.maxMaterialCount);
			this._color[0]=Material.AMBIENTCOLORVALUE;
			this._color[1]=Material.DIFFUSECOLORVALUE;
			this._color[2]=Material.SPECULARCOLORVALUE;
			this._color[3]=Material.REFLECTCOLORVALUE;
			this._pushShaderValue(0,/*laya.webgl.utils.Buffer2D.MATERIALAMBIENT*/"MATERIALAMBIENT",this._color[0].elements,this._id);
			this._pushShaderValue(1,/*laya.webgl.utils.Buffer2D.MATERIALDIFFUSE*/"MATERIALDIFFUSE",this._color[1].elements,this._id);
			this._pushShaderValue(2,/*laya.webgl.utils.Buffer2D.MATERIALSPECULAR*/"MATERIALSPECULAR",this._color[2].elements,this._id);
			this._pushShaderValue(3,/*laya.webgl.utils.Buffer2D.MATERIALREFLECT*/"MATERIALREFLECT",this._color[3].elements,this._id);
			this._pushShaderValue(5,/*laya.webgl.utils.Buffer2D.LUMINANCE*/"LUMINANCE",this._luminance,this._id);
			this._getRenderQueue();
		}

		__class(Material,'laya.d3.core.material.Material',_super);
		var __proto=Material.prototype;
		__proto._getRenderQueue=function(){
			if (this._isSky){
				this._renderQueue=/*laya.d3.core.render.RenderQueue.NONEWRITEDEPTH*/0;
				}else {
				if (!this._transparent || (this._transparent && this._transparentMode===0))
					this._renderQueue=this._cullFace ? /*laya.d3.core.render.RenderQueue.OPAQUE*/1 :/*laya.d3.core.render.RenderQueue.OPAQUE_DOUBLEFACE*/2;
				else if (this._transparent && this._transparentMode===1){
					if (this._transparentAddtive)
						this._renderQueue=this._cullFace ? /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND*/9 :/*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE*/10;
					else
					this._renderQueue=this._cullFace ? /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND*/7 :/*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE*/8;
				}
			}
		}

		/**
		*@private
		*/
		__proto._loadeCompleted=function(){
			if (this._texturesloaded)
				return true;
			if (this.diffuseTexture && !this.diffuseTexture.loaded)
				return false;
			if (this.normalTexture && !this.normalTexture.loaded)
				return false;
			if (this.specularTexture && !this.specularTexture.loaded)
				return false;
			if (this.emissiveTexture && !this.emissiveTexture.loaded)
				return false;
			if (this.ambientTexture && !this.ambientTexture.loaded)
				return false;
			if (this.reflectTexture && !this.reflectTexture.loaded)
				return false;
			(this.diffuseTexture)&& this._uploadTexture(0,this.diffuseTexture);
			(this.normalTexture)&& (this._uploadTexture(1,this.normalTexture));
			(this.specularTexture)&& this._uploadTexture(2,this.specularTexture);
			(this.emissiveTexture)&& (this._uploadTexture(3,this.emissiveTexture));
			(this.ambientTexture)&& (this._uploadTexture(4,this.ambientTexture));
			(this.reflectTexture)&& (this._uploadTexture(5,this.reflectTexture));
			return this._texturesloaded=true;
		}

		/**
		*@private
		*获取材质的ShaderDefine。
		*@param shaderIndex 在ShaderValue队列中的索引。
		*@param name 名称。
		*@param value 值。
		*@param id 优化id。
		*@return 当前ShaderValue队列的索引。
		*/
		__proto._pushShaderValue=function(shaderIndex,name,value,id){
			var shaderValue=this._shaderValues;
			var index=this._otherSharderIndex[shaderIndex];
			if (!index){
				index=shaderValue.length+1;
				shaderValue.pushValue(name,null,-1);
				this._otherSharderIndex[shaderIndex]=index;
			}
			shaderValue.data[index][0]=value;
			shaderValue.data[index][1]=id;
			return index;
		}

		/**
		*@private
		*获取材质的ShaderDefine。
		*@return 材质的ShaderDefine。
		*/
		__proto._getShaderDefineValue=function(){
			this._shaderDef=0;
			this.diffuseTexture && (this._shaderDef |=/*laya.d3.shader.ShaderDefines3D.DIFFUSEMAP*/0x1);
			this.normalTexture && (this._shaderDef |=/*laya.d3.shader.ShaderDefines3D.NORMALMAP*/0x2);
			this.specularTexture && (this._shaderDef |=/*laya.d3.shader.ShaderDefines3D.SPECULARMAP*/0x4);
			this.emissiveTexture && (this._shaderDef |=/*laya.d3.shader.ShaderDefines3D.EMISSIVEMAP*/0x8);
			this.ambientTexture && (this._shaderDef |=/*laya.d3.shader.ShaderDefines3D.AMBIENTMAP*/0x10);
			this.reflectTexture && (this._shaderDef |=/*laya.d3.shader.ShaderDefines3D.REFLECTMAP*/0x40000);
			this._transformUV && (this._shaderDef |=/*laya.d3.shader.ShaderDefines3D.UVTRANSFORM*/0x4000);
			(this._transparent && this._transparentMode===0)&& (this._shaderDef |=/*laya.d3.shader.ShaderDefines3D.ALPHATEST*/0x800);
			return this._shaderDef;
		}

		/**
		*@private
		*/
		__proto._setTexture=function(value,shaderIndex,shaderValue){
			var index=this._texturesSharderIndex[shaderIndex];
			if (!index && value){
				index=this._shaderValues.length+1;
				this._shaderValues.pushValue(shaderValue,null,-1);
				this._texturesSharderIndex[shaderIndex]=index;
			}
			(value)&& (this._texturesloaded=false);
			this._textures[shaderIndex]=value;
			return index;
		}

		/**
		*@private
		*/
		__proto._uploadTexture=function(shaderIndex,texture){
			var shaderValue=this._shaderValues;
			var data=shaderValue.data[this._texturesSharderIndex[shaderIndex]];
			data[0]=texture.source;
			data[1]=texture.bitmap.id;
		}

		/**
		*通过索引获取纹理。
		*@param index 索引。
		*@return 纹理。
		*/
		__proto.getTextureByIndex=function(index){
			return this._textures[index];
		}

		/**
		*获取Shader。
		*@param state 相关渲染状态。
		*@return Shader。
		*/
		__proto.getShader=function(state){
			var shaderDefs=state.shaderDefs;
			var preDef=shaderDefs._value;
			this._disableDefine && (shaderDefs._value=preDef & (~this._disableDefine));
			var nameID=(shaderDefs._value | state.shadingMode)+this._sharderNameID */*laya.webgl.shader.Shader.SHADERNAME2ID*/0.0002;
			this._shader=Shader.withCompile(this._sharderNameID,state.shadingMode,shaderDefs.toNameDic(),nameID,null);
			shaderDefs._value=preDef;
			return this._shader;
		}

		/**
		*上传材质。
		*@param state 相关渲染状态。
		*@param bufferUsageShader Buffer相关绑定。
		*@param shader 着色器。
		*@return 是否成功。
		*/
		__proto.upload=function(state,bufferUsageShader,shader){
			if (!this._loadeCompleted())return false;
			shader || (shader=this.getShader(state));
			var shaderValue=this._shaderValues;
			var _presize=shaderValue.length;
			shaderValue.pushArray(state.shaderValue);
			if (shader.tag._uploadMaterialID !=Stat.loopCount){
				shader.tag._uploadMaterialID=Stat.loopCount;
				shaderValue.pushArray(state.worldShaderValue);
			}
			shader.uploadArray(shaderValue.data,shaderValue.length,bufferUsageShader);
			shaderValue.length=_presize;
			return true;
		}

		/**
		*禁用灯光。
		*/
		__proto.disableLight=function(){
			this._disableDefine |=/*laya.d3.shader.ShaderDefines3D.POINTLIGHT*/0x80 | /*laya.d3.shader.ShaderDefines3D.SPOTLIGHT*/0x100 | /*laya.d3.shader.ShaderDefines3D.DIRECTIONLIGHT*/0x40;
		}

		/**
		*禁用相关Define。
		*@param value 禁用值。
		*/
		__proto.disableDefine=function(value){
			this._disableDefine=value;
		}

		/**
		*设置使用Shader名字。
		*@param name 名称。
		*/
		__proto.setShaderName=function(name){
			this._sharderNameID=Shader.nameKey.get(name);
		}

		/**
		*复制材质
		*@param dec 目标材质
		*/
		__proto.copy=function(dec){
			dec._renderQueue=this._renderQueue;
			dec._sharderNameID=this._sharderNameID;
			dec._shader=this._shader;
			dec._texturesloaded=this._texturesloaded;
			dec._textures=this._textures;
			dec._texturesSharderIndex=this._texturesSharderIndex;
			dec._otherSharderIndex=this._otherSharderIndex;
			dec._disableDefine=this._disableDefine;
			dec._color=this._color;
			dec._transparent=this._transparent;
			dec._transparentMode=this._transparentMode;
			dec._alphaTestValue=this._alphaTestValue;
			dec.transparentAddtive=this.transparentAddtive;
			dec.cullFace=this.cullFace;
			dec._transformUV=this._transformUV;
			dec._luminance=this._luminance;
			dec._shaderDef=this._shaderDef;
			dec._isSky=this._isSky;
			dec.name=this.name;
			dec.loaded=this.loaded;
			this._shaderValues.copyTo(dec._shaderValues);
			return dec;;
		}

		/**
		*获取唯一标识ID(通常用于优化或识别)。
		*@return 唯一标识ID
		*/
		__getset(0,__proto,'id',function(){
			return this._id;
		});

		/**
		*获取所属渲染队列。
		*@return 渲染队列。
		*/
		__getset(0,__proto,'renderQueue',function(){
			return this._renderQueue;
		});

		/**
		*设置是否单面渲染。
		*@param 是否单面渲染。
		*/
		/**
		*获取是否单面渲染。
		*@return 是否单面渲染。
		*/
		__getset(0,__proto,'cullFace',function(){
			return this._cullFace;
			},function(value){
			if (this._cullFace!==value){
				this._cullFace=value;
				this._getRenderQueue();
			}
		});

		/**
		*设置是否天空。
		*@param 是否天空
		*/
		/**
		*获取是否天空。
		*@return 是否天空
		*/
		__getset(0,__proto,'isSky',function(){
			return this._isSky;
			},function(value){
			if (this._isSky!==value){
				this._isSky=value;
				this._getRenderQueue();
			}
		});

		/**
		*获取材质的ShaderDef。
		*@return 材质的ShaderDef。
		*/
		__getset(0,__proto,'shaderDef',function(){
			return this._shaderDef;
		});

		/**
		*设置是否透明。
		*@param value 是否透明。
		*/
		/**
		*获取是否透明。
		*@return 是否透明。
		*/
		__getset(0,__proto,'transparent',function(){
			return this._transparent;
			},function(value){
			if (this._transparent!==value){
				this._transparent=value;
				this.alphaTestValue=this._alphaTestValue;
				this._getShaderDefineValue();
				this._getRenderQueue();
			}
		});

		/**
		*设置透明测试模式裁剪值。
		*@param value 透明测试模式裁剪值。
		*/
		/**
		*获取透明测试模式裁剪值。
		*@return 透明测试模式裁剪值。
		*/
		__getset(0,__proto,'alphaTestValue',function(){
			return this._alphaTestValue;
			},function(value){
			this._alphaTestValue=value;
			this._pushShaderValue(7,/*laya.webgl.utils.Buffer2D.ALPHATESTVALUE*/"ALPHATESTVALUE",this._transparent && this._transparentMode===0 ? this._alphaTestValue :null,this._id);
		});

		/**
		*设置透明模式。
		*@param value 透明模式。
		*/
		/**
		*获取透明模式。
		*@return 透明模式。
		*/
		__getset(0,__proto,'transparentMode',function(){
			return this._transparentMode;
			},function(value){
			if (this._transparentMode!==value){
				this._transparentMode=value;
				this.alphaTestValue=this._alphaTestValue;
				this._getShaderDefineValue();
				this._getRenderQueue();
			}
		});

		/**
		*设置AlphaBlend模式下是否使用加色法。
		*@param AlphaBlend模式下是否使用加色法
		*/
		/**
		*获取AlphaBlend模式下是否使用加色法。
		*@return AlphaBlend模式下是否使用加色法
		*/
		__getset(0,__proto,'transparentAddtive',function(){
			return this._transparentAddtive;
			},function(value){
			if (this._transparentAddtive!==value){
				this._transparentAddtive=value;
				this._getRenderQueue();
			}
		});

		/**
		*设置漫反射贴图。
		*@param value 漫反射贴图。
		*/
		/**
		*获取漫反射贴图。
		*@return 漫反射贴图。
		*/
		__getset(0,__proto,'diffuseTexture',function(){
			return this._textures[0];
			},function(value){
			this._setTexture(value,0,/*laya.webgl.utils.Buffer2D.DIFFUSETEXTURE*/"DIFFUSETEXTURE");
			this._getShaderDefineValue();
		});

		/**
		*设置亮度。
		*@param value 亮度。
		*/
		__getset(0,__proto,'luminance',null,function(value){
			this._luminance=value;
			this._pushShaderValue(5,/*laya.webgl.utils.Buffer2D.LUMINANCE*/"LUMINANCE",this._luminance,this._id);
		});

		/**
		*设置法线贴图。
		*@param value 法线贴图。
		*/
		/**
		*获取法线贴图。
		*@return 法线贴图。
		*/
		__getset(0,__proto,'normalTexture',function(){
			return this._textures[1];
			},function(value){
			this._setTexture(value,1,/*laya.webgl.utils.Buffer2D.NORMALTEXTURE*/"NORMALTEXTURE");
			this._getShaderDefineValue();
		});

		/**
		*设置反射贴图。
		*@param value 反射贴图。
		*/
		/**
		*获取反射贴图。
		*@return 反射贴图。
		*/
		__getset(0,__proto,'reflectTexture',function(){
			return this._textures[5];
			},function(value){
			this._setTexture(value,5,/*laya.webgl.utils.Buffer2D.REFLECTTEXTURE*/"REFLECTTEXTURE");
			this._getShaderDefineValue();
		});

		/**
		*设置高光贴图。
		*@param value 高光贴图。
		*/
		/**
		*获取高光贴图。
		*@return 高光贴图。
		*/
		__getset(0,__proto,'specularTexture',function(){
			return this._textures[2];
			},function(value){
			this._setTexture(value,2,/*laya.webgl.utils.Buffer2D.SPECULARTEXTURE*/"SPECULARTEXTURE");
			this._getShaderDefineValue();
		});

		/**
		*设置放射贴图。
		*@param value 放射贴图。
		*/
		/**
		*获取放射贴图。
		*@return 放射贴图。
		*/
		__getset(0,__proto,'emissiveTexture',function(){
			return this._textures[3];
			},function(value){
			this._setTexture(value,3,/*laya.webgl.utils.Buffer2D.EMISSIVETEXTURE*/"EMISSIVETEXTURE");
			this._getShaderDefineValue();
		});

		/**
		*设置环境贴图。
		*@param value 环境贴图。
		*/
		/**
		*获取环境贴图。
		*@return 环境贴图。
		*/
		__getset(0,__proto,'ambientTexture',function(){
			return this._textures[4];
			},function(value){
			this._setTexture(value,4,/*laya.webgl.utils.Buffer2D.AMBIENTTEXTURE*/"AMBIENTTEXTURE");
			this._getShaderDefineValue();
		});

		/**
		*获取贴图数量。
		*@return 贴图数量。
		*/
		__getset(0,__proto,'texturesCount',function(){
			return this._textures.length;
		});

		/**
		*设置环境光颜色。
		*@param value 环境光颜色。
		*/
		__getset(0,__proto,'ambientColor',null,function(value){
			this._color[0]=value;
			this._pushShaderValue(0,/*laya.webgl.utils.Buffer2D.MATERIALAMBIENT*/"MATERIALAMBIENT",value.elements,this._id);
		});

		/**
		*设置漫反射光颜色。
		*@param value 漫反射光颜色。
		*/
		__getset(0,__proto,'diffuseColor',null,function(value){
			this._color[1]=value;
			this._pushShaderValue(1,/*laya.webgl.utils.Buffer2D.MATERIALDIFFUSE*/"MATERIALDIFFUSE",value.elements,this._id);
		});

		/**
		*设置高光颜色。
		*@param value 高光颜色。
		*/
		__getset(0,__proto,'specularColor',null,function(value){
			this._color[2]=value;
			this._pushShaderValue(2,/*laya.webgl.utils.Buffer2D.MATERIALSPECULAR*/"MATERIALSPECULAR",value.elements,this._id);
		});

		/**
		*设置反射颜色。
		*@param value 反射颜色。
		*/
		__getset(0,__proto,'reflectColor',null,function(value){
			this._color[3]=value;
			this._pushShaderValue(3,/*laya.webgl.utils.Buffer2D.MATERIALREFLECT*/"MATERIALREFLECT",value.elements,this._id);
		});

		/**
		*设置UV变换。
		*@param value UV变换。
		*/
		/**
		*获取UV变换。
		*@return UV变换。
		*/
		__getset(0,__proto,'transformUV',function(){
			return this._transformUV;
			},function(value){
			this._transformUV=value;
			var uvMat=this._transformUV.matrix;
			this._pushShaderValue(6,/*laya.webgl.utils.Buffer2D.MATRIX2*/"MATRIX2",uvMat.elements,this._id);
			this._getShaderDefineValue();
		});

		Material._uniqueIDCounter=1;
		Material.DIFFUSETEXTURE=0;
		Material.NORMALTEXTURE=1;
		Material.SPECULARTEXTURE=2;
		Material.EMISSIVETEXTURE=3;
		Material.AMBIENTTEXTURE=4;
		Material.REFLECTTEXTURE=5;
		Material.AMBIENTCOLOR=0;
		Material.DIFFUSECOLOR=1;
		Material.SPECULARCOLOR=2;
		Material.REFLECTCOLOR=3;
		Material.TRANSPARENT=4;
		Material.LUMINANCE=5;
		Material.TRANSFORMUV=6;
		Material.ALPHATESTVALUE=7;
		__static(Material,
		['maxMaterialCount',function(){return this.maxMaterialCount=Math.floor(2147483647 / /*laya.d3.graphics.VertexDeclaration._maxVertexDeclarationBit*/1000);},'AMBIENTCOLORVALUE',function(){return this.AMBIENTCOLORVALUE=new Vector3(0.6,0.6,0.6);},'DIFFUSECOLORVALUE',function(){return this.DIFFUSECOLORVALUE=new Vector3(1.0,1.0,1.0);},'SPECULARCOLORVALUE',function(){return this.SPECULARCOLORVALUE=new Vector4(1.0,1.0,1.0,8.0);},'REFLECTCOLORVALUE',function(){return this.REFLECTCOLORVALUE=new Vector3(1.0,1.0,1.0);}
		]);
		return Material;
	})(EventDispatcher)


	/**
	*<code>TransformUV</code> 类用于实现UV变换。
	*/
	//class laya.d3.core.TransformUV extends laya.events.EventDispatcher
	var TransformUV=(function(_super){
		function TransformUV(){
			this._rotation=0;
			this._matNeedUpdte=false;
			TransformUV.__super.call(this);
			this._tempTitlingV3=new Vector3();
			this._tempRotationMatrix=new Matrix4x4();
			this._tempTitlingMatrix=new Matrix4x4();
			this._matrix=new Matrix4x4();
			this._offset=new Vector2();
			this._tiling=new Vector2();
		}

		__class(TransformUV,'laya.d3.core.TransformUV',_super);
		var __proto=TransformUV.prototype;
		/**
		*@private
		*/
		__proto._updateMatrix=function(){
			this._tempTitlingV3.elements[0]=this._tiling.x;
			this._tempTitlingV3.elements[1]=this._tiling.y;
			this._tempTitlingV3.elements[2]=1;
			Matrix4x4.createScaling(this._tempTitlingV3,this._tempTitlingMatrix);
			Matrix4x4.createRotationZ(this._rotation,this._tempRotationMatrix);
			Matrix4x4.multiply(this._tempRotationMatrix,this._tempTitlingMatrix,this._matrix);
			var mate=this._matrix.elements;
			mate[12]=this._offset.x;
			mate[13]=this._offset.y;
			mate[14]=0;
		}

		/**
		*获取变换矩阵。
		*@return 变换矩阵。
		*/
		__getset(0,__proto,'matrix',function(){
			if (this._matNeedUpdte){
				this._updateMatrix();
				this._matNeedUpdte=false;
			}
			return this._matrix;
		});

		/**
		*设置偏移。
		*@param value 偏移。
		*/
		/**
		*获取偏移。
		*@return 偏移。
		*/
		__getset(0,__proto,'offset',function(){
			return this._offset;
			},function(value){
			this._offset=value;
			this._matNeedUpdte=true;
		});

		/**
		*设置旋转。
		*@param value 旋转。
		*/
		/**
		*获取旋转。
		*@return 旋转。
		*/
		__getset(0,__proto,'rotation',function(){
			return this._rotation;
			},function(value){
			this._rotation=value;
			this._matNeedUpdte=true;
		});

		/**
		*设置平铺次数。
		*@param value 平铺次数。
		*/
		/**
		*获取平铺次数。
		*@return 平铺次数。
		*/
		__getset(0,__proto,'tiling',function(){
			return this._tiling;
			},function(value){
			this._tiling=value;
			this._matNeedUpdte=true;
		});

		return TransformUV;
	})(EventDispatcher)


	/**
	*<code>EmitterBox</code> 类用于盒发射器。
	*/
	//class laya.d3.core.particle.EmitterBox extends laya.particle.emitter.EmitterBase
	var EmitterBox=(function(_super){
		function EmitterBox(particle3D){
			this._settings=null;
			this._particle3D=null;
			EmitterBox.__super.call(this);
			this._resultPosition=new Vector3();
			this._resultVelocity=new Vector3();
			this.centerPosition=new Vector3();
			this.size=new Vector3();
			this.velocity=new Vector3();
			this.velocityAddVariance=new Vector3();
			this._particle3D=particle3D;
			var setting=particle3D.templet.settings;
			for (var i=0;i < 3;i++){
				this.centerPosition.elements[i]=setting.boxEmitterCenterPosition[i];
				this.size.elements[i]=setting.boxEmitterSize[i];
				this.velocity.elements[i]=setting.boxEmitterVelocity[i];
				this.velocityAddVariance.elements[i]=setting.boxEmitterVelocityAddVariance[i];
			}
			this.emissionRate=setting.emissionRate;
		}

		__class(EmitterBox,'laya.d3.core.particle.EmitterBox',_super);
		var __proto=EmitterBox.prototype;
		/**
		*@private
		*/
		__proto._randomPositionOnBox=function(){
			var rpe=this._resultPosition.elements;
			var cpe=this.centerPosition.elements;
			var se=this.size.elements;
			rpe[0]=cpe[0]+se[0] *(Math.random()-0.5);
			rpe[1]=cpe[1]+se[1] *(Math.random()-0.5);
			rpe[2]=cpe[2]+se[2] *(Math.random()-0.5);
			return this._resultPosition;
		}

		/**
		*@private
		*/
		__proto._randomVelocityOnBox=function(){
			var rve=this._resultVelocity.elements;
			var ve=this.velocity.elements;
			var vve=this.velocityAddVariance.elements;
			rve[0]=ve[0]+vve[0] *Math.random();
			rve[1]=ve[1]+vve[1] *Math.random();
			rve[2]=ve[2]+vve[2] *Math.random();
			return this._resultVelocity;
		}

		/**
		*盒发射器发射函数。
		*/
		__proto.emit=function(){
			_super.prototype.emit.call(this);
			this._particle3D.templet.addParticle(this._randomPositionOnBox(),this._randomVelocityOnBox());
		}

		/**
		*更新盒粒子发射器。
		*@param state 渲染相关状态参数。
		*/
		__proto.update=function(state){
			this.advanceTime(state.elapsedTime / 1000);
		}

		return EmitterBox;
	})(EmitterBase)


	/**
	*<code>EmitterPoint</code> 类用于点发射器。
	*/
	//class laya.d3.core.particle.EmitterPoint extends laya.particle.emitter.EmitterBase
	var EmitterPoint=(function(_super){
		function EmitterPoint(particle3D){
			this._settings=null;
			this._particle3D=null;
			EmitterPoint.__super.call(this);
			this._resultPosition=new Vector3();
			this._resultVelocity=new Vector3();
			this.position=new Vector3();
			this.positionVariance=new Vector3();
			this.velocity=new Vector3();
			this.velocityAddVariance=new Vector3();
			this._particle3D=particle3D;
			var setting=particle3D.templet.settings;
			for (var i=0;i < 3;i++){
				this.position.elements[i]=setting.pointEmitterPosition[i];
				this.positionVariance.elements[i]=setting.pointEmitterPositionVariance[i];
				this.velocity.elements[i]=setting.pointEmitterVelocity[i];
				this.velocityAddVariance.elements[i]=setting.pointEmitterVelocityAddVariance[i];
			}
			this.emissionRate=setting.emissionRate;
		}

		__class(EmitterPoint,'laya.d3.core.particle.EmitterPoint',_super);
		var __proto=EmitterPoint.prototype;
		/**
		*@private
		*/
		__proto._randomPositionOnPoint=function(){
			var rpe=this._resultPosition.elements;
			var pe=this.position.elements;
			var pve=this.positionVariance.elements;
			rpe[0]=pe[0]+pve[0] *(Math.random()-0.5)*2;
			rpe[1]=pe[1]+pve[1] *(Math.random()-0.5)*2;
			rpe[2]=pe[2]+pve[2] *(Math.random()-0.5)*2;
			return this._resultPosition;
		}

		/**
		*@private
		*/
		__proto._randomVelocityOnPoint=function(){
			var rve=this._resultVelocity.elements;
			var ve=this.velocity.elements;
			var vve=this.velocityAddVariance.elements;
			rve[0]=ve[0]+vve[0] *Math.random();
			rve[1]=ve[1]+vve[1] *Math.random();
			rve[2]=ve[2]+vve[2] *Math.random();
			return this._resultVelocity;
		}

		/**
		*点发射器发射函数。
		*/
		__proto.emit=function(){
			_super.prototype.emit.call(this);
			this._particle3D.templet.addParticle(this._randomPositionOnPoint(),this._randomVelocityOnPoint());
		}

		/**
		*更新点粒子发射器。
		*@param state 渲染相关状态参数。
		*/
		__proto.update=function(state){
			this.advanceTime(state.elapsedTime / 1000);
		}

		return EmitterPoint;
	})(EmitterBase)


	/**
	*<code>EmitterRing</code> 类用于环发射器。
	*/
	//class laya.d3.core.particle.EmitterRing extends laya.particle.emitter.EmitterBase
	var EmitterRing=(function(_super){
		function EmitterRing(particle3D){
			this._settings=null;
			this._particle3D=null;
			this.radius=30;
			this.velocity=0;
			this.velocityAddVariance=0;
			this.up=2;
			EmitterRing.__super.call(this);
			this._resultPosition=new Vector3();
			this._resultVelocity=new Vector3();
			this._direction=new Vector3();
			this.centerPosition=new Vector3();
			this._particle3D=particle3D;
			var setting=particle3D.templet.settings;
			for (var i=0;i < 3;i++){
				this.centerPosition.elements[i]=setting.ringEmitterCenterPosition[i];
			}
			this.radius=setting.ringEmitterRadius
			this.velocity=setting.ringEmitterVelocity
			this.velocityAddVariance=setting.ringEmitterVelocityAddVariance
			this.emissionRate=setting.emissionRate;
		}

		__class(EmitterRing,'laya.d3.core.particle.EmitterRing',_super);
		var __proto=EmitterRing.prototype;
		/**
		*@private
		*/
		__proto._randomPointOnRing=function(){
			var angle=Math.random()*Math.PI *2;
			var x=Math.cos(angle);
			var y=Math.sin(angle);
			var rpe=this._resultPosition.elements;
			var cpe=this.centerPosition.elements;
			switch (this.up){
				case 0:
					rpe[0]=cpe[0]+0;
					rpe[1]=cpe[1]+x *this.radius;
					rpe[2]=cpe[2]+y *this.radius;
					break ;
				case 1:
					rpe[0]=cpe[0]+x *this.radius;
					rpe[1]=cpe[1]+0;
					rpe[2]=cpe[2]+y *this.radius;
					break ;
				case 2:
					rpe[0]=cpe[0]+x *this.radius;
					rpe[1]=cpe[1]+y *this.radius;
					rpe[2]=cpe[2]+0;
					break ;
				}
			return this._resultPosition;
		}

		/**
		*@private
		*/
		__proto._randomVelocityOnRing=function(){
			var rve=this._resultVelocity.elements;
			this._resultPosition.cloneTo(this._direction);
			Vector3.normalize(this._direction,this._direction);
			var de=this._direction.elements;
			rve[0]=de[0] *(this.velocity+this.velocityAddVariance *Math.random());
			rve[1]=de[1] *(this.velocity+this.velocityAddVariance *Math.random());
			rve[2]=de[2] *(this.velocity+this.velocityAddVariance *Math.random());
			return this._resultVelocity;
		}

		/**
		*环发射器发射函数。
		*/
		__proto.emit=function(){
			_super.prototype.emit.call(this);
			this._particle3D.templet.addParticle(this._randomPointOnRing(),this._randomVelocityOnRing());
		}

		/**
		*更新环粒子发射器。
		*@param state 渲染相关状态参数。
		*/
		__proto.update=function(elapsedTime){
			this.advanceTime(elapsedTime / 1000);
		}

		return EmitterRing;
	})(EmitterBase)


	/**
	*<code>EmitterSphere</code> 类用于球发射器。
	*/
	//class laya.d3.core.particle.EmitterSphere extends laya.particle.emitter.EmitterBase
	var EmitterSphere=(function(_super){
		function EmitterSphere(particle3D){
			this._settings=null;
			this._particle3D=null;
			this.radius=1;
			this.velocity=0;
			this.velocityAddVariance=0;
			EmitterSphere.__super.call(this);
			this._reultPosition=new Vector3();
			this._resultVelocity=new Vector3();
			this._direction=new Vector3();
			this.centerPosition=new Vector3();
			this._particle3D=particle3D;
			var setting=particle3D.templet.settings;
			for (var i=0;i < 3;i++){
				this.centerPosition.elements[i]=setting.sphereEmitterCenterPosition[i];
			}
			this.radius=setting.sphereEmitterRadius
			this.velocity=setting.sphereEmitterVelocity
			this.velocityAddVariance=setting.sphereEmitterVelocityAddVariance
			this.emissionRate=setting.emissionRate;
		}

		__class(EmitterSphere,'laya.d3.core.particle.EmitterSphere',_super);
		var __proto=EmitterSphere.prototype;
		/**
		*@private
		*/
		__proto._randomPositionOnSphere=function(){
			var angleVer=Math.random()*Math.PI *2;
			var angleHor=Math.random()*Math.PI *2;
			var r=Math.cos(angleVer)*this.radius;
			var y=Math.sin(angleVer)*this.radius;
			var x=Math.cos(angleHor)*r;
			var z=Math.sin(angleHor)*r;
			var rpe=this._reultPosition.elements;
			var cpe=this.centerPosition.elements;
			rpe[0]=cpe[0]+x;
			rpe[1]=cpe[1]+y;
			rpe[2]=cpe[2]+z;
			return this._reultPosition;
		}

		/**
		*@private
		*/
		__proto._randomVelocityOnSphere=function(){
			var rve=this._resultVelocity.elements;
			this._reultPosition.cloneTo(this._direction);
			Vector3.normalize(this._direction,this._direction);
			var de=this._direction.elements;
			rve[0]=de[0] *(this.velocity+this.velocityAddVariance *Math.random());
			rve[1]=de[1] *(this.velocity+this.velocityAddVariance *Math.random());
			rve[2]=de[2] *(this.velocity+this.velocityAddVariance *Math.random());
			return this._resultVelocity;
		}

		/**
		*球发射器发射函数。
		*/
		__proto.emit=function(){
			_super.prototype.emit.call(this);
			this._particle3D.templet.addParticle(this._randomPositionOnSphere(),this._randomVelocityOnSphere());
		}

		/**
		*更新球粒子发射器。
		*@param state 渲染相关状态参数。
		*/
		__proto.update=function(state){
			this.advanceTime(state.elapsedTime / 1000);
		}

		return EmitterSphere;
	})(EmitterBase)


	/**
	*<code>SplineCurvePosition</code> 类用于通过顶点创建闪光插值。
	*/
	//class laya.d3.core.glitter.SplineCurvePosition extends laya.d3.core.glitter.SplineCurvePositionVelocity
	var SplineCurvePosition=(function(_super){
		/**
		*创建一个 <code>SplineCurvePosition</code> 实例。
		*/
		function SplineCurvePosition(){
			SplineCurvePosition.__super.call(this);
		}

		__class(SplineCurvePosition,'laya.d3.core.glitter.SplineCurvePosition',_super);
		var __proto=SplineCurvePosition.prototype;
		/**
		*@private
		*计算速度。
		*/
		__proto._CalcVelocity=function(left,right,out){
			Vector3.subtract(left,right,out);
			Vector3.scale(out,0.5,out);
		}

		/**
		*初始化插值所需信息。
		*@param lastPosition0 顶点0的上次位置。
		*@param position0 顶点0的位置。
		*@param lastPosition1 顶点1的上次位置。
		*@param position1 顶点1的位置。
		*/
		__proto.Init=function(lastPosition0,position0,lastPosition1,position1){
			this._CalcVelocity(position0,lastPosition0,this._tempVector30);
			this._CalcVelocity(position1,lastPosition1,this._tempVector31);
			_super.prototype.Init.call(this,position0,this._tempVector30,position1,this._tempVector31);
		}

		return SplineCurvePosition;
	})(SplineCurvePositionVelocity)


	/**
	*@private
	*<code>ShaderDefines3D</code> 类用于创建3DshaderDefine相关。
	*/
	//class laya.d3.shader.ShaderDefines3D extends laya.webgl.shader.ShaderDefines
	var ShaderDefines3D=(function(_super){
		function ShaderDefines3D(){
			ShaderDefines3D.__super.call(this,ShaderDefines3D._name2int,ShaderDefines3D._int2name,ShaderDefines3D._int2nameMap);
		}

		__class(ShaderDefines3D,'laya.d3.shader.ShaderDefines3D',_super);
		ShaderDefines3D.__init__=function(){
			ShaderDefines3D.reg("FSHIGHPRECISION",0x100000);
			ShaderDefines3D.reg("DIFFUSEMAP",0x1);
			ShaderDefines3D.reg("NORMALMAP",0x2);
			ShaderDefines3D.reg("SPECULARMAP",0x4);
			ShaderDefines3D.reg("EMISSIVEMAP",0x8);
			ShaderDefines3D.reg("AMBIENTMAP",0x10);
			ShaderDefines3D.reg("REFLECTMAP",0x40000);
			ShaderDefines3D.reg("PARTICLE3D",0x8000);
			ShaderDefines3D.reg("COLOR",0x20);
			ShaderDefines3D.reg("VERTEXSHADERING",0x1000);
			ShaderDefines3D.reg("PIXELSHADERING",0x2000);
			ShaderDefines3D.reg("SKINNED",0x400);
			ShaderDefines3D.reg("DIRECTIONLIGHT",0x40);
			ShaderDefines3D.reg("POINTLIGHT",0x80);
			ShaderDefines3D.reg("SPOTLIGHT",0x100);
			ShaderDefines3D.reg("BONE",0x200);
			ShaderDefines3D.reg("ALPHATEST",0x800);
			ShaderDefines3D.reg("UVTRANSFORM",0x4000);
			ShaderDefines3D.reg("MIXUV",0x10000);
			ShaderDefines3D.reg("FOG",0x20000);
			ShaderDefines3D.reg("VR",0x80000);
		}

		ShaderDefines3D.reg=function(name,value){
			ShaderDefines._reg(name,value,ShaderDefines3D._name2int,ShaderDefines3D._int2name);
		}

		ShaderDefines3D.toText=function(value,_int2name,_int2nameMap){
			return ShaderDefines._toText(value,_int2name,_int2nameMap);
		}

		ShaderDefines3D.toInt=function(names){
			return ShaderDefines._toInt(names,ShaderDefines3D._name2int);
		}

		ShaderDefines3D.DIFFUSEMAP=0x1;
		ShaderDefines3D.NORMALMAP=0x2;
		ShaderDefines3D.SPECULARMAP=0x4;
		ShaderDefines3D.EMISSIVEMAP=0x8;
		ShaderDefines3D.AMBIENTMAP=0x10;
		ShaderDefines3D.REFLECTMAP=0x40000;
		ShaderDefines3D.VR=0x80000;
		ShaderDefines3D.FSHIGHPRECISION=0x100000;
		ShaderDefines3D.UVTRANSFORM=0x4000;
		ShaderDefines3D.MIXUV=0x10000;
		ShaderDefines3D.FOG=0x20000;
		ShaderDefines3D.COLOR=0x20;
		ShaderDefines3D.DIRECTIONLIGHT=0x40;
		ShaderDefines3D.POINTLIGHT=0x80;
		ShaderDefines3D.SPOTLIGHT=0x100;
		ShaderDefines3D.BONE=0x200;
		ShaderDefines3D.SKINNED=0x400;
		ShaderDefines3D.ALPHATEST=0x800;
		ShaderDefines3D.PARTICLE3D=0x8000;
		ShaderDefines3D.VERTEXSHADERING=0x1000;
		ShaderDefines3D.PIXELSHADERING=0x2000;
		ShaderDefines3D._name2int={};
		ShaderDefines3D._int2name=[];
		ShaderDefines3D._int2nameMap=[];
		return ShaderDefines3D;
	})(ShaderDefines)


	/**
	*<code>Sprite3D</code> 类用于实现3D精灵。
	*/
	//class laya.d3.core.Sprite3D extends laya.display.Node
	var Sprite3D=(function(_super){
		function Sprite3D(name){
			this._id=0;
			this._enable=false;
			this._layerMask=0;
			this._componentsMap=[];
			this.transform=null;
			this.isStatic=false;
			Sprite3D.__super.call(this);
			this._components=[];
			this._wvpMatrix=new Matrix4x4();
			var _$this=this;
			(name)? (this.name=name):(this.name="Sprite3D-"+Sprite3D._nameNumberCounter++);
			this._enable=true;
			this._id=Sprite3D._uniqueIDCounter;
			Sprite3D._uniqueIDCounter++;
			this.layer=Layer.currentCreationLayer;
			this.transform=new Transform3D(this);
			this.on(/*laya.events.Event.ADDED*/"added",this,function(){
				_$this.transform._parent=(_$this._parent).transform;
			});
			this.on(/*laya.events.Event.REMOVED*/"removed",this,function(){
				_$this.transform._parent=null;
			});
		}

		__class(Sprite3D,'laya.d3.core.Sprite3D',_super);
		var __proto=Sprite3D.prototype;
		Laya.imps(__proto,{"laya.d3.core.render.IUpdate":true})
		/**
		*清理自身渲染物体。
		*/
		__proto._clearSelfRenderObjects=function(){}
		/**
		*清理自身和子节点渲染物体,重写此函数。
		*/
		__proto._clearSelfAndChildrenRenderObjects=function(){
			this._clearSelfRenderObjects();
			for (var i=0;i < this._childs.length;i++)
			(this._childs [i])._clearSelfAndChildrenRenderObjects();
		}

		/**
		*更新组件update函数。
		*@param state 渲染相关状态。
		*/
		__proto._updateComponents=function(state){
			for (var i=0;i < this._components.length;i++){
				var component=this._components[i];
				(!component.started)&& (component._start(state),component.started=true);
				(component.isActive)&& (component._update(state));
			}
		}

		/**
		*更新组件lateUpdate函数。
		*@param state 渲染相关状态。
		*/
		__proto._lateUpdateComponents=function(state){
			for (var i=0;i < this._components.length;i++){
				var component=this._components[i];
				(!component.started)&& (component._start(state),component.started=true);
				(component.isActive)&& (component._lateUpdate(state));
			}
		}

		/**
		*更新子节点。
		*@param state 渲染相关状态。
		*/
		__proto._updateChilds=function(state){
			var n=this._childs.length;
			if (n===0)return;
			for (var i=0;i < n;++i){
				var child=this._childs[i];
				child._update((state));
			}
		}

		/**
		*排序函数。
		*@param state 渲染相关状态。
		*/
		__proto._getSortID=function(renderElement,material){
			return material.id */*laya.d3.graphics.VertexDeclaration._maxVertexDeclarationBit*/1000+renderElement.getVertexBuffer().vertexDeclaration.id;
		}

		/**
		*更新
		*@param state 渲染相关状态
		*/
		__proto._update=function(state){
			state.owner=this;
			var preTransformID=state.worldTransformModifyID;
			var canView=state.renderClip.view(this);
			(canView)&& (this._updateComponents(state));
			state.worldTransformModifyID+=this.transform._worldTransformModifyID;
			this.transform.getWorldMatrix(state.worldTransformModifyID);
			(canView)&& (this._lateUpdateComponents(state));
			this._childs.length && this._updateChilds(state);
			state.worldTransformModifyID=preTransformID;
		}

		__proto.removeChildAt=function(index){
			var node=this.getChildAt(index);
			if (node){
				this._childs.splice(index,1);
				this.model && this.model.removeChild(node.model);
				node.parent=null;
				(node)._clearSelfAndChildrenRenderObjects();
			}
			return node;
		}

		/**
		*添加指定类型组件。
		*@param type 组件类型。
		*@return 组件。
		*/
		__proto.addComponent=function(type){
			if (!(this._componentsMap[type]===undefined))
				throw new Error("无法创建"+type+"组件"+"，"+type+"组件已存在！");
			var component=ClassUtils.getInstance(type);
			component._initialize(this);
			this._componentsMap[type]=this._components.length;
			this._components.push(component);
			this.event(/*laya.events.Event.COMPONENT_ADDED*/"componentadded",component);
			return component;
		}

		/**
		*获得指定类型组件。
		*@param type 组件类型。
		*@return 组件。
		*/
		__proto.getComponentByType=function(type){
			if (this._componentsMap[type]===undefined)
				return null;
			return this._components[this._componentsMap[type]];
		}

		/**
		*获得指定类型组件。
		*@param type 组件类型。
		*@return 组件。
		*/
		__proto.getComponentByIndex=function(index){
			return this._components[index];
		}

		/**
		*移除指定类型组件。
		*@param type 组件类型。
		*/
		__proto.removeComponent=function(type){
			if (this._componentsMap[type]===undefined)
				return;
			var component=this._components[this._componentsMap[type]];
			this._components.splice(this._componentsMap[type],1);
			delete this._componentsMap[type];
			this.event(/*laya.events.Event.COMPONENT_REMOVED*/"componentremoved",component);
		}

		/**
		*移除全部组件。
		*/
		__proto.removeAllComponent=function(){
			for (var component in this._componentsMap)
			this.removeComponent(component);
		}

		/**
		*加载场景文件。
		*@param url 地址。
		*/
		__proto.loadHierarchy=function(url){
			var _$this=this;
			if (url===null)return;
			var loader=new Loader();
			var _this=this;
			url=URL.formatURL(url);
			var onComp=function (data){
				var preBasePath=URL.basePath;
				URL.basePath=URL.getPath(URL.formatURL(url));
				_$this.addChild(ClassUtils.createByJson(data,null,_this,Handler.create(null,Utils3D._parseHierarchyProp,null,false),Handler.create(null,Utils3D._parseHierarchyNode,null,false)));
				URL.basePath=preBasePath;
				_$this.event(/*laya.events.Event.HIERARCHY_LOADED*/"hierarchyloaded",_this);
			}
			loader.once(/*laya.events.Event.COMPLETE*/"complete",null,onComp);
			loader.load(url,/*laya.net.Loader.TEXT*/"text");
		}

		/**
		*获取唯一标识ID。
		*@return 唯一标识ID。
		*/
		__getset(0,__proto,'id',function(){
			return this._id;
		});

		/**
		*设置是否启用。
		*@param value 是否启动。
		*/
		/**
		*获取是否启用。
		*@return 是否激活。
		*/
		__getset(0,__proto,'enable',function(){
			return this._enable;
			},function(value){
			this._enable=value;
			this.event(/*laya.events.Event.ENABLED_CHANGED*/"enabledchanged",this._enable);
		});

		/**
		*获得WorldViewProjection矩阵。
		*@return 矩阵。
		*/
		__getset(0,__proto,'wvpMatrix',function(){
			return this._wvpMatrix;
		});

		/**
		*获取是否激活。
		*@return 是否激活。
		*/
		__getset(0,__proto,'active',function(){
			return Layer.isActive(this._layerMask)&& this._enable;
		});

		/**
		*获取是否显示。
		*@return 是否显示。
		*/
		__getset(0,__proto,'visible',function(){
			return Layer.isVisible(this._layerMask)&& this._enable;
		});

		/**
		*设置蒙版。
		*@param value 蒙版。
		*/
		/**
		*获取蒙版。
		*@return 蒙版。
		*/
		__getset(0,__proto,'layer',function(){
			return Layer.getLayerByMask(this._layerMask);
			},function(value){
			this._layerMask=value.mask;
			this.event(/*laya.events.Event.LAYER_CHANGED*/"layerchanged",this._layerMask);
		});

		/**
		*获得组件的数量。
		*@return 组件数量。
		*/
		__getset(0,__proto,'componentsCount',function(){
			return this._components.length;
		});

		/**
		*获得所属场景。
		*@return 场景。
		*/
		__getset(0,__proto,'scene',function(){
			return (this.parent).scene;
		});

		Sprite3D._uniqueIDCounter=1;
		Sprite3D._nameNumberCounter=0;
		return Sprite3D;
	})(Node)


	/**
	*<code>BaseMesh</code> 类用于创建网格,抽象类,不允许实例。
	*/
	//class laya.d3.resource.models.BaseMesh extends laya.resource.Resource
	var BaseMesh=(function(_super){
		function BaseMesh(){
			this._subMeshCount=0;
			this._boundingBox=null;
			this._boundingSphere=null;
			BaseMesh.__super.call(this);
			this._boundingBox=new BoundBox(new Vector3(),new Vector3());
			this._boundingSphere=new BoundSphere(new Vector3(),0);
		}

		__class(BaseMesh,'laya.d3.resource.models.BaseMesh',_super);
		var __proto=BaseMesh.prototype;
		/**
		*获取渲染单元,请重载此方法。
		*@param index 索引。
		*@return 渲染单元。
		*/
		__proto.getRenderElement=function(index){
			throw new Error("未Override,请重载该属性！");
		}

		/**
		*获取渲染单元数量,请重载此方法。
		*@return 渲染单元数量。
		*/
		__proto.getRenderElementsCount=function(){
			throw new Error("未Override,请重载该属性！");
		}

		/**@private 待开放。*/
		__proto.Render=function(){
			throw new Error("未Override,请重载该方法！");
		}

		/**@private 待开放。*/
		__proto.RenderSubMesh=function(subMeshIndex){
			throw new Error("未Override,请重载该方法！");
		}

		/**
		*获取SubMesh的个数。
		*@return SubMesh的个数。
		*/
		__getset(0,__proto,'subMeshCount',function(){
			return this._subMeshCount;
		});

		/**
		*获取包围盒。
		*@return 包围盒。
		*/
		__getset(0,__proto,'boundingBox',function(){
			return this._boundingBox;
		});

		/**
		*获取包围球。
		*@return 包围球。
		*/
		__getset(0,__proto,'boundingSphere',function(){
			return this._boundingSphere;
		});

		/**
		*获取网格顶点,请重载此方法。
		*@return 网格顶点。
		*/
		__getset(0,__proto,'positions',function(){
			throw new Error("未Override,请重载该属性！");
		});

		return BaseMesh;
	})(Resource)


	/**
	*<code>RenderTarget</code> 类用于创建渲染目标。
	*/
	//class laya.d3.resource.RenderTarget extends laya.resource.Texture
	var RenderTarget=(function(_super){
		function RenderTarget(width,height,surfaceFormat,surfaceType,depthStencilFormat,mipMap,repeat,minFifter,magFifter){
			this._alreadyResolved=false;
			this._looked=false;
			this._surfaceFormat=0;
			this._surfaceType=0;
			this._depthStencilFormat=0;
			this._mipMap=false;
			this._repeat=false;
			this._minFifter=0;
			this._magFifter=0;
			this._size=null;
			RenderTarget.__super.call(this);
			(surfaceFormat===void 0)&& (surfaceFormat=/*laya.webgl.WebGLContext.RGBA*/0x1908);
			(surfaceType===void 0)&& (surfaceType=/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401);
			(depthStencilFormat===void 0)&& (depthStencilFormat=/*laya.webgl.WebGLContext.DEPTH_COMPONENT16*/0x81A5);
			(mipMap===void 0)&& (mipMap=false);
			(repeat===void 0)&& (repeat=false);
			(minFifter===void 0)&& (minFifter=-1);
			(magFifter===void 0)&& (magFifter=-1);
			this._w=width;
			this._h=height;
			this._surfaceFormat=surfaceFormat;
			this._surfaceType=surfaceType;
			this._depthStencilFormat=depthStencilFormat;
			this._mipMap=mipMap;
			this._repeat=repeat;
			this._minFifter=minFifter;
			this._magFifter=magFifter;
			this._size=new Size(width,height);
			this._createWebGLRenderTarget();
			this.bitmap.lock=true;
		}

		__class(RenderTarget,'laya.d3.resource.RenderTarget',_super);
		var __proto=RenderTarget.prototype;
		Laya.imps(__proto,{"laya.resource.IDispose":true})
		/**@private */
		__proto._createWebGLRenderTarget=function(){
			this.bitmap=new WebGLRenderTarget(this.width,this.height,this._surfaceFormat,this._surfaceType,this._depthStencilFormat,this._mipMap,this._repeat,this._minFifter,this._magFifter);
			this.bitmap.activeResource();
			this._alreadyResolved=true;
		}

		/**
		*开始绑定。
		*/
		__proto.start=function(){
			var gl=WebGL.mainContext;
			gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,(this.bitmap).frameBuffer);
			RenderTarget._currentRenderTarget=this;
			this._alreadyResolved=false;
			RenderTarget._currentRenderTarget=this;
		}

		/**
		*清理并着色。
		*/
		__proto.clear=function(r,g,b,a){
			(r===void 0)&& (r=0.0);
			(g===void 0)&& (g=0.0);
			(b===void 0)&& (b=0.0);
			(a===void 0)&& (a=1.0);
			var gl=WebGL.mainContext;
			gl.clearColor(r,g,b,a);
			var clearFlag=/*laya.webgl.WebGLContext.COLOR_BUFFER_BIT*/0x00004000;
			switch (this._depthStencilFormat){
				case /*laya.webgl.WebGLContext.DEPTH_COMPONENT16*/0x81A5:
					clearFlag |=/*laya.webgl.WebGLContext.DEPTH_BUFFER_BIT*/0x00000100;
					break ;
				case /*laya.webgl.WebGLContext.STENCIL_INDEX8*/0x8D48:
					clearFlag |=/*laya.webgl.WebGLContext.STENCIL_BUFFER_BIT*/0x00000400;
					break ;
				case /*laya.webgl.WebGLContext.DEPTH_STENCIL*/0x84F9:
					clearFlag |=/*laya.webgl.WebGLContext.DEPTH_BUFFER_BIT*/0x00000100;
					clearFlag |=/*laya.webgl.WebGLContext.STENCIL_BUFFER_BIT*/0x00000400
					break ;
				}
			gl.clear(clearFlag);
		}

		/**
		*结束绑定。
		*/
		__proto.end=function(){
			var gl=WebGL.mainContext;
			gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,null);
			RenderTarget._currentRenderTarget=null;
			this._alreadyResolved=true;
		}

		/**
		*获得像素数据。
		*@param x X像素坐标。
		*@param y Y像素坐标。
		*@param width 宽度。
		*@param height 高度。
		*@return 像素数据。
		*/
		__proto.getData=function(x,y,width,height){
			var gl=WebGL.mainContext;
			gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,(this.bitmap).frameBuffer);
			var canRead=(gl.checkFramebufferStatus(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40)===/*laya.webgl.WebGLContext.FRAMEBUFFER_COMPLETE*/0x8CD5);
			if (!canRead){
				gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,null);
				return null;
			};
			var pixels=new Uint8Array(this._w *this._h *4);
			gl.readPixels(x,y,width,height,this._surfaceFormat,this._surfaceType,pixels);
			gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,null);
			return pixels;
		}

		/**
		*彻底清理资源,注意会强制解锁清理
		*/
		__proto.dispose=function(){
			this.bitmap.dispose();
		}

		__getset(0,__proto,'size',function(){
			return this._size;
		});

		/**
		*获取表面格式。
		*@return 表面格式。
		*/
		__getset(0,__proto,'surfaceFormat',function(){
			return this._surfaceFormat;
		});

		//}
		__getset(0,__proto,'minFifter',function(){
			return this._minFifter;
		});

		/**
		*获取表面类型。
		*@return 表面类型。
		*/
		__getset(0,__proto,'surfaceType',function(){
			return this._surfaceType;
		});

		/**
		*获取深度格式。
		*@return 深度格式。
		*/
		__getset(0,__proto,'depthStencilFormat',function(){
			return this._depthStencilFormat;
		});

		/**
		*获取是否为多级纹理。
		*@return 是否为多级纹理。
		*/
		__getset(0,__proto,'mipMap',function(){
			return this._mipMap;
		});

		__getset(0,__proto,'magFifter',function(){
			return this._magFifter;
		});

		/**
		*获取RenderTarget数据源。
		*@return RenderTarget数据源。
		*/
		__getset(0,__proto,'source',function(){
			if (this._alreadyResolved)
				return _super.prototype._$get_source.call(this);
			throw new Error("RenderTarget  还未准备好！");
		});

		RenderTarget._currentRenderTarget=null
		return RenderTarget;
	})(Texture)


	/**
	*<code>KeyframeAnimation</code> 类用于帧动画组件的父类。
	*/
	//class laya.d3.component.animation.KeyframeAnimations extends laya.d3.component.Component3D
	var KeyframeAnimations=(function(_super){
		function KeyframeAnimations(){
			this._url=null;
			this._templet=null;
			this.player=null;
			KeyframeAnimations.__super.call(this);
			this.player=new AnimationPlayer();
		}

		__class(KeyframeAnimations,'laya.d3.component.animation.KeyframeAnimations',_super);
		var __proto=KeyframeAnimations.prototype;
		/**
		*播放动画。
		*@param index 动画索引。
		*@param playbackRate 播放速率。
		*@param duration 播放时长（Number.MAX_VALUE为循环播放，0为1次）。
		*/
		__proto.play=function(index,playbackRate,duration){
			(index===void 0)&& (index=0);
			(playbackRate===void 0)&& (playbackRate=1.0);
			(duration===void 0)&& (duration=Number.MAX_VALUE);
			this.player.play(index,playbackRate,duration);
		}

		/**
		*停止播放当前动画
		*@param immediate 是否立即停止
		*/
		__proto.stop=function(immediate){
			(immediate===void 0)&& (immediate=true);
			this.player.stop(immediate);
		}

		/**
		*设置url地址。
		*@param value 地址。
		*/
		/**
		*获取url地址。
		*@return 地址。
		*/
		__getset(0,__proto,'url',function(){
			return this._url;
			},function(value){
			var _$this=this;
			if (this.player.State!==/*laya.ani.AnimationState.stopped*/0)
				this.player.stop(true);
			this._url=URL.formatURL(value);
			var templet=Resource.animationCache[this._url];
			var _this=this;
			if (!templet){
				templet=Resource.animationCache[this._url]=new KeyframesAniTemplet();
				this._templet=templet;
				this.player.templet=templet;
				var onComp=function (data){
					var arraybuffer=data;
					templet.parse(arraybuffer,_$this.player.cacheFrameRate);
				};
				var loader=new Loader();
				loader.once(/*laya.events.Event.COMPLETE*/"complete",null,onComp);
				loader.load(this._url,/*laya.net.Loader.BUFFER*/"arraybuffer");
				}else {
				this._templet=templet;
				this.player.templet=templet
			}
			if (!templet.loaded)
				templet.once(/*laya.events.Event.LOADED*/"loaded",null,function(e){_this.event(/*laya.events.Event.LOADED*/"loaded",_this)
			});
			else
			this.event(/*laya.events.Event.LOADED*/"loaded",this);
		});

		/**
		*获取播放器帧率。
		*@return 播放器帧率。
		*/
		__getset(0,__proto,'currentFrameIndex',function(){
			return this.player.currentKeyframeIndex;
		});

		/**
		*获取播放器当前动画的节点数量。
		*@return 节点数量。
		*/
		__getset(0,__proto,'NodeCount',function(){
			return this._templet.getNodeCount(this.player.currentAnimationClipIndex);
		});

		/**
		*获取播放器的动画索引。
		*@return 动画索引。
		*/
		__getset(0,__proto,'currentAnimationClipIndex',function(){
			return this.player.currentAnimationClipIndex;
		});

		/**
		*设置播放器是否暂停。
		*@param value 是否暂停。
		*/
		/**
		*获取播放器是否暂停。
		*@return 是否暂停。
		*/
		__getset(0,__proto,'paused',function(){
			return this.player.paused;
			},function(value){
			this.player.paused=value;
		});

		/**
		*获取播放器的缓存帧率。
		*@return 缓存帧率。
		*/
		__getset(0,__proto,'cacheFrameRate',function(){
			return this.player.cacheFrameRate;
		});

		return KeyframeAnimations;
	})(Component3D)


	/**
	*<code>AttachPoint</code> 类用于创建挂点组件。
	*/
	//class laya.d3.component.AttachPoint extends laya.d3.component.Component3D
	var AttachPoint=(function(_super){
		function AttachPoint(){
			this._attachSkeleton=null;
			this._data=null;
			this._extenData=null;
			this.attachBones=null;
			this.matrixs=null;
			AttachPoint.__super.call(this);
			this.attachBones=[];
			this.matrixs=[];
		}

		__class(AttachPoint,'laya.d3.component.AttachPoint',_super);
		var __proto=AttachPoint.prototype;
		/**
		*@private
		*初始化载入挂点组件。
		*@param owner 所属精灵对象。
		*/
		__proto._load=function(owner){
			_super.prototype._load.call(this,owner);
			this._attachSkeleton=owner.getComponentByType(SkinAnimations);
		}

		/**
		*@private
		*更新挂点组件。
		*@param state 渲染状态。
		*/
		__proto._update=function(state){
			var player=this._attachSkeleton.player;
			var skeletonTemplet=this._attachSkeleton._templet;
			if (!this._attachSkeleton || player.State!==/*laya.ani.AnimationState.playing*/2 || !skeletonTemplet || !skeletonTemplet.loaded)
				return;
			this.matrixs.length=this.attachBones.length;
			for (var i=0;i < this.attachBones.length;i++){
				var index=skeletonTemplet.getNodeIndexWithName(player.currentAnimationClipIndex,this.attachBones[i]);
				this._data=this._attachSkeleton.curBonesDatas.subarray(index *16,(index+1)*16);
				var matrix=this.matrixs[i];
				matrix || (matrix=this.matrixs[i]=new Matrix4x4());
				matrix.copyFromArray(this._data);
				Matrix4x4.multiply(this.owner.transform.worldMatrix,matrix,matrix);
			}
		}

		return AttachPoint;
	})(Component3D)


	/**
	*<code>Script</code> 类用于创建脚本的父类。
	*/
	//class laya.d3.component.Script extends laya.d3.component.Component3D
	var Script=(function(_super){
		/**
		*创建一个新的 <code>Script</code> 实例。
		*/
		function Script(){
			Script.__super.call(this);
		}

		__class(Script,'laya.d3.component.Script',_super);
		return Script;
	})(Component3D)


	/**
	*@private
	*<code>ParticleTemplet3D</code> 类用于创建3D粒子数据模板。
	*/
	//class laya.d3.resource.tempelet.ParticleTemplet3D extends laya.particle.ParticleTemplateWebGL
	var ParticleTemplet3D=(function(_super){
		function ParticleTemplet3D(parSetting){
			this._vertexBuffer3D=null;
			this._indexBuffer3D=null;
			this._sharderNameID=0;
			this._shader=null;
			this._shaderValue=new ValusArray();
			ParticleTemplet3D.__super.call(this,parSetting);
			this.initialize();
			this.loadShaderParams();
			this._vertexBuffer=this._vertexBuffer3D=VertexBuffer3D.create(VertexParticle.vertexDeclaration,parSetting.maxPartices *4,/*laya.webgl.WebGLContext.DYNAMIC_DRAW*/0x88E8);
			this._indexBuffer=this._indexBuffer3D=IndexBuffer3D.create(/*laya.d3.graphics.IndexBuffer3D.INDEXTYPE_USHORT*/"ushort",parSetting.maxPartices *6,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4,true);
			this.loadContent();
		}

		__class(ParticleTemplet3D,'laya.d3.resource.tempelet.ParticleTemplet3D',_super);
		var __proto=ParticleTemplet3D.prototype;
		Laya.imps(__proto,{"laya.d3.core.render.IRenderable":true})
		__proto.getBakedVertexs=function(index,transform){
			return null;
		}

		__proto.getBakedIndices=function(){
			return null;
		}

		__proto.getVertexBuffer=function(index){
			(index===void 0)&& (index=0);
			if (index===0)
				return this._vertexBuffer3D;
			else
			return null;
		}

		__proto.getIndexBuffer=function(){
			return this._indexBuffer3D;
		}

		__proto.loadShaderParams=function(){
			this._sharderNameID=Shader.nameKey.get("PARTICLE");
			if (this.settings.textureName){
				this.texture=new Texture();
				this._shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.DIFFUSETEXTURE*/"DIFFUSETEXTURE",null,-1);
				var _this=this;
				Laya.loader.load(this.settings.textureName,Handler.create(null,function(texture){
					(texture.bitmap).enableMerageInAtlas=false;
					(texture.bitmap).mipmap=true;
					(texture.bitmap).repeat=true;
					_this.texture=texture;
				}));
			}
			this._shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.DURATION*/"DURATION",this.settings.duration,-1);
			this._shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.GRAVITY*/"GRAVITY",this.settings.gravity,-1);
			this._shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.ENDVELOCITY*/"ENDVELOCITY",this.settings.endVelocity,-1);
		}

		__proto.addParticle=function(position,velocity){
			this.addParticleArray(position.elements,velocity.elements);
		}

		__proto.loadContent=function(){
			var indexes=new Uint16Array(this.settings.maxPartices *6);
			for (var i=0;i < this.settings.maxPartices;i++){
				indexes[i *6+0]=(i *4+0);
				indexes[i *6+1]=(i *4+1);
				indexes[i *6+2]=(i *4+2);
				indexes[i *6+3]=(i *4+0);
				indexes[i *6+4]=(i *4+2);
				indexes[i *6+5]=(i *4+3);
			}
			this._indexBuffer3D.setData(indexes);
		}

		__proto.addNewParticlesToVertexBuffer=function(){
			var start=0;
			if (this._firstNewElement < this._firstFreeElement){
				start=this._firstNewElement *4 *this._floatCountPerVertex;
				this._vertexBuffer3D.setData(this._vertices,start,start,(this._firstFreeElement-this._firstNewElement)*4 *this._floatCountPerVertex);
				}else {
				start=this._firstNewElement *4 *this._floatCountPerVertex;
				this._vertexBuffer3D.setData(this._vertices,start,start,(this.settings.maxPartices-this._firstNewElement)*4 *this._floatCountPerVertex);
				if (this._firstFreeElement > 0){
					this._vertexBuffer3D.setData(this._vertices,0,0,this._firstFreeElement *4 *this._floatCountPerVertex);
				}
			}
			this._firstNewElement=this._firstFreeElement;
		}

		__proto._render=function(state){
			if (this.texture && this.texture.loaded){
				if (this._firstNewElement !=this._firstFreeElement){
					this.addNewParticlesToVertexBuffer();
				}
				if (this._firstActiveElement !=this._firstFreeElement){
					var gl=WebGL.mainContext;
					this._vertexBuffer3D._bind();
					this._indexBuffer._bind();
					this._shader=this.getShader(state);
					var presz=this._shaderValue.length;
					this._shaderValue.pushArray(state.shaderValue);
					this._shaderValue.pushArray(this._vertexBuffer3D.vertexDeclaration.shaderValues);
					this._shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.MVPMATRIX*/"MVPMATRIX",state.owner.transform.getWorldMatrix(2).elements,-1);
					this._shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.MATRIX1*/"MATRIX1",state.viewMatrix.elements,-1);
					this._shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.MATRIX2*/"MATRIX2",state.projectionMatrix.elements,-1);
					var aspectRadio=state.viewport.width / state.viewport.height;
					var viewportScale=new Vector2(0.5 / aspectRadio,-0.5);
					this._shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.VIEWPORTSCALE*/"VIEWPORTSCALE",viewportScale.elements,-1);
					this._shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.CURRENTTIME*/"CURRENTTIME",this._currentTime,-1);
					this._shaderValue.data[1][0]=this.texture.source;
					this._shaderValue.data[1][1]=this.texture.bitmap.id;
					this._shader.uploadArray(this._shaderValue.data,this._shaderValue.length,null);
					this._shaderValue.length=presz;
					var drawVertexCount=0;
					if (this._firstActiveElement < this._firstFreeElement){
						drawVertexCount=(this._firstFreeElement-this._firstActiveElement)*6;
						WebGL.mainContext.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,drawVertexCount,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,this._firstActiveElement *6 *2);
						Stat.trianglesFaces+=drawVertexCount / 3;
						Stat.drawCall++;
						}else {
						drawVertexCount=(this.settings.maxPartices-this._firstActiveElement)*6;
						WebGL.mainContext.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,drawVertexCount,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,this._firstActiveElement *6 *2);
						Stat.trianglesFaces+=drawVertexCount / 3;
						Stat.drawCall++;
						if (this._firstFreeElement > 0){
							drawVertexCount=this._firstFreeElement *6;
							WebGL.mainContext.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,drawVertexCount,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,0);
							Stat.trianglesFaces+=drawVertexCount / 3;
							Stat.drawCall++;
						}
					}
				}
				this._drawCounter++;
				return true;
			}
			return false;
		}

		__proto.getShader=function(state){
			var shaderDefs=state.shaderDefs;
			var preDef=shaderDefs._value;
			shaderDefs.addInt(/*laya.d3.shader.ShaderDefines3D.PARTICLE3D*/0x8000);
			var nameID=(shaderDefs._value | state.shadingMode)+this._sharderNameID */*laya.webgl.shader.Shader.SHADERNAME2ID*/0.0002;
			this._shader=Shader.withCompile(this._sharderNameID,state.shadingMode,shaderDefs.toNameDic(),nameID,null);
			shaderDefs._value=preDef;
			return this._shader;
		}

		__getset(0,__proto,'VertexBufferCount',function(){
			return 1;
		});

		__getset(0,__proto,'indexOfHost',function(){
			return 0;
		});

		__getset(0,__proto,'triangleCount',function(){
			return this._indexBuffer3D.indexCount/3;
		});

		return ParticleTemplet3D;
	})(ParticleTemplateWebGL)


	/**
	*<code>BaseScene</code> 类用于实现场景的父类。
	*/
	//class laya.d3.core.scene.BaseScene extends laya.display.Sprite
	var BaseScene=(function(_super){
		function BaseScene(){
			this._enableLightCount=3;
			this._renderTargetTexture=null;
			this._customRenderQueneIndex=11;
			this._lastCurrentTime=NaN;
			this.enableFog=false;
			this.fogStart=NaN;
			this.fogRange=NaN;
			this.fogColor=null;
			this.enableLight=true;
			this.currentCamera=null;
			BaseScene.__super.call(this);
			this._renderState=new RenderState();
			this._lights=new Array;
			this._shadingMode=/*laya.d3.shader.ShaderDefines3D.PIXELSHADERING*/0x2000;
			this._renderConfigs=[];
			this._quenes=[];
			this.enableFog=false;
			this.fogStart=300;
			this.fogRange=1000;
			this.fogColor=new Vector3(0.7,0.7,0.7);
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.NONEWRITEDEPTH*/0]=new RenderConfig();
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.NONEWRITEDEPTH*/0].depthTest=false;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.OPAQUE*/1]=new RenderConfig();
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.OPAQUE_DOUBLEFACE*/2]=new RenderConfig();
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.OPAQUE_DOUBLEFACE*/2].cullFace=false;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_BLEND_DOUBLEFACE*/4]=new RenderConfig();
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_BLEND_DOUBLEFACE*/4].cullFace=false;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_BLEND_DOUBLEFACE*/4].blend=true;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_BLEND_DOUBLEFACE*/4].sFactor=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_BLEND_DOUBLEFACE*/4].dFactor=/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_ADDTIVE_BLEND_DOUBLEFACE*/6]=new RenderConfig();
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_ADDTIVE_BLEND_DOUBLEFACE*/6].cullFace=false;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_ADDTIVE_BLEND_DOUBLEFACE*/6].blend=true;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_ADDTIVE_BLEND_DOUBLEFACE*/6].sFactor=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_ADDTIVE_BLEND_DOUBLEFACE*/6].dFactor=/*laya.webgl.WebGLContext.ONE*/1;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_BLEND*/3]=new RenderConfig();
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_BLEND*/3].blend=true;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_BLEND*/3].sFactor=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_BLEND*/3].dFactor=/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_ADDTIVE_BLEND*/5]=new RenderConfig();
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_ADDTIVE_BLEND*/5].blend=true;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_ADDTIVE_BLEND*/5].sFactor=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_ADDTIVE_BLEND*/5].dFactor=/*laya.webgl.WebGLContext.ONE*/1;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE*/8]=new RenderConfig();
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE*/8].cullFace=false;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE*/8].blend=true;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE*/8].depthMask=0;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE*/8].sFactor=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE*/8].dFactor=/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE*/10]=new RenderConfig();
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE*/10].cullFace=false;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE*/10].blend=true;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE*/10].depthMask=0;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE*/10].sFactor=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE*/10].dFactor=/*laya.webgl.WebGLContext.ONE*/1;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND*/7]=new RenderConfig();
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND*/7].blend=true;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND*/7].depthMask=0;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND*/7].sFactor=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND*/7].dFactor=/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND*/9]=new RenderConfig();
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND*/9].blend=true;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND*/9].depthMask=0;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND*/9].sFactor=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
			this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND*/9].dFactor=/*laya.webgl.WebGLContext.ONE*/1;
		}

		__class(BaseScene,'laya.d3.core.scene.BaseScene',_super);
		var __proto=BaseScene.prototype;
		Laya.imps(__proto,{"laya.webgl.submit.ISubmit":true})
		/**
		*@private
		*清除背景色。
		*@param gl WebGL上下文。
		*/
		__proto._clearColor=function(gl){
			var clearColore=this.currentCamera.clearColor.elements;
			gl.clearColor(clearColore[0],clearColore[1],clearColore[2],clearColore[3]);
			gl.clear(/*laya.webgl.WebGLContext.COLOR_BUFFER_BIT*/0x00004000 | /*laya.webgl.WebGLContext.DEPTH_BUFFER_BIT*/0x00000100);
		}

		/**
		*@private
		*场景相关渲染准备设置。
		*@param gl WebGL上下文。
		*@return state 渲染状态。
		*/
		__proto._prepareScene=function(gl,state){
			Layer._currentCameraCullingMask=this.currentCamera.cullingMask;
			state.context=WebGL.mainContext;
			state.worldTransformModifyID=1;
			state.elapsedTime=this._lastCurrentTime ? this.timer.currTimer-this._lastCurrentTime :0;
			this._lastCurrentTime=this.timer.currTimer;
			state.reset();
			state.loopCount=Stat.loopCount;
			state.shadingMode=this._shadingMode;
			state.scene=this;
			state.camera=this.currentCamera;
			var shaderValue=state.worldShaderValue;
			var loopCount=Stat.loopCount;
			this.currentCamera && shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.CAMERAPOS*/"CAMERAPOS",this.currentCamera.transform.position.elements,loopCount);
			if (this._lights.length > 0){
				var lightCount=0;
				for (var i=0;i < this._lights.length;i++){
					var light=this._lights[i];
					if (!light.active)continue ;
					lightCount++;
					if (lightCount > this._enableLightCount)
						break ;
					light.updateToWorldState(state);
				}
			}
			if (this.enableFog){
				state.worldShaderValue.pushValue(/*laya.webgl.utils.Buffer2D.FOGSTART*/"FOGSTART",this.fogStart,loopCount);
				state.worldShaderValue.pushValue(/*laya.webgl.utils.Buffer2D.FOGRANGE*/"FOGRANGE",this.fogRange,loopCount);
				state.worldShaderValue.pushValue(/*laya.webgl.utils.Buffer2D.FOGCOLOR*/"FOGCOLOR",this.fogColor.elements,loopCount);
			}
		}

		/**
		*@private
		*/
		__proto._updateScene=function(state){
			this._updateChilds(state);
		}

		/**
		*@private
		*/
		__proto._updateChilds=function(state){
			for (var i=0,n=this._childs.length;i < n;++i){
				var child=this._childs[i];
				child._update(state);
			}
		}

		/**
		*@private
		*/
		__proto._preRenderScene=function(gl,state){
			for (var i=0;i < this._quenes.length;i++){
				if (this._quenes[i]){
					this._quenes[i]._preRender(state);
				}
			}
		}

		/**
		*@private
		*/
		__proto._renderScene=function(gl,state){
			var viewport=state.viewport;
			gl.viewport(viewport.x,RenderState.clientHeight-viewport.y-viewport.height,viewport.width,viewport.height);
			for (var i=0;i < this._quenes.length;i++){
				if (this._quenes[i]){
					this._quenes[i]._setState(gl);
					this._quenes[i]._render(state);
				}
			}
		}

		/**
		*@private
		*/
		__proto._set3DRenderConfig=function(gl){
			gl.disable(/*laya.webgl.WebGLContext.BLEND*/0x0BE2);
			WebGLContext._blend=false;
			gl.blendFunc(/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302,/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303);
			WebGLContext._sFactor=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
			WebGLContext._dFactor=/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303;
			gl.disable(/*laya.webgl.WebGLContext.DEPTH_TEST*/0x0B71);
			WebGLContext._depthTest=false;
			gl.enable(/*laya.webgl.WebGLContext.CULL_FACE*/0x0B44);
			WebGLContext._cullFace=true;
			gl.depthMask(1);
			WebGLContext._depthMask=1;
			gl.frontFace(/*laya.webgl.WebGLContext.CW*/0x0900);
			WebGLContext._frontFace=/*laya.webgl.WebGLContext.CW*/0x0900;
		}

		/**
		*@private
		*/
		__proto._set2DRenderConfig=function(gl){
			WebGLContext.setBlend(gl,true);
			WebGLContext.setBlendFunc(gl,/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302,/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303);
			WebGLContext.setDepthTest(gl,false);
			WebGLContext.setCullFace(gl,true);
			WebGLContext.setDepthMask(gl,1);
			WebGLContext.setFrontFaceCCW(gl,/*laya.webgl.WebGLContext.CCW*/0x0901);
			gl.viewport(0,0,RenderState2D.width,RenderState2D.height);
		}

		/**
		*@private
		*/
		__proto._addLight=function(light){
			if (this._lights.indexOf(light)< 0)this._lights.push(light);
		}

		/**
		*@private
		*/
		__proto._removeLight=function(light){
			var index=this._lights.indexOf(light);
			index >=0 && (this._lights.splice(index,1));
		}

		__proto.removeChildAt=function(index){
			var node=this.getChildAt(index);
			if (node){
				this._childs.splice(index,1);
				this.model && this.model.removeChild(node.model);
				node.parent=null;
				(node)._clearSelfAndChildrenRenderObjects();
			}
			return node;
		}

		/**
		*获得某个渲染队列。
		*@param index 渲染队列索引。
		*@return 渲染队列。
		*/
		__proto.getRenderQueue=function(index){
			return (this._quenes[index] || (this._quenes[index]=new RenderQueue(this._renderConfigs[index])));
		}

		/**
		*获得某个渲染队列的渲染物体。
		*@param index 渲染队列索引。
		*@return 渲染物体。
		*/
		__proto.getRenderObject=function(index){
			return (this._quenes[index] || (this._quenes[index]=new RenderQueue(this._renderConfigs[index]))).getRenderObj();
		}

		/**
		*添加渲染队列。
		*@param renderConfig 渲染队列配置文件。
		*/
		__proto.addRenderQuene=function(renderConfig){
			this._quenes[this._customRenderQueneIndex++]=new RenderQueue(renderConfig);
		}

		/**
		*更新前处理,可重写此函数。
		*@param state 渲染相关状态。
		*/
		__proto.beforeUpate=function(state){}
		/**
		*更新后处理,可重写此函数。
		*@param state 渲染相关状态。
		*/
		__proto.lateUpate=function(state){}
		/**
		*渲染前处理,可重写此函数。
		*@param state 渲染相关状态。
		*/
		__proto.beforeRender=function(state){}
		/**
		*渲染后处理,可重写此函数。
		*@param state 渲染相关状态。
		*/
		__proto.lateRender=function(state){}
		/**
		*@private
		*/
		__proto.render=function(context,x,y){
			(Render._context.ctx)._shader2D.glTexture=null;
			this._childs.length > 0 && context.addRenderObject(this);
			this._renderType &=~ /*laya.renders.RenderSprite.CHILDS*/0x800;
			_super.prototype.render.call(this,context,x,y);
		}

		/**
		*@private
		*/
		__proto.renderSubmit=function(){
			return 1;
		}

		/**
		*@private
		*/
		__proto.getRenderType=function(){
			return 0;
		}

		/**
		*@private
		*/
		__proto.releaseRender=function(){}
		/**
		*获取当前场景。
		*@return 当前场景。
		*/
		__getset(0,__proto,'scene',function(){
			return this;
		});

		/**
		*设置着色模式。
		*@param value 着色模式。
		*/
		/**
		*获取着色模式。
		*@return 着色模式。
		*/
		__getset(0,__proto,'shadingMode',function(){
			return this._shadingMode==/*laya.d3.shader.ShaderDefines3D.VERTEXSHADERING*/0x1000 ? /*CLASS CONST:laya.d3.core.scene.BaseScene.VERTEX_SHADING*/0 :/*laya.d3.shader.ShaderDefines3D.PIXELSHADERING*/0x2000;
			},function(value){
			if (value!==/*CLASS CONST:laya.d3.core.scene.BaseScene.VERTEX_SHADING*/0 && value!==/*CLASS CONST:laya.d3.core.scene.BaseScene.PIXEL_SHADING*/1)throw Error("Scene set shadingMode,must:0 or 1,value="+value);
			this._shadingMode=value===/*CLASS CONST:laya.d3.core.scene.BaseScene.VERTEX_SHADING*/0 ? /*laya.d3.shader.ShaderDefines3D.VERTEXSHADERING*/0x1000 :/*laya.d3.shader.ShaderDefines3D.PIXELSHADERING*/0x2000;
		});

		BaseScene.VERTEX_SHADING=0;
		BaseScene.PIXEL_SHADING=1;
		return BaseScene;
	})(Sprite)


	/**
	*<code>BaseCamera</code> 类用于创建摄像机的父类。
	*/
	//class laya.d3.core.BaseCamera extends laya.d3.core.Sprite3D
	var BaseCamera=(function(_super){
		function BaseCamera(nearPlane,farPlane){
			//this._tempVector3=null;
			//this._position=null;
			//this._up=null;
			//this._forward=null;
			//this._right=null;
			//this._masterCamera=null;
			//this._slavesCameras=null;
			//this._renderTarget=null;
			//this._renderingOrder=0;
			//this._renderTargetSize=null;
			//this._nearPlane=NaN;
			//this._farPlane=NaN;
			//this._fieldOfView=NaN;
			//this._orthographic=false;
			//this._orthographicVerticalSize=NaN;
			//this._useUserProjectionMatrix=false;
			//this._viewportExpressedInClipSpace=false;
			this._projectionMatrixModifyID=0;
			//this._partialRenderTarget=null;
			//this.clearColor=null;
			//this.cullingMask=0;
			BaseCamera.__super.call(this);
			(nearPlane===void 0)&& (nearPlane=0.1);
			(farPlane===void 0)&& (farPlane=1000);
			this._tempVector3=new Vector3();
			this._up=new Vector3();
			this._forward=new Vector3();
			this._right=new Vector3();
			this._fieldOfView=60;
			this._useUserProjectionMatrix=false;
			this._orthographic=false;
			this._viewportExpressedInClipSpace=true;
			this._slavesCameras=[];
			this._renderTargetSize=Size.fullScreen;
			this._orthographicVerticalSize=10;
			this.renderingOrder=0;
			this._nearPlane=nearPlane;
			this._farPlane=farPlane;
			this.cullingMask=2147483647;
			this.clearColor=new Vector4(100.0 / 255.0,149.0 / 255.0,237.0 / 255.0,255.0 / 255.0);
			this._calculateProjectionMatrix();
			Laya.stage.on(/*laya.events.Event.RESIZE*/"resize",this,this._onScreenSizeChanged);
		}

		__class(BaseCamera,'laya.d3.core.BaseCamera',_super);
		var __proto=BaseCamera.prototype;
		__proto._calculateProjectionMatrix=function(){}
		__proto._onScreenSizeChanged=function(){
			this._calculateProjectionMatrix();
		}

		/**
		*增加可视图层。
		*@param layer 图层。
		*/
		__proto.addLayer=function(layer){
			if (layer.number===29 || layer.number==30)
				return;
			this.cullingMask=this.cullingMask | layer.mask;
		}

		/**
		*移除可视图层。
		*@param layer 图层。
		*/
		__proto.removeLayer=function(layer){
			if (layer.number===29 || layer.number==30)
				return;
			this.cullingMask=this.cullingMask & ~layer.mask;
		}

		/**
		*增加所有图层。
		*/
		__proto.addAllLayers=function(){
			this.cullingMask=2147483647;
		}

		/**
		*移除所有图层。
		*/
		__proto.removeAllLayers=function(){
			this.cullingMask=0 | Layer.getLayerByNumber(29).mask | Layer.getLayerByNumber(30).mask;
		}

		__proto.ResetProjectionMatrix=function(){
			this._useUserProjectionMatrix=false;
			this._calculateProjectionMatrix();
		}

		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			this.masterCamera=null;
			this.renderTarget=null;
			Laya.stage.off(/*laya.events.Event.RESIZE*/"resize",this,this._onScreenSizeChanged);
			laya.display.Node.prototype.destroy.call(this,destroyChild);
		}

		/**
		*向前移动。
		*@param distance 移动距离。
		*/
		__proto.moveForward=function(distance){
			this._tempVector3.elements[0]=this._tempVector3.elements[1]=0;
			this._tempVector3.elements[2]=distance;
			this.transform.translate(this._tempVector3);
		}

		/**
		*向右移动。
		*@param distance 移动距离。
		*/
		__proto.moveRight=function(distance){
			this._tempVector3.elements[1]=this._tempVector3.elements[2]=0;
			this._tempVector3.elements[0]=distance;
			this.transform.translate(this._tempVector3);
		}

		/**
		*向上移动。
		*@param distance 移动距离。
		*/
		__proto.moveVertical=function(distance){
			this._tempVector3.elements[0]=this._tempVector3.elements[2]=0;
			this._tempVector3.elements[1]=distance;
			this.transform.translate(this._tempVector3,false);
		}

		/**获取位置。*/
		__getset(0,__proto,'position',function(){
			var worldMatrixe=this.transform.worldMatrix.elements;
			var positione=this._position.elements;
			positione[0]=worldMatrixe[12];
			positione[1]=worldMatrixe[13];
			positione[2]=worldMatrixe[14];
			return this._position;
		});

		/**
		*设置渲染目标的尺寸
		*@param value 渲染目标的尺寸。
		*/
		/**
		*获取渲染目标的尺寸
		*@return 渲染目标的尺寸。
		*/
		__getset(0,__proto,'renderTargetSize',function(){
			if (this._masterCamera !=null)
				return this._masterCamera.renderTargetSize;
			return this._renderTargetSize;
			},function(value){
			if (this._masterCamera !=null)
				return;
			if (this.renderTarget !=null && this._renderTargetSize !=value){}
				this._renderTargetSize=value;
			this._calculateProjectionMatrix();
		});

		/**
		*获取上向量。
		*@return 上向量。
		*/
		__getset(0,__proto,'up',function(){
			var worldMatrixe=this.transform.worldMatrix.elements;
			var upe=this._up.elements;
			upe[0]=worldMatrixe[4];
			upe[1]=worldMatrixe[5];
			upe[2]=worldMatrixe[6];
			return this._up;
		});

		/**
		*设置视野。
		*@param value 视野。
		*/
		/**
		*获取视野。
		*@return 视野。
		*/
		__getset(0,__proto,'fieldOfView',function(){
			return this._fieldOfView;
			},function(value){
			this._fieldOfView=value;
			this._calculateProjectionMatrix();
		});

		/**
		*获取前向量。
		*@return 前向量。
		*/
		__getset(0,__proto,'forward',function(){
			var worldMatrixe=this.transform.worldMatrix.elements;
			var forwarde=this._forward.elements;
			forwarde[0]=-worldMatrixe[8];
			forwarde[1]=-worldMatrixe[9];
			forwarde[2]=-worldMatrixe[10];
			return this._forward;
		});

		/**
		*获取右向量。
		*@return 右向量。
		*/
		__getset(0,__proto,'right',function(){
			var worldMatrixe=this.transform.worldMatrix.elements;
			var righte=this._right.elements;
			righte[0]=worldMatrixe[0];
			righte[1]=worldMatrixe[1];
			righte[2]=worldMatrixe[2];
			return this._right;
		});

		/**
		*设置主人摄像机，渲染类型、清除颜色和渲染目标值均来自主人摄像机。
		*@param 主人摄像机。
		*/
		/**
		*获取主人摄像机，渲染类型、清除颜色和渲染目标值均来自主人摄像机。
		*@return 主人摄像机。
		*/
		__getset(0,__proto,'masterCamera',function(){
			return this._masterCamera;
			},function(value){
			if (this._slavesCameras.length !=0 || (value !=null && value.masterCamera !=null))
				throw new Error("BaseCamera: A camera can't be master and slave simultaneity.");
			if (this.masterCamera !=null){
				var slavesCameras=this.masterCamera._slavesCameras;
				slavesCameras.splice(slavesCameras.indexOf(this),1);
			}
			this.masterCamera=value;
			if (value !=null){
				value._slavesCameras.push(this);
				for (var i=0;i < value._slavesCameras.length;i++){
					var count=value._slavesCameras.length;
					if (value._slavesCameras[i].renderingOrder > value._slavesCameras[count-1].renderingOrder){
						var temp=value._slavesCameras[count-1];
						value._slavesCameras[count-1]=value._slavesCameras[i];
						value._slavesCameras[i]=temp;
					}
				}
				this._renderTarget=null;
			}
		});

		/**
		*设置渲染场景的渲染目标，渲染目标同时存储主人相机和奴隶相机的结果。
		*@param value 渲染场景的渲染目标。
		*/
		/**
		*获取渲染场景的渲染目标，渲染目标同时存储主人相机和奴隶相机的结果。
		*@return 渲染场景的渲染目标。
		*/
		__getset(0,__proto,'renderTarget',function(){
			if (this._masterCamera !=null)
				return this._masterCamera.renderTarget;
			return this._renderTarget;
			},function(value){
			if (this._masterCamera !=null)
				return;
			this._renderTarget=value;
			if (value !=null)
				this._renderTargetSize=value.size;
		});

		/**
		*设置近裁面。
		*@param value 近裁面。
		*/
		/**
		*获取近裁面。
		*@return 近裁面。
		*/
		__getset(0,__proto,'nearPlane',function(){
			return this._nearPlane;
			},function(value){
			this._nearPlane=value;
			this._calculateProjectionMatrix();
		});

		/**
		*设置远裁面。
		*@param value 远裁面。
		*/
		/**
		*获取远裁面。
		*@return 远裁面。
		*/
		__getset(0,__proto,'farPlane',function(){
			return this._farPlane;
			},function(vaule){
			this._farPlane=vaule;
			this._calculateProjectionMatrix();
		});

		__getset(0,__proto,'renderingOrder',function(){
			return this._renderingOrder;
			},function(value){
			this._renderingOrder=value;
		});

		/**
		*设置是否正交投影矩阵。
		*@param 是否正交投影矩阵。
		*/
		/**
		*获取是否正交投影矩阵。
		*@return 是否正交投影矩阵。
		*/
		__getset(0,__proto,'orthographicProjection',function(){
			return this._orthographic;
			},function(vaule){
			this._orthographic=vaule;
			this._calculateProjectionMatrix();
		});

		/**
		*设置正交投影垂直矩阵尺寸。
		*@param 正交投影垂直矩阵尺寸。
		*/
		/**
		*获取正交投影垂直矩阵尺寸。
		*@return 正交投影垂直矩阵尺寸。
		*/
		__getset(0,__proto,'orthographicVerticalSize',function(){
			return this._orthographicVerticalSize;
			},function(vaule){
			this._orthographicVerticalSize=vaule;
			this._calculateProjectionMatrix();
		});

		/**
		*获取主摄像机，确保已经使用RenderingOrder排序。
		*@return 主摄像机。
		*/
		__getset(1,BaseCamera,'mainCamera',function(){
			for (var i=BaseCamera._cameraPool.length-1;i >=0;i--){
				if (BaseCamera._cameraPool[i].masterCamera==null && BaseCamera._cameraPool[i].enable)
					return BaseCamera._cameraPool[i];
			}
			return null;
		},laya.d3.core.Sprite3D._$SET_mainCamera);

		BaseCamera._sortCamerasByRenderingOrder=function(){
			var n=BaseCamera._cameraPool.length-1;
			for (var i=0;i < n;i++){
				if (BaseCamera._cameraPool[i].renderingOrder > BaseCamera._cameraPool[n].renderingOrder){
					var tempCamera=BaseCamera._cameraPool[i];
					BaseCamera._cameraPool[i]=BaseCamera._cameraPool[n];
					BaseCamera._cameraPool[n]=tempCamera;
				}
			}
		}

		BaseCamera.RENDERINGTYPE_DEFERREDLIGHTING="DEFERREDLIGHTING";
		BaseCamera.RENDERINGTYPE_FORWARDRENDERING="FORWARDRENDERING";
		__static(BaseCamera,
		['_cameraPool',function(){return this._cameraPool=__newvec(2,null);}
		]);
		return BaseCamera;
	})(Sprite3D)


	/**
	*<code>Glitter</code> 类用于创建闪光。
	*/
	//class laya.d3.core.glitter.Glitter extends laya.d3.core.Sprite3D
	var Glitter=(function(_super){
		function Glitter(settings){
			this._templet=null;
			this._renderObject=null;
			Glitter.__super.call(this);
			this._templet=new GlitterTemplet(settings);
		}

		__class(Glitter,'laya.d3.core.glitter.Glitter',_super);
		var __proto=Glitter.prototype;
		__proto._clearSelfRenderObjects=function(){
			this._renderObject.renderQneue.deleteRenderObj(this._renderObject);
		}

		/**
		*@private
		*更新闪光。
		*@param state 渲染状态参数。
		*/
		__proto._update=function(state){
			state.owner=this;
			var preWorldTransformModifyID=state.worldTransformModifyID;
			var canView=state.renderClip.view(this)&& this.active;
			state.worldTransformModifyID+=this.transform._worldTransformModifyID;
			this.transform.getWorldMatrix(state.worldTransformModifyID);
			if (canView){
				if (this._renderObject){
					var renderQueueIndex=0;
					renderQueueIndex=/*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE*/8;
					var renderQueue=state.scene.getRenderQueue(renderQueueIndex);
					if (this._renderObject.renderQneue !=renderQueue){
						this._renderObject.renderQneue.deleteRenderObj(this._renderObject);
						this._renderObject=this._addRenderObject(state,renderQueueIndex);
					}
					}else {
					this._renderObject=this._addRenderObject(state,renderQueueIndex);
				}
				this._renderObject.tag.worldTransformModifyID=state.worldTransformModifyID;
				}else {
				this._clearSelfRenderObjects();
			}
			state.worldTransformModifyID=preWorldTransformModifyID;
			this._childs.length && this._updateChilds(state);
		}

		__proto._addRenderObject=function(state,renderQueueIndex){
			var renderObj=state.scene.getRenderObject(renderQueueIndex);
			this._renderObject=renderObj;
			var renderElement=this.templet;
			renderObj.mainSortID=0;
			renderObj.triangleCount=renderElement.triangleCount;
			renderObj.owner=state.owner;
			renderObj.renderElement=renderElement;
			renderObj.material=null;
			renderObj.tag || (renderObj.tag=new Object());
			renderObj.tag.worldTransformModifyID=state.worldTransformModifyID;
			return renderObj;
		}

		/**
		*获取闪光模板。
		*@return 闪光模板。
		*/
		__getset(0,__proto,'templet',function(){
			return this._templet;
		});

		return Glitter;
	})(Sprite3D)


	/**
	*<code>LightSprite</code> 类用于创建灯光的父类。
	*/
	//class laya.d3.core.light.LightSprite extends laya.d3.core.Sprite3D
	var LightSprite=(function(_super){
		function LightSprite(){
			this._diffuseColor=null;
			this._ambientColor=null;
			this._specularColor=null;
			this._reflectColor=null;
			LightSprite.__super.call(this);
			this.on(/*laya.events.Event.ADDED*/"added",this,this._onAdded);
			this.on(/*laya.events.Event.REMOVED*/"removed",this,this._onRemoved);
			this._diffuseColor=new Vector3(0.8,0.8,0.8);
			this._ambientColor=new Vector3(0.6,0.6,0.6);
			this._specularColor=new Vector3(1.0,1.0,1.0);
			this._reflectColor=new Vector3(1.0,1.0,1.0);
		}

		__class(LightSprite,'laya.d3.core.light.LightSprite',_super);
		var __proto=LightSprite.prototype;
		/**
		*@private
		*灯光节点移除事件处理函数。
		*/
		__proto._onRemoved=function(){
			this.scene._removeLight(this);
		}

		/**
		*@private
		*灯光节点添加事件处理函数。
		*/
		__proto._onAdded=function(){
			this.scene._addLight(this);
		}

		/**
		*更新灯光相关渲染状态参数。
		*@param state 渲染状态参数。
		*/
		__proto.updateToWorldState=function(state){}
		/**
		*设置灯光的漫反射颜色。
		*@param value 灯光的漫反射颜色。
		*/
		/**
		*获取灯光的漫反射颜色。
		*@return 灯光的漫反射颜色。
		*/
		__getset(0,__proto,'diffuseColor',function(){
			return this._diffuseColor;
			},function(value){
			this._diffuseColor=value;
		});

		/**
		*获取灯光的类型。
		*@return 灯光的类型。
		*/
		__getset(0,__proto,'lightType',function(){
			return-1;
		});

		/**
		*设置灯光的环境光颜色。
		*@param value 灯光的环境光颜色。
		*/
		/**
		*获取灯光的环境光颜色。
		*@return 灯光的环境光颜色。
		*/
		__getset(0,__proto,'ambientColor',function(){
			return this._ambientColor;
			},function(value){
			this._ambientColor=value;
		});

		/**
		*设置灯光的高光颜色。
		*@param value 灯光的高光颜色。
		*/
		/**
		*获取灯光的高光颜色。
		*@return 灯光的高光颜色。
		*/
		__getset(0,__proto,'specularColor',function(){
			return this._specularColor;
			},function(value){
			this._specularColor=value;
		});

		/**
		*设置灯光的反射颜色。
		*@param value 灯光的反射颜色。
		*/
		/**
		*获取灯光的反射颜色。
		*@return 灯光的反射颜色。
		*/
		__getset(0,__proto,'reflectColor',function(){
			return this._reflectColor;
			},function(value){
			this._reflectColor=value;
		});

		LightSprite.TYPE_DIRECTIONLIGHT=1;
		LightSprite.TYPE_POINTLIGHT=2;
		LightSprite.TYPE_SPOTLIGHT=3;
		return LightSprite;
	})(Sprite3D)


	/**
	*<code>MeshSprite3D</code> 类用于创建网格。
	*/
	//class laya.d3.core.MeshSprite3D extends laya.d3.core.Sprite3D
	var MeshSprite3D=(function(_super){
		function MeshSprite3D(mesh,name){
			this._renderObjects=null;
			this._mesh=null;
			this._materials=null;
			this._renderObjects=[];
			this._mesh=mesh;
			if ((mesh instanceof laya.d3.resource.models.Mesh ))
				this._materials=(mesh).materials;
			MeshSprite3D.__super.call(this,name);
		}

		__class(MeshSprite3D,'laya.d3.core.MeshSprite3D',_super);
		var __proto=MeshSprite3D.prototype;
		__proto._clearSelfRenderObjects=function(){
			for (var i=0,n=this._renderObjects.length;i < n;i++){
				var renderObj=this._renderObjects[i];
				renderObj.renderQneue.deleteRenderObj(renderObj);
			}
			this._renderObjects.length=0;
		}

		/**
		*@private
		*/
		__proto._update=function(state){
			state.owner=this;
			var preTransformID=state.worldTransformModifyID;
			var canView=state.renderClip.view(this)&& this.active;
			(canView)&& (this._updateComponents(state));
			state.worldTransformModifyID+=this.transform._worldTransformModifyID;
			this.transform.getWorldMatrix(state.worldTransformModifyID);
			if (canView){
				var renderElementsCount=this._mesh.getRenderElementsCount();
				for (var i=0;i < renderElementsCount;i++){
					var obj=this._renderObjects[i];
					if (obj){
						var material=this._materials[i];
						var renderQueue=state.scene.getRenderQueue(material.renderQueue);
						if (obj.renderQneue !=renderQueue){
							obj.renderQneue.deleteRenderObj(obj);
							obj=this._addRenderObject(state,i,material);
						}
						}else {
						obj=this._addRenderObject(state,i,this._materials[i]);
					}
					obj.tag.worldTransformModifyID=state.worldTransformModifyID;
				}
				this._lateUpdateComponents(state);
				}else {
				this._clearSelfRenderObjects();
			}
			Stat.spriteCount++;
			this._childs.length && this._updateChilds(state);
			state.worldTransformModifyID=preTransformID;
		}

		__proto._addRenderObject=function(state,index,material){
			var renderObj=state.scene.getRenderObject(material.renderQueue);
			this._renderObjects[index]=renderObj;
			var renderElement=this._mesh.getRenderElement(index);
			renderObj.mainSortID=state.owner._getSortID(renderElement,material);
			renderObj.triangleCount=renderElement.triangleCount;
			renderObj.owner=state.owner;
			renderObj.renderElement=renderElement;
			renderObj.material=material;
			renderObj.tag || (renderObj.tag=new Object());
			renderObj.tag.worldTransformModifyID=state.worldTransformModifyID;
			return renderObj;
		}

		/**
		*设置第一个实例材质。
		*@param value 第一个实例材质。
		*/
		/**
		*返回第一个实例材质,注意会拷贝对象。
		*@return 第一个实例材质。
		*/
		__getset(0,__proto,'material',function(){
			if ((this._materials && this._materials[0])){
				var instanceMaterial=new Material();
				this._materials[0].copy(instanceMaterial);
				this._materials=this._materials.slice();
				this._materials[0]=instanceMaterial;
				return this._materials[0];
			}
			return null;
			},function(value){
			(this._materials)|| (this._materials=[]);
			this._materials[0]=value;
		});

		/**
		*设置实例材质列表。
		*@param value 实例材质列表。
		*/
		/**
		*获取实例材质列表,注意会拷贝对象。
		*@return 实例材质列表。
		*/
		__getset(0,__proto,'materials',function(){
			if (this._materials){
				var instanceMaterials=[];
				for (var i=0;i < this._materials.length;i++){
					var material=new Material();
					this._materials[i].copy(material);
					instanceMaterials.push(material);
				}
				this._materials=instanceMaterials;
			}
			return this._materials;
			},function(value){
			this._materials=value;
		});

		/**
		*设置子网格数据模板。
		*@param value 子网格数据模板。
		*/
		/**
		*获取子网格数据模板。
		*@return 子网格数据模板。
		*/
		__getset(0,__proto,'mesh',function(){
			return this._mesh;
			},function(value){
			this._mesh=value;
			this.event(/*laya.events.Event.CHANGED*/"changed");
		});

		/**
		*设置第一个材质。
		*@param value 第一个材质。
		*/
		/**
		*返回第一个材质。
		*@return 第一个材质。
		*/
		__getset(0,__proto,'shadredMaterial',function(){
			return (this._materials && this._materials[0])? this._materials[0] :null;
			},function(value){
			(this._materials)|| (this._materials=[]);
			this._materials[0]=value;
		});

		/**
		*设置材质列表。
		*@param value 材质列表。
		*/
		/**
		*获取材质列表。
		*@return 材质列表。
		*/
		__getset(0,__proto,'shadredMaterials',function(){
			return this._materials;
			},function(value){
			this._materials=value;
		});

		return MeshSprite3D;
	})(Sprite3D)


	/**
	*<code>Particle3D</code> 3D粒子。
	*/
	//class laya.d3.core.particle.Particle3D extends laya.d3.core.Sprite3D
	var Particle3D=(function(_super){
		function Particle3D(settings){
			this.templet=null;
			this._renderObject=null;
			Particle3D.__super.call(this);
			this.templet=new ParticleTemplet3D(settings);
		}

		__class(Particle3D,'laya.d3.core.particle.Particle3D',_super);
		var __proto=Particle3D.prototype;
		__proto._clearSelfRenderObjects=function(){
			this._renderObject.renderQneue.deleteRenderObj(this._renderObject);
		}

		/**
		*添加粒子。
		*@param position 粒子位置。
		*@param velocity 粒子速度。
		*/
		__proto.addParticle=function(position,velocity){
			Vector3.add(this.transform.localPosition,position,position);
			this.templet.addParticle(position,velocity);
		}

		/**
		*更新粒子。
		*@param state 渲染相关状态参数。
		*/
		__proto._update=function(state){
			this.templet.update(state.elapsedTime);
			state.owner=this;
			var preWorldTransformModifyID=state.worldTransformModifyID;
			var canView=state.renderClip.view(this)&& this.active;
			state.worldTransformModifyID+=this.transform._worldTransformModifyID;
			this.transform.getWorldMatrix(state.worldTransformModifyID);
			if (canView){
				if (this._renderObject){
					var renderQueueIndex=0;
					if (this.templet.settings.blendState===0)
						renderQueueIndex=/*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND*/7;
					else if (this.templet.settings.blendState===1)
					renderQueueIndex=/*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND*/9;
					var renderQueue=state.scene.getRenderQueue(renderQueueIndex);
					if (this._renderObject.renderQneue !=renderQueue){
						this._renderObject.renderQneue.deleteRenderObj(this._renderObject);
						this._renderObject=this._addRenderObject(state,renderQueueIndex);
					}
					}else {
					this._renderObject=this._addRenderObject(state,renderQueueIndex);
				}
				this._renderObject.tag.worldTransformModifyID=state.worldTransformModifyID;
				}else {
				this._clearSelfRenderObjects();
			}
			state.worldTransformModifyID=preWorldTransformModifyID;
			this._childs.length && this._updateChilds(state);
		}

		__proto._addRenderObject=function(state,renderQueueIndex){
			var renderObj=state.scene.getRenderObject(renderQueueIndex);
			this._renderObject=renderObj;
			var renderElement=this.templet;
			renderObj.mainSortID=0;
			renderObj.triangleCount=renderElement.triangleCount;
			renderObj.owner=state.owner;
			renderObj.renderElement=renderElement;
			renderObj.material=null;
			renderObj.tag || (renderObj.tag=new Object());
			renderObj.tag.worldTransformModifyID=state.worldTransformModifyID;
			return renderObj;
		}

		return Particle3D;
	})(Sprite3D)


	/**
	*<code>IndexBuffer3D</code> 类用于创建索引缓冲。
	*/
	//class laya.d3.graphics.IndexBuffer3D extends laya.webgl.utils.Buffer
	var IndexBuffer3D=(function(_super){
		function IndexBuffer3D(indexType,indexCount,bufferUsage,canRead){
			this._indexType=null;
			this._indexTypeByteCount=0;
			this._indexCount=0;
			this._canRead=false;
			(bufferUsage===void 0)&& (bufferUsage=/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4);
			(canRead===void 0)&& (canRead=false);
			IndexBuffer3D.__super.call(this);
			this._indexType=indexType;
			this._indexCount=indexCount;
			this._bufferUsage=bufferUsage;
			this._bufferType=/*laya.webgl.WebGLContext.ELEMENT_ARRAY_BUFFER*/0x8893;
			this._canRead=canRead;
			this._bind();
			var byteLength=0;
			if (indexType==/*CLASS CONST:laya.d3.graphics.IndexBuffer3D.INDEXTYPE_USHORT*/"ushort")
				this._indexTypeByteCount=2;
			else if (indexType==/*CLASS CONST:laya.d3.graphics.IndexBuffer3D.INDEXTYPE_UBYTE*/"ubyte")
			this._indexTypeByteCount=1;
			else
			throw new Error("unidentification index type.");
			byteLength=this._indexTypeByteCount *indexCount;
			this._byteLength=byteLength;
			Buffer._gl.bufferData(this._bufferType,byteLength,this._bufferUsage);
			if (canRead){
				if (indexType==/*CLASS CONST:laya.d3.graphics.IndexBuffer3D.INDEXTYPE_USHORT*/"ushort")
					this._buffer=new Uint16Array(indexCount);
				else if (indexType==/*CLASS CONST:laya.d3.graphics.IndexBuffer3D.INDEXTYPE_UBYTE*/"ubyte")
				this._buffer=new Uint8Array(indexCount);
				this.memorySize=byteLength *2;
				}else {
				this.memorySize=byteLength;
			}
		}

		__class(IndexBuffer3D,'laya.d3.graphics.IndexBuffer3D',_super);
		var __proto=IndexBuffer3D.prototype;
		/**
		*设置数据。
		*@param data 索引数据。
		*@param bufferOffset 索引缓冲中的偏移。
		*@param dataStartIndex 索引数据的偏移。
		*@param dataCount 索引数据的数量。
		*/
		__proto.setData=function(data,bufferOffset,dataStartIndex,dataCount){
			(bufferOffset===void 0)&& (bufferOffset=0);
			(dataStartIndex===void 0)&& (dataStartIndex=0);
			(dataCount===void 0)&& (dataCount=4294967295);
			var byteCount=0;
			if (this._indexType==/*CLASS CONST:laya.d3.graphics.IndexBuffer3D.INDEXTYPE_USHORT*/"ushort"){
				byteCount=2;
				if (dataStartIndex!==0 || dataCount!==4294967295)
					data=new Uint16Array(data.buffer,dataStartIndex *byteCount,dataCount);
				}else if (this._indexType==/*CLASS CONST:laya.d3.graphics.IndexBuffer3D.INDEXTYPE_UBYTE*/"ubyte"){
				byteCount=1;
				if (dataStartIndex!==0 || dataCount!==4294967295)
					data=new Uint8Array(data.buffer,dataStartIndex *byteCount,dataCount);
			}
			this._bind();
			Buffer._gl.bufferSubData(this._bufferType,bufferOffset *byteCount,data);
			if (this._canRead){
				if (bufferOffset!==0 || dataStartIndex!==0 || dataCount!==4294967295){
					var maxLength=this._buffer.length-bufferOffset;
					if (dataCount > maxLength)
						dataCount=maxLength;
					for (var i=0;i < dataCount;i++)
					this._buffer[bufferOffset+i]=data[i];
					}else {
					this._buffer=data;
				}
			}
		}

		/**
		*获取索引数据。
		*@return 索引数据。
		*/
		__proto.getData=function(){
			if (this._canRead)
				return this._buffer;
			else
			throw new Error("Can't read data from VertexBuffer with only write flag!");
		}

		/**彻底销毁索引缓冲。*/
		__proto.dispose=function(){
			this._buffer=null;
			_super.prototype.dispose.call(this);
			this.memorySize=0;
		}

		/**
		*获取索引类型。
		*@return 索引类型。
		*/
		__getset(0,__proto,'indexType',function(){
			return this._indexType;
		});

		/**
		*获取索引类型字节数量。
		*@return 索引类型字节数量。
		*/
		__getset(0,__proto,'indexTypeByteCount',function(){
			return this._indexTypeByteCount;
		});

		/**
		*获取索引个数。
		*@return 索引个数。
		*/
		__getset(0,__proto,'indexCount',function(){
			return this._indexCount;
		});

		/**
		*获取是否可读。
		*@return 是否可读。
		*/
		__getset(0,__proto,'canRead',function(){
			return this._canRead;
		});

		IndexBuffer3D.INDEXTYPE_UBYTE="ubyte";
		IndexBuffer3D.INDEXTYPE_USHORT="ushort";
		IndexBuffer3D.create=function(indexType,indexCount,bufferUsage,canRead){
			(bufferUsage===void 0)&& (bufferUsage=/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4);
			(canRead===void 0)&& (canRead=false);
			return new IndexBuffer3D(indexType,indexCount,bufferUsage,canRead);
		}

		return IndexBuffer3D;
	})(Buffer)


	/**
	*<code>VertexBuffer3D</code> 类用于创建顶点缓冲。
	*/
	//class laya.d3.graphics.VertexBuffer3D extends laya.webgl.utils.Buffer
	var VertexBuffer3D=(function(_super){
		function VertexBuffer3D(vertexDeclaration,vertexCount,bufferUsage,canRead){
			this._vertexDeclaration=null;
			this._vertexCount=0;
			this._canRead=false;
			(canRead===void 0)&& (canRead=false);
			VertexBuffer3D.__super.call(this);
			this._vertexDeclaration=vertexDeclaration;
			this._vertexCount=vertexCount;
			this._bufferUsage=bufferUsage;
			this._bufferType=/*laya.webgl.WebGLContext.ARRAY_BUFFER*/0x8892;
			this._canRead=canRead;
			this._bind();
			var byteLength=this._vertexDeclaration.vertexStride *vertexCount;
			this._byteLength=byteLength;
			Buffer._gl.bufferData(this._bufferType,byteLength,this._bufferUsage);
			canRead && (this._buffer=new Float32Array(byteLength / 4));
		}

		__class(VertexBuffer3D,'laya.d3.graphics.VertexBuffer3D',_super);
		var __proto=VertexBuffer3D.prototype;
		/**
		*和索引缓冲一起绑定。
		*@param ib 索引缓冲。
		*/
		__proto.bindWithIndexBuffer=function(ib){
			(ib)&& (ib._bind());
			this._bind();
		}

		/**
		*设置数据。
		*@param data 顶点数据。
		*@param bufferOffset 顶点缓冲中的偏移。
		*@param dataStartIndex 顶点数据的偏移。
		*@param dataCount 顶点数据的数量。
		*/
		__proto.setData=function(data,bufferOffset,dataStartIndex,dataCount){
			(bufferOffset===void 0)&& (bufferOffset=0);
			(dataStartIndex===void 0)&& (dataStartIndex=0);
			(dataCount===void 0)&& (dataCount=4294967295);
			if (dataStartIndex!==0 || dataCount!==4294967295)
				data=new Float32Array(data.buffer,dataStartIndex *4,dataCount);
			this._bind();
			Buffer._gl.bufferSubData(this._bufferType,bufferOffset *4,data);
			if (this._canRead){
				if (bufferOffset!==0 || dataStartIndex!==0 || dataCount!==4294967295){
					var maxLength=this._buffer.length-bufferOffset;
					if (dataCount > maxLength)
						dataCount=maxLength;
					for (var i=0;i < dataCount;i++)
					this._buffer[bufferOffset+i]=data[i];
					}else {
					this._buffer=data;
				}
			}
		}

		/**
		*获取顶点数据。
		*@return 顶点数据。
		*/
		__proto.getData=function(){
			if (this._canRead)
				return this._buffer;
			else
			throw new Error("Can't read data from VertexBuffer with only write flag!");
		}

		/**销毁顶点缓冲。*/
		__proto.detoryResource=function(){
			var elements=this._vertexDeclaration.getVertexElements();
			for (var i=0;i < elements.length;i++)
			WebGL.mainContext.disableVertexAttribArray(i);
			_super.prototype.detoryResource.call(this);
		}

		/**彻底销毁顶点缓冲。*/
		__proto.dispose=function(){
			_super.prototype.dispose.call(this);
			this._buffer=null;
			this._vertexDeclaration=null;
		}

		/**
		*获取顶点结构声明。
		*@return 顶点结构声明。
		*/
		__getset(0,__proto,'vertexDeclaration',function(){
			return this._vertexDeclaration;
		});

		/**
		*获取顶点个数。
		*@return 顶点个数。
		*/
		__getset(0,__proto,'vertexCount',function(){
			return this._vertexCount;
		});

		/**
		*获取是否可读。
		*@return 是否可读。
		*/
		__getset(0,__proto,'canRead',function(){
			return this._canRead;
		});

		VertexBuffer3D.create=function(vertexDeclaration,vertexCount,bufferUsage,canRead){
			(bufferUsage===void 0)&& (bufferUsage=/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4);
			(canRead===void 0)&& (canRead=false);
			return new VertexBuffer3D(vertexDeclaration,vertexCount,bufferUsage,canRead);
		}

		return VertexBuffer3D;
	})(Buffer)


	/**
	*<code>Mesh</code> 类用于创建文件网格数据模板。
	*/
	//class laya.d3.resource.models.Mesh extends laya.d3.resource.models.BaseMesh
	var Mesh=(function(_super){
		function Mesh(url){
			this._materials=null;
			this._subMeshes=null;
			this._useFullBone=true;
			this._url=null;
			this._loaded=false;
			Mesh.__super.call(this);
			this._subMeshes=[];
			this._materials=[];
			this._url=url;
			if (this._loaded)
				this._generateBoundingObject();
			else
			this.once(/*laya.events.Event.LOADED*/"loaded",this,this._generateBoundingObject);
		}

		__class(Mesh,'laya.d3.resource.models.Mesh',_super);
		var __proto=Mesh.prototype;
		__proto._generateBoundingObject=function(){
			var pos=this.positions;
			BoundBox.fromPoints(pos,this._boundingBox);
			BoundSphere.fromPoints(pos,this._boundingSphere);
		}

		/**
		*添加子网格（开发者禁止修改）。
		*@param subMesh 子网格。
		*/
		__proto.add=function(subMesh){
			subMesh._indexOfHost=this._subMeshes.length;
			this._subMeshes.push(subMesh);
			this._subMeshCount++;
		}

		/**
		*移除子网格。
		*@param subMesh 子网格。
		*@return 是否成功。
		*/
		__proto.remove=function(subMesh){
			var index=this._subMeshes.indexOf(subMesh);
			if (index < 0)return false;
			this._subMeshes.splice(index,1);
			this._subMeshCount--;
			return true;
		}

		/**
		*获得子网格。
		*@param index 子网格索引。
		*@return 子网格。
		*/
		__proto.getSubMesh=function(index){
			return this._subMeshes[index];
		}

		/**
		*获得子网格数量。
		*@return 子网格数量。
		*/
		__proto.getSubMeshCount=function(){
			return this._subMeshes.length;
		}

		/**
		*清除子网格。
		*@return 子网格。
		*/
		__proto.clear=function(){
			this._subMeshes.length=0;
			this._subMeshCount=0;
			return this;
		}

		/**@private */
		__proto.disableUseFullBone=function(){
			this._useFullBone=false;
		}

		/**
		*@private
		*/
		__proto._addToRenderQuene=function(state,material){
			var o;
			if (material.isSky){
				o=state.scene.getRenderObject(/*laya.d3.core.render.RenderQueue.NONEWRITEDEPTH*/0);
				}else {
				if (!material.transparent || (material.transparent && material.transparentMode===0))
					o=material.cullFace ? state.scene.getRenderObject(/*laya.d3.core.render.RenderQueue.OPAQUE*/1):state.scene.getRenderObject(/*laya.d3.core.render.RenderQueue.OPAQUE_DOUBLEFACE*/2);
				else if (material.transparent && material.transparentMode===1){
					if (material.transparentAddtive)
						o=material.cullFace ? state.scene.getRenderObject(/*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND*/9):state.scene.getRenderObject(/*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE*/10);
					else
					o=material.cullFace ? state.scene.getRenderObject(/*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND*/7):state.scene.getRenderObject(/*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE*/8);
				}
			}
			return o;
		}

		__proto.getRenderElementsCount=function(){
			return this._subMeshes.length;
		}

		__proto.getRenderElement=function(index){
			return this._subMeshes[index];
		}

		/**
		*<p>彻底清理资源。</p>
		*<p><b>注意：</b>会强制解锁清理。</p>
		*/
		__proto.dispose=function(){
			this._resourceManager.removeResource(this);
			laya.resource.Resource.prototype.dispose.call(this);
			for (var i=0;i < this._subMeshes.length;i++)
			this._subMeshes[i].dispose();
			this._subMeshes=null;
			this._subMeshCount=0;
		}

		/**
		*获取网格顶点
		*@return 网格顶点。
		*/
		__getset(0,__proto,'positions',function(){
			var vertices=[];
			var submesheCount=this._subMeshes.length;
			for (var i=0;i < submesheCount;i++){
				var subMesh=this._subMeshes[i];
				var vertexBuffer=subMesh.getVertexBuffer();
				var positionElement;
				var vertexElements=vertexBuffer.vertexDeclaration.getVertexElements();
				var j=0;
				for (j=0;j < vertexElements.length;j++){
					var vertexElement=vertexElements[j];
					if (vertexElement.elementFormat===/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3" && vertexElement.elementUsage===/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"){
						positionElement=vertexElement;
						break ;
					}
				};
				var verticesData=vertexBuffer.getData();
				for (j=0;j < verticesData.length;j+=vertexBuffer.vertexDeclaration.vertexStride / 4){
					var ofset=j+positionElement.offset / 4;
					var position=new Vector3(verticesData[ofset+0],verticesData[ofset+1],verticesData[ofset+2]);
					vertices.push(position);
				}
			}
			return vertices;
		});

		/**
		*获取材质队列。
		*@return 材质队列。
		*/
		__getset(0,__proto,'materials',function(){
			return this._materials;
		});

		/**
		*获取是否已载入。
		*@return 是否已载入。
		*/
		__getset(0,__proto,'loaded',function(){
			return this._loaded;
		});

		Mesh.load=function(url){
			url=URL.formatURL(url);
			var mesh=Resource.meshCache[url];
			if (!mesh){
				mesh=Resource.meshCache[url]=new Mesh(url);
				var loader=new Loader();
				loader.once(/*laya.events.Event.COMPLETE*/"complete",null,function(data){
					new LoadModel(data,mesh,mesh._materials,url);
					mesh._loaded=true;
					mesh.event(/*laya.events.Event.LOADED*/"loaded",mesh);
				});
				loader.load(url,/*laya.net.Loader.BUFFER*/"arraybuffer");
			}
			return mesh;
		}

		return Mesh;
	})(BaseMesh)


	/**
	*@private
	*<code>PrimitiveMesh</code> 类用于创建基本网格的父类。
	*/
	//class laya.d3.resource.models.PrimitiveMesh extends laya.d3.resource.models.BaseMesh
	var PrimitiveMesh=(function(_super){
		function PrimitiveMesh(){
			this._numberVertices=0;
			this._numberIndices=0;
			this._vertexBuffer=null;
			this._indexBuffer=null;
			this._bakedVertexes=null;
			this._bakedIndices=null;
			this._isVertexbaked=false;
			this._indexOfHost=0;
			PrimitiveMesh.__super.call(this);
			this._indexOfHost=0;
		}

		__class(PrimitiveMesh,'laya.d3.resource.models.PrimitiveMesh',_super);
		var __proto=PrimitiveMesh.prototype;
		Laya.imps(__proto,{"laya.d3.core.render.IRenderable":true})
		__proto.getVertexBuffer=function(index){
			(index===void 0)&& (index=0);
			if (index===0)
				return this._vertexBuffer;
			else
			return null;
		}

		__proto.getIndexBuffer=function(){
			return this._indexBuffer;
		}

		/**
		*@private
		*/
		__proto._getShader=function(state,vertexBuffer,material){
			if (!material)
				return null;
			var def=0;
			var shaderAttribute=vertexBuffer.vertexDeclaration.shaderAttribute;
			(shaderAttribute.UV)&& (def |=material.shaderDef);
			(shaderAttribute.COLOR)&& (def |=/*laya.d3.shader.ShaderDefines3D.COLOR*/0x20);
			(state.scene.enableFog)&& (def |=/*laya.d3.shader.ShaderDefines3D.FOG*/0x20000);
			def > 0 && state.shaderDefs.addInt(def);
			var shader=material.getShader(state);
			return shader;
		}

		/**
		*@private
		*/
		__proto._addToRenderQuene=function(state,material){
			var o;
			if (!material.transparent || (material.transparent && material.transparentMode===0))
				o=material.cullFace ? state.scene.getRenderObject(/*laya.d3.core.render.RenderQueue.OPAQUE*/1):state.scene.getRenderObject(/*laya.d3.core.render.RenderQueue.OPAQUE_DOUBLEFACE*/2);
			else if (material.transparent && material.transparentMode===1){
				if (material.transparentAddtive)
					o=material.cullFace ? state.scene.getRenderObject(/*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND*/9):state.scene.getRenderObject(/*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE*/10);
				else
				o=material.cullFace ? state.scene.getRenderObject(/*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND*/7):state.scene.getRenderObject(/*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE*/8);
			}
			return o;
		}

		__proto.getRenderElement=function(index){
			return this;
		}

		__proto.getRenderElementsCount=function(){
			return 1;
		}

		__proto.detoryResource=function(){
			(this._vertexBuffer)&& (this._vertexBuffer.dispose(),this._vertexBuffer=null);
			(this._indexBuffer)&& (this._indexBuffer.dispose(),this._indexBuffer=null);
			this.memorySize=0;
		}

		__proto._render=function(state){
			this._vertexBuffer._bind();
			this._indexBuffer._bind();
			var material=state.renderObj.material;
			if (material){
				var shader=this._getShader(state,this._vertexBuffer,material);
				var presz=state.shaderValue.length;
				state.shaderValue.pushArray(this._vertexBuffer.vertexDeclaration.shaderValues);
				var meshSprite=state.owner;
				var worldMat=meshSprite.transform.getWorldMatrix(-2);
				var worldTransformModifyID=state.renderObj.tag.worldTransformModifyID;
				state.shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.MATRIX1*/"MATRIX1",worldMat.elements,worldTransformModifyID);
				Matrix4x4.multiply(state.projectionViewMatrix,worldMat,state.owner.wvpMatrix);
				state.shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.MVPMATRIX*/"MVPMATRIX",meshSprite.wvpMatrix.elements,state.camera.transform._worldTransformModifyID+worldTransformModifyID+state.camera._projectionMatrixModifyID);
				if (!material.upload(state,null,shader)){
					state.shaderValue.length=presz;
					return false;
				}
				state.shaderValue.length=presz;
			}
			state.context.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,this._numberIndices,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,0);
			Stat.drawCall++;
			Stat.trianglesFaces+=this._numberIndices / 3;
			return true;
		}

		__proto.getBakedVertexs=function(index,transform){
			if (index===0){
				if (this._bakedVertexes)
					return this._bakedVertexes;
				var byteSizeInFloat=4;
				var vb=this._vertexBuffer;
				this._bakedVertexes=(vb.getData().slice());
				var vertexDeclaration=vb.vertexDeclaration;
				var positionOffset=vertexDeclaration.shaderAttribute[ /*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"][4] / byteSizeInFloat;
				var normalOffset=vertexDeclaration.shaderAttribute[ /*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL"][4] / byteSizeInFloat;
				for (var i=0;i < this._bakedVertexes.length;i+=vertexDeclaration.vertexStride / byteSizeInFloat){
					var posOffset=i+positionOffset;
					var norOffset=i+normalOffset;
					Utils3D.transformVector3ArrayToVector3ArrayCoordinate(this._bakedVertexes,posOffset,transform,this._bakedVertexes,posOffset);
					Utils3D.transformVector3ArrayToVector3ArrayCoordinate(this._bakedVertexes,normalOffset,transform,this._bakedVertexes,normalOffset);
				}
				this._isVertexbaked=true;
				return this._bakedVertexes;
			}else
			return null;
		}

		__proto.getBakedIndices=function(){
			if (this._bakedIndices)
				return this._bakedIndices;
			return this._bakedIndices=this._indexBuffer.getData();
		}

		__getset(0,__proto,'VertexBufferCount',function(){
			return 1;
		});

		__getset(0,__proto,'indexOfHost',function(){
			return this._indexOfHost;
		});

		__getset(0,__proto,'triangleCount',function(){
			return this._indexBuffer.indexCount / 3;
		});

		/**
		*获取网格顶点
		*@return 网格顶点。
		*/
		__getset(0,__proto,'positions',function(){
			var vertices=[];
			var positionElement;
			var vertexElements=this._vertexBuffer.vertexDeclaration.getVertexElements();
			var j=0;
			for (j=0;j < vertexElements.length;j++){
				var vertexElement=vertexElements[j];
				if (vertexElement.elementFormat===/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3" && vertexElement.elementUsage===/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"){
					positionElement=vertexElement;
					break ;
				}
			};
			var verticesData=this._vertexBuffer.getData();
			for (j=0;j < verticesData.length;j+=this._vertexBuffer.vertexDeclaration.vertexStride / 4){
				var ofset=j+positionElement.offset / 4;
				var position=new Vector3(verticesData[ofset+0],verticesData[ofset+1],verticesData[ofset+2]);
				vertices.push(position);
			}
			return vertices;
		});

		return PrimitiveMesh;
	})(BaseMesh)


	/**
	*<code>CameraAnimations</code> 类用于创建摄像机动画组件。
	*/
	//class laya.d3.component.animation.CameraAnimations extends laya.d3.component.animation.KeyframeAnimations
	var CameraAnimations=(function(_super){
		function CameraAnimations(){
			this._tempCurAnimationData=null;
			this._lastFrameIndex=-1;
			this._currentTransform=null;
			this._originalAnimationTransform=null;
			this._originalFov=0;
			this._camera=null;
			this._currentAnimationData=null;
			this.localMode=true;
			this.addMode=true;
			this._tempVector30=new Vector3();
			this._tempVector31=new Vector3();
			this._tempVector32=new Vector3();
			CameraAnimations.__super.call(this);
		}

		__class(CameraAnimations,'laya.d3.component.animation.CameraAnimations',_super);
		var __proto=CameraAnimations.prototype;
		/**
		*@private
		*摄像机动画作用函数。
		*/
		__proto._effect=function(){
			var i=0;
			for (i=0;i < 3;i++){
				this._tempVector30.elements[i]=this._currentAnimationData[i];
				this._tempVector31.elements[i]=this._currentAnimationData[i+3];
				this._tempVector32.elements[i]=this._currentAnimationData[i+6];
			}
			this._currentTransform || (this._currentTransform=new Matrix4x4());
			Matrix4x4.createLookAt(this._tempVector30,this._tempVector31,this._tempVector32,this._currentTransform);
			this._currentTransform.invert(this._currentTransform);
			if (this.addMode){
				Matrix4x4.multiply(this._originalAnimationTransform,this._currentTransform,this._currentTransform);
			}
			if (this.localMode)
				this.owner.transform.localMatrix=this._currentTransform;
			else
			this.owner.transform.worldMatrix=this._currentTransform;
			this._camera.fieldOfView=this._currentAnimationData[9];
		}

		/**
		*@private
		*初始化载入摄像机动画组件。
		*@param owner 所属精灵对象。
		*/
		__proto._load=function(owner){
			var _$this=this;
			if ((owner instanceof laya.d3.core.Camera ))
				this._camera=owner;
			else
			throw new Error("该Sprite3D并非Camera");
			this.player.on(/*laya.events.Event.STOPPED*/"stopped",this,function(){
				if (_$this.player.returnToZeroStopped){
					if (_$this.localMode)
						_$this._originalAnimationTransform && (owner.transform.localMatrix=_$this._originalAnimationTransform);
					else
					_$this._originalAnimationTransform && (owner.transform.worldMatrix=_$this._originalAnimationTransform);
					_$this._camera.fieldOfView=_$this._originalFov;
				}
			});
		}

		/**
		*@private
		*更新摄像机动画组件。
		*@param state 渲染状态。
		*/
		__proto._update=function(state){
			this.player.update(state.elapsedTime);
			if (!this._templet || !this._templet.loaded || this.player.State!==/*laya.ani.AnimationState.playing*/2)
				return;
			var rate=this.player.playbackRate *state.scene.timer.scale;
			var frameIndex=(this.player.isCache && rate >=1.0)? this.currentFrameIndex :-1;
			var animationClipIndex=this.currentAnimationClipIndex;
			if (frameIndex!==-1 && this._lastFrameIndex===frameIndex){
				laya.d3.component.Component3D.prototype._update.call(this,state);
				return;
			}
			if (this.player.isCache && rate >=1.0){
				var cache=this._templet.getAnimationDataWithCache(this._templet._animationDatasCache,animationClipIndex,frameIndex);
				if (cache){
					this._currentAnimationData=cache;
					this._lastFrameIndex=frameIndex;
					laya.d3.component.Component3D.prototype._update.call(this,state);
					this._effect();
					return;
				}
			};
			var nodes=this._templet.getNodes(animationClipIndex);
			var nodeCount=nodes.length;
			if (this.player.isCache && rate >=1.0){
				this._currentAnimationData=new Float32Array(nodeCount *10);
				}else{
				(this._tempCurAnimationData)|| (this._tempCurAnimationData=new Float32Array(nodeCount *10));
				this._currentAnimationData=this._tempCurAnimationData;
			}
			if (this.player.isCache && rate >=1.0)
				this._templet.getOriginalData(animationClipIndex,this._currentAnimationData,frameIndex,this.player.currentTime);
			else
			this._templet.getOriginalDataUnfixedRate(animationClipIndex,this._currentAnimationData,this.player.currentTime);
			if (this.player.isCache && rate >=1.0){
				this._templet.setAnimationDataWithCache(this._templet._animationDatasCache,animationClipIndex,frameIndex,this._currentAnimationData);
			}
			this._lastFrameIndex=frameIndex;
			laya.d3.component.Component3D.prototype._update.call(this,state);
			this._effect();
		}

		/**
		*播放动画。
		*@param index 动画索引。
		*@param playbackRate 播放速率。
		*@param duration 播放时长（Number.MAX_VALUE为循环播放，0为1次）。
		*/
		__proto.play=function(index,playbackRate,duration){
			(index===void 0)&& (index=0);
			(playbackRate===void 0)&& (playbackRate=1.0);
			(duration===void 0)&& (duration=Number.MAX_VALUE);
			if (this.player.State===/*laya.ani.AnimationState.stopped*/0){
				(this._originalAnimationTransform)|| (this._originalAnimationTransform=new Matrix4x4());
				this.localMode ? this.owner.transform.localMatrix.cloneTo(this._originalAnimationTransform):this.owner.transform.worldMatrix.cloneTo(this._originalAnimationTransform);
			}
			this._originalFov=this._camera.fieldOfView;
			_super.prototype.play.call(this,index,playbackRate,duration);
		}

		return CameraAnimations;
	})(KeyframeAnimations)


	/**
	*<code>SkinAnimations</code> 类用于创建蒙皮动画组件。
	*/
	//class laya.d3.component.animation.SkinAnimations extends laya.d3.component.animation.KeyframeAnimations
	var SkinAnimations=(function(_super){
		function SkinAnimations(){
			this._tempFrameIndex=-1;
			this._tempIsCache=false;
			this._tempCurBonesData=null;
			this._tempCurAnimationData=null;
			this._curOriginalData=null;
			this._extenData=null;
			this._lastFrameIndex=-1;
			this._curBonesDatas=null;
			this._curAnimationDatas=null;
			this._ownerMesh=null;
			this._subAnimationCacheDatas=null;
			this._subAnimationDatas=null;
			this._subAnimationCacheDatas=[];
			this._subAnimationDatas=[];
			SkinAnimations.__super.call(this);
		}

		__class(SkinAnimations,'laya.d3.component.animation.SkinAnimations',_super);
		var __proto=SkinAnimations.prototype;
		/**
		*@private
		*初始化载入蒙皮动画组件。
		*@param owner 所属精灵对象。
		*/
		__proto._load=function(owner){
			var _$this=this;
			this._ownerMesh=(owner);
			this.player.on(/*laya.events.Event.STOPPED*/"stopped",this,function(){
				_$this._lastFrameIndex=-1;
				if (_$this.player.returnToZeroStopped)
					_$this._curBonesDatas=_$this._curAnimationDatas=null;
			});
		}

		/**
		*@private
		*预缓存帧动画数据（需确保动画模板、模型模板都已加载完成）。
		*@param animationClipIndex 动画索引
		*@param meshTemplet 动画模板
		*/
		__proto.preComputeKeyFrames=function(animationClipIndex){
			var maxKeyFrame=Math.floor(this._templet.getAniDuration(animationClipIndex)/ this.player.cacheFrameRateInterval);
			for (var frameIndex=0;frameIndex <=maxKeyFrame;frameIndex++){
				(this._templet._animationDatasCache[0])|| (this._templet._animationDatasCache[0]=[]);
				(this._templet._animationDatasCache[1])|| (this._templet._animationDatasCache[1]=[]);
				var cacheData=this._templet.getAnimationDataWithCache(this._templet._animationDatasCache[0],animationClipIndex,frameIndex);
				if (cacheData){
					continue ;
				};
				var bones=this._templet.getNodes(animationClipIndex);
				var boneFloatCount=bones.length *16;
				this._curAnimationDatas=new Float32Array(boneFloatCount);
				this._curBonesDatas=new Float32Array(boneFloatCount);
				this._curOriginalData || (this._curOriginalData=new Float32Array(this._templet.getTotalkeyframesLength(animationClipIndex)));
				this._templet.getOriginalData(animationClipIndex,this._curOriginalData,frameIndex,this.player.cacheFrameRateInterval *frameIndex);
				this._extenData || (this._extenData=new Float32Array(this._templet.getPublicExtData()));
				Utils3D._computeSkinAnimationData(bones,this._curOriginalData,this._extenData,this._curBonesDatas,this._curAnimationDatas);
				this._templet.setAnimationDataWithCache(this._templet._animationDatasCache[0],animationClipIndex,frameIndex,this._curAnimationDatas);
				this._templet.setAnimationDataWithCache(this._templet._animationDatasCache[1],animationClipIndex,frameIndex,this._curBonesDatas);
				var mesh=this._ownerMesh.mesh;
				var subMeshCount=mesh.getSubMeshCount();
				for (var j=0;j < subMeshCount;j++){
					var subMesh=mesh.getSubMesh(j);
					var subAnimationData=this._subAnimationCacheDatas[j];
					(subAnimationData)|| (subAnimationData=this._subAnimationCacheDatas[j]=new Array);
					SkinAnimations._copyBoneAndCache(frameIndex,subMesh._boneIndex,this._curAnimationDatas,subAnimationData);
				}
			}
		}

		/**
		*@private
		*更新蒙皮动画组件。
		*@param state 渲染状态参数。
		*/
		__proto._update=function(state){
			this.player.update(state.elapsedTime);
			if (this.player.State!==/*laya.ani.AnimationState.playing*/2 || !this._templet || !this._templet.loaded)
				return;
			var rate=this.player.playbackRate *state.scene.timer.scale;
			var isCache=this._tempIsCache=this.player.isCache && rate >=1.0;
			var frameIndex=this._tempFrameIndex=isCache ? this.currentFrameIndex :-1;
			if (frameIndex!==-1 && this._lastFrameIndex===frameIndex)
				return;
			(this._templet._animationDatasCache[0])|| (this._templet._animationDatasCache[0]=[]);
			(this._templet._animationDatasCache[1])|| (this._templet._animationDatasCache[1]=[]);
			var animationClipIndex=this.currentAnimationClipIndex;
			if (isCache){
				var cacheData=this._templet.getAnimationDataWithCache(this._templet._animationDatasCache[0],animationClipIndex,frameIndex);
				if (cacheData){
					this._curAnimationDatas=cacheData;
					this._curBonesDatas=this._templet.getAnimationDataWithCache(this._templet._animationDatasCache[1],animationClipIndex,frameIndex);
					this._lastFrameIndex=frameIndex;
					return;
				}
			};
			var nodes=this._templet.getNodes(animationClipIndex);
			var nodeFloatCount=nodes.length *16;
			if (isCache){
				this._curAnimationDatas=new Float32Array(nodeFloatCount);
				this._curBonesDatas=new Float32Array(nodeFloatCount);
				}else {
				(this._tempCurAnimationData)|| (this._tempCurAnimationData=new Float32Array(nodeFloatCount));
				(this._tempCurBonesData)|| (this._tempCurBonesData=new Float32Array(nodeFloatCount));
				this._curAnimationDatas=this._tempCurAnimationData;
				this._curBonesDatas=this._tempCurBonesData;
			}
			this._curOriginalData || (this._curOriginalData=new Float32Array(this._templet.getTotalkeyframesLength(animationClipIndex)));
			if (isCache)
				this._templet.getOriginalData(animationClipIndex,this._curOriginalData,frameIndex,this.player.currentFrameTime);
			else
			this._templet.getOriginalDataUnfixedRate(animationClipIndex,this._curOriginalData,this.player.currentTime);
			this._extenData || (this._extenData=new Float32Array(this._templet.getPublicExtData()));
			Utils3D._computeSkinAnimationData(nodes,this._curOriginalData,this._extenData,this._curBonesDatas,this._curAnimationDatas);
			if (isCache){
				this._templet.setAnimationDataWithCache(this._templet._animationDatasCache[0],animationClipIndex,frameIndex,this._curAnimationDatas);
				this._templet.setAnimationDataWithCache(this._templet._animationDatasCache[1],animationClipIndex,frameIndex,this._curBonesDatas);
			}
			this._lastFrameIndex=frameIndex;
		}

		/**
		*@private
		*在渲染前更新蒙皮动画组件渲染参数。
		*@param state 渲染状态参数。
		*/
		__proto._preRenderUpdate=function(state){
			if (this._curAnimationDatas){
				state.shaderDefs.addInt(/*laya.d3.shader.ShaderDefines3D.BONE*/0x200);
				var subMeshIndex=state.renderObj.renderElement.indexOfHost;
				var subMesh=(this._ownerMesh.mesh).getSubMesh(subMeshIndex);
				if (this._tempIsCache){
					var subAnimationCacheData=this._subAnimationCacheDatas[subMeshIndex];
					(subAnimationCacheData)|| (subAnimationCacheData=this._subAnimationCacheDatas[subMeshIndex]=new Array);
					SkinAnimations._copyBoneAndCache(this._tempFrameIndex,subMesh._boneIndex,this._curAnimationDatas,subAnimationCacheData);
					state.shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.MATRIXARRAY0*/"MATRIXARRAY0",subAnimationCacheData[this._tempFrameIndex],-1);
					}else {
					var subAnimationData=this._subAnimationDatas[subMeshIndex];
					(subAnimationData)|| (subAnimationData=this._subAnimationDatas[subMeshIndex]=new Float32Array(subMesh._boneIndex.length *16));
					SkinAnimations._copyBone(subMesh._boneIndex,this._curAnimationDatas,subAnimationData);
					state.shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.MATRIXARRAY0*/"MATRIXARRAY0",subAnimationData,-1);
				}
			}
		}

		/**
		*获取骨骼数据。
		*@return 骨骼数据。
		*/
		__getset(0,__proto,'curBonesDatas',function(){
			return this._curBonesDatas;
		});

		/**
		*获取动画数据。
		*@return 动画数据。
		*/
		__getset(0,__proto,'curAnimationDatas',function(){
			return this._curAnimationDatas;
		});

		/**
		*设置url地址。
		*@param value 地址。
		*/
		__getset(0,__proto,'url',_super.prototype._$get_url,function(value){
			this._curOriginalData=this._extenData=null;
			this._subAnimationCacheDatas.length=0;
			this._subAnimationDatas.length=0;
			_super.prototype._$set_url.call(this,value);
		});

		SkinAnimations._copyBoneAndCache=function(frameIndex,index,bonesData,out){
			var data=out[frameIndex];
			if (!data)
				(data=out[frameIndex]=new Float32Array(index.length *16));
			else
			return;
			for (var i=0,n=index.length,ii=0;i < n;i++){
				for (var j=0;j < 16;j++,ii++){
					data[ii]=bonesData[(index[i] << 4)+j];
				}
			}
		}

		SkinAnimations._copyBone=function(index,bonesData,out){
			for (var i=0,n=index.length,ii=0;i < n;i++){
				for (var j=0;j < 16;j++,ii++){
					out[ii]=bonesData[(index[i] << 4)+j];
				}
			}
		}

		return SkinAnimations;
	})(KeyframeAnimations)


	/**
	*<code>UVAnimations</code> 类用于创建UV动画组件。
	*/
	//class laya.d3.component.animation.UVAnimations extends laya.d3.component.animation.KeyframeAnimations
	var UVAnimations=(function(_super){
		function UVAnimations(){
			this._nodes=null;
			this._lasstInitIndex=-1;
			this._materials=null;
			this._mesh=null;
			this._meshDataInited=false;
			this._uvDatasCount=0;
			this._subMeshIndexToNodeIndex=[];
			this._keyframeAges=[];
			this._ages=[];
			this._bufferUsages=[];
			this._originalShaderAttributes=[];
			this._uvShaderValues=[];
			this._uvNextShaderValues=[];
			this._uvAnimationBuffers=[];
			UVAnimations.__super.call(this);
			this._meshDataInited=false;
		}

		__class(UVAnimations,'laya.d3.component.animation.UVAnimations',_super);
		var __proto=UVAnimations.prototype;
		/**
		*@private
		*初始化Mesh相关数据函数。
		*/
		__proto._initMeshData=function(){
			this._materials=this._mesh.shadredMaterials;
			this._meshDataInited=true;
		}

		/**
		*@private
		*初始化UV动画相关数据函数。
		*/
		__proto._initAnimationData=function(animationIndex){}
		/**
		*@private
		*初始化载入UV动画组件。
		*@param owner 所属精灵对象。
		*/
		__proto._load=function(owner){
			if ((owner instanceof laya.d3.core.MeshSprite3D ))
				this._mesh=owner;
			else
			throw new Error("该Sprite3D并非Mesh");
			owner.on(/*laya.events.Event.LOADED*/"loaded",this,function(mesh){
			});
			this.on(/*laya.events.Event.LOADED*/"loaded",this,function(){
			});
			this.player.on(/*laya.events.Event.PLAYED*/"played",this,function(){
			});
			this.player.on(/*laya.events.Event.STOPPED*/"stopped",this,function(){
			});
		}

		/**
		*@private
		*更新UV动画组件。
		*@param state 渲染状态参数。
		*/
		__proto._update=function(state){
			this.player.update(state.elapsedTime);
			if (!this._templet || !this._templet.loaded || this.player.State!==/*laya.ani.AnimationState.playing*/2)
				return;
			var animationClipIndex=this.currentAnimationClipIndex;
			var unfixedIndexes=this._templet.getNodesCurrentFrameIndex(animationClipIndex,this.player.currentTime);
			for (var i=0;i < this._nodes.length;i++){
				var index=unfixedIndexes[i];
				this._keyframeAges[i]=(this.player.currentTime-this._nodes[i].keyFrame[index].startTime)/ this._nodes[i].keyFrame[index].duration;
				this._ages[i]=this.player.currentTime / this._nodes[i].playTime;
				var subkeyframeWidth=this._nodes[i].keyframeWidth / this._uvDatasCount;
				(this._uvShaderValues[i])|| (this._uvShaderValues[i]=[]);
				(this._uvNextShaderValues[i])|| (this._uvNextShaderValues[i]=[]);
				for (var c=0;c < this._uvDatasCount;c++){
					var uvShaderValue=[2,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,0,(index)*subkeyframeWidth *4];
					var uvNextShaderValue=[2,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,0,(index+1)*subkeyframeWidth *4];
					this._uvShaderValues[i][c]=uvShaderValue;
					this._uvNextShaderValues[i][c]=uvNextShaderValue;
				}
			}
			laya.d3.component.Component3D.prototype._update.call(this,state);
		}

		/**
		*@private
		*在渲染前更新UV动画组件渲染参数。
		*@param state 渲染状态参数。
		*/
		__proto._preRenderUpdate=function(state){}
		return UVAnimations;
	})(KeyframeAnimations)


	/**
	*<code>Scene</code> 类用于实现普通场景。
	*/
	//class laya.d3.core.scene.Scene extends laya.d3.core.scene.BaseScene
	var Scene=(function(_super){
		/**
		*创建一个 <code>Scene</code> 实例。
		*/
		function Scene(){
			Scene.__super.call(this);
		}

		__class(Scene,'laya.d3.core.scene.Scene',_super);
		var __proto=Scene.prototype;
		/**
		*@private
		*/
		__proto.renderSubmit=function(){
			var gl=WebGL.mainContext;
			var state=this._renderState;
			this._set3DRenderConfig(gl);
			(this.currentCamera.clearColor)&& (this._clearColor(gl));
			this._prepareScene(gl,state);
			this.beforeUpate(state);
			this._updateScene(state);
			this.lateUpate(state);
			this.beforeRender(state);
			this._preRenderScene(gl,state);
			var camera=this.currentCamera;
			state.viewMatrix=camera.viewMatrix;
			state.projectionMatrix=camera.projectionMatrix;
			state.projectionViewMatrix=camera.projectionViewMatrix;
			state.viewport=camera.viewport;
			this._renderScene(gl,state);
			this.lateRender(state);
			this._set2DRenderConfig(gl);
			return 1;
		}

		return Scene;
	})(BaseScene)


	/**
	*<code>VRScene</code> 类用于实现VR场景。
	*/
	//class laya.d3.core.scene.VRScene extends laya.d3.core.scene.BaseScene
	var VRScene=(function(_super){
		/**
		*创建一个 <code>VRScene</code> 实例。
		*/
		function VRScene(){
			VRScene.__super.call(this);
		}

		__class(VRScene,'laya.d3.core.scene.VRScene',_super);
		var __proto=VRScene.prototype;
		/**
		*@private
		*/
		__proto.renderSubmit=function(){
			var gl=WebGL.mainContext;
			var state=this._renderState;
			this._set3DRenderConfig(gl);
			(this.currentCamera.clearColor)&& (this._clearColor(gl));
			this._prepareScene(gl,state);
			state.shaderDefs.add(/*laya.d3.shader.ShaderDefines3D.VR*/0x80000);
			this.beforeUpate(state);
			this._updateScene(state);
			this.lateUpate(state);
			this.beforeRender(state);
			this._preRenderScene(gl,state);
			var cameraVR=this.currentCamera;
			state.viewMatrix=cameraVR.leftViewMatrix;
			state.projectionMatrix=cameraVR.leftProjectionMatrix;
			state.projectionViewMatrix=cameraVR.leftProjectionViewMatrix;
			state.viewport=cameraVR.leftViewport;
			this._renderScene(gl,state);
			state.viewMatrix=cameraVR.rightViewMatrix;
			state.projectionMatrix=cameraVR.rightProjectionMatrix;
			state.projectionViewMatrix=cameraVR.rightProjectionViewMatrix;
			state.viewport=cameraVR.rightViewport;
			var preTransformID=cameraVR.transform._worldTransformModifyID;
			cameraVR.transform._worldTransformModifyID=cameraVR.transform._worldTransformModifyID *2;
			this._renderScene(gl,state);
			cameraVR.transform._worldTransformModifyID=preTransformID;
			this.lateRender(state);
			this._set2DRenderConfig(gl);
			return 1;
		}

		return VRScene;
	})(BaseScene)


	/**
	*<code>Camera</code> 类用于创建普通摄像机。
	*/
	//class laya.d3.core.Camera extends laya.d3.core.BaseCamera
	var Camera=(function(_super){
		function Camera(aspectRatio,nearPlane,farPlane){
			//this._aspectRatio=NaN;
			//this._viewport=null;
			//this._normalizedViewport=null;
			//this._viewMatrix=null;
			//this._projectionMatrix=null;
			//this._projectionViewMatrix=null;
			(aspectRatio===void 0)&& (aspectRatio=0);
			(nearPlane===void 0)&& (nearPlane=0.1);
			(farPlane===void 0)&& (farPlane=1000);
			this._viewMatrix=new Matrix4x4();
			this._projectionMatrix=new Matrix4x4();
			this._projectionViewMatrix=new Matrix4x4();
			this._viewport=new Viewport(0,0,0,0);
			this._normalizedViewport=new Viewport(0,0,1,1);
			this._aspectRatio=aspectRatio;
			Camera.__super.call(this,nearPlane,farPlane);
		}

		__class(Camera,'laya.d3.core.Camera',_super);
		var __proto=Camera.prototype;
		/**
		*@private
		*计算投影矩阵。
		*/
		__proto._calculateProjectionMatrix=function(){
			if (!this._useUserProjectionMatrix){
				if (this.orthographicProjection){
					var halfWidth=this.orthographicVerticalSize *this.aspectRatio *0.5;
					var halfHeight=this.orthographicVerticalSize *0.5;
					Matrix4x4.createOrthogonal(-halfWidth,halfWidth,-halfHeight,halfHeight,this.nearPlane,this.farPlane,this._projectionMatrix);
					}else {
					Matrix4x4.createPerspective(3.1416 *this.fieldOfView / 180.0,this.aspectRatio,this.nearPlane,this.farPlane,this._projectionMatrix);
				}
			}
			this._projectionMatrixModifyID+=0.01 / this.id;
		}

		/**
		*计算从屏幕空间生成的射线。
		*@param point 屏幕空间的位置位置。
		*@return out 输出射线。
		*/
		__proto.viewportPointToRay=function(point,out){
			Picker.calculateCursorRay(point,this.viewport,this._projectionMatrix,this.viewMatrix,null,out);
		}

		/**
		*计算从裁切空间生成的射线。
		*@param point 裁切空间的位置。。
		*@return out 输出射线。
		*/
		__proto.normalizedViewportPointToRay=function(point,out){
			var finalPoint=Camera._tempVector2;
			var vp=this.viewport;
			var nVpPosE=point.elements;
			var vpPosE=finalPoint.elements;
			vpPosE[0]=nVpPosE[0] *vp.width;
			vpPosE[1]=nVpPosE[1] *vp.height;
			Picker.calculateCursorRay(finalPoint,this.viewport,this._projectionMatrix,this.viewMatrix,null,out);
		}

		/**
		*设置横纵比。
		*@param value 横纵比。
		*/
		/**
		*获取横纵比。
		*@return 横纵比。
		*/
		__getset(0,__proto,'aspectRatio',function(){
			if (this._aspectRatio===0){
				var vp=this.viewport;
				return vp.width / vp.height;
			}
			return this._aspectRatio;
			},function(value){
			if (value < 0)
				throw new Error("Camera: the aspect ratio has to be a positive real number.");
			this._aspectRatio=value;
			this._calculateProjectionMatrix();
		});

		/**
		*设置裁剪空间的视口。
		*@return 裁剪空间的视口。
		*/
		/**
		*获取裁剪空间的视口。
		*@return 裁剪空间的视口。
		*/
		__getset(0,__proto,'normalizedViewport',function(){
			if (!this._viewportExpressedInClipSpace){
				var vp=this._viewport;
				var size=this.renderTargetSize;
				var sizeW=size.width;
				var sizeH=size.height;
				this._normalizedViewport.x=vp.x / sizeW;
				this._normalizedViewport.y=vp.y / sizeH;
				this._normalizedViewport.width=vp.width / sizeW;
				this._normalizedViewport.height=vp.height / sizeH;
			}
			return this._normalizedViewport;
			},function(value){
			if (value.x < 0 || value.y < 0 || (value.x+value.width)> 1 || (value.x+value.height)> 1)
				throw new Error("Camera: viewport size invalid.","value");
			this._viewportExpressedInClipSpace=true;
			this._normalizedViewport=value;
			this._calculateProjectionMatrix();
		});

		/**
		*设置屏幕空间的视口。
		*@param 屏幕空间的视口。
		*/
		/**
		*获取屏幕空间的视口。
		*@return 屏幕空间的视口。
		*/
		__getset(0,__proto,'viewport',function(){
			if (this._viewportExpressedInClipSpace){
				var nVp=this._normalizedViewport;
				var size=this.renderTargetSize;
				var sizeW=size.width;
				var sizeH=size.height;
				this._viewport.x=nVp.x *sizeW;
				this._viewport.y=nVp.y *sizeH;
				this._viewport.width=nVp.width *sizeW;
				this._viewport.height=nVp.height *sizeH;
			}
			return this._viewport;
			},function(value){
			if (this.renderTarget !=null && (value.x < 0 || value.y < 0 || value.width==0 || value.height==0))
				throw new Error("Camera: viewport size invalid.","value");
			this._viewportExpressedInClipSpace=false;
			this._viewport=value;
			this._calculateProjectionMatrix();
		});

		__getset(0,__proto,'needViewport',function(){
			var nVp=this.normalizedViewport;
			return nVp.x===0 && nVp.y===0 && nVp.width===1 && nVp.height===1;
		});

		/**
		*获取视图矩阵。
		*@return 视图矩阵。
		*/
		__getset(0,__proto,'viewMatrix',function(){
			this.transform.worldMatrix.invert(this._viewMatrix);
			return this._viewMatrix;
		});

		/**设置投影矩阵。*/
		/**获取投影矩阵。*/
		__getset(0,__proto,'projectionMatrix',function(){
			return this._projectionMatrix;
			},function(value){
			this._projectionMatrix=value;
			this._useUserProjectionMatrix=true;
		});

		/**
		*获取视图投影矩阵。
		*@return 视图投影矩阵。
		*/
		__getset(0,__proto,'projectionViewMatrix',function(){
			Matrix4x4.multiply(this.projectionMatrix,this.viewMatrix,this._projectionViewMatrix);
			return this._projectionViewMatrix;
		});

		__static(Camera,
		['_tempVector2',function(){return this._tempVector2=new Vector2();}
		]);
		return Camera;
	})(BaseCamera)


	/**
	*<code>DirectionLight</code> 类用于创建平行光。
	*/
	//class laya.d3.core.light.DirectionLight extends laya.d3.core.light.LightSprite
	var DirectionLight=(function(_super){
		function DirectionLight(){
			this._direction=null;
			DirectionLight.__super.call(this);
			this._diffuseColor=new Vector3(1.0,1.0,1.0);
			this._ambientColor=new Vector3(0.6,0.6,0.6);
			this._specularColor=new Vector3(1.0,1.0,1.0);
			this._reflectColor=new Vector3(1.0,1.0,1.0);
			this._direction=new Vector3(0.0,-0.5,-1.0);
		}

		__class(DirectionLight,'laya.d3.core.light.DirectionLight',_super);
		var __proto=DirectionLight.prototype;
		/**
		*更新平行光相关渲染状态参数。
		*@param state 渲染状态参数。
		*/
		__proto.updateToWorldState=function(state){
			if (state.scene.enableLight){
				var shaderValue=state.worldShaderValue;
				var loopCount=Stat.loopCount;
				state.shaderDefs.add(/*laya.d3.shader.ShaderDefines3D.DIRECTIONLIGHT*/0x40);
				shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.LIGHTDIRDIFFUSE*/"LIGHTDIRDIFFUSE",this.diffuseColor.elements,loopCount);
				shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.LIGHTDIRAMBIENT*/"LIGHTDIRAMBIENT",this.ambientColor.elements,loopCount);
				shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.LIGHTDIRSPECULAR*/"LIGHTDIRSPECULAR",this.specularColor.elements,loopCount);
				shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.LIGHTDIRECTION*/"LIGHTDIRECTION",this.direction.elements,loopCount);
			}
		}

		/**
		*设置平行光的方向。
		*@param value 平行光的方向。
		*/
		/**
		*获取平行光的方向。
		*@return 平行光的方向。
		*/
		__getset(0,__proto,'direction',function(){
			return this._direction;
			},function(value){
			this._direction=value;
		});

		/**
		*获取平行光的类型。
		*@return 平行光的类型。
		*/
		__getset(0,__proto,'lightType',function(){
			return 1;
		});

		return DirectionLight;
	})(LightSprite)


	/**
	*<code>PointLight</code> 类用于创建点光。
	*/
	//class laya.d3.core.light.PointLight extends laya.d3.core.light.LightSprite
	var PointLight=(function(_super){
		function PointLight(){
			this._attenuation=null;
			this._range=NaN;
			PointLight.__super.call(this);
			this._diffuseColor=new Vector3(1.0,1.0,1.0);
			this._ambientColor=new Vector3(0.2,0.2,0.2);
			this._specularColor=new Vector3(1.0,0.0,0.0);
			this._reflectColor=new Vector3(1.0,1.0,1.0);
			this.transform.position=new Vector3(0.0,0.0,0.0);
			this._range=6.0;
			this._attenuation=new Vector3(0.6,0.6,0.6);
		}

		__class(PointLight,'laya.d3.core.light.PointLight',_super);
		var __proto=PointLight.prototype;
		/**
		*更新点光相关渲染状态参数。
		*@param state 渲染状态参数。
		*/
		__proto.updateToWorldState=function(state){
			if (state.scene.enableLight){
				var shaderValue=state.worldShaderValue;
				var loopCount=Stat.loopCount;
				state.shaderDefs.add(/*laya.d3.shader.ShaderDefines3D.POINTLIGHT*/0x80);
				shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.POINTLIGHTDIFFUSE*/"POINTLIGHTDIFFUSE",this.diffuseColor.elements,loopCount);
				shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.POINTLIGHTAMBIENT*/"POINTLIGHTAMBIENT",this.ambientColor.elements,loopCount);
				shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.POINTLIGHTSPECULAR*/"POINTLIGHTSPECULAR",this.specularColor.elements,loopCount);
				shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.POINTLIGHTPOS*/"POINTLIGHTPOS",this.transform.position.elements,loopCount);
				shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.POINTLIGHTRANGE*/"POINTLIGHTRANGE",this.range,loopCount);
				shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.POINTLIGHTATTENUATION*/"POINTLIGHTATTENUATION",this.attenuation.elements,loopCount);
			}
		}

		/**
		*设置点光的范围。
		*@param value 点光的范围。
		*/
		/**
		*获取点光的范围。
		*@return 点光的范围。
		*/
		__getset(0,__proto,'range',function(){
			return this._range;
			},function(value){
			this._range=value;
		});

		/**
		*设置点光的衰减。
		*@param value 点光的衰减。
		*/
		/**
		*获取点光的衰减。
		*@return 点光的衰减。
		*/
		__getset(0,__proto,'attenuation',function(){
			return this._attenuation;
			},function(value){
			this._attenuation=value;
		});

		/**
		*获取点光的类型。
		*@return 点光的类型。
		*/
		__getset(0,__proto,'lightType',function(){
			return 2;
		});

		return PointLight;
	})(LightSprite)


	/**
	*<code>SpotLight</code> 类用于创建聚光。
	*/
	//class laya.d3.core.light.SpotLight extends laya.d3.core.light.LightSprite
	var SpotLight=(function(_super){
		function SpotLight(){
			this._direction=null;
			this._attenuation=null;
			this._spot=NaN;
			this._range=NaN;
			SpotLight.__super.call(this);
			this._diffuseColor=new Vector3(1.0,1.0,1.0);
			this._ambientColor=new Vector3(0.2,0.2,0.2);
			this._specularColor=new Vector3(1.0,1.0,1.0);
			this._reflectColor=new Vector3(1.0,1.0,1.0);
			this.transform.position=new Vector3(0.0,1.0,1.0);
			this._direction=new Vector3(0.0,-1.0,-1.0);
			this._attenuation=new Vector3(0.6,0.6,0.6);
			this._spot=96.0;
			this._range=6.0;
		}

		__class(SpotLight,'laya.d3.core.light.SpotLight',_super);
		var __proto=SpotLight.prototype;
		/**
		*更新聚光相关渲染状态参数。
		*@param state 渲染状态参数。
		*/
		__proto.updateToWorldState=function(state){
			if (state.scene.enableLight){
				var shaderValue=state.worldShaderValue;
				var loopCount=Stat.loopCount;
				state.shaderDefs.add(/*laya.d3.shader.ShaderDefines3D.SPOTLIGHT*/0x100);
				shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.SPOTLIGHTDIFFUSE*/"SPOTLIGHTDIFFUSE",this.diffuseColor.elements,loopCount);
				shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.SPOTLIGHTAMBIENT*/"SPOTLIGHTAMBIENT",this.ambientColor.elements,loopCount);
				shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.SPOTLIGHTSPECULAR*/"SPOTLIGHTSPECULAR",this.specularColor.elements,loopCount);
				shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.SPOTLIGHTPOS*/"SPOTLIGHTPOS",this.transform.position.elements,loopCount);
				shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.SPOTLIGHTDIRECTION*/"SPOTLIGHTDIRECTION",this.direction.elements,loopCount);
				shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.SPOTLIGHTRANGE*/"SPOTLIGHTRANGE",this.range,loopCount);
				shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.SPOTLIGHTSPOT*/"SPOTLIGHTSPOT",this.spot,loopCount);
				shaderValue.pushValue(/*laya.webgl.utils.Buffer2D.SPOTLIGHTATTENUATION*/"SPOTLIGHTATTENUATION",this.attenuation.elements,loopCount);
			}
		}

		/**
		*设置聚光的方向。
		*@param value 聚光的方向。
		*/
		/**
		*获取聚光的方向。
		*@return 聚光的方向。
		*/
		__getset(0,__proto,'direction',function(){
			return this._direction;
			},function(value){
			this._direction=value;
		});

		/**
		*设置聚光的衰减。
		*@param value 聚光的衰减。
		*/
		/**
		*获取聚光的衰减。
		*@return 聚光的衰减。
		*/
		__getset(0,__proto,'attenuation',function(){
			return this._attenuation;
			},function(value){
			this._attenuation=value;
		});

		/**
		*设置聚光的聚光值。
		*@param value 聚光的聚光值。
		*/
		/**
		*获取聚光的聚光值。
		*@return 聚光的聚光值。
		*/
		__getset(0,__proto,'spot',function(){
			return this._spot;
			},function(value){
			this._spot=value;
		});

		/**
		*设置聚光的范围。
		*@param value 聚光的范围值。
		*/
		/**
		*获取聚光的范围。
		*@return 聚光的范围值。
		*/
		__getset(0,__proto,'range',function(){
			return this._range;
			},function(value){
			this._range=value;
		});

		/**
		*获取聚光的类型。
		*@return 聚光的类型。
		*/
		__getset(0,__proto,'lightType',function(){
			return 3;
		});

		return SpotLight;
	})(LightSprite)


	/**
	*<code>TerrainMeshSprite3D</code> 类用于创建网格。
	*/
	//class laya.d3.core.MeshTerrainSprite3D extends laya.d3.core.MeshSprite3D
	var MeshTerrainSprite3D=(function(_super){
		function MeshTerrainSprite3D(mesh,heightMapWidth,heightMapHeight,name){
			this._heightMapWidth=NaN;
			this._heightMapHeight=NaN;
			this._minX=NaN;
			this._minZ=NaN;
			this._cellSize=null;
			this._heightMap=null;
			MeshTerrainSprite3D.__super.call(this,mesh,name);
			this._cellSize=new Vector2();
			this._heightMapWidth=heightMapWidth;
			this._heightMapHeight=heightMapHeight;
			if (mesh.loaded)
				this._init();
			else
			mesh.once(/*laya.events.Event.LOADED*/"loaded",this,this._init);
		}

		__class(MeshTerrainSprite3D,'laya.d3.core.MeshTerrainSprite3D',_super);
		var __proto=MeshTerrainSprite3D.prototype;
		/**
		*@private
		*/
		__proto._disableRotation=function(){
			var rotation=this.transform.rotation;
			rotation.elements[0]=0;
			rotation.elements[1]=0;
			rotation.elements[2]=0;
			rotation.elements[3]=1;
			this.transform.rotation=rotation;
		}

		/**
		*@private
		*/
		__proto._getScaleX=function(){
			var worldMat=this.transform.worldMatrix;
			var worldMatE=worldMat.elements;
			var m11=worldMatE[0];
			var m12=worldMatE[1];
			var m13=worldMatE[2];
			return Math.sqrt((m11 *m11)+(m12 *m12)+(m13 *m13));
		}

		/**
		*@private
		*/
		__proto._getScaleZ=function(){
			var worldMat=this.transform.worldMatrix;
			var worldMatE=worldMat.elements;
			var m31=worldMatE[8];
			var m32=worldMatE[9];
			var m33=worldMatE[10];
			return Math.sqrt((m31 *m31)+(m32 *m32)+(m33 *m33));
		}

		/**
		*@private
		*/
		__proto._init=function(){;
			this._heightMap=HeightMap.creatFromMesh(this.mesh,this._heightMapWidth,this._heightMapHeight,this._cellSize);
			var boundingBox=this.mesh.boundingBox;
			var min=boundingBox.min;
			var max=boundingBox.max;
			this._minX=min.x;
			this._minZ=min.z;
		}

		/**
		*@private
		*/
		__proto._update=function(state){
			this._disableRotation();
			_super.prototype._update.call(this,state);
		}

		/**
		*获取地形高度。
		*@param x X轴坐标。
		*@param z Z轴坐标。
		*/
		__proto.getHeight=function(x,z){
			MeshTerrainSprite3D._tempVector3.elements[0]=x;
			MeshTerrainSprite3D._tempVector3.elements[1]=0;
			MeshTerrainSprite3D._tempVector3.elements[2]=z;
			this._disableRotation();
			var worldMat=this.transform.worldMatrix;
			worldMat.invert(MeshTerrainSprite3D._tempMatrix4x4);
			Vector3.transformCoordinate(MeshTerrainSprite3D._tempVector3,MeshTerrainSprite3D._tempMatrix4x4,MeshTerrainSprite3D._tempVector3);
			x=MeshTerrainSprite3D._tempVector3.elements[0];
			z=MeshTerrainSprite3D._tempVector3.elements[2];
			var c=(x-this._minX)/ this._cellSize.x;
			var d=(z-this._minZ)/ this._cellSize.y;
			var row=Math.floor(d);
			var col=Math.floor(c);
			var s=c-col;
			var t=d-row;
			var uy=NaN;
			var vy=NaN;
			var worldMatE=worldMat.elements;
			var m21=worldMatE[4];
			var m22=worldMatE[5];
			var m23=worldMatE[6];
			var scaleY=Math.sqrt((m21 *m21)+(m22 *m22)+(m23 *m23));
			var translateY=worldMatE[13];
			var h01=this._heightMap.getHeight(row,col+1);
			var h10=this._heightMap.getHeight((row+1),col);
			h01=isNaN(h01)? 0 :h01;
			h10=isNaN(h10)? 0 :h10;
			if (s+t <=1.0){
				var h00=this._heightMap.getHeight(row,col);
				h00=isNaN(h00)? 0 :h00;
				uy=h01-h00;
				vy=h10-h00;
				return (h00+s *uy+t *vy)*scaleY+translateY;
				}else {
				var h11=this._heightMap.getHeight((row+1),col+1);
				h11=isNaN(h11)? 0 :h11;
				uy=h10-h11;
				vy=h01-h11;
				return (h11+(1.0-s)*uy+(1.0-t)*vy)*scaleY+translateY;
			}
		}

		/**
		*获取地形X轴最小位置。
		*@return 地形X轴最小位置。
		*/
		__getset(0,__proto,'minX',function(){
			var worldMat=this.transform.worldMatrix;
			var worldMatE=worldMat.elements;
			return this._minX *this._getScaleX()+worldMatE[12];
		});

		/**
		*获取地形Z轴最小位置。
		*@return 地形X轴最小位置。
		*/
		__getset(0,__proto,'minZ',function(){
			var worldMat=this.transform.worldMatrix;
			var worldMatE=worldMat.elements;
			return this._minZ *this._getScaleZ()+worldMatE[14];
		});

		/**
		*获取地形X轴长度。
		*@return 地形X轴长度。
		*/
		__getset(0,__proto,'width',function(){
			return (this._heightMap.width-1)*this._cellSize.x *this._getScaleX();
		});

		/**
		*获取地形Z轴长度。
		*@return 地形Z轴长度。
		*/
		__getset(0,__proto,'depth',function(){
			return (this._heightMap.height-1)*this._cellSize.y *this._getScaleZ();
		});

		__static(MeshTerrainSprite3D,
		['_tempVector3',function(){return this._tempVector3=new Vector3();},'_tempMatrix4x4',function(){return this._tempMatrix4x4=new Matrix4x4();}
		]);
		return MeshTerrainSprite3D;
	})(MeshSprite3D)


	/**
	*<code>Camera</code> 类用于创建VR摄像机。
	*/
	//class laya.d3.core.VRCamera extends laya.d3.core.BaseCamera
	var VRCamera=(function(_super){
		function VRCamera(pupilDistande,leftAspectRatio,rightAspectRatio,nearPlane,farPlane){
			//this._tempMatrix=null;
			//this._leftAspectRatio=NaN;
			//this._leftViewport=null;
			//this._leftNormalizedViewport=null;
			//this._leftViewMatrix=null;
			//this._leftProjectionMatrix=null;
			//this._leftProjectionViewMatrix=null;
			//this._rightAspectRatio=NaN;
			//this._rightViewport=null;
			//this._rightNormalizedViewport=null;
			//this._rightViewMatrix=null;
			//this._rightProjectionMatrix=null;
			//this._rightProjectionViewMatrix=null;
			//this._pupilDistande=0;
			(pupilDistande===void 0)&& (pupilDistande=0.1);
			(leftAspectRatio===void 0)&& (leftAspectRatio=0);
			(rightAspectRatio===void 0)&& (rightAspectRatio=0);
			(nearPlane===void 0)&& (nearPlane=0.1);
			(farPlane===void 0)&& (farPlane=1000);
			this._tempMatrix=new Matrix4x4();
			this._leftViewMatrix=new Matrix4x4();
			this._leftProjectionMatrix=new Matrix4x4();
			this._leftProjectionViewMatrix=new Matrix4x4();
			this._leftViewport=new Viewport(0,0,0,0);
			this._leftNormalizedViewport=new Viewport(0,0,0.5,1);
			this._leftAspectRatio=leftAspectRatio;
			this._rightViewMatrix=new Matrix4x4();
			this._rightProjectionMatrix=new Matrix4x4();
			this._rightProjectionViewMatrix=new Matrix4x4();
			this._rightViewport=new Viewport(0,0,0,0);
			this._rightNormalizedViewport=new Viewport(0.5,0,0.5,1);
			this._rightAspectRatio=rightAspectRatio;
			this._pupilDistande=pupilDistande;
			VRCamera.__super.call(this,nearPlane,farPlane);
		}

		__class(VRCamera,'laya.d3.core.VRCamera',_super);
		var __proto=VRCamera.prototype;
		/**
		*@private
		*计算瞳距。
		*/
		__proto._calculatePupilOffset=function(){
			var offset=this._tempVector3;
			Vector3.scale(this.right,this._pupilDistande / 2,offset);
			return offset.elements;
		}

		/**
		*@private
		*计算左投影矩阵。
		*/
		__proto._calculateLeftProjectionMatrix=function(){
			if (!this._useUserProjectionMatrix){
				if (this.orthographicProjection){
					var leftHalfWidth=this.orthographicVerticalSize *this.leftAspectRatio *0.5;
					var leftHalfHeight=this.orthographicVerticalSize *0.5;
					Matrix4x4.createOrthogonal(-leftHalfWidth,leftHalfWidth,-leftHalfHeight,leftHalfHeight,this.nearPlane,this.farPlane,this._leftProjectionMatrix);
					}else {
					Matrix4x4.createPerspective(3.1416 *this.fieldOfView / 180.0,this.leftAspectRatio,this.nearPlane,this.farPlane,this._rightProjectionMatrix);
				}
			}
			this._projectionMatrixModifyID+=0.01 / this.id;
		}

		/**
		*@private
		*计算右投影矩阵。
		*/
		__proto._calculateRightProjectionMatrix=function(){
			if (!this._useUserProjectionMatrix){
				if (this.orthographicProjection){
					var rightHalfWidth=this.orthographicVerticalSize *this.rightAspectRatio *0.5;
					var rightHalfHeight=this.orthographicVerticalSize *0.5;
					Matrix4x4.createOrthogonal(-rightHalfWidth,rightHalfWidth,rightHalfHeight,rightHalfHeight,this.nearPlane,this.farPlane,this._rightProjectionMatrix);
					}else {
					Matrix4x4.createPerspective(3.1416 *this.fieldOfView / 180.0,this.rightAspectRatio,this.nearPlane,this.farPlane,this._rightProjectionMatrix);
				}
			}
			this._projectionMatrixModifyID+=0.01 / this.id;
		}

		/**
		*@private
		*计算投影矩阵。
		*/
		__proto._calculateProjectionMatrix=function(){
			if (!this._useUserProjectionMatrix){
				if (this.orthographicProjection){
					var leftHalfWidth=this.orthographicVerticalSize *this.leftAspectRatio *0.5;
					var leftHalfHeight=this.orthographicVerticalSize *0.5;
					var rightHalfWidth=this.orthographicVerticalSize *this.rightAspectRatio *0.5;
					var rightHalfHeight=this.orthographicVerticalSize *0.5;
					Matrix4x4.createOrthogonal(-leftHalfWidth,leftHalfWidth,-leftHalfHeight,leftHalfHeight,this.nearPlane,this.farPlane,this._leftProjectionMatrix);
					Matrix4x4.createOrthogonal(-rightHalfWidth,rightHalfWidth,rightHalfHeight,rightHalfHeight,this.nearPlane,this.farPlane,this._rightProjectionMatrix);
					}else {
					Matrix4x4.createPerspective(3.1416 *this.fieldOfView / 180.0,this.leftAspectRatio,this.nearPlane,this.farPlane,this._leftProjectionMatrix);
					Matrix4x4.createPerspective(3.1416 *this.fieldOfView / 180.0,this.rightAspectRatio,this.nearPlane,this.farPlane,this._rightProjectionMatrix);
				}
			}
			this._projectionMatrixModifyID+=0.01 / this.id;
		}

		/**
		*设置横纵比。
		*@param value 横纵比。
		*/
		__getset(0,__proto,'aspectRatio',null,function(value){
			if (value < 0)
				throw new Error("VRCamera: the aspect ratio has to be a positive real number.");
			this._leftAspectRatio=value;
			this._rightAspectRatio=value;
			this._calculateRightProjectionMatrix();
		});

		/**
		*设置裁剪空间的视口。
		*@return 裁剪空间的视口。
		*/
		__getset(0,__proto,'normalizedViewport',null,function(value){
			if (value.x < 0 || value.y < 0 || (value.x+value.width)> 1 || (value.x+value.height)> 1)
				throw new Error("VRCamera: viewport size invalid.","value");
			this._viewportExpressedInClipSpace=true;
			this._leftNormalizedViewport=new Viewport(0,0,value.width / 2,value.height);
			this._rightNormalizedViewport=new Viewport(value.width / 2,0,value.width / 2,value.height);
			this._calculateProjectionMatrix();
		});

		/**
		*获取左横纵比。
		*@return 左横纵比。
		*/
		__getset(0,__proto,'leftAspectRatio',function(){
			if (this._leftAspectRatio===0){
				var lVp=this.leftViewport;
				return lVp.width / lVp.height;
			}
			return this._leftAspectRatio;
		});

		/**
		*获取右投影视图矩阵。
		*@return 右投影视图矩阵。
		*/
		__getset(0,__proto,'rightProjectionViewMatrix',function(){
			Matrix4x4.multiply(this.rightProjectionMatrix,this.rightViewMatrix,this._rightProjectionViewMatrix);
			return this._rightProjectionViewMatrix;
		});

		/**
		*设置屏幕空间的视口。
		*@param 屏幕空间的视口。
		*/
		__getset(0,__proto,'viewport',null,function(value){
			if (this.renderTarget !=null && (value.x < 0 || value.y < 0 || value.width==0 || value.height==0))
				throw new Error("VRCamera: viewport size invalid.","value");
			this._viewportExpressedInClipSpace=false;
			this._leftViewport=new Viewport(0,0,value.width / 2,value.height);
			this._rightViewport=new Viewport(value.width / 2,0,value.width / 2,value.height);
			this._calculateProjectionMatrix();
		});

		/**
		*获取屏幕空间的左视口。
		*@return 屏幕空间的左视口。
		*/
		__getset(0,__proto,'leftViewport',function(){
			if (this._viewportExpressedInClipSpace){
				var nVp=this._leftNormalizedViewport;
				var size=this.renderTargetSize;
				var sizeW=size.width;
				var sizeH=size.height;
				this._leftViewport.x=nVp.x *sizeW;
				this._leftViewport.y=nVp.y *sizeH;
				this._leftViewport.width=nVp.width *sizeW;
				this._leftViewport.height=nVp.height *sizeH;
			}
			return this._leftViewport;
		});

		/**
		*获取裁剪空间的右视口。
		*@return 裁剪空间的右视口。
		*/
		__getset(0,__proto,'rightNormalizedViewport',function(){
			if (!this._viewportExpressedInClipSpace){
				var vp=this._rightViewport;
				var size=this.renderTargetSize;
				var sizeW=size.width;
				var sizeH=size.height;
				this._rightNormalizedViewport.x=vp.x / sizeW;
				this._rightNormalizedViewport.y=vp.y / sizeH;
				this._rightNormalizedViewport.width=vp.width / sizeW;
				this._rightNormalizedViewport.height=vp.height / sizeH;
			}
			return this._rightNormalizedViewport;
		});

		/**
		*获取右横纵比。
		*@return 右横纵比。
		*/
		__getset(0,__proto,'rightAspectRatio',function(){
			if (this._rightAspectRatio===0){
				var rVp=this.rightViewport;
				return rVp.width / rVp.height;
			}
			return this._rightAspectRatio;
		});

		/**
		*获取屏幕空间的右视口。
		*@return 屏幕空间的右视口。
		*/
		__getset(0,__proto,'rightViewport',function(){
			if (this._viewportExpressedInClipSpace){
				var nVp=this._rightNormalizedViewport;
				var size=this.renderTargetSize;
				var sizeW=size.width;
				var sizeH=size.height;
				this._rightViewport.x=nVp.x *sizeW;
				this._rightViewport.y=nVp.y *sizeH;
				this._rightViewport.width=nVp.width *sizeW;
				this._rightViewport.height=nVp.height *sizeH;
			}
			return this._rightViewport;
		});

		/**
		*获取裁剪空间的左视口。
		*@return 裁剪空间的左视口。
		*/
		__getset(0,__proto,'leftNormalizedViewport',function(){
			if (!this._viewportExpressedInClipSpace){
				var vp=this._leftViewport;
				var size=this.renderTargetSize;
				var sizeW=size.width;
				var sizeH=size.height;
				this._leftNormalizedViewport.x=vp.x / sizeW;
				this._leftNormalizedViewport.y=vp.y / sizeH;
				this._leftNormalizedViewport.width=vp.width / sizeW;
				this._leftNormalizedViewport.height=vp.height / sizeH;
			}
			return this._leftNormalizedViewport;
		});

		__getset(0,__proto,'needLeftViewport',function(){
			var nVp=this.leftNormalizedViewport;
			return nVp.x===0 && nVp.y===0 && nVp.width===1 && nVp.height===1;
		});

		__getset(0,__proto,'needRightViewport',function(){
			var nVp=this.rightNormalizedViewport;
			return nVp.x===0 && nVp.y===0 && nVp.width===1 && nVp.height===1;
		});

		/**
		*获取左视图矩阵。
		*@return 左视图矩阵。
		*/
		__getset(0,__proto,'leftViewMatrix',function(){
			var offsetE=this._calculatePupilOffset();
			var tempWorldMat=this._tempMatrix;
			this.transform.worldMatrix.cloneTo(tempWorldMat);
			var worldMatE=tempWorldMat.elements;
			worldMatE[12]-=offsetE[0];
			worldMatE[13]-=offsetE[1];
			worldMatE[14]-=offsetE[2];
			tempWorldMat.invert(this._leftViewMatrix);
			return this._leftViewMatrix;
		});

		/**
		*获取右视图矩阵。
		*@return 右视图矩阵。
		*/
		__getset(0,__proto,'rightViewMatrix',function(){
			var offsetE=this._calculatePupilOffset();
			var tempWorldMat=this._tempMatrix;
			this.transform.worldMatrix.cloneTo(tempWorldMat);
			var worldMatE=tempWorldMat.elements;
			worldMatE[12]+=offsetE[0];
			worldMatE[13]+=offsetE[1];
			worldMatE[14]+=offsetE[2];
			tempWorldMat.invert(this._rightViewMatrix);
			return this._rightViewMatrix;
		});

		/**
		*获取左投影矩阵。
		*@return 左投影矩阵。
		*/
		__getset(0,__proto,'leftProjectionMatrix',function(){
			return this._leftProjectionMatrix;
		});

		/**
		*获取右投影矩阵。
		*@return 右投影矩阵。
		*/
		__getset(0,__proto,'rightProjectionMatrix',function(){
			return this._rightProjectionMatrix;
		});

		/**
		*获取左投影视图矩阵。
		*@return 左投影视图矩阵。
		*/
		__getset(0,__proto,'leftProjectionViewMatrix',function(){
			Matrix4x4.multiply(this.leftProjectionMatrix,this.leftViewMatrix,this._leftProjectionViewMatrix);
			return this._leftProjectionViewMatrix;
		});

		return VRCamera;
	})(BaseCamera)


	/**
	*<code>Sphere</code> 类用于创建球体。
	*/
	//class laya.d3.resource.models.Sphere extends laya.d3.resource.models.PrimitiveMesh
	var Sphere=(function(_super){
		function Sphere(radius,stacks,slices){
			this._radius=NaN;
			this._slices=0;
			this._stacks=0;
			(radius===void 0)&& (radius=10);
			(stacks===void 0)&& (stacks=8);
			(slices===void 0)&& (slices=8);
			Sphere.__super.call(this);
			this._radius=radius;
			this._stacks=stacks;
			this._slices=slices;
			this.recreateResource();
			var pos=this.positions;
			BoundBox.fromPoints(pos,this._boundingBox);
			BoundSphere.fromPoints(pos,this._boundingSphere);
		}

		__class(Sphere,'laya.d3.resource.models.Sphere',_super);
		var __proto=Sphere.prototype;
		__proto.recreateResource=function(){
			this._numberVertices=(this._stacks+1)*(this._slices+1);
			this._numberIndices=(3 *this._stacks *(this._slices+1))*2;
			var indices=new Uint16Array(this._numberIndices);
			var vertexDeclaration=VertexPositionNormalTexture.vertexDeclaration;
			var vertexFloatStride=vertexDeclaration.vertexStride / 4;
			var vertices=new Float32Array(this._numberVertices *vertexFloatStride);
			var stackAngle=Math.PI / this._stacks;
			var sliceAngle=(Math.PI *2.0)/ this._slices;
			var wVertexIndex=0;
			var vertexCount=0;
			var indexCount=0;
			for (var stack=0;stack < (this._stacks+1);stack++){
				var r=Math.sin(stack *stackAngle);
				var y=Math.cos(stack *stackAngle);
				for (var slice=0;slice < (this._slices+1);slice++){
					var x=r *Math.sin(slice *sliceAngle);
					var z=r *Math.cos(slice *sliceAngle);
					vertices[vertexCount+0]=x *this._radius;
					vertices[vertexCount+1]=y *this._radius;
					vertices[vertexCount+2]=z *this._radius;
					vertices[vertexCount+3]=x;
					vertices[vertexCount+4]=y;
					vertices[vertexCount+5]=z;
					vertices[vertexCount+6]=slice / this._slices;
					vertices[vertexCount+7]=stack / this._stacks;
					vertexCount+=vertexFloatStride;
					if (stack !=(this._stacks-1)){
						indices[indexCount++]=wVertexIndex+(this._slices+1);
						indices[indexCount++]=wVertexIndex;
						indices[indexCount++]=wVertexIndex+1;
						indices[indexCount++]=wVertexIndex+(this._slices);
						indices[indexCount++]=wVertexIndex;
						indices[indexCount++]=wVertexIndex+(this._slices+1);
						wVertexIndex++;
					}
				}
			}
			this._vertexBuffer=new VertexBuffer3D(vertexDeclaration,this._numberVertices,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4,true);
			this._indexBuffer=new IndexBuffer3D(/*laya.d3.graphics.IndexBuffer3D.INDEXTYPE_USHORT*/"ushort",this._numberIndices,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4,true);
			this._vertexBuffer.setData(vertices);
			this._indexBuffer.setData(indices);
			this.memorySize=(this._vertexBuffer.byteLength+this._indexBuffer.byteLength)*2;
			laya.resource.Resource.prototype.recreateResource.call(this);
		}

		/**
		*设置半径（改变此属性会重新生成顶点和索引）
		*@param value 半径
		*/
		/**
		*返回半径
		*@return 半径
		*/
		__getset(0,__proto,'radius',function(){
			return this._radius;
			},function(value){
			this._radius=value;
			this.recreateResource();
		});

		/**
		*设置宽度分段（改变此属性会重新生成顶点和索引）
		*@param value 宽度分段
		*/
		/**
		*获取宽度分段
		*@return 宽度分段
		*/
		__getset(0,__proto,'slices',function(){
			return this._slices;
			},function(value){
			this._slices=value;
			this.recreateResource();
		});

		/**
		*设置高度分段（改变此属性会重新生成顶点和索引）
		*@param value高度分段
		*/
		/**
		*获取高度分段
		*@return 高度分段
		*/
		__getset(0,__proto,'stacks',function(){
			return this._stacks;
			},function(value){
			this._stacks=value;
			this.recreateResource();
		});

		return Sphere;
	})(PrimitiveMesh)



})(window,document,Laya);
