
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var AnimationPlayer=laya.ani.AnimationPlayer,AnimationState=laya.ani.AnimationState,AnimationTemplet=laya.ani.AnimationTemplet;
	var Arith=laya.maths.Arith,Bitmap=laya.resource.Bitmap,Browser=laya.utils.Browser,Buffer=laya.webgl.utils.Buffer;
	var Buffer2D=laya.webgl.utils.Buffer2D,Byte=laya.utils.Byte,ClassUtils=laya.utils.ClassUtils,Config=Laya.Config;
	var EmitterBase=laya.particle.emitter.EmitterBase,Event=laya.events.Event,EventDispatcher=laya.events.EventDispatcher;
	var Handler=laya.utils.Handler,IndexBuffer2D=laya.webgl.utils.IndexBuffer2D,Loader=laya.net.Loader,MathUtil=laya.maths.MathUtil;
	var Node=laya.display.Node,ParticleSetting=laya.particle.ParticleSetting,ParticleShader=laya.particle.shader.ParticleShader;
	var ParticleTemplateWebGL=laya.particle.ParticleTemplateWebGL,Rectangle=laya.maths.Rectangle,Render=laya.renders.Render;
	var RenderContext=laya.renders.RenderContext,RenderSprite=laya.renders.RenderSprite,RenderState2D=laya.webgl.utils.RenderState2D;
	var Resource=laya.resource.Resource,RunDriver=laya.utils.RunDriver,Shader=laya.webgl.shader.Shader,ShaderDefines=laya.webgl.shader.ShaderDefines;
	var Sprite=laya.display.Sprite,Stat=laya.utils.Stat,URL=laya.net.URL,ValusArray=laya.webgl.utils.ValusArray;
	var VertexBuffer2D=laya.webgl.utils.VertexBuffer2D,WebGL=laya.webgl.WebGL,WebGLContext=laya.webgl.WebGLContext;
	var WebGLContext2D=laya.webgl.canvas.WebGLContext2D,WebGLImage=laya.webgl.resource.WebGLImage;
	Laya.interface('laya.d3.core.IClone');
	Laya.interface('laya.d3.graphics.IVertex');
	Laya.interface('laya.d3.core.render.IUpdate');
	Laya.interface('laya.d3.core.render.IRenderable');
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
		function HeightMap(width,height,minHeight,maxHeight){
			this._datas=null;
			this._w=0;
			this._h=0;
			this._minHeight=NaN;
			this._maxHeight=NaN;
			this._datas=[];
			this._w=width;
			this._h=height;
			this._minHeight=minHeight;
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
			return NaN;
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

		/**
		*最大高度。
		*@return value 最大高度。
		*/
		__getset(0,__proto,'minHeight',function(){
			return this._minHeight;
		});

		HeightMap.creatFromMesh=function(mesh,width,height,outCellSize){
			var vertices=[];
			var indexs=[];
			var submesheCount=mesh.getSubMeshCount();
			for (var i=0;i < submesheCount;i++){
				var subMesh=mesh.getSubMesh(i);
				var vertexBuffer=subMesh._getVertexBuffer();
				var verts=vertexBuffer.getData();
				var subMeshVertices=[];
				for (var j=0;j < verts.length;j+=vertexBuffer.vertexDeclaration.vertexStride / 4){
					var position=new Vector3(verts[j+0],verts[j+1],verts[j+2]);
					subMeshVertices.push(position);
				}
				vertices.push(subMeshVertices);
				var ib=subMesh._getIndexBuffer();
				indexs.push(ib.getData());
			};
			var boundingBox=mesh.boundingBox;
			var minX=boundingBox.min.x;
			var minZ=boundingBox.min.z;
			var maxX=boundingBox.max.x;
			var maxZ=boundingBox.max.z;
			var minY=boundingBox.min.y;
			var maxY=boundingBox.max.y;
			var widthSize=maxX-minX;
			var heightSize=maxZ-minZ;
			var cellWidth=outCellSize.elements[0]=widthSize / (width-1);
			var cellHeight=outCellSize.elements[1]=heightSize / (height-1);
			var heightMap=new HeightMap(width,height,minY,maxY);
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

		HeightMap.createFromImage=function(texture,minHeight,maxHeight){
			var textureWidth=texture.width;
			var textureHeight=texture.height;
			var heightMap=new HeightMap(textureWidth,textureHeight,minHeight,maxHeight);
			var compressionRatio=(maxHeight-minHeight)/ 254;
			Browser.canvas.size(textureWidth,textureHeight);
			Browser.context.drawImage(texture._image,0,0,textureWidth,textureHeight);
			var pixelsInfo=Browser.context.getImageData(0,0,textureWidth,textureHeight).data;
			var index=0;
			for (var w=0;w < textureWidth;w++){
				var colDatas=heightMap._datas[w]=[];
				for (var h=0;h < textureHeight;h++){
					var r=pixelsInfo[index++];
					var g=pixelsInfo[index++];
					var b=pixelsInfo[index++];
					var a=pixelsInfo[index++];
					if (r==255 && g==255 && b==255 && a==255)
						colDatas[h]=NaN;
					else {
						colDatas[h]=(r+g+b)/ 3 *compressionRatio+minHeight;
					}
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
	*<code>Burst</code> 类用于粒子的爆裂描述。
	*/
	//class laya.d3.core.particleShuriKen.module.Burst
	var Burst=(function(){
		function Burst(time,minCount,maxCount){
			this._time=NaN;
			this._minCount=0;
			this._maxCount=0;
			this._time=time;
			this._minCount=minCount;
			this._maxCount=maxCount;
		}

		__class(Burst,'laya.d3.core.particleShuriKen.module.Burst');
		var __proto=Burst.prototype;
		/**
		*获取爆裂时间,单位为秒。
		*@return 爆裂时间,单位为秒。
		*/
		__getset(0,__proto,'time',function(){
			return this._time;
		});

		/**
		*获取爆裂的最小数量。
		*@return 爆裂的最小数量。
		*/
		__getset(0,__proto,'minCount',function(){
			return this._minCount;
		});

		/**
		*获取爆裂的最大数量。
		*@return 爆裂的最大数量。
		*/
		__getset(0,__proto,'maxCount',function(){
			return this._maxCount;
		});

		return Burst;
	})()


	/**
	*<code>ColorOverLifetime</code> 类用于粒子的生命周期颜色。
	*/
	//class laya.d3.core.particleShuriKen.module.ColorOverLifetime
	var ColorOverLifetime=(function(){
		function ColorOverLifetime(color){
			this._color=null;
			this.enbale=false;
			this._color=color;
		}

		__class(ColorOverLifetime,'laya.d3.core.particleShuriKen.module.ColorOverLifetime');
		var __proto=ColorOverLifetime.prototype;
		/**
		*克隆。
		*@param destObject 克隆源。
		*/
		__proto.cloneTo=function(destObject){
			var destColorOverLifetime=destObject;
			this._color.cloneTo(destColorOverLifetime._color);
			destColorOverLifetime.enbale=this.enbale;
		}

		/**
		*克隆。
		*@return 克隆副本。
		*/
		__proto.clone=function(){
			var destColorOverLifetime=/*__JS__ */new this.constructor();
			this.cloneTo(destColorOverLifetime);
			return destColorOverLifetime;
		}

		/**
		*获取颜色。
		*/
		__getset(0,__proto,'color',function(){
			return this._color;
		});

		return ColorOverLifetime;
	})()


	/**
	*<code>Emission</code> 类用于粒子发射器。
	*/
	//class laya.d3.core.particleShuriKen.module.Emission
	var Emission=(function(){
		function Emission(){
			this._burstsIndex=0;
			this._bursts=null;
			this._startDelay=NaN;
			this._played=false;
			this._paused=false;
			this._frameTime=NaN;
			this._emissionTime=NaN;
			this._playbackTime=NaN;
			this._minEmissionTime=NaN;
			this._emissionRate=0;
			this._particleSystem=null;
			this._shape=null;
			this.enbale=false;
			this._burstsIndex=0;
			this._played=false;
			this._paused=false;
			this._frameTime=0;
			this._emissionTime=0;
			this._playbackTime=0;
			this.emissionRate=10;
			this._bursts=[];
		}

		__class(Emission,'laya.d3.core.particleShuriKen.module.Emission');
		var __proto=Emission.prototype;
		/**
		*@private
		*/
		__proto._burst=function(transform){
			var duration=this._particleSystem.duration;
			for (var n=this._bursts.length;this._burstsIndex < n;this._burstsIndex++){
				var burst=this._bursts[this._burstsIndex];
				var burstTime=burst.time;
				if (this._emissionTime >=burstTime && burstTime <=duration){
					var emitCount=MathUtil.lerp(burst.minCount,burst.maxCount,Math.random());
					for (var i=0;i < emitCount;i++)
					this.emit(transform);
					}else {
					break ;
				}
			}
		}

		/**
		*@private
		*/
		__proto._advanceTime=function(elapsedTime,transform){
			if (!this._played || this._paused)
				return;
			this._playbackTime+=elapsedTime;
			if (this._playbackTime < this._startDelay)
				return;
			this._emissionTime+=elapsedTime;
			var duration=this._particleSystem.duration;
			if (this._emissionTime > duration){
				this._burst(transform);
				if (this._particleSystem.looping){
					this._emissionTime-=duration;
					this._burstsIndex=0;
					}else {
					this._played=false;
					return;
				}
			}
			this._burst(transform);
			this._frameTime+=elapsedTime;
			if (this._frameTime < this._minEmissionTime)
				return;
			while (this._frameTime > this._minEmissionTime){
				this._frameTime-=this._minEmissionTime;
				this.emit(transform);
			}
		}

		/**
		*开始发射粒子。
		*/
		__proto.play=function(){
			this._burstsIndex=0;
			this._played=true;
			this._paused=false;
			this._frameTime=0;
			this._emissionTime=0;
			this._playbackTime=0;
			switch (this._particleSystem.startDelayType){
				case 0:
					this._startDelay=this._particleSystem.startDelay;
					break ;
				case 1:
					this._startDelay=MathUtil.lerp(this._particleSystem.startDelayMin,this._particleSystem.startDelayMax,Math.random());
					break ;
				default :
					throw new Error("Utils3D: startDelayType is invalid.");
				}
		}

		/**
		*暂停发射粒子。
		*/
		__proto.pause=function(){
			this._paused=true;
		}

		/**
		*停止发射粒子。
		*/
		__proto.stop=function(){
			this._burstsIndex=0;
			this._frameTime=0;
			this._played=false;
			this._paused=false;
			this._emissionTime=0;
			this._playbackTime=0;
		}

		/**
		*获取粒子爆裂个数。
		*@return 粒子爆裂个数。
		*/
		__proto.getBurstsCount=function(){
			return this._bursts.length;
		}

		/**
		*通过索引获取粒子爆裂。
		*@param index 爆裂索引。
		*@return 粒子爆裂。
		*/
		__proto.getBurstByIndex=function(index){
			return this._bursts[index];
		}

		/**
		*增加粒子爆裂。
		*@param burst 爆裂。
		*/
		__proto.addBurst=function(burst){
			var burstsCount=this._bursts.length;
			if (burstsCount > 0)
				for (var i=0;i < burstsCount;i++){
				if (this._bursts[i].time > burst.time)
					this._bursts.splice(i,0,burst);
			}
			else
			this._bursts.push(burst);
		}

		/**
		*移除粒子爆裂。
		*@param burst 爆裂。
		*/
		__proto.removeBurst=function(burst){
			var index=this._bursts.indexOf(burst);
			if (index!==-1){
				this._bursts.splice(index,1);
				var maxBurstsIndex=this._bursts.length;
				if (this._burstsIndex > maxBurstsIndex)
					this._burstsIndex=maxBurstsIndex;
			}
		}

		/**
		*通过索引移除粒子爆裂。
		*@param index 爆裂索引。
		*/
		__proto.removeBurstByIndex=function(index){
			this._bursts.splice(index,1);
			var maxBurstsIndex=this._bursts.length;
			if (this._burstsIndex > maxBurstsIndex)
				this._burstsIndex=maxBurstsIndex;
		}

		/**
		*清空粒子爆裂。
		*/
		__proto.clearBurst=function(){
			this._burstsIndex=0;
			this._bursts.length=0;
		}

		/**
		*更新球粒子发射器。
		*@param state 渲染相关状态参数。
		*/
		__proto.update=function(elapsedTime,transform){
			(this.enbale)&& (this._advanceTime(elapsedTime,transform));
		}

		/**
		*发射一个粒子。
		*/
		__proto.emit=function(transform){
			var position=Emission._tempPosition;
			var direction=Emission._tempDirection;
			if (this._shape.enbale){
				this._shape.generatePositionAndDirection(position,direction);
				}else {
				var positionE=position.elements;
				var directionE=direction.elements;
				positionE[0]=positionE[1]=positionE[2]=0;
				directionE[0]=directionE[1]=0;
				directionE[2]=1;
			}
			switch (this._particleSystem.simulationSpace){
				case 0:
					Vector3.add(position,transform.position,position);
					break ;
				case 1:
					break ;
				default :
					throw new Error("ShurikenParticleMaterial: SimulationSpace value is invalid.");
				}
			this._particleSystem.addParticle(position,direction);
		}

		/**
		*获取一次循环内的累计时间。
		*@return 一次循环内的累计时间。
		*/
		__getset(0,__proto,'emissionTime',function(){
			var duration=this._particleSystem.duration;
			return this._emissionTime > duration ? duration :this._emissionTime;
		});

		/**
		*获取播放的累计时间。
		*@return 播放的累计时间。
		*/
		__getset(0,__proto,'playbackTime',function(){
			return this._playbackTime;
		});

		/**
		*设置粒子发射速率。
		*@param emissionRate 粒子发射速率 (个/秒)。
		*/
		/**
		*获取粒子发射速率。
		*@return 粒子发射速率 (个/秒)。
		*/
		__getset(0,__proto,'emissionRate',function(){
			return this._emissionRate;
			},function(value){
			if (value < 0)
				throw new Error("ParticleBaseShape:emissionRate value must large or equal than 0.");
			this._emissionRate=value;
			if (value===0)
				this._minEmissionTime=2147483647;
			else
			this._minEmissionTime=1 / value;
		});

		__static(Emission,
		['_tempPosition',function(){return this._tempPosition=new Vector3();},'_tempDirection',function(){return this._tempDirection=new Vector3();}
		]);
		return Emission;
	})()


	/**
	*<code>FrameOverTime</code> 类用于创建时间帧。
	*/
	//class laya.d3.core.particleShuriKen.module.FrameOverTime
	var FrameOverTime=(function(){
		function FrameOverTime(){
			this._type=0;
			this._constant=0;
			this._overTime=null;
			this._constantMin=0;
			this._constantMax=0;
			this._overTimeMin=null;
			this._overTimeMax=null;
		}

		__class(FrameOverTime,'laya.d3.core.particleShuriKen.module.FrameOverTime');
		var __proto=FrameOverTime.prototype;
		Laya.imps(__proto,{"laya.d3.core.IClone":true})
		/**
		*克隆。
		*@param destObject 克隆源。
		*/
		__proto.cloneTo=function(destObject){
			var destFrameOverTime=destObject;
			destFrameOverTime._type=this._type;
			destFrameOverTime._constant=this._constant;
			this._overTime.cloneTo(destFrameOverTime._overTime);
			destFrameOverTime._constantMin=this._constantMin;
			destFrameOverTime._constantMax=this._constantMax;
			this._overTimeMin.cloneTo(destFrameOverTime._overTimeMin);
			this._overTimeMax.cloneTo(destFrameOverTime._overTimeMax);
		}

		/**
		*克隆。
		*@return 克隆副本。
		*/
		__proto.clone=function(){
			var destFrameOverTime=/*__JS__ */new this.constructor();
			this.cloneTo(destFrameOverTime);
			return destFrameOverTime;
		}

		/**
		*时间帧。
		*/
		__getset(0,__proto,'frameOverTimeData',function(){
			return this._overTime;
		});

		/**
		*固定帧。
		*/
		__getset(0,__proto,'constant',function(){
			return this._constant;
		});

		/**
		*生命周期旋转类型,0常量模式，1曲线模式，2随机双常量模式，3随机双曲线模式。
		*/
		__getset(0,__proto,'type',function(){
			return this._type;
		});

		/**
		*最小时间帧。
		*/
		__getset(0,__proto,'frameOverTimeDataMin',function(){
			return this._overTimeMin;
		});

		/**
		*最小固定帧。
		*/
		__getset(0,__proto,'constantMin',function(){
			return this._constantMin;
		});

		/**
		*最大时间帧。
		*/
		__getset(0,__proto,'frameOverTimeDataMax',function(){
			return this._overTimeMax;
		});

		/**
		*最大固定帧。
		*/
		__getset(0,__proto,'constantMax',function(){
			return this._constantMax;
		});

		FrameOverTime.createByConstant=function(constant){
			var rotationOverLifetime=new FrameOverTime();
			rotationOverLifetime._type=0;
			rotationOverLifetime._constant=constant;
			return rotationOverLifetime;
		}

		FrameOverTime.createByOverTime=function(overTime){
			var rotationOverLifetime=new FrameOverTime();
			rotationOverLifetime._type=1;
			rotationOverLifetime._overTime=overTime;
			return rotationOverLifetime;
		}

		FrameOverTime.createByRandomTwoConstant=function(constantMin,constantMax){
			var rotationOverLifetime=new FrameOverTime();
			rotationOverLifetime._type=2;
			rotationOverLifetime._constantMin=constantMin;
			rotationOverLifetime._constantMax=constantMax;
			return rotationOverLifetime;
		}

		FrameOverTime.createByRandomTwoOverTime=function(gradientFrameMin,gradientFrameMax){
			var rotationOverLifetime=new FrameOverTime();
			rotationOverLifetime._type=3;
			rotationOverLifetime._overTimeMin=gradientFrameMin;
			rotationOverLifetime._overTimeMax=gradientFrameMax;
			return rotationOverLifetime;
		}

		return FrameOverTime;
	})()


	/**
	*<code>GradientRotation</code> 类用于创建渐变角速度。
	*/
	//class laya.d3.core.particleShuriKen.module.GradientAngularVelocity
	var GradientAngularVelocity=(function(){
		function GradientAngularVelocity(){
			this._type=0;
			this._separateAxes=false;
			this._constant=NaN;
			this._constantSeparate=null;
			this._gradient=null;
			this._gradientX=null;
			this._gradientY=null;
			this._gradientZ=null;
			this._constantMin=NaN;
			this._constantMax=NaN;
			this._constantMinSeparate=null;
			this._constantMaxSeparate=null;
			this._gradientMin=null;
			this._gradientMax=null;
			this._gradientXMin=null;
			this._gradientXMax=null;
			this._gradientYMin=null;
			this._gradientYMax=null;
			this._gradientZMin=null;
			this._gradientZMax=null;
		}

		__class(GradientAngularVelocity,'laya.d3.core.particleShuriKen.module.GradientAngularVelocity');
		var __proto=GradientAngularVelocity.prototype;
		Laya.imps(__proto,{"laya.d3.core.IClone":true})
		/**
		*克隆。
		*@param destObject 克隆源。
		*/
		__proto.cloneTo=function(destObject){
			var destGradientAngularVelocity=destObject;
			destGradientAngularVelocity._type=this._type;
			destGradientAngularVelocity._separateAxes=this._separateAxes;
			destGradientAngularVelocity._constant=this._constant;
			destGradientAngularVelocity._constantSeparate.copyFrom(this._constantSeparate);
			this._gradient.cloneTo(destGradientAngularVelocity._gradient);
			this._gradientX.cloneTo(destGradientAngularVelocity._gradientX);
			this._gradientY.cloneTo(destGradientAngularVelocity._gradientY);
			this._gradientZ.cloneTo(destGradientAngularVelocity._gradientZ);
			destGradientAngularVelocity._constantMin=this._constantMin;
			destGradientAngularVelocity._constantMax=this._constantMax;
			destGradientAngularVelocity._constantMinSeparate.copyFrom(this._constantMinSeparate);
			destGradientAngularVelocity._constantMaxSeparate.copyFrom(this._constantMaxSeparate);
			this._gradientMin.cloneTo(destGradientAngularVelocity._gradientMin);
			this._gradientMax.cloneTo(destGradientAngularVelocity._gradientMax);
			this._gradientXMin.cloneTo(destGradientAngularVelocity._gradientXMin);
			this._gradientXMax.cloneTo(destGradientAngularVelocity._gradientXMax);
			this._gradientYMin.cloneTo(destGradientAngularVelocity._gradientYMin);
			this._gradientYMax.cloneTo(destGradientAngularVelocity._gradientYMax);
			this._gradientZMin.cloneTo(destGradientAngularVelocity._gradientZMin);
			this._gradientZMax.cloneTo(destGradientAngularVelocity._gradientZMax);
		}

		/**
		*克隆。
		*@return 克隆副本。
		*/
		__proto.clone=function(){
			var destGradientAngularVelocity=/*__JS__ */new this.constructor();
			this.cloneTo(destGradientAngularVelocity);
			return destGradientAngularVelocity;
		}

		/**
		*渐变角速度Z。
		*/
		__getset(0,__proto,'gradientZ',function(){
			return this._gradientZ;
		});

		/**
		*固定角速度。
		*/
		__getset(0,__proto,'constant',function(){
			return this._constant;
		});

		/**
		*渐变角速度。
		*/
		__getset(0,__proto,'gradient',function(){
			return this._gradient;
		});

		/**
		*是否分轴。
		*/
		__getset(0,__proto,'separateAxes',function(){
			return this._separateAxes;
		});

		/**
		*生命周期角速度类型,0常量模式，1曲线模式，2随机双常量模式，3随机双曲线模式。
		*/
		__getset(0,__proto,'type',function(){
			return this._type;
		});

		/**
		*分轴固定角速度。
		*/
		__getset(0,__proto,'constantSeparate',function(){
			return this._constantSeparate;
		});

		/**
		*最小渐变角速度。
		*/
		__getset(0,__proto,'gradientMin',function(){
			return this._gradientMin;
		});

		/**
		*最小随机双固定角速度。
		*/
		__getset(0,__proto,'constantMin',function(){
			return this._constantMin;
		});

		/**
		*渐变角角速度X。
		*/
		__getset(0,__proto,'gradientX',function(){
			return this._gradientX;
		});

		/**
		*渐变角速度Y。
		*/
		__getset(0,__proto,'gradientY',function(){
			return this._gradientY;
		});

		/**
		*最大渐变角速度。
		*/
		__getset(0,__proto,'gradientMax',function(){
			return this._gradientMax;
		});

		/**
		*最大随机双固定角速度。
		*/
		__getset(0,__proto,'constantMax',function(){
			return this._constantMax;
		});

		/**
		*最小分轴随机双固定角速度。
		*/
		__getset(0,__proto,'constantMinSeparate',function(){
			return this._constantMinSeparate;
		});

		/**
		*最大分轴随机双固定角速度。
		*/
		__getset(0,__proto,'constantMaxSeparate',function(){
			return this._constantMaxSeparate;
		});

		/**
		*最小渐变角速度X。
		*/
		__getset(0,__proto,'gradientXMin',function(){
			return this._gradientXMin;
		});

		/**
		*最大渐变角速度X。
		*/
		__getset(0,__proto,'gradientXMax',function(){
			return this._gradientXMax;
		});

		/**
		*最小渐变角速度Y。
		*/
		__getset(0,__proto,'gradientYMin',function(){
			return this._gradientYMin;
		});

		/**
		*最大渐变角速度Y。
		*/
		__getset(0,__proto,'gradientYMax',function(){
			return this._gradientYMax;
		});

		/**
		*最小渐变角速度Z。
		*/
		__getset(0,__proto,'gradientZMin',function(){
			return this._gradientZMin;
		});

		/**
		*最大渐变角速度Z。
		*/
		__getset(0,__proto,'gradientZMax',function(){
			return this._gradientZMax;
		});

		GradientAngularVelocity.createByConstant=function(constant){
			var gradientAngularVelocity=new GradientAngularVelocity();
			gradientAngularVelocity._type=0;
			gradientAngularVelocity._separateAxes=false;
			gradientAngularVelocity._constant=constant;
			return gradientAngularVelocity;
		}

		GradientAngularVelocity.createByConstantSeparate=function(separateConstant){
			var gradientAngularVelocity=new GradientAngularVelocity();
			gradientAngularVelocity._type=0;
			gradientAngularVelocity._separateAxes=true;
			gradientAngularVelocity._constantSeparate=separateConstant;
			return gradientAngularVelocity;
		}

		GradientAngularVelocity.createByGradient=function(gradient){
			var gradientAngularVelocity=new GradientAngularVelocity();
			gradientAngularVelocity._type=1;
			gradientAngularVelocity._separateAxes=false;
			gradientAngularVelocity._gradient=gradient;
			return gradientAngularVelocity;
		}

		GradientAngularVelocity.createByGradientSeparate=function(gradientX,gradientY,gradientZ){
			var gradientAngularVelocity=new GradientAngularVelocity();
			gradientAngularVelocity._type=1;
			gradientAngularVelocity._separateAxes=true;
			gradientAngularVelocity._gradientX=gradientX;
			gradientAngularVelocity._gradientY=gradientY;
			gradientAngularVelocity._gradientZ=gradientZ;
			return gradientAngularVelocity;
		}

		GradientAngularVelocity.createByRandomTwoConstant=function(constantMin,constantMax){
			var gradientAngularVelocity=new GradientAngularVelocity();
			gradientAngularVelocity._type=2;
			gradientAngularVelocity._separateAxes=false;
			gradientAngularVelocity._constantMin=constantMin;
			gradientAngularVelocity._constantMax=constantMax;
			return gradientAngularVelocity;
		}

		GradientAngularVelocity.createByRandomTwoConstantSeparate=function(separateConstantMin,separateConstantMax){
			var gradientAngularVelocity=new GradientAngularVelocity();
			gradientAngularVelocity._type=2;
			gradientAngularVelocity._separateAxes=true;
			gradientAngularVelocity._constantMinSeparate=separateConstantMin;
			gradientAngularVelocity._constantMaxSeparate=separateConstantMax;
			return gradientAngularVelocity;
		}

		GradientAngularVelocity.createByRandomTwoGradient=function(gradientMin,gradientMax){
			var gradientAngularVelocity=new GradientAngularVelocity();
			gradientAngularVelocity._type=3;
			gradientAngularVelocity._separateAxes=false;
			gradientAngularVelocity._gradientMin=gradientMin;
			gradientAngularVelocity._gradientMax=gradientMax;
			return gradientAngularVelocity;
		}

		GradientAngularVelocity.createByRandomTwoGradientSeparate=function(gradientXMin,gradientXMax,gradientYMin,gradientYMax,gradientZMin,gradientZMax){
			var gradientAngularVelocity=new GradientAngularVelocity();
			gradientAngularVelocity._type=3;
			gradientAngularVelocity._separateAxes=true;
			gradientAngularVelocity._gradientXMin=gradientXMin;
			gradientAngularVelocity._gradientXMax=gradientXMax;
			gradientAngularVelocity._gradientYMin=gradientYMin;
			gradientAngularVelocity._gradientYMax=gradientYMax;
			gradientAngularVelocity._gradientZMin=gradientZMin;
			gradientAngularVelocity._gradientZMax=gradientZMax;
			return gradientAngularVelocity;
		}

		return GradientAngularVelocity;
	})()


	/**
	*<code>GradientColor</code> 类用于创建渐变颜色。
	*/
	//class laya.d3.core.particleShuriKen.module.GradientColor
	var GradientColor=(function(){
		function GradientColor(){
			this._type=0;
			this._constant=null;
			this._constantMin=null;
			this._constantMax=null;
			this._gradient=null;
			this._gradientMin=null;
			this._gradientMax=null;
		}

		__class(GradientColor,'laya.d3.core.particleShuriKen.module.GradientColor');
		var __proto=GradientColor.prototype;
		Laya.imps(__proto,{"laya.d3.core.IClone":true})
		/**
		*克隆。
		*@param destObject 克隆源。
		*/
		__proto.cloneTo=function(destObject){
			var destGradientColor=destObject;
			destGradientColor._type=this._type;
			destGradientColor._constant.copyFrom(this._constant);
			destGradientColor._constantMin.copyFrom(this._constantMin);
			destGradientColor._constantMax.copyFrom(this._constantMax);
			this._gradient.cloneTo(destGradientColor._gradient);
			this._gradientMin.cloneTo(destGradientColor._gradientMin);
			this._gradientMax.cloneTo(destGradientColor._gradientMax);
		}

		/**
		*克隆。
		*@return 克隆副本。
		*/
		__proto.clone=function(){
			var destGradientColor=/*__JS__ */new this.constructor();
			this.cloneTo(destGradientColor);
			return destGradientColor;
		}

		/**
		*渐变颜色。
		*/
		__getset(0,__proto,'gradient',function(){
			return this._gradient;
		});

		/**
		*固定颜色。
		*/
		__getset(0,__proto,'constant',function(){
			return this._constant;
		});

		/**
		*生命周期颜色类型,0为固定颜色模式,1渐变模式,2为随机双固定颜色模式,3随机双渐变模式。
		*/
		__getset(0,__proto,'type',function(){
			return this._type;
		});

		/**
		*最小渐变颜色。
		*/
		__getset(0,__proto,'gradientMin',function(){
			return this._gradientMin;
		});

		/**
		*最小固定颜色。
		*/
		__getset(0,__proto,'constantMin',function(){
			return this._constantMin;
		});

		/**
		*最大渐变颜色。
		*/
		__getset(0,__proto,'gradientMax',function(){
			return this._gradientMax;
		});

		/**
		*最大固定颜色。
		*/
		__getset(0,__proto,'constantMax',function(){
			return this._constantMax;
		});

		GradientColor.createByConstant=function(constant){
			var gradientColor=new GradientColor();
			gradientColor._type=0;
			gradientColor._constant=constant;
			return gradientColor;
		}

		GradientColor.createByGradient=function(gradient){
			var gradientColor=new GradientColor();
			gradientColor._type=1;
			gradientColor._gradient=gradient;
			return gradientColor;
		}

		GradientColor.createByRandomTwoConstant=function(minConstant,maxConstant){
			var gradientColor=new GradientColor();
			gradientColor._type=2;
			gradientColor._constantMin=minConstant;
			gradientColor._constantMax=maxConstant;
			return gradientColor;
		}

		GradientColor.createByRandomTwoGradient=function(minGradient,maxGradient){
			var gradientColor=new GradientColor();
			gradientColor._type=3;
			gradientColor._gradientMin=minGradient;
			gradientColor._gradientMax=maxGradient;
			return gradientColor;
		}

		return GradientColor;
	})()


	/**
	*<code>GradientDataColor</code> 类用于创建颜色渐变。
	*/
	//class laya.d3.core.particleShuriKen.module.GradientDataColor
	var GradientDataColor=(function(){
		function GradientDataColor(){
			this._alphaCurrentLength=0;
			this._rgbCurrentLength=0;
			this._alphaElements=null;
			this._rgbElements=null;
			this._alphaElements=new Float32Array(8);
			this._rgbElements=new Float32Array(16);
		}

		__class(GradientDataColor,'laya.d3.core.particleShuriKen.module.GradientDataColor');
		var __proto=GradientDataColor.prototype;
		Laya.imps(__proto,{"laya.d3.core.IClone":true})
		/**
		*增加Alpha渐变。
		*@param key 生命周期，范围为0到1。
		*@param value rgb值。
		*/
		__proto.addAlpha=function(key,value){
			if (this._alphaCurrentLength < 8){
				this._alphaElements[this._alphaCurrentLength++]=key;
				this._alphaElements[this._alphaCurrentLength++]=value;
				}else {
				throw new Error("GradientDataColor:Alpha count must less than 4.");
			}
		}

		/**
		*增加RGB渐变。
		*@param key 生命周期，范围为0到1。
		*@param value RGB值。
		*/
		__proto.addRGB=function(key,value){
			if (this._rgbCurrentLength < 16){
				this._rgbElements[this._rgbCurrentLength++]=key;
				this._rgbElements[this._rgbCurrentLength++]=value.x;
				this._rgbElements[this._rgbCurrentLength++]=value.y;
				this._rgbElements[this._rgbCurrentLength++]=value.z;
				}else {
				throw new Error("GradientDataColor:RGB count must less than 4.");
			}
		}

		/**
		*克隆。
		*@param destObject 克隆源。
		*/
		__proto.cloneTo=function(destObject){
			var destGradientDataColor=destObject;
			var i=0,n=0;
			destGradientDataColor._alphaCurrentLength=this._alphaCurrentLength;
			var destAlphaElements=destGradientDataColor._alphaElements;
			destAlphaElements.length=this._alphaElements.length;
			for (i=0,n=this._alphaElements.length;i < n;i++)
			destAlphaElements[i]=this._alphaElements[i];
			destGradientDataColor._rgbCurrentLength=this._rgbCurrentLength;
			var destRGBElements=destGradientDataColor._rgbElements;
			destRGBElements.length=this._rgbElements.length;
			for (i=0,n=this._rgbElements.length;i < n;i++)
			destRGBElements[i]=this._rgbElements[i];
		}

		/**
		*克隆。
		*@return 克隆副本。
		*/
		__proto.clone=function(){
			var destGradientDataColor=/*__JS__ */new this.constructor();
			this.cloneTo(destGradientDataColor);
			return destGradientDataColor;
		}

		/**渐变Alpha数量。*/
		__getset(0,__proto,'alphaGradientCount',function(){
			return this._alphaCurrentLength / 2;
		});

		/**渐变RGB数量。*/
		__getset(0,__proto,'rgbGradientCount',function(){
			return this._rgbCurrentLength / 4;
		});

		return GradientDataColor;
	})()


	/**
	*<code>GradientDataInt</code> 类用于创建整形渐变。
	*/
	//class laya.d3.core.particleShuriKen.module.GradientDataInt
	var GradientDataInt=(function(){
		function GradientDataInt(){
			this._currentLength=0;
			this._elements=null;
			this._elements=new Float32Array(8);
		}

		__class(GradientDataInt,'laya.d3.core.particleShuriKen.module.GradientDataInt');
		var __proto=GradientDataInt.prototype;
		Laya.imps(__proto,{"laya.d3.core.IClone":true})
		/**
		*增加整形渐变。
		*@param key 生命周期，范围为0到1。
		*@param value 整形值。
		*/
		__proto.add=function(key,value){
			if (this._currentLength < 8){
				this._elements[this._currentLength++]=key;
				this._elements[this._currentLength++]=value;
				}else {
				throw new Error("GradientDataInt:  Count must less than 4.");
			}
		}

		/**
		*克隆。
		*@param destObject 克隆源。
		*/
		__proto.cloneTo=function(destObject){
			var destGradientDataInt=destObject;
			destGradientDataInt._currentLength=this._currentLength;
			var destElements=destGradientDataInt._elements;
			destElements.length=this._elements.length;
			for (var i=0,n=this._elements.length;i < n;i++){
				destElements[i]=this._elements[i];
			}
		}

		/**
		*克隆。
		*@return 克隆副本。
		*/
		__proto.clone=function(){
			var destGradientDataInt=/*__JS__ */new this.constructor();
			this.cloneTo(destGradientDataInt);
			return destGradientDataInt;
		}

		/**整形渐变数量。*/
		__getset(0,__proto,'gradientCount',function(){
			return this._currentLength / 2;
		});

		return GradientDataInt;
	})()


	/**
	*<code>GradientDataNumber</code> 类用于创建浮点渐变。
	*/
	//class laya.d3.core.particleShuriKen.module.GradientDataNumber
	var GradientDataNumber=(function(){
		function GradientDataNumber(){
			this._currentLength=0;
			this._elements=null;
			this._elements=new Float32Array(8);
		}

		__class(GradientDataNumber,'laya.d3.core.particleShuriKen.module.GradientDataNumber');
		var __proto=GradientDataNumber.prototype;
		Laya.imps(__proto,{"laya.d3.core.IClone":true})
		/**
		*增加浮点渐变。
		*@param key 生命周期，范围为0到1。
		*@param value 浮点值。
		*/
		__proto.add=function(key,value){
			if (this._currentLength < 8){
				this._elements[this._currentLength++]=key;
				this._elements[this._currentLength++]=value;
				}else {
				throw new Error("GradientDataNumber: Count must less than 4.");
			}
		}

		/**
		*通过索引获取键。
		*@param index 索引。
		*@return value 键。
		*/
		__proto.getKeyByIndex=function(index){
			return this._elements[index *2];
		}

		/**
		*通过索引获取值。
		*@param index 索引。
		*@return value 值。
		*/
		__proto.getValueByIndex=function(index){
			return this._elements[index *2+1];
		}

		/**
		*克隆。
		*@param destObject 克隆源。
		*/
		__proto.cloneTo=function(destObject){
			var destGradientDataNumber=destObject;
			destGradientDataNumber._currentLength=this._currentLength;
			var destElements=destGradientDataNumber._elements;
			destElements.length=this._elements.length;
			for (var i=0,n=this._elements.length;i < n;i++)
			destElements[i]=this._elements[i];
		}

		/**
		*克隆。
		*@return 克隆副本。
		*/
		__proto.clone=function(){
			var destGradientDataNumber=/*__JS__ */new this.constructor();
			this.cloneTo(destGradientDataNumber);
			return destGradientDataNumber;
		}

		/**渐变浮点数量。*/
		__getset(0,__proto,'gradientCount',function(){
			return this._currentLength / 2;
		});

		return GradientDataNumber;
	})()


	/**
	*<code>GradientDataVector2</code> 类用于创建二维向量渐变。
	*/
	//class laya.d3.core.particleShuriKen.module.GradientDataVector2
	var GradientDataVector2=(function(){
		function GradientDataVector2(){
			this._currentLength=0;
			this._elements=null;
			this._elements=new Float32Array(12);
		}

		__class(GradientDataVector2,'laya.d3.core.particleShuriKen.module.GradientDataVector2');
		var __proto=GradientDataVector2.prototype;
		Laya.imps(__proto,{"laya.d3.core.IClone":true})
		/**
		*增加二维向量渐变。
		*@param key 生命周期，范围为0到1。
		*@param value 二维向量值。
		*/
		__proto.add=function(key,value){
			if (this._currentLength < 8){
				this._elements[this._currentLength++]=key;
				this._elements[this._currentLength++]=value.x;
				this._elements[this._currentLength++]=value.y;
				}else {
				throw new Error("GradientDataVector2:  Count must less than 4.");
			}
		}

		/**
		*克隆。
		*@param destObject 克隆源。
		*/
		__proto.cloneTo=function(destObject){
			var destGradientDataVector2=destObject;
			destGradientDataVector2._currentLength=this._currentLength;
			var destElements=destGradientDataVector2._elements;
			destElements.length=this._elements.length;
			for (var i=0,n=this._elements.length;i < n;i++){
				destElements[i]=this._elements[i];
			}
		}

		/**
		*克隆。
		*@return 克隆副本。
		*/
		__proto.clone=function(){
			var destGradientDataVector2=/*__JS__ */new this.constructor();
			this.cloneTo(destGradientDataVector2);
			return destGradientDataVector2;
		}

		/**二维向量渐变数量。*/
		__getset(0,__proto,'gradientCount',function(){
			return this._currentLength / 3;
		});

		return GradientDataVector2;
	})()


	/**
	*<code>GradientSize</code> 类用于创建渐变尺寸。
	*/
	//class laya.d3.core.particleShuriKen.module.GradientSize
	var GradientSize=(function(){
		function GradientSize(){
			this._type=0;
			this._separateAxes=false;
			this._gradient=null;
			this._gradientX=null;
			this._gradientY=null;
			this._gradientZ=null;
			this._constantMin=NaN;
			this._constantMax=NaN;
			this._constantMinSeparate=null;
			this._constantMaxSeparate=null;
			this._gradientMin=null;
			this._gradientMax=null;
			this._gradientXMin=null;
			this._gradientXMax=null;
			this._gradientYMin=null;
			this._gradientYMax=null;
			this._gradientZMin=null;
			this._gradientZMax=null;
		}

		__class(GradientSize,'laya.d3.core.particleShuriKen.module.GradientSize');
		var __proto=GradientSize.prototype;
		Laya.imps(__proto,{"laya.d3.core.IClone":true})
		/**
		*克隆。
		*@param destObject 克隆源。
		*/
		__proto.cloneTo=function(destObject){
			var destGradientSize=destObject;
			destGradientSize._type=this._type;
			destGradientSize._separateAxes=this._separateAxes;
			this._gradient.cloneTo(destGradientSize._gradient);
			this._gradientX.cloneTo(destGradientSize._gradientX);
			this._gradientY.cloneTo(destGradientSize._gradientY);
			this._gradientZ.cloneTo(destGradientSize._gradientZ);
			destGradientSize._constantMin=this._constantMin;
			destGradientSize._constantMax=this._constantMax;
			destGradientSize._constantMinSeparate.copyFrom(this._constantMinSeparate);
			destGradientSize._constantMaxSeparate.copyFrom(this._constantMaxSeparate);
			this._gradientMin.cloneTo(destGradientSize._gradientMin);
			this._gradientMax.cloneTo(destGradientSize._gradientMax);
			this._gradientXMin.cloneTo(destGradientSize._gradientXMin);
			this._gradientXMax.cloneTo(destGradientSize._gradientXMax);
			this._gradientYMin.cloneTo(destGradientSize._gradientYMin);
			this._gradientYMax.cloneTo(destGradientSize._gradientYMax);
			this._gradientZMin.cloneTo(destGradientSize._gradientZMin);
			this._gradientZMax.cloneTo(destGradientSize._gradientZMax);
		}

		/**
		*克隆。
		*@return 克隆副本。
		*/
		__proto.clone=function(){
			var destGradientSize=/*__JS__ */new this.constructor();
			this.cloneTo(destGradientSize);
			return destGradientSize;
		}

		/**
		*是否分轴。
		*/
		__getset(0,__proto,'separateAxes',function(){
			return this._separateAxes;
		});

		/**
		*生命周期尺寸类型，0曲线模式，1随机双常量模式，2随机双曲线模式。
		*/
		__getset(0,__proto,'type',function(){
			return this._type;
		});

		/**
		*渐变尺寸X。
		*/
		__getset(0,__proto,'gradientSizeX',function(){
			return this._gradientX;
		});

		/**
		*渐变尺寸。
		*/
		__getset(0,__proto,'gradientSize',function(){
			return this._gradient;
		});

		/**
		*渐变最小尺寸。
		*/
		__getset(0,__proto,'gradientMin',function(){
			return this._gradientMin;
		});

		/**
		*最小随机双固定尺寸。
		*/
		__getset(0,__proto,'constantMin',function(){
			return this._constantMin;
		});

		/**
		*渐变最小尺寸Z。
		*/
		__getset(0,__proto,'gradientZMin',function(){
			return this._gradientZMin;
		});

		/**
		*渐变尺寸Y。
		*/
		__getset(0,__proto,'gradientSizeY',function(){
			return this._gradientY;
		});

		/**
		*最小分轴随机双固定尺寸。
		*/
		__getset(0,__proto,'constantMinSeparate',function(){
			return this._constantMinSeparate;
		});

		/**
		*渐变尺寸Z。
		*/
		__getset(0,__proto,'gradientSizeZ',function(){
			return this._gradientZ;
		});

		/**
		*渐变最大尺寸。
		*/
		__getset(0,__proto,'gradientMax',function(){
			return this._gradientMax;
		});

		/**
		*最大随机双固定尺寸。
		*/
		__getset(0,__proto,'constantMax',function(){
			return this._constantMax;
		});

		/**
		*最小分轴随机双固定尺寸。
		*/
		__getset(0,__proto,'constantMaxSeparate',function(){
			return this._constantMaxSeparate;
		});

		/**
		*渐变最小尺寸X。
		*/
		__getset(0,__proto,'gradientXMin',function(){
			return this._gradientXMin;
		});

		/**
		*渐变最大尺寸X。
		*/
		__getset(0,__proto,'gradientXMax',function(){
			return this._gradientXMax;
		});

		/**
		*渐变最小尺寸Y。
		*/
		__getset(0,__proto,'gradientYMin',function(){
			return this._gradientYMin;
		});

		/**
		*渐变最大尺寸Y。
		*/
		__getset(0,__proto,'gradientYMax',function(){
			return this._gradientYMax;
		});

		/**
		*渐变最大尺寸Z。
		*/
		__getset(0,__proto,'gradientZMax',function(){
			return this._gradientZMax;
		});

		GradientSize.createByGradient=function(gradient){
			var gradientSize=new GradientSize();
			gradientSize._type=0;
			gradientSize._separateAxes=false;
			gradientSize._gradient=gradient;
			return gradientSize;
		}

		GradientSize.createByGradientSeparate=function(gradientX,gradientY,gradientZ){
			var gradientSize=new GradientSize();
			gradientSize._type=0;
			gradientSize._separateAxes=true;
			gradientSize._gradientX=gradientX;
			gradientSize._gradientY=gradientY;
			gradientSize._gradientZ=gradientZ;
			return gradientSize;
		}

		GradientSize.createByRandomTwoConstant=function(constantMin,constantMax){
			var gradientSize=new GradientSize();
			gradientSize._type=1;
			gradientSize._separateAxes=false;
			gradientSize._constantMin=constantMin;
			gradientSize._constantMax=constantMax;
			return gradientSize;
		}

		GradientSize.createByRandomTwoConstantSeparate=function(constantMinSeparate,constantMaxSeparate){
			var gradientSize=new GradientSize();
			gradientSize._type=1;
			gradientSize._separateAxes=true;
			gradientSize._constantMinSeparate=constantMinSeparate;
			gradientSize._constantMaxSeparate=constantMaxSeparate;
			return gradientSize;
		}

		GradientSize.createByRandomTwoGradient=function(gradientMin,gradientMax){
			var gradientSize=new GradientSize();
			gradientSize._type=2;
			gradientSize._separateAxes=false;
			gradientSize._gradientMin=gradientMin;
			gradientSize._gradientMax=gradientMax;
			return gradientSize;
		}

		GradientSize.createByRandomTwoGradientSeparate=function(gradientXMin,gradientXMax,gradientYMin,gradientYMax,gradientZMin,gradientZMax){
			var gradientSize=new GradientSize();
			gradientSize._type=2;
			gradientSize._separateAxes=true;
			gradientSize._gradientXMin=gradientXMin;
			gradientSize._gradientXMax=gradientXMax;
			gradientSize._gradientYMin=gradientYMin;
			gradientSize._gradientYMax=gradientYMax;
			gradientSize._gradientZMin=gradientZMin;
			gradientSize._gradientZMax=gradientZMax;
			return gradientSize;
		}

		return GradientSize;
	})()


	/**
	*<code>GradientVelocity</code> 类用于创建渐变速度。
	*/
	//class laya.d3.core.particleShuriKen.module.GradientVelocity
	var GradientVelocity=(function(){
		function GradientVelocity(){
			this._type=0;
			this._constant=null;
			this._gradientX=null;
			this._gradientY=null;
			this._gradientZ=null;
			this._constantMin=null;
			this._constantMax=null;
			this._gradientXMin=null;
			this._gradientXMax=null;
			this._gradientYMin=null;
			this._gradientYMax=null;
			this._gradientZMin=null;
			this._gradientZMax=null;
		}

		__class(GradientVelocity,'laya.d3.core.particleShuriKen.module.GradientVelocity');
		var __proto=GradientVelocity.prototype;
		Laya.imps(__proto,{"laya.d3.core.IClone":true})
		/**
		*克隆。
		*@param destObject 克隆源。
		*/
		__proto.cloneTo=function(destObject){
			var destGradientVelocity=destObject;
			destGradientVelocity._type=this._type;
			destGradientVelocity._constant.copyFrom(this._constant);
			this._gradientX.cloneTo(destGradientVelocity._gradientX);
			this._gradientY.cloneTo(destGradientVelocity._gradientY);
			this._gradientZ.cloneTo(destGradientVelocity._gradientZ);
			destGradientVelocity._constantMin.copyFrom(this._constantMin);
			destGradientVelocity._constantMax.copyFrom(this._constantMax);
			this._gradientXMin.cloneTo(destGradientVelocity._gradientXMin);
			this._gradientXMax.cloneTo(destGradientVelocity._gradientXMax);
			this._gradientYMin.cloneTo(destGradientVelocity._gradientYMin);
			this._gradientYMax.cloneTo(destGradientVelocity._gradientYMax);
			this._gradientZMin.cloneTo(destGradientVelocity._gradientZMin);
			this._gradientZMax.cloneTo(destGradientVelocity._gradientZMax);
		}

		/**
		*克隆。
		*@return 克隆副本。
		*/
		__proto.clone=function(){
			var destGradientVelocity=/*__JS__ */new this.constructor();
			this.cloneTo(destGradientVelocity);
			return destGradientVelocity;
		}

		/**
		*渐变速度Z。
		*/
		__getset(0,__proto,'gradientZ',function(){
			return this._gradientZ;
		});

		/**固定速度。*/
		__getset(0,__proto,'constant',function(){
			return this._constant;
		});

		/**
		*生命周期速度类型，0常量模式，1曲线模式，2随机双常量模式，3随机双曲线模式。
		*/
		__getset(0,__proto,'type',function(){
			return this._type;
		});

		/**
		*渐变最大速度X。
		*/
		__getset(0,__proto,'gradientXMax',function(){
			return this._gradientXMax;
		});

		/**最小固定速度。*/
		__getset(0,__proto,'constantMin',function(){
			return this._constantMin;
		});

		/**
		*渐变速度X。
		*/
		__getset(0,__proto,'gradientX',function(){
			return this._gradientX;
		});

		/**
		*渐变速度Y。
		*/
		__getset(0,__proto,'gradientY',function(){
			return this._gradientY;
		});

		/**
		*渐变最小速度X。
		*/
		__getset(0,__proto,'gradientXMin',function(){
			return this._gradientXMin;
		});

		/**最大固定速度。*/
		__getset(0,__proto,'constantMax',function(){
			return this._constantMax;
		});

		/**
		*渐变最小速度Y。
		*/
		__getset(0,__proto,'gradientYMin',function(){
			return this._gradientYMin;
		});

		/**
		*渐变最大速度Y。
		*/
		__getset(0,__proto,'gradientYMax',function(){
			return this._gradientYMax;
		});

		/**
		*渐变最小速度Z。
		*/
		__getset(0,__proto,'gradientZMin',function(){
			return this._gradientZMin;
		});

		/**
		*渐变最大速度Z。
		*/
		__getset(0,__proto,'gradientZMax',function(){
			return this._gradientZMax;
		});

		GradientVelocity.createByConstant=function(constant){
			var gradientVelocity=new GradientVelocity();
			gradientVelocity._type=0;
			gradientVelocity._constant=constant;
			return gradientVelocity;
		}

		GradientVelocity.createByGradient=function(gradientX,gradientY,gradientZ){
			var gradientVelocity=new GradientVelocity();
			gradientVelocity._type=1;
			gradientVelocity._gradientX=gradientX;
			gradientVelocity._gradientY=gradientY;
			gradientVelocity._gradientZ=gradientZ;
			return gradientVelocity;
		}

		GradientVelocity.createByRandomTwoConstant=function(constantMin,constantMax){
			var gradientVelocity=new GradientVelocity();
			gradientVelocity._type=2;
			gradientVelocity._constantMin=constantMin;
			gradientVelocity._constantMax=constantMax;
			return gradientVelocity;
		}

		GradientVelocity.createByRandomTwoGradient=function(gradientXMin,gradientXMax,gradientYMin,gradientYMax,gradientZMin,gradientZMax){
			var gradientVelocity=new GradientVelocity();
			gradientVelocity._type=3;
			gradientVelocity._gradientXMin=gradientXMin;
			gradientVelocity._gradientXMax=gradientXMax;
			gradientVelocity._gradientYMin=gradientYMin;
			gradientVelocity._gradientYMax=gradientYMax;
			gradientVelocity._gradientZMin=gradientZMin;
			gradientVelocity._gradientZMax=gradientZMax;
			return gradientVelocity;
		}

		return GradientVelocity;
	})()


	/**
	*<code>RotationOverLifetime</code> 类用于粒子的生命周期旋转。
	*/
	//class laya.d3.core.particleShuriKen.module.RotationOverLifetime
	var RotationOverLifetime=(function(){
		function RotationOverLifetime(angularVelocity){
			this._angularVelocity=null;
			this.enbale=false;
			this._angularVelocity=angularVelocity;
		}

		__class(RotationOverLifetime,'laya.d3.core.particleShuriKen.module.RotationOverLifetime');
		var __proto=RotationOverLifetime.prototype;
		Laya.imps(__proto,{"laya.d3.core.IClone":true})
		/**
		*克隆。
		*@param destObject 克隆源。
		*/
		__proto.cloneTo=function(destObject){
			var destRotationOverLifetime=destObject;
			this._angularVelocity.cloneTo(destRotationOverLifetime._angularVelocity);
			destRotationOverLifetime.enbale=this.enbale;
		}

		/**
		*克隆。
		*@return 克隆副本。
		*/
		__proto.clone=function(){
			var destRotationOverLifetime=/*__JS__ */new this.constructor();
			this.cloneTo(destRotationOverLifetime);
			return destRotationOverLifetime;
		}

		/**
		*获取角速度。
		*/
		__getset(0,__proto,'angularVelocity',function(){
			return this._angularVelocity;
		});

		return RotationOverLifetime;
	})()


	/**
	*<code>BaseShape</code> 类用于粒子形状。
	*/
	//class laya.d3.core.particleShuriKen.module.shape.BaseShape
	var BaseShape=(function(){
		function BaseShape(){
			this.enbale=false;
		}

		__class(BaseShape,'laya.d3.core.particleShuriKen.module.shape.BaseShape');
		var __proto=BaseShape.prototype;
		/**
		*用于生成粒子初始位置和方向。
		*@param position 粒子位置。
		*@param direction 粒子方向。
		*/
		__proto.generatePositionAndDirection=function(position,direction){
			throw new Error("BaseShape: must override it.");
		}

		return BaseShape;
	})()


	/**
	*...
	*@author ...
	*/
	//class laya.d3.core.particleShuriKen.module.shape.ShapeUtils
	var ShapeUtils=(function(){
		function ShapeUtils(){}
		__class(ShapeUtils,'laya.d3.core.particleShuriKen.module.shape.ShapeUtils');
		ShapeUtils._randomPointUnitArcCircle=function(arc,out){
			var outE=out.elements;
			var angle=Math.random()*arc;
			outE[0]=Math.cos(angle);
			outE[1]=Math.sin(angle);
		}

		ShapeUtils._randomPointInsideUnitArcCircle=function(arc,out){
			var outE=out.elements;
			ShapeUtils._randomPointUnitArcCircle(arc,out);
			var range=Math.pow(Math.random(),1.0 / 2.0);
			outE[0]=outE[0] *range;
			outE[1]=outE[1] *range;
		}

		ShapeUtils._randomPointUnitCircle=function(out){
			var outE=out.elements;
			var angle=Math.random()*Math.PI *2;
			outE[0]=Math.cos(angle);
			outE[1]=Math.sin(angle);
		}

		ShapeUtils._randomPointInsideUnitCircle=function(out){
			var outE=out.elements;
			ShapeUtils._randomPointUnitCircle(out);
			var range=Math.pow(Math.random(),1.0 / 2.0);
			outE[0]=outE[0] *range;
			outE[1]=outE[1] *range;
		}

		ShapeUtils._randomPointUnitSphere=function(out){
			var outE=out.elements;
			var z=outE[2]=Math.random()*2-1.0;
			var a=Math.random()*Math.PI *2;
			var r=Math.sqrt(1.0-z *z);
			outE[0]=r *Math.cos(a);
			outE[1]=r *Math.sin(a);
		}

		ShapeUtils._randomPointInsideUnitSphere=function(out){
			var outE=out.elements;
			ShapeUtils._randomPointUnitSphere(out);
			var range=Math.pow(Math.random(),1.0 / 3.0);
			outE[0]=outE[0] *range;
			outE[1]=outE[1] *range;
			outE[2]=outE[2] *range;
		}

		ShapeUtils._randomPointInsideHalfUnitBox=function(out){
			var outE=out.elements;
			outE[0]=(Math.random()-0.5);
			outE[1]=(Math.random()-0.5);
			outE[2]=(Math.random()-0.5);
		}

		return ShapeUtils;
	})()


	/**
	*<code>SizeOverLifetime</code> 类用于粒子的生命周期尺寸。
	*/
	//class laya.d3.core.particleShuriKen.module.SizeOverLifetime
	var SizeOverLifetime=(function(){
		function SizeOverLifetime(size){
			this._size=null;
			this.enbale=false;
			this._size=size;
		}

		__class(SizeOverLifetime,'laya.d3.core.particleShuriKen.module.SizeOverLifetime');
		var __proto=SizeOverLifetime.prototype;
		Laya.imps(__proto,{"laya.d3.core.IClone":true})
		/**
		*克隆。
		*@param destObject 克隆源。
		*/
		__proto.cloneTo=function(destObject){
			var destSizeOverLifetime=destObject;
			this._size.cloneTo(destSizeOverLifetime._size);
			destSizeOverLifetime.enbale=this.enbale;
		}

		/**
		*克隆。
		*@return 克隆副本。
		*/
		__proto.clone=function(){
			var destSizeOverLifetime=/*__JS__ */new this.constructor();
			this.cloneTo(destSizeOverLifetime);
			return destSizeOverLifetime;
		}

		/**
		*获取尺寸。
		*/
		__getset(0,__proto,'size',function(){
			return this._size;
		});

		return SizeOverLifetime;
	})()


	/**
	*<code>StartFrame</code> 类用于创建开始帧。
	*/
	//class laya.d3.core.particleShuriKen.module.StartFrame
	var StartFrame=(function(){
		function StartFrame(){
			this._type=0;
			this._constant=NaN;
			this._constantMin=NaN;
			this._constantMax=NaN;
		}

		__class(StartFrame,'laya.d3.core.particleShuriKen.module.StartFrame');
		var __proto=StartFrame.prototype;
		Laya.imps(__proto,{"laya.d3.core.IClone":true})
		/**
		*克隆。
		*@param destObject 克隆源。
		*/
		__proto.cloneTo=function(destObject){
			var destStartFrame=destObject;
			destStartFrame._type=this._type;
			destStartFrame._constant=this._constant;
			destStartFrame._constantMin=this._constantMin;
			destStartFrame._constantMax=this._constantMax;
		}

		/**
		*克隆。
		*@return 克隆副本。
		*/
		__proto.clone=function(){
			var destStartFrame=/*__JS__ */new this.constructor();
			this.cloneTo(destStartFrame);
			return destStartFrame;
		}

		/**
		*固定帧。
		*/
		__getset(0,__proto,'constant',function(){
			return this._constant;
		});

		/**
		*开始帧类型,0常量模式，1随机双常量模式。
		*/
		__getset(0,__proto,'type',function(){
			return this._type;
		});

		/**
		*最小固定帧。
		*/
		__getset(0,__proto,'constantMin',function(){
			return this._constantMin;
		});

		/**
		*最大固定帧。
		*/
		__getset(0,__proto,'constantMax',function(){
			return this._constantMax;
		});

		StartFrame.createByConstant=function(constant){
			var rotationOverLifetime=new StartFrame();
			rotationOverLifetime._type=0;
			rotationOverLifetime._constant=constant;
			return rotationOverLifetime;
		}

		StartFrame.createByRandomTwoConstant=function(constantMin,constantMax){
			var rotationOverLifetime=new StartFrame();
			rotationOverLifetime._type=1;
			rotationOverLifetime._constantMin=constantMin;
			rotationOverLifetime._constantMax=constantMax;
			return rotationOverLifetime;
		}

		return StartFrame;
	})()


	/**
	*<code>TextureSheetAnimation</code> 类用于创建粒子帧动画。
	*/
	//class laya.d3.core.particleShuriKen.module.TextureSheetAnimation
	var TextureSheetAnimation=(function(){
		function TextureSheetAnimation(frame,startFrame){
			this.tiles=null;
			this.type=0;
			this.randomRow=false;
			this.frame=null;
			this.startFrame=null;
			this.cycles=0;
			this.enableUVChannels=0;
			this.enbale=false;
			this.tiles=new Vector2(1,1);
			this.type=0;
			this.randomRow=true;
			this.cycles=1;
			this.enableUVChannels=1;
			this.frame=frame;
			this.startFrame=startFrame;
		}

		__class(TextureSheetAnimation,'laya.d3.core.particleShuriKen.module.TextureSheetAnimation');
		var __proto=TextureSheetAnimation.prototype;
		Laya.imps(__proto,{"laya.d3.core.IClone":true})
		/**
		*克隆。
		*@param destObject 克隆源。
		*/
		__proto.cloneTo=function(destObject){
			var destTextureSheetAnimation=destObject;
			this.tiles.clone(destTextureSheetAnimation.tiles);
			destTextureSheetAnimation.type=this.type;
			destTextureSheetAnimation.randomRow=this.randomRow;
			this.frame.cloneTo(destTextureSheetAnimation.frame);
			this.startFrame.cloneTo(destTextureSheetAnimation.startFrame);
			destTextureSheetAnimation.cycles=this.cycles;
			destTextureSheetAnimation.enableUVChannels=this.enableUVChannels;
			destTextureSheetAnimation.enbale=this.enbale;
		}

		/**
		*克隆。
		*@return 克隆副本。
		*/
		__proto.clone=function(){
			var destTextureSheetAnimation=/*__JS__ */new this.constructor();
			this.cloneTo(destTextureSheetAnimation);
			return destTextureSheetAnimation;
		}

		return TextureSheetAnimation;
	})()


	/**
	*<code>VelocityOverLifetime</code> 类用于粒子的生命周期速度。
	*/
	//class laya.d3.core.particleShuriKen.module.VelocityOverLifetime
	var VelocityOverLifetime=(function(){
		function VelocityOverLifetime(velocity){
			this._velocity=null;
			this.enbale=false;
			this.space=0;
			this._velocity=velocity;
		}

		__class(VelocityOverLifetime,'laya.d3.core.particleShuriKen.module.VelocityOverLifetime');
		var __proto=VelocityOverLifetime.prototype;
		Laya.imps(__proto,{"laya.d3.core.IClone":true})
		/**
		*克隆。
		*@param destObject 克隆源。
		*/
		__proto.cloneTo=function(destObject){
			var destVelocityOverLifetime=destObject;
			this._velocity.cloneTo(destVelocityOverLifetime._velocity);
			destVelocityOverLifetime.enbale=this.enbale;
			destVelocityOverLifetime.space=this.space;
		}

		/**
		*克隆。
		*@return 克隆副本。
		*/
		__proto.clone=function(){
			var destVelocityOverLifetime=/*__JS__ */new this.constructor();
			this.cloneTo(destVelocityOverLifetime);
			return destVelocityOverLifetime;
		}

		/**
		*获取尺寸。
		*/
		__getset(0,__proto,'velocity',function(){
			return this._velocity;
		});

		return VelocityOverLifetime;
	})()


	/**
	*@private
	*/
	//class laya.d3.core.particleShuriKen.ShurikenParticleData
	var ShurikenParticleData=(function(){
		function ShurikenParticleData(){
			this.startLifeTime=NaN;
			this.position=null;
			this.direction=null;
			this.startColor=null;
			this.startSize=null;
			this.startRotation0=null;
			this.startRotation1=null;
			this.startRotation2=null;
			this.time=NaN;
			this.startSpeed=NaN;
			this.startUVInfo=null;
		}

		__class(ShurikenParticleData,'laya.d3.core.particleShuriKen.ShurikenParticleData');
		ShurikenParticleData._getStartLifetimeFromGradient=function(startLifeTimeGradient,emissionTime){
			for (var i=1,n=startLifeTimeGradient.gradientCount;i < n;i++){
				var key=startLifeTimeGradient.getKeyByIndex(i);
				if (key >=emissionTime){
					var lastKey=startLifeTimeGradient.getKeyByIndex(i-1);
					var age=(emissionTime-lastKey)/ (key-lastKey);
					return MathUtil.lerp(startLifeTimeGradient.getValueByIndex(i-1),startLifeTimeGradient.getValueByIndex(i),age)
				}
			}
			throw new Error("ShurikenParticleData: can't get value foam startLifeTimeGradient.");
		}

		ShurikenParticleData.create=function(particleSystem,particleRender,position,direction,time){
			var particleData=new ShurikenParticleData();
			particleData.position=position;
			MathUtil.scaleVector3(direction,1.0,ShurikenParticleData._tempDirection);
			particleData.direction=ShurikenParticleData._tempDirection;
			particleData.startColor=ShurikenParticleData._tempStartColor;
			switch (particleSystem.startColorType){
				case 0:;
					var startColorE=particleData.startColor;
					var constantStartColorE=particleSystem.startColorConstant.elements;
					startColorE[0]=constantStartColorE[0];
					startColorE[1]=constantStartColorE[1];
					startColorE[2]=constantStartColorE[2];
					startColorE[3]=constantStartColorE[3];
					break ;
				case 2:
					MathUtil.lerpVector4(particleSystem.startColorConstantMin.elements,particleSystem.startColorConstantMax.elements,Math.random(),particleData.startColor);
					break ;
				};
			var colorOverLifetime=particleSystem.colorOverLifetime;
			if (colorOverLifetime && colorOverLifetime.enbale){
				var startColor=particleData.startColor;
				var color=colorOverLifetime.color;
				switch (color.type){
					case 0:
						startColor[0]=startColor[0] *color.constant.x;
						startColor[1]=startColor[1] *color.constant.y;
						startColor[2]=startColor[2] *color.constant.z;
						startColor[3]=startColor[3] *color.constant.w;
						break ;
					case 2:;
						var colorRandom=Math.random();
						var minConstantColor=color.constantMin;
						var maxConstantColor=color.constantMax;
						startColor[0]=startColor[0] *MathUtil.lerp(minConstantColor.x,maxConstantColor.x,colorRandom);
						startColor[1]=startColor[1] *MathUtil.lerp(minConstantColor.y,maxConstantColor.y,colorRandom);
						startColor[2]=startColor[2] *MathUtil.lerp(minConstantColor.z,maxConstantColor.z,colorRandom);
						startColor[3]=startColor[3] *MathUtil.lerp(minConstantColor.w,maxConstantColor.w,colorRandom);
						break ;
					}
			}
			particleData.startSize=ShurikenParticleData._tempStartSize;
			var particleSize=particleData.startSize;
			switch (particleSystem.startSizeType){
				case 0:
					if (particleSystem.threeDStartSize){
						var startSizeConstantSeparate=particleSystem.startSizeConstantSeparate;
						particleSize[0]=startSizeConstantSeparate.x;
						particleSize[1]=startSizeConstantSeparate.y;
						particleSize[2]=startSizeConstantSeparate.z;
						}else {
						particleSize[0]=particleSize[1]=particleSize[2]=particleSystem.startSizeConstant;
					}
					break ;
				case 2:
					if (particleSystem.threeDStartSize){
						var startSizeConstantMinSeparate=particleSystem.startSizeConstantMinSeparate;
						var startSizeConstantMaxSeparate=particleSystem.startSizeConstantMaxSeparate;
						particleSize[0]=MathUtil.lerp(startSizeConstantMinSeparate.x,startSizeConstantMaxSeparate.x,Math.random());
						particleSize[1]=MathUtil.lerp(startSizeConstantMinSeparate.y,startSizeConstantMaxSeparate.y,Math.random());
						particleSize[2]=MathUtil.lerp(startSizeConstantMinSeparate.z,startSizeConstantMaxSeparate.z,Math.random());
						}else {
						particleSize[0]=particleSize[1]=particleSize[2]=MathUtil.lerp(particleSystem.startSizeConstantMin,particleSystem.startSizeConstantMax,Math.random());
					}
					break ;
				};
			var sizeOverLifetime=particleSystem.sizeOverLifetime;
			if (sizeOverLifetime && sizeOverLifetime.enbale && sizeOverLifetime.size.type===1){
				var size=sizeOverLifetime.size;
				if (size.separateAxes){
					particleSize[0]=particleSize[0] *MathUtil.lerp(size.constantMinSeparate.x,size.constantMaxSeparate.x,Math.random());
					particleSize[1]=particleSize[1] *MathUtil.lerp(size.constantMinSeparate.y,size.constantMaxSeparate.y,Math.random());
					particleSize[2]=particleSize[2] *MathUtil.lerp(size.constantMinSeparate.z,size.constantMaxSeparate.z,Math.random());
					}else {
					var randomSize=MathUtil.lerp(size.constantMin,size.constantMax,Math.random());
					particleSize[0]=particleSize[0] *randomSize;
					particleSize[1]=particleSize[1] *randomSize;
					particleSize[2]=particleSize[2] *randomSize;
				}
			};
			var particleRotation0;
			var particleRotation1;
			var particleRotation2;
			var rotationMatrixE;
			switch (particleSystem.startRotationType){
				case 0:
					if (particleSystem.threeDStartRotation&&(particleRender.renderMode!==1)&&(particleRender.renderMode!==1)){
						var startRotationConstantSeparate=particleSystem.startRotationConstantSeparate;
						Matrix4x4.createRotationYawPitchRoll(startRotationConstantSeparate.y,startRotationConstantSeparate.x,startRotationConstantSeparate.z,ShurikenParticleData._tempRotationMatrix);
						rotationMatrixE=ShurikenParticleData._tempRotationMatrix.elements;
						particleData.startRotation0=ShurikenParticleData._tempStartRotation0;
						particleRotation0=particleData.startRotation0;
						particleRotation0[0]=rotationMatrixE[0];
						particleRotation0[1]=rotationMatrixE[1];
						particleRotation0[2]=rotationMatrixE[2];
						particleData.startRotation1=ShurikenParticleData._tempStartRotation1;
						particleRotation1=particleData.startRotation1;
						particleRotation1[0]=rotationMatrixE[4];
						particleRotation1[1]=rotationMatrixE[5];
						particleRotation1[2]=rotationMatrixE[6];
						particleData.startRotation2=ShurikenParticleData._tempStartRotation2;
						particleRotation2=particleData.startRotation2;
						particleRotation2[0]=rotationMatrixE[8];
						particleRotation2[1]=rotationMatrixE[9];
						particleRotation2[2]=rotationMatrixE[10];
						}else {
						particleData.startRotation0=ShurikenParticleData._tempStartRotation0;
						particleRotation0=particleData.startRotation0;
						particleRotation0[0]=particleRotation0[1]=particleRotation0[2]=particleSystem.startRotationConstant;
					}
					break ;
				case 2:
					if (particleSystem.threeDStartRotation&&(particleRender.renderMode!==1)&&(particleRender.renderMode!==2)){
						particleData.startRotation0=ShurikenParticleData._tempStartRotation0;
						particleRotation0=particleData.startRotation0;
						var startRotationConstantMinSeparate=particleSystem.startRotationConstantMinSeparate;
						var startRotationConstantMaxSeparate=particleSystem.startRotationConstantMaxSeparate;
						Matrix4x4.createRotationYawPitchRoll(MathUtil.lerp(startRotationConstantMinSeparate.y,startRotationConstantMaxSeparate.y,Math.random()),MathUtil.lerp(startRotationConstantMinSeparate.x,startRotationConstantMaxSeparate.x,Math.random()),MathUtil.lerp(startRotationConstantMinSeparate.z,startRotationConstantMaxSeparate.z,Math.random()),ShurikenParticleData._tempRotationMatrix);
						rotationMatrixE=ShurikenParticleData._tempRotationMatrix.elements;
						particleData.startRotation0=ShurikenParticleData._tempStartRotation0;
						particleRotation0=particleData.startRotation0;
						particleRotation0[0]=rotationMatrixE[0];
						particleRotation0[1]=rotationMatrixE[1];
						particleRotation0[2]=rotationMatrixE[2];
						particleData.startRotation1=ShurikenParticleData._tempStartRotation1;
						particleRotation1=particleData.startRotation1;
						particleRotation1[0]=rotationMatrixE[4];
						particleRotation1[1]=rotationMatrixE[5];
						particleRotation1[2]=rotationMatrixE[6];
						particleData.startRotation2=ShurikenParticleData._tempStartRotation2;
						particleRotation2=particleData.startRotation2;
						particleRotation2[0]=rotationMatrixE[8];
						particleRotation2[1]=rotationMatrixE[9];
						particleRotation2[2]=rotationMatrixE[10];
						}else {
						particleData.startRotation0=ShurikenParticleData._tempStartRotation0;
						particleRotation0=particleData.startRotation0;
						particleRotation0[0]=particleRotation0[1]=particleRotation0[2]=MathUtil.lerp(particleSystem.startRotationConstantMin,particleSystem.startRotationConstantMax,Math.random());
					}
					break ;
				}
			if (Math.random()< particleSystem.randomizeRotationDirection){
				particleRotation0[0]=-particleRotation0[0];
				particleRotation0[1]=-particleRotation0[1];
				particleRotation0[2]=-particleRotation0[2];
			}
			particleData.startRotation1=ShurikenParticleData._tempStartRotation1;
			particleData.startRotation2=ShurikenParticleData._tempStartRotation2;
			switch (particleSystem.startLifetimeType){
				case 0:
					particleData.startLifeTime=particleSystem.startLifetimeConstant;
					break ;
				case 1:
					particleData.startLifeTime=ShurikenParticleData._getStartLifetimeFromGradient(particleSystem.startLifeTimeGradient,particleSystem.emission.emissionTime);
					break ;
				case 2:
					particleData.startLifeTime=MathUtil.lerp(particleSystem.startLifetimeConstantMin,particleSystem.startLifetimeConstantMax,Math.random());
					break ;
				case 3:;
					var emissionTime=particleSystem.emission.emissionTime;
					particleData.startLifeTime=MathUtil.lerp(ShurikenParticleData._getStartLifetimeFromGradient(particleSystem.startLifeTimeGradientMin,emissionTime),ShurikenParticleData._getStartLifetimeFromGradient(particleSystem.startLifeTimeGradientMax,emissionTime),Math.random());
					break ;
				}
			switch (particleSystem.startSpeedType){
				case 0:
					particleData.startSpeed=particleSystem.startSpeedConstant;
					break ;
				case 2:
					particleData.startSpeed=MathUtil.lerp(particleSystem.startSpeedConstantMin,particleSystem.startSpeedConstantMax,Math.random());
					break ;
				}
			particleData.startUVInfo=ShurikenParticleData._tempStartUVInfo;
			var textureSheetAnimation=particleSystem.textureSheetAnimation;
			var enableSheetAnimation=textureSheetAnimation && textureSheetAnimation.enbale;
			var startUVInfo;
			if (enableSheetAnimation){
				var title=textureSheetAnimation.tiles;
				var titleX=title.x,titleY=title.y;
				var subU=1.0 / titleX,subV=1.0 / titleY;
				var totalFrameCount=0;
				var startRow=0;
				var randomRow=textureSheetAnimation.randomRow;
				switch (textureSheetAnimation.type){
					case 0:
						totalFrameCount=titleX *titleY;
						break ;
					case 1:
						totalFrameCount=titleX;
						if (randomRow)
							startRow=Math.round(Math.random()*titleY);
						else
						startRow=0;
						break ;
					};
				var startFrameCount=0;
				var startFrame=textureSheetAnimation.startFrame;
				switch (startFrame.type){
					case 0:
						startFrameCount=startFrame.constant;
						break ;
					case 1:
						startFrameCount=Math.round(MathUtil.lerp(startFrame.constantMin,startFrame.constantMax,Math.random()));
						break ;
					};
				var frame=textureSheetAnimation.frame;
				switch (frame.type){
					case 0:
						startFrameCount+=frame.constant;
						break ;
					case 2:
						startFrameCount+=Math.round(MathUtil.lerp(frame.constantMin,frame.constantMax,Math.random()));
						break ;
					}
				if (!randomRow)
					startRow=Math.floor(startFrameCount / titleX);
				var startCol=startFrameCount % titleX;
				startUVInfo=particleData.startUVInfo;
				startUVInfo[0]=subU;
				startUVInfo[1]=subV;
				startUVInfo[2]=startCol *subU;
				startUVInfo[3]=startRow *subV;
				}else {
				startUVInfo=particleData.startUVInfo;
				startUVInfo[0]=1.0;
				startUVInfo[1]=1.0;
				startUVInfo[2]=0.0;
				startUVInfo[3]=0.0;
			}
			particleData.time=time;
			return particleData;
		}

		__static(ShurikenParticleData,
		['_tempRotationMatrix',function(){return this._tempRotationMatrix=new Matrix4x4();},'_tempDirection',function(){return this._tempDirection=new Float32Array(3);},'_tempStartColor',function(){return this._tempStartColor=new Float32Array(4);},'_tempStartSize',function(){return this._tempStartSize=new Float32Array(3);},'_tempStartRotation0',function(){return this._tempStartRotation0=new Float32Array(3);},'_tempStartRotation1',function(){return this._tempStartRotation1=new Float32Array(3);},'_tempStartRotation2',function(){return this._tempStartRotation2=new Float32Array(3);},'_tempStartUVInfo',function(){return this._tempStartUVInfo=new Float32Array(4);}
		]);
		return ShurikenParticleData;
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
			this._albedo=new Vector4(1.0,1.0,1.0,1.0);
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

		__proto.boundingBoxLine=function(minX,minY,minZ,maxX,maxY,maxZ,r,g,b,a){
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
			this._renderState.shaderValue.pushValue(/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION",this._posShaderValue);
			this._renderState.shaderValue.pushValue(/*laya.d3.graphics.VertexElementUsage.COLOR0*/"COLOR",this._colorShaderValue);
			this._renderState.shaderValue.pushValue(/*laya.d3.core.material.StandardMaterial.MVPMATRIX*/"MVPMATRIX",this._wvpMatrix.elements);
			this._renderState.shaderValue.pushValue(/*laya.d3.core.material.StandardMaterial.ALBEDO*/"ALBEDO",this._albedo.elements);
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
			state.shaderDefs._value=preDef & (~(/*laya.d3.shader.ShaderDefines3D.POINTLIGHT*/0x2000 | /*laya.d3.shader.ShaderDefines3D.SPOTLIGHT*/0x4000 | /*laya.d3.shader.ShaderDefines3D.DIRECTIONLIGHT*/0x1000));
			state.shaderDefs.add(/*laya.d3.shader.ShaderDefines3D.COLOR*/0x800);
			var nameID=state.shaderDefs.getValue()+this._sharderNameID */*laya.webgl.shader.Shader.SHADERNAME2ID*/0.0002;
			var shader=this._shader ? this._shader :Shader.getShader(nameID);
			return shader || (shader=Shader.withCompile(this._sharderNameID,state.shaderDefs.toNameDic(),nameID,null));
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
			throw new Error("您必须确保在此之前已调用begin()且使用“LINES”基元！");
		}

		__proto.drawTrianglesException=function(){
			throw new Error("您必须确保在此之前已调用begin()且使用“TRIANGLES”基元！");
		}

		return PhasorSpriter3D;
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
	*@private
	*<code>RenderElement</code> 类用于实现渲染物体。
	*/
	//class laya.d3.core.render.RenderElement
	var RenderElement=(function(){
		function RenderElement(){
			this._type=0;
			this._mainSortID=0;
			this._renderObject=null;
			this._sprite3D=null;
			this._material=null;
			this._renderObj=null;
			this._staticBatch=null;
			this._batchIndexStart=0;
			this._batchIndexEnd=0;
			this._canDynamicBatch=false;
			this._canDynamicBatch=true;
		}

		__class(RenderElement,'laya.d3.core.render.RenderElement');
		var __proto=RenderElement.prototype;
		/**
		*@private
		*/
		__proto.getStaticBatchBakedVertexs=function(index){
			var byteSizeInFloat=4;
			var vb=this._renderObj._getVertexBuffer(index);
			var bakedVertexes=vb.getData().slice();
			var vertexDeclaration=vb.vertexDeclaration;
			var positionOffset=vertexDeclaration.getVertexElementByUsage(/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION").offset / byteSizeInFloat;
			var normalOffset=vertexDeclaration.getVertexElementByUsage(/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL").offset / byteSizeInFloat;
			var rootTransform=this._staticBatch._rootSprite.transform.worldMatrix;
			var transform=this._sprite3D.transform.worldMatrix;
			var rootInvertMat=RenderElement._tempMatrix4x40;
			var result=RenderElement._tempMatrix4x41;
			rootTransform.invert(rootInvertMat);
			Matrix4x4.multiply(rootInvertMat,transform,result);
			var rotation=RenderElement._tempQuaternion0;
			result.decompose(RenderElement._tempVector30,rotation,RenderElement._tempVector31);
			var vertexFloatCount=vertexDeclaration.vertexStride / byteSizeInFloat;
			for (var i=0,n=bakedVertexes.length;i < n;i+=vertexFloatCount){
				var posOffset=i+positionOffset;
				var norOffset=i+normalOffset;
				Utils3D.transformVector3ArrayToVector3ArrayCoordinate(bakedVertexes,posOffset,result,bakedVertexes,posOffset);
				Utils3D.transformVector3ArrayByQuat(bakedVertexes,normalOffset,rotation,bakedVertexes,normalOffset);
			}
			return bakedVertexes;
		}

		/**
		*@private
		*/
		__proto.getDynamicBatchBakedVertexs=function(index){
			var byteSizeInFloat=4;
			var vb=this._renderObj._getVertexBuffer(index);
			var bakedVertexes=vb.getData().slice();
			var vertexDeclaration=vb.vertexDeclaration;
			var positionOffset=vertexDeclaration.getVertexElementByUsage(/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION").offset / byteSizeInFloat;
			var normalOffset=vertexDeclaration.getVertexElementByUsage(/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL").offset / byteSizeInFloat;
			var transform=this._sprite3D.transform;
			var worldMatrix=transform.worldMatrix;
			var rotation=transform.rotation;
			var vertexFloatCount=vertexDeclaration.vertexStride / byteSizeInFloat;
			for (var i=0,n=bakedVertexes.length;i < n;i+=vertexFloatCount){
				var posOffset=i+positionOffset;
				var norOffset=i+normalOffset;
				Utils3D.transformVector3ArrayToVector3ArrayCoordinate(bakedVertexes,posOffset,worldMatrix,bakedVertexes,posOffset);
				Utils3D.transformVector3ArrayByQuat(bakedVertexes,normalOffset,rotation,bakedVertexes,normalOffset);
			}
			return bakedVertexes;
		}

		/**
		*@private
		*/
		__proto.getBakedIndices=function(){
			return this._renderObj._getIndexBuffer().getData();
		}

		__getset(0,__proto,'renderObj',function(){
			return this._renderObj;
			},function(value){
			if (this._renderObj!==value){
				this._renderObj=value;
			}
		});

		__static(RenderElement,
		['_tempVector30',function(){return this._tempVector30=new Vector3();},'_tempVector31',function(){return this._tempVector31=new Vector3();},'_tempQuaternion0',function(){return this._tempQuaternion0=new Quaternion();},'_tempMatrix4x40',function(){return this._tempMatrix4x40=new Matrix4x4();},'_tempMatrix4x41',function(){return this._tempMatrix4x41=new Matrix4x4();}
		]);
		return RenderElement;
	})()


	/**
	*@private
	*<code>RenderQuene</code> 类用于实现渲染队列。
	*/
	//class laya.d3.core.render.RenderQueue
	var RenderQueue=(function(){
		function RenderQueue(renderConfig,scene){
			this._id=0;
			this._needSort=false;
			this._renderElements=null;
			this._staticBatches=null;
			this._renderableRenderObjects=null;
			this._renderConfig=null;
			this._staticBatchCombineRenderElements=null;
			this._dynamicBatchCombineRenderElements=null;
			this._finalElements=null;
			this._scene=null;
			this._id=++RenderQueue._uniqueIDCounter;
			this._needSort=false;
			this._renderConfig=renderConfig;
			this._scene=scene;
			this._renderElements=[];
			this._renderableRenderObjects=[];
			this._staticBatchCombineRenderElements=[];
			this._dynamicBatchCombineRenderElements=[];
			this._staticBatches=[];
		}

		__class(RenderQueue,'laya.d3.core.render.RenderQueue');
		var __proto=RenderQueue.prototype;
		__proto._sortAlphaFunc=function(a,b){
			if (a._renderObject && b._renderObject)
				return Vector3.distance(b._renderObject._boundingSphere.center,RenderQueue._cameraPosition)-Vector3.distance(a._renderObject._boundingSphere.center,RenderQueue._cameraPosition);
			else
			return 0;
		}

		/**
		*@private
		*/
		__proto._begainRenderElement=function(state,renderObj,material){
			if (renderObj._beforeRender(state)){
				state.shaderValue.pushArray(renderObj._getVertexBuffer(0).vertexDeclaration.shaderValues);
				return true;
			}
			return false;
		}

		/**
		*@private
		*/
		__proto._endRenderElement=function(state,renderObj,material){
			material._upload(state,renderObj._getVertexBuffer(0).vertexDeclaration,null);
			renderObj._render(state);
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
		*/
		__proto._sortAlpha=function(cameraPos){
			RenderQueue._cameraPosition=cameraPos;
			this._finalElements.sort(this._sortAlphaFunc);
		}

		/**
		*@private
		*应用渲染状态到显卡。
		*@param gl WebGL上下文。
		*/
		__proto._setState=function(gl,state){
			WebGLContext.setDepthTest(gl,this._renderConfig.depthTest);
			WebGLContext.setDepthMask(gl,this._renderConfig.depthMask);
			WebGLContext.setBlend(gl,this._renderConfig.blend);
			WebGLContext.setBlendFunc(gl,this._renderConfig.sFactor,this._renderConfig.dFactor);
			WebGLContext.setCullFace(gl,this._renderConfig.cullFace);
			if (state.camera.renderTarget)
				WebGLContext.setFrontFaceCCW(gl,this._renderConfig.frontFace===/*laya.webgl.WebGLContext.CW*/0x0900 ? /*laya.webgl.WebGLContext.CCW*/0x0901 :/*laya.webgl.WebGLContext.CW*/0x0900);
			else
			WebGLContext.setFrontFaceCCW(gl,this._renderConfig.frontFace);
		}

		/**
		*@private
		*准备渲染队列。
		*@param state 渲染状态。
		*/
		__proto._preRender=function(state){
			this._staticBatchCombineRenderElements.length=0;
			for (var i=0,n=this._staticBatches.length;i < n;i++)
			this._staticBatches[i]._getRenderElement(this._staticBatchCombineRenderElements);
			this._finalElements=this._renderElements.concat(this._staticBatchCombineRenderElements,this._dynamicBatchCombineRenderElements);
		}

		/**
		*@private
		*渲染队列。
		*@param state 渲染状态。
		*/
		__proto._render=function(state){
			var preShaderValue=state.shaderValue.length;
			var preShadeDef=state.shaderDefs.getValue();
			for (var i=0,n=this._finalElements.length;i < n;i++){
				var renderElement=this._finalElements[i];
				var renderObj,material;
				if (renderElement._type===0){
					var owner=renderElement._sprite3D;
					state.owner=owner;
					state.renderElement=renderElement;
					this._preRenderUpdateComponents(owner,state);
					renderObj=renderElement.renderObj,material=renderElement._material;
					if (this._begainRenderElement(state,renderObj,material)){
						material._setLoopShaderParams(state,state.projectionViewMatrix,owner.transform.worldMatrix,renderElement.renderObj,material);
						this._endRenderElement(state,renderObj,material);
					}
					this._postRenderUpdateComponents(owner,state);
					}else if (renderElement._type===1){
					var staticBatch=renderElement.renderObj;
					state.owner=null;
					state.renderElement=renderElement;
					state._batchIndexStart=renderElement._batchIndexStart;
					state._batchIndexEnd=renderElement._batchIndexEnd;
					renderObj=renderElement.renderObj,material=renderElement._material;
					if (this._begainRenderElement(state,renderObj,material)){
						renderElement._material._setLoopShaderParams(state,state.projectionViewMatrix,staticBatch._rootSprite.transform.worldMatrix,renderElement.renderObj,renderElement._material);
						this._endRenderElement(state,renderObj,material);
					}
					}else if (renderElement._type===2){
					var dynamicBatch=renderElement.renderObj;
					state.owner=null;
					state.renderElement=renderElement;
					state._batchIndexStart=renderElement._batchIndexStart;
					state._batchIndexEnd=renderElement._batchIndexEnd;
					renderObj=renderElement.renderObj,material=renderElement._material;
					if (this._begainRenderElement(state,renderObj,material)){
						renderElement._material._setLoopShaderParams(state,state.projectionViewMatrix,Matrix4x4.DEFAULT,renderElement.renderObj,renderElement._material);
						this._endRenderElement(state,renderObj,material);
					}
				}
				state.shaderDefs.setValue(preShadeDef);
				state.shaderValue.length=preShaderValue;
			}
		}

		/**
		*清空队列中的渲染物体。
		*/
		__proto._clearRenderElements=function(){
			this._staticBatches.length=0;
			this._dynamicBatchCombineRenderElements.length=0;
			this._renderElements.length=0;
			this._needSort=true;
		}

		/**
		*添加渲染物体。
		*@param renderObj 渲染物体。
		*/
		__proto._addRenderElement=function(renderElement){
			this._renderElements.push(renderElement);
			this._needSort=true;
		}

		/**
		*添加静态批处理。
		*@param renderObj 静态批处理。
		*/
		__proto._addStaticBatch=function(staticBatch){
			this._staticBatches.push(staticBatch)
		}

		/**
		*添加动态批处理。
		*@param renderObj 动态批处理。
		*/
		__proto._addDynamicBatchElement=function(dynamicBatchElement){
			this._dynamicBatchCombineRenderElements.push(dynamicBatchElement);
		}

		/**
		*获取唯一标识ID(通常用于优化或识别)。
		*/
		__getset(0,__proto,'id',function(){
			return this._id;
		});

		RenderQueue._uniqueIDCounter=0;
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
		RenderQueue.NONDEPTH_ALPHA_BLEND=11;
		RenderQueue.NONDEPTH_ALPHA_BLEND_DOUBLEFACE=12;
		RenderQueue.NONDEPTH_ALPHA_ADDTIVE_BLEND=13;
		RenderQueue.NONDEPTH_ALPHA_ADDTIVE_BLEND_DOUBLEFACE=14;
		RenderQueue._cameraPosition=null
		return RenderQueue;
	})()


	/**
	*<code>RenderState</code> 类用于实现渲染状态。
	*/
	//class laya.d3.core.render.RenderState
	var RenderState=(function(){
		function RenderState(){
			this.elapsedTime=NaN;
			this.loopCount=0;
			this.context=null;
			this.scene=null;
			this.owner=null;
			this.renderElement=null;
			this._staticBatch=null;
			this._batchIndexStart=0;
			this._batchIndexEnd=0;
			this.camera=null;
			this.viewMatrix=null;
			this.projectionMatrix=null;
			this.projectionViewMatrix=null;
			this.cameraBoundingFrustum=null;
			this.viewport=null;
			this.worldShaderValue=new ValusArray;
			this.shaderValue=new ValusArray;
			this.shaderDefs=new ShaderDefines3D();
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
			(WebGL.frameShaderHighPrecision)&& (this.shaderDefs.setValue(/*laya.d3.shader.ShaderDefines3D.FSHIGHPRECISION*/0x80));
		}

		RenderState.VERTEXSHADERING=0x04;
		RenderState.PIXELSHADERING=0x08;
		RenderState.clientWidth=0;
		RenderState.clientHeight=0;
		return RenderState;
	})()


	/**
	*@private
	*<code>DynamicBatch</code> 类用于动态批处理。
	*/
	//class laya.d3.graphics.DynamicBatch
	var DynamicBatch=(function(){
		function DynamicBatch(vertexDeclaration){
			this._vertexDeclaration=null;
			this._vertexDatas=null;
			this._indexDatas=null;
			this._vertexBuffer=null;
			this._indexBuffer=null;
			this._currentCombineVertexCount=0;
			this._currentCombineIndexCount=0;
			this._combineRenderElements=null;
			this._materials=null;
			this._materialToRenderElementsOffsets=null;
			this._merageElements=null;
			this._combineRenderElementPool=null;
			this._combineRenderElementPoolIndex=0;
			this._currentCombineVertexCount=0;
			this._currentCombineIndexCount=0;
			this._combineRenderElements=[];
			this._materialToRenderElementsOffsets=[];
			this._materials=[];
			this._merageElements=[];
			this._combineRenderElementPool=[];
			this._combineRenderElementPoolIndex=0;
			this._vertexDeclaration=vertexDeclaration;
		}

		__class(DynamicBatch,'laya.d3.graphics.DynamicBatch');
		var __proto=DynamicBatch.prototype;
		Laya.imps(__proto,{"laya.d3.core.render.IRenderable":true})
		__proto._getVertexBuffer=function(index){
			(index===void 0)&& (index=0);
			if (index===0)
				return this._vertexBuffer;
			else
			return null;
		}

		__proto._getIndexBuffer=function(){
			return this._indexBuffer;
		}

		__proto._getCombineRenderElementFromPool=function(){
			var renderElement=this._combineRenderElementPool[this._combineRenderElementPoolIndex++];
			return renderElement || (this._combineRenderElementPool[this._combineRenderElementPoolIndex-1]=new RenderElement());
		}

		__proto._getRenderElement=function(){
			if (!this._vertexDatas){
				this._vertexDatas=new Float32Array(this._vertexDeclaration.vertexStride / 4 *DynamicBatch.maxVertexCount);
				this._indexDatas=new Uint16Array(DynamicBatch.maxIndexCount);
				this._vertexBuffer=VertexBuffer3D.create(this._vertexDeclaration,DynamicBatch.maxVertexCount,/*laya.webgl.WebGLContext.DYNAMIC_DRAW*/0x88E8);
				this._indexBuffer=IndexBuffer3D.create(/*laya.d3.graphics.IndexBuffer3D.INDEXTYPE_USHORT*/"ushort",DynamicBatch.maxIndexCount,/*laya.webgl.WebGLContext.DYNAMIC_DRAW*/0x88E8);
			}
			this._merageElements.length=0;
			var curMerVerCount=0;
			var curIndexCount=0;
			for (var i=0,n=this._combineRenderElements.length;i < n;i++){
				var renderElement=this._combineRenderElements[i];
				var subVertexDatas=renderElement.getDynamicBatchBakedVertexs(0);
				var subIndexDatas=renderElement.getBakedIndices();
				var indexOffset=curMerVerCount / (this._vertexDeclaration.vertexStride / 4);
				var indexStart=curIndexCount;
				var indexEnd=indexStart+subIndexDatas.length;
				renderElement._batchIndexStart=indexStart;
				renderElement._batchIndexEnd=indexEnd;
				this._indexDatas.set(subIndexDatas,curIndexCount);
				for (var k=indexStart;k < indexEnd;k++)
				this._indexDatas[k]=indexOffset+this._indexDatas[k];
				curIndexCount+=subIndexDatas.length;
				this._vertexDatas.set(subVertexDatas,curMerVerCount);
				curMerVerCount+=subVertexDatas.length;
			}
			this._vertexBuffer.setData(this._vertexDatas);
			this._indexBuffer.setData(this._indexDatas);
			this._combineRenderElementPoolIndex=0;
			for (i=0,n=this._materials.length;i < n;i++){
				var merageElement=this._getCombineRenderElementFromPool();
				merageElement._type=2;
				merageElement._staticBatch=null;
				merageElement.renderObj=this;
				var renderElementStartIndex=this._combineRenderElements[this._materialToRenderElementsOffsets[i]]._batchIndexStart;
				var renderElementEndIndex=(i+1===this._materialToRenderElementsOffsets.length)? curIndexCount :this._combineRenderElements[this._materialToRenderElementsOffsets[i+1]]._batchIndexStart;
				merageElement._batchIndexStart=renderElementStartIndex;
				merageElement._batchIndexEnd=renderElementEndIndex;
				merageElement._material=this._materials[i];
				this._merageElements.push(merageElement);
			}
		}

		__proto._addCombineRenderObjTest=function(renderElement){
			var renderObj=renderElement.renderObj;
			var indexCount=this._currentCombineIndexCount+renderObj._getIndexBuffer().indexCount;
			var vertexCount=this._currentCombineVertexCount+renderObj._getVertexBuffer().vertexCount;
			if (vertexCount > DynamicBatch.maxVertexCount || indexCount > DynamicBatch.maxIndexCount){
				return false;
			}
			return true;
		}

		__proto._addCombineRenderObj=function(renderElement){
			var renderObj=renderElement.renderObj;
			this._combineRenderElements.push(renderElement);
			this._currentCombineIndexCount=this._currentCombineIndexCount+renderObj._getIndexBuffer().indexCount;
			this._currentCombineVertexCount=this._currentCombineVertexCount+renderObj._getVertexBuffer().vertexCount;
		}

		__proto._addCombineMaterial=function(material){
			this._materials.push(material);
		}

		__proto._addMaterialToRenderElementOffset=function(offset){
			this._materialToRenderElementsOffsets.push(offset);
		}

		__proto._clearRenderElements=function(){
			this._combineRenderElements.length=0;
			this._materials.length=0;
			this._materialToRenderElementsOffsets.length=0;
			this._currentCombineVertexCount=0;
			this._currentCombineIndexCount=0;
		}

		__proto._addToRenderQueue=function(scene){
			this._getRenderElement();
			for (var i=0,n=this._materials.length;i < n;i++)
			scene.getRenderQueue(this._materials[i].renderQueue)._addDynamicBatchElement(this._merageElements[i]);
		}

		__proto._beforeRender=function(state){
			this._vertexBuffer._bind();
			this._indexBuffer._bind();
			return true;
		}

		__proto._render=function(state){
			var indexCount=state._batchIndexEnd-state._batchIndexStart;
			state.context.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,indexCount,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,state._batchIndexStart *2);
			Stat.drawCall++;
			Stat.trianglesFaces+=indexCount / 3;
		}

		__getset(0,__proto,'indexOfHost',function(){
			return 0;
		});

		__getset(0,__proto,'_vertexBufferCount',function(){
			return 1;
		});

		__getset(0,__proto,'triangleCount',function(){
			return this._indexBuffer.indexCount / 3;
		});

		__getset(0,__proto,'combineRenderElementsCount',function(){
			return this._combineRenderElements.length;
		});

		DynamicBatch.maxVertexCount=20000;
		DynamicBatch.maxIndexCount=40000;
		DynamicBatch.maxCombineTriangleCount=50;
		return DynamicBatch;
	})()


	/**
	*@private
	*<code>DynamicBatchManager</code> 类用于管理动态批处理。
	*/
	//class laya.d3.graphics.DynamicBatchManager
	var DynamicBatchManager=(function(){
		function DynamicBatchManager(){
			this._dynamicBatches=null;
			this._prepareDynamicBatchCombineElements=null;
			this._dynamicBatches={};
			this._prepareDynamicBatchCombineElements=[];
		}

		__class(DynamicBatchManager,'laya.d3.graphics.DynamicBatchManager');
		var __proto=DynamicBatchManager.prototype;
		__proto.getDynamicBatch=function(_vertexDeclaration,number){
			var dynamicBatch;
			var key=_vertexDeclaration.id.toString()+number;
			if (!this._dynamicBatches[key]){
				this._dynamicBatches[key]=dynamicBatch=new DynamicBatch(_vertexDeclaration);
				}else {
				dynamicBatch=this._dynamicBatches[key];
			}
			return dynamicBatch;
		}

		/**需手动调用*/
		__proto._garbageCollection=function(){
			for (var key in this._dynamicBatches)
			if (this._dynamicBatches[key].combineRenderElementsCount===0)
				delete this._dynamicBatches[key];
		}

		__proto._addPrepareRenderElement=function(renderElement){
			this._prepareDynamicBatchCombineElements.push(renderElement);
		}

		/**@private */
		__proto._finishCombineDynamicBatch=function(scene){
			this._prepareDynamicBatchCombineElements.sort(DynamicBatchManager._sortPrepareDynamicBatch);
			var lastMaterial;
			var lastVertexDeclaration;
			var lastRenderElement;
			var lastBatchNumber=-1;
			var lastCanMerage=true;
			var curMaterial;
			var curRenderElement;
			var curDynamicBatch;
			var curbatchNumber=0;
			var laterAddMaterial;
			var laterAddRenderElement;
			var laterAddMatToElementOffset=-1;
			for (var i=0,n=this._prepareDynamicBatchCombineElements.length;i < n;i++){
				curRenderElement=this._prepareDynamicBatchCombineElements[i];
				var curDeclaration=curRenderElement.renderObj._getVertexBuffer(0).vertexDeclaration;
				var declarationChanged=(lastVertexDeclaration!==curDeclaration);
				declarationChanged && (curbatchNumber=0,lastVertexDeclaration=curDeclaration);
				var batchNumbrChanged=(curbatchNumber!==lastBatchNumber);
				batchNumbrChanged && (lastBatchNumber=curbatchNumber);
				if ((declarationChanged)|| batchNumbrChanged){
					curDynamicBatch=this.getDynamicBatch(curDeclaration,curbatchNumber);
					lastMaterial=null;
				}
				if (lastCanMerage){
					if (curDynamicBatch._addCombineRenderObjTest(curRenderElement)){
						curMaterial=curRenderElement._material;
						if (lastMaterial!==curMaterial){
							if (laterAddMaterial){
								scene.getRenderQueue(laterAddRenderElement._material.renderQueue)._addRenderElement(laterAddRenderElement);
								laterAddMaterial=null;
								laterAddRenderElement=null;
								laterAddMatToElementOffset=-1;
							}
							laterAddMaterial=curMaterial;
							laterAddMatToElementOffset=curDynamicBatch.combineRenderElementsCount;
							laterAddRenderElement=curRenderElement;
							lastMaterial=curMaterial;
							}else {
							if (laterAddMaterial){
								var lastRenderObj=laterAddRenderElement.renderObj;
								var curRenderObj=curRenderElement.renderObj;
								if (((lastRenderObj._getVertexBuffer().vertexCount+curRenderObj._getVertexBuffer().vertexCount)> DynamicBatch.maxVertexCount)|| ((lastRenderObj._getIndexBuffer().indexCount+curRenderObj._getIndexBuffer().indexCount)> DynamicBatch.maxIndexCount)){
									scene.getRenderQueue(laterAddRenderElement._material.renderQueue)._addRenderElement(laterAddRenderElement);
									laterAddMaterial=curMaterial;
									laterAddMatToElementOffset=curDynamicBatch.combineRenderElementsCount;
									laterAddRenderElement=curRenderElement;
									}else {
									curDynamicBatch._addCombineMaterial(laterAddMaterial);
									curDynamicBatch._addMaterialToRenderElementOffset(laterAddMatToElementOffset);
									curDynamicBatch._addCombineRenderObj(laterAddRenderElement);
									laterAddMaterial=null;
									laterAddRenderElement=null;
									laterAddMatToElementOffset=-1;
									curDynamicBatch._addCombineRenderObj(curRenderElement);
								}
								}else {
								curDynamicBatch._addCombineRenderObj(curRenderElement);
							}
						}
						lastCanMerage=true;
						}else {
						if (laterAddMaterial){
							scene.getRenderQueue(laterAddRenderElement._material.renderQueue)._addRenderElement(laterAddRenderElement);
							laterAddMaterial=null;
							laterAddRenderElement=null;
							laterAddMatToElementOffset=-1;
						}
						curbatchNumber++;
						lastCanMerage=false;
					}
					}else {
					lastRenderElement=this._prepareDynamicBatchCombineElements[i-1];
					curDynamicBatch._addMaterialToRenderElementOffset(curDynamicBatch.combineRenderElementsCount);
					lastMaterial=lastRenderElement._material;
					curDynamicBatch._addCombineMaterial(lastMaterial);
					curDynamicBatch._addCombineRenderObj(lastRenderElement);
					lastCanMerage=true;
					curMaterial=curRenderElement._material;
					if (lastMaterial!==curMaterial){
						laterAddMaterial=curMaterial;
						laterAddMatToElementOffset=curDynamicBatch.combineRenderElementsCount;
						laterAddRenderElement=curRenderElement;
						}else {
						curDynamicBatch._addCombineRenderObj(curRenderElement);
					}
					lastMaterial=curMaterial;
				}
			}
			if (laterAddMaterial){
				scene.getRenderQueue(laterAddRenderElement._material.renderQueue)._addRenderElement(laterAddRenderElement);
				laterAddMaterial=null;
				laterAddRenderElement=null;
				laterAddMatToElementOffset=-1;
			}
			this._prepareDynamicBatchCombineElements.length=0;
		}

		__proto._clearRenderElements=function(){
			for (var key in this._dynamicBatches)
			this._dynamicBatches[key]._clearRenderElements();
		}

		__proto._addToRenderQueue=function(scene){
			for (var key in this._dynamicBatches){
				var dynamicBatch=this._dynamicBatches[key];
				(dynamicBatch.combineRenderElementsCount > 0)&& (dynamicBatch._addToRenderQueue(scene));
			}
		}

		__proto.dispose=function(){
			this._dynamicBatches=null;
		}

		DynamicBatchManager._sortPrepareDynamicBatch=function(a,b){
			return a._mainSortID-b._mainSortID;
		}

		return DynamicBatchManager;
	})()


	/**
	*...
	*@author ...
	*/
	//class laya.d3.graphics.FrustumCulling
	var FrustumCulling=(function(){
		function FrustumCulling(){}
		__class(FrustumCulling,'laya.d3.graphics.FrustumCulling');
		FrustumCulling.RenderObjectCulling=function(boundFrustum,scene){
			var i=0,iNum=0,j=0,jNum=0;
			var frustumCullingObject;
			var renderElement;
			var curRenderQueue;
			var queues=scene._quenes;
			var staticBatchMananger=scene._staticBatchManager;
			var dynamicBatchManager=scene._dynamicBatchManager;
			var frustumCullingObjects=scene._frustumCullingObjects;
			for (i=0,iNum=queues.length;i < iNum;i++)
			(queues[i])&& (queues[i]._clearRenderElements());
			staticBatchMananger._clearRenderElements();
			dynamicBatchManager._clearRenderElements();
			for (i=0,iNum=frustumCullingObjects.length;i < iNum;i++){
				frustumCullingObject=frustumCullingObjects[i];
				if (Layer.isVisible(frustumCullingObject._layerMask)&& frustumCullingObject._ownerEnable && frustumCullingObject._enable && (boundFrustum.ContainsBoundSphere(frustumCullingObject._boundingSphere)!==/*laya.d3.math.ContainmentType.Disjoint*/0)){
					for (j=0,jNum=frustumCullingObject._renderElements.length;j < jNum;j++){
						renderElement=frustumCullingObject._renderElements[j];
						var staticBatch=renderElement._staticBatch;
						if (staticBatch && (staticBatch._material===renderElement._material)){
							staticBatch._addRenderElement(renderElement);
							}else {
							var renderObj=renderElement.renderObj;
							if ((renderObj.triangleCount < /*laya.d3.graphics.DynamicBatch.maxCombineTriangleCount*/50)&& (renderObj._vertexBufferCount===1)&& (renderObj._getIndexBuffer())&&(renderElement._material.renderQueue<3)&&renderElement._canDynamicBatch)
								dynamicBatchManager._addPrepareRenderElement(renderElement);
							else
							scene.getRenderQueue(renderElement._material.renderQueue)._addRenderElement(renderElement);
						}
					}
				}
			}
			staticBatchMananger._addToRenderQueue(scene);
			dynamicBatchManager._finishCombineDynamicBatch(scene);
			dynamicBatchManager._addToRenderQueue(scene);
		}

		return FrustumCulling;
	})()


	/**
	*...
	*@author ...
	*/
	//class laya.d3.graphics.RenderObject
	var RenderObject=(function(){
		function RenderObject(){
			this._render=null;
			this._renderElements=null;
			this._layerMask=0;
			this._ownerEnable=false;
			this._enable=false;
			this._renderElements=[];
		}

		__class(RenderObject,'laya.d3.graphics.RenderObject');
		var __proto=RenderObject.prototype;
		__getset(0,__proto,'_boundingSphere',function(){
			return this._render.boundingSphere;
		});

		return RenderObject;
	})()


	/**
	*@private
	*<code>StaticBatch</code> 类用于静态批处理。
	*/
	//class laya.d3.graphics.StaticBatch
	var StaticBatch=(function(){
		function StaticBatch(rootSprite,vertexDeclaration,material){
			this._vertexBuffer=null;
			this._indexBuffer=null;
			this._renderElements=null;
			this._combineRenderElementPool=null;
			this._combineRenderElementPoolIndex=0;
			this._combineRenderElements=null;
			this._currentCombineVertexCount=0;
			this._currentCombineIndexCount=0;
			this._needFinishCombine=false;
			this._rootSprite=null;
			this._vertexDeclaration=null;
			this._material=null;
			this._currentCombineVertexCount=0;
			this._currentCombineIndexCount=0;
			this._needFinishCombine=false;
			this._renderElements=[];
			this._combineRenderElements=[];
			this._combineRenderElementPool=[];
			this._combineRenderElementPoolIndex=0;
			this._rootSprite=rootSprite;
			this._vertexDeclaration=vertexDeclaration;
			this._material=material;
		}

		__class(StaticBatch,'laya.d3.graphics.StaticBatch');
		var __proto=StaticBatch.prototype;
		Laya.imps(__proto,{"laya.d3.core.render.IRenderable":true})
		__proto._getVertexBuffer=function(index){
			(index===void 0)&& (index=0);
			if (index===0)
				return this._vertexBuffer;
			else
			return null;
		}

		__proto._getIndexBuffer=function(){
			return this._indexBuffer;
		}

		__proto._getCombineRenderElementFromPool=function(){
			var renderElement=this._combineRenderElementPool[this._combineRenderElementPoolIndex++];
			return renderElement || (this._combineRenderElementPool[this._combineRenderElementPoolIndex-1]=new RenderElement());
		}

		__proto._addCombineRenderObjTest=function(renderElement){
			var renderObj=renderElement.renderObj;
			var vertexCount=this._currentCombineVertexCount+renderObj._getVertexBuffer().vertexCount;
			if (vertexCount > StaticBatch.maxVertexCount){
				return false;
			}
			return true;
		}

		__proto._addCombineRenderObj=function(renderElement){
			var renderObj=renderElement.renderObj;
			this._combineRenderElements.push(renderElement);
			renderElement._staticBatch=this;
			this._currentCombineIndexCount=this._currentCombineIndexCount+renderObj._getIndexBuffer().indexCount;
			this._currentCombineVertexCount=this._currentCombineVertexCount+renderObj._getVertexBuffer().vertexCount;
			this._needFinishCombine=true;
		}

		__proto._deleteCombineRenderObj=function(renderElement){
			var renderObj=renderElement.renderObj;
			var index=this._combineRenderElements.indexOf(renderElement);
			if (index!==-1){
				this._combineRenderElements.splice(index,1);
				renderElement._staticBatch=null;
				this._currentCombineIndexCount=this._currentCombineIndexCount-renderObj._getIndexBuffer().indexCount;
				this._currentCombineVertexCount=this._currentCombineVertexCount-renderObj._getVertexBuffer().vertexCount;
				this._needFinishCombine=true;
			}
		}

		__proto._finshCombine=function(){
			if (this._needFinishCombine){
				var curMerVerCount=0;
				var curIndexCount=0;
				var vertexDatas=new Float32Array(this._vertexDeclaration.vertexStride / 4 *this._currentCombineVertexCount);
				var indexDatas=new Uint16Array(this._currentCombineIndexCount);
				if (this._vertexBuffer){
					this._vertexBuffer.dispose();
					this._indexBuffer.dispose();
				}
				this._vertexBuffer=VertexBuffer3D.create(this._vertexDeclaration,this._currentCombineVertexCount,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4);
				this._indexBuffer=IndexBuffer3D.create(/*laya.d3.graphics.IndexBuffer3D.INDEXTYPE_USHORT*/"ushort",this._currentCombineIndexCount,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4);
				for (var i=0,n=this._combineRenderElements.length;i < n;i++){
					var renderElement=this._combineRenderElements[i];
					var subVertexDatas=renderElement.getStaticBatchBakedVertexs(0);
					var subIndexDatas=renderElement.getBakedIndices();
					var indexOffset=curMerVerCount / (this._vertexDeclaration.vertexStride / 4);
					var indexStart=curIndexCount;
					var indexEnd=indexStart+subIndexDatas.length;
					renderElement._batchIndexStart=indexStart;
					renderElement._batchIndexEnd=indexEnd;
					indexDatas.set(subIndexDatas,curIndexCount);
					for (var k=indexStart;k < indexEnd;k++)
					indexDatas[k]=indexOffset+indexDatas[k];
					curIndexCount+=subIndexDatas.length;
					vertexDatas.set(subVertexDatas,curMerVerCount);
					curMerVerCount+=subVertexDatas.length;
				}
				this._vertexBuffer.setData(vertexDatas);
				this._indexBuffer.setData(indexDatas);
				this._needFinishCombine=false;
			}
		}

		__proto._clearRenderElements=function(){
			this._renderElements.length=0;
		}

		__proto._addRenderElement=function(renderElement){
			for (var i=0,n=this._renderElements.length;i < n;i++){
				if (this._renderElements[i]._batchIndexStart > renderElement._batchIndexStart){
					this._renderElements.splice(i,0,renderElement);
					return;
				}
			}
			this._renderElements.push(renderElement);
		}

		__proto._getRenderElement=function(mergeElements){
			this._combineRenderElementPoolIndex=0;
			var length=this._renderElements.length;
			var merageElement=this._getCombineRenderElementFromPool();
			merageElement._type=1;
			merageElement._staticBatch=null;
			merageElement.renderObj=this;
			merageElement._batchIndexStart=this._renderElements[0]._batchIndexStart;
			merageElement._batchIndexEnd=this._renderElements[0]._batchIndexEnd;
			merageElement._material=this._material;
			merageElement._material=this._material;
			mergeElements.push(merageElement);
			if (length > 1){
				for (var i=1;i < length;i++){
					var renderElement=this._renderElements[i];
					if (this._renderElements[i-1]._batchIndexEnd!==renderElement._batchIndexStart){
						merageElement=this._getCombineRenderElementFromPool();
						merageElement._type=1;
						merageElement._staticBatch=null;
						merageElement.renderObj=this;
						merageElement._batchIndexStart=renderElement._batchIndexStart;
						merageElement._batchIndexEnd=renderElement._batchIndexEnd;
						merageElement._material=this._material;
						mergeElements.push(merageElement);
						}else {
						merageElement._batchIndexEnd=renderElement._batchIndexEnd;
					}
				}
			}
		}

		__proto._addToRenderQueue=function(scene){
			(this._renderElements.length > 0)&& (scene.getRenderQueue(this._material.renderQueue)._addStaticBatch(this));
		}

		//TODO:>0移到外层
		__proto._beforeRender=function(state){
			this._vertexBuffer._bind();
			this._indexBuffer._bind();
			return true;
		}

		__proto._render=function(state){
			var indexCount=state._batchIndexEnd-state._batchIndexStart;
			state.context.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,indexCount,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,state._batchIndexStart *2);
			Stat.drawCall++;
			Stat.trianglesFaces+=indexCount / 3;
		}

		__getset(0,__proto,'_vertexBufferCount',function(){
			return 1;
		});

		__getset(0,__proto,'indexOfHost',function(){
			return 0;
		});

		__getset(0,__proto,'triangleCount',function(){
			return this._indexBuffer.indexCount / 3;
		});

		StaticBatch._addToRenderQueueStaticBatch=function(scene,sprite3D){
			var i=0,n=0;
			if (((sprite3D instanceof laya.d3.core.MeshSprite3D ))&& (sprite3D.isStatic)){
				var renderElements=(sprite3D).meshRender.renderObject._renderElements;
				for (i=0,n=renderElements.length;i < n;i++){
					var renderElement=renderElements[i];
					if (renderElement.renderObj._vertexBufferCount===1)
						scene._staticBatchManager._addPrepareRenderElement(renderElement);
				}
			}
			for (i=0,n=sprite3D.numChildren;i < n;i++)
			StaticBatch._addToRenderQueueStaticBatch(scene,sprite3D._childs [i]);
		}

		StaticBatch.combine=function(staticBatchRoot){
			var scene=staticBatchRoot.scene;
			if (!scene)
				throw new Error("BaseScene: staticBatchRoot is not a part of scene.");
			StaticBatch._addToRenderQueueStaticBatch(scene,staticBatchRoot);
			scene._staticBatchManager._finishCombineStaticBatch(staticBatchRoot);
		}

		StaticBatch.maxVertexCount=65535;
		return StaticBatch;
	})()


	/**
	*@private
	*<code>StaticBatchManager</code> 类用于管理静态批处理。
	*/
	//class laya.d3.graphics.StaticBatchManager
	var StaticBatchManager=(function(){
		function StaticBatchManager(){
			this._staticBatches=null;
			this._prepareStaticBatchCombineElements=null;
			this._staticBatches={};
			this._prepareStaticBatchCombineElements=[];
		}

		__class(StaticBatchManager,'laya.d3.graphics.StaticBatchManager');
		var __proto=StaticBatchManager.prototype;
		/**完成合并*/
		__proto._finshCombine=function(){
			for (var key in this._staticBatches)
			this._staticBatches[key]._finshCombine();
		}

		__proto.getStaticBatch=function(rootSprite,_vertexDeclaration,material,number){
			var staticBatch;
			var key=rootSprite.id.toString()+material.id.toString()+_vertexDeclaration.id.toString()+number;
			if (!this._staticBatches[key]){
				this._staticBatches[key]=staticBatch=new StaticBatch(rootSprite,_vertexDeclaration,material);
				}else {
				staticBatch=this._staticBatches[key];
			}
			return staticBatch;
		}

		/**@private 通常应在所有getStaticBatchQneue函数相关操作结束后执行*/
		__proto._garbageCollection=function(){
			for (var key in this._staticBatches)
			if (this._staticBatches[key].combineRenderElementsCount===0)
				delete this._staticBatches[key];
		}

		/**@private */
		__proto._addPrepareRenderElement=function(renderElement){
			this._prepareStaticBatchCombineElements.push(renderElement);
		}

		/**@private */
		__proto._finishCombineStaticBatch=function(rootSprite){
			this._prepareStaticBatchCombineElements.sort(StaticBatchManager._sortPrepareStaticBatch);
			var lastMaterial;
			var lastVertexDeclaration;
			var lastCanMerage=false;
			var curStaticBatch;
			var renderElement;
			var lastRenderObj;
			var vb;
			var oldStaticBatch;
			var batchNumber=0;
			for (var i=0,n=this._prepareStaticBatchCombineElements.length;i < n;i++){
				renderElement=this._prepareStaticBatchCombineElements[i];
				vb=renderElement.renderObj._getVertexBuffer(0);
				if ((lastVertexDeclaration===vb.vertexDeclaration)&& (lastMaterial===renderElement._material)){
					if (!lastCanMerage){
						lastRenderObj=this._prepareStaticBatchCombineElements[i-1];
						var lastRenderElement=lastRenderObj.renderObj;
						var curRenderElement=renderElement.renderObj;
						if (((lastRenderElement._getVertexBuffer().vertexCount+curRenderElement._getVertexBuffer().vertexCount)> StaticBatch.maxVertexCount)){
							lastCanMerage=false;
							}else {
							curStaticBatch=this.getStaticBatch(rootSprite,lastVertexDeclaration,lastMaterial,batchNumber);
							oldStaticBatch=lastRenderObj._staticBatch;
							(oldStaticBatch)&& (oldStaticBatch!==curStaticBatch)&& (oldStaticBatch._deleteCombineRenderObj(lastRenderObj));
							curStaticBatch._addCombineRenderObj(lastRenderObj);
							oldStaticBatch=renderElement._staticBatch;
							(oldStaticBatch)&& (oldStaticBatch!==curStaticBatch)&& (oldStaticBatch._deleteCombineRenderObj(renderElement));
							curStaticBatch._addCombineRenderObj(renderElement);
							lastCanMerage=true;
						}
						}else {
						if (!curStaticBatch._addCombineRenderObjTest(renderElement)){
							lastCanMerage=false;
							batchNumber++;
							}else {
							oldStaticBatch=renderElement._staticBatch;
							(oldStaticBatch)&& (oldStaticBatch!==curStaticBatch)&& (oldStaticBatch._deleteCombineRenderObj(renderElement));
							curStaticBatch._addCombineRenderObj(renderElement)
						}
					}
					}else {
					lastCanMerage=false;
					batchNumber=0;
				}
				lastMaterial=renderElement._material;
				lastVertexDeclaration=vb.vertexDeclaration;
			}
			this._garbageCollection();
			this._finshCombine();
			this._prepareStaticBatchCombineElements.length=0;
		}

		__proto._clearRenderElements=function(){
			for (var key in this._staticBatches)
			this._staticBatches[key]._clearRenderElements();
		}

		__proto._addToRenderQueue=function(scene){
			for (var key in this._staticBatches)
			this._staticBatches[key]._addToRenderQueue(scene);
		}

		__proto.dispose=function(){
			this._staticBatches=null;
		}

		StaticBatchManager._sortPrepareStaticBatch=function(a,b){
			var id=a._mainSortID-b._mainSortID;
			return (id===0)? (a.renderObj.triangleCount-b.renderObj.triangleCount):id;
		}

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
			this._shaderDefine=0;
			this._vertexStride=0;
			this._vertexElements=null;
			this._vertexElementsDic=null;
			this._id=++VertexDeclaration._uniqueIDCounter;
			if (this._id > VertexDeclaration.maxVertexDeclaration)
				throw new Error("VertexDeclaration: VertexDeclaration count should not large than ",VertexDeclaration.maxVertexDeclaration);
			this._shaderValues=new ValusArray();
			this._vertexElementsDic={};
			this._vertexStride=vertexStride;
			this._vertexElements=vertexElements;
			for (var i=0;i < vertexElements.length;i++){
				var vertexElement=vertexElements[i];
				var attributeName=vertexElement.elementUsage;
				this._vertexElementsDic[attributeName]=vertexElement;
				var value=[VertexDeclaration._getTypeSize(vertexElement.elementFormat)/ 4,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,this._vertexStride,vertexElement.offset];
				this._shaderValues.pushValue(attributeName,value);
				switch (attributeName){
					case /*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV":
						this._shaderDefine |=/*laya.d3.shader.ShaderDefines3D.UV*/0x400;
						break ;
					case /*laya.d3.graphics.VertexElementUsage.COLOR0*/"COLOR":
						this._shaderDefine |=/*laya.d3.shader.ShaderDefines3D.COLOR*/0x800;
						break ;
					}
			}
		}

		__class(VertexDeclaration,'laya.d3.graphics.VertexDeclaration');
		var __proto=VertexDeclaration.prototype;
		__proto.getVertexElements=function(){
			return this._vertexElements.slice();
		}

		__proto.getVertexElementByUsage=function(usage){
			return this._vertexElementsDic[usage];
		}

		__proto.unBinding=function(){}
		/**
		*获取唯一标识ID(通常用于优化或识别)。
		*@return 唯一标识ID
		*/
		__getset(0,__proto,'id',function(){
			return this._id;
		});

		__getset(0,__proto,'vertexStride',function(){
			return this._vertexStride;
		});

		__getset(0,__proto,'shaderValues',function(){
			return this._shaderValues;
		});

		__getset(0,__proto,'shaderDefine',function(){
			return this._shaderDefine;
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
				case /*laya.d3.graphics.VertexElementFormat.Color*/"color":
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
		VertexElementFormat.Color="color";
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
		VertexElementUsage.STARTSIZE="STARTSIZE";
		VertexElementUsage.AGEADDSCALE0="AGEADDSCALE0";
		VertexElementUsage.STARTROTATION0="STARTROTATION0";
		VertexElementUsage.STARTROTATION1="STARTROTATION1";
		VertexElementUsage.STARTROTATION2="STARTROTATION2";
		VertexElementUsage.ENDCOLOR0="ENDCOLOR";
		VertexElementUsage.SIZEROTATION0="SIZEROTATION";
		VertexElementUsage.RADIUS0="RADIUS";
		VertexElementUsage.RADIAN0="RADIAN";
		VertexElementUsage.STARTLIFETIME="STARTLIFETIME";
		VertexElementUsage.STARTSPEED="STARTSPEED";
		VertexElementUsage.DIRECTION="DIRECTION";
		VertexElementUsage.TIME0="TIME";
		VertexElementUsage.RANDOM0="RANDOM0";
		VertexElementUsage.RANDOM1="RANDOM1";
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
		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
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
		__getset(0,__proto,'endColor',function(){
			return this._endColor;
		});

		__getset(0,__proto,'cornerTextureCoordinate',function(){
			return this._cornerTextureCoordinate;
		});

		__getset(0,__proto,'sizeRotation',function(){
			return this._sizeRotation;
		});

		__getset(0,__proto,'velocity',function(){
			return this._velocity;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'startColor',function(){
			return this._startColor;
		});

		__getset(0,__proto,'radius',function(){
			return this._radius;
		});

		__getset(0,__proto,'radian',function(){
			return this._radian;
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
			new VertexElement(108,/*laya.d3.graphics.VertexElementFormat.Single*/"single",/*laya.d3.graphics.VertexElementUsage.STARTLIFETIME*/"STARTLIFETIME"),
			new VertexElement(112,/*laya.d3.graphics.VertexElementFormat.Single*/"single",/*laya.d3.graphics.VertexElementUsage.TIME0*/"TIME")]);}
		]);
		return VertexParticle;
	})()


	/**
	*<code>VertexPositionNormalColorTangent</code> 类用于创建粒子顶点结构。
	*/
	//class laya.d3.graphics.VertexParticleShuriken
	var VertexParticleShuriken=(function(){
		function VertexParticleShuriken(cornerTextureCoordinate,position,velocity,startColor,startSize,startRotation0,startRotation1,startRotation2,ageAddScale,time,startSpeed,randoms0,randoms1){
			this._cornerTextureCoordinate=null;
			this._position=null;
			this._velocity=null;
			this._startColor=null;
			this._startSize=null;
			this._startRotation0=null;
			this._startRotation1=null;
			this._startRotation2=null;
			this._startLifeTime=NaN;
			this._time=NaN;
			this._startSpeed=NaN;
			this._randoms0=null;
			this._randoms1=null;
			this._cornerTextureCoordinate=cornerTextureCoordinate;
			this._position=position;
			this._velocity=velocity;
			this._startColor=startColor;
			this._startSize=startSize;
			this._startRotation0=startRotation0;
			this._startRotation1=startRotation1;
			this._startRotation2=startRotation2;
			this._startLifeTime=ageAddScale;
			this._time=time;
			this._startSpeed=startSpeed;
			this._randoms0=this.random0;
			this._randoms1=this.random1;
		}

		__class(VertexParticleShuriken,'laya.d3.graphics.VertexParticleShuriken');
		var __proto=VertexParticleShuriken.prototype;
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

		__getset(0,__proto,'random0',function(){
			return this._randoms0;
		});

		__getset(0,__proto,'startSize',function(){
			return this._startSize;
		});

		__getset(0,__proto,'startColor',function(){
			return this._startColor;
		});

		__getset(0,__proto,'startRotation0',function(){
			return this._startRotation0;
		});

		__getset(0,__proto,'startRotation1',function(){
			return this._startRotation1;
		});

		__getset(0,__proto,'random1',function(){
			return this._randoms1;
		});

		__getset(0,__proto,'startRotation2',function(){
			return this._startRotation2;
		});

		__getset(0,__proto,'startLifeTime',function(){
			return this._startLifeTime;
		});

		__getset(0,__proto,'time',function(){
			return this._time;
		});

		__getset(0,__proto,'startSpeed',function(){
			return this._startSpeed;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexParticleShuriken._vertexDeclaration;
		});

		__getset(1,VertexParticleShuriken,'vertexDeclaration',function(){
			return VertexParticleShuriken._vertexDeclaration;
		});

		__static(VertexParticleShuriken,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(148,
			[new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.CORNERTEXTURECOORDINATE0*/"CORNERTEXTURECOORDINATE"),
			new VertexElement(16,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),
			new VertexElement(28,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.DIRECTION*/"DIRECTION"),
			new VertexElement(40,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.STARTCOLOR0*/"STARTCOLOR"),
			new VertexElement(56,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.STARTSIZE*/"STARTSIZE"),
			new VertexElement(68,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.STARTROTATION0*/"STARTROTATION0"),
			new VertexElement(80,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.STARTROTATION1*/"STARTROTATION1"),
			new VertexElement(92,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.STARTROTATION2*/"STARTROTATION2"),
			new VertexElement(104,/*laya.d3.graphics.VertexElementFormat.Single*/"single",/*laya.d3.graphics.VertexElementUsage.STARTLIFETIME*/"STARTLIFETIME"),
			new VertexElement(108,/*laya.d3.graphics.VertexElementFormat.Single*/"single",/*laya.d3.graphics.VertexElementUsage.TIME0*/"TIME"),
			new VertexElement(112,/*laya.d3.graphics.VertexElementFormat.Single*/"single",/*laya.d3.graphics.VertexElementUsage.STARTSPEED*/"STARTSPEED"),
			new VertexElement(116,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.RANDOM0*/"RANDOM0"),
			new VertexElement(132,/*laya.d3.graphics.VertexElementFormat.Vector4*/"vector4",/*laya.d3.graphics.VertexElementUsage.RANDOM1*/"RANDOM1")]);}
		]);
		return VertexParticleShuriken;
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
		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
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
		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
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
		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
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
		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
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
		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
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
		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'textureCoordinate0',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorTexture0Texture1._vertexDeclaration;
		});

		__getset(0,__proto,'textureCoordinate1',function(){
			return this._textureCoordinate1;
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
		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'textureCoordinate0',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorTexture0Texture1Skin._vertexDeclaration;
		});

		__getset(0,__proto,'textureCoordinate1',function(){
			return this._textureCoordinate1;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
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

		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'textureCoordinate0',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorTexture0Texture1SkinTangent._vertexDeclaration;
		});

		__getset(0,__proto,'textureCoordinate1',function(){
			return this._textureCoordinate1;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
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

		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'textureCoordinate0',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorTexture0Texture1Tangent._vertexDeclaration;
		});

		__getset(0,__proto,'textureCoordinate1',function(){
			return this._textureCoordinate1;
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
		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
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
		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
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
		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
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
		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
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
		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'textureCoordinate0',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalTexture0Texture1._vertexDeclaration;
		});

		__getset(0,__proto,'textureCoordinate1',function(){
			return this._textureCoordinate1;
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
		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'textureCoordinate0',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalTexture0Texture1Skin._vertexDeclaration;
		});

		__getset(0,__proto,'textureCoordinate1',function(){
			return this._textureCoordinate1;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
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

		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'textureCoordinate0',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalTexture0Texture1SkinTangent._vertexDeclaration;
		});

		__getset(0,__proto,'textureCoordinate1',function(){
			return this._textureCoordinate1;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
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

		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'textureCoordinate0',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalTexture0Texture1Tangent._vertexDeclaration;
		});

		__getset(0,__proto,'textureCoordinate1',function(){
			return this._textureCoordinate1;
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
		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
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
		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
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
		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'position',function(){
			return this._position;
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
			this._version=null;
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
			this._fileData=data;
			this._readData=new Byte(this._fileData);
			this._readData.pos=0;
			this._version=this._readData.readUTFString();
			this.READ_BLOCK();
			for (var i=0;i < this._BLOCK.count;i++){
				var index=this._readData.getUint16();
				var blockName=this._strings[index];
				var fn=this["READ_"+blockName];
				if (fn==null)throw new Error("model file err,no this function:"+index+" "+blockName);
				if (!fn.call(this))break ;
			}
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
				this._materials[index]=Laya.loader.create(url,null,null,StandardMaterial);
				}else {
				this._materials[index]=new BaseMaterial();
			}
			return true;
		}

		__proto.READ_MESH=function(){
			var name=this._readString();
			switch (this._version){
				case "LAYAMODEL:01":
					console.log("Warning: The (.lm) file is converted by old fbxTools,please reConverted it use  lastest fbxTools version,later we will remove the  support of old version (.lm) support.");
					break ;
				case "LAYASKINANI:01":;
					var arrayBuffer=this._readData.__getBuffer();
					var i=0,n=0;
					var bindPoseStart=this._readData.getUint32();
					var binPoseLength=this._readData.getUint32();
					var bindPoseDatas=new Float32Array(arrayBuffer.slice(bindPoseStart+this._DATA.offset,bindPoseStart+this._DATA.offset+binPoseLength));
					this.mesh._bindPoses=[];
					for (i=0,n=bindPoseDatas.length;i < n;i+=16){
						var bindPose=new Matrix4x4(bindPoseDatas[i+0],bindPoseDatas[i+1],bindPoseDatas[i+2],bindPoseDatas[i+3],bindPoseDatas[i+4],bindPoseDatas[i+5],bindPoseDatas[i+6],bindPoseDatas[i+7],bindPoseDatas[i+8],bindPoseDatas[i+9],bindPoseDatas[i+10],bindPoseDatas[i+11],bindPoseDatas[i+12],bindPoseDatas[i+13],bindPoseDatas[i+14],bindPoseDatas[i+15]);
						this.mesh._bindPoses.push(bindPose);
					};
					var inverseGlobalBindPoseStart=this._readData.getUint32();
					var inverseGlobalBinPoseLength=this._readData.getUint32();
					var invGloBindPoseDatas=new Float32Array(arrayBuffer.slice(inverseGlobalBindPoseStart+this._DATA.offset,inverseGlobalBindPoseStart+this._DATA.offset+inverseGlobalBinPoseLength));
					this.mesh._inverseBindPoses=[];
					for (i=0,n=invGloBindPoseDatas.length;i < n;i+=16){
						var inverseGlobalBindPose=new Matrix4x4(invGloBindPoseDatas[i+0],invGloBindPoseDatas[i+1],invGloBindPoseDatas[i+2],invGloBindPoseDatas[i+3],invGloBindPoseDatas[i+4],invGloBindPoseDatas[i+5],invGloBindPoseDatas[i+6],invGloBindPoseDatas[i+7],invGloBindPoseDatas[i+8],invGloBindPoseDatas[i+9],invGloBindPoseDatas[i+10],invGloBindPoseDatas[i+11],invGloBindPoseDatas[i+12],invGloBindPoseDatas[i+13],invGloBindPoseDatas[i+14],invGloBindPoseDatas[i+15]);
						this.mesh._inverseBindPoses.push(inverseGlobalBindPose);
					}
					break ;
				default :
					throw new Error("LoadModel:unknown version.");
				}
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
			var submesh=new SubMesh();
			var vertexDeclaration=this._getVertexDeclaration();
			var vb=VertexBuffer3D.create(vertexDeclaration,vbsize / vertexDeclaration.vertexStride,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4,true);
			var vbStart=vbofs+this._DATA.offset;
			var vbArrayBuffer=arrayBuffer.slice(vbStart,vbStart+vbsize);
			vb.setData(new Float32Array(vbArrayBuffer));
			submesh._vertexBuffer=vb;
			var vertexElements=vb.vertexDeclaration.getVertexElements();
			for (var i=0;i < vertexElements.length;i++)
			submesh._bufferUsage[(vertexElements [i]).elementUsage]=vb;
			var ib=IndexBuffer3D.create(/*laya.d3.graphics.IndexBuffer3D.INDEXTYPE_USHORT*/"ushort",ibsize / 2,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4,true);
			var ibStart=ibofs+this._DATA.offset;
			var ibArrayBuffer=arrayBuffer.slice(ibStart,ibStart+ibsize);
			ib.setData(new Uint16Array(ibArrayBuffer));
			submesh._indexBuffer=ib;
			var boneDicArrayBuffer=arrayBuffer.slice(boneDicofs+this._DATA.offset,boneDicofs+this._DATA.offset+boneDicsize);
			submesh._boneIndices=new Uint8Array(boneDicArrayBuffer);
			this._mesh._add(submesh);
			return true;
		}

		__proto.READ_DATAAREA=function(){
			return false;
		}

		__proto._getVertexDeclaration=function(){
			var position=false,normal=false,color=false,texcoord0=false,texcoord1=false,tangent=false,blendWeight=false,blendIndex=false;
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
					case "TANGENT":
						tangent=true;
						break ;
					}
			};
			var vertexDeclaration;
			if (position && normal && color && texcoord0 && texcoord1 && blendWeight && blendIndex && tangent)
				vertexDeclaration=VertexPositionNormalColorTexture0Texture1SkinTangent.vertexDeclaration;
			else if (position && normal && color && texcoord0 && texcoord1 && blendWeight && blendIndex)
			vertexDeclaration=VertexPositionNormalColorTexture0Texture1Skin.vertexDeclaration;
			else if (position && normal && texcoord0 && texcoord1 && blendWeight && blendIndex && tangent)
			vertexDeclaration=VertexPositionNormalTexture0Texture1SkinTangent.vertexDeclaration;
			else if (position && normal && texcoord0 && texcoord1 && blendWeight && blendIndex)
			vertexDeclaration=VertexPositionNormalTexture0Texture1Skin.vertexDeclaration;
			else if (position && normal && color && texcoord0 && blendWeight && blendIndex && tangent)
			vertexDeclaration=VertexPositionNormalColorTextureSkinTangent.vertexDeclaration;
			else if (position && normal && color && texcoord0 && blendWeight && blendIndex)
			vertexDeclaration=VertexPositionNormalColorTextureSkin.vertexDeclaration;
			else if (position && normal && texcoord0 && blendWeight && blendIndex && tangent)
			vertexDeclaration=VertexPositionNormalTextureSkinTangent.vertexDeclaration;
			else if (position && normal && texcoord0 && blendWeight && blendIndex)
			vertexDeclaration=VertexPositionNormalTextureSkin.vertexDeclaration;
			else if (position && normal && color && blendWeight && blendIndex && tangent)
			vertexDeclaration=VertexPositionNormalColorSkinTangent.vertexDeclaration;
			else if (position && normal && color && blendWeight && blendIndex)
			vertexDeclaration=VertexPositionNormalColorSkin.vertexDeclaration;
			else if (position && normal && color && texcoord0 && texcoord1 && tangent)
			vertexDeclaration=VertexPositionNormalColorTexture0Texture1Tangent.vertexDeclaration;
			else if (position && normal && color && texcoord0 && texcoord1)
			vertexDeclaration=VertexPositionNormalColorTexture0Texture1.vertexDeclaration;
			else if (position && normal && texcoord0 && texcoord1 && tangent)
			vertexDeclaration=VertexPositionNormalTexture0Texture1Tangent.vertexDeclaration;
			else if (position && normal && texcoord0 && texcoord1)
			vertexDeclaration=VertexPositionNormalTexture0Texture1.vertexDeclaration;
			else if (position && normal && color && texcoord0 && tangent)
			vertexDeclaration=VertexPositionNormalColorTextureTangent.vertexDeclaration;
			else if (position && normal && color && texcoord0)
			vertexDeclaration=VertexPositionNormalColorTexture.vertexDeclaration;
			else if (position && normal && texcoord0 && tangent)
			vertexDeclaration=VertexPositionNormalTextureTangent.vertexDeclaration;
			else if (position && normal && texcoord0)
			vertexDeclaration=VertexPositionNormalTexture.vertexDeclaration;
			else if (position && normal && color && tangent)
			vertexDeclaration=VertexPositionNormalColorTangent.vertexDeclaration;
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
		__proto.getCorners=function(corners){
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

		__proto.toDefault=function(){
			this.min.toDefault();
			this.max.toDefault();
		}

		BoundBox.createfromPoints=function(points,out){
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
	*<code>BoundFrustum</code> 类用于创建锥截体。
	*/
	//class laya.d3.math.BoundFrustum
	var BoundFrustum=(function(){
		function BoundFrustum(matrix){
			this._matrix=null;
			this._near=null;
			this._far=null;
			this._left=null;
			this._right=null;
			this._top=null;
			this._bottom=null;
			this._matrix=matrix;
			this._near=new Plane(new Vector3());
			this._far=new Plane(new Vector3());
			this._left=new Plane(new Vector3());
			this._right=new Plane(new Vector3());
			this._top=new Plane(new Vector3());
			this._bottom=new Plane(new Vector3());
			BoundFrustum._getPlanesFromMatrix(this._matrix,this._near,this._far,this._left,this._right,this._top,this._bottom);
		}

		__class(BoundFrustum,'laya.d3.math.BoundFrustum');
		var __proto=BoundFrustum.prototype;
		/**
		*判断是否与其他锥截体相等。
		*@param other 锥截体。
		*/
		__proto.equalsBoundFrustum=function(other){
			return this._matrix.equalsOtherMatrix(other.matrix)
		}

		/**
		*判断是否与其他对象相等。
		*@param obj 对象。
		*/
		__proto.equalsObj=function(obj){
			if ((obj instanceof laya.d3.math.BoundFrustum )){
				var bf=obj;
				return this.equalsBoundFrustum(bf);
			}
			return false;
		}

		/**
		*获取锥截体的任意一平面。
		*0:近平面
		*1:远平面
		*2:左平面
		*3:右平面
		*4:顶平面
		*5:底平面
		*@param index 索引。
		*/
		__proto.getPlane=function(index){
			switch(index){
				case 0:
					return this._near;
				case 1:
					return this._far;
				case 2:
					return this._left;
				case 3:
					return this._right;
				case 4:
					return this._top;
				case 5:
					return this._bottom;
				default :
					return null;
				}
		}

		/**
		*锥截体的8个顶点。
		*@param corners 返回顶点的输出队列。
		*/
		__proto.getCorners=function(corners){
			corners[0]=BoundFrustum.get3PlaneInterPoint(this._near,this._bottom,this._right);
			corners[1]=BoundFrustum.get3PlaneInterPoint(this._near,this._top,this._right);
			corners[2]=BoundFrustum.get3PlaneInterPoint(this._near,this._top,this._left);
			corners[3]=BoundFrustum.get3PlaneInterPoint(this._near,this._bottom,this._left);
			corners[4]=BoundFrustum.get3PlaneInterPoint(this._far,this._bottom,this._right);
			corners[5]=BoundFrustum.get3PlaneInterPoint(this._far,this._top,this._right);
			corners[6]=BoundFrustum.get3PlaneInterPoint(this._far,this._top,this._left);
			corners[7]=BoundFrustum.get3PlaneInterPoint(this._far,this._bottom,this._left);
		}

		/**
		*与点的位置关系。返回-1,包涵;0,相交;1,不相交
		*@param point 点。
		*/
		__proto.ContainsPoint=function(point){
			var result=Plane.PlaneIntersectionType_Front;
			var planeResult=Plane.PlaneIntersectionType_Front;
			for (var i=0;i < 6;i++){
				switch(i){
					case 0:
						planeResult=Collision.intersectsPlaneAndPoint(this._near,point);
						break ;
					case 1:
						planeResult=Collision.intersectsPlaneAndPoint(this._far,point);
						break ;
					case 2:
						planeResult=Collision.intersectsPlaneAndPoint(this._left,point);
						break ;
					case 3:
						planeResult=Collision.intersectsPlaneAndPoint(this._right,point);
						break ;
					case 4:
						planeResult=Collision.intersectsPlaneAndPoint(this._top,point);
						break ;
					case 5:
						planeResult=Collision.intersectsPlaneAndPoint(this._bottom,point);
						break ;
					}
				switch(planeResult){
					case Plane.PlaneIntersectionType_Back:
						return /*laya.d3.math.ContainmentType.Disjoint*/0;
					case Plane.PlaneIntersectionType_Intersecting:
						result=Plane.PlaneIntersectionType_Intersecting;
						break ;
					}
			}
			switch(result){
				case Plane.PlaneIntersectionType_Intersecting:
					return /*laya.d3.math.ContainmentType.Intersects*/2;
				default :
					return /*laya.d3.math.ContainmentType.Contains*/1;
				}
		}

		/**
		*与包围盒的位置关系。返回-1,包涵;0,相交;1,不相交
		*@param box 包围盒。
		*/
		__proto.ContainsBoundBox=function(box){
			var plane;
			var result=/*laya.d3.math.ContainmentType.Contains*/1;
			for (var i=0;i < 6;i++){
				plane=this.getPlane(i);
				this._getBoxToPlanePVertexNVertex(box,plane.normal,BoundFrustum._tempV30,BoundFrustum._tempV31);
				if (Collision.intersectsPlaneAndPoint(plane,BoundFrustum._tempV30)==Plane.PlaneIntersectionType_Back)
					return /*laya.d3.math.ContainmentType.Disjoint*/0;
				if (Collision.intersectsPlaneAndPoint(plane,BoundFrustum._tempV31)==Plane.PlaneIntersectionType_Back)
					result=/*laya.d3.math.ContainmentType.Intersects*/2;
			}
			return result;
		}

		/**
		*与包围球的位置关系。返回-1,包涵;0,相交;1,不相交
		*@param sphere 包围球。
		*/
		__proto.ContainsBoundSphere=function(sphere){
			var result=Plane.PlaneIntersectionType_Front;
			var planeResult=Plane.PlaneIntersectionType_Front;
			for (var i=0;i < 6;i++){
				switch(i){
					case 0:
						planeResult=Collision.intersectsPlaneAndSphere(this._near,sphere);
						break ;
					case 1:
						planeResult=Collision.intersectsPlaneAndSphere(this._far,sphere);
						break ;
					case 2:
						planeResult=Collision.intersectsPlaneAndSphere(this._left,sphere);
						break ;
					case 3:
						planeResult=Collision.intersectsPlaneAndSphere(this._right,sphere);
						break ;
					case 4:
						planeResult=Collision.intersectsPlaneAndSphere(this._top,sphere);
						break ;
					case 5:
						planeResult=Collision.intersectsPlaneAndSphere(this._bottom,sphere);
						break ;
					}
				switch(planeResult){
					case Plane.PlaneIntersectionType_Back:
						return /*laya.d3.math.ContainmentType.Disjoint*/0;
					case Plane.PlaneIntersectionType_Intersecting:
						result=Plane.PlaneIntersectionType_Intersecting;
						break ;
					}
			}
			switch(result){
				case Plane.PlaneIntersectionType_Intersecting:
					return /*laya.d3.math.ContainmentType.Intersects*/2;
				default :
					return /*laya.d3.math.ContainmentType.Contains*/1;
				}
		}

		/**
		*@private
		*/
		__proto._getBoxToPlanePVertexNVertex=function(box,planeNormal,outP,outN){
			var boxMin=box.min;
			var boxMinE=boxMin.elements;
			var boxMax=box.max;
			var boxMaxE=boxMax.elements;
			var planeNorE=planeNormal.elements;
			var planeNorEX=planeNorE[0];
			var planeNorEY=planeNorE[1];
			var planeNorEZ=planeNorE[2];
			outP=boxMin;
			var outPE=outP.elements;
			if (planeNorEX >=0)
				outPE[0]=boxMaxE[0];
			if (planeNorEY >=0)
				outPE[1]=boxMaxE[1];
			if (planeNorEZ >=0)
				outPE[2]=boxMaxE[2];
			outN=boxMax;
			var outNE=outN.elements;
			if (planeNorEX >=0)
				outNE[0]=boxMinE[0];
			if (planeNorEY >=0)
				outNE[1]=boxMinE[1];
			if (planeNorEZ >=0)
				outNE[2]=boxMinE[2];
		}

		/**
		*获取顶平面。
		*@return 顶平面。
		*/
		__getset(0,__proto,'top',function(){
			return this._top;
		});

		/**
		*设置描述矩阵。
		*@param matrix 描述矩阵。
		*/
		/**
		*获取描述矩阵。
		*@return 描述矩阵。
		*/
		__getset(0,__proto,'matrix',function(){
			return this._matrix;
			},function(matrix){
			this._matrix=matrix;
			BoundFrustum._getPlanesFromMatrix(this._matrix,this._near,this._far,this._left,this._right,this._top,this._bottom);
		});

		/**
		*获取近平面。
		*@return 近平面。
		*/
		__getset(0,__proto,'near',function(){
			return this._near;
		});

		/**
		*获取远平面。
		*@return 远平面。
		*/
		__getset(0,__proto,'far',function(){
			return this._far;
		});

		/**
		*获取左平面。
		*@return 左平面。
		*/
		__getset(0,__proto,'left',function(){
			return this._left;
		});

		/**
		*获取右平面。
		*@return 右平面。
		*/
		__getset(0,__proto,'right',function(){
			return this._right;
		});

		/**
		*获取底平面。
		*@return 底平面。
		*/
		__getset(0,__proto,'bottom',function(){
			return this._bottom;
		});

		BoundFrustum._getPlanesFromMatrix=function(m,np,fp,lp,rp,tp,bp){
			var matrixE=m.elements;
			var m11=matrixE[0];
			var m12=matrixE[1];
			var m13=matrixE[2];
			var m14=matrixE[3];
			var m21=matrixE[4];
			var m22=matrixE[5];
			var m23=matrixE[6];
			var m24=matrixE[7];
			var m31=matrixE[8];
			var m32=matrixE[9];
			var m33=matrixE[10];
			var m34=matrixE[11];
			var m41=matrixE[12];
			var m42=matrixE[13];
			var m43=matrixE[14];
			var m44=matrixE[15];
			var nearNorE=np.normal.elements;
			nearNorE[0]=m13;
			nearNorE[1]=m23;
			nearNorE[2]=m33;
			np.distance=m43;
			np.normalize();
			var farNorE=fp.normal.elements;
			farNorE[0]=m14-m13;
			farNorE[1]=m24-m23;
			farNorE[2]=m34-m33;
			fp.distance=m44-m43;
			fp.normalize();
			var leftNorE=lp.normal.elements;
			leftNorE[0]=m14+m11;
			leftNorE[1]=m24+m21;
			leftNorE[2]=m34+m31;
			lp.distance=m44+m41;
			lp.normalize();
			var rightNorE=rp.normal.elements;
			rightNorE[0]=m14-m11;
			rightNorE[1]=m24-m21;
			rightNorE[2]=m34-m31;
			rp.distance=m44-m41;
			rp.normalize();
			var topNorE=tp.normal.elements;
			topNorE[0]=m14-m12;
			topNorE[1]=m24-m22;
			topNorE[2]=m34-m32;
			tp.distance=m44-m42;
			tp.normalize();
			var bottomNorE=bp.normal.elements;
			bottomNorE[0]=m14+m12;
			bottomNorE[1]=m24+m22;
			bottomNorE[2]=m34+m32;
			bp.distance=m44+m42;
			bp.normalize();
		}

		BoundFrustum.get3PlaneInterPoint=function(p1,p2,p3){
			var p1Nor=p1.normal;
			var p2Nor=p2.normal;
			var p3Nor=p3.normal;
			Vector3.cross(p2Nor,p3Nor,BoundFrustum._tempV30);
			Vector3.cross(p3Nor,p1Nor,BoundFrustum._tempV31);
			Vector3.cross(p1Nor,p2Nor,BoundFrustum._tempV32);
			var a=Vector3.dot(p1Nor,BoundFrustum._tempV30);
			var b=Vector3.dot(p2Nor,BoundFrustum._tempV31);
			var c=Vector3.dot(p3Nor,BoundFrustum._tempV32);
			Vector3.scale(BoundFrustum._tempV30,-p1.distance / a,BoundFrustum._tempV33);
			Vector3.scale(BoundFrustum._tempV31,-p2.distance / b,BoundFrustum._tempV34);
			Vector3.scale(BoundFrustum._tempV32,-p3.distance / c,BoundFrustum._tempV35);
			Vector3.add(BoundFrustum._tempV33,BoundFrustum._tempV34,BoundFrustum._tempV36);
			Vector3.add(BoundFrustum._tempV35,BoundFrustum._tempV36,BoundFrustum._tempV37);
			var v=BoundFrustum._tempV37;
			return v;
		}

		__static(BoundFrustum,
		['_tempV30',function(){return this._tempV30=new Vector3();},'_tempV31',function(){return this._tempV31=new Vector3();},'_tempV32',function(){return this._tempV32=new Vector3();},'_tempV33',function(){return this._tempV33=new Vector3();},'_tempV34',function(){return this._tempV34=new Vector3();},'_tempV35',function(){return this._tempV35=new Vector3();},'_tempV36',function(){return this._tempV36=new Vector3();},'_tempV37',function(){return this._tempV37=new Vector3();}
		]);
		return BoundFrustum;
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
		var __proto=BoundSphere.prototype;
		__proto.toDefault=function(){
			this.center.toDefault();
			this.radius=0;
		}

		BoundSphere.createFromSubPoints=function(points,start,count,out){
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
			};
			var outCenter=out.center;
			Vector3.scale(center,1 / count,outCenter);
			var radius=0.0;
			for (i=start;i < upperEnd;++i){
				var distance=Vector3.distanceSquared(outCenter,points[i]);
				if (distance > radius)
					radius=distance;
			}
			out.radius=Math.sqrt(radius);
		}

		BoundSphere.createfromPoints=function(points,out){
			if (points==null){
				throw new Error("points");
			}
			BoundSphere.createFromSubPoints(points,0,points.length,out);
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
			var delta=NaN;
			if (box1MineX > box2MaxeX){
				delta=box1MineX-box2MaxeX;
				distance+=delta *delta;
				}else if (box2MineX > box1MaxeX){
				delta=box2MineX-box1MaxeX;
				distance+=delta *delta;
			}
			if (box1MineY > box2MaxeY){
				delta=box1MineY-box2MaxeY;
				distance+=delta *delta;
				}else if (box2MineY > box1MaxeY){
				delta=box2MineY-box1MaxeY;
				distance+=delta *delta;
			}
			if (box1MineZ > box2MaxeZ){
				delta=box1MineZ-box2MaxeZ;
				distance+=delta *delta;
				}else if (box2MineZ > box1MaxeZ){
				delta=box2MineZ-box1MaxeZ;
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

		Collision.intersectsRayAndTriangleRD=function(ray,vertex1,vertex2,vertex3,out){
			var rayO=ray.origin;
			var rayOe=rayO.elements;
			var rayOeX=rayOe[0];
			var rayOeY=rayOe[1];
			var rayOeZ=rayOe[2];
			var rayD=ray.direction;
			var rayDe=rayD.elements;
			var rayDeX=rayDe[0];
			var rayDeY=rayDe[1];
			var rayDeZ=rayDe[2];
			var v1e=vertex1.elements;
			var v1eX=v1e[0];
			var v1eY=v1e[1];
			var v1eZ=v1e[2];
			var v2e=vertex2.elements;
			var v2eX=v2e[0];
			var v2eY=v2e[1];
			var v2eZ=v2e[2];
			var v3e=vertex3.elements;
			var v3eX=v3e[0];
			var v3eY=v3e[1];
			var v3eZ=v3e[2];
			var _tempV30e=Collision._tempV30.elements;
			var _tempV30eX=_tempV30e[0];
			var _tempV30eY=_tempV30e[1];
			var _tempV30eZ=_tempV30e[2];
			_tempV30eX=v2eX-v1eX;
			_tempV30eY=v2eY-v1eY;
			_tempV30eZ=v2eZ-v1eZ;
			var _tempV31e=Collision._tempV31.elements;
			var _tempV31eX=_tempV31e[0];
			var _tempV31eY=_tempV31e[1];
			var _tempV31eZ=_tempV31e[2];
			_tempV31eX=v3eX-v1eX;
			_tempV31eY=v3eY-v1eY;
			_tempV31eZ=v3eZ-v1eZ;
			var _tempV32e=Collision._tempV32.elements;
			var _tempV32eX=_tempV32e[0];
			var _tempV32eY=_tempV32e[1];
			var _tempV32eZ=_tempV32e[2];
			_tempV32eX=(rayDeY *_tempV31eZ)-(rayDeZ *_tempV31eY);
			_tempV32eY=(rayDeZ *_tempV31eX)-(rayDeX *_tempV31eZ);
			_tempV32eZ=(rayDeX *_tempV31eY)-(rayDeY *_tempV31eX);
			var determinant=(_tempV30eX *_tempV32eX)+(_tempV30eY *_tempV32eY)+(_tempV30eZ *_tempV32eZ);
			if (MathUtils3D.isZero(determinant)){
				out=0;
				return false;
			};
			var inversedeterminant=1 / determinant;
			var _tempV33e=Collision._tempV33.elements;
			var _tempV33eX=_tempV33e[0];
			var _tempV33eY=_tempV33e[1];
			var _tempV33eZ=_tempV33e[2];
			_tempV33eX=rayOeX-v1eX;
			_tempV33eY=rayOeY-v1eY;
			_tempV33eZ=rayOeZ-v1eZ;
			var triangleU=(_tempV33eX *_tempV32eX)+(_tempV33eY *_tempV32eY)+(_tempV33eZ *_tempV32eZ);
			triangleU *=inversedeterminant;
			if (triangleU < 0 || triangleU > 1){
				out=0;
				return false;
			};
			var _tempV34e=Collision._tempV34.elements;
			var _tempV34eX=_tempV34e[0];
			var _tempV34eY=_tempV34e[1];
			var _tempV34eZ=_tempV34e[2];
			_tempV34eX=(_tempV33eY *_tempV30eZ)-(_tempV33eZ *_tempV30eY);
			_tempV34eY=(_tempV33eZ *_tempV30eX)-(_tempV33eX *_tempV30eZ);
			_tempV34eZ=(_tempV33eX *_tempV30eY)-(_tempV33eY *_tempV30eX);
			var triangleV=((rayDeX *_tempV34eX)+(rayDeY *_tempV34eY))+(rayDeZ *_tempV34eZ);
			triangleV *=inversedeterminant;
			if (triangleV < 0 || triangleU+triangleV > 1){
				out=0;
				return false;
			};
			var raydistance=(_tempV31eX *_tempV34eX)+(_tempV31eY *_tempV34eY)+(_tempV31eZ *_tempV34eZ);
			raydistance *=inversedeterminant;
			if (raydistance < 0){
				out=0;
				return false;
			}
			out=raydistance;
			return true;
		}

		Collision.intersectsRayAndTriangleRP=function(ray,vertex1,vertex2,vertex3,out){
			var distance=NaN;
			if (!Collision.intersectsRayAndTriangleRD(ray,vertex1,vertex2,vertex3,distance)){
				out=Vector3.ZERO;
				return false;
			}
			Vector3.scale(ray.direction,distance,Collision._tempV30);
			Vector3.add(ray.origin,Collision._tempV30,out);
			return true;
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

		Collision.intersectsPlaneAndTriangle=function(plane,vertex1,vertex2,vertex3){
			var test1=Collision.intersectsPlaneAndPoint(plane,vertex1);
			var test2=Collision.intersectsPlaneAndPoint(plane,vertex2);
			var test3=Collision.intersectsPlaneAndPoint(plane,vertex3);
			if (test1==Plane.PlaneIntersectionType_Front && test2==Plane.PlaneIntersectionType_Front && test3==Plane.PlaneIntersectionType_Front)
				return Plane.PlaneIntersectionType_Front;
			if (test1==Plane.PlaneIntersectionType_Back && test2==Plane.PlaneIntersectionType_Back && test3==Plane.PlaneIntersectionType_Back)
				return Plane.PlaneIntersectionType_Back;
			return Plane.PlaneIntersectionType_Intersecting;
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
			var rayoe=ray.origin.elements;
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
				}else {
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
				}else {
				var inverse1=1 / raydeY;
				var t3=(boxMineY-rayoeY)*inverse1;
				var t4=(boxMaxeY-rayoeY)*inverse1;
				if (t3 > t4){
					var temp1=t3;
					t3=t4;
					t4=temp1;
				}
				out=Math.max(t3,out);
				tmax=Math.min(t4,tmax);
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
				}else {
				var inverse2=1 / raydeZ;
				var t5=(boxMineZ-rayoeZ)*inverse2;
				var t6=(boxMaxeZ-rayoeZ)*inverse2;
				if (t5 > t6){
					var temp2=t5;
					t5=t6;
					t6=temp2;
				}
				out=Math.max(t5,out);
				tmax=Math.min(t6,tmax);
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

		Collision.intersectsSphereAndTriangle=function(sphere,vertex1,vertex2,vertex3){
			var sphereC=sphere.center;
			var sphereR=sphere.radius;
			Collision.closestPointPointTriangle(sphereC,vertex1,vertex2,vertex3,Collision._tempV30);
			Vector3.subtract(Collision._tempV30,sphereC,Collision._tempV31);
			var dot=Vector3.dot(Collision._tempV31,Collision._tempV31);
			return dot <=sphereR *sphereR;
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
			var box1Maxe=box1.max.elements;
			var box2Mine=box2.min.elements;
			var box2Maxe=box2.max.elements;
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

		Collision.boxContainsPoint=function(box,point){
			var boxMine=box.min.elements;
			var boxMaxe=box.max.elements;
			var pointe=point.elements;
			if (boxMine[0] <=pointe[0] && boxMaxe[0] >=pointe[0] && boxMine[1] <=pointe[1] && boxMaxe[1] >=pointe[1] && boxMine[2] <=pointe[2] && boxMaxe[2] >=pointe[2])
				return /*laya.d3.math.ContainmentType.Contains*/1;
			return /*laya.d3.math.ContainmentType.Disjoint*/0;
		}

		Collision.boxContainsBox=function(box1,box2){
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
			if (box1MaxeX < box2MineX || box1MineX > box2MaxeX)
				return /*laya.d3.math.ContainmentType.Disjoint*/0;
			if (box1MaxeY < box2MineY || box1MineY > box2MaxeY)
				return /*laya.d3.math.ContainmentType.Disjoint*/0;
			if (box1MaxeZ < box2MineZ || box1MineZ > box2MaxeZ)
				return /*laya.d3.math.ContainmentType.Disjoint*/0;
			if (box1MineX <=box2MineX && box2MaxeX <=box2MineX && box1MineY <=box2MineY && box2MaxeY <=box1MaxeY && box1MineZ <=box2MineZ && box2MaxeZ <=box1MaxeZ){
				return /*laya.d3.math.ContainmentType.Contains*/1;
			}
			return /*laya.d3.math.ContainmentType.Intersects*/2;
		}

		Collision.boxContainsSphere=function(box,sphere){
			var boxMin=box.min;
			var boxMine=boxMin.elements;
			var boxMineX=boxMine[0];
			var boxMineY=boxMine[1];
			var boxMineZ=boxMine[2];
			var boxMax=box.max;
			var boxMaxe=boxMax.elements;
			var boxMaxeX=boxMaxe[0];
			var boxMaxeY=boxMaxe[1];
			var boxMaxeZ=boxMaxe[2];
			var sphereC=sphere.center;
			var sphereCe=sphereC.elements;
			var sphereCeX=sphereCe[0];
			var sphereCeY=sphereCe[1];
			var sphereCeZ=sphereCe[2];
			var sphereR=sphere.radius;
			Vector3.Clamp(sphereC,boxMin,boxMax,Collision._tempV30);
			var distance=Vector3.distanceSquared(sphereC,Collision._tempV30);
			if (distance > sphereR *sphereR)
				return /*laya.d3.math.ContainmentType.Disjoint*/0;
			if ((((boxMineX+sphereR <=sphereCeX)&& (sphereCeX <=boxMaxeX-sphereR))&& ((boxMaxeX-boxMineX > sphereR)&&
				(boxMineY+sphereR <=sphereCeY)))&& (((sphereCeY <=boxMaxeY-sphereR)&& (boxMaxeY-boxMineY > sphereR))&&
			(((boxMineZ+sphereR <=sphereCeZ)&& (sphereCeZ <=boxMaxeZ-sphereR))&& (boxMaxeZ-boxMineZ > sphereR))))
			return /*laya.d3.math.ContainmentType.Contains*/1;
			return /*laya.d3.math.ContainmentType.Intersects*/2;
		}

		Collision.sphereContainsPoint=function(sphere,point){
			if (Vector3.distanceSquared(point,sphere.center)<=sphere.radius *sphere.radius)
				return /*laya.d3.math.ContainmentType.Contains*/1;
			return /*laya.d3.math.ContainmentType.Disjoint*/0;
		}

		Collision.sphereContainsTriangle=function(sphere,vertex1,vertex2,vertex3){
			var test1=Collision.sphereContainsPoint(sphere,vertex1);
			var test2=Collision.sphereContainsPoint(sphere,vertex2);
			var test3=Collision.sphereContainsPoint(sphere,vertex3);
			if (test1==/*laya.d3.math.ContainmentType.Contains*/1 && test2==/*laya.d3.math.ContainmentType.Contains*/1 && test3==/*laya.d3.math.ContainmentType.Contains*/1)
				return /*laya.d3.math.ContainmentType.Contains*/1;
			if (Collision.intersectsSphereAndTriangle(sphere,vertex1,vertex2,vertex3))
				return /*laya.d3.math.ContainmentType.Intersects*/2;
			return /*laya.d3.math.ContainmentType.Disjoint*/0;
		}

		Collision.sphereContainsBox=function(sphere,box){
			var sphereC=sphere.center;
			var sphereCe=sphereC.elements;
			var sphereCeX=sphereCe[0];
			var sphereCeY=sphereCe[1];
			var sphereCeZ=sphereCe[2];
			var sphereR=sphere.radius;
			var boxMin=box.min;
			var boxMine=boxMin.elements;
			var boxMineX=boxMine[0];
			var boxMineY=boxMine[1];
			var boxMineZ=boxMine[2];
			var boxMax=box.max;
			var boxMaxe=boxMax.elements;
			var boxMaxeX=boxMaxe[0];
			var boxMaxeY=boxMaxe[1];
			var boxMaxeZ=boxMaxe[2];
			var _tempV30e=Collision._tempV30.elements;
			var _tempV30eX=_tempV30e[0];
			var _tempV30eY=_tempV30e[1];
			var _tempV30eZ=_tempV30e[2];
			if (!Collision.intersectsBoxAndSphere(box,sphere))
				return /*laya.d3.math.ContainmentType.Disjoint*/0;
			var radiusSquared=sphereR *sphereR;
			_tempV30eX=sphereCeX-boxMineX;
			_tempV30eY=sphereCeY-boxMaxeY;
			_tempV30eZ=sphereCeZ-boxMaxeZ;
			if (Vector3.scalarLengthSquared(Collision._tempV30)> radiusSquared)
				return /*laya.d3.math.ContainmentType.Intersects*/2;
			_tempV30eX=sphereCeX-boxMaxeX;
			_tempV30eY=sphereCeY-boxMaxeY;
			_tempV30eZ=sphereCeZ-boxMaxeZ;
			if (Vector3.scalarLengthSquared(Collision._tempV30)> radiusSquared)
				return /*laya.d3.math.ContainmentType.Intersects*/2;
			_tempV30eX=sphereCeX-boxMaxeX;
			_tempV30eY=sphereCeY-boxMineY;
			_tempV30eZ=sphereCeZ-boxMaxeZ;
			if (Vector3.scalarLengthSquared(Collision._tempV30)> radiusSquared)
				return /*laya.d3.math.ContainmentType.Intersects*/2;
			_tempV30eX=sphereCeX-boxMineX;
			_tempV30eY=sphereCeY-boxMineY;
			_tempV30eZ=sphereCeZ-boxMaxeZ;
			if (Vector3.scalarLengthSquared(Collision._tempV30)> radiusSquared)
				return /*laya.d3.math.ContainmentType.Intersects*/2;
			_tempV30eX=sphereCeX-boxMineX;
			_tempV30eY=sphereCeY-boxMaxeY;
			_tempV30eZ=sphereCeZ-boxMineZ;
			if (Vector3.scalarLengthSquared(Collision._tempV30)> radiusSquared)
				return /*laya.d3.math.ContainmentType.Intersects*/2;
			_tempV30eX=sphereCeX-boxMaxeX;
			_tempV30eY=sphereCeY-boxMaxeY;
			_tempV30eZ=sphereCeZ-boxMineZ;
			if (Vector3.scalarLengthSquared(Collision._tempV30)> radiusSquared)
				return /*laya.d3.math.ContainmentType.Intersects*/2;
			_tempV30eX=sphereCeX-boxMaxeX;
			_tempV30eY=sphereCeY-boxMineY;
			_tempV30eZ=sphereCeZ-boxMineZ;
			if (Vector3.scalarLengthSquared(Collision._tempV30)> radiusSquared)
				return /*laya.d3.math.ContainmentType.Intersects*/2;
			_tempV30eX=sphereCeX-boxMineX;
			_tempV30eY=sphereCeY-boxMineY;
			_tempV30eZ=sphereCeZ-boxMineZ;
			if (Vector3.scalarLengthSquared(Collision._tempV30)> radiusSquared)
				return /*laya.d3.math.ContainmentType.Intersects*/2;
			return /*laya.d3.math.ContainmentType.Contains*/1;
		}

		Collision.sphereContainsSphere=function(sphere1,sphere2){
			var sphere1R=sphere1.radius;
			var sphere2R=sphere2.radius;
			var distance=Vector3.distance(sphere1.center,sphere2.center);
			if (sphere1R+sphere2R < distance)
				return /*laya.d3.math.ContainmentType.Disjoint*/0;
			if (sphere1R-sphere2R < distance)
				return /*laya.d3.math.ContainmentType.Intersects*/2;
			return /*laya.d3.math.ContainmentType.Contains*/1;
		}

		Collision.closestPointPointTriangle=function(point,vertex1,vertex2,vertex3,out){
			Vector3.subtract(vertex2,vertex1,Collision._tempV30);
			Vector3.subtract(vertex3,vertex1,Collision._tempV31);
			Vector3.subtract(point,vertex1,Collision._tempV32);
			Vector3.subtract(point,vertex2,Collision._tempV33);
			Vector3.subtract(point,vertex3,Collision._tempV34);
			var d1=Vector3.dot(Collision._tempV30,Collision._tempV32);
			var d2=Vector3.dot(Collision._tempV31,Collision._tempV32);
			var d3=Vector3.dot(Collision._tempV30,Collision._tempV33);
			var d4=Vector3.dot(Collision._tempV31,Collision._tempV33);
			var d5=Vector3.dot(Collision._tempV30,Collision._tempV34);
			var d6=Vector3.dot(Collision._tempV31,Collision._tempV34);
			if (d1 <=0 && d2 <=0){
				vertex1.cloneTo(out);
				return;
			}
			if (d3 >=0 && d4 <=d3){
				vertex2.cloneTo(out);
				return;
			};
			var vc=d1 *d4-d3 *d2;
			if (vc <=0 && d1 >=0 && d3 <=0){
				var v=d1 / (d1-d3);
				Vector3.scale(Collision._tempV30,v,out);
				Vector3.add(vertex1,out,out);
				return;
			}
			if (d6 >=0 && d5 <=d6){
				vertex3.cloneTo(out);
				return;
			};
			var vb=d5 *d2-d1 *d6;
			if (vb <=0 && d2 >=0 && d6 <=0){
				var w=d2 / (d2-d6);
				Vector3.scale(Collision._tempV31,w,out);
				Vector3.add(vertex1,out,out);
				return;
			};
			var va=d3 *d6-d5 *d4;
			if (va <=0 && (d4-d3)>=0 && (d5-d6)>=0){
				var w3=(d4-d3)/ ((d4-d3)+(d5-d6));
				Vector3.subtract(vertex3,vertex2,out);
				Vector3.scale(out,w3,out);
				Vector3.add(vertex2,out,out);
				return;
			};
			var denom=1 / (va+vb+vc);
			var v2=vb *denom;
			var w2=vc *denom;
			Vector3.scale(Collision._tempV30,v2,Collision._tempV35);
			Vector3.scale(Collision._tempV31,w2,Collision._tempV36);
			Vector3.add(Collision._tempV35,Collision._tempV36,out);
			Vector3.add(vertex1,out,out);
		}

		Collision.closestPointPlanePoint=function(plane,point,out){
			var planeN=plane.normal;
			var t=Vector3.dot(planeN,point)-plane.distance;
			Vector3.scale(planeN,t,Collision._tempV30);
			Vector3.subtract(point,Collision._tempV30,out);
		}

		Collision.closestPointBoxPoint=function(box,point,out){
			Vector3.max(point,box.min,Collision._tempV30);
			Vector3.min(Collision._tempV30,box.max,out);
		}

		Collision.closestPointSpherePoint=function(sphere,point,out){
			var sphereC=sphere.center;
			Vector3.subtract(point,sphereC,out);
			Vector3.normalize(out,out);
			Vector3.scale(out,sphere.radius,out);
			Vector3.add(out,sphereC,out);
		}

		Collision.closestPointSphereSphere=function(sphere1,sphere2,out){
			var sphere1C=sphere1.center;
			Vector3.subtract(sphere2.center,sphere1C,out);
			Vector3.normalize(out,out);
			Vector3.scale(out,sphere1.radius,out);
			Vector3.add(out,sphere1C,out);
		}

		__static(Collision,
		['_tempV30',function(){return this._tempV30=new Vector3();},'_tempV31',function(){return this._tempV31=new Vector3();},'_tempV32',function(){return this._tempV32=new Vector3();},'_tempV33',function(){return this._tempV33=new Vector3();},'_tempV34',function(){return this._tempV34=new Vector3();},'_tempV35',function(){return this._tempV35=new Vector3();},'_tempV36',function(){return this._tempV36=new Vector3();}
		]);
		return Collision;
	})()


	/**
	*<code>ContainmentType</code> 类用于定义空间物体位置关系。
	*/
	//class laya.d3.math.ContainmentType
	var ContainmentType=(function(){
		function ContainmentType(){};
		__class(ContainmentType,'laya.d3.math.ContainmentType');
		ContainmentType.Disjoint=0;
		ContainmentType.Contains=1;
		ContainmentType.Intersects=2;
		return ContainmentType;
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

		MathUtils3D.fastInvSqrt=function(value){
			if (MathUtils3D.isZero(value))
				return value;
			return 1.0 / Math.sqrt(value);
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
		function Matrix4x4(m11,m12,m13,m14,m21,m22,m23,m24,m31,m32,m33,m34,m41,m42,m43,m44){
			//this.elements=null;
			(m11===void 0)&& (m11=1);
			(m12===void 0)&& (m12=0);
			(m13===void 0)&& (m13=0);
			(m14===void 0)&& (m14=0);
			(m21===void 0)&& (m21=0);
			(m22===void 0)&& (m22=1);
			(m23===void 0)&& (m23=0);
			(m24===void 0)&& (m24=0);
			(m31===void 0)&& (m31=0);
			(m32===void 0)&& (m32=0);
			(m33===void 0)&& (m33=1);
			(m34===void 0)&& (m34=0);
			(m41===void 0)&& (m41=0);
			(m42===void 0)&& (m42=0);
			(m43===void 0)&& (m43=0);
			(m44===void 0)&& (m44=1);
			var e=this.elements=new Float32Array(16);
			e[0]=m11;
			e[1]=m12;
			e[2]=m13;
			e[3]=m14;
			e[4]=m21;
			e[5]=m22;
			e[6]=m23;
			e[7]=m24;
			e[8]=m31;
			e[9]=m32;
			e[10]=m33;
			e[11]=m34;
			e[12]=m41;
			e[13]=m42;
			e[14]=m43;
			e[15]=m44;
		}

		__class(Matrix4x4,'laya.d3.math.Matrix4x4');
		var __proto=Matrix4x4.prototype;
		/**
		*判断两个4x4矩阵的值是否相等。
		*@param other 4x4矩阵
		*/
		__proto.equalsOtherMatrix=function(other){
			var e=this.elements;
			var oe=other.elements;
			return (MathUtils3D.nearEqual(e[0],oe[0])&& MathUtils3D.nearEqual(e[1],oe[1])&& MathUtils3D.nearEqual(e[2],oe[2])&& MathUtils3D.nearEqual(e[3],oe[3])&& MathUtils3D.nearEqual(e[4],oe[4])&& MathUtils3D.nearEqual(e[5],oe[5])&& MathUtils3D.nearEqual(e[6],oe[6])&& MathUtils3D.nearEqual(e[7],oe[7])&& MathUtils3D.nearEqual(e[8],oe[8])&& MathUtils3D.nearEqual(e[9],oe[9])&& MathUtils3D.nearEqual(e[10],oe[10])&& MathUtils3D.nearEqual(e[11],oe[11])&& MathUtils3D.nearEqual(e[12],oe[12])&& MathUtils3D.nearEqual(e[13],oe[13])&& MathUtils3D.nearEqual(e[14],oe[14])&& MathUtils3D.nearEqual(e[15],oe[15]));
		}

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

		__getset(0,__proto,'translationVector',function(){
			var me=this.elements;
			var oe=Matrix4x4._translationVector.elements;
			oe[0]=me[12];
			oe[1]=me[13];
			oe[2]=me[14];
			return Matrix4x4._translationVector;
			},function(v3){
			var me=this.elements;
			var ve=v3.elements;
			me[12]=ve[0];
			me[13]=ve[1];
			me[14]=ve[2];
		});

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

		Matrix4x4.createRotationYawPitchRoll=function(yaw,pitch,roll,result){
			Quaternion.createFromYawPitchRoll(yaw,pitch,roll,Matrix4x4._tempQuaternion);
			Matrix4x4.createRotationQuaternion(Matrix4x4._tempQuaternion,result);
		}

		Matrix4x4.createRotationQuaternion=function(rotation,result){
			var rotationE=rotation.elements;
			var resultE=result.elements;
			var rotationX=rotationE[0];
			var rotationY=rotationE[1];
			var rotationZ=rotationE[2];
			var rotationW=rotationE[3];
			var xx=rotationX *rotationX;
			var yy=rotationY *rotationY;
			var zz=rotationZ *rotationZ;
			var xy=rotationX *rotationY;
			var zw=rotationZ *rotationW;
			var zx=rotationZ *rotationX;
			var yw=rotationY *rotationW;
			var yz=rotationY *rotationZ;
			var xw=rotationX *rotationW;
			resultE[3]=resultE[7]=resultE[11]=resultE[12]=resultE[13]=resultE[14]=0;
			resultE[15]=1.0;
			resultE[0]=1.0-(2.0 *(yy+zz));
			resultE[1]=2.0 *(xy+zw);
			resultE[2]=2.0 *(zx-yw);
			resultE[4]=2.0 *(xy-zw);
			resultE[5]=1.0-(2.0 *(zz+xx));
			resultE[6]=2.0 *(yz+xw);
			resultE[8]=2.0 *(zx+yw);
			resultE[9]=2.0 *(yz-xw);
			resultE[10]=1.0-(2.0 *(yy+xx));
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
			var yScale=1.0 / Math.tan(fov *0.5);
			var q=far / (near-far);
			oe[0]=yScale / aspect;
			oe[5]=yScale;
			oe[10]=q;
			oe[11]=-1.0;
			oe[14]=q *near;
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

		Matrix4x4.translation=function(v3,out){
			var ve=v3.elements;
			var oe=out.elements;
			oe[0]=oe[5]=oe[10]=oe[15]=1;
			oe[12]=ve[0];
			oe[13]=ve[1];
			oe[14]=ve[2];
		}

		Matrix4x4._tempMatrix4x4=new Matrix4x4();
		Matrix4x4.DEFAULT=new Matrix4x4();
		__static(Matrix4x4,
		['_tempQuaternion',function(){return this._tempQuaternion=new Quaternion();},'_translationVector',function(){return this._translationVector=new Vector3();}
		]);
		return Matrix4x4;
	})()


	/**
	*<code>OrientedBoundBox</code> 类用于创建OBB包围盒。
	*/
	//class laya.d3.math.OrientedBoundBox
	var OrientedBoundBox=(function(){
		function OrientedBoundBox(box){
			this.extents=null;
			this.transformation=null;
			var min=box.min;
			var max=box.max;
			Vector3.subtract(max,min,OrientedBoundBox._tempV30);
			Vector3.scale(OrientedBoundBox._tempV30,0.5,OrientedBoundBox._tempV30);
			Vector3.add(min,OrientedBoundBox._tempV30,OrientedBoundBox._tempV31);
			Vector3.subtract(max,OrientedBoundBox._tempV31,this.extents);
			Matrix4x4.translation(OrientedBoundBox._tempV31,this.transformation);
		}

		__class(OrientedBoundBox,'laya.d3.math.OrientedBoundBox');
		var __proto=OrientedBoundBox.prototype;
		/**
		*获取OBB包围盒的8个角顶点。
		*@param corners 返回顶点的输出队列。
		*/
		__proto.getCorners=function(corners){
			var extentsE=this.extents.elements;
			corners.length=8;
			OrientedBoundBox._tempV30.x=extentsE[0];
			OrientedBoundBox._tempV31.y=extentsE[1];
			OrientedBoundBox._tempV32.z=extentsE[2];
			Vector3.TransformNormal(OrientedBoundBox._tempV30,this.transformation,OrientedBoundBox._tempV30);
			Vector3.TransformNormal(OrientedBoundBox._tempV31,this.transformation,OrientedBoundBox._tempV31);
			Vector3.TransformNormal(OrientedBoundBox._tempV32,this.transformation,OrientedBoundBox._tempV32);
			OrientedBoundBox._tempV33=this.transformation.translationVector;
			Vector3.add(OrientedBoundBox._tempV33,OrientedBoundBox._tempV30,OrientedBoundBox._tempV34);
			Vector3.add(OrientedBoundBox._tempV34,OrientedBoundBox._tempV31,OrientedBoundBox._tempV34);
			Vector3.add(OrientedBoundBox._tempV34,OrientedBoundBox._tempV32,corners[0]);
			Vector3.add(OrientedBoundBox._tempV33,OrientedBoundBox._tempV30,OrientedBoundBox._tempV34);
			Vector3.add(OrientedBoundBox._tempV34,OrientedBoundBox._tempV31,OrientedBoundBox._tempV34);
			Vector3.subtract(OrientedBoundBox._tempV34,OrientedBoundBox._tempV32,corners[1]);
			Vector3.subtract(OrientedBoundBox._tempV33,OrientedBoundBox._tempV30,OrientedBoundBox._tempV34);
			Vector3.add(OrientedBoundBox._tempV34,OrientedBoundBox._tempV31,OrientedBoundBox._tempV34);
			Vector3.subtract(OrientedBoundBox._tempV34,OrientedBoundBox._tempV32,corners[2]);
			Vector3.subtract(OrientedBoundBox._tempV33,OrientedBoundBox._tempV30,OrientedBoundBox._tempV34);
			Vector3.add(OrientedBoundBox._tempV34,OrientedBoundBox._tempV31,OrientedBoundBox._tempV34);
			Vector3.add(OrientedBoundBox._tempV34,OrientedBoundBox._tempV32,corners[3]);
			Vector3.add(OrientedBoundBox._tempV33,OrientedBoundBox._tempV30,OrientedBoundBox._tempV34);
			Vector3.subtract(OrientedBoundBox._tempV34,OrientedBoundBox._tempV31,OrientedBoundBox._tempV34);
			Vector3.add(OrientedBoundBox._tempV34,OrientedBoundBox._tempV32,corners[4]);
			Vector3.add(OrientedBoundBox._tempV33,OrientedBoundBox._tempV30,OrientedBoundBox._tempV34);
			Vector3.subtract(OrientedBoundBox._tempV34,OrientedBoundBox._tempV31,OrientedBoundBox._tempV34);
			Vector3.subtract(OrientedBoundBox._tempV34,OrientedBoundBox._tempV32,corners[5]);
			Vector3.subtract(OrientedBoundBox._tempV33,OrientedBoundBox._tempV30,OrientedBoundBox._tempV34);
			Vector3.subtract(OrientedBoundBox._tempV34,OrientedBoundBox._tempV31,OrientedBoundBox._tempV34);
			Vector3.subtract(OrientedBoundBox._tempV34,OrientedBoundBox._tempV32,corners[6]);
			Vector3.subtract(OrientedBoundBox._tempV33,OrientedBoundBox._tempV30,OrientedBoundBox._tempV34);
			Vector3.subtract(OrientedBoundBox._tempV34,OrientedBoundBox._tempV31,OrientedBoundBox._tempV34);
			Vector3.add(OrientedBoundBox._tempV34,OrientedBoundBox._tempV32,corners[7]);
		}

		/**
		*变换该包围盒的矩阵信息。
		*@param mat 矩阵
		*/
		__proto.transform=function(mat){
			Matrix4x4.multiply(this.transformation,mat,this.transformation);
		}

		/**
		*缩放该包围盒
		*@param scaling 各轴的缩放比。
		*/
		__proto.scale=function(scaling){
			Vector3.multiply(this.extents,scaling,this.extents);
		}

		/**
		*平移该包围盒。
		*@param translation 平移参数
		*/
		__proto.translate=function(translation){
			var v3=this.transformation.translationVector;
			Vector3.add(v3,translation,OrientedBoundBox._tempV30);
			this.transformation.translationVector=OrientedBoundBox._tempV30;
		}

		/**
		*该包围盒的尺寸。
		*@param out 输出
		*/
		__proto.Size=function(out){
			Vector3.scale(this.extents,2,out);
		}

		/**
		*该包围盒需要考虑的尺寸
		*@param out 输出
		*/
		__proto.getSize=function(out){
			var extentsE=this.extents.elements;
			OrientedBoundBox._tempV30.x=extentsE[0];
			OrientedBoundBox._tempV31.y=extentsE[1];
			OrientedBoundBox._tempV32.z=extentsE[2];
			Vector3.TransformNormal(OrientedBoundBox._tempV30,this.transformation,OrientedBoundBox._tempV30);
			Vector3.TransformNormal(OrientedBoundBox._tempV31,this.transformation,OrientedBoundBox._tempV31);
			Vector3.TransformNormal(OrientedBoundBox._tempV31,this.transformation,OrientedBoundBox._tempV32);
			var oe=out.elements;
			oe[0]=Vector3.scalarLength(OrientedBoundBox._tempV30);
			oe[1]=Vector3.scalarLength(OrientedBoundBox._tempV31);
			oe[2]=Vector3.scalarLength(OrientedBoundBox._tempV32);
		}

		/**
		*该包围盒需要考虑尺寸的平方
		*@param out 输出
		*/
		__proto.getSizeSquared=function(out){
			var extentsE=this.extents.elements;
			OrientedBoundBox._tempV30.x=extentsE[0];
			OrientedBoundBox._tempV31.y=extentsE[1];
			OrientedBoundBox._tempV32.z=extentsE[2];
			Vector3.TransformNormal(OrientedBoundBox._tempV30,this.transformation,OrientedBoundBox._tempV30);
			Vector3.TransformNormal(OrientedBoundBox._tempV31,this.transformation,OrientedBoundBox._tempV31);
			Vector3.TransformNormal(OrientedBoundBox._tempV31,this.transformation,OrientedBoundBox._tempV32);
			var oe=out.elements;
			oe[0]=Vector3.scalarLengthSquared(OrientedBoundBox._tempV30);
			oe[1]=Vector3.scalarLengthSquared(OrientedBoundBox._tempV31);
			oe[2]=Vector3.scalarLengthSquared(OrientedBoundBox._tempV32);
		}

		/**
		*该包围盒的几何中心
		*/
		__proto.getCenter=function(){
			return this.transformation.translationVector;
		}

		/**
		*该包围盒是否包含空间中一点
		*@param point 点
		*@return 返回位置关系
		*/
		__proto.containsPoint=function(point){
			var extentsE=this.extents.elements;
			var extentsEX=extentsE[0];
			var extentsEY=extentsE[1];
			var extentsEZ=extentsE[2];
			this.transformation.invert(OrientedBoundBox._tempM0);
			Vector3.transformCoordinate(point,OrientedBoundBox._tempM0,OrientedBoundBox._tempV30);
			var _tempV30e=OrientedBoundBox._tempV30.elements;
			var _tempV30ex=Math.abs(_tempV30e[0]);
			var _tempV30ey=Math.abs(_tempV30e[1]);
			var _tempV30ez=Math.abs(_tempV30e[2]);
			if (MathUtils3D.nearEqual(_tempV30ex,extentsEX)&& MathUtils3D.nearEqual(_tempV30ey,extentsEY)&& MathUtils3D.nearEqual(_tempV30ez,extentsEZ))
				return /*laya.d3.math.ContainmentType.Intersects*/2;
			if (_tempV30ex < extentsEX && _tempV30ey < extentsEY && _tempV30ez < extentsEZ)
				return /*laya.d3.math.ContainmentType.Contains*/1;
			else
			return /*laya.d3.math.ContainmentType.Disjoint*/0;
		}

		/**
		*该包围盒是否包含空间中一包围球
		*@param sphere 包围球
		*@param ignoreScale 是否考虑该包围盒的缩放
		*@return 返回位置关系
		*/
		__proto.containsSphere=function(sphere,ignoreScale){
			(ignoreScale===void 0)&& (ignoreScale=false);
			var extentsE=this.extents.elements;
			var extentsEX=extentsE[0];
			var extentsEY=extentsE[1];
			var extentsEZ=extentsE[2];
			var sphereR=sphere.radius;
			this.transformation.invert(OrientedBoundBox._tempM0);
			Vector3.transformCoordinate(sphere.center,OrientedBoundBox._tempM0,OrientedBoundBox._tempV30);
			var locRadius=NaN;
			if (ignoreScale){
				locRadius=sphereR;
				}else {
				Vector3.scale(Vector3.UnitX,sphereR,OrientedBoundBox._tempV31);
				Vector3.TransformNormal(OrientedBoundBox._tempV31,OrientedBoundBox._tempM0,OrientedBoundBox._tempV31);
				locRadius=Vector3.scalarLength(OrientedBoundBox._tempV31);
			}
			Vector3.scale(this.extents,-1,OrientedBoundBox._tempV32);
			Vector3.Clamp(OrientedBoundBox._tempV30,OrientedBoundBox._tempV32,this.extents,OrientedBoundBox._tempV33);
			var distance=Vector3.distanceSquared(OrientedBoundBox._tempV30,OrientedBoundBox._tempV33);
			if (distance > locRadius *locRadius)
				return /*laya.d3.math.ContainmentType.Disjoint*/0;
			var tempV30e=OrientedBoundBox._tempV30.elements;
			var tempV30ex=tempV30e[0];
			var tempV30ey=tempV30e[1];
			var tempV30ez=tempV30e[2];
			var tempV32e=OrientedBoundBox._tempV32.elements;
			var tempV32ex=tempV32e[0];
			var tempV32ey=tempV32e[1];
			var tempV32ez=tempV32e[2];
			if ((((tempV32ex+locRadius <=tempV30ex)&& (tempV30ex <=extentsEX-locRadius))&& ((extentsEX-tempV32ex > locRadius)&& (tempV32ey+locRadius <=tempV30ey)))&& (((tempV30ey <=extentsEY-locRadius)&& (extentsEY-tempV32ey > locRadius))&& (((tempV32ez+locRadius <=tempV30ez)&& (tempV30ez <=extentsEZ-locRadius))&& (extentsEZ-tempV32ez > locRadius)))){
				return /*laya.d3.math.ContainmentType.Contains*/1;
			}
			return /*laya.d3.math.ContainmentType.Intersects*/2;
		}

		OrientedBoundBox._getRows=function(mat,out){
			out.length=3;
			var mate=mat.elements;
			var row0e=out[0].elements;
			row0e[0]=mate[0];
			row0e[1]=mate[1];
			row0e[2]=mate[2];
			var row1e=out[1].elements;
			row1e[0]=mate[4];
			row1e[1]=mate[5];
			row1e[2]=mate[6];
			var row2e=out[2].elements;
			row2e[0]=mate[8];
			row2e[1]=mate[9];
			row2e[2]=mate[10];
		}

		__static(OrientedBoundBox,
		['_tempV30',function(){return this._tempV30=new Vector3();},'_tempV31',function(){return this._tempV31=new Vector3();},'_tempV32',function(){return this._tempV32=new Vector3();},'_tempV33',function(){return this._tempV33=new Vector3();},'_tempV34',function(){return this._tempV34=new Vector3();},'_tempM0',function(){return this._tempM0=new Matrix4x4();},'_tempM1',function(){return this._tempM1=new Matrix4x4();}
		]);
		return OrientedBoundBox;
	})()


	/**
	*<code>Plane</code> 类用于创建平面。
	*/
	//class laya.d3.math.Plane
	var Plane=(function(){
		function Plane(normal,d){
			this.normal=null;
			this.distance=NaN;
			(d===void 0)&& (d=0);
			this.normal=normal;
			this.distance=d;
		}

		__class(Plane,'laya.d3.math.Plane');
		var __proto=Plane.prototype;
		/**
		*更改平面法线向量的系数，使之成单位长度。
		*/
		__proto.normalize=function(){
			var normalE=this.normal.elements;
			var normalEX=normalE[0];
			var normalEY=normalE[1];
			var normalEZ=normalE[2];
			var magnitude=1 / Math.sqrt(normalEX *normalEX+normalEY *normalEY+normalEZ *normalEZ);
			normalE[0]=normalEX *magnitude;
			normalE[1]=normalEY *magnitude;
			normalE[2]=normalEZ *magnitude;
			this.distance *=magnitude;
		}

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

		Plane.PlaneIntersectionType_Back=0;
		Plane.PlaneIntersectionType_Front=1;
		Plane.PlaneIntersectionType_Intersecting=2;
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

		Vector2.scale=function(a,b,out){
			var e=out.elements;
			var f=a.elements;
			e[0]=f[0] *b;
			e[1]=f[1] *b;
		}

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

		__proto.toDefault=function(){
			this.elements[0]=0;
			this.elements[1]=0;
			this.elements[2]=0;
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

		Vector3.distance=function(value1,value2){
			var value1e=value1.elements;
			var value2e=value2.elements;
			var x=value1e[0]-value2e[0];
			var y=value1e[1]-value2e[1];
			var z=value1e[2]-value2e[2];
			return Math.sqrt((x *x)+(y *y)+(z *z));
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

		Vector3.scalarLengthSquared=function(a){
			var f=a.elements;
			var x=f[0],y=f[1],z=f[2];
			return x *x+y *y+z *z;
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

		Vector3.TransformNormal=function(normal,transform,result){
			var normalElem=normal.elements;
			var normalX=normalElem[0];
			var normalY=normalElem[1];
			var normalZ=normalElem[2];
			var transformElem=transform.elements;
			var resultElem=result.elements;
			resultElem[0]=(normalX *transformElem[0])+(normalY *transformElem[4])+(normalZ *transformElem[8]);
			resultElem[1]=(normalX *transformElem[1])+(normalY *transformElem[5])+(normalZ *transformElem[9]);
			resultElem[2]=(normalX *transformElem[2])+(normalY *transformElem[6])+(normalZ *transformElem[10]);
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

		Vector3.equals=function(a,b){
			var ae=a.elements;
			var be=b.elements;
			return MathUtils3D.nearEqual(Math.abs(ae[0]),Math.abs(be[0]))
			&& MathUtils3D.nearEqual(Math.abs(ae[1]),Math.abs(be[1]))
			&& MathUtils3D.nearEqual(Math.abs(ae[2]),Math.abs(be[2]));
		}

		__static(Vector3,
		['TEMPVec4',function(){return this.TEMPVec4=new Vector4();},'ZERO',function(){return this.ZERO=new Vector3(0.0,0.0,0.0);},'ONE',function(){return this.ONE=new Vector3(1.0,1.0,1.0);},'NegativeUnitX',function(){return this.NegativeUnitX=new Vector3(-1,0,0);},'UnitX',function(){return this.UnitX=new Vector3(1,0,0);},'UnitY',function(){return this.UnitY=new Vector3(0,1,0);},'UnitZ',function(){return this.UnitZ=new Vector3(0,0,1);},'ForwardRH',function(){return this.ForwardRH=new Vector3(0,0,-1);},'ForwardLH',function(){return this.ForwardLH=new Vector3(0,0,1);},'Up',function(){return this.Up=new Vector3(0,1,0);}
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
			this.minDepth=0.0;
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
	*<code>SubMesh</code> 类用于创建子网格数据模板。
	*/
	//class laya.d3.resource.models.SubMesh
	var SubMesh=(function(){
		function SubMesh(){
			this._indexBuffer=null;
			this._vertexBuffer=null;
			this._boneIndices=null;
			this._bufferUsage=null;
			this._indexInMesh=0;
			this._bufferUsage={};
		}

		__class(SubMesh,'laya.d3.resource.models.SubMesh');
		var __proto=SubMesh.prototype;
		Laya.imps(__proto,{"laya.d3.core.render.IRenderable":true,"laya.resource.IDispose":true})
		/**
		*@private
		*/
		__proto._getVertexBuffer=function(index){
			(index===void 0)&& (index=0);
			if (index===0)
				return this._vertexBuffer;
			else
			return null;
		}

		/**
		*@private
		*/
		__proto._getIndexBuffer=function(){
			return this._indexBuffer;
		}

		/**
		*@private
		*/
		__proto._beforeRender=function(state){
			this._vertexBuffer._bind();
			this._indexBuffer._bind();
			return true;
		}

		/**
		*@private
		*渲染。
		*@param state 渲染状态。
		*/
		__proto._render=function(state){
			var indexCount=this._indexBuffer.indexCount;
			state.context.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,indexCount,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,0);
			Stat.drawCall++;
			Stat.trianglesFaces+=indexCount / 3;
		}

		/**
		*<p>彻底清理资源。</p>
		*<p><b>注意：</b>会强制解锁清理。</p>
		*/
		__proto.dispose=function(){
			this._boneIndices=null;
			this._indexBuffer.dispose();
			this._vertexBuffer.dispose();
		}

		/**
		*@private
		*/
		__getset(0,__proto,'_vertexBufferCount',function(){
			return 1;
		});

		/**
		*@private
		*/
		__getset(0,__proto,'indexOfHost',function(){
			return this._indexInMesh;
		});

		/**
		*@private
		*/
		__getset(0,__proto,'triangleCount',function(){
			return this._indexBuffer.indexCount / 3;
		});

		return SubMesh;
	})()


	/**
	*...
	*@author ...
	*/
	//class laya.d3.utils.Physics
	var Physics=(function(){
		function Physics(){}
		__class(Physics,'laya.d3.utils.Physics');
		Physics.rayCastNode=function(ray,sprite3D,outHitInfo){
			if ((sprite3D instanceof laya.d3.core.MeshSprite3D )){
				var meshSprite3D=sprite3D;
				var worldMatrix=sprite3D.transform.worldMatrix;
				var invertWorldMatrix=Physics._tempMatrix4x40;
				worldMatrix.invert(invertWorldMatrix);
				var preRayOrigin=Physics._tempVector30;
				var preRayDirection=Physics._tempVector31;
				var rayOrigin=ray.origin;
				var rayDirection=ray.direction;
				rayOrigin.cloneTo(preRayOrigin);
				rayDirection.cloneTo(preRayDirection);
				Vector3.transformCoordinate(rayOrigin,invertWorldMatrix,rayOrigin);
				Vector3.TransformNormal(rayDirection,invertWorldMatrix,rayDirection);
				Vector3.normalize(rayDirection,rayDirection);
				var renderElements=meshSprite3D.meshRender.renderObject._renderElements;
				for (var i=0,iNum=renderElements.length;i < iNum;i++){
					var renderObj=renderElements[i].renderObj;
					var vertexBuffer=renderObj._getVertexBuffer(0);
					var vertexDatas=vertexBuffer.getData();
					var indexDatas=renderObj._getIndexBuffer().getData();
					var elementRaycastHit=Physics._tempRaycastHit0;
					var isHit=Picker.rayIntersectsPositionsAndIndices(ray,vertexDatas,vertexBuffer.vertexDeclaration,indexDatas,elementRaycastHit);
					if (isHit){
						Vector3.transformCoordinate(elementRaycastHit.position,worldMatrix,elementRaycastHit.position);
						var trianglePositions=elementRaycastHit.trianglePositions;
						Vector3.transformCoordinate(trianglePositions[0],worldMatrix,trianglePositions[0]);
						Vector3.transformCoordinate(trianglePositions[1],worldMatrix,trianglePositions[1]);
						Vector3.transformCoordinate(trianglePositions[2],worldMatrix,trianglePositions[2]);
						var triangleNormals=elementRaycastHit.triangleNormals;
						Vector3.transformCoordinate(triangleNormals[0],worldMatrix,triangleNormals[0]);
						Vector3.transformCoordinate(triangleNormals[1],worldMatrix,triangleNormals[1]);
						Vector3.transformCoordinate(triangleNormals[2],worldMatrix,triangleNormals[2]);
						var rayOriToPos=Physics._tempVector33;
						Vector3.subtract(preRayOrigin,elementRaycastHit.position,rayOriToPos);
						outHitInfo.distance=Vector3.scalarLength(rayOriToPos);
					}
					if (isHit && elementRaycastHit.distance < outHitInfo.distance){
						elementRaycastHit.copy(outHitInfo);
					}
				}
				preRayOrigin.cloneTo(rayOrigin);
				preRayDirection.cloneTo(rayDirection);
			}
			for (var j=0,jNum=sprite3D._childs.length;j < jNum;j++)
			Physics.rayCast(ray,sprite3D._childs[j],outHitInfo);
		}

		Physics.rayCast=function(ray,sprite3D,outHitInfo){
			outHitInfo.position.toDefault();
			outHitInfo.distance=Number.MAX_VALUE;
			outHitInfo.trianglePositions[0].toDefault();
			outHitInfo.trianglePositions[1].toDefault();
			outHitInfo.trianglePositions[2].toDefault();
			outHitInfo.triangleNormals[0].toDefault();
			outHitInfo.triangleNormals[1].toDefault();
			outHitInfo.triangleNormals[2].toDefault();
			Physics.rayCastNode(ray,sprite3D,outHitInfo);
		}

		__static(Physics,
		['_tempVector30',function(){return this._tempVector30=new Vector3();},'_tempVector31',function(){return this._tempVector31=new Vector3();},'_tempVector33',function(){return this._tempVector33=new Vector3();},'_tempMatrix4x40',function(){return this._tempMatrix4x40=new Matrix4x4();},'_tempRaycastHit0',function(){return this._tempRaycastHit0=new RaycastHit();}
		]);
		return Physics;
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

		Picker.rayIntersectsPositionsAndIndices=function(ray,vertexDatas,vertexDeclaration,indices,outHitInfo){
			var vertexStrideFloatCount=vertexDeclaration.vertexStride / 4;
			var positionVertexElementOffset=vertexDeclaration.getVertexElementByUsage(/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION").offset / 4;
			var closestIntersection=Number.MAX_VALUE;
			var closestTriangleVertexIndex1=-1;
			var closestTriangleVertexIndex2=-1;
			var closestTriangleVertexIndex3=-1;
			for (var j=0;j < indices.length;j+=3){
				var vertex1=Picker._tempVector35;
				var vertex1E=vertex1.elements;
				var vertex1Index=indices[j] *vertexStrideFloatCount;
				var vertex1PositionIndex=vertex1Index+positionVertexElementOffset;
				vertex1E[0]=vertexDatas[vertex1PositionIndex];
				vertex1E[1]=vertexDatas[vertex1PositionIndex+1];
				vertex1E[2]=vertexDatas[vertex1PositionIndex+2];
				var vertex2=Picker._tempVector36;
				var vertex2E=vertex2.elements;
				var vertex2Index=indices[j+1] *vertexStrideFloatCount;
				var vertex2PositionIndex=vertex2Index+positionVertexElementOffset;
				vertex2E[0]=vertexDatas[vertex2PositionIndex];
				vertex2E[1]=vertexDatas[vertex2PositionIndex+1];
				vertex2E[2]=vertexDatas[vertex2PositionIndex+2];
				var vertex3=Picker._tempVector37;
				var vertex3E=vertex3.elements;
				var vertex3Index=indices[j+2] *vertexStrideFloatCount;
				var vertex3PositionIndex=vertex3Index+positionVertexElementOffset;
				vertex3E[0]=vertexDatas[vertex3PositionIndex];
				vertex3E[1]=vertexDatas[vertex3PositionIndex+1];
				vertex3E[2]=vertexDatas[vertex3PositionIndex+2];
				var intersection=laya.d3.utils.Picker.rayIntersectsTriangle(ray,vertex1,vertex2,vertex3);
				if (!isNaN(intersection)&& intersection < closestIntersection){
					closestIntersection=intersection;
					closestTriangleVertexIndex1=vertex1Index;
					closestTriangleVertexIndex2=vertex2Index;
					closestTriangleVertexIndex3=vertex3Index;
				}
			}
			if (closestIntersection!==Number.MAX_VALUE){
				outHitInfo.distance=closestIntersection;
				Vector3.normalize(ray.direction,ray.direction);
				Vector3.scale(ray.direction,closestIntersection,outHitInfo.position);
				Vector3.add(ray.origin,outHitInfo.position,outHitInfo.position);
				var trianglePositions=outHitInfo.trianglePositions;
				var position0=trianglePositions[0];
				var position1=trianglePositions[1];
				var position2=trianglePositions[2];
				var position0E=position0.elements;
				var position1E=position1.elements;
				var position2E=position2.elements;
				var closestVertex1PositionIndex=closestTriangleVertexIndex1+positionVertexElementOffset;
				position0E[0]=vertexDatas[closestVertex1PositionIndex];
				position0E[1]=vertexDatas[closestVertex1PositionIndex+1];
				position0E[2]=vertexDatas[closestVertex1PositionIndex+2];
				var closestVertex2PositionIndex=closestTriangleVertexIndex2+positionVertexElementOffset;
				position1E[0]=vertexDatas[closestVertex2PositionIndex];
				position1E[1]=vertexDatas[closestVertex2PositionIndex+1];
				position1E[2]=vertexDatas[closestVertex2PositionIndex+2];
				var closestVertex3PositionIndex=closestTriangleVertexIndex3+positionVertexElementOffset;
				position2E[0]=vertexDatas[closestVertex3PositionIndex];
				position2E[1]=vertexDatas[closestVertex3PositionIndex+1];
				position2E[2]=vertexDatas[closestVertex3PositionIndex+2];
				var normalVertexElement=vertexDeclaration.getVertexElementByUsage(/*laya.d3.graphics.VertexElementUsage.NORMAL0*/"NORMAL");
				if (normalVertexElement){
					var normalVertexElementOffset=normalVertexElement.offset / 4;
					var triangleNormals=outHitInfo.triangleNormals;
					var normal0=triangleNormals[0];
					var normal1=triangleNormals[1];
					var normal2=triangleNormals[2];
					var normal0E=normal0.elements;
					var normal1E=normal1.elements;
					var normal2E=normal2.elements;
					var closestVertex1NormalIndex=closestTriangleVertexIndex1+normalVertexElementOffset;
					normal0E[0]=vertexDatas[closestVertex1NormalIndex];
					normal0E[1]=vertexDatas[closestVertex1NormalIndex+1];
					normal0E[2]=vertexDatas[closestVertex1NormalIndex+2];
					var closestVertex2NormalIndex=closestTriangleVertexIndex2+normalVertexElementOffset;
					normal1E[0]=vertexDatas[closestVertex2NormalIndex];
					normal1E[1]=vertexDatas[closestVertex2NormalIndex+1];
					normal1E[2]=vertexDatas[closestVertex2NormalIndex+2];
					var closestVertex3NormalIndex=closestTriangleVertexIndex3+normalVertexElementOffset;
					normal2E[0]=vertexDatas[closestVertex3NormalIndex];
					normal2E[1]=vertexDatas[closestVertex3NormalIndex+1];
					normal2E[2]=vertexDatas[closestVertex3NormalIndex+2];
				}
				return true;
				}else {
				outHitInfo.position.toDefault();
				outHitInfo.distance=Number.MAX_VALUE;
				outHitInfo.trianglePositions[0].toDefault();
				outHitInfo.trianglePositions[1].toDefault();
				outHitInfo.trianglePositions[2].toDefault();
				outHitInfo.triangleNormals[0].toDefault();
				outHitInfo.triangleNormals[1].toDefault();
				outHitInfo.triangleNormals[2].toDefault();
				return false;
			}
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
		['_tempVector30',function(){return this._tempVector30=new Vector3();},'_tempVector31',function(){return this._tempVector31=new Vector3();},'_tempVector32',function(){return this._tempVector32=new Vector3();},'_tempVector33',function(){return this._tempVector33=new Vector3();},'_tempVector34',function(){return this._tempVector34=new Vector3();},'_tempVector35',function(){return this._tempVector35=new Vector3();},'_tempVector36',function(){return this._tempVector36=new Vector3();},'_tempVector37',function(){return this._tempVector37=new Vector3();}
		]);
		return Picker;
	})()


	/**
	*...
	*@author ...
	*/
	//class laya.d3.utils.RaycastHit
	var RaycastHit=(function(){
		function RaycastHit(){
			this.distance=NaN;
			this.trianglePositions=null;
			this.triangleNormals=null;
			this.position=null;
			this.distance=Number.MAX_VALUE;
			this.trianglePositions=[new Vector3(),new Vector3(),new Vector3()];
			this.trianglePositions.length=3;
			this.triangleNormals=[new Vector3(),new Vector3(),new Vector3()];
			this.triangleNormals.length=3;
			this.position=new Vector3();
		}

		__class(RaycastHit,'laya.d3.utils.RaycastHit');
		var __proto=RaycastHit.prototype;
		__proto.copy=function(dec){
			dec.distance=this.distance;
			this.trianglePositions[0].cloneTo(dec.trianglePositions[0]);
			this.trianglePositions[1].cloneTo(dec.trianglePositions[1]);
			this.trianglePositions[2].cloneTo(dec.trianglePositions[2]);
			this.triangleNormals[0].cloneTo(dec.triangleNormals[0]);
			this.triangleNormals[1].cloneTo(dec.triangleNormals[1]);
			this.triangleNormals[2].cloneTo(dec.triangleNormals[2]);
			this.position.cloneTo(dec.position);
		}

		return RaycastHit;
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
		var __proto=Utils3D.prototype;
		/**
		*@private
		*/
		__proto.testTangent=function(renderElement,vertexBuffer,indeBuffer,bufferUsage){
			var vertexDeclaration=vertexBuffer.vertexDeclaration;
			var material=renderElement._material;
			if (material.normalTexture && !vertexDeclaration.getVertexElementByUsage(/*laya.d3.graphics.VertexElementUsage.TANGENT0*/"TANGENT0")){
				var vertexDatas=vertexBuffer.getData();
				var newVertexDatas=laya.d3.utils.Utils3D.generateTangent(vertexDatas,vertexDeclaration.vertexStride / 4,vertexDeclaration.getVertexElementByUsage(/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION").offset / 4,vertexDeclaration.getVertexElementByUsage(/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV").offset / 4,indeBuffer.getData());
				vertexDeclaration=laya.d3.utils.Utils3D.getVertexTangentDeclaration(vertexDeclaration.getVertexElements());
				var newVB=VertexBuffer3D.create(vertexDeclaration,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4);
				newVB.setData(newVertexDatas);
				vertexBuffer.dispose();
				bufferUsage[ /*laya.d3.graphics.VertexElementUsage.TANGENT0*/"TANGENT0"]=newVB;
				return newVB;
			}
			return vertexBuffer;
		}

		Utils3D._getTexturePath=function(path){
			var extenIndex=path.length-4;
			if (path.indexOf(".dds")==extenIndex || path.indexOf(".tga")==extenIndex || path.indexOf(".exr")==extenIndex || path.indexOf(".DDS")==extenIndex || path.indexOf(".TGA")==extenIndex || path.indexOf(".EXR")==extenIndex)
				path=path.substr(0,extenIndex)+".png";
			return path=URL.formatURL(path);
		}

		Utils3D._rotationTransformScaleSkinAnimation=function(tx,ty,tz,qx,qy,qz,qw,sx,sy,sz,outArray,outOffset){
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

		Utils3D._applyMeshMaterials=function(meshSprite3D,mesh){
			var meshRender=meshSprite3D.meshRender;
			var shaderMaterials=meshRender.sharedMaterials;
			var meshMaterials=mesh.materials;
			for (var i=0,n=meshMaterials.length;i < n;i++)
			(shaderMaterials[i])|| (shaderMaterials[i]=meshMaterials[i]);
			meshRender.sharedMaterials=shaderMaterials;
		}

		Utils3D._loadParticle=function(settting,particle){
			var anglelToRad=Math.PI / 180.0;
			var i=0,n=0;
			var material=new ShurikenParticleMaterial();
			material.diffuseTexture=Texture2D.load(settting.texturePath);
			material.renderMode=/*laya.d3.core.material.BaseMaterial.RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE*/8;
			particle.particleRender.sharedMaterial=material;
			var particleSystem=particle.particleSystem;
			particleSystem.duration=settting.duration;
			particleSystem.looping=settting.looping;
			particleSystem.prewarm=settting.prewarm;
			particleSystem.startDelayType=settting.startDelayType;
			particleSystem.startDelay=settting.startDelay;
			particleSystem.startDelayMin=settting.startDelayMin;
			particleSystem.startDelayMax=settting.startDelayMax;
			particleSystem.startLifetimeType=settting.startLifetimeType;
			particleSystem.startLifetimeConstant=settting.startLifetimeConstant;
			particleSystem.startLifeTimeGradient=Utils3D._initStartLife(settting.startLifetimeGradient);
			particleSystem.startLifetimeConstantMin=settting.startLifetimeConstantMin;
			particleSystem.startLifetimeConstantMax=settting.startLifetimeConstantMax;
			particleSystem.startLifeTimeGradientMin=Utils3D._initStartLife(settting.startLifetimeGradientMin);
			particleSystem.startLifeTimeGradientMax=Utils3D._initStartLife(settting.startLifetimeGradientMax);
			particleSystem.startSpeedType=settting.startSpeedType;
			particleSystem.startSpeedConstant=settting.startSpeedConstant;
			particleSystem.startSpeedConstantMin=settting.startSpeedConstantMin;
			particleSystem.startSpeedConstantMax=settting.startSpeedConstantMax;
			particleSystem.threeDStartSize=settting.threeDStartSize;
			particleSystem.startSizeType=settting.startSizeType;
			particleSystem.startSizeConstant=settting.startSizeConstant;
			var startSizeConstantSeparateArray=settting.startSizeConstantSeparate;
			particleSystem.startSizeConstantSeparate=new Vector3(startSizeConstantSeparateArray[0],startSizeConstantSeparateArray[1],startSizeConstantSeparateArray[2]);
			particleSystem.startSizeConstantMin=settting.startSizeConstantMin;
			particleSystem.startSizeConstantMax=settting.startSizeConstantMax;
			var startSizeConstantMinSeparateArray=settting.startSizeConstantMinSeparate;
			particleSystem.startSizeConstantMinSeparate=new Vector3(startSizeConstantMinSeparateArray[0],startSizeConstantMinSeparateArray[1],startSizeConstantMinSeparateArray[2]);
			var startSizeConstantMaxSeparateArray=settting.startSizeConstantMaxSeparate;
			particleSystem.startSizeConstantMaxSeparate=new Vector3(startSizeConstantMaxSeparateArray[0],startSizeConstantMaxSeparateArray[1],startSizeConstantMaxSeparateArray[2]);
			particleSystem.threeDStartRotation=settting.threeDStartRotation;
			particleSystem.startRotationType=settting.startRotationType;
			particleSystem.startRotationConstant=settting.startRotationConstant *anglelToRad;
			var startRotationConstantSeparateArray=settting.startRotationConstantSeparate;
			particleSystem.startRotationConstantSeparate=new Vector3(startRotationConstantSeparateArray[0] *anglelToRad,startRotationConstantSeparateArray[1] *anglelToRad,startRotationConstantSeparateArray[2] *anglelToRad);
			particleSystem.startRotationConstantMin=settting.startRotationConstantMin *anglelToRad;
			particleSystem.startRotationConstantMax=settting.startRotationConstantMax *anglelToRad;
			var startRotationConstantMinSeparateArray=settting.startRotationConstantMinSeparate;
			particleSystem.startRotationConstantMinSeparate=new Vector3(startRotationConstantMinSeparateArray[0] *anglelToRad,startRotationConstantMinSeparateArray[1] *anglelToRad,startRotationConstantMinSeparateArray[2] *anglelToRad);
			var startRotationConstantMaxSeparateArray=settting.startRotationConstantMaxSeparate;
			particleSystem.startRotationConstantMaxSeparate=new Vector3(startRotationConstantMaxSeparateArray[0] *anglelToRad,startRotationConstantMaxSeparateArray[1] *anglelToRad,startRotationConstantMaxSeparateArray[2] *anglelToRad);
			particleSystem.randomizeRotationDirection=settting.randomizeRotationDirection;
			particleSystem.startColorType=settting.startColorType;
			var startColorConstantArray=settting.startColorConstant;
			particleSystem.startColorConstant=new Vector4(startColorConstantArray[0],startColorConstantArray[1],startColorConstantArray[2],startColorConstantArray[3]);
			var startColorConstantMinArray=settting.startColorConstantMin;
			particleSystem.startColorConstantMin=new Vector4(startColorConstantMinArray[0],startColorConstantMinArray[1],startColorConstantMinArray[2],startColorConstantMinArray[3]);
			var startColorConstantMaxArray=settting.startColorConstantMax;
			particleSystem.startColorConstantMax=new Vector4(startColorConstantMaxArray[0],startColorConstantMaxArray[1],startColorConstantMaxArray[2],startColorConstantMaxArray[3]);
			var gravityArray=settting.gravity;
			var gravityE=particleSystem.gravity.elements;
			gravityE[0]=gravityArray[0];
			gravityE[1]=gravityArray[1];
			gravityE[2]=gravityArray[2];
			particleSystem.gravityModifier=settting.gravityModifier;
			particleSystem.simulationSpace=settting.simulationSpace;
			particleSystem.scaleMode=settting.scaleMode;
			particleSystem.playOnAwake=settting.playOnAwake;
			particleSystem.maxParticles=settting.maxParticles;
			var emissionData=settting.emission;
			var emission=new Emission();
			emission.emissionRate=emissionData.emissionRate;
			var burstsData=emissionData.bursts;
			if (burstsData)
				for (i=0,n=burstsData.length;i < n;i++){
				var brust=burstsData[i];
				emission.addBurst(new Burst(brust.time,brust.min,brust.max));
			}
			emission.enbale=emissionData.enable;
			particleSystem.emission=emission;
			var shapeData=settting.shape;
			var shape;
			switch (shapeData.shapeType){
				case 0:;
					var sphereShape;
					shape=sphereShape=new SphereShape();
					sphereShape.radius=shapeData.sphereRadius;
					sphereShape.emitFromShell=shapeData.sphereEmitFromShell;
					sphereShape.randomDirection=shapeData.sphereRandomDirection;
					break ;
				case 1:;
					var hemiSphereShape;
					shape=hemiSphereShape=new HemisphereShape();
					hemiSphereShape.radius=shapeData.hemiSphereRadius;
					hemiSphereShape.emitFromShell=shapeData.hemiSphereEmitFromShell;
					hemiSphereShape.randomDirection=shapeData.hemiSphereRandomDirection;
					break ;
				case 2:;
					var coneShape;
					shape=coneShape=new ConeShape();
					coneShape.angle=shapeData.coneAngle *anglelToRad;
					coneShape.radius=shapeData.coneRadius;
					coneShape.length=shapeData.coneLength;
					coneShape.emitType=shapeData.coneEmitType;
					coneShape.randomDirection=shapeData.coneRandomDirection;
					break ;
				case 3:;
					var boxShape;
					shape=boxShape=new BoxShape();
					boxShape.x=shapeData.boxX;
					boxShape.y=shapeData.boxY;
					boxShape.z=shapeData.boxZ;
					boxShape.randomDirection=shapeData.boxRandomDirection;
					break ;
				case 7:;
					var circleShape;
					shape=circleShape=new CircleShape();
					circleShape.radius=shapeData.circleRadius;
					circleShape.arc=shapeData.circleArc *anglelToRad;
					circleShape.emitFromEdge=shapeData.circleEmitFromEdge;
					circleShape.randomDirection=shapeData.circleRandomDirection;
					break ;
				}
			shape.enbale=shapeData.enable;
			particleSystem.shape=shape;
			var velocityOverLifetimeData=settting.velocityOverLifetime;
			if (velocityOverLifetimeData){
				var velocityData=velocityOverLifetimeData.velocity;
				var velocity;
				switch (velocityData.type){
					case 0:;
						var constantData=velocityData.constant;
						velocity=GradientVelocity.createByConstant(new Vector3(constantData[0],constantData[1],constantData[2]));
						break ;
					case 1:
						velocity=GradientVelocity.createByGradient(Utils3D._initParticleVelocity(velocityData.gradientX),Utils3D._initParticleVelocity(velocityData.gradientY),Utils3D._initParticleVelocity(velocityData.gradientZ));
						break ;
					case 2:;
						var constantMinData=velocityData.constantMin;
						var constantMaxData=velocityData.constantMax;
						velocity=GradientVelocity.createByRandomTwoConstant(new Vector3(constantMinData[0],constantMinData[1],constantMinData[2]),new Vector3(constantMaxData[0],constantMaxData[1],constantMaxData[2]));
						break ;
					case 3:
						velocity=GradientVelocity.createByRandomTwoGradient(Utils3D._initParticleVelocity(velocityData.gradientXMin),Utils3D._initParticleVelocity(velocityData.gradientXMax),Utils3D._initParticleVelocity(velocityData.gradientYMin),Utils3D._initParticleVelocity(velocityData.gradientYMax),Utils3D._initParticleVelocity(velocityData.gradientZMin),Utils3D._initParticleVelocity(velocityData.gradientZMax));
						break ;
					};
				var velocityOverLifetime=new VelocityOverLifetime(velocity);
				velocityOverLifetime.space=velocityOverLifetimeData.space;
				velocityOverLifetime.enbale=velocityOverLifetimeData.enable;
				particleSystem.velocityOverLifetime=velocityOverLifetime;
			};
			var colorOverLifetimeData=settting.colorOverLifetime;
			if (colorOverLifetimeData){
				var colorData=colorOverLifetimeData.color;
				var color;
				switch (colorData.type){
					case 0:;
						var constColorData=colorData.constant;
						color=GradientColor.createByConstant(new Vector4(constColorData[0],constColorData[1],constColorData[2],constColorData[3]));
						break ;
					case 1:
						color=GradientColor.createByGradient(Utils3D._initParticleColor(colorData.gradient));
						break ;
					case 2:;
						var minConstColorData=colorData.constantMin;
						var maxConstColorData=colorData.constantMax;
						color=GradientColor.createByRandomTwoConstant(new Vector4(minConstColorData[0],minConstColorData[1],minConstColorData[2],minConstColorData[3]),new Vector4(maxConstColorData[0],maxConstColorData[1],maxConstColorData[2],maxConstColorData[3]));
						break ;
					case 3:
						color=GradientColor.createByRandomTwoGradient(Utils3D._initParticleColor(colorData.gradientMin),Utils3D._initParticleColor(colorData.gradientMax));
						break ;
					};
				var colorOverLifetime=new ColorOverLifetime(color);
				colorOverLifetime.enbale=colorOverLifetimeData.enable;
				particleSystem.colorOverLifetime=colorOverLifetime;
			};
			var sizeOverLifetimeData=settting.sizeOverLifetime;
			if (sizeOverLifetimeData){
				var sizeData=sizeOverLifetimeData.size;
				var size;
				switch (sizeData.type){
					case 0:
						if (sizeData.separateAxes){
							size=GradientSize.createByGradientSeparate(Utils3D._initParticleSize(sizeData.gradientX),Utils3D._initParticleSize(sizeData.gradientY),Utils3D._initParticleSize(sizeData.gradientZ));
							}else {
							size=GradientSize.createByGradient(Utils3D._initParticleSize(sizeData.gradient));
						}
						break ;
					case 1:
						if (sizeData.separateAxes){
							var constantMinSeparateData=sizeData.constantMinSeparate;
							var constantMaxSeparateData=sizeData.constantMaxSeparate;
							size=GradientSize.createByRandomTwoConstantSeparate(new Vector3(constantMinSeparateData[0],constantMinSeparateData[1],constantMinSeparateData[2]),new Vector3(constantMaxSeparateData[0],constantMaxSeparateData[1],constantMaxSeparateData[2]));
							}else {
							size=GradientSize.createByRandomTwoConstant(sizeData.constantMin,sizeData.constantMax);
						}
						break ;
					case 2:
						if (sizeData.separateAxes){
							size=GradientSize.createByRandomTwoGradientSeparate(Utils3D._initParticleSize(sizeData.gradientXMin),Utils3D._initParticleSize(sizeData.gradientYMin),Utils3D._initParticleSize(sizeData.gradientZMin),Utils3D._initParticleSize(sizeData.gradientXMax),Utils3D._initParticleSize(sizeData.gradientYMax),Utils3D._initParticleSize(sizeData.gradientZMax));
							}else {
							size=GradientSize.createByRandomTwoGradient(Utils3D._initParticleSize(sizeData.gradientMin),Utils3D._initParticleSize(sizeData.gradientMax));
						}
						break ;
					};
				var sizeOverLifetime=new SizeOverLifetime(size);
				sizeOverLifetime.enbale=sizeOverLifetimeData.enable;
				particleSystem.sizeOverLifetime=sizeOverLifetime;
			};
			var rotationOverLifetimeData=settting.rotationOverLifetime;
			if (rotationOverLifetimeData){
				var angularVelocityData=rotationOverLifetimeData.angularVelocity;
				var angularVelocity;
				switch (angularVelocityData.type){
					case 0:
						if (angularVelocityData.separateAxes){
							}else {
							angularVelocity=GradientAngularVelocity.createByConstant(angularVelocityData.constant *anglelToRad);
						}
						break ;
					case 1:
						if (angularVelocityData.separateAxes){
							}else {
							angularVelocity=GradientAngularVelocity.createByGradient(Utils3D._initParticleRotation(angularVelocityData.gradient));
						}
						break ;
					case 2:
						if (angularVelocityData.separateAxes){
							}else {
							angularVelocity=GradientAngularVelocity.createByRandomTwoConstant(angularVelocityData.constantMin *anglelToRad,angularVelocityData.constantMax *anglelToRad);
						}
						break ;
					case 3:
						if (angularVelocityData.separateAxes){
							}else {
							angularVelocity=GradientAngularVelocity.createByRandomTwoGradient(Utils3D._initParticleRotation(angularVelocityData.gradientMin),Utils3D._initParticleRotation(angularVelocityData.gradientMax));
						}
						break ;
					};
				var rotationOverLifetime=new RotationOverLifetime(angularVelocity);
				rotationOverLifetime.enbale=rotationOverLifetimeData.enable;
				particleSystem.rotationOverLifetime=rotationOverLifetime;
			};
			var textureSheetAnimationData=settting.textureSheetAnimation;
			if (textureSheetAnimationData){
				var frameData=textureSheetAnimationData.frame;
				var frameOverTime;
				switch (frameData.type){
					case 0:
						frameOverTime=FrameOverTime.createByConstant(frameData.constant);
						break ;
					case 1:
						frameOverTime=FrameOverTime.createByOverTime(Utils3D._initParticleFrame(frameData.overTime));
						break ;
					case 2:
						frameOverTime=FrameOverTime.createByRandomTwoConstant(frameData.constantMin,frameData.constantMax);
						break ;
					case 3:
						frameOverTime=FrameOverTime.createByRandomTwoOverTime(Utils3D._initParticleFrame(frameData.overTimeMin),Utils3D._initParticleFrame(frameData.overTimeMax));
						break ;
					};
				var startFrameData=textureSheetAnimationData.startFrame;
				var startFrame;
				switch (startFrameData.type){
					case 0:
						startFrame=StartFrame.createByConstant(startFrameData.constant);
						break ;
					case 1:
						startFrame=StartFrame.createByRandomTwoConstant(startFrameData.constantMin,startFrameData.constantMax);
						break ;
					};
				var textureSheetAnimation=new TextureSheetAnimation(frameOverTime,startFrame);
				textureSheetAnimation.enbale=textureSheetAnimationData.enable;
				var tilesData=textureSheetAnimationData.tiles;
				textureSheetAnimation.tiles=new Vector2(tilesData[0],tilesData[1]);
				textureSheetAnimation.type=textureSheetAnimationData.type;
				textureSheetAnimation.randomRow=textureSheetAnimationData.randomRow;
				textureSheetAnimation.cycles=textureSheetAnimationData.cycles;
				particleSystem.textureSheetAnimation=textureSheetAnimation;
			};
			var particleRender=particle.particleRender;
			particleRender.renderMode=settting.renderMode;
			particleRender.stretchedBillboardCameraSpeedScale=settting.stretchedBillboardCameraSpeedScale;
			particleRender.stretchedBillboardSpeedScale=settting.stretchedBillboardSpeedScale;
			particleRender.stretchedBillboardLengthScale=settting.stretchedBillboardLengthScale;
			(particleSystem.playOnAwake)&& (emission.play());
		}

		Utils3D._parseHierarchyProp=function(node,json){
			var customProps=json.customProps;
			var transValue=customProps.translate;
			node.transform.localPosition=new Vector3(transValue[0],transValue[1],transValue[2]);
			var rotValue=customProps.rotation;
			node.transform.localRotation=new Quaternion(rotValue[0],rotValue[1],rotValue[2],rotValue[3]);
			var scaleValue=customProps.scale;
			node.transform.localScale=new Vector3(scaleValue[0],scaleValue[1],scaleValue[2]);
			switch (json.type){
				case "Sprite3D":
					break ;
				case "MeshSprite3D":;
					var loadPath=URL.formatURL(json.instanceParams.loadPath);
					var mesh=Mesh.load(loadPath);
					var meshSprite3D=(node);
					meshSprite3D.meshFilter.sharedMesh=mesh;
					if (mesh.loaded)
						meshSprite3D.meshRender.sharedMaterials=mesh.materials;
					else
					mesh.once(/*laya.events.Event.LOADED*/"loaded",meshSprite3D,meshSprite3D._applyMeshMaterials);
					break ;
				case "ShuriKenParticle3D":;
					var shuriKenParticle3D=(node);
					Utils3D._loadParticle(customProps,shuriKenParticle3D);
					break ;
				}
		}

		Utils3D._parseHierarchyNode=function(json){
			switch (json.type){
				case "Sprite3D":
					return new Sprite3D();
					break ;
				case "MeshSprite3D":
					return new MeshSprite3D();
					break ;
				case "ShuriKenParticle3D":
					return new ShuriKenParticle3D();
					break ;
				default :
					throw new Error("Utils3D:unidentified class type in (.lh) file.");
				}
		}

		Utils3D._initStartLife=function(gradientData){
			var gradient=new GradientDataNumber();
			var startLifetimesData=gradientData.startLifetimes;
			for (var i=0,n=startLifetimesData.length;i < n;i++){
				var valueData=startLifetimesData[i];
				gradient.add(valueData.key,valueData.value);
			}
			return gradient
		}

		Utils3D._initParticleVelocity=function(gradientData){
			var gradient=new GradientDataNumber();
			var velocitysData=gradientData.velocitys;
			for (var i=0,n=velocitysData.length;i < n;i++){
				var valueData=velocitysData[i];
				gradient.add(valueData.key,valueData.value);
			}
			return gradient;
		}

		Utils3D._initParticleColor=function(gradientColorData){
			var gradientColor=new GradientDataColor();
			var alphasData=gradientColorData.alphas;
			var i=0,n=0;
			for (i=0,n=alphasData.length;i < n;i++){
				var alphaData=alphasData[i];
				gradientColor.addAlpha(alphaData.key,alphaData.value);
			};
			var rgbsData=gradientColorData.rgbs;
			for (i=0,n=rgbsData.length;i < n;i++){
				var rgbData=rgbsData[i];
				var rgbValue=rgbData.value;
				gradientColor.addRGB(rgbData.key,new Vector3(rgbValue[0],rgbValue[1],rgbValue[2]));
			}
			return gradientColor;
		}

		Utils3D._initParticleSize=function(gradientSizeData){
			var gradientSize=new GradientDataNumber();
			var sizesData=gradientSizeData.sizes;
			for (var i=0,n=sizesData.length;i < n;i++){
				var valueData=sizesData[i];
				gradientSize.add(valueData.key,valueData.value);
			}
			return gradientSize;
		}

		Utils3D._initParticleRotation=function(gradientData){
			var gradient=new GradientDataNumber();
			var angularVelocitysData=gradientData.angularVelocitys;
			for (var i=0,n=angularVelocitysData.length;i < n;i++){
				var valueData=angularVelocitysData[i];
				gradient.add(valueData.key,valueData.value /180.0*Math.PI);
			}
			return gradient;
		}

		Utils3D._initParticleFrame=function(overTimeFramesData){
			var overTimeFrame=new GradientDataInt();
			var framesData=overTimeFramesData.frames;
			for (var i=0,n=framesData.length;i < n;i++){
				var frameData=framesData[i];
				overTimeFrame.add(frameData.key,frameData.value);
			}
			return overTimeFrame;
		}

		Utils3D._parseMaterial=function(material,json){
			var customProps=json.customProps;
			var ambientColorValue=customProps.ambientColor;
			material.ambientColor=new Vector3(ambientColorValue[0],ambientColorValue[1],ambientColorValue[2]);
			var diffuseColorValue=customProps.diffuseColor;
			material.diffuseColor=new Vector3(diffuseColorValue[0],diffuseColorValue[1],diffuseColorValue[2]);
			var specularColorValue=customProps.specularColor;
			material.specularColor=new Vector4(specularColorValue[0],specularColorValue[1],specularColorValue[2],specularColorValue[3]);
			var reflectColorValue=customProps.reflectColor;
			material.reflectColor=new Vector3(reflectColorValue[0],reflectColorValue[1],reflectColorValue[2]);
			var diffuseTexture=customProps.diffuseTexture.texture2D;
			(diffuseTexture)&& (material.diffuseTexture=Laya.loader.create(Utils3D._getTexturePath(diffuseTexture),null,null,Texture2D));
			var normalTexture=customProps.normalTexture.texture2D;
			(normalTexture)&& (material.normalTexture=Laya.loader.create(Utils3D._getTexturePath(normalTexture),null,null,Texture2D));
			var specularTexture=customProps.specularTexture.texture2D;
			(specularTexture)&& (material.specularTexture=Laya.loader.create(Utils3D._getTexturePath(specularTexture),null,null,Texture2D));
			var emissiveTexture=customProps.emissiveTexture.texture2D;
			(emissiveTexture)&& (material.emissiveTexture=Laya.loader.create(Utils3D._getTexturePath(emissiveTexture),null,null,Texture2D));
			var ambientTexture=customProps.ambientTexture.texture2D;
			(ambientTexture)&& (material.ambientTexture=Laya.loader.create(Utils3D._getTexturePath(ambientTexture),null,null,Texture2D));
			var reflectTexture=customProps.reflectTexture.texture2D;
			(reflectTexture)&& (material.reflectTexture=Laya.loader.create(Utils3D._getTexturePath(reflectTexture),null,null,Texture2D));
		}

		Utils3D._computeBoneAndAnimationDatas=function(bones,curData,exData,outBonesDatas,outAnimationDatas){
			var offset=0;
			var matOffset=0;
			var len=exData.length / 2;
			var i;
			var parentOffset;
			var boneLength=bones.length;
			for (i=0;i < boneLength;offset+=bones[i].keyframeWidth,matOffset+=16,i++){
				laya.d3.utils.Utils3D._rotationTransformScaleSkinAnimation(curData[offset+7],curData[offset+8],curData[offset+9],curData[offset+3],curData[offset+4],curData[offset+5],curData[offset+6],curData[offset+0],curData[offset+1],curData[offset+2],outBonesDatas,matOffset);
				if (i !=0){
					parentOffset=bones[i].parentIndex *16;
					laya.d3.utils.Utils3D.mulMatrixByArray(outBonesDatas,parentOffset,outBonesDatas,matOffset,outBonesDatas,matOffset);
				}
			}
			for (i=0;i < len;i+=16){
				laya.d3.utils.Utils3D.mulMatrixByArrayFast(outBonesDatas,i,exData,len+i,outAnimationDatas,i);
			}
		}

		Utils3D._computeAnimationDatas=function(exData,bonesDatas,outAnimationDatas){
			var len=exData.length / 2;
			for (var i=0;i < len;i+=16){
				laya.d3.utils.Utils3D.mulMatrixByArrayFast(bonesDatas,i,exData,len+i,outAnimationDatas,i);
			}
		}

		Utils3D._computeBoneAndAnimationDatasByBindPoseMatrxix=function(bones,curData,inverGlobalBindPose,outBonesDatas,outAnimationDatas){
			var offset=0;
			var matOffset=0;
			var i;
			var parentOffset;
			var boneLength=bones.length;
			for (i=0;i < boneLength;offset+=bones[i].keyframeWidth,matOffset+=16,i++){
				laya.d3.utils.Utils3D._rotationTransformScaleSkinAnimation(curData[offset+7],curData[offset+8],curData[offset+9],curData[offset+3],curData[offset+4],curData[offset+5],curData[offset+6],curData[offset+0],curData[offset+1],curData[offset+2],outBonesDatas,matOffset);
				if (i !=0){
					parentOffset=bones[i].parentIndex *16;
					laya.d3.utils.Utils3D.mulMatrixByArray(outBonesDatas,parentOffset,outBonesDatas,matOffset,outBonesDatas,matOffset);
				}
			};
			var n=inverGlobalBindPose.length;
			for (i=0;i < n;i++){
				var arrayOffset=i *16;
				laya.d3.utils.Utils3D.mulMatrixByArrayAndMatrixFast(outBonesDatas,arrayOffset,inverGlobalBindPose[i],outAnimationDatas,arrayOffset);
			}
		}

		Utils3D._computeAnimationDatasByArrayAndMatrixFast=function(inverGlobalBindPose,bonesDatas,outAnimationDatas){
			var n=inverGlobalBindPose.length;
			for (var i=0;i < n;i++){
				var arrayOffset=i *16;
				laya.d3.utils.Utils3D.mulMatrixByArrayAndMatrixFast(bonesDatas,arrayOffset,inverGlobalBindPose[i],outAnimationDatas,arrayOffset);
			}
		}

		Utils3D._computeRootAnimationData=function(bones,curData,animationDatas){
			for (var i=0,offset=0,matOffset=0,boneLength=bones.length;i < boneLength;offset+=bones[i].keyframeWidth,matOffset+=16,i++)
			laya.d3.utils.Utils3D.createAffineTransformationArray(curData[offset+0],curData[offset+1],curData[offset+2],curData[offset+3],curData[offset+4],curData[offset+5],curData[offset+6],curData[offset+7],curData[offset+8],curData[offset+9],animationDatas,matOffset);
		}

		Utils3D.generateTangent=function(vertexDatas,vertexStride,positionOffset,uvOffset,indices){
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
			var position=false,normal=false,color=false,texcoord0=false,texcoord1=false,blendWeight=false,blendIndex=false;
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
				vertexDeclaration=VertexPositionNormalColorTexture0Texture1SkinTangent.vertexDeclaration;
			if (position && normal && color && texcoord0 && blendWeight && blendIndex)
				vertexDeclaration=VertexPositionNormalColorTextureSkinTangent.vertexDeclaration;
			else if (position && normal && texcoord0 && texcoord1 && blendWeight && blendIndex)
			vertexDeclaration=VertexPositionNormalTexture0Texture1SkinTangent.vertexDeclaration;
			else if (position && normal && texcoord0 && blendWeight && blendIndex)
			vertexDeclaration=VertexPositionNormalTextureSkinTangent.vertexDeclaration;
			else if (position && normal && color && blendWeight && blendIndex)
			vertexDeclaration=VertexPositionNormalColorSkinTangent.vertexDeclaration;
			else if (position && normal && color && texcoord0 && texcoord1)
			vertexDeclaration=VertexPositionNormalColorTexture0Texture1Tangent.vertexDeclaration;
			else if (position && normal && color && texcoord0)
			vertexDeclaration=VertexPositionNormalColorTextureTangent.vertexDeclaration;
			else if (position && normal && texcoord0 && texcoord1)
			vertexDeclaration=VertexPositionNormalTexture0Texture1Tangent.vertexDeclaration;
			else if (position && normal && texcoord0)
			vertexDeclaration=VertexPositionNormalTextureTangent.vertexDeclaration;
			else if (position && normal && color)
			vertexDeclaration=VertexPositionNormalColorTangent.vertexDeclaration;
			return vertexDeclaration;
		}

		Utils3D.transformVector3ArrayByQuat=function(sourceArray,sourceOffset,rotation,outArray,outOffset){
			var re=rotation.elements;
			var x=sourceArray[sourceOffset],y=sourceArray[sourceOffset+1],z=sourceArray[sourceOffset+2],qx=re[0],qy=re[1],qz=re[2],qw=re[3],
			ix=qw *x+qy *z-qz *y,iy=qw *y+qz *x-qx *z,iz=qw *z+qx *y-qy *x,iw=-qx *x-qy *y-qz *z;
			outArray[outOffset]=ix *qw+iw *-qx+iy *-qz-iz *-qy;
			outArray[outOffset+1]=iy *qw+iw *-qy+iz *-qx-ix *-qz;
			outArray[outOffset+2]=iz *qw+iw *-qz+ix *-qy-iy *-qx;
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

		Utils3D.mulMatrixByArrayAndMatrixFast=function(leftArray,leftOffset,rightMatrix,outArray,outOffset){
			var i,ai0,ai1,ai2,ai3;
			var rightMatrixE=rightMatrix.elements;
			var m11=rightMatrixE[0],m12=rightMatrixE[1],m13=rightMatrixE[2],m14=rightMatrixE[3];
			var m21=rightMatrixE[4],m22=rightMatrixE[5],m23=rightMatrixE[6],m24=rightMatrixE[7];
			var m31=rightMatrixE[8],m32=rightMatrixE[9],m33=rightMatrixE[10],m34=rightMatrixE[11];
			var m41=rightMatrixE[12],m42=rightMatrixE[13],m43=rightMatrixE[14],m44=rightMatrixE[15];
			var ai0LeftOffset=leftOffset;
			var ai1LeftOffset=leftOffset+4;
			var ai2LeftOffset=leftOffset+8;
			var ai3LeftOffset=leftOffset+12;
			var ai0OutOffset=outOffset;
			var ai1OutOffset=outOffset+4;
			var ai2OutOffset=outOffset+8;
			var ai3OutOffset=outOffset+12;
			for (i=0;i < 4;i++){
				ai0=leftArray[ai0LeftOffset+i];
				ai1=leftArray[ai1LeftOffset+i];
				ai2=leftArray[ai2LeftOffset+i];
				ai3=leftArray[ai3LeftOffset+i];
				outArray[ai0OutOffset+i]=ai0 *m11+ai1 *m12+ai2 *m13+ai3 *m14;
				outArray[ai1OutOffset+i]=ai0 *m21+ai1 *m22+ai2 *m23+ai3 *m24;
				outArray[ai2OutOffset+i]=ai0 *m31+ai1 *m32+ai2 *m33+ai3 *m34;
				outArray[ai3OutOffset+i]=ai0 *m41+ai1 *m42+ai2 *m43+ai3 *m44;
			}
		}

		Utils3D.createAffineTransformationArray=function(tX,tY,tZ,rX,rY,rZ,rW,sX,sY,sZ,outArray,outOffset){
			var x2=rX+rX,y2=rY+rY,z2=rZ+rZ;
			var xx=rX *x2,xy=rX *y2,xz=rX *z2,yy=rY *y2,yz=rY *z2,zz=rZ *z2;
			var wx=rW *x2,wy=rW *y2,wz=rW *z2;
			outArray[outOffset+0]=(1-(yy+zz))*sX;
			outArray[outOffset+1]=(xy+wz)*sX;
			outArray[outOffset+2]=(xz-wy)*sX;
			outArray[outOffset+3]=0;
			outArray[outOffset+4]=(xy-wz)*sY;
			outArray[outOffset+5]=(1-(xx+zz))*sY;
			outArray[outOffset+6]=(yz+wx)*sY;
			outArray[outOffset+7]=0;
			outArray[outOffset+8]=(xz+wy)*sZ;
			outArray[outOffset+9]=(yz-wx)*sZ;
			outArray[outOffset+10]=(1-(xx+yy))*sZ;
			outArray[outOffset+11]=0;
			outArray[outOffset+12]=tX;
			outArray[outOffset+13]=tY;
			outArray[outOffset+14]=tZ;
			outArray[outOffset+15]=1;
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
			oe[0]=-RenderState.clientWidth / 2+se[0];
			oe[1]=RenderState.clientHeight / 2-se[1];
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
		Laya3D._initShader=function(){
			Shader.addInclude("LightHelper.glsl","\nstruct DirectionLight\n{\n vec3 Direction;\n vec3 Diffuse;\n vec3 Ambient;\n vec3 Specular;\n};\n\nstruct PointLight\n{\n vec3 Diffuse;\n vec3 Ambient;\n vec3 Specular;\n vec3 Attenuation;\n vec3 Position;\n float Range;\n};\n\nstruct SpotLight\n{\n vec3 Diffuse;\n vec3 Ambient;\n vec3 Specular;\n vec3 Attenuation;\n vec3 Position;\n vec3 Direction;\n float Spot;\n float Range;\n};\n\n\nvoid  computeDirectionLight(in vec3 matDif,in vec3 matAmb,in vec4 matSpe,in DirectionLight dirLight,in vec3 normal,in vec3 toEye,out vec3 dif,out vec3 amb,out vec3 spec)\n{\n	dif=vec3(0.0);//不初始化在IOS中闪烁，PC中不会闪烁\n	amb=vec3(0.0);\n	spec=vec3(0.0);\n	vec3 lightVec=-normalize(dirLight.Direction);\n	\n	amb=matAmb*dirLight.Ambient;\n	\n	float  diffuseFactor=dot(lightVec, normal);\n	\n	if(diffuseFactor>0.0)\n	{\n	   vec3 v = reflect(-lightVec, normal);\n	   float specFactor = pow(max(dot(v, toEye), 0.0), matSpe.w);\n	   \n	   dif = diffuseFactor * matDif * dirLight.Diffuse;\n	   spec = specFactor * matSpe.rgb * dirLight.Specular;\n	}\n	\n}\n\nvoid computePointLight(in vec3 matDif,in vec3 matAmb,in vec4 matSpe,in PointLight poiLight, in vec3 pos,in vec3 normal,in vec3 toEye,out vec3 dif,out vec3 amb,out vec3 spec)\n{\n	dif=vec3(0.0);\n	amb=vec3(0.0);\n	spec=vec3(0.0);\n	vec3 lightVec = poiLight.Position - pos;\n		\n	float d = length(lightVec);\n	\n	if( d > poiLight.Range )\n		return;\n		\n	lightVec /= d; \n	\n	amb = matAmb * poiLight.Ambient;	\n\n	float diffuseFactor = dot(lightVec, normal);\n\n	if( diffuseFactor > 0.0 )\n	{\n		vec3 v= reflect(-lightVec, normal);\n		float specFactor = pow(max(dot(v, toEye), 0.0), matSpe.w);\n					\n		dif = diffuseFactor * matDif * poiLight.Diffuse;\n		spec = specFactor * matSpe.rgb * poiLight.Specular;\n	}\n\n	float attenuate = 1.0 / dot(poiLight.Attenuation, vec3(1.0, d, d*d));\n\n	dif *= attenuate;\n	spec*= attenuate;\n}\n\nvoid ComputeSpotLight(in vec3 matDif,in vec3 matAmb,in vec4 matSpe,in SpotLight spoLight,in vec3 pos, in vec3 normal,in vec3 toEye,out vec3 dif,out vec3 amb,out vec3 spec)\n{\n	amb = vec3(0.0);\n	dif =vec3(0.0);\n	spec= vec3(0.0);\n	vec3 lightVec = spoLight.Position - pos;\n		\n	float d = length(lightVec);\n	\n	if( d > spoLight.Range)\n		return;\n		\n	lightVec /= d; \n	\n	amb = matAmb * spoLight.Ambient;	\n\n	float diffuseFactor = dot(lightVec, normal);\n\n	if(diffuseFactor > 0.0)\n	{\n		vec3 v= reflect(-lightVec, normal);\n		float specFactor = pow(max(dot(v, toEye), 0.0), matSpe.w);\n					\n		dif = diffuseFactor * matDif * spoLight.Diffuse;\n		spec = specFactor * matSpe.rgb * spoLight.Specular;\n	}\n	\n	float spot = pow(max(dot(-lightVec, normalize(spoLight.Direction)), 0.0), spoLight.Spot);\n\n	float attenuate = spot/dot(spoLight.Attenuation, vec3(1.0, d, d*d));\n\n	amb *= spot;\n	dif *= attenuate;\n	spec*= attenuate;\n}\n\nvec3 NormalSampleToWorldSpace(vec3 normalMapSample, vec3 unitNormal, vec3 tangent)\n{\n	vec3 normalT = 2.0*normalMapSample - 1.0;\n\n	// Build orthonormal basis.\n	vec3 N = normalize(unitNormal);\n	vec3 T = normalize(tangent- dot(tangent, N)*N);\n	vec3 B = cross(T, N);\n\n	mat3 TBN = mat3(T, B, N);\n\n	// Transform from tangent space to world space.\n	vec3 bumpedNormal = TBN*normalT;\n\n	return bumpedNormal;\n}\n"/*__INCLUDESTR__E:/trank/libs/LayaAir/publish/LayaAirPublish/src/d3/src/laya/d3/shader/files/LightHelper.glsl*/);
			Shader.addInclude("VRHelper.glsl","\nvec4 DistortFishEye(vec4 p)\n{\n    vec2 v = p.xy / p.w;\n    float radius = length(v);// Convert to polar coords\n    if (radius > 0.0)\n    {\n      float theta = atan(v.y,v.x);\n      \n      radius = pow(radius, 0.93);// Distort:\n\n      v.x = radius * cos(theta);// Convert back to Cartesian\n      v.y = radius * sin(theta);\n      p.xy = v.xy * p.w;\n    }\n    return p;\n}"/*__INCLUDESTR__E:/trank/libs/LayaAir/publish/LayaAirPublish/src/d3/src/laya/d3/shader/files/VRHelper.glsl*/);
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
				'u_CameraPos':/*laya.d3.core.scene.BaseScene.CAMERAPOS*/"CAMERAPOS",
				'u_FogStart':/*laya.d3.core.scene.BaseScene.FOGSTART*/"FOGSTART",
				'u_FogRange':/*laya.d3.core.scene.BaseScene.FOGRANGE*/"FOGRANGE",
				'u_FogColor':/*laya.d3.core.scene.BaseScene.FOGCOLOR*/"FOGCOLOR",
				'u_DirectionLight.Direction':/*laya.d3.core.scene.BaseScene.LIGHTDIRECTION*/"LIGHTDIRECTION",
				'u_DirectionLight.Diffuse':/*laya.d3.core.scene.BaseScene.LIGHTDIRDIFFUSE*/"LIGHTDIRDIFFUSE",
				'u_DirectionLight.Ambient':/*laya.d3.core.scene.BaseScene.LIGHTDIRAMBIENT*/"LIGHTDIRAMBIENT",
				'u_DirectionLight.Specular':/*laya.d3.core.scene.BaseScene.LIGHTDIRSPECULAR*/"LIGHTDIRSPECULAR",
				'u_PointLight.Position':/*laya.d3.core.scene.BaseScene.POINTLIGHTPOS*/"POINTLIGHTPOS",
				'u_PointLight.Range':/*laya.d3.core.scene.BaseScene.POINTLIGHTRANGE*/"POINTLIGHTRANGE",
				'u_PointLight.Attenuation':/*laya.d3.core.scene.BaseScene.POINTLIGHTATTENUATION*/"POINTLIGHTATTENUATION",
				'u_PointLight.Diffuse':/*laya.d3.core.scene.BaseScene.POINTLIGHTDIFFUSE*/"POINTLIGHTDIFFUSE",
				'u_PointLight.Ambient':/*laya.d3.core.scene.BaseScene.POINTLIGHTAMBIENT*/"POINTLIGHTAMBIENT",
				'u_PointLight.Specular':/*laya.d3.core.scene.BaseScene.POINTLIGHTSPECULAR*/"POINTLIGHTSPECULAR",
				'u_SpotLight.Position':/*laya.d3.core.scene.BaseScene.SPOTLIGHTPOS*/"SPOTLIGHTPOS",
				'u_SpotLight.Direction':/*laya.d3.core.scene.BaseScene.SPOTLIGHTDIRECTION*/"SPOTLIGHTDIRECTION",
				'u_SpotLight.Range':/*laya.d3.core.scene.BaseScene.SPOTLIGHTRANGE*/"SPOTLIGHTRANGE",
				'u_SpotLight.Spot':/*laya.d3.core.scene.BaseScene.SPOTLIGHTSPOT*/"SPOTLIGHTSPOT",
				'u_SpotLight.Attenuation':/*laya.d3.core.scene.BaseScene.SPOTLIGHTATTENUATION*/"SPOTLIGHTATTENUATION",
				'u_SpotLight.Diffuse':/*laya.d3.core.scene.BaseScene.SPOTLIGHTDIFFUSE*/"SPOTLIGHTDIFFUSE",
				'u_SpotLight.Ambient':/*laya.d3.core.scene.BaseScene.SPOTLIGHTAMBIENT*/"SPOTLIGHTAMBIENT",
				'u_SpotLight.Specular':/*laya.d3.core.scene.BaseScene.SPOTLIGHTSPECULAR*/"SPOTLIGHTSPECULAR",
				'u_WorldMat':/*laya.d3.core.material.StandardMaterial.WORLDMATRIX*/"MATRIX1",
				'u_DiffuseTexture':/*laya.d3.core.material.StandardMaterial.DIFFUSETEXTURE*/"DIFFUSETEXTURE",
				'u_SpecularTexture':/*laya.d3.core.material.StandardMaterial.SPECULARTEXTURE*/"SPECULARTEXTURE",
				'u_NormalTexture':/*laya.d3.core.material.StandardMaterial.NORMALTEXTURE*/"NORMALTEXTURE",
				'u_AmbientTexture':/*laya.d3.core.material.StandardMaterial.AMBIENTTEXTURE*/"AMBIENTTEXTURE",
				'u_ReflectTexture':/*laya.d3.core.material.StandardMaterial.REFLECTTEXTURE*/"REFLECTTEXTURE",
				'u_MvpMatrix':/*laya.d3.core.material.StandardMaterial.MVPMATRIX*/"MVPMATRIX",
				'u_Bones':/*laya.d3.core.material.StandardMaterial.Bones*/"MATRIXARRAY0",
				'u_Albedo':/*laya.d3.core.material.StandardMaterial.ALBEDO*/"ALBEDO",
				'u_AlphaTestValue':/*laya.d3.core.material.StandardMaterial.ALPHATESTVALUE*/"ALPHATESTVALUE",
				'u_UVMatrix':/*laya.d3.core.material.StandardMaterial.UVMATRIX*/"MATRIX2",
				'u_UVAge':/*laya.d3.core.material.StandardMaterial.UVAGE*/"FLOAT0",
				'u_UVAniAge':/*laya.d3.core.material.StandardMaterial.UVANIAGE*/"UVAGEX",
				'u_MaterialDiffuse':/*laya.d3.core.material.StandardMaterial.MATERIALDIFFUSE*/"MATERIALDIFFUSE",
				'u_MaterialAmbient':/*laya.d3.core.material.StandardMaterial.MATERIALAMBIENT*/"MATERIALAMBIENT",
				'u_MaterialSpecular':/*laya.d3.core.material.StandardMaterial.MATERIALSPECULAR*/"MATERIALSPECULAR",
				'u_MaterialReflect':/*laya.d3.core.material.StandardMaterial.MATERIALREFLECT*/"MATERIALREFLECT"};
			var SIMPLE=Shader.nameKey.add("SIMPLE");
			vs="#include?VR \"VRHelper.glsl\";\nattribute vec4 a_Position;\nuniform mat4 u_MvpMatrix;\n\n\n\n#ifdef DIFFUSEMAP||((DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&(COLOR&&SPECULARMAP||NORMALMAP))\nattribute vec2 a_Texcoord0;\nvarying vec2 v_Texcoord0;\n  #ifdef MIXUV\n  attribute vec2 a_TexcoordNext0;\n  uniform float  u_UVAge;\n  #endif\n  #ifdef UVTRANSFORM \n  uniform mat4 u_UVMatrix;\n  #endif\n#endif\n\n#ifdef AMBIENTMAP\nattribute vec2 a_Texcoord1;\nvarying vec2 v_Texcoord1;\n#endif\n\n#ifdef COLOR\nattribute vec4 a_Color;\nvarying vec4 v_Color;\n#endif\n\n#ifdef BONE\nattribute vec4 a_BoneIndices;\nattribute vec4 a_BoneWeights;\nconst int c_MaxBoneCount = 24;\nuniform mat4 u_Bones[c_MaxBoneCount];\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP\nattribute vec3 a_Normal;\nvarying vec3 v_Normal;\n#endif\n\n#ifdef (DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP)&&NORMALMAP\nattribute vec3 a_Tangent0;\nvarying vec3 v_Tangent0;\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP\nuniform mat4 u_WorldMat;\nvarying vec3 v_PositionWorld;\n#endif\n\n\nvoid main()\n{\n #ifdef BONE\n mat4 skinTransform=mat4(0.0);\n skinTransform += u_Bones[int(a_BoneIndices.x)] * a_BoneWeights.x;\n skinTransform += u_Bones[int(a_BoneIndices.y)] * a_BoneWeights.y;\n skinTransform += u_Bones[int(a_BoneIndices.z)] * a_BoneWeights.z;\n skinTransform += u_Bones[int(a_BoneIndices.w)] * a_BoneWeights.w;\n vec4 position=skinTransform*a_Position;\n   #ifdef VR\n   gl_Position = DistortFishEye(u_MvpMatrix * position);\n   #else\n   gl_Position = u_MvpMatrix * position;\n   #endif\n #else\n   #ifdef VR\n   gl_Position = DistortFishEye(u_MvpMatrix * a_Position);\n   #else\n   gl_Position = u_MvpMatrix * a_Position;\n   #endif\n #endif\n \n\n #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP\n mat3 worldMat;\n   #ifdef BONE\n   worldMat=mat3(u_WorldMat*skinTransform);\n   #else\n   worldMat=mat3(u_WorldMat);\n   #endif  \n v_Normal=worldMat*a_Normal;\n   #ifdef (DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&NORMALMAP\n   v_Tangent0=worldMat*a_Tangent0;\n   #endif\n #endif\n \n #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG\n   #ifdef BONE\n   v_PositionWorld=(u_WorldMat*position).xyz;\n   #else\n   v_PositionWorld=(u_WorldMat*a_Position).xyz;\n   #endif\n #endif\n \n#ifdef DIFFUSEMAP||((DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&(COLOR&&SPECULARMAP||NORMALMAP))\n  #ifdef MIXUV\n  v_Texcoord0=mix(a_Texcoord0,a_TexcoordNext0,u_UVAge);\n  #else\n  v_Texcoord0=a_Texcoord0;\n  #endif\n  #ifdef UVTRANSFORM\n  v_Texcoord0=(u_UVMatrix*vec4(v_Texcoord0,0.0,1.0)).xy;\n  #endif\n#endif\n\n#ifdef AMBIENTMAP\nv_Texcoord1=a_Texcoord1;\n#endif\n\n  \n#ifdef COLOR\nv_Color=a_Color;\n#endif\n}"/*__INCLUDESTR__E:/trank/libs/LayaAir/publish/LayaAirPublish/src/d3/src/laya/d3/shader/files/PixelSimpleTextureSkinnedMesh.vs*/;
			ps="#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\n#include?DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT \"LightHelper.glsl\";\n\nuniform vec4 u_Albedo;\n\n#ifdef ALPHATEST\nuniform float u_AlphaTestValue;\n#endif\n\n#ifdef DIFFUSEMAP\nuniform sampler2D u_DiffuseTexture;\n#endif\n\n#ifdef REFLECTMAP\nuniform samplerCube u_ReflectTexture;\nuniform vec3 u_MaterialReflect;\n#endif\n\n#ifdef DIFFUSEMAP||((DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&(COLOR&&SPECULARMAP||NORMALMAP))\nvarying vec2 v_Texcoord0;\n#endif\n\n#ifdef AMBIENTMAP\nvarying vec2 v_Texcoord1;\nuniform sampler2D u_AmbientTexture;\n#endif\n\n#ifdef COLOR\nvarying vec4 v_Color;\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT\nuniform vec3 u_MaterialDiffuse;\nuniform vec4 u_MaterialSpecular;\n  #ifdef (DIFFUSEMAP||COLOR)&&SPECULARMAP \n  uniform sampler2D u_SpecularTexture;\n  #endif\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||AMBIENTMAP\nuniform vec3 u_MaterialAmbient;\n#endif\n\n#ifdef FOG\nuniform float u_FogStart;\nuniform float u_FogRange;\nuniform vec3 u_FogColor;\n#endif\n\n#ifdef MIXUV\nuniform float  u_UVAniAge;\n#endif\n\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP\nvarying vec3 v_Normal;\n#endif\n\n#ifdef (DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&NORMALMAP\nuniform sampler2D u_NormalTexture;\nvarying vec3 v_Tangent0;\n#endif\n\n#ifdef DIRECTIONLIGHT\nuniform DirectionLight u_DirectionLight;\n#endif\n\n#ifdef POINTLIGHT\nuniform PointLight u_PointLight;\n#endif\n\n#ifdef SPOTLIGHT\nuniform SpotLight u_SpotLight;\n#endif\n\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP\nuniform vec3 u_CameraPos;\nvarying vec3 v_PositionWorld;\n#endif\n\n\nvoid main()\n{\n  #ifdef DIFFUSEMAP&&!COLOR\n  gl_FragColor=texture2D(u_DiffuseTexture, v_Texcoord0);\n  #endif \n  \n  #ifdef COLOR&&!DIFFUSEMAP\n  gl_FragColor=v_Color;\n  #endif \n  \n  #ifdef DIFFUSEMAP&&COLOR\n  vec4 texColor=texture2D(u_DiffuseTexture, v_Texcoord0);\n  gl_FragColor=texColor*v_Color;\n  #endif\n  \n  #ifdef !DIFFUSEMAP&&!COLOR\n  gl_FragColor=vec4(1.0,1.0,1.0,1.0);\n  #endif \n  \n  #ifdef AMBIENTMAP\n  gl_FragColor.rgb=gl_FragColor.rgb*(u_MaterialAmbient+texture2D(u_AmbientTexture, v_Texcoord1).rgb);\n  #endif \n  \n  gl_FragColor=gl_FragColor*u_Albedo;\n  \n  #ifdef ALPHATEST\n  if(gl_FragColor.a-u_AlphaTestValue<0.0)\n    discard;\n  #endif\n  \n  \n  #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP\n  vec3 normal;\n    #ifdef (DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&NORMALMAP\n    vec3 normalMapSample = texture2D(u_NormalTexture, v_Texcoord0).rgb;\n	normal = normalize(NormalSampleToWorldSpace(normalMapSample, v_Normal, v_Tangent0));\n	#else\n	normal = normalize(v_Normal);\n    #endif\n  #endif\n	\n  #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT\n  vec3 diffuse = vec3(0.0);\n  vec3 ambient = vec3(0.0);\n  vec3 specular= vec3(0.0);\n  vec3 dif, amb, spe;\n  #endif\n  \n  #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP\n  vec3 toEye;\n    #ifdef FOG\n	toEye=u_CameraPos-v_PositionWorld;\n    float toEyeLength=length(toEye);\n    toEye/=toEyeLength;\n    #else\n	toEye=normalize(u_CameraPos-v_PositionWorld);\n    #endif\n  #endif\n	\n  #ifdef DIRECTIONLIGHT\n  computeDirectionLight(u_MaterialDiffuse,u_MaterialAmbient,u_MaterialSpecular,u_DirectionLight,normal,toEye, dif, amb, spe);\n  diffuse+=dif;\n  ambient+=amb;\n  specular+=spe;\n  #endif\n \n  #ifdef POINTLIGHT\n  computePointLight(u_MaterialDiffuse,u_MaterialAmbient,u_MaterialSpecular,u_PointLight,v_PositionWorld,normal,toEye, dif, amb, spe);\n  diffuse+=dif;\n  ambient+=amb;\n  specular+=spe;\n  #endif\n\n  #ifdef SPOTLIGHT\n  ComputeSpotLight(u_MaterialDiffuse,u_MaterialAmbient,u_MaterialSpecular,u_SpotLight,v_PositionWorld,normal,toEye, dif, amb, spe);\n  diffuse+=dif;\n  ambient+=amb;\n  specular+=spe;\n  #endif\n  \n\n  \n  \n  \n  #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT\n    #ifdef (DIFFUSEMAP||COLOR)&&SPECULARMAP\n    specular =specular*texture2D(u_SpecularTexture, v_Texcoord0).rgb;\n    #endif\n  gl_FragColor =vec4( gl_FragColor.rgb*(ambient + diffuse) + specular,gl_FragColor.a);\n  #endif\n  \n  #ifdef REFLECTMAP\n  vec3 incident = -toEye;\n  vec3 reflectionVector = reflect(incident,normal);\n  vec3 reflectionColor  = textureCube(u_ReflectTexture,reflectionVector).rgb;\n  gl_FragColor.rgb += u_MaterialReflect*reflectionColor;\n  #endif\n  \n  #ifdef FOG\n  float lerpFact=clamp((toEyeLength-u_FogStart)/u_FogRange,0.0,1.0);\n  gl_FragColor.rgb=mix(gl_FragColor.rgb,u_FogColor,lerpFact);\n  #endif\n}\n\n"/*__INCLUDESTR__E:/trank/libs/LayaAir/publish/LayaAirPublish/src/d3/src/laya/d3/shader/files/PixelSimpleTextureSkinnedMesh.ps*/;
			Shader.preCompile(SIMPLE,vs,ps,shaderNameMap);
			var SIMPLEVEXTEX=Shader.nameKey.add("SIMPLEVEXTEX");
			vs="#include?DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT \"LightHelper.glsl\";\n\nattribute vec4 a_Position;\nuniform mat4 u_MvpMatrix;\n\n#include?VR \"VRHelper.glsl\";\n\n\n\n#ifdef DIFFUSEMAP||((DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&COLOR&&SPECULARMAP)\nattribute vec2 a_Texcoord0;\nvarying vec2 v_Texcoord0;\n  #ifdef MIXUV\n  attribute vec2 a_TexcoordNext0;\n  uniform float  u_UVAge;\n  #endif\n  #ifdef UVTRANSFORM\n  uniform mat4 u_UVMatrix;\n  #endif\n#endif\n\n#ifdef AMBIENTMAP\nattribute vec2 a_Texcoord1;\nvarying vec2 v_Texcoord1;\n#endif\n\n\n#ifdef COLOR\nattribute vec4 a_Color;\nvarying vec4 v_Color;\n#endif\n\n#ifdef BONE\nattribute vec4 a_BoneIndices;\nattribute vec4 a_BoneWeights;\nconst int c_MaxBoneCount = 24;\nuniform mat4 u_Bones[c_MaxBoneCount];\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP\nattribute vec3 a_Normal;\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP\nuniform mat4 u_WorldMat;\nuniform vec3 u_CameraPos;\n#endif\n\n#ifdef DIRECTIONLIGHT\nuniform DirectionLight u_DirectionLight;\n#endif\n\n#ifdef POINTLIGHT\nuniform PointLight u_PointLight;\n#endif\n\n#ifdef SPOTLIGHT\nuniform SpotLight u_SpotLight;\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT\nuniform vec3 u_MaterialDiffuse;\nuniform vec4 u_MaterialSpecular;\n\nvarying vec3 v_Diffuse;\nvarying vec3 v_Ambient;\nvarying vec3 v_Specular;\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||AMBIENTMAP\nuniform vec3 u_MaterialAmbient;\n#endif\n\n#ifdef FOG\nvarying float v_ToEyeLength;\n#endif\n\n#ifdef REFLECTMAP\nvarying vec3 v_ToEye;\nvarying vec3 v_Normal;\n#endif\n\n\nvoid main()\n{\n #ifdef BONE\n mat4 skinTransform=mat4(0.0);\n skinTransform += u_Bones[int(a_BoneIndices.x)] * a_BoneWeights.x;\n skinTransform += u_Bones[int(a_BoneIndices.y)] * a_BoneWeights.y;\n skinTransform += u_Bones[int(a_BoneIndices.z)] * a_BoneWeights.z;\n skinTransform += u_Bones[int(a_BoneIndices.w)] * a_BoneWeights.w;\n vec4 position=skinTransform*a_Position;\n   #ifdef VR\n   gl_Position = DistortFishEye(u_MvpMatrix * position);\n   #else\n   gl_Position = u_MvpMatrix * position;\n   #endif\n #else\n   #ifdef VR\n   gl_Position = DistortFishEye(u_MvpMatrix * a_Position);\n   #else\n   gl_Position = u_MvpMatrix * a_Position;\n   #endif\n #endif\n \n \n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP\n  #ifdef BONE\n  vec3 normal=normalize( mat3(u_WorldMat*skinTransform)*a_Normal);\n  #else\n  vec3 normal=normalize( mat3(u_WorldMat)*a_Normal);\n  #endif\n \n  #ifdef REFLECTMAP\n  v_Normal=normal;\n  #endif\n#endif\n \n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT\n  v_Diffuse=vec3(0.0);\n  v_Ambient=vec3(0.0);\n  v_Specular=vec3(0.0);\n  vec3 dif, amb, spe;\n#endif\n\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP\n  #ifdef BONE\n  vec3 positionWorld=(u_WorldMat*position).xyz;\n  #else\n  vec3 positionWorld=(u_WorldMat*a_Position).xyz;\n  #endif\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP\nvec3 toEye;\n  #ifdef FOG\n  toEye=u_CameraPos-positionWorld;\n  v_ToEyeLength=length(toEye);\n  toEye/=v_ToEyeLength;\n  #else\n  toEye=normalize(u_CameraPos-positionWorld);\n  #endif\n \n  #ifdef REFLECTMAP\n  v_ToEye=toEye;\n  #endif\n#endif\n \n#ifdef DIRECTIONLIGHT\ncomputeDirectionLight(u_MaterialDiffuse,u_MaterialAmbient,u_MaterialSpecular,u_DirectionLight,normal,toEye, dif, amb, spe);\nv_Diffuse+=dif;\nv_Ambient+=amb;\nv_Specular+=spe;\n#endif\n \n#ifdef POINTLIGHT\ncomputePointLight(u_MaterialDiffuse,u_MaterialAmbient,u_MaterialSpecular,u_PointLight,positionWorld,normal,toEye, dif, amb, spe);\nv_Diffuse+=dif;\nv_Ambient+=amb;\nv_Specular+=spe;\n#endif\n\n#ifdef SPOTLIGHT\nComputeSpotLight(u_MaterialDiffuse,u_MaterialAmbient,u_MaterialSpecular,u_SpotLight,positionWorld,normal,toEye, dif, amb, spe);\nv_Diffuse+=dif;\nv_Ambient+=amb;\nv_Specular+=spe;\n#endif\n  \n#ifdef DIFFUSEMAP||((DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&COLOR&&SPECULARMAP)\n  #ifdef MIXUV\n  v_Texcoord0=mix(a_Texcoord0,a_TexcoordNext0,u_UVAge);\n  #else\n  v_Texcoord0=a_Texcoord0;\n  #endif\n  #ifdef UVTRANSFORM\n  v_Texcoord0=(u_UVMatrix*vec4(v_Texcoord0,0.0,1.0)).xy;\n  #endif\n#endif\n\n#ifdef AMBIENTMAP\nv_Texcoord1=a_Texcoord1;\n#endif\n  \n#ifdef COLOR\nv_Color=a_Color;\n#endif\n}"/*__INCLUDESTR__E:/trank/libs/LayaAir/publish/LayaAirPublish/src/d3/src/laya/d3/shader/files/VertexSimpleTextureSkinnedMesh.vs*/;
			ps="#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\nuniform vec4 u_Albedo;\n\n#ifdef ALPHATEST\nuniform float u_AlphaTestValue;\n#endif\n\n#ifdef DIFFUSEMAP\nuniform sampler2D u_DiffuseTexture;\n#endif\n\n#ifdef REFLECTMAP\nuniform samplerCube u_ReflectTexture;\nuniform vec3 u_MaterialReflect;\n#endif\n\n\n#ifdef DIFFUSEMAP||((DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&COLOR&&SPECULARMAP)\nvarying vec2 v_Texcoord0;\n#endif\n\n#ifdef AMBIENTMAP\nvarying vec2 v_Texcoord1;\nuniform sampler2D u_AmbientTexture;\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||AMBIENTMAP\nuniform vec3 u_MaterialAmbient;\n#endif\n\n#ifdef COLOR\nvarying vec4 v_Color;\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT\nvarying vec3 v_Diffuse;\nvarying vec3 v_Ambient;\nvarying vec3 v_Specular;\n  #ifdef (DIFFUSEMAP||COLOR)&&SPECULARMAP\n  uniform sampler2D u_SpecularTexture;\n  #endif\n#endif\n\n#ifdef FOG\nuniform float u_FogStart;\nuniform float u_FogRange;\nuniform vec3 u_FogColor;\nvarying float v_ToEyeLength;\n#endif\n\n#ifdef MIXUV\nuniform float  u_UVAniAge;\n#endif\n\n#ifdef REFLECTMAP\nvarying vec3 v_Normal;\nvarying vec3 v_ToEye;\n#endif\n\n\nvoid main()\n{\n #ifdef DIFFUSEMAP&&!COLOR\n gl_FragColor=texture2D(u_DiffuseTexture, v_Texcoord0);\n #endif \n \n #ifdef COLOR&&!DIFFUSEMAP\n gl_FragColor=v_Color;\n #endif \n \n #ifdef DIFFUSEMAP&&COLOR\n vec4 texColor=texture2D(u_DiffuseTexture, v_Texcoord0);\n gl_FragColor=texColor*v_Color;\n #endif\n \n #ifdef !DIFFUSEMAP&&!COLOR\n gl_FragColor=vec4(1.0,1.0,1.0,1.0);\n #endif \n \n #ifdef AMBIENTMAP\n gl_FragColor.rgb=gl_FragColor.rgb*(u_MaterialAmbient+texture2D(u_AmbientTexture, v_Texcoord1).rgb);\n #endif \n \n gl_FragColor=gl_FragColor*u_Albedo;\n  \n #ifdef ALPHATEST\n   if(gl_FragColor.a-u_AlphaTestValue<0.0)\n    discard;\n #endif\n \n \n #ifdef REFLECTMAP\n vec3 normal=normalize(v_Normal);\n #endif 	\n\n  \n #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT\n   #ifdef (DIFFUSEMAP||COLOR)&&SPECULARMAP\n   vec3 specular =v_Specular*texture2D(u_SpecularTexture,v_Texcoord0).rgb;\n   gl_FragColor =vec4( gl_FragColor.rgb*(v_Ambient + v_Diffuse)+specular,gl_FragColor.a);\n   #else\n   gl_FragColor =vec4( gl_FragColor.rgb*(v_Ambient + v_Diffuse)+v_Specular,gl_FragColor.a);\n   #endif\n #endif\n \n #ifdef REFLECTMAP\n vec3 incident = -v_ToEye;\n vec3 reflectionVector = reflect(incident,v_Normal);\n vec3 reflectionColor  = textureCube(u_ReflectTexture,reflectionVector).rgb;\n gl_FragColor.rgb += u_MaterialReflect*reflectionColor;\n #endif\n \n #ifdef FOG\n float lerpFact=clamp((v_ToEyeLength-u_FogStart)/u_FogRange,0.0,1.0);\n gl_FragColor.rgb=mix(gl_FragColor.rgb,u_FogColor,lerpFact);\n #endif\n}\n\n"/*__INCLUDESTR__E:/trank/libs/LayaAir/publish/LayaAirPublish/src/d3/src/laya/d3/shader/files/VertexSimpleTextureSkinnedMesh.ps*/;
			Shader.preCompile(SIMPLEVEXTEX,vs,ps,shaderNameMap);
			shaderNameMap={
				'a_Position':/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION",
				'a_Texcoord':/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV",
				'u_FogStart':/*laya.d3.core.scene.BaseScene.FOGSTART*/"FOGSTART",
				'u_FogRange':/*laya.d3.core.scene.BaseScene.FOGRANGE*/"FOGRANGE",
				'u_FogColor':/*laya.d3.core.scene.BaseScene.FOGCOLOR*/"FOGCOLOR",
				'u_CameraPos':/*laya.d3.core.scene.BaseScene.CAMERAPOS*/"CAMERAPOS",
				'u_WorldMat':/*laya.d3.core.material.StandardMaterial.WORLDMATRIX*/"MATRIX1",
				'u_BlendTexture':/*laya.d3.core.material.StandardMaterial.DIFFUSETEXTURE*/"DIFFUSETEXTURE",
				'u_LayerTexture0':/*laya.d3.core.material.StandardMaterial.NORMALTEXTURE*/"NORMALTEXTURE",
				'u_LayerTexture1':/*laya.d3.core.material.StandardMaterial.SPECULARTEXTURE*/"SPECULARTEXTURE",
				'u_LayerTexture2':/*laya.d3.core.material.StandardMaterial.EMISSIVETEXTURE*/"EMISSIVETEXTURE",
				'u_LayerTexture3':/*laya.d3.core.material.StandardMaterial.AMBIENTTEXTURE*/"AMBIENTTEXTURE",
				'u_MvpMatrix':/*laya.d3.core.material.StandardMaterial.MVPMATRIX*/"MVPMATRIX",
				'u_Albedo':/*laya.d3.core.material.StandardMaterial.ALBEDO*/"ALBEDO",
				'u_Ambient':/*laya.d3.core.material.StandardMaterial.MATERIALAMBIENT*/"MATERIALAMBIENT",
				'u_UVMatrix':/*laya.d3.core.material.StandardMaterial.UVMATRIX*/"MATRIX2"};
			var TERRAIN=Shader.nameKey.add("TERRAIN");
			vs="#include?VR \"VRHelper.glsl\";\nattribute vec4 a_Position;\nuniform mat4 u_MvpMatrix;\nuniform mat4 u_UVMatrix;\n\n#ifdef DIFFUSEMAP&&NORMALMAP&&SPECULARMAP&&EMISSIVEMAP&&AMBIENTMAP\nattribute vec2 a_Texcoord;\nvarying vec2 v_Texcoord;\nvarying vec2 v_TiledTexcoord;\n#endif\n\n#ifdef FOG\nuniform mat4 u_WorldMat;\nvarying vec3 v_PositionWorld;\n#endif\n\n\nvoid main()\n{\n #ifdef VR\n gl_Position = DistortFishEye(u_MvpMatrix * a_Position);\n #else\n gl_Position = u_MvpMatrix * a_Position;\n #endif\n \n #ifdef FOG\n v_PositionWorld=(u_WorldMat*a_Position).xyz;\n #endif\n \n #ifdef DIFFUSEMAP&&NORMALMAP&&SPECULARMAP&&EMISSIVEMAP&&AMBIENTMAP\n v_Texcoord=a_Texcoord;\n v_TiledTexcoord=(u_UVMatrix*vec4(a_Texcoord,0.0,1.0)).xy;\n #endif\n}"/*__INCLUDESTR__E:/trank/libs/LayaAir/publish/LayaAirPublish/src/d3/src/laya/d3/shader/files/modelTerrain.vs*/;
			ps="#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\nuniform vec4 u_Albedo;\nuniform vec3 u_Ambient;\n\n#ifdef FOG\nuniform vec3 u_CameraPos;\nvarying vec3 v_PositionWorld;\n\nuniform float u_FogStart;\nuniform float u_FogRange;\nuniform vec3 u_FogColor;\n#endif\n\n#ifdef DIFFUSEMAP&&NORMALMAP&&SPECULARMAP&&EMISSIVEMAP&&AMBIENTMAP\n  varying vec2 v_Texcoord;\n  varying vec2 v_TiledTexcoord;\n  uniform sampler2D u_BlendTexture;\n  uniform sampler2D u_LayerTexture0;\n  uniform sampler2D u_LayerTexture1;\n  uniform sampler2D u_LayerTexture2;\n  uniform sampler2D u_LayerTexture3;\n#endif\n\nvoid main()\n{	\n  #ifdef DIFFUSEMAP&&NORMALMAP&&SPECULARMAP&&EMISSIVEMAP&&AMBIENTMAP\n  vec4 blend=texture2D(u_BlendTexture, v_Texcoord);\n  vec4 c0=texture2D(u_LayerTexture0, v_TiledTexcoord);\n  vec4 c1=texture2D(u_LayerTexture1, v_TiledTexcoord);\n  vec4 c2=texture2D(u_LayerTexture2, v_TiledTexcoord);\n  vec4 c3=texture2D(u_LayerTexture3, v_TiledTexcoord);\n  vec4 texColor = c0;\n  texColor = mix(texColor, c1, blend.r);\n  texColor = mix(texColor, c2, blend.g);\n  texColor = mix(texColor, c3, blend.b);\n  gl_FragColor=vec4(texColor.rgb*u_Ambient.rgb*blend.a,1.0);\n  gl_FragColor=gl_FragColor*u_Albedo;\n  #endif \n  \n  #ifdef FOG\n  vec3 toEye=u_CameraPos-v_PositionWorld;\n  float toEyeLength=length(toEye);\n  \n  float lerpFact=clamp((toEyeLength-u_FogStart)/u_FogRange,0.0,1.0);\n  gl_FragColor.rgb=mix(gl_FragColor.rgb,u_FogColor,lerpFact);\n  #endif\n}\n\n"/*__INCLUDESTR__E:/trank/libs/LayaAir/publish/LayaAirPublish/src/d3/src/laya/d3/shader/files/modelTerrain.ps*/;
			Shader.preCompile(TERRAIN,vs,ps,shaderNameMap);
			shaderNameMap={
				'a_CornerTextureCoordinate':/*laya.d3.graphics.VertexElementUsage.CORNERTEXTURECOORDINATE0*/"CORNERTEXTURECOORDINATE",
				'a_Position':/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION",
				'a_Velocity':/*laya.d3.graphics.VertexElementUsage.VELOCITY0*/"VELOCITY",
				'a_StartColor':/*laya.d3.graphics.VertexElementUsage.STARTCOLOR0*/"STARTCOLOR",
				'a_EndColor':/*laya.d3.graphics.VertexElementUsage.ENDCOLOR0*/"ENDCOLOR",
				'a_SizeRotation':/*laya.d3.graphics.VertexElementUsage.SIZEROTATION0*/"SIZEROTATION",
				'a_Radius':/*laya.d3.graphics.VertexElementUsage.RADIUS0*/"RADIUS",
				'a_Radian':/*laya.d3.graphics.VertexElementUsage.RADIAN0*/"RADIAN",
				'a_AgeAddScale':/*laya.d3.graphics.VertexElementUsage.STARTLIFETIME*/"STARTLIFETIME",
				'a_Time':/*laya.d3.graphics.VertexElementUsage.TIME0*/"TIME",
				'u_WorldMat':/*laya.d3.core.material.ParticleMaterial.WORLDMATRIX*/"MVPMATRIX",
				'u_View':/*laya.d3.core.material.ParticleMaterial.VIEWMATRIX*/"MATRIX1",
				'u_Projection':/*laya.d3.core.material.ParticleMaterial.PROJECTIONMATRIX*/"MATRIX2",
				'u_ViewportScale':/*laya.d3.core.material.ParticleMaterial.VIEWPORTSCALE*/"VIEWPORTSCALE",
				'u_CurrentTime':/*laya.d3.core.material.ParticleMaterial.CURRENTTIME*/"CURRENTTIME",
				'u_Duration':/*laya.d3.core.material.ParticleMaterial.DURATION*/"DURATION",
				'u_Gravity':/*laya.d3.core.material.ParticleMaterial.GRAVITY*/"GRAVITY",
				'u_EndVelocity':/*laya.d3.core.material.ParticleMaterial.ENDVELOCITY*/"ENDVELOCITY",
				'u_texture':/*laya.d3.core.material.ParticleMaterial.DIFFUSETEXTURE*/"DIFFUSETEXTURE"};
			var PARTICLE=Shader.nameKey.add("PARTICLE");
			Shader.preCompile(PARTICLE,ParticleShader.vs,ParticleShader.ps,shaderNameMap);
			shaderNameMap={
				'a_CornerTextureCoordinate':/*laya.d3.graphics.VertexElementUsage.CORNERTEXTURECOORDINATE0*/"CORNERTEXTURECOORDINATE",
				'a_Position':/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION",
				'a_Direction':/*laya.d3.graphics.VertexElementUsage.DIRECTION*/"DIRECTION",
				'a_StartColor':/*laya.d3.graphics.VertexElementUsage.STARTCOLOR0*/"STARTCOLOR",
				'a_EndColor':/*laya.d3.graphics.VertexElementUsage.ENDCOLOR0*/"ENDCOLOR",
				'a_StartSize':/*laya.d3.graphics.VertexElementUsage.STARTSIZE*/"STARTSIZE",
				'a_StartRotation0':/*laya.d3.graphics.VertexElementUsage.STARTROTATION0*/"STARTROTATION0",
				'a_StartRotation1':/*laya.d3.graphics.VertexElementUsage.STARTROTATION1*/"STARTROTATION1",
				'a_StartRotation2':/*laya.d3.graphics.VertexElementUsage.STARTROTATION2*/"STARTROTATION2",
				'a_StartLifeTime':/*laya.d3.graphics.VertexElementUsage.STARTLIFETIME*/"STARTLIFETIME",
				'a_StartSpeed':/*laya.d3.graphics.VertexElementUsage.STARTSPEED*/"STARTSPEED",
				'a_Time':/*laya.d3.graphics.VertexElementUsage.TIME0*/"TIME",
				'a_Random0':/*laya.d3.graphics.VertexElementUsage.RANDOM0*/"RANDOM0",
				'a_Random1':/*laya.d3.graphics.VertexElementUsage.RANDOM1*/"RANDOM1",
				'u_WorldPosition':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.WORLDPOSITION*/"WORLDPOSITION",
				'u_WorldRotationMat':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.WORLDROTATIONMATRIX*/"WORLDROTATIONMATRIX",
				'u_ThreeDStartRotation':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.THREEDSTARTROTATION*/"THREEDSTARTROTATION",
				'u_ScalingMode':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.SCALINGMODE*/"SCALINGMODE",
				'u_PositionScale':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.POSITIONSCALE*/"POSITIONSCALE",
				'u_SizeScale':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.SIZESCALE*/"SIZESCALE",
				'u_View':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.VIEWMATRIX*/"MATRIX1",
				'u_Projection':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.PROJECTIONMATRIX*/"MATRIX2",
				'u_CurrentTime':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.CURRENTTIME*/"CURRENTTIME",
				'u_Gravity':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.GRAVITY*/"GRAVITY",
				'u_texture':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.DIFFUSETEXTURE*/"DIFFUSETEXTURE",
				'u_CameraDirection':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.CAMERADIRECTION*/"CAMERADIRECTION",
				'u_CameraUp':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.CAMERAUP*/"CAMERAUP",
				'u_StretchedBillboardLengthScale':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.STRETCHEDBILLBOARDLENGTHSCALE*/"STRETCHEDBILLBOARDLENGTHSCALE",
				'u_StretchedBillboardSpeedScale':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.STRETCHEDBILLBOARDSPEEDSCALE*/"STRETCHEDBILLBOARDSPEEDSCALE",
				'u_ColorOverLifeGradientAlphas':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.COLOROVERLIFEGRADIENTALPHAS*/"COLOROVERLIFEGRADIENTALPHAS",
				'u_ColorOverLifeGradientColors':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.COLOROVERLIFEGRADIENTCOLORS*/"COLOROVERLIFEGRADIENTCOLORS",
				'u_MaxColorOverLifeGradientAlphas':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.MAXCOLOROVERLIFEGRADIENTALPHAS*/"MAXCOLOROVERLIFEGRADIENTALPHAS",
				'u_MaxColorOverLifeGradientColors':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.MAXCOLOROVERLIFEGRADIENTCOLORS*/"MAXCOLOROVERLIFEGRADIENTCOLORS",
				'u_VOLType':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.VOLTYPE*/"VOLTYPE",
				'u_VOLVelocityConst':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.VOLVELOCITYCONST*/"VOLVELOCITYCONST",
				'u_VOLVelocityGradientX':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.VOLVELOCITYGRADIENTX*/"VOLVELOCITYGRADIENTX",
				'u_VOLVelocityGradientY':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.VOLVELOCITYGRADIENTY*/"VOLVELOCITYGRADIENTY",
				'u_VOLVelocityGradientZ':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.VOLVELOCITYGRADIENTZ*/"VOLVELOCITYGRADIENTZ",
				'u_VOLVelocityConstMax':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.VOLVELOCITYCONSTMAX*/"VOLVELOCITYCONSTMAX",
				'u_VOLVelocityGradientMaxX':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.VOLVELOCITYGRADIENTXMAX*/"VOLVELOCITYGRADIENTXMAX",
				'u_VOLVelocityGradientMaxY':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.VOLVELOCITYGRADIENTYMAX*/"VOLVELOCITYGRADIENTYMAX",
				'u_VOLVelocityGradientMaxZ':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.VOLVELOCITYGRADIENTZMAX*/"VOLVELOCITYGRADIENTZMAX",
				'u_VOLSpaceType':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.VOLSPACETYPE*/"VOLSPACETYPE",
				'u_SOLType':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.SOLTYPE*/"SOLTYPE",
				'u_SOLSeprarate':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.SOLSEPRARATE*/"SOLSEPRARATE",
				'u_SOLSizeGradient':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.SOLSIZEGRADIENT*/"SOLSIZEGRADIENT",
				'u_SOLSizeGradientX':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.SOLSIZEGRADIENTX*/"SOLSIZEGRADIENTX",
				'u_SOLSizeGradientY':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.SOLSIZEGRADIENTY*/"SOLSIZEGRADIENTY",
				'u_SOLSizeGradientZ':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.SOLSizeGradientZ*/"SOLSizeGradientZ",
				'u_SOLSizeGradientMax':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.SOLSizeGradientMax*/"SOLSizeGradientMax",
				'u_SOLSizeGradientMaxX':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.SOLSIZEGRADIENTXMAX*/"SOLSIZEGRADIENTXMAX",
				'u_SOLSizeGradientMaxY':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.SOLSIZEGRADIENTYMAX*/"SOLSIZEGRADIENTYMAX",
				'u_SOLSizeGradientMaxZ':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.SOLSizeGradientZMAX*/"SOLSizeGradientZMAX",
				'u_ROLType':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.ROLTYPE*/"ROLTYPE",
				'u_ROLSeprarate':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.ROLSEPRARATE*/"ROLSEPRARATE",
				'u_ROLAngularVelocityConst':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.ROLANGULARVELOCITYCONST*/"ROLANGULARVELOCITYCONST",
				'u_ROLAngularVelocityConstSeprarate':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.ROLANGULARVELOCITYCONSTSEPRARATE*/"ROLANGULARVELOCITYCONSTSEPRARATE",
				'u_ROLAngularVelocityGradient':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENT*/"ROLANGULARVELOCITYGRADIENT",
				'u_ROLAngularVelocityGradientX':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENTX*/"ROLANGULARVELOCITYGRADIENTX",
				'u_ROLAngularVelocityGradientY':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENTY*/"ROLANGULARVELOCITYGRADIENTY",
				'u_ROLAngularVelocityGradientZ':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENTZ*/"ROLANGULARVELOCITYGRADIENTZ",
				'u_ROLAngularVelocityConstMax':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.ROLANGULARVELOCITYCONSTMAX*/"ROLANGULARVELOCITYCONSTMAX",
				'u_ROLAngularVelocityConstMaxSeprarate':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.ROLANGULARVELOCITYCONSTMAXSEPRARATE*/"ROLANGULARVELOCITYCONSTMAXSEPRARATE",
				'u_ROLAngularVelocityGradientMax':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENTMAX*/"ROLANGULARVELOCITYGRADIENTMAX",
				'u_ROLAngularVelocityGradientMaxX':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENTXMAX*/"ROLANGULARVELOCITYGRADIENTXMAX",
				'u_ROLAngularVelocityGradientMaxY':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENTYMAX*/"ROLANGULARVELOCITYGRADIENTYMAX",
				'u_ROLAngularVelocityGradientMaxZ':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENTZMAX*/"ROLANGULARVELOCITYGRADIENTZMAX",
				'u_TSAType':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.TEXTURESHEETANIMATIONTYPE*/"TEXTURESHEETANIMATIONTYPE",
				'u_TSACycles':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.TEXTURESHEETANIMATIONCYCLES*/"TEXTURESHEETANIMATIONCYCLES",
				'u_TSASubUVLength':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.TEXTURESHEETANIMATIONSUBUVLENGTH*/"TEXTURESHEETANIMATIONSUBUVLENGTH",
				'u_TSAGradientUVs':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.TEXTURESHEETANIMATIONGRADIENTUVS*/"TEXTURESHEETANIMATIONGRADIENTUVS",
				'u_TSAMaxGradientUVs':/*laya.d3.core.particleShuriKen.ShurikenParticleMaterial.TEXTURESHEETANIMATIONGRADIENTMAXUVS*/"TEXTURESHEETANIMATIONGRADIENTMAXUVS"};
			var PARTICLESHURIKEN=Shader.nameKey.add("PARTICLESHURIKEN");
			vs="attribute vec4 a_CornerTextureCoordinate;\nattribute vec3 a_Position;\nattribute vec3 a_Direction;\nattribute vec4 a_StartColor;\nattribute vec3 a_StartSize;\nattribute vec3 a_StartRotation0;\nattribute vec3 a_StartRotation1;\nattribute vec3 a_StartRotation2;\nattribute float a_StartLifeTime;\nattribute float a_Time;\nattribute float a_StartSpeed;\n#ifdef VELOCITYOVERLIFETIME||COLOROVERLIFETIME||RANDOMCOLOROVERLIFETIME||SIZEOVERLIFETIME||ROTATIONOVERLIFETIME\n  attribute vec4 a_Random0;\n#endif\n#ifdef TEXTURESHEETANIMATION\n  attribute vec4 a_Random1;\n#endif\n\nvarying float v_Discard;\nvarying vec4 v_Color;\nvarying vec2 v_TextureCoordinate;\n\nuniform float u_CurrentTime;\nuniform vec3 u_Gravity;\n\nuniform vec3 u_WorldPosition;\nuniform mat4 u_WorldRotationMat;\nuniform bool u_ThreeDStartRotation;\nuniform int u_ScalingMode;\nuniform vec3 u_PositionScale;\nuniform vec3 u_SizeScale;\nuniform mat4 u_View;\nuniform mat4 u_Projection;\n\nuniform vec3 u_CameraDirection;//TODO:只有几种广告牌模式需要用\nuniform vec3 u_CameraUp;\n\nuniform  float u_StretchedBillboardLengthScale;\nuniform  float u_StretchedBillboardSpeedScale;\n\n#ifdef VELOCITYOVERLIFETIME\n  uniform  int  u_VOLType;\n  uniform  vec3 u_VOLVelocityConst;\n  uniform  vec2 u_VOLVelocityGradientX[4];//x为key,y为速度\n  uniform  vec2 u_VOLVelocityGradientY[4];//x为key,y为速度\n  uniform  vec2 u_VOLVelocityGradientZ[4];//x为key,y为速度\n  uniform  vec3 u_VOLVelocityConstMax;\n  uniform  vec2 u_VOLVelocityGradientMaxX[4];//x为key,y为速度\n  uniform  vec2 u_VOLVelocityGradientMaxY[4];//x为key,y为速度\n  uniform  vec2 u_VOLVelocityGradientMaxZ[4];//x为key,y为速度\n  uniform  int  u_VOLSpaceType;\n#endif\n\n#ifdef COLOROVERLIFETIME\n  uniform  vec4 u_ColorOverLifeGradientColors[4];//x为key,yzw为Color\n  uniform  vec2 u_ColorOverLifeGradientAlphas[4];//x为key,y为Alpha\n#endif\n\n#ifdef RANDOMCOLOROVERLIFETIME\n  uniform  vec4 u_ColorOverLifeGradientColors[4];//x为key,yzw为Color\n  uniform  vec2 u_ColorOverLifeGradientAlphas[4];//x为key,y为Alpha\n  uniform  vec4 u_MaxColorOverLifeGradientColors[4];//x为key,yzw为Color\n  uniform  vec2 u_MaxColorOverLifeGradientAlphas[4];//x为key,y为Alpha\n#endif\n\n#ifdef SIZEOVERLIFETIME\n  uniform  int u_SOLType;\n  uniform  bool u_SOLSeprarate;\n  uniform  vec2 u_SOLSizeGradient[4];//x为key,y为尺寸\n  uniform  vec2 u_SOLSizeGradientX[4];//x为key,y为尺寸\n  uniform  vec2 u_SOLSizeGradientY[4];//x为key,y为尺寸\n  uniform  vec2 u_SOLSizeGradientZ[4];//x为key,y为尺寸\n  uniform  vec2 u_SOLSizeGradientMax[4];//x为key,y为尺寸\n  uniform  vec2 u_SOLSizeGradientMaxX[4];//x为key,y为尺寸\n  uniform  vec2 u_SOLSizeGradientMaxY[4];//x为key,y为尺寸\n  uniform  vec2 u_SOLSizeGradientMaxZ[4];//x为key,y为尺寸\n#endif\n\n\n#ifdef ROTATIONOVERLIFETIME\n  uniform  int u_ROLType;\n  uniform  bool u_ROLSeprarate;\n  uniform  float u_ROLAngularVelocityConst;\n  uniform  vec3 u_ROLAngularVelocityConstSeprarate;\n  uniform  vec2 u_ROLAngularVelocityGradient[4];//x为key,y为旋转\n  uniform  vec2 u_ROLAngularVelocityGradientX[4];//x为key,y为旋转\n  uniform  vec2 u_ROLAngularVelocityGradientY[4];//x为key,y为旋转\n  uniform  vec2 u_ROLAngularVelocityGradientZ[4];//x为key,y为旋转\n  uniform  float u_ROLAngularVelocityConstMax;\n  uniform  vec3 u_ROLAngularVelocityConstMaxSeprarate;\n  uniform  vec2 u_ROLAngularVelocityGradientMax[4];//x为key,y为旋转\n  uniform  vec2 u_ROLAngularVelocityGradientMaxX[4];//x为key,y为旋转\n  uniform  vec2 u_ROLAngularVelocityGradientMaxY[4];//x为key,y为旋转\n  uniform  vec2 u_ROLAngularVelocityGradientMaxZ[4];//x为key,y为旋转\n#endif\n\n#ifdef TEXTURESHEETANIMATION\n  uniform  int u_TSAType;\n  uniform  float u_TSACycles;\n  uniform  vec2 u_TSASubUVLength;\n  uniform  vec2 u_TSAGradientUVs[4];//x为key,y为frame\n  uniform  vec2 u_TSAMaxGradientUVs[4];//x为key,y为frame\n#endif\n\nfloat getCurValueFromGradientFloat(in vec2 gradientNumbers[4],in float normalizedAge)\n{\n	float curValue;\n	for(int i=1;i<4;i++)\n	{\n		vec2 gradientNumber=gradientNumbers[i];\n		float key=gradientNumber.x;\n		if(key>=normalizedAge)\n		{\n			vec2 lastGradientNumber=gradientNumbers[i-1];\n			float lastKey=lastGradientNumber.x;\n			float age=(normalizedAge-lastKey)/(key-lastKey);\n			curValue=mix(lastGradientNumber.y,gradientNumber.y,age);\n			break;\n		}\n	}\n	return curValue;\n}\n\n#ifdef VELOCITYOVERLIFETIME\n//float getTotalPositionFromGradientFloat(in vec2 gradientNumbers[4],in float normalizedAge)\n//{\n//	float totalPosition=0.0;\n//	for(int i=1;i<4;i++)\n//	{\n//		vec2 gradientNumber=gradientNumbers[i];\n//		float key=gradientNumber.x;\n//		vec2 lastGradientNumber=gradientNumbers[i-1];\n//		float lastValue=lastGradientNumber.y;\n//		\n//		if(key>=normalizedAge){\n//			float lastKey=lastGradientNumber.x;\n//			float age=(normalizedAge-lastKey)/(key-lastKey);\n//			\n//			float velocity=(lastValue+mix(lastValue,gradientNumber.y,age))/2.0;\n//			totalPosition+=velocity*a_StartLifeTime*(normalizedAge-lastKey);//TODO:计算POSITION时可用优化，用已计算好速度\n//			break;\n//		}\n//		else{\n//			float velocity=(lastValue+gradientNumber.y)/2.0;\n//			totalPosition+=velocity*a_StartLifeTime*(key-lastGradientNumber.x);\n//		}\n//	}\n//	return totalPosition;\n//}\n#endif\n\n\nfloat getTotalValueFromGradientFloat(in vec2 gradientNumbers[4],in float normalizedAge)\n{\n	float totalValue=0.0;\n	for(int i=1;i<4;i++)\n	{\n		vec2 gradientNumber=gradientNumbers[i];\n		float key=gradientNumber.x;\n		vec2 lastGradientNumber=gradientNumbers[i-1];\n		float lastValue=lastGradientNumber.y;\n		\n		if(key>=normalizedAge){\n			float lastKey=lastGradientNumber.x;\n			float age=(normalizedAge-lastKey)/(key-lastKey);\n			totalValue+=(lastValue+mix(lastValue,gradientNumber.y,age))/2.0*a_StartLifeTime*(normalizedAge-lastKey);\n			break;\n		}\n		else{\n			totalValue+=(lastValue+gradientNumber.y)/2.0*a_StartLifeTime*(key-lastGradientNumber.x);\n		}\n	}\n	return totalValue;\n}\n\nvec4 getColorFromGradient(in vec2 gradientAlphas[4],in vec4 gradientColors[4],in float normalizedAge)\n{\n	vec4 overTimeColor;\n	for(int i=1;i<4;i++)\n	{\n		vec2 gradientAlpha=gradientAlphas[i];\n		float alphaKey=gradientAlpha.x;\n		if(alphaKey>=normalizedAge)\n		{\n			vec2 lastGradientAlpha=gradientAlphas[i-1];\n			float lastAlphaKey=lastGradientAlpha.x;\n			float age=(normalizedAge-lastAlphaKey)/(alphaKey-lastAlphaKey);\n			overTimeColor.a=mix(lastGradientAlpha.y,gradientAlpha.y,age);\n			break;\n		}\n	}\n	\n	for(int i=1;i<4;i++)\n	{\n		vec4 gradientColor=gradientColors[i];\n		float colorKey=gradientColor.x;\n		if(colorKey>=normalizedAge)\n		{\n			vec4 lastGradientColor=gradientColors[i-1];\n			float lastColorKey=lastGradientColor.x;\n			float age=(normalizedAge-lastColorKey)/(colorKey-lastColorKey);\n			overTimeColor.rgb=mix(gradientColors[i-1].yzw,gradientColor.yzw,age);\n			break;\n		}\n	}\n	return overTimeColor;\n}\n\n\n\nfloat getFrameFromGradient(in vec2 gradientFrames[4],in float normalizedAge)\n{\n	float overTimeFrame;\n	for(int i=1;i<4;i++)\n	{\n		vec2 gradientFrame=gradientFrames[i];\n		float key=gradientFrame.x;\n		if(key>=normalizedAge)\n		{\n			vec2 lastGradientFrame=gradientFrames[i-1];\n			float lastKey=lastGradientFrame.x;\n			float age=(normalizedAge-lastKey)/(key-lastKey);\n			overTimeFrame=mix(lastGradientFrame.y,gradientFrame.y,age);\n			break;\n		}\n	}\n	return floor(overTimeFrame);\n}\n\n#ifdef VELOCITYOVERLIFETIME\nvec3 computeParticleLifeVelocity(in float normalizedAge)\n{\n  vec3 outLifeVelocity;\n  if(u_VOLType==0)\n	 outLifeVelocity=u_VOLVelocityConst; \n  else if(u_VOLType==1)\n     outLifeVelocity= vec3(getCurValueFromGradientFloat(u_VOLVelocityGradientX,normalizedAge),getCurValueFromGradientFloat(u_VOLVelocityGradientY,normalizedAge),getCurValueFromGradientFloat(u_VOLVelocityGradientZ,normalizedAge));\n  else if(u_VOLType==2)\n	 outLifeVelocity=mix(u_VOLVelocityConst,u_VOLVelocityConstMax,a_Random0.x); \n  else if(u_VOLType==3)\n     outLifeVelocity=vec3(mix(getCurValueFromGradientFloat(u_VOLVelocityGradientX,normalizedAge),getCurValueFromGradientFloat(u_VOLVelocityGradientMaxX,normalizedAge),a_Random0.x),\n	                 mix(getCurValueFromGradientFloat(u_VOLVelocityGradientY,normalizedAge),getCurValueFromGradientFloat(u_VOLVelocityGradientMaxY,normalizedAge),a_Random0.x),\n					 mix(getCurValueFromGradientFloat(u_VOLVelocityGradientZ,normalizedAge),getCurValueFromGradientFloat(u_VOLVelocityGradientMaxZ,normalizedAge),a_Random0.x));\n					\n  return outLifeVelocity;\n} \n#endif\n\nvec3 computeParticlePosition(in vec3 startVelocity, in vec3 lifeVelocity,in float age,in float normalizedAge)\n{\n   vec3 startPosition;\n   vec3 lifePosition;\n   #ifdef VELOCITYOVERLIFETIME\n	 if(u_VOLType==0){\n		  startPosition=startVelocity*age;\n		  lifePosition=lifeVelocity*age;\n	 }\n	 else if(u_VOLType==1){\n		  startPosition=startVelocity*age;\n		  lifePosition=vec3(getTotalValueFromGradientFloat(u_VOLVelocityGradientX,normalizedAge),getTotalValueFromGradientFloat(u_VOLVelocityGradientY,normalizedAge),getTotalValueFromGradientFloat(u_VOLVelocityGradientZ,normalizedAge));\n	 }\n	 else if(u_VOLType==2){\n		  startPosition=startVelocity*age;\n		  lifePosition=lifeVelocity*age;\n	 }\n	 else if(u_VOLType==3){\n		  startPosition=startVelocity*age;\n		  lifePosition=vec3(mix(getTotalValueFromGradientFloat(u_VOLVelocityGradientX,normalizedAge),getTotalValueFromGradientFloat(u_VOLVelocityGradientMaxX,normalizedAge),a_Random0.x)\n	      ,mix(getTotalValueFromGradientFloat(u_VOLVelocityGradientY,normalizedAge),getTotalValueFromGradientFloat(u_VOLVelocityGradientMaxY,normalizedAge),a_Random0.x)\n	      ,mix(getTotalValueFromGradientFloat(u_VOLVelocityGradientZ,normalizedAge),getTotalValueFromGradientFloat(u_VOLVelocityGradientMaxZ,normalizedAge),a_Random0.x));\n	 }\n	\n	vec3 finalPosition;\n	if(u_VOLSpaceType==0){\n	  if(u_ScalingMode!=2)\n	   finalPosition =mat3(u_WorldRotationMat)*(u_PositionScale*(a_Position+startPosition+lifePosition));\n	  else\n	   finalPosition =mat3(u_WorldRotationMat)*(u_PositionScale*a_Position+startPosition+lifePosition);\n	}\n	else{\n	  if(u_ScalingMode!=2)\n	    finalPosition = mat3(u_WorldRotationMat)*(u_PositionScale*(a_Position+startPosition))+lifePosition;\n	  else\n	    finalPosition = mat3(u_WorldRotationMat)*(u_PositionScale*a_Position+startPosition)+lifePosition;\n	}\n  #else\n	 startPosition=startVelocity*age;\n	 vec3 finalPosition;\n	 if(u_ScalingMode!=2)\n	   finalPosition = mat3(u_WorldRotationMat)*(u_PositionScale*(a_Position+startPosition));\n	 else\n	   finalPosition = mat3(u_WorldRotationMat)*(u_PositionScale*a_Position+startPosition);\n  #endif\n		  \n  finalPosition=finalPosition+u_WorldPosition;\n  finalPosition+=u_Gravity*age*normalizedAge;//计算受重力影响的位置//TODO:移除\n \n  return  finalPosition;\n}\n\n\nvec4 computeParticleColor(in vec4 color,in float normalizedAge)\n{\n	#ifdef COLOROVERLIFETIME\n	  color*=getColorFromGradient(u_ColorOverLifeGradientAlphas,u_ColorOverLifeGradientColors,normalizedAge);\n	#endif\n	\n	#ifdef RANDOMCOLOROVERLIFETIME\n	  color*=mix(getColorFromGradient(u_ColorOverLifeGradientAlphas,u_ColorOverLifeGradientColors,normalizedAge),getColorFromGradient(u_MaxColorOverLifeGradientAlphas,u_MaxColorOverLifeGradientColors,normalizedAge),a_Random0.y);\n	#endif\n\n    return color;\n}\n\nvec2 computeParticleSize(in vec2 size,in float normalizedAge)\n{\n	#ifdef SIZEOVERLIFETIME\n	 if(u_SOLType==0){\n		if(u_SOLSeprarate){\n		    size*=vec2(getCurValueFromGradientFloat(u_SOLSizeGradientX,normalizedAge),getCurValueFromGradientFloat(u_SOLSizeGradientY,normalizedAge));\n		}\n		else{\n		    size*=getCurValueFromGradientFloat(u_SOLSizeGradient,normalizedAge);\n		}\n	 }\n	 else if(u_SOLType==2){\n		if(u_SOLSeprarate){\n			size*=vec2(mix(getCurValueFromGradientFloat(u_SOLSizeGradientX,normalizedAge),getCurValueFromGradientFloat(u_SOLSizeGradientMaxX,normalizedAge),a_Random0.z)\n	        ,mix(getCurValueFromGradientFloat(u_SOLSizeGradientY,normalizedAge),getCurValueFromGradientFloat(u_SOLSizeGradientMaxY,normalizedAge),a_Random0.z));\n		}\n		else{\n			size*=mix(getCurValueFromGradientFloat(u_SOLSizeGradient,normalizedAge),getCurValueFromGradientFloat(u_SOLSizeGradientMax,normalizedAge),a_Random0.z); \n		}\n	 }\n	#endif\n	return size;\n}\n\nmat2 computeParticleRotation(in vec3 rotation,in float age,in float normalizedAge)//TODO:不分轴是否无需计算XY，Billboard模式下好像是,待确认。\n{ \n	#ifdef ROTATIONOVERLIFETIME\n	   if(u_ROLType==0){\n		  if(u_ROLSeprarate){\n			  vec3 ageRot=u_ROLAngularVelocityConstSeprarate*age;\n	          rotation+=ageRot;\n			}\n			else{\n			  float ageRot=u_ROLAngularVelocityConst*age;\n	          rotation+=ageRot;\n			}\n		}\n	    else if(u_ROLType==1){\n		    if(u_ROLSeprarate){\n			  rotation+=vec3(getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientX,normalizedAge),getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientY,normalizedAge),getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientZ,normalizedAge));\n			}\n			else{\n			  rotation+=getTotalValueFromGradientFloat(u_ROLAngularVelocityGradient,normalizedAge);\n			}\n		}\n	    else if(u_ROLType==2){\n		    if(u_ROLSeprarate){\n			  vec3 ageRot=mix(u_ROLAngularVelocityConstSeprarate,u_ROLAngularVelocityConstMaxSeprarate,a_Random0.w)*age;\n	          rotation+=ageRot;\n	        }\n			else{\n			  float ageRot=mix(u_ROLAngularVelocityConst,u_ROLAngularVelocityConstMax,a_Random0.w)*age;\n	          rotation+=ageRot;\n			}\n	    }\n	    else if(u_ROLType==3){\n		    if(u_ROLSeprarate){\n			   rotation+=vec3(mix(getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientX,normalizedAge),getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientMaxX,normalizedAge),a_Random0.w)\n	          ,mix(getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientY,normalizedAge),getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientMaxY,normalizedAge),a_Random0.w)\n	          ,mix(getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientZ,normalizedAge),getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientMaxZ,normalizedAge),a_Random0.w));\n			}\n			else{\n			  rotation+=mix(getTotalValueFromGradientFloat(u_ROLAngularVelocityGradient,normalizedAge),getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientMax,normalizedAge),a_Random0.w);\n			}\n		}\n	#endif\n	float rot=rotation.z;\n    float c = cos(rot);\n    float s = sin(rot);\n    return mat2(c, -s, s, c);\n}\n\nvec2 computeParticleUV(in vec2 uv,in float normalizedAge)\n{ \n	#ifdef TEXTURESHEETANIMATION\n	  if(u_TSAType==1){\n		float cycleNormalizedAge=normalizedAge*u_TSACycles;\n		float frame=getFrameFromGradient(u_TSAGradientUVs,normalizedAge*(cycleNormalizedAge-floor(cycleNormalizedAge)));\n		float totalULength=frame*u_TSASubUVLength.x;\n		float floorTotalULength=floor(totalULength);\n	    uv.x=uv.x+totalULength-floorTotalULength;\n		uv.y=uv.y+floorTotalULength*u_TSASubUVLength.y;\n	  }\n	  else if(u_TSAType==3){\n		float cycleNormalizedAge=normalizedAge*u_TSACycles;\n		float uvNormalizedAge=cycleNormalizedAge-floor(cycleNormalizedAge);\n	    float frame=floor(mix(getFrameFromGradient(u_TSAGradientUVs,uvNormalizedAge),getFrameFromGradient(u_TSAMaxGradientUVs,uvNormalizedAge),a_Random1.x));\n		float totalULength=frame*u_TSASubUVLength.x;\n		float floorTotalULength=floor(totalULength);\n	    uv.x=uv.x+totalULength-floorTotalULength;\n		uv.y=uv.y+floorTotalULength*u_TSASubUVLength.y;\n	  }\n    #endif\n	return uv;\n}\n\nvoid main()\n{\n   float age = u_CurrentTime - a_Time;\n   float normalizedAge = age/a_StartLifeTime;\n   vec3 lifeVelocity;\n   if(normalizedAge<1.0){ \n	  vec3 startVelocity=a_Direction*a_StartSpeed;\n   #ifdef VELOCITYOVERLIFETIME\n	  lifeVelocity= computeParticleLifeVelocity(normalizedAge);//计算粒子生命周期速度\n   #endif \n	  \n   vec3 center=computeParticlePosition(startVelocity, lifeVelocity, age, normalizedAge);//计算粒子位置\n   vec2 corner=a_CornerTextureCoordinate.xy;//Billboard模式z轴无效\n   \n   #ifdef SPHERHBILLBOARD\n        vec3 cameraUpVector =normalize(u_CameraUp);//TODO:是否外面归一化\n        vec3 sideVector = normalize(cross(u_CameraDirection,cameraUpVector));\n        vec3 upVector = normalize(cross(sideVector,u_CameraDirection));\n	    corner*=computeParticleSize(a_StartSize.xy,normalizedAge);\n		if(u_ThreeDStartRotation){\n		  center += u_SizeScale.xzy*(mat3(a_StartRotation0,a_StartRotation1,a_StartRotation2)*(corner.x*sideVector+corner.y*upVector));\n		}\n		else{\n		  mat2 rotation = computeParticleRotation(a_StartRotation0, age,normalizedAge);\n		  corner=rotation*corner;\n		  center += u_SizeScale.xzy*(corner.x*sideVector+corner.y*upVector);\n		}\n       \n   #endif\n   \n   #ifdef STRETCHEDBILLBOARD\n	vec3 velocity;\n	#ifdef VELOCITYOVERLIFETIME\n	    if(u_VOLSpaceType==0)\n		  velocity=mat3(u_WorldRotationMat)*(u_SizeScale*(startVelocity+lifeVelocity));\n	    else\n		  velocity=mat3(u_WorldRotationMat)*(u_SizeScale*startVelocity)+lifeVelocity;\n    #else\n	    velocity= mat3(u_WorldRotationMat)*(u_SizeScale*startVelocity);\n    #endif   \n        vec3 cameraUpVector =normalize(velocity);\n        vec3 sideVector = normalize(cross(u_CameraDirection,cameraUpVector));\n	    vec2 size=computeParticleSize(a_StartSize.xy,normalizedAge);\n	    const mat2 rotaionZHalfPI=mat2(0.0, -1.0, 1.0, 0.0);\n	    corner=rotaionZHalfPI*corner;\n	    corner.y=corner.y-abs(corner.y);\n	    float speed=length(velocity);//TODO:\n	    center +=u_SizeScale.xzy*size.x*corner.x*sideVector+((cameraUpVector*speed)*u_StretchedBillboardSpeedScale+cameraUpVector*size.y*u_StretchedBillboardLengthScale)*corner.y;\n   #endif\n   \n   #ifdef HORIZONTALBILLBOARD\n        const vec3 cameraUpVector =vec3(0.0,0.0,-1.0);\n	    const vec3 sideVector = vec3(1.0,0.0,0.0);\n		corner*=computeParticleSize(a_StartSize.xy,normalizedAge);\n		mat2 rotation = computeParticleRotation(a_StartRotation0, age,normalizedAge);\n	    corner=rotation*corner;\n        center +=u_SizeScale.xzy*(corner.x*sideVector+ corner.y*cameraUpVector);\n   #endif\n   \n   #ifdef VERTICALBILLBOARD\n        const vec3 cameraUpVector =vec3(0.0,1.0,0.0);\n        vec3 sideVector = normalize(cross(u_CameraDirection,cameraUpVector));\n		corner*=computeParticleSize(a_StartSize.xy,normalizedAge);\n		mat2 rotation = computeParticleRotation(a_StartRotation0, age,normalizedAge);\n	    corner=rotation*corner*cos(0.78539816339744830961566084581988);//TODO:临时缩小cos45,不确定U3D原因\n        center +=u_SizeScale.xzy*(corner.x*sideVector+ corner.y*cameraUpVector);\n   #endif\n   \n      gl_Position=u_Projection*u_View*vec4(center,1.0);\n      v_Color = computeParticleColor(a_StartColor, normalizedAge);\n      v_TextureCoordinate =computeParticleUV(a_CornerTextureCoordinate.zw, normalizedAge);\n      v_Discard=0.0;\n   }\n   else\n   {\n      v_Discard=1.0;\n   }\n}\n\n"/*__INCLUDESTR__E:/trank/libs/LayaAir/publish/LayaAirPublish/src/d3/src/laya/d3/shader/files/ParticleShuriKen.vs*/;
			ps="#ifdef FSHIGHPRECISION\n  precision highp float;\n#else\n  precision mediump float;\n#endif\n\nvarying float v_Discard;\nvarying vec4 v_Color;\nvarying vec2 v_TextureCoordinate;\nuniform sampler2D u_texture;\n\n\nvoid main()\n{	\n	#ifdef DIFFUSEMAP\n	  if(v_Discard!=0.0)\n         discard;\n	  gl_FragColor=texture2D(u_texture,v_TextureCoordinate)*v_Color;\n	#else\n	  gl_FragColor=vec4(0.0);\n	#endif\n}"/*__INCLUDESTR__E:/trank/libs/LayaAir/publish/LayaAirPublish/src/d3/src/laya/d3/shader/files/ParticleShuriKen.ps*/;
			Shader.preCompile(PARTICLESHURIKEN,vs,ps,shaderNameMap);
			shaderNameMap={
				'a_Position':/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION",
				'a_Texcoord0':/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV",
				'a_Time':/*laya.d3.core.material.GlitterMaterial.TIME*/"TIME",
				'u_Texture':/*laya.d3.core.material.GlitterMaterial.DIFFUSETEXTURE*/"DIFFUSETEXTURE",
				'u_MvpMatrix':/*laya.d3.core.material.GlitterMaterial.MVPMATRIX*/"MVPMATRIX",
				'u_Albedo':/*laya.d3.core.material.GlitterMaterial.ALBEDO*/"ALBEDO",
				'u_CurrentTime':/*laya.d3.core.material.GlitterMaterial.CURRENTTIME*/"CURRENTTIME",
				'u_Color':/*laya.d3.core.material.GlitterMaterial.UNICOLOR*/"UNICOLOR",
				'u_Duration':/*laya.d3.core.material.GlitterMaterial.DURATION*/"DURATION"};
			var GLITTER=Shader.nameKey.add("GLITTER");
			vs="attribute vec4 a_Position;\nattribute vec2 a_Texcoord0;\nattribute float a_Time;\n\nuniform mat4 u_MvpMatrix;\nuniform  float u_CurrentTime;\nuniform  vec4 u_Color;\nuniform float u_Duration;\n\nvarying vec2 v_Texcoord;\nvarying vec4 v_Color;\n\n\nvoid main()\n{\n  gl_Position = u_MvpMatrix * a_Position;\n  \n  float age = u_CurrentTime-a_Time;\n  float normalizedAge = clamp(age / u_Duration,0.0,1.0);\n   \n  v_Texcoord=a_Texcoord0;\n  \n  v_Color=u_Color;\n  v_Color.a*=1.0-normalizedAge;\n}\n"/*__INCLUDESTR__E:/trank/libs/LayaAir/publish/LayaAirPublish/src/d3/src/laya/d3/shader/files/Glitter.vs*/;
			ps="#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\nuniform vec4 u_Albedo;\nuniform sampler2D u_Texture;\n\nvarying vec2 v_Texcoord;\nvarying vec4 v_Color;\n\n\nvoid main()\n{	\n  gl_FragColor=texture2D(u_Texture, v_Texcoord)*v_Color;\n  gl_FragColor=gl_FragColor*u_Albedo;\n}\n\n"/*__INCLUDESTR__E:/trank/libs/LayaAir/publish/LayaAirPublish/src/d3/src/laya/d3/shader/files/Glitter.ps*/;
			Shader.preCompile(GLITTER,vs,ps,shaderNameMap);
			shaderNameMap={
				'a_Position':/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION",
				'u_MvpMatrix':/*laya.d3.resource.models.Sky.MVPMATRIX*/"MVPMATRIX",
				'u_Intensity':/*laya.d3.resource.models.Sky.INTENSITY*/"INTENSITY",
				'u_AlphaBlending':/*laya.d3.resource.models.Sky.ALPHABLENDING*/"ALPHABLENDING",
				'u_CubeTexture':/*laya.d3.resource.models.Sky.DIFFUSETEXTURE*/"DIFFUSETEXTURE"};
			var skyBox=Shader.nameKey.add("SkyBox");
			vs="attribute vec4 a_Position;\nuniform mat4 u_MvpMatrix;\nvarying vec3 v_Texcoord;\n\n\nvoid main()\n{\n  gl_Position = (u_MvpMatrix*a_Position).xyww;\n  v_Texcoord=a_Position.xyz;\n}\n"/*__INCLUDESTR__E:/trank/libs/LayaAir/publish/LayaAirPublish/src/d3/src/laya/d3/shader/files/SkyBox.vs*/;
			ps="#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\nuniform float u_Intensity;\nuniform float u_AlphaBlending;\nuniform samplerCube u_CubeTexture;\n\nvarying vec3 v_Texcoord;\n\n\nvoid main()\n{	\n  gl_FragColor=vec4(textureCube(u_CubeTexture, v_Texcoord).rgb*u_Intensity,u_AlphaBlending);\n}\n\n"/*__INCLUDESTR__E:/trank/libs/LayaAir/publish/LayaAirPublish/src/d3/src/laya/d3/shader/files/SkyBox.ps*/;
			Shader.preCompile(skyBox,vs,ps,shaderNameMap);
			shaderNameMap={
				'a_Position':/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION",
				'a_Texcoord0':/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV",
				'u_MvpMatrix':/*laya.d3.resource.models.Sky.MVPMATRIX*/"MVPMATRIX",
				'u_Intensity':/*laya.d3.resource.models.Sky.INTENSITY*/"INTENSITY",
				'u_AlphaBlending':/*laya.d3.resource.models.Sky.ALPHABLENDING*/"ALPHABLENDING",
				'u_texture':/*laya.d3.resource.models.Sky.DIFFUSETEXTURE*/"DIFFUSETEXTURE"};
			var skyDome=Shader.nameKey.add("SkyDome");
			vs="attribute vec4 a_Position;\nattribute vec2 a_Texcoord0;\nuniform mat4 u_MvpMatrix;\nvarying vec2 v_Texcoord;\n\n\nvoid main()\n{\n  gl_Position = (u_MvpMatrix*a_Position).xyww;\n  v_Texcoord = a_Texcoord0;\n}\n"/*__INCLUDESTR__E:/trank/libs/LayaAir/publish/LayaAirPublish/src/d3/src/laya/d3/shader/files/SkyDome.vs*/;
			ps="#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\nuniform float u_Intensity;\nuniform float u_AlphaBlending;\nuniform sampler2D u_texture;\n\nvarying vec2 v_Texcoord;\n\n\nvoid main()\n{	\n  gl_FragColor=vec4(texture2D(u_texture, v_Texcoord).rgb*u_Intensity,u_AlphaBlending);\n}\n\n"/*__INCLUDESTR__E:/trank/libs/LayaAir/publish/LayaAirPublish/src/d3/src/laya/d3/shader/files/SkyDome.ps*/;
			Shader.preCompile(skyDome,vs,ps,shaderNameMap);
		}

		Laya3D._regClassforJson=function(){
			var createMap=Laya.loader.createMap;
			createMap["lh"]=[Sprite3D,/*laya.net.Loader.TEXT*/"text"];
			createMap["lm"]=[Mesh,/*laya.net.Loader.BUFFER*/"arraybuffer"];
			createMap["lmat"]=[StandardMaterial,/*laya.net.Loader.JSON*/"json"];
			createMap["jpg"]=[Texture2D,"nativeimage"];
			createMap["jpeg"]=[Texture2D,"nativeimage"];
			createMap["png"]=[Texture2D,"nativeimage"];
			createMap["ltc"]=[TextureCube,/*CLASS CONST:Laya3D.TEXTURECUBE*/"texturecube"];
			createMap["lsani"]=[AnimationTemplet,/*laya.net.Loader.BUFFER*/"arraybuffer"];
			createMap["lrani"]=[AnimationTemplet,/*laya.net.Loader.BUFFER*/"arraybuffer"];
			createMap["lp"]=[ShurikenParticleSystem,/*laya.net.Loader.JSON*/"json"];
			createMap["ani"]=[AnimationTemplet,/*laya.net.Loader.BUFFER*/"arraybuffer"];
			createMap["lani"]=[AnimationTemplet,/*laya.net.Loader.BUFFER*/"arraybuffer"];
		}

		Laya3D._loadTextureCube=function(loader){
			var ltcLoader=new Loader();
			var url=loader.url;
			ltcLoader.on(/*laya.events.Event.COMPLETE*/"complete",null,Laya3D._onTextureCubeLTCLoaded,[loader]);
			ltcLoader.load(url,/*laya.net.Loader.JSON*/"json",false,null,true);
		}

		Laya3D._onTextureCubeLTCLoaded=function(loader,ltcData){
			var preBasePath=URL.basePath;
			URL.basePath=URL.getPath(URL.formatURL(loader.url));
			var urls=[URL.formatURL(ltcData.px),URL.formatURL(ltcData.nx),URL.formatURL(ltcData.py),URL.formatURL(ltcData.ny),URL.formatURL(ltcData.pz),URL.formatURL(ltcData.nz)];
			var processHandler=Handler.create(null,Laya3D._onTextureCubeProcess,[loader],false);
			Laya.loader.load(urls,Handler.create(null,Laya3D._onTextureCubeImagesLoaded,[loader,urls,processHandler]),processHandler,"nativeimage");
			URL.basePath=preBasePath;
		}

		Laya3D._onTextureCubeProcess=function(loader,process){
			loader.event(/*laya.events.Event.PROGRESS*/"progress",process);
		}

		Laya3D._onTextureCubeImagesLoaded=function(loader,urls,processHandler){
			var images=[];
			images.length=6;
			for (var i=0;i < 6;i++){
				var url=urls[i];
				images[i]=Loader.getRes(url);
				Loader.clearRes(url);
			}
			loader.endLoad(images);
			processHandler.recover();
		}

		Laya3D.init=function(width,height,antialias){
			(antialias===void 0)&& (antialias=false);
			if (!WebGL.enable()){
				alert("Laya3D init err,must support webGL!");
				return;
			}
			Loader.parserMap[ /*CLASS CONST:Laya3D.TEXTURECUBE*/"texturecube"]=Laya3D._loadTextureCube;
			RunDriver.changeWebGLSize=function (width,height){
				WebGL.onStageResize(width,height);
				RenderState.clientWidth=width;
				RenderState.clientHeight=height;
			}
			Config.isAntialias=antialias;
			Render.is3DMode=true;
			Laya.init(width,height);
			Layer.__init__();
			ShaderDefines3D.__init__();
			Laya3D._initShader();
			Laya3D._regClassforJson();
		}

		Laya3D.TEXTURECUBE="texturecube";
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
		__proto._onLayerChanged=function(layer){
			this._cachedOwnerLayerMask=layer.mask;
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

		Component3D._uniqueIDCounter=1;
		return Component3D;
	})(EventDispatcher)


	/**
	*<code>Render</code> 类用于渲染器的父类，抽象类不允许示例。
	*/
	//class laya.d3.core.render.BaseRender extends laya.events.EventDispatcher
	var BaseRender=(function(_super){
		function BaseRender(owner){
			this._owner=null;
			this._enable=false;
			this._renderObject=null;
			this._materials=null;
			this._boundingSphereNeedChange=false;
			this._boundingBoxNeedChange=false;
			this._boundingSphere=null;
			this._boundingBox=null;
			BaseRender.__super.call(this);
			this._owner=owner;
			this._enable=true;
			this._boundingBox=new BoundBox(new Vector3(),new Vector3());
			this._boundingSphere=new BoundSphere(new Vector3(),0);
			this._boundingSphereNeedChange=true;
			this._boundingBoxNeedChange=true;
			this._renderObject=new RenderObject();
			this._renderObject._render=this;
			this._renderObject._layerMask=this._owner.layer.mask;
			this._renderObject._ownerEnable=this._owner.enable;
			this._renderObject._enable=this._enable;
			this._materials=[];
			this._owner.transform.on(/*laya.events.Event.WORLDMATRIX_NEEDCHANGE*/"worldmatrixneedchanged",this,this._onWorldMatNeedChange);
			this._owner.on(/*laya.events.Event.LAYER_CHANGED*/"layerchanged",this,this._onOwnerLayerChanged);
			this._owner.on(/*laya.events.Event.ENABLED_CHANGED*/"enabledchanged",this,this._onOwnerEnableChanged);
			this.on(/*laya.events.Event.ENABLED_CHANGED*/"enabledchanged",this,this._onEnableChanged);
		}

		__class(BaseRender,'laya.d3.core.render.BaseRender',_super);
		var __proto=BaseRender.prototype;
		Laya.imps(__proto,{"laya.resource.IDestroy":true})
		/**
		*@private
		*/
		__proto._onWorldMatNeedChange=function(){
			this._boundingSphereNeedChange=true;
			this._boundingBoxNeedChange=true;
		}

		/**
		*@private
		*/
		__proto._onOwnerLayerChanged=function(layer){
			this._renderObject._layerMask=layer.mask;
		}

		/**
		*@private
		*/
		__proto._onOwnerEnableChanged=function(enable){
			this._renderObject._ownerEnable=enable;
		}

		/**
		*@private
		*/
		__proto._onEnableChanged=function(sender,enable){
			this._renderObject._enable=enable;
		}

		/**
		*@private
		*/
		__proto._calculateBoundingSphere=function(){
			throw("BaseRender: must override it.");
		}

		/**
		*@private
		*/
		__proto._calculateBoundingBox=function(){
			throw("BaseRender: must override it.");
		}

		/**
		*彻底清理资源。
		*/
		__proto.destroy=function(){
			this.offAll();
			this._owner=null;
			this._renderObject=null;
			this._materials=null;
			this._boundingBox=null;
			this._boundingSphere=null;
		}

		/**
		*设置是否可用。
		*@param value 是否可用。
		*/
		/**
		*获取是否可用。
		*@return 是否可用。
		*/
		__getset(0,__proto,'enable',function(){
			return this._enable;
			},function(value){
			this._enable=value;
			this.event(/*laya.events.Event.ENABLED_CHANGED*/"enabledchanged",[this,value]);
		});

		/**
		*获取包围盒。
		*@return 包围盒。
		*/
		__getset(0,__proto,'boundingBox',function(){
			if (this._boundingBoxNeedChange){
				this._calculateBoundingBox();
				this._boundingBoxNeedChange=false;
			}
			return this._boundingBox;
		});

		/**
		*设置材质列表。
		*@param value 材质列表。
		*/
		/**
		*获取浅拷贝材质列表。
		*@return 浅拷贝材质列表。
		*/
		__getset(0,__proto,'sharedMaterials',function(){
			var materials=this._materials.slice();
			return materials;
			},function(value){
			if (!value)
				throw new Error("MeshRender: shadredMaterials value can't be null.");
			this._materials=value;
			for (var i=0,n=value.length;i<n;i++)
			this.event(/*laya.events.Event.MATERIAL_CHANGED*/"materialchanged",[this,i,value[i]]);
		});

		/**
		*获取渲染物体。
		*@return 渲染物体。
		*/
		__getset(0,__proto,'renderObject',function(){
			return this._renderObject;
		});

		/**
		*获取包围球。
		*@return 包围球。
		*/
		__getset(0,__proto,'boundingSphere',function(){
			if (this._boundingSphereNeedChange){
				this._calculateBoundingSphere();
				this._boundingSphereNeedChange=false;
			}
			return this._boundingSphere;
		});

		/**
		*设置第一个实例材质。
		*@param value 第一个实例材质。
		*/
		/**
		*返回第一个实例材质,第一次使用会拷贝实例对象。
		*@return 第一个实例材质。
		*/
		__getset(0,__proto,'material',function(){
			var material=this._materials[0];
			if (material && !material._isInstance){
				var instanceMaterial=/*__JS__ */new material.constructor();
				material.cloneTo(instanceMaterial);
				instanceMaterial.name=instanceMaterial.name+"(Instance)";
				instanceMaterial._isInstance=true;
				this._materials[0]=instanceMaterial;
				this.event(/*laya.events.Event.MATERIAL_CHANGED*/"materialchanged",[this,0,instanceMaterial]);
			}
			return this._materials[0];
			},function(value){
			this._materials[0]=value;
			this.event(/*laya.events.Event.MATERIAL_CHANGED*/"materialchanged",[this,0,value]);
		});

		/**
		*设置实例材质列表。
		*@param value 实例材质列表。
		*/
		/**
		*获取潜拷贝实例材质列表,第一次使用会拷贝实例对象。
		*@return 浅拷贝实例材质列表。
		*/
		__getset(0,__proto,'materials',function(){
			for (var i=0,n=this._materials.length;i < n;i++){
				var material=this._materials[i];
				if (!material._isInstance){
					var instanceMaterial=/*__JS__ */new material.constructor();
					material.cloneTo(instanceMaterial);
					instanceMaterial.name=instanceMaterial.name+"(Instance)";
					instanceMaterial._isInstance=true;
					this._materials[i]=instanceMaterial;
					this.event(/*laya.events.Event.MATERIAL_CHANGED*/"materialchanged",[this,i,instanceMaterial]);
				}
			}
			return this._materials.slice();
			},function(value){
			if (!value)
				throw new Error("MeshRender: materials value can't be null.");
			this._materials=value;
			for (var i=0,n=value.length;i<n;i++)
			this.event(/*laya.events.Event.MATERIAL_CHANGED*/"materialchanged",[this,i,value[i]]);
		});

		/**
		*设置第一个材质。
		*@param value 第一个材质。
		*/
		/**
		*返回第一个材质。
		*@return 第一个材质。
		*/
		__getset(0,__proto,'sharedMaterial',function(){
			return this._materials[0];
			},function(value){
			this._materials[0]=value;
			this.event(/*laya.events.Event.MATERIAL_CHANGED*/"materialchanged",[this,0,value]);
		});

		return BaseRender;
	})(EventDispatcher)


	/**
	*<code>MeshFilter</code> 类用于创建网格过滤器。
	*/
	//class laya.d3.core.MeshFilter extends laya.events.EventDispatcher
	var MeshFilter=(function(_super){
		function MeshFilter(owner){
			this._owner=null;
			this._sharedMesh=null;
			MeshFilter.__super.call(this);
			this._owner=owner;
		}

		__class(MeshFilter,'laya.d3.core.MeshFilter',_super);
		var __proto=MeshFilter.prototype;
		Laya.imps(__proto,{"laya.resource.IDestroy":true})
		__proto.destroy=function(){
			this.offAll();
			this._owner=null;
			this._sharedMesh=null;
		}

		/**
		*设置共享网格。
		*@return value 共享网格。
		*/
		/**
		*获取共享网格。
		*@return 共享网格。
		*/
		__getset(0,__proto,'sharedMesh',function(){
			return this._sharedMesh;
			},function(value){
			var oldMesh=this._sharedMesh;
			this._sharedMesh=value;
			this.event(/*laya.events.Event.MESH_CHANGED*/"meshchanged",[this,oldMesh,value]);
		});

		return MeshFilter;
	})(EventDispatcher)


	/**
	*<code>Transform3D</code> 类用于实现3D变换。
	*/
	//class laya.d3.core.Transform3D extends laya.events.EventDispatcher
	var Transform3D=(function(_super){
		function Transform3D(owner){
			this._owner=null;
			this._preWorldTransformModifyID=-1;
			this._localUpdate=false;
			this._worldUpdate=true;
			this._parent=null;
			Transform3D.__super.call(this);
			this._tempMatrix0=new Matrix4x4();
			this._tempQuaternion0=new Quaternion();
			this._tempVector30=new Vector3();
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
			this._owner=owner;
		}

		__class(Transform3D,'laya.d3.core.Transform3D',_super);
		var __proto=Transform3D.prototype;
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
			if (!this._worldUpdate){
				this._worldUpdate=true;
				this.event(/*laya.events.Event.WORLDMATRIX_NEEDCHANGE*/"worldmatrixneedchanged");
				for (var i=0,n=this._owner._childs.length;i < n;i++)
				(this._owner._childs [i]).transform._onWorldTransform();
			}
		}

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
				Quaternion.multiply(this._localRotation,this._tempQuaternion0,this._localRotation);
				this.localRotation=this._localRotation;
				}else {
				Quaternion.multiply(this._tempQuaternion0,this.rotation,this._rotation);
				this.rotation=this._rotation;
			}
		}

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
		*设置世界矩阵。
		*@param value 世界矩阵。
		*/
		/**
		*获取世界矩阵。
		*@return 世界矩阵。
		*/
		__getset(0,__proto,'worldMatrix',function(){
			if (!this._worldUpdate)
				return this._worldMatrix;
			if (this._parent !=null)
				Matrix4x4.multiply(this._parent.worldMatrix,this.localMatrix,this._worldMatrix);
			else
			this.localMatrix.cloneTo(this._worldMatrix);
			this._worldUpdate=false;
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
		*获取世界矩阵是否需要更新。
		*@return 世界矩阵是否需要更新。
		*/
		__getset(0,__proto,'worldNeedUpdate',function(){
			return this._worldUpdate;
		});

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
		*设置局部空间的旋转角度。
		*@param value 欧拉角的旋转值，顺序为x、y、z。
		*/
		__getset(0,__proto,'localRotationEuler',null,function(value){
			Quaternion.createFromYawPitchRoll(value.y,value.x,value.z,this._localRotation);
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

		/**
		*设置父3D变换。
		*@param value 父3D变换。
		*/
		__getset(0,__proto,'parent',null,function(value){
			this._parent=value;
			this._onWorldTransform();
		});

		return Transform3D;
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

		return TransformUV;
	})(EventDispatcher)


	/**
	*@private
	*<code>GlitterTemplet</code> 类用于创建闪光数据模板。
	*/
	//class laya.d3.resource.tempelet.GlitterTemplet extends laya.events.EventDispatcher
	var GlitterTemplet=(function(_super){
		function GlitterTemplet(owner){
			this._floatCountPerVertex=6;
			this._owner=null;
			this._vertices=null;
			this._vertexBuffer=null;
			this._firstActiveElement=0;
			this._firstNewElement=0;
			this._firstFreeElement=0;
			this._firstRetiredElement=0;
			this._currentTime=NaN;
			this._drawCounter=0;
			this.scLeft=null;
			this.scRight=null;
			this._numPositionMode=0;
			this._numPositionVelocityMode=0;
			this._lastTime=NaN;
			this._needPatch=false;
			this._lastPatchAddPos0=null;
			this._lastPatchAddPos1=null;
			this._lastPatchAddTime=NaN;
			this.lifeTime=NaN;
			this.minSegmentDistance=NaN;
			this.minInterpDistance=NaN;
			this.maxSlerpCount=0;
			this.color=null;
			this._maxSegments=0;
			GlitterTemplet.__super.call(this);
			this._tempVector0=new Vector3();
			this._tempVector1=new Vector3();
			this._tempVector2=new Vector3();
			this._tempVector3=new Vector3();
			this._albedo=new Vector4(1.0,1.0,1.0,1.0);
			this._posModeLastPosition0=new Vector3();
			this._posModeLastPosition1=new Vector3();
			this._posModePosition0=new Vector3();
			this._posModePosition1=new Vector3();
			this._posVelModePosition0=new Vector3();
			this._posVelModeVelocity0=new Vector3();
			this._posVelModePosition1=new Vector3();
			this._posVelModeVelocity1=new Vector3();
			this._owner=owner;
			this._lastTime=0
			this._firstActiveElement=0;
			this._firstNewElement=0;
			this._firstFreeElement=0;
			this._firstRetiredElement=0;
			this._currentTime=0;
			this._drawCounter=0;
			this._needPatch=false;
			this._lastPatchAddPos0=new Vector3();
			this._lastPatchAddPos1=new Vector3();
			this.scLeft=new SplineCurvePositionVelocity();
			this.scRight=new SplineCurvePositionVelocity();
			this.lifeTime=0.5;
			this.minSegmentDistance=0.1;
			this.minInterpDistance=0.6;
			this.maxSlerpCount=128;
			this.color=new Vector4(1.0,1.0,1.0,1.0);
			this._maxSegments=200;
			this._owner.on(/*laya.events.Event.ENABLED_CHANGED*/"enabledchanged",this,this._onEnableChanged);
		}

		__class(GlitterTemplet,'laya.d3.resource.tempelet.GlitterTemplet',_super);
		var __proto=GlitterTemplet.prototype;
		Laya.imps(__proto,{"laya.d3.core.render.IRenderable":true})
		__proto._getVertexBuffer=function(index){
			(index===void 0)&& (index=0);
			if (index===0)
				return this._vertexBuffer;
			else
			return null;
		}

		__proto._getIndexBuffer=function(){
			return null;
		}

		/**
		*@private
		*/
		__proto._initialize=function(){
			this._vertexBuffer=VertexBuffer3D.create(VertexGlitter.vertexDeclaration,this.maxSegments *2,/*laya.webgl.WebGLContext.DYNAMIC_DRAW*/0x88E8);
			this._vertices=new Float32Array(this.maxSegments *this._floatCountPerVertex *2);
		}

		__proto._onEnableChanged=function(enable){
			if (!enable){
				this._numPositionMode=0;
				this._numPositionVelocityMode=0;
				this._firstActiveElement=0;
				this._firstNewElement=0;
				this._firstFreeElement=0;
				this._firstRetiredElement=0;
				this._currentTime=0;
				this._drawCounter=0;
			}
		}

		/**
		*@private
		*/
		__proto._updateTextureCoordinates=function(){
			if (this._firstActiveElement < this._firstFreeElement){
				this._updateSubTextureCoordinates(this._firstActiveElement,(this._firstFreeElement-this._firstActiveElement)*2);
				}else {
				this._updateSubTextureCoordinates(this._firstActiveElement,(this.maxSegments-this._firstActiveElement)*2);
				if (this._firstFreeElement > 0)
					this._updateSubTextureCoordinates(0,this._firstFreeElement *2);
			}
		}

		/**
		*@private
		*/
		__proto._updateSubTextureCoordinates=function(start,count){
			var startOffset=start *2;
			for (var i=0;i < count;i+=2){
				var vertexOffset=startOffset+i;
				var upVertexOffset=vertexOffset *this._floatCountPerVertex;
				var downVertexOffset=(vertexOffset+1)*this._floatCountPerVertex;
				this._vertices[upVertexOffset+3]=this._vertices[downVertexOffset+3]=(this._vertices[upVertexOffset+5]-this._currentTime)/ this.lifeTime;
			}
		}

		/**
		*@private
		*/
		__proto._retireActiveGlitter=function(){
			var particleDuration=this.lifeTime;
			var _floatCountOneSegement=this._floatCountPerVertex *2;
			while (this._firstActiveElement !=this._firstNewElement){
				var index=this._firstActiveElement *_floatCountOneSegement+5;
				var particleAge=this._currentTime-this._vertices[index];
				if (particleAge < particleDuration)
					break ;
				this._vertices[index]=this._drawCounter;
				this._firstActiveElement++;
				if (this._firstActiveElement >=this.maxSegments)
					this._firstActiveElement=0;
			}
		}

		/**
		*@private
		*/
		__proto._freeRetiredGlitter=function(){
			var _floatCountOneSegement=this._floatCountPerVertex *2;
			while (this._firstRetiredElement !=this._firstActiveElement){
				var age=this._drawCounter-this._vertices[this._firstRetiredElement *_floatCountOneSegement+5];
				if (age < 3)
					break ;
				this._firstRetiredElement++;
				if (this._firstRetiredElement >=this.maxSegments)
					this._firstRetiredElement=0;
			}
		}

		/**
		*@private
		*/
		__proto._calcVelocity=function(left,right,out){
			Vector3.subtract(left,right,out);
			Vector3.scale(out,0.5,out);
		}

		/**
		*@private
		*/
		__proto._addNewGlitterSegementToVertexBuffer=function(){
			var start=0;
			if (this._firstActiveElement < this._firstFreeElement){
				start=this._firstActiveElement *2 *this._floatCountPerVertex;
				this._vertexBuffer.setData(this._vertices,start,start,(this._firstFreeElement-this._firstActiveElement)*2 *this._floatCountPerVertex);
				}else {
				start=this._firstActiveElement *2 *this._floatCountPerVertex;
				this._vertexBuffer.setData(this._vertices,start,start,(this.maxSegments-this._firstActiveElement)*2 *this._floatCountPerVertex);
				if (this._firstFreeElement > 0){
					this._vertexBuffer.setData(this._vertices,0,0,this._firstFreeElement *2 *this._floatCountPerVertex);
				}
			}
			this._firstNewElement=this._firstFreeElement;
		}

		/**
		*@private
		*/
		__proto._addGlitter=function(position0,position1,time){
			if (this._needPatch){
				this._needPatch=false;
				this._addGlitter(this._lastPatchAddPos0,this._lastPatchAddPos1,this._lastPatchAddTime);
			};
			var nextFreeParticle=this._firstFreeElement+1;
			if (nextFreeParticle >=this.maxSegments){
				nextFreeParticle=0;
				position0.cloneTo(this._lastPatchAddPos0);
				position1.cloneTo(this._lastPatchAddPos1);
				this._lastPatchAddTime=time;
				this._needPatch=true;
			}
			if (nextFreeParticle===this._firstRetiredElement)
				throw new Error("GlitterTemplet:current segement count have large than maxSegments,please adjust the  value of maxSegments or add Glitter Vertex Frequency.");
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

		/**
		*@private
		*更新闪光。
		*@param elapsedTime 间隔时间
		*/
		__proto._update=function(elapsedTime){
			this._currentTime+=elapsedTime / 1000;
			this._retireActiveGlitter();
			this._freeRetiredGlitter();
			if (this._firstActiveElement==this._firstFreeElement)
				this._currentTime=0;
			if (this._firstRetiredElement==this._firstActiveElement)
				this._drawCounter=0;
			this._updateTextureCoordinates();
		}

		//实时更新纹理坐标
		__proto._beforeRender=function(state){
			if (this._firstNewElement !=this._firstFreeElement){
				this._addNewGlitterSegementToVertexBuffer();
			}
			this._drawCounter++;
			if (this._firstActiveElement !=this._firstFreeElement){
				this._vertexBuffer.bindWithIndexBuffer(null);
				return true;
			}
			return false;
		}

		/**
		*@private
		*渲染闪光。
		*@param state 相关渲染状态
		*/
		__proto._render=function(state){
			var drawVertexCount=0;
			var glContext=WebGL.mainContext;
			if (this._firstActiveElement < this._firstFreeElement){
				drawVertexCount=(this._firstFreeElement-this._firstActiveElement)*2;
				glContext.drawArrays(/*laya.webgl.WebGLContext.TRIANGLE_STRIP*/0x0005,this._firstActiveElement *2,drawVertexCount);
				Stat.trianglesFaces+=drawVertexCount-2;
				Stat.drawCall++;
				}else {
				drawVertexCount=(this.maxSegments-this._firstActiveElement)*2;
				glContext.drawArrays(/*laya.webgl.WebGLContext.TRIANGLE_STRIP*/0x0005,this._firstActiveElement *2,drawVertexCount);
				Stat.trianglesFaces+=drawVertexCount-2;
				Stat.drawCall++;
				if (this._firstFreeElement > 0){
					drawVertexCount=this._firstFreeElement *2;
					glContext.drawArrays(/*laya.webgl.WebGLContext.TRIANGLE_STRIP*/0x0005,0,drawVertexCount);
					Stat.trianglesFaces+=drawVertexCount-2;
					Stat.drawCall++;
				}
			}
		}

		/**
		*通过位置添加刀光。
		*@param position0 位置0。
		*@param position1 位置1。
		*/
		__proto.addVertexPosition=function(position0,position1){
			if (this._owner.enable){
				if (this._numPositionMode < 2){
					if (this._numPositionMode===0){
						position0.cloneTo(this._posModeLastPosition0);
						position1.cloneTo(this._posModeLastPosition1);
						}else {
						position0.cloneTo(this._posModePosition0);
						position1.cloneTo(this._posModePosition1);
					}
					this._numPositionMode++;
					}else {
					var v0=this._tempVector2;
					this._calcVelocity(position0,this._posModeLastPosition0,v0);
					var v1=this._tempVector3;
					this._calcVelocity(position1,this._posModeLastPosition1,v1);
					this.addVertexPositionVelocity(this._posModePosition0,v0,this._posModePosition1,v1);
					this._posModePosition0.cloneTo(this._posModeLastPosition0);
					this._posModePosition1.cloneTo(this._posModeLastPosition1);
					position0.cloneTo(this._posModePosition0);
					position1.cloneTo(this._posModePosition1);
				}
			}
		}

		/**
		*通过位置和速度添加刀光。
		*@param position0 位置0。
		*@param velocity0 速度0。
		*@param position1 位置1。
		*@param velocity1 速度1。
		*/
		__proto.addVertexPositionVelocity=function(position0,velocity0,position1,velocity1){
			if (this._owner.enable){
				if (this._numPositionVelocityMode===0){
					this._numPositionVelocityMode++;
					}else {
					var d=this._tempVector0;
					Vector3.subtract(position0,this._posVelModePosition0,d);
					var distance0=Vector3.scalarLength(d);
					Vector3.subtract(position1,this._posVelModePosition1,d);
					var distance1=Vector3.scalarLength(d);
					var slerpCount=0;
					var minSegmentDistance=minSegmentDistance;
					if (distance0 < minSegmentDistance && distance1 < minSegmentDistance)
						return;
					slerpCount=1+Math.floor(Math.max(distance0,distance1)/ this.minInterpDistance);
					if (slerpCount===1){
						this._addGlitter(position0,position1,this._currentTime);
						}else {
						slerpCount=Math.min(slerpCount,this.maxSlerpCount);
						this.scLeft.Init(this._posVelModePosition0,this._posVelModeVelocity0,position0,velocity0);
						this.scRight.Init(this._posVelModePosition1,this._posVelModeVelocity1,position1,velocity1);
						var segment=1.0 / slerpCount;
						var addSegment=segment;
						var timeOffset=this._currentTime-this._lastTime;
						for (var i=1;i <=slerpCount;i++){
							var pos0=this._tempVector0;
							this.scLeft.Slerp(addSegment,pos0);
							var pos1=this._tempVector1;
							this.scRight.Slerp(addSegment,pos1);
							var time=this._lastTime+timeOffset *i / slerpCount;
							this._addGlitter(pos0,pos1,time);
							addSegment+=segment;
						}
					}
				}
				this._lastTime=this._currentTime;
				position0.cloneTo(this._posVelModePosition0);
				velocity0.cloneTo(this._posVelModeVelocity0);
				position1.cloneTo(this._posVelModePosition1);
				velocity1.cloneTo(this._posVelModeVelocity1);
			}
		}

		__proto.dispose=function(){
			this._owner.off(/*laya.events.Event.ENABLED_CHANGED*/"enabledchanged",this,this._onEnableChanged);
		}

		/**设置最大分段数,注意:谨慎修改此属性，有性能损耗。*/
		/**获取最大分段数。*/
		__getset(0,__proto,'maxSegments',function(){
			return this._maxSegments-1;
			},function(value){
			var newMaxSegments=value+1;
			if (newMaxSegments!==this._maxSegments){
				this._maxSegments=newMaxSegments;
				if (this._vertexBuffer){
					this._vertexBuffer.dispose();
				}
				this._initialize();
			}
		});

		__getset(0,__proto,'indexOfHost',function(){
			return 0;
		});

		__getset(0,__proto,'_vertexBufferCount',function(){
			return 1;
		});

		__getset(0,__proto,'triangleCount',function(){
			var drawVertexCount=0;
			if (this._firstActiveElement < this._firstFreeElement){
				drawVertexCount=(this._firstFreeElement-this._firstActiveElement)*2-2;
				}else {
				drawVertexCount=(this.maxSegments-this._firstActiveElement)*2-2;
				drawVertexCount+=this._firstFreeElement *2-2;
			}
			return drawVertexCount;
		});

		return GlitterTemplet;
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
	*<code>BoxShape</code> 类用于创建球形粒子形状。
	*/
	//class laya.d3.core.particleShuriKen.module.shape.BoxShape extends laya.d3.core.particleShuriKen.module.shape.BaseShape
	var BoxShape=(function(_super){
		function BoxShape(){
			this.x=NaN;
			this.y=NaN;
			this.z=NaN;
			this.randomDirection=false;
			BoxShape.__super.call(this);
			this.x=1.0;
			this.y=1.0;
			this.z=1.0;
			this.randomDirection=false;
		}

		__class(BoxShape,'laya.d3.core.particleShuriKen.module.shape.BoxShape',_super);
		var __proto=BoxShape.prototype;
		/**
		*用于生成粒子初始位置和方向。
		*@param position 粒子位置。
		*@param direction 粒子方向。
		*/
		__proto.generatePositionAndDirection=function(position,direction){
			var rpE=position.elements;
			var rdE=direction.elements;
			ShapeUtils._randomPointInsideHalfUnitBox(position);
			rpE[0]=this.x *rpE[0];
			rpE[1]=this.y *rpE[0];
			rpE[2]=this.z *rpE[0];
			if (this.randomDirection){
				ShapeUtils._randomPointUnitSphere(direction);
				}else {
				rdE[0]=0.0;
				rdE[1]=0.0;
				rdE[2]=-1.0;
			}
		}

		return BoxShape;
	})(BaseShape)


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
			ShaderDefines3D.reg("FSHIGHPRECISION",0x80);
			ShaderDefines3D.reg("DIFFUSEMAP",0x1);
			ShaderDefines3D.reg("NORMALMAP",0x2);
			ShaderDefines3D.reg("SPECULARMAP",0x4);
			ShaderDefines3D.reg("EMISSIVEMAP",0x8);
			ShaderDefines3D.reg("AMBIENTMAP",0x10);
			ShaderDefines3D.reg("REFLECTMAP",0x20);
			ShaderDefines3D.reg("PARTICLE3D",0x40000);
			ShaderDefines3D.reg("COLOR",0x800);
			ShaderDefines3D.reg("UV",0x400);
			ShaderDefines3D.reg("SKINNED",0x10000);
			ShaderDefines3D.reg("DIRECTIONLIGHT",0x1000);
			ShaderDefines3D.reg("POINTLIGHT",0x2000);
			ShaderDefines3D.reg("SPOTLIGHT",0x4000);
			ShaderDefines3D.reg("BONE",0x8000);
			ShaderDefines3D.reg("ALPHATEST",0x20000);
			ShaderDefines3D.reg("UVTRANSFORM",0x100);
			ShaderDefines3D.reg("FOG",0x200);
			ShaderDefines3D.reg("VR",0x40);
			ShaderDefines3D.reg("SPHERHBILLBOARD",0x80000);
			ShaderDefines3D.reg("STRETCHEDBILLBOARD",0x100000);
			ShaderDefines3D.reg("HORIZONTALBILLBOARD",0x200000);
			ShaderDefines3D.reg("VERTICALBILLBOARD",0x400000);
			ShaderDefines3D.reg("COLOROVERLIFETIME",0x800000);
			ShaderDefines3D.reg("RANDOMCOLOROVERLIFETIME",0x1000000);
			ShaderDefines3D.reg("SIZEOVERLIFETIME",0x2000000);
			ShaderDefines3D.reg("ROTATIONOVERLIFETIME",0x4000000);
			ShaderDefines3D.reg("TEXTURESHEETANIMATION",0x8000000);
			ShaderDefines3D.reg("VELOCITYOVERLIFETIME",0x10000000);
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

		ShaderDefines3D.FSHIGHPRECISION=0x80;
		ShaderDefines3D.VR=0x40;
		ShaderDefines3D.FOG=0x200;
		ShaderDefines3D.DIRECTIONLIGHT=0x1000;
		ShaderDefines3D.POINTLIGHT=0x2000;
		ShaderDefines3D.SPOTLIGHT=0x4000;
		ShaderDefines3D.DIFFUSEMAP=0x1;
		ShaderDefines3D.NORMALMAP=0x2;
		ShaderDefines3D.SPECULARMAP=0x4;
		ShaderDefines3D.EMISSIVEMAP=0x8;
		ShaderDefines3D.AMBIENTMAP=0x10;
		ShaderDefines3D.REFLECTMAP=0x20;
		ShaderDefines3D.UVTRANSFORM=0x100;
		ShaderDefines3D.UV=0x400;
		ShaderDefines3D.COLOR=0x800;
		ShaderDefines3D.BONE=0x8000;
		ShaderDefines3D.SKINNED=0x10000;
		ShaderDefines3D.ALPHATEST=0x20000;
		ShaderDefines3D.PARTICLE3D=0x40000;
		ShaderDefines3D.SPHERHBILLBOARD=0x80000;
		ShaderDefines3D.STRETCHEDBILLBOARD=0x100000;
		ShaderDefines3D.HORIZONTALBILLBOARD=0x200000;
		ShaderDefines3D.VERTICALBILLBOARD=0x400000;
		ShaderDefines3D.COLOROVERLIFETIME=0x800000;
		ShaderDefines3D.RANDOMCOLOROVERLIFETIME=0x1000000;
		ShaderDefines3D.SIZEOVERLIFETIME=0x2000000;
		ShaderDefines3D.ROTATIONOVERLIFETIME=0x4000000;
		ShaderDefines3D.TEXTURESHEETANIMATION=0x8000000;
		ShaderDefines3D.VELOCITYOVERLIFETIME=0x10000000;
		ShaderDefines3D._name2int={};
		ShaderDefines3D._int2name=[];
		ShaderDefines3D._int2nameMap=[];
		return ShaderDefines3D;
	})(ShaderDefines)


	/**
	*<code>CircleShape</code> 类用于创建环形粒子形状。
	*/
	//class laya.d3.core.particleShuriKen.module.shape.CircleShape extends laya.d3.core.particleShuriKen.module.shape.BaseShape
	var CircleShape=(function(_super){
		function CircleShape(){
			this.radius=NaN;
			this.arc=NaN;
			this.emitFromEdge=false;
			this.randomDirection=false;
			CircleShape.__super.call(this);
			this.radius=1.0;
			this.arc=360.0 / 180.0 *Math.PI;
			this.emitFromEdge=false;
			this.randomDirection=false;
		}

		__class(CircleShape,'laya.d3.core.particleShuriKen.module.shape.CircleShape',_super);
		var __proto=CircleShape.prototype;
		/**
		*用于生成粒子初始位置和方向。
		*@param position 粒子位置。
		*@param direction 粒子方向。
		*/
		__proto.generatePositionAndDirection=function(position,direction){
			var rpE=position.elements;
			var positionPointE=CircleShape._tempPositionPoint.elements;
			if (this.emitFromEdge)
				ShapeUtils._randomPointUnitArcCircle(this.arc,CircleShape._tempPositionPoint);
			else
			ShapeUtils._randomPointInsideUnitArcCircle(this.arc,CircleShape._tempPositionPoint);
			rpE[0]=positionPointE[0];
			rpE[1]=positionPointE[1];
			rpE[2]=0;
			Vector3.scale(position,this.radius,position);
			if (this.randomDirection){
				ShapeUtils._randomPointUnitSphere(direction);
				}else {
				position.cloneTo(direction);
			}
		}

		__static(CircleShape,
		['_tempPositionPoint',function(){return this._tempPositionPoint=new Vector2();}
		]);
		return CircleShape;
	})(BaseShape)


	/**
	*<code>ConeShape</code> 类用于创建锥形粒子形状。
	*/
	//class laya.d3.core.particleShuriKen.module.shape.ConeShape extends laya.d3.core.particleShuriKen.module.shape.BaseShape
	var ConeShape=(function(_super){
		function ConeShape(){
			this.angle=NaN;
			this.radius=NaN;
			this.length=NaN;
			this.emitType=0;
			this.randomDirection=false;
			ConeShape.__super.call(this);
			this.angle=25.0 / 180.0 *Math.PI;
			this.radius=1.0;
			this.length=5.0;
			this.emitType=0;
			this.randomDirection=false;
		}

		__class(ConeShape,'laya.d3.core.particleShuriKen.module.shape.ConeShape',_super);
		var __proto=ConeShape.prototype;
		/**
		*用于生成粒子初始位置和方向。
		*@param position 粒子位置。
		*@param direction 粒子方向。
		*/
		__proto.generatePositionAndDirection=function(position,direction){
			var rpE=position.elements;
			var rdE=direction.elements;
			var positionPointE=ConeShape._tempPositionPoint.elements;
			var positionX=NaN;
			var positionY=NaN;
			var directionPointE;
			var dirCosA=Math.cos(this.angle);
			var dirSinA=Math.sin(this.angle);
			switch (this.emitType){
				case 0:
					ShapeUtils._randomPointInsideUnitCircle(ConeShape._tempPositionPoint);
					positionX=positionPointE[0];
					positionY=positionPointE[1];
					rpE[0]=positionX *this.radius;
					rpE[1]=positionY *this.radius;
					rpE[2]=0;
					if (this.randomDirection){
						ShapeUtils._randomPointInsideUnitCircle(ConeShape._tempDirectionPoint);
						directionPointE=ConeShape._tempDirectionPoint.elements;
						rdE[0]=directionPointE[0] *dirSinA;
						rdE[1]=directionPointE[1] *dirSinA;
						}else {
						rdE[0]=positionX *dirSinA;
						rdE[1]=positionY *dirSinA;
					}
					rdE[2]=-dirCosA;
					break ;
				case 1:
					ShapeUtils._randomPointUnitCircle(ConeShape._tempPositionPoint);
					positionX=positionPointE[0];
					positionY=positionPointE[1];
					rpE[0]=positionX *this.radius;
					rpE[1]=positionY *this.radius;
					rpE[2]=0;
					if (this.randomDirection){
						ShapeUtils._randomPointInsideUnitCircle(ConeShape._tempDirectionPoint);
						directionPointE=ConeShape._tempDirectionPoint.elements;
						rdE[0]=directionPointE[0] *dirSinA;
						rdE[1]=directionPointE[1] *dirSinA;
						}else {
						rdE[0]=positionX *dirSinA;
						rdE[1]=positionY *dirSinA;
					}
					rdE[2]=-dirCosA;
					break ;
				case 2:
					ShapeUtils._randomPointInsideUnitCircle(ConeShape._tempPositionPoint);
					positionX=positionPointE[0];
					positionY=positionPointE[1];
					rpE[0]=positionX *this.radius;
					rpE[1]=positionY *this.radius;
					rpE[2]=0;
					rdE[0]=positionX *dirSinA;
					rdE[1]=positionY *dirSinA;
					rdE[2]=-dirCosA;
					Vector3.normalize(direction,direction);
					Vector3.scale(direction,this.length *Math.random(),direction);
					Vector3.add(position,direction,position);
					if (this.randomDirection)
						ShapeUtils._randomPointUnitSphere(direction);
					break ;
				case 3:
					ShapeUtils._randomPointUnitCircle(ConeShape._tempPositionPoint);
					positionX=positionPointE[0];
					positionY=positionPointE[1];
					rpE[0]=positionX *this.radius;
					rpE[1]=positionY *this.radius;
					rpE[2]=0;
					rdE[0]=positionX *dirSinA;
					rdE[1]=positionY *dirSinA;
					rdE[2]=-dirCosA;
					Vector3.normalize(direction,direction);
					Vector3.scale(direction,this.length *Math.random(),direction);
					Vector3.add(position,direction,position);
					if (this.randomDirection)
						ShapeUtils._randomPointUnitSphere(direction);
					break ;
				default :
					throw new Error("ConeShape:emitType is invalid.");
				}
		}

		__static(ConeShape,
		['_tempPositionPoint',function(){return this._tempPositionPoint=new Vector2();},'_tempDirectionPoint',function(){return this._tempDirectionPoint=new Vector2();}
		]);
		return ConeShape;
	})(BaseShape)


	/**
	*<code>HemisphereShape</code> 类用于创建半球形粒子形状。
	*/
	//class laya.d3.core.particleShuriKen.module.shape.HemisphereShape extends laya.d3.core.particleShuriKen.module.shape.BaseShape
	var HemisphereShape=(function(_super){
		function HemisphereShape(){
			this.radius=NaN;
			this.emitFromShell=false;
			this.randomDirection=false;
			HemisphereShape.__super.call(this);
			this.radius=1.0;
			this.emitFromShell=false;
			this.randomDirection=false;
		}

		__class(HemisphereShape,'laya.d3.core.particleShuriKen.module.shape.HemisphereShape',_super);
		var __proto=HemisphereShape.prototype;
		/**
		*用于生成粒子初始位置和方向。
		*@param position 粒子位置。
		*@param direction 粒子方向。
		*/
		__proto.generatePositionAndDirection=function(position,direction){
			var rpE=position.elements;
			if (this.emitFromShell)
				ShapeUtils._randomPointUnitSphere(position);
			else
			ShapeUtils._randomPointInsideUnitSphere(position);
			Vector3.scale(position,this.radius,position);
			var z=rpE[2];
			(z > 0.0)&& (rpE[2]=z *-1.0);
			if (this.randomDirection){
				ShapeUtils._randomPointUnitSphere(direction);
				}else {
				position.cloneTo(direction);
			}
		}

		return HemisphereShape;
	})(BaseShape)


	/**
	*<code>SphereShape</code> 类用于创建球形粒子形状。
	*/
	//class laya.d3.core.particleShuriKen.module.shape.SphereShape extends laya.d3.core.particleShuriKen.module.shape.BaseShape
	var SphereShape=(function(_super){
		function SphereShape(){
			this.radius=NaN;
			this.emitFromShell=false;
			this.randomDirection=false;
			SphereShape.__super.call(this);
			this.radius=1.0;
			this.emitFromShell=false;
			this.randomDirection=false;
		}

		__class(SphereShape,'laya.d3.core.particleShuriKen.module.shape.SphereShape',_super);
		var __proto=SphereShape.prototype;
		/**
		*用于生成粒子初始位置和方向。
		*@param position 粒子位置。
		*@param direction 粒子方向。
		*/
		__proto.generatePositionAndDirection=function(position,direction){
			if (this.emitFromShell)
				ShapeUtils._randomPointUnitSphere(position);
			else
			ShapeUtils._randomPointInsideUnitSphere(position);
			Vector3.scale(position,this.radius,position);
			if (this.randomDirection){
				ShapeUtils._randomPointUnitSphere(direction);
				}else {
				position.cloneTo(direction);
			}
		}

		return SphereShape;
	})(BaseShape)


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
			(name)? (this.name=name):(this.name="Sprite3D-"+Sprite3D._nameNumberCounter++);
			this._enable=true;
			this._id=++Sprite3D._uniqueIDCounter;
			this.layer=Layer.currentCreationLayer;
			this.transform=new Transform3D(this);
			this.on(/*laya.events.Event.ADDED*/"added",this,this._onAdded);
			this.on(/*laya.events.Event.REMOVED*/"removed",this,this._onRemoved);
		}

		__class(Sprite3D,'laya.d3.core.Sprite3D',_super);
		var __proto=Sprite3D.prototype;
		Laya.imps(__proto,{"laya.d3.core.render.IUpdate":true,"laya.resource.ICreateResource":true,"laya.d3.core.IClone":true})
		/**
		*@private
		*/
		__proto._onAdded=function(){
			this.transform.parent=(this._parent).transform;
			if (Laya.stage.contains(this)){
				this._addSelfAndChildrenRenderObjects();
			}
		}

		/**
		*@private
		*/
		__proto._onRemoved=function(){
			this.transform.parent=null;
			if (Laya.stage.contains(this)){
				this._clearSelfAndChildrenRenderObjects();
			}
		}

		/**
		*清理自身渲染物体，请重载此函数。
		*/
		__proto._clearSelfRenderObjects=function(){}
		/**
		*添加自身渲染物体，请重载此函数。
		*/
		__proto._addSelfRenderObjects=function(){}
		/**
		*清理自身和子节点渲染物体,重写此函数。
		*/
		__proto._clearSelfAndChildrenRenderObjects=function(){
			this._clearSelfRenderObjects();
			for (var i=0,n=this._childs.length;i < n;i++)
			(this._childs [i])._clearSelfAndChildrenRenderObjects();
		}

		/**
		*添加自身和子节点渲染物体,重写此函数。
		*/
		__proto._addSelfAndChildrenRenderObjects=function(){
			this._addSelfRenderObjects();
			for (var i=0,n=this._childs.length;i < n;i++)
			(this._childs [i])._addSelfAndChildrenRenderObjects();
		}

		/**
		*更新组件update函数。
		*@param state 渲染相关状态。
		*/
		__proto._updateComponents=function(state){
			for (var i=0,n=this._components.length;i < n;i++){
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
			return renderElement._getVertexBuffer().vertexDeclaration.id+material.id */*laya.d3.graphics.VertexDeclaration._maxVertexDeclarationBit*/1000;
		}

		/**
		*更新
		*@param state 渲染相关状态
		*/
		__proto._update=function(state){
			state.owner=this;
			if (this._enable){
				this._updateComponents(state);
				this._lateUpdateComponents(state);
			}
			Stat.spriteCount++;
			this._childs.length && this._updateChilds(state);
		}

		/**
		*加载层级文件，并作为该节点的子节点。
		*@param url
		*/
		__proto.loadHierarchy=function(url){
			this.addChild(laya.d3.core.Sprite3D.load(url));
		}

		__proto.addChildAt=function(node,index){
			if (!((node instanceof laya.d3.core.Sprite3D )))
				throw new Error("Sprite3D:Node type must Sprite3D.");
			return _super.prototype.addChildAt.call(this,node,index);
		}

		__proto.addChild=function(node){
			if (!((node instanceof laya.d3.core.Sprite3D )))
				throw new Error("Sprite3D:Node type must Sprite3D.");
			return _super.prototype.addChild.call(this,node);
		}

		/**
		*添加指定类型组件。
		*@param type 组件类型。
		*@return 组件。
		*/
		__proto.addComponent=function(type){
			if (this._componentsMap.indexOf(type)!==-1)
				throw new Error("无法创建"+type+"组件"+"，"+type+"组件已存在！");
			var component=ClassUtils.getInstance(type);
			component._initialize(this);
			this._componentsMap.push(type);
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
			var index=this._componentsMap.indexOf(type);
			if (index===-1)
				return null;
			return this._components[index];
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
			var index=this._componentsMap.indexOf(type);
			if (index===-1)
				return;
			var component=this._components[index];
			this._components.splice(index,1);
			this._componentsMap.splice(index,1);
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
		*@private
		*/
		__proto.onAsynLoaded=function(url,data){
			var preBasePath=URL.basePath;
			URL.basePath=URL.getPath(URL.formatURL(url));
			ClassUtils.createByJson(data,this,this,Handler.create(null,Utils3D._parseHierarchyProp,null,false),Handler.create(null,Utils3D._parseHierarchyNode,null,false));
			URL.basePath=preBasePath;
			this.event(/*laya.events.Event.HIERARCHY_LOADED*/"hierarchyloaded",[this]);
		}

		__proto.cloneTo=function(destObject){
			var destSprite3D=destObject;
			destSprite3D.name=this.name+"(clone)";
			destSprite3D.destroyed=this.destroyed;
			destSprite3D.timer=this.timer;
			destSprite3D._displayedInStage=this._displayedInStage;
			destSprite3D._$P=this._$P;
			destSprite3D._enable=this._enable;
			destSprite3D._layerMask=this._layerMask;
			destSprite3D.transform.localMatrix=this.transform.localMatrix;
			destSprite3D.isStatic=this.isStatic;
			var i=0,n=0;
			for (i=0,n=this._componentsMap.length;i < n;i++)
			destSprite3D.addComponent(this._componentsMap[i]);
			for (i=0,n=this._childs.length;i < n;i++)
			destSprite3D.addChild(this._childs[i].clone());
		}

		__proto.clone=function(){
			var destSprite3D=/*__JS__ */new this.constructor();
			this.cloneTo(destSprite3D);
			return destSprite3D;
		}

		/**
		*<p>销毁此对象。</p>
		*@param destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
		*/
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			_super.prototype.destroy.call(this,destroyChild);
			for (var i=0,n=this._components.length;i < n;i++)
			this._components[i]._uninitialize();
			this._components=null;
			this._componentsMap=null;
			this.transform=null;
		}

		/**
		*获得组件的数量。
		*@return 组件数量。
		*/
		__getset(0,__proto,'componentsCount',function(){
			return this._components.length;
		});

		/**
		*获取唯一标识ID。
		*@return 唯一标识ID。
		*/
		__getset(0,__proto,'id',function(){
			return this._id;
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
			this.event(/*laya.events.Event.LAYER_CHANGED*/"layerchanged",value);
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
			if (this._enable!==value){
				this._enable=value;
				this.event(/*laya.events.Event.ENABLED_CHANGED*/"enabledchanged",this._enable);
			}
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
		*获得所属场景。
		*@return 场景。
		*/
		__getset(0,__proto,'scene',function(){
			return this.parent ? (this.parent).scene :null;
		});

		Sprite3D.instantiate=function(original,position,rotation,parent,worldPositionStays){
			(worldPositionStays===void 0)&& (worldPositionStays=true);
			var destSprite3D=original.clone();
			var transform;
			if (position || rotation){
				(parent)&& (parent.addChild(destSprite3D));
				transform=destSprite3D.transform;
				(position)&& (transform.position=position);
				(rotation)&& (transform.rotation=rotation);
				}else {
				if (worldPositionStays){
					transform=destSprite3D.transform;
					if (parent){
						var oriPosition=transform.position;
						var oriRotation=transform.rotation;
						parent.addChild(destSprite3D);
						transform.position=oriPosition;
						transform.rotation=oriRotation;
					}
					}else {
					if (parent){
						parent.addChild(destSprite3D);
					}
				}
			}
			return destSprite3D;
		}

		Sprite3D.load=function(url){
			return Laya.loader.create(url,null,null,Sprite3D,1,false);
		}

		Sprite3D._uniqueIDCounter=0;
		Sprite3D._nameNumberCounter=0;
		return Sprite3D;
	})(Node)


	/**
	*<code>BaseMaterial</code> 类用于创建材质,抽象类,不允许实例。
	*/
	//class laya.d3.core.material.BaseMaterial extends laya.resource.Resource
	var BaseMaterial=(function(_super){
		function BaseMaterial(){
			this._renderQueue=0;
			this._renderMode=0;
			this._sharderNameID=0;
			this._shaderDefine=0;
			this._disableShaderDefine=0;
			this._shaderValues=null;
			this._textures=null;
			this._colors=null;
			this._numbers=null;
			this._matrix4x4s=null;
			this._textureSharderIndices=null;
			this._colorSharderIndices=null;
			this._numberSharderIndices=null;
			this._matrix4x4SharderIndices=null;
			this._isInstance=false;
			this.shader=null;
			BaseMaterial.__super.call(this);
			this._loaded=true;
			this._isInstance=false;
			this._shaderDefine=0;
			this._disableShaderDefine=0;
			this._shaderValues=new ValusArray();
			this._textures=[];
			this._colors=[];
			this._numbers=[];
			this._matrix4x4s=[];
			this._textureSharderIndices=[];
			this._colorSharderIndices=[];
			this._numberSharderIndices=[];
			this._matrix4x4SharderIndices=[];
			this.renderMode=1;
		}

		__class(BaseMaterial,'laya.d3.core.material.BaseMaterial',_super);
		var __proto=BaseMaterial.prototype;
		Laya.imps(__proto,{"laya.d3.core.IClone":true})
		/**
		*@private
		*/
		__proto._uploadTextures=function(){
			for (var i=0,n=this._textures.length;i < n;i++){
				var texture=this._textures[i];
				if (texture){
					var source=texture.source;
					(source)? this._uploadTexture(i,source):this._uploadTexture(i,SolidColorTexture2D.grayTexture.source);
				}
			}
		}

		/**
		*获取Shader。
		*@param state 相关渲染状态。
		*@return Shader。
		*/
		__proto._getShader=function(state,vertexDeclaration){
			var shaderDefs=state.shaderDefs;
			var shaderDefsValue=state.shaderDefs._value;
			shaderDefsValue |=vertexDeclaration.shaderDefine | this._shaderDefine;
			this._disableShaderDefine && (shaderDefsValue=shaderDefsValue & (~this._disableShaderDefine));
			shaderDefs._value=shaderDefsValue;
			var nameID=shaderDefs._value+this._sharderNameID */*laya.webgl.shader.Shader.SHADERNAME2ID*/0.0002;
			this.shader=Shader.withCompile(this._sharderNameID,shaderDefs.toNameDic(),nameID,null);
		}

		/**
		*@private
		*/
		__proto._uploadTexture=function(shaderIndex,textureSource){
			this._shaderValues.data[this._textureSharderIndices[shaderIndex]]=textureSource;
		}

		/**
		*增加Shader宏定义。
		*@param value 宏定义。
		*/
		__proto._addShaderDefine=function(value){
			this._shaderDefine |=value;
		}

		/**
		*移除Shader宏定义。
		*@param value 宏定义。
		*/
		__proto._removeShaderDefine=function(value){
			this._shaderDefine &=~value;
		}

		/**
		*增加禁用宏定义。
		*@param value 宏定义。
		*/
		__proto._addDisableShaderDefine=function(value){
			this._disableShaderDefine |=value;
		}

		/**
		*移除禁用宏定义。
		*@param value 宏定义。
		*/
		__proto._removeDisableShaderDefine=function(value){
			this._disableShaderDefine &=~value;
		}

		__proto._setMatrix4x4=function(matrix4x4Index,shaderName,matrix4x4){
			var shaderValue=this._shaderValues;
			var index=this._matrix4x4SharderIndices[matrix4x4Index];
			if (!index && matrix4x4){
				this._matrix4x4SharderIndices[matrix4x4Index]=index=shaderValue.length+1;
				shaderValue.pushValue(shaderName,null);
			}
			shaderValue.data[index]=matrix4x4.elements;
			this._matrix4x4s[matrix4x4Index]=matrix4x4;
		}

		__proto._getMatrix4x4=function(matrix4x4Index){
			return this._matrix4x4s[matrix4x4Index];
		}

		__proto._setNumber=function(numberIndex,shaderName,number){
			var shaderValue=this._shaderValues;
			var index=this._numberSharderIndices[numberIndex];
			if (!index && number){
				this._numberSharderIndices[numberIndex]=index=shaderValue.length+1;
				shaderValue.pushValue(shaderName,null);
			}
			shaderValue.data[index]=number;
			this._numbers[numberIndex]=number;
		}

		__proto._getNumber=function(numberIndex){
			return this._numbers[numberIndex];
		}

		__proto._setColor=function(colorIndex,shaderName,color){
			var shaderValue=this._shaderValues;
			var index=this._colorSharderIndices[colorIndex];
			if (!index && color){
				this._colorSharderIndices[colorIndex]=index=shaderValue.length+1;
				shaderValue.pushValue(shaderName,null);
			}
			shaderValue.data[index]=color.elements;
			this._colors[colorIndex]=color;
		}

		__proto._getColor=function(colorIndex){
			return this._colors[colorIndex];
		}

		/**
		*设置纹理。
		*/
		__proto._setTexture=function(texture,textureIndex,shaderName){
			var shaderValue=this._shaderValues;
			var index=this._textureSharderIndices[textureIndex];
			if (!index && texture){
				this._textureSharderIndices[textureIndex]=index=shaderValue.length+1;
				shaderValue.pushValue(shaderName,null);
			}
			this._textures[textureIndex]=texture;
		}

		/**
		*获取纹理。
		*/
		__proto._getTexture=function(textureIndex){
			return this._textures[textureIndex];
		}

		/**
		*上传材质。
		*@param state 相关渲染状态。
		*@param bufferUsageShader Buffer相关绑定。
		*@param shader 着色器。
		*@return 是否成功。
		*/
		__proto._upload=function(state,vertexDeclaration,bufferUsageShader){
			this._uploadTextures();
			this._getShader(state,vertexDeclaration);
			var shaderValue=state.shaderValue;
			shaderValue.pushArray(this._shaderValues);
			this.shader.uploadArray(shaderValue.data,shaderValue.length,bufferUsageShader);
		}

		__proto._setLoopShaderParams=function(state,projectionView,worldMatrix,mesh,material){
			throw new Error("Marterial:must override it.");
		}

		/**
		*@private
		*/
		__proto.onAsynLoaded=function(url,data){
			var preBasePath=URL.basePath;
			URL.basePath=URL.getPath(URL.formatURL(url));
			var customHandler=Handler.create(null,Utils3D._parseMaterial,null,false);
			ClassUtils.createByJson(data,this,null,customHandler);
			customHandler.recover();
			URL.basePath=preBasePath;
			this.event(/*laya.events.Event.LOADED*/"loaded",this);
		}

		/**
		*设置使用Shader名字。
		*@param name 名称。
		*/
		__proto.setShaderName=function(name){
			this._sharderNameID=Shader.nameKey.get(name);
		}

		/**
		*克隆。
		*@param destObject 克隆源。
		*/
		__proto.cloneTo=function(destObject){
			var destBaseMaterial=destObject;
			destBaseMaterial._loaded=this._loaded;
			destBaseMaterial._renderQueue=this._renderQueue;
			destBaseMaterial._renderMode=this._renderMode;
			destBaseMaterial._textures=this._textures.slice();
			destBaseMaterial._colors=this._colors.slice();
			destBaseMaterial._numbers=this._numbers.slice();
			destBaseMaterial._matrix4x4s=this._matrix4x4s.slice();
			destBaseMaterial._textureSharderIndices=this._textureSharderIndices.slice();
			destBaseMaterial._colorSharderIndices=this._colorSharderIndices.slice();
			destBaseMaterial._numberSharderIndices=this._numberSharderIndices.slice();
			destBaseMaterial.shader=this.shader;
			destBaseMaterial._sharderNameID=this._sharderNameID;
			destBaseMaterial._disableShaderDefine=this._disableShaderDefine;
			destBaseMaterial._shaderDefine=this._shaderDefine;
			destBaseMaterial.name=this.name;
			this._shaderValues.copyTo(destBaseMaterial._shaderValues);
		}

		/**
		*克隆。
		*@return 克隆副本。
		*/
		__proto.clone=function(){
			var destBaseMaterial=/*__JS__ */new this.constructor();
			this.cloneTo(destBaseMaterial);
			return destBaseMaterial;
		}

		__proto.dispose=function(){
			this.resourceManager.removeResource(this);
			_super.prototype.dispose.call(this);
		}

		/**
		*获取所属渲染队列。
		*@return 渲染队列。
		*/
		__getset(0,__proto,'renderQueue',function(){
			return this._renderQueue;
		});

		/**
		*设置渲染模式。
		*@return 渲染模式。
		*/
		/**
		*获取渲染状态。
		*@return 渲染状态。
		*/
		__getset(0,__proto,'renderMode',function(){
			return this._renderMode;
			},function(value){
			this._renderMode=value;
			switch (value){
				case 1:
					this._renderQueue=/*laya.d3.core.render.RenderQueue.OPAQUE*/1;
					this.event(/*laya.events.Event.RENDERQUEUE_CHANGED*/"renderqueuechanged",this);
					break ;
				case 2:
					this._renderQueue=/*laya.d3.core.render.RenderQueue.OPAQUE_DOUBLEFACE*/2;
					this.event(/*laya.events.Event.RENDERQUEUE_CHANGED*/"renderqueuechanged",this);
					break ;
				case 3:
					this._renderQueue=/*laya.d3.core.render.RenderQueue.OPAQUE*/1;
					this.event(/*laya.events.Event.RENDERQUEUE_CHANGED*/"renderqueuechanged",this);
					break ;
				case 4:
					this._renderQueue=/*laya.d3.core.render.RenderQueue.OPAQUE_DOUBLEFACE*/2;
					this.event(/*laya.events.Event.RENDERQUEUE_CHANGED*/"renderqueuechanged",this);
					break ;
				case 13:
					this._renderQueue=/*laya.d3.core.render.RenderQueue.ALPHA_BLEND*/3;
					this.event(/*laya.events.Event.RENDERQUEUE_CHANGED*/"renderqueuechanged",this);
					break ;
				case 14:
					this._renderQueue=/*laya.d3.core.render.RenderQueue.ALPHA_BLEND_DOUBLEFACE*/4;
					this.event(/*laya.events.Event.RENDERQUEUE_CHANGED*/"renderqueuechanged",this);
					break ;
				case 15:
					this._renderQueue=/*laya.d3.core.render.RenderQueue.ALPHA_ADDTIVE_BLEND*/5;
					this.event(/*laya.events.Event.RENDERQUEUE_CHANGED*/"renderqueuechanged",this);
					break ;
				case 16:
					this._renderQueue=/*laya.d3.core.render.RenderQueue.ALPHA_ADDTIVE_BLEND_DOUBLEFACE*/6;
					this.event(/*laya.events.Event.RENDERQUEUE_CHANGED*/"renderqueuechanged",this);
					break ;
				case 5:
					this._renderQueue=/*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND*/7;
					this.event(/*laya.events.Event.RENDERQUEUE_CHANGED*/"renderqueuechanged",this);
					break ;
				case 6:
					this._renderQueue=/*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE*/8;
					this.event(/*laya.events.Event.RENDERQUEUE_CHANGED*/"renderqueuechanged",this);
					break ;
				case 7:
					this._renderQueue=/*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND*/9;
					this.event(/*laya.events.Event.RENDERQUEUE_CHANGED*/"renderqueuechanged",this);
					break ;
				case 8:
					this._renderQueue=/*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE*/10;
					this.event(/*laya.events.Event.RENDERQUEUE_CHANGED*/"renderqueuechanged",this);
					break ;
				case 9:
					this._renderQueue=/*laya.d3.core.render.RenderQueue.NONDEPTH_ALPHA_BLEND*/11;
					this.event(/*laya.events.Event.RENDERQUEUE_CHANGED*/"renderqueuechanged",this);
					break ;
				case 10:
					this._renderQueue=/*laya.d3.core.render.RenderQueue.NONDEPTH_ALPHA_BLEND_DOUBLEFACE*/12;
					this.event(/*laya.events.Event.RENDERQUEUE_CHANGED*/"renderqueuechanged",this);
					break ;
				case 11:
					this._renderQueue=/*laya.d3.core.render.RenderQueue.NONDEPTH_ALPHA_ADDTIVE_BLEND*/13;
					this.event(/*laya.events.Event.RENDERQUEUE_CHANGED*/"renderqueuechanged",this);
					break ;
				case 12:
					this._renderQueue=/*laya.d3.core.render.RenderQueue.NONDEPTH_ALPHA_ADDTIVE_BLEND_DOUBLEFACE*/14;
					this.event(/*laya.events.Event.RENDERQUEUE_CHANGED*/"renderqueuechanged",this);
					break ;
				default :
					throw new Error("Material:renderMode value error.");
					break ;
				}
			if (this._renderMode===3 || this._renderMode===4)
				this._shaderDefine |=/*laya.d3.shader.ShaderDefines3D.ALPHATEST*/0x20000;
			else
			this._shaderDefine=this._shaderDefine & (~ /*laya.d3.shader.ShaderDefines3D.ALPHATEST*/0x20000);
		});

		BaseMaterial.RENDERMODE_OPAQUE=1;
		BaseMaterial.RENDERMODE_OPAQUEDOUBLEFACE=2;
		BaseMaterial.RENDERMODE_CUTOUT=3;
		BaseMaterial.RENDERMODE_CUTOUTDOUBLEFACE=4;
		BaseMaterial.RENDERMODE_TRANSPARENT=13;
		BaseMaterial.RENDERMODE_TRANSPARENTDOUBLEFACE=14;
		BaseMaterial.RENDERMODE_ADDTIVE=15;
		BaseMaterial.RENDERMODE_ADDTIVEDOUBLEFACE=16;
		BaseMaterial.RENDERMODE_DEPTHREAD_TRANSPARENT=5;
		BaseMaterial.RENDERMODE_DEPTHREAD_TRANSPARENTDOUBLEFACE=6;
		BaseMaterial.RENDERMODE_DEPTHREAD_ADDTIVE=7;
		BaseMaterial.RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE=8;
		BaseMaterial.RENDERMODE_NONDEPTH_TRANSPARENT=9;
		BaseMaterial.RENDERMODE_NONDEPTH_TRANSPARENTDOUBLEFACE=10;
		BaseMaterial.RENDERMODE_NONDEPTH_ADDTIVE=11;
		BaseMaterial.RENDERMODE_NONDEPTH_ADDTIVEDOUBLEFACE=12;
		return BaseMaterial;
	})(Resource)


	/**
	*<code>ShurikenParticleSystem</code> 类用于创建3D粒子数据模板。
	*/
	//class laya.d3.core.particleShuriKen.ShurikenParticleSystem extends laya.resource.Resource
	var ShurikenParticleSystem=(function(_super){
		function ShurikenParticleSystem(owner){
			this._owner=null;
			this._vertices=null;
			this._floatCountPerVertex=0;
			this._firstActiveElement=0;
			this._firstNewElement=0;
			this._firstFreeElement=0;
			this._firstRetiredElement=0;
			this._drawCounter=0;
			this._currentTime=NaN;
			this._vertexBuffer=null;
			this._indexBuffer=null;
			this._maxParticles=0;
			this._emission=null;
			this._shape=null;
			this.duration=NaN;
			this.looping=false;
			this.prewarm=false;
			this.startDelayType=0;
			this.startDelay=NaN;
			this.startDelayMin=NaN;
			this.startDelayMax=NaN;
			this.startLifetimeType=0;
			this.startLifetimeConstant=NaN;
			this.startLifeTimeGradient=null;
			this.startLifetimeConstantMin=NaN;
			this.startLifetimeConstantMax=NaN;
			this.startLifeTimeGradientMin=null;
			this.startLifeTimeGradientMax=null;
			this.startSpeedType=0;
			this.startSpeedConstant=NaN;
			this.startSpeedConstantMin=NaN;
			this.startSpeedConstantMax=NaN;
			this.threeDStartSize=false;
			this.startSizeType=0;
			this.startSizeConstant=NaN;
			this.startSizeConstantSeparate=null;
			this.startSizeConstantMin=NaN;
			this.startSizeConstantMax=NaN;
			this.startSizeConstantMinSeparate=null;
			this.startSizeConstantMaxSeparate=null;
			this.threeDStartRotation=false;
			this.startRotationType=0;
			this.startRotationConstant=NaN;
			this.startRotationConstantSeparate=null;
			this.startRotationConstantMin=NaN;
			this.startRotationConstantMax=NaN;
			this.startRotationConstantMinSeparate=null;
			this.startRotationConstantMaxSeparate=null;
			this.randomizeRotationDirection=NaN;
			this.startColorType=0;
			this.startColorConstant=null;
			this.startColorConstantMin=null;
			this.startColorConstantMax=null;
			this.gravity=null;
			this.gravityModifier=NaN;
			this.simulationSpace=0;
			this.scaleMode=0;
			this.playOnAwake=false;
			this.velocityOverLifetime=null;
			this.colorOverLifetime=null;
			this.sizeOverLifetime=null;
			this.rotationOverLifetime=null;
			this.textureSheetAnimation=null;
			ShurikenParticleSystem.__super.call(this);
			this._owner=owner;
			this._currentTime=0;
			this._floatCountPerVertex=37;
			this._maxParticles=1000;
			this.duration=5.0;
			this.looping=true;
			this.prewarm=false;
			this.startDelayType=0;
			this.startDelay=0.0;
			this.startDelayMin=0.0;
			this.startDelayMax=0.0;
			this.startLifetimeType=0;
			this.startLifetimeConstant=5.0;
			this.startLifetimeConstantMin=0.0;
			this.startLifetimeConstantMax=5.0;
			this.startSpeedType=0;
			this.startSpeedConstant=5.0;
			this.startSpeedConstantMin=0.0;
			this.startSpeedConstantMax=5.0;
			this.threeDStartSize=false;
			this.startSizeType=0;
			this.startSizeConstant=1;
			this.startSizeConstantSeparate=new Vector3(1,1,1);
			this.startSizeConstantMin=0;
			this.startSizeConstantMax=1;
			this.startSizeConstantMinSeparate=new Vector3(0,0,0);
			this.startSizeConstantMaxSeparate=new Vector3(1,1,1);
			this.threeDStartRotation=false;
			this.startRotationType=0;
			this.startRotationConstant=0;
			this.startRotationConstantMin=0.0;
			this.startRotationConstantMax=0.0;
			this.randomizeRotationDirection=0.0;
			this.startColorType=0;
			this.startColorConstant=new Vector4(1,1,1,1);
			this.startColorConstantMin=new Vector4(1,1,1,1);
			this.startColorConstantMax=new Vector4(1,1,1,1);
			this.gravity=new Vector3(0,-9.81,0);
			this.gravityModifier=0.0;
			this.simulationSpace=1;
			this.scaleMode=0;
			this.playOnAwake=true;
		}

		__class(ShurikenParticleSystem,'laya.d3.core.particleShuriKen.ShurikenParticleSystem',_super);
		var __proto=ShurikenParticleSystem.prototype;
		Laya.imps(__proto,{"laya.d3.core.render.IRenderable":true})
		__proto._getVertexBuffer=function(index){
			(index===void 0)&& (index=0);
			if (index===0)
				return this._vertexBuffer;
			else
			return null;
		}

		__proto._getIndexBuffer=function(){
			return this._indexBuffer;
		}

		//autoRandomSeed=true;
		__proto._retireActiveParticles=function(){
			while (this._firstActiveElement !=this._firstNewElement){
				var index=this._firstActiveElement *this._floatCountPerVertex *4;
				var timeIndex=index+27;
				var particleAge=this._currentTime-this._vertices[timeIndex];
				if (particleAge < this._vertices[index+26])
					break ;
				this._vertices[timeIndex]=this._drawCounter;
				this._firstActiveElement++;
				if (this._firstActiveElement >=this._maxParticles)
					this._firstActiveElement=0;
			}
		}

		__proto._freeRetiredParticles=function(){
			while (this._firstRetiredElement !=this._firstActiveElement){
				var age=this._drawCounter-this._vertices[this._firstRetiredElement *this._floatCountPerVertex *4+27];
				if (age < 3)
					break ;
				this._firstRetiredElement++;
				if (this._firstRetiredElement >=this._maxParticles)
					this._firstRetiredElement=0;
			}
		}

		__proto._setPartVertexDatas=function(subU,subV,startU,startV){
			for (var i=0;i < this._maxParticles;i++){
				var particleOffset=i *this._floatCountPerVertex *4;
				this._vertices[particleOffset+this._floatCountPerVertex *0+0]=-0.5;
				this._vertices[particleOffset+this._floatCountPerVertex *0+1]=-0.5;
				this._vertices[particleOffset+this._floatCountPerVertex *1+0]=0.5;
				this._vertices[particleOffset+this._floatCountPerVertex *1+1]=-0.5;
				this._vertices[particleOffset+this._floatCountPerVertex *2+0]=0.5;
				this._vertices[particleOffset+this._floatCountPerVertex *2+1]=0.5;
				this._vertices[particleOffset+this._floatCountPerVertex *3+0]=-0.5;
				this._vertices[particleOffset+this._floatCountPerVertex *3+1]=0.5;
			}
		}

		__proto._initPartVertexDatas=function(){
			this._vertexBuffer=VertexBuffer3D.create(VertexParticleShuriken.vertexDeclaration,this._maxParticles *4,/*laya.webgl.WebGLContext.DYNAMIC_DRAW*/0x88E8);
			this._vertices=new Float32Array(this._maxParticles *this._floatCountPerVertex *4);
			var enableSheetAnimation=this.textureSheetAnimation && this.textureSheetAnimation.enbale;
			if (enableSheetAnimation){
				var title=this.textureSheetAnimation.tiles;
				var titleX=title.x,titleY=title.y;
				var subU=1.0 / titleX,subV=1.0 / titleY;
				var totalFrameCount=0;
				var startRow=0;
				var randomRow=this.textureSheetAnimation.randomRow;
				switch (this.textureSheetAnimation.type){
					case 0:
						totalFrameCount=titleX *titleY;
						break ;
					case 1:
						totalFrameCount=titleX;
						if (randomRow)
							startRow=Math.round(Math.random()*titleY);
						else
						startRow=0;
						break ;
					};
				var startFrameCount=0;
				var startFrame=this.textureSheetAnimation.startFrame;
				switch (startFrame.type){
					case 0:
						startFrameCount=startFrame.constant;
						break ;
					case 1:
						startFrameCount=Math.round(MathUtil.lerp(startFrame.constantMin,startFrame.constantMax,Math.random()));
						break ;
					};
				var frame=this.textureSheetAnimation.frame;
				switch (frame.type){
					case 0:
						startFrameCount+=frame.constant;
						break ;
					case 2:
						startFrameCount+=Math.round(MathUtil.lerp(frame.constantMin,frame.constantMax,Math.random()));
						break ;
					}
				if (!randomRow)
					startRow=Math.floor(startFrameCount / titleX);
				var startCol=startFrameCount % titleX;
				this._setPartVertexDatas(subU,subV,startCol *subU,startRow *subV);
				}else {
				this._setPartVertexDatas(1.0,1.0,0.0,0.0);
			}
		}

		__proto._initIndexDatas=function(){
			this._indexBuffer=IndexBuffer3D.create(/*laya.d3.graphics.IndexBuffer3D.INDEXTYPE_USHORT*/"ushort",this._maxParticles *6,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4);
			var indexes=new Uint16Array(this._maxParticles *6);
			for (var i=0;i < this._maxParticles;i++){
				var indexOffset=i *6;
				var vertexOffset=i *4;
				indexes[indexOffset+0]=(vertexOffset+0);
				indexes[indexOffset+1]=(vertexOffset+2);
				indexes[indexOffset+2]=(vertexOffset+1);
				indexes[indexOffset+3]=(vertexOffset+0);
				indexes[indexOffset+4]=(vertexOffset+3);
				indexes[indexOffset+5]=(vertexOffset+2);
			}
			this._indexBuffer.setData(indexes);
		}

		__proto.update=function(state){
			var elapsedTime=state.elapsedTime / 1000.0;
			this._currentTime+=elapsedTime;
			this._emission.update(elapsedTime,this._owner.transform);
			this._retireActiveParticles();
			this._freeRetiredParticles();
			if (this._firstActiveElement==this._firstFreeElement)
				this._currentTime=0;
			if (this._firstRetiredElement==this._firstActiveElement)
				this._drawCounter=0;
		}

		__proto.addParticle=function(position,direction){
			Vector3.normalize(direction,direction);
			var positionE=position.elements;
			var directionE=direction.elements;
			var nextFreeParticle=this._firstFreeElement+1;
			if (nextFreeParticle >=this._maxParticles)
				nextFreeParticle=0;
			if (nextFreeParticle===this._firstRetiredElement)
				return;
			var particleData=ShurikenParticleData.create(this,this._owner.particleRender,positionE,directionE,this._currentTime);
			var startIndex=this._firstFreeElement *this._floatCountPerVertex *4;
			var randomX0=Math.random(),randomY0=Math.random(),randomZ0=Math.random(),randomW0=Math.random();
			var randomX1=Math.random(),randomY1=Math.random(),randomZ1=Math.random(),randomW1=Math.random();
			var subU=particleData.startUVInfo[0];
			var subV=particleData.startUVInfo[1];
			var startU=particleData.startUVInfo[2];
			var startV=particleData.startUVInfo[3];
			this._vertices[startIndex+2]=startU;
			this._vertices[startIndex+3]=startV+subV;
			this._vertices[startIndex+this._floatCountPerVertex+2]=startU+subU;
			this._vertices[startIndex+this._floatCountPerVertex+3]=startV+subV;
			this._vertices[startIndex+this._floatCountPerVertex *2+2]=startU+subU;
			this._vertices[startIndex+this._floatCountPerVertex *2+3]=startV;
			this._vertices[startIndex+this._floatCountPerVertex *3+2]=startU;
			this._vertices[startIndex+this._floatCountPerVertex *3+3]=startV;
			for (var i=0;i < 4;i++){
				var vertexStart=startIndex+i *this._floatCountPerVertex;
				var j=0,offset=0;
				for (j=0,offset=4;j < 3;j++)
				this._vertices[vertexStart+offset+j]=particleData.position[j];
				for (j=0,offset=7;j < 3;j++)
				this._vertices[vertexStart+offset+j]=particleData.direction[j];
				for (j=0,offset=10;j < 4;j++)
				this._vertices[vertexStart+offset+j]=particleData.startColor[j];
				for (j=0,offset=14;j < 3;j++)
				this._vertices[vertexStart+offset+j]=particleData.startSize[j];
				for (j=0,offset=17;j < 3;j++)
				this._vertices[vertexStart+offset+j]=particleData.startRotation0[j];
				for (j=0,offset=20;j < 3;j++)
				this._vertices[vertexStart+offset+j]=particleData.startRotation1[j];
				for (j=0,offset=23;j < 3;j++)
				this._vertices[vertexStart+offset+j]=particleData.startRotation2[j];
				this._vertices[vertexStart+26]=particleData.startLifeTime;
				this._vertices[vertexStart+27]=particleData.time;
				this._vertices[vertexStart+28]=particleData.startSpeed;
				this._vertices[vertexStart+29]=randomX0;
				this._vertices[vertexStart+30]=randomY0;
				this._vertices[vertexStart+31]=randomZ0;
				this._vertices[vertexStart+32]=randomW0;
				this._vertices[vertexStart+33]=randomX1;
				this._vertices[vertexStart+34]=randomY1;
				this._vertices[vertexStart+35]=randomZ1;
				this._vertices[vertexStart+36]=randomW1;
			}
			this._firstFreeElement=nextFreeParticle;
		}

		__proto.addNewParticlesToVertexBuffer=function(){
			var start=0;
			if (this._firstNewElement < this._firstFreeElement){
				start=this._firstNewElement *4 *this._floatCountPerVertex;
				this._vertexBuffer.setData(this._vertices,start,start,(this._firstFreeElement-this._firstNewElement)*4 *this._floatCountPerVertex);
				}else {
				start=this._firstNewElement *4 *this._floatCountPerVertex;
				this._vertexBuffer.setData(this._vertices,start,start,(this._maxParticles-this._firstNewElement)*4 *this._floatCountPerVertex);
				if (this._firstFreeElement > 0){
					this._vertexBuffer.setData(this._vertices,0,0,this._firstFreeElement *4 *this._floatCountPerVertex);
				}
			}
			this._firstNewElement=this._firstFreeElement;
		}

		__proto._beforeRender=function(state){
			if (this._firstNewElement !=this._firstFreeElement){
				this.addNewParticlesToVertexBuffer();
			}
			this._drawCounter++;
			if (this._firstActiveElement !=this._firstFreeElement){
				this._vertexBuffer._bind();
				this._indexBuffer._bind();
				return true;
			}
			return false;
		}

		__proto._render=function(state){
			var drawVertexCount=0;
			var glContext=WebGL.mainContext;
			if (this._firstActiveElement < this._firstFreeElement){
				drawVertexCount=(this._firstFreeElement-this._firstActiveElement)*6;
				glContext.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,drawVertexCount,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,this._firstActiveElement *6 *2);
				Stat.trianglesFaces+=drawVertexCount / 3;
				Stat.drawCall++;
				}else {
				drawVertexCount=(this._maxParticles-this._firstActiveElement)*6;
				glContext.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,drawVertexCount,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,this._firstActiveElement *6 *2);
				Stat.trianglesFaces+=drawVertexCount / 3;
				Stat.drawCall++;
				if (this._firstFreeElement > 0){
					drawVertexCount=this._firstFreeElement *6;
					glContext.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,drawVertexCount,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,0);
					Stat.trianglesFaces+=drawVertexCount / 3;
					Stat.drawCall++;
				}
			}
		}

		__proto.dispose=function(){
			_super.prototype.dispose.call(this);
			this._vertexBuffer.dispose();
			this._indexBuffer.dispose();
			this._vertices=null;
			this._emission=null;
			this.startLifeTimeGradient=null;
			this.startLifeTimeGradientMin=null;
			this.startLifeTimeGradientMax=null;
			this.velocityOverLifetime=null;
			this.colorOverLifetime=null;
			this.sizeOverLifetime=null;
			this.rotationOverLifetime=null;
			this.textureSheetAnimation=null;
		}

		/**当前粒子时间。*/
		__getset(0,__proto,'currentTime',function(){
			return this._currentTime;
		});

		__getset(0,__proto,'indexOfHost',function(){
			return 0;
		});

		/**设置最大粒子数,注意:谨慎修改此属性，有性能损耗。*/
		/**获取最大粒子数。*/
		__getset(0,__proto,'maxParticles',function(){
			return this._maxParticles-1;
			},function(value){
			var newMaxParticles=value+1;
			if (newMaxParticles!==this._maxParticles){
				this._maxParticles=newMaxParticles;
				if (this._vertexBuffer){
					this._vertexBuffer.dispose();
					this._indexBuffer.dispose();
				}
				this._initPartVertexDatas();
				this._initIndexDatas();
			}
		});

		/**
		*设置形状。
		*/
		/**
		*获取形状。
		*/
		__getset(0,__proto,'shape',function(){
			return this._shape;
			},function(value){
			this._shape=value;
			this._emission._shape=value;
		});

		/**
		*设置发射器。
		*/
		/**
		*获取发射器。
		*/
		__getset(0,__proto,'emission',function(){
			return this._emission;
			},function(value){
			this._emission=value;
			value._particleSystem=this;
			value._shape=this._shape;
		});

		__getset(0,__proto,'_vertexBufferCount',function(){
			return 1;
		});

		__getset(0,__proto,'triangleCount',function(){
			return this._indexBuffer.indexCount / 3;
		});

		return ShurikenParticleSystem;
	})(Resource)


	/**
	*<code>BaseTexture</code> 纹理的父类，抽象类，不允许实例。
	*/
	//class laya.d3.resource.BaseTexture extends laya.resource.Resource
	var BaseTexture=(function(_super){
		function BaseTexture(){
			this._width=0;
			this._height=0;
			this._size=null;
			this._repeat=false;
			this._mipmap=false;
			this._minFifter=0;
			this._magFifter=0;
			this._source=null;
			BaseTexture.__super.call(this);
			this._repeat=true;
			this._mipmap=true;
			this._minFifter=-1;
			this._magFifter=-1;
		}

		__class(BaseTexture,'laya.d3.resource.BaseTexture',_super);
		var __proto=BaseTexture.prototype;
		__proto.dispose=function(){
			this.resourceManager.removeResource(this);
			_super.prototype.dispose.call(this);
		}

		/**
		*获取宽度。
		*/
		__getset(0,__proto,'width',function(){
			return this._width;
		});

		/**
		*是否使用重复模式纹理寻址
		*/
		__getset(0,__proto,'repeat',function(){
			return this._repeat;
		});

		/**
		*获取高度。
		*/
		__getset(0,__proto,'height',function(){
			return this._height;
		});

		/**
		*放大过滤器
		*/
		__getset(0,__proto,'magFifter',function(){
			return this._magFifter;
		});

		/**
		*获取尺寸。
		*/
		__getset(0,__proto,'size',function(){
			return this._size;
		});

		/**
		*是否使用mipLevel
		*/
		__getset(0,__proto,'mipmap',function(){
			return this._mipmap;
		});

		/**\
		*缩小过滤器
		*/
		__getset(0,__proto,'minFifter',function(){
			return this._minFifter;
		});

		/**
		*获取纹理资源。
		*/
		__getset(0,__proto,'source',function(){
			this.activeResource();
			return this._source;
		});

		return BaseTexture;
	})(Resource)


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
			this._loaded=false;
		}

		__class(BaseMesh,'laya.d3.resource.models.BaseMesh',_super);
		var __proto=BaseMesh.prototype;
		/**
		*获取渲染单元数量,请重载此方法。
		*@return 渲染单元数量。
		*/
		__proto.getRenderElementsCount=function(){
			throw new Error("未Override,请重载该属性！");
		}

		/**
		*获取渲染单元,请重载此方法。
		*@param index 索引。
		*@return 渲染单元。
		*/
		__proto.getRenderElement=function(index){
			throw new Error("未Override,请重载该属性！");
		}

		/**
		*获取网格顶点,请重载此方法。
		*@return 网格顶点。
		*/
		__getset(0,__proto,'positions',function(){
			throw new Error("未Override,请重载该属性！");
		});

		/**
		*获取SubMesh的个数。
		*@return SubMesh的个数。
		*/
		__getset(0,__proto,'subMeshCount',function(){
			return this._subMeshCount;
		});

		/**
		*获取AABB包围盒。
		*@return AABB包围盒。
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

		return BaseMesh;
	})(Resource)


	/**
	*<code>Sky</code> 类用于创建天空的父类，抽象类不允许实例。
	*/
	//class laya.d3.resource.models.Sky extends laya.resource.Resource
	var Sky=(function(_super){
		function Sky(){
			Sky.__super.call(this);
		}

		__class(Sky,'laya.d3.resource.models.Sky',_super);
		var __proto=Sky.prototype;
		__proto._render=function(state){}
		Sky.MVPMATRIX="MVPMATRIX";
		Sky.INTENSITY="INTENSITY";
		Sky.ALPHABLENDING="ALPHABLENDING";
		Sky.DIFFUSETEXTURE="DIFFUSETEXTURE";
		return Sky;
	})(Resource)


	/**
	*<code>KeyframeAnimation</code> 类用于帧动画组件的父类。
	*/
	//class laya.d3.component.animation.KeyframeAnimations extends laya.d3.component.Component3D
	var KeyframeAnimations=(function(_super){
		function KeyframeAnimations(){
			this._player=null;
			this._templet=null;
			KeyframeAnimations.__super.call(this);
			this._player=new AnimationPlayer();
		}

		__class(KeyframeAnimations,'laya.d3.component.animation.KeyframeAnimations',_super);
		var __proto=KeyframeAnimations.prototype;
		/**
		*@private
		*/
		__proto._updateAnimtionPlayer=function(){
			this._player.update(Laya.timer.delta);
		}

		/**
		*@private
		*/
		__proto._addUpdatePlayerToTimer=function(){
			Laya.timer.frameLoop(1,this,this._updateAnimtionPlayer);
		}

		/**
		*@private
		*/
		__proto._removeUpdatePlayerToTimer=function(){
			Laya.timer.clear(this,this._updateAnimtionPlayer);
		}

		/**
		*@private
		*/
		__proto._onOwnerEnableChanged=function(enable){
			if (this._owner.displayedInStage){
				if (enable)
					this._addUpdatePlayerToTimer();
				else
				this._removeUpdatePlayerToTimer();
			}
		}

		/**
		*@private
		*/
		__proto._onDisplayInStage=function(){
			(this._owner.enable)&& (this._addUpdatePlayerToTimer());
		}

		/**
		*@private
		*/
		__proto._onUnDisplayInStage=function(){
			(this._owner.enable)&& (this._removeUpdatePlayerToTimer());
		}

		/**
		*@private
		*载入组件时执行
		*/
		__proto._load=function(owner){
			(this._owner.displayedInStage && this._owner.enable)&& (this._addUpdatePlayerToTimer());
			this._owner.on(/*laya.events.Event.ENABLED_CHANGED*/"enabledchanged",this,this._onOwnerEnableChanged);
			this._owner.on(/*laya.events.Event.DISPLAY*/"display",this,this._onDisplayInStage);
			this._owner.on(/*laya.events.Event.UNDISPLAY*/"undisplay",this,this._onUnDisplayInStage);
		}

		/**
		*@private
		*卸载组件时执行
		*/
		__proto._unload=function(owner){
			(this._owner.displayedInStage && this._owner.enable)&& (this._removeUpdatePlayerToTimer());
			this._owner.off(/*laya.events.Event.ENABLED_CHANGED*/"enabledchanged",this,this._onOwnerEnableChanged);
			this._owner.off(/*laya.events.Event.DISPLAY*/"display",this,this._onDisplayInStage);
			this._owner.off(/*laya.events.Event.UNDISPLAY*/"undisplay",this,this._onUnDisplayInStage);
		}

		/**
		*停止播放当前动画
		*@param immediate 是否立即停止
		*/
		__proto.stop=function(immediate){
			(immediate===void 0)&& (immediate=true);
			this._player.stop(immediate);
		}

		/**
		*设置url地址。
		*@param value 地址。
		*/
		__getset(0,__proto,'url',null,function(value){
			console.log("Warning: discard property,please use templet property instead.");
			if (this._player.state!==/*laya.ani.AnimationState.stopped*/0)
				this._player.stop(true);
			var templet=Laya.loader.create(value,null,null,AnimationTemplet);
			this._templet=templet;
			this._player.templet=templet;
			this.event(/*laya.events.Event.ANIMATION_CHANGED*/"actionchanged",this);
		});

		/**
		*获取动画播放器。
		*@return 动画播放器。
		*/
		__getset(0,__proto,'player',function(){
			return this._player;
		});

		/**
		*设置动画模板。
		*@param value 设置动画模板。
		*/
		/**
		*获取动画模板。
		*@return value 动画模板。
		*/
		__getset(0,__proto,'templet',function(){
			return this._templet;
			},function(value){
			if (this._player.state!==/*laya.ani.AnimationState.stopped*/0)
				this._player.stop(true);
			this._templet=value;
			this._player.templet=value;
			this.event(/*laya.events.Event.ANIMATION_CHANGED*/"actionchanged",this);
		});

		/**
		*获取播放器帧数。
		*@return 播放器帧数。
		*/
		__getset(0,__proto,'currentFrameIndex',function(){
			return this._player.currentKeyframeIndex;
		});

		/**
		*获取播放器的动画索引。
		*@return 动画索引。
		*/
		__getset(0,__proto,'currentAnimationClipIndex',function(){
			return this._player.currentAnimationClipIndex;
		});

		/**
		*获取播放器当前动画的节点数量。
		*@return 节点数量。
		*/
		__getset(0,__proto,'NodeCount',function(){
			return this._templet.getNodeCount(this._player.currentAnimationClipIndex);
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
			if (!this._attachSkeleton || player.state!==/*laya.ani.AnimationState.playing*/2 || !this._attachSkeleton.curBonesDatas)
				return;
			this.matrixs.length=this.attachBones.length;
			for (var i=0;i < this.attachBones.length;i++){
				var index=this._attachSkeleton.templet.getNodeIndexWithName(player.currentAnimationClipIndex,this.attachBones[i]);
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
	*...
	*@author ...
	*/
	//class laya.d3.core.GlitterRender extends laya.d3.core.render.BaseRender
	var GlitterRender=(function(_super){
		function GlitterRender(owner){
			GlitterRender.__super.call(this,owner);
		}

		__class(GlitterRender,'laya.d3.core.GlitterRender',_super);
		var __proto=GlitterRender.prototype;
		__proto._calculateBoundingBox=function(){
			var minE=this._boundingBox.min.elements;
			minE[0]=-Number.MAX_VALUE;
			minE[1]=-Number.MAX_VALUE;
			minE[2]=-Number.MAX_VALUE;
			var maxE=this._boundingBox.min.elements;
			maxE[0]=Number.MAX_VALUE;
			maxE[1]=Number.MAX_VALUE;
			maxE[2]=Number.MAX_VALUE;
		}

		__proto._calculateBoundingSphere=function(){
			var centerE=this._boundingSphere.center.elements;
			centerE[0]=0;
			centerE[1]=0;
			centerE[2]=0;
			this._boundingSphere.radius=Number.MAX_VALUE;
		}

		return GlitterRender;
	})(BaseRender)


	/**
	*<code>MeshRender</code> 类用于网格渲染器。
	*/
	//class laya.d3.core.MeshRender extends laya.d3.core.render.BaseRender
	var MeshRender=(function(_super){
		function MeshRender(owner){
			this._meshSprite3DOwner=null;
			this.castShadow=false;
			this.receiveShadow=false;
			MeshRender.__super.call(this,owner);
			this._meshSprite3DOwner=owner;
			this.castShadow=true;
			this.receiveShadow=true;
			this._meshSprite3DOwner.meshFilter.on(/*laya.events.Event.MESH_CHANGED*/"meshchanged",this,this._onMeshChanged);
		}

		__class(MeshRender,'laya.d3.core.MeshRender',_super);
		var __proto=MeshRender.prototype;
		/**
		*@private
		*/
		__proto._onMeshChanged=function(sender,oldMesh,mesh){
			if (mesh.loaded){
				this._boundingSphereNeedChange=true;
				this._boundingBoxNeedChange=true;
				}else {
				mesh.once(/*laya.events.Event.LOADED*/"loaded",this,this._onMeshLoaed);
			}
		}

		/**
		*@private
		*/
		__proto._onMeshLoaed=function(sender,enable){
			this._boundingSphereNeedChange=true;
			this._boundingBoxNeedChange=true;
		}

		__proto._calculateBoundingSphere=function(){
			if (this._meshSprite3DOwner.meshFilter.sharedMesh===null || this._meshSprite3DOwner.meshFilter.sharedMesh.boundingSphere===null){
				this._boundingSphere.toDefault();
				}else {
				var meshBoundingSphere=this._meshSprite3DOwner.meshFilter.sharedMesh.boundingSphere;
				var maxScale=NaN;
				var transform=this._meshSprite3DOwner.transform;
				var scale=transform.scale;
				if (scale.x >=scale.y && scale.x >=scale.z)
					maxScale=scale.x;
				else
				maxScale=scale.y >=scale.z ? scale.y :scale.z;
				Vector3.transformCoordinate(meshBoundingSphere.center,transform.worldMatrix,this._boundingSphere.center);
				this._boundingSphere.radius=meshBoundingSphere.radius *maxScale;
			}
		}

		__proto._calculateBoundingBox=function(){
			if (this._meshSprite3DOwner.meshFilter.sharedMesh===null || this._meshSprite3DOwner.meshFilter.sharedMesh.boundingBox===null){
				this._boundingBox.toDefault();
				}else {
				var meshBoudingBox=this._meshSprite3DOwner.meshFilter.sharedMesh.boundingBox;
				var worldMat=this._meshSprite3DOwner.transform.worldMatrix;
				Vector3.transformCoordinate(meshBoudingBox.min,worldMat,this._boundingBox.min);
				Vector3.transformCoordinate(meshBoudingBox.max,worldMat,this._boundingBox.max);
			}
		}

		__proto.destroy=function(){
			_super.prototype.destroy.call(this);
			this._meshSprite3DOwner=null;
		}

		return MeshRender;
	})(BaseRender)


	/**
	*...
	*@author ...
	*/
	//class laya.d3.core.ParticleRender extends laya.d3.core.render.BaseRender
	var ParticleRender=(function(_super){
		function ParticleRender(owner){
			ParticleRender.__super.call(this,owner);
		}

		__class(ParticleRender,'laya.d3.core.ParticleRender',_super);
		var __proto=ParticleRender.prototype;
		__proto._calculateBoundingBox=function(){
			var minE=this._boundingBox.min.elements;
			minE[0]=-Number.MAX_VALUE;
			minE[1]=-Number.MAX_VALUE;
			minE[2]=-Number.MAX_VALUE;
			var maxE=this._boundingBox.min.elements;
			maxE[0]=Number.MAX_VALUE;
			maxE[1]=Number.MAX_VALUE;
			maxE[2]=Number.MAX_VALUE;
		}

		__proto._calculateBoundingSphere=function(){
			var centerE=this._boundingSphere.center.elements;
			centerE[0]=0;
			centerE[1]=0;
			centerE[2]=0;
			this._boundingSphere.radius=Number.MAX_VALUE;
		}

		return ParticleRender;
	})(BaseRender)


	/**
	*...
	*@author ...
	*/
	//class laya.d3.core.particleShuriKen.ShurikenParticleRender extends laya.d3.core.render.BaseRender
	var ShurikenParticleRender=(function(_super){
		function ShurikenParticleRender(owner){
			this.renderMode=0;
			this.stretchedBillboardCameraSpeedScale=0;
			this.stretchedBillboardSpeedScale=0;
			this.stretchedBillboardLengthScale=1;
			ShurikenParticleRender.__super.call(this,owner);
			this.renderMode=0;
		}

		__class(ShurikenParticleRender,'laya.d3.core.particleShuriKen.ShurikenParticleRender',_super);
		var __proto=ShurikenParticleRender.prototype;
		__proto._calculateBoundingBox=function(){
			var minE=this._boundingBox.min.elements;
			minE[0]=-Number.MAX_VALUE;
			minE[1]=-Number.MAX_VALUE;
			minE[2]=-Number.MAX_VALUE;
			var maxE=this._boundingBox.min.elements;
			maxE[0]=Number.MAX_VALUE;
			maxE[1]=Number.MAX_VALUE;
			maxE[2]=Number.MAX_VALUE;
		}

		__proto._calculateBoundingSphere=function(){
			var centerE=this._boundingSphere.center.elements;
			centerE[0]=0;
			centerE[1]=0;
			centerE[2]=0;
			this._boundingSphere.radius=Number.MAX_VALUE;
		}

		return ShurikenParticleRender;
	})(BaseRender)


	/**
	*@private
	*<code>ParticleTemplet3D</code> 类用于创建3D粒子数据模板。
	*/
	//class laya.d3.resource.tempelet.ParticleTemplet3D extends laya.particle.ParticleTemplateWebGL
	var ParticleTemplet3D=(function(_super){
		function ParticleTemplet3D(owner,setting){
			this._owner=null;
			this._vertexBuffer3D=null;
			this._indexBuffer3D=null;
			ParticleTemplet3D.__super.call(this,setting);
			this._owner=owner;
			this.initialize();
			this._vertexBuffer=this._vertexBuffer3D=VertexBuffer3D.create(VertexParticle.vertexDeclaration,setting.maxPartices *4,/*laya.webgl.WebGLContext.DYNAMIC_DRAW*/0x88E8);
			this._indexBuffer=this._indexBuffer3D=IndexBuffer3D.create(/*laya.d3.graphics.IndexBuffer3D.INDEXTYPE_USHORT*/"ushort",setting.maxPartices *6,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4,true);
			this.loadContent();
		}

		__class(ParticleTemplet3D,'laya.d3.resource.tempelet.ParticleTemplet3D',_super);
		var __proto=ParticleTemplet3D.prototype;
		Laya.imps(__proto,{"laya.d3.core.render.IRenderable":true})
		__proto._getVertexBuffer=function(index){
			(index===void 0)&& (index=0);
			if (index===0)
				return this._vertexBuffer3D;
			else
			return null;
		}

		__proto._getIndexBuffer=function(){
			return this._indexBuffer3D;
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

		__proto._beforeRender=function(state){
			if (this._firstNewElement !=this._firstFreeElement){
				this.addNewParticlesToVertexBuffer();
			}
			this._drawCounter++;
			if (this._firstActiveElement !=this._firstFreeElement){
				this._vertexBuffer3D._bind();
				this._indexBuffer._bind();
				return true;
			}
			return false;
		}

		__proto._render=function(state){
			var drawVertexCount=0;
			var glContext=WebGL.mainContext;
			if (this._firstActiveElement < this._firstFreeElement){
				drawVertexCount=(this._firstFreeElement-this._firstActiveElement)*6;
				glContext.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,drawVertexCount,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,this._firstActiveElement *6 *2);
				Stat.trianglesFaces+=drawVertexCount / 3;
				Stat.drawCall++;
				}else {
				drawVertexCount=(this.settings.maxPartices-this._firstActiveElement)*6;
				glContext.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,drawVertexCount,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,this._firstActiveElement *6 *2);
				Stat.trianglesFaces+=drawVertexCount / 3;
				Stat.drawCall++;
				if (this._firstFreeElement > 0){
					drawVertexCount=this._firstFreeElement *6;
					glContext.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,drawVertexCount,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,0);
					Stat.trianglesFaces+=drawVertexCount / 3;
					Stat.drawCall++;
				}
			}
		}

		__getset(0,__proto,'indexOfHost',function(){
			return 0;
		});

		__getset(0,__proto,'_vertexBufferCount',function(){
			return 1;
		});

		__getset(0,__proto,'triangleCount',function(){
			return this._indexBuffer3D.indexCount / 3;
		});

		return ParticleTemplet3D;
	})(ParticleTemplateWebGL)


	/**
	*<code>BaseScene</code> 类用于实现场景的父类。
	*/
	//class laya.d3.core.scene.BaseScene extends laya.display.Sprite
	var BaseScene=(function(_super){
		function BaseScene(){
			this._invertYProjectionMatrix=null;
			this._invertYProjectionViewMatrix=null;
			this._invertYScaleMatrix=null;
			this._isInStage=false;
			this._boundFrustum=null;
			this._enableLightCount=3;
			this._renderTargetTexture=null;
			this._customRenderQueneIndex=11;
			this._lastCurrentTime=NaN;
			this._staticBatchManager=null;
			this._dynamicBatchManager=null;
			this.enableFog=false;
			this.fogStart=NaN;
			this.fogRange=NaN;
			this.fogColor=null;
			this.enableLight=true;
			BaseScene.__super.call(this);
			this._renderState=new RenderState();
			this._lights=new Array;
			this._renderConfigs=[];
			this._frustumCullingObjects=[];
			this._quenes=[];
			this._cameraPool=[];
			this._invertYProjectionMatrix=new Matrix4x4();
			this._invertYProjectionViewMatrix=new Matrix4x4();
			this._invertYScaleMatrix=new Matrix4x4();
			Matrix4x4.createScaling(new Vector3(1,-1,1),this._invertYScaleMatrix);
			this._staticBatchManager=new StaticBatchManager();
			this._dynamicBatchManager=new DynamicBatchManager();
			this._boundFrustum=new BoundFrustum(Matrix4x4.DEFAULT);
			this.enableFog=false;
			this.fogStart=300;
			this.fogRange=1000;
			this.fogColor=new Vector3(0.7,0.7,0.7);
			var renderConfig;
			renderConfig=this._renderConfigs[ /*laya.d3.core.render.RenderQueue.OPAQUE*/1]=new RenderConfig();
			renderConfig=this._renderConfigs[ /*laya.d3.core.render.RenderQueue.OPAQUE_DOUBLEFACE*/2]=new RenderConfig();
			renderConfig.cullFace=false;
			renderConfig=this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_BLEND*/3]=new RenderConfig();
			renderConfig.blend=true;
			renderConfig.sFactor=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
			renderConfig.dFactor=/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303;
			renderConfig=this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_BLEND_DOUBLEFACE*/4]=new RenderConfig();
			renderConfig.cullFace=false;
			renderConfig.blend=true;
			renderConfig.sFactor=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
			renderConfig.dFactor=/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303;
			renderConfig=this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_ADDTIVE_BLEND*/5]=new RenderConfig();
			renderConfig.blend=true;
			renderConfig.sFactor=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
			renderConfig.dFactor=/*laya.webgl.WebGLContext.ONE*/1;
			renderConfig=this._renderConfigs[ /*laya.d3.core.render.RenderQueue.ALPHA_ADDTIVE_BLEND_DOUBLEFACE*/6]=new RenderConfig();
			renderConfig.cullFace=false;
			renderConfig.blend=true;
			renderConfig.sFactor=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
			renderConfig.dFactor=/*laya.webgl.WebGLContext.ONE*/1;
			renderConfig=this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND*/7]=new RenderConfig();
			renderConfig.blend=true;
			renderConfig.depthMask=0;
			renderConfig.sFactor=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
			renderConfig.dFactor=/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303;
			renderConfig=this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND*/9]=new RenderConfig();
			renderConfig.blend=true;
			renderConfig.depthMask=0;
			renderConfig.sFactor=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
			renderConfig.dFactor=/*laya.webgl.WebGLContext.ONE*/1;
			renderConfig=this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE*/8]=new RenderConfig();
			renderConfig.cullFace=false;
			renderConfig.blend=true;
			renderConfig.depthMask=0;
			renderConfig.sFactor=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
			renderConfig.dFactor=/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303;
			renderConfig=this._renderConfigs[ /*laya.d3.core.render.RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE*/10]=new RenderConfig();
			renderConfig.cullFace=false;
			renderConfig.blend=true;
			renderConfig.depthMask=0;
			renderConfig.sFactor=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
			renderConfig.dFactor=/*laya.webgl.WebGLContext.ONE*/1;
			renderConfig=this._renderConfigs[ /*laya.d3.core.render.RenderQueue.NONDEPTH_ALPHA_BLEND*/11]=new RenderConfig();
			renderConfig.blend=true;
			renderConfig.depthTest=false;
			renderConfig.sFactor=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
			renderConfig.dFactor=/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303;
			renderConfig=this._renderConfigs[ /*laya.d3.core.render.RenderQueue.NONDEPTH_ALPHA_ADDTIVE_BLEND*/13]=new RenderConfig();
			renderConfig.blend=true;
			renderConfig.depthTest=false;
			renderConfig.sFactor=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
			renderConfig.dFactor=/*laya.webgl.WebGLContext.ONE*/1;
			renderConfig=this._renderConfigs[ /*laya.d3.core.render.RenderQueue.NONDEPTH_ALPHA_BLEND_DOUBLEFACE*/12]=new RenderConfig();
			renderConfig.cullFace=false;
			renderConfig.blend=true;
			renderConfig.depthTest=false;
			renderConfig.sFactor=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
			renderConfig.dFactor=/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303;
			renderConfig=this._renderConfigs[ /*laya.d3.core.render.RenderQueue.NONDEPTH_ALPHA_ADDTIVE_BLEND_DOUBLEFACE*/14]=new RenderConfig();
			renderConfig.cullFace=false;
			renderConfig.blend=true;
			renderConfig.depthTest=false;
			renderConfig.sFactor=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
			renderConfig.dFactor=/*laya.webgl.WebGLContext.ONE*/1;
			this.on(/*laya.events.Event.ADDED*/"added",this,this._onAdded);
			this.on(/*laya.events.Event.REMOVED*/"removed",this,this._onRemoved);
		}

		__class(BaseScene,'laya.d3.core.scene.BaseScene',_super);
		var __proto=BaseScene.prototype;
		Laya.imps(__proto,{"laya.webgl.submit.ISubmit":true})
		/**
		*@private
		*/
		__proto._onAdded=function(){
			if (Laya.stage.contains(this)){
				this._addSelfAndChildrenRenderObjects();
				var index=this._parent._childs.indexOf(this);
				Laya.stage._scenes[index]=this;
			}
		}

		/**
		*@private
		*/
		__proto._onRemoved=function(){
			if (Laya.stage.contains(this)){
				this._clearSelfAndChildrenRenderObjects();
				var scenes=Laya.stage._scenes;
				scenes.splice(scenes.indexOf(this),1);
			}
		}

		/**
		*清理自身和子节点渲染物体,重写此函数。
		*/
		__proto._clearSelfAndChildrenRenderObjects=function(){
			for (var i=0,n=this._childs.length;i < n;i++)
			(this._childs [i])._clearSelfAndChildrenRenderObjects();
		}

		/**
		*添加自身和子节点渲染物体,重写此函数。
		*/
		__proto._addSelfAndChildrenRenderObjects=function(){
			for (var i=0,n=this._childs.length;i < n;i++)
			(this._childs [i])._addSelfAndChildrenRenderObjects();
		}

		/**
		*@private
		*场景相关渲染准备设置。
		*@param gl WebGL上下文。
		*@return state 渲染状态。
		*/
		__proto._prepareUpdateToRenderState=function(gl,state){
			state.reset();
			state.context=WebGL.mainContext;
			state.elapsedTime=this._lastCurrentTime ? this.timer.currTimer-this._lastCurrentTime :0;
			this._lastCurrentTime=this.timer.currTimer;
			state.loopCount=Stat.loopCount;
			state.scene=this;
		}

		/**
		*@private
		*场景相关渲染准备设置。
		*@param gl WebGL上下文。
		*@return state 渲染状态。
		*/
		__proto._prepareRenderToRenderState=function(camera,state){
			Layer._currentCameraCullingMask=camera.cullingMask;
			state.camera=camera;
			var worldShaderValue=state.worldShaderValue;
			camera && worldShaderValue.pushValue(/*CLASS CONST:laya.d3.core.scene.BaseScene.CAMERAPOS*/"CAMERAPOS",camera.transform.position.elements);
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
				worldShaderValue.pushValue(/*CLASS CONST:laya.d3.core.scene.BaseScene.FOGSTART*/"FOGSTART",this.fogStart);
				worldShaderValue.pushValue(/*CLASS CONST:laya.d3.core.scene.BaseScene.FOGRANGE*/"FOGRANGE",this.fogRange);
				worldShaderValue.pushValue(/*CLASS CONST:laya.d3.core.scene.BaseScene.FOGCOLOR*/"FOGCOLOR",this.fogColor.elements);
			}
			state.shaderValue.pushArray(worldShaderValue);
			var shaderDefs=state.shaderDefs;
			(this.enableFog)&& (shaderDefs._value |=/*laya.d3.shader.ShaderDefines3D.FOG*/0x200);
		}

		/**
		*@private
		*/
		__proto._updateScene=function(){
			var renderState=this._renderState;
			this._prepareUpdateToRenderState(WebGL.mainContext,renderState);
			this.beforeUpate(renderState);
			this._updateChilds(renderState);
			this.lateUpate(renderState);
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
			this._boundFrustum.matrix=state.projectionViewMatrix;
			FrustumCulling.RenderObjectCulling(this._boundFrustum,this);
			for (var i=0,iNum=this._quenes.length;i < iNum;i++)
			(this._quenes[i])&& (this._quenes[i]._preRender(state));
		}

		__proto._clear=function(gl,state){
			var viewport=state.viewport;
			var camera=state.camera;
			var renderTargetHeight=camera.renderTargetSize.height;
			gl.viewport(viewport.x,renderTargetHeight-viewport.y-viewport.height,viewport.width,viewport.height);
			var clearFlag=0;
			switch (camera.clearFlag){
				case /*laya.d3.core.BaseCamera.CLEARFLAG_SOLIDCOLOR*/0:
					if (camera.clearColor){
						gl.enable(/*laya.webgl.WebGLContext.SCISSOR_TEST*/0x0C11);
						gl.scissor(viewport.x,renderTargetHeight-viewport.y-viewport.height,viewport.width,viewport.height);
						var clearColorE=camera.clearColor.elements;
						gl.clearColor(clearColorE[0],clearColorE[1],clearColorE[2],clearColorE[3]);
						clearFlag=/*laya.webgl.WebGLContext.COLOR_BUFFER_BIT*/0x00004000;
						if (camera.renderTarget){
						switch (camera.renderTarget.depthStencilFormat){
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
						}else {
						clearFlag |=/*laya.webgl.WebGLContext.DEPTH_BUFFER_BIT*/0x00000100;
					}
					gl.clear(clearFlag);
					gl.disable(/*laya.webgl.WebGLContext.SCISSOR_TEST*/0x0C11);
					}else {
					gl.clear(/*laya.webgl.WebGLContext.DEPTH_BUFFER_BIT*/0x00000100);
				}
				break ;
				case /*laya.d3.core.BaseCamera.CLEARFLAG_SKY*/1:
				case /*laya.d3.core.BaseCamera.CLEARFLAG_DEPTHONLY*/2:
				if (camera.renderTarget){
					switch (camera.renderTarget.depthStencilFormat){
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
					}else {
					clearFlag |=/*laya.webgl.WebGLContext.DEPTH_BUFFER_BIT*/0x00000100;
				}
				break ;
				case /*laya.d3.core.BaseCamera.CLEARFLAG_NONE*/3:
				break ;
				default :
				throw new Error("BaseScene:camera clearFlag invalid.");
			}
		}

		/**
		*@private
		*/
		__proto._renderScene=function(gl,state){
			var camera=state.camera;
			var i=0,n=0;
			var queue;
			for (i=0;i < 3;i++){
				queue=this._quenes[i];
				if (queue){
					queue._setState(gl,state);
					queue._render(state);
				}
			}
			if (camera.clearFlag===/*laya.d3.core.BaseCamera.CLEARFLAG_SKY*/1){
				var sky=camera.sky;
				if (sky){
					WebGLContext.setCullFace(gl,false);
					WebGLContext.setDepthFunc(gl,/*laya.webgl.WebGLContext.LEQUAL*/0x0203);
					WebGLContext.setDepthMask(gl,0);
					sky._render(state);
					WebGLContext.setDepthFunc(gl,/*laya.webgl.WebGLContext.LESS*/0x0201);
					WebGLContext.setDepthMask(gl,1);
				}
			}
			for (i=3,n=this._quenes.length;i < n;i++){
				queue=this._quenes[i];
				if (queue){
					queue._sortAlpha(state.camera.transform.position);
					queue._setState(gl,state);
					queue._render(state);
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
			WebGLContext.setCullFace(gl,false);
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

		__proto.addChildAt=function(node,index){
			if (!((node instanceof laya.d3.core.Sprite3D )))
				throw new Error("Sprite3D:Node type must Sprite3D.");
			return laya.display.Node.prototype.addChildAt.call(this,node,index);
		}

		__proto.addChild=function(node){
			if (!((node instanceof laya.d3.core.Sprite3D )))
				throw new Error("Sprite3D:Node type must Sprite3D.");
			return laya.display.Node.prototype.addChild.call(this,node);
		}

		__proto.addFrustumCullingObject=function(frustumCullingObject){
			this._frustumCullingObjects.push(frustumCullingObject);
		}

		__proto.removeFrustumCullingObject=function(frustumCullingObject){
			var index=this._frustumCullingObjects.indexOf(frustumCullingObject);
			(index!==-1)&& (this._frustumCullingObjects.splice(index,1));
		}

		/**
		*获得某个渲染队列。
		*@param index 渲染队列索引。
		*@return 渲染队列。
		*/
		__proto.getRenderQueue=function(index){
			return (this._quenes[index] || (this._quenes[index]=new RenderQueue(this._renderConfigs[index],this)));
		}

		/**
		*添加渲染队列。
		*@param renderConfig 渲染队列配置文件。
		*/
		__proto.addRenderQuene=function(renderConfig){
			this._quenes[this._customRenderQueneIndex++]=new RenderQueue(renderConfig,this);
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
		*获取是否在场景树。
		*@return 是否在场景树。
		*/
		__getset(0,__proto,'isInStage',function(){
			return this._isInStage;
		});

		BaseScene.FOGCOLOR="FOGCOLOR";
		BaseScene.FOGSTART="FOGSTART";
		BaseScene.FOGRANGE="FOGRANGE";
		BaseScene.CAMERAPOS="CAMERAPOS";
		BaseScene.LIGHTDIRECTION="LIGHTDIRECTION";
		BaseScene.LIGHTDIRDIFFUSE="LIGHTDIRDIFFUSE";
		BaseScene.LIGHTDIRAMBIENT="LIGHTDIRAMBIENT";
		BaseScene.LIGHTDIRSPECULAR="LIGHTDIRSPECULAR";
		BaseScene.POINTLIGHTPOS="POINTLIGHTPOS";
		BaseScene.POINTLIGHTRANGE="POINTLIGHTRANGE";
		BaseScene.POINTLIGHTATTENUATION="POINTLIGHTATTENUATION";
		BaseScene.POINTLIGHTDIFFUSE="POINTLIGHTDIFFUSE";
		BaseScene.POINTLIGHTAMBIENT="POINTLIGHTAMBIENT";
		BaseScene.POINTLIGHTSPECULAR="POINTLIGHTSPECULAR";
		BaseScene.SPOTLIGHTPOS="SPOTLIGHTPOS";
		BaseScene.SPOTLIGHTDIRECTION="SPOTLIGHTDIRECTION";
		BaseScene.SPOTLIGHTSPOT="SPOTLIGHTSPOT";
		BaseScene.SPOTLIGHTRANGE="SPOTLIGHTRANGE";
		BaseScene.SPOTLIGHTATTENUATION="SPOTLIGHTATTENUATION";
		BaseScene.SPOTLIGHTDIFFUSE="SPOTLIGHTDIFFUSE";
		BaseScene.SPOTLIGHTAMBIENT="SPOTLIGHTAMBIENT";
		BaseScene.SPOTLIGHTSPECULAR="SPOTLIGHTSPECULAR";
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
			//this.clearFlag=0;
			//this.clearColor=null;
			//this.cullingMask=0;
			//this.sky=null;
			BaseCamera.__super.call(this);
			(nearPlane===void 0)&& (nearPlane=0.1);
			(farPlane===void 0)&& (farPlane=1000);
			this._tempVector3=new Vector3();
			this._position=new Vector3();
			this._up=new Vector3();
			this._forward=new Vector3();
			this._right=new Vector3();
			this._fieldOfView=60;
			this._useUserProjectionMatrix=false;
			this._orthographic=false;
			this._viewportExpressedInClipSpace=true;
			this._renderTargetSize=Size.fullScreen;
			this._orthographicVerticalSize=10;
			this.renderingOrder=0;
			this._nearPlane=nearPlane;
			this._farPlane=farPlane;
			this.cullingMask=2147483647;
			this.clearColor=new Vector4(0.26,0.26,0.26,1.0);
			this.clearFlag=/*CLASS CONST:laya.d3.core.BaseCamera.CLEARFLAG_SOLIDCOLOR*/0;
			this._calculateProjectionMatrix();
			Laya.stage.on(/*laya.events.Event.RESIZE*/"resize",this,this._onScreenSizeChanged);
		}

		__class(BaseCamera,'laya.d3.core.BaseCamera',_super);
		var __proto=BaseCamera.prototype;
		/**
		*通过RenderingOrder属性对摄像机机型排序。
		*/
		__proto._sortCamerasByRenderingOrder=function(){
			if (this._displayedInStage){
				var cameraPool=this.scene._cameraPool;
				var n=cameraPool.length-1;
				for (var i=0;i < n;i++){
					if (cameraPool[i].renderingOrder > cameraPool[n].renderingOrder){
						var tempCamera=cameraPool[i];
						cameraPool[i]=cameraPool[n];
						cameraPool[n]=tempCamera;
					}
				}
			}
		}

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
			this.sky=null;
			this.renderTarget=null;
			Laya.stage.off(/*laya.events.Event.RESIZE*/"resize",this,this._onScreenSizeChanged);
			_super.prototype.destroy.call(this,destroyChild);
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

		//}// BoundingFrustumWorldSpace
		__proto._addSelfRenderObjects=function(){
			var cameraPool=this.scene._cameraPool;
			var cmaeraCount=cameraPool.length;
			if (cmaeraCount > 0){
				for (var i=cmaeraCount-1;i >=0;i--){
					if (this.renderingOrder <=cameraPool[i].renderingOrder){
						cameraPool.splice(i+1,0,this);
						break ;
					}
				}
				}else {
				cameraPool.push(this);
			}
		}

		__proto._clearSelfRenderObjects=function(){
			var cameraPool=this.scene._cameraPool;
			cameraPool.splice(cameraPool.indexOf(this),1);
		}

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

		/**
		*设置渲染场景的渲染目标。
		*@param value 渲染场景的渲染目标。
		*/
		/**
		*获取渲染场景的渲染目标。
		*@return 渲染场景的渲染目标。
		*/
		__getset(0,__proto,'renderTarget',function(){
			return this._renderTarget;
			},function(value){
			this._renderTarget=value;
			if (value !=null)
				this._renderTargetSize=value.size;
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
		*设置渲染目标的尺寸
		*@param value 渲染目标的尺寸。
		*/
		/**
		*获取渲染目标的尺寸
		*@return 渲染目标的尺寸。
		*/
		__getset(0,__proto,'renderTargetSize',function(){
			return this._renderTargetSize;
			},function(value){
			if (this.renderTarget !=null && this._renderTargetSize !=value){}
				this._renderTargetSize=value;
			this._calculateProjectionMatrix();
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

		__getset(0,__proto,'renderingOrder',function(){
			return this._renderingOrder;
			},function(value){
			this._renderingOrder=value;
			this._sortCamerasByRenderingOrder();
		});

		BaseCamera.RENDERINGTYPE_DEFERREDLIGHTING="DEFERREDLIGHTING";
		BaseCamera.RENDERINGTYPE_FORWARDRENDERING="FORWARDRENDERING";
		BaseCamera.CLEARFLAG_SOLIDCOLOR=0;
		BaseCamera.CLEARFLAG_SKY=1;
		BaseCamera.CLEARFLAG_DEPTHONLY=2;
		BaseCamera.CLEARFLAG_NONE=3;
		return BaseCamera;
	})(Sprite3D)


	/**
	*<code>Glitter</code> 类用于创建闪光。
	*/
	//class laya.d3.core.glitter.Glitter extends laya.d3.core.Sprite3D
	var Glitter=(function(_super){
		function Glitter(){
			this._templet=null;
			this._glitterRender=null;
			Glitter.__super.call(this);
			this._glitterRender=new GlitterRender(this);
			this._glitterRender.on(/*laya.events.Event.MATERIAL_CHANGED*/"materialchanged",this,this._onMaterialChanged);
			var material=new GlitterMaterial();
			this._glitterRender.sharedMaterial=material;
			this._templet=new GlitterTemplet(this);
			material.renderMode=/*laya.d3.core.material.BaseMaterial.RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE*/8;
			this._changeRenderObject(0);
		}

		__class(Glitter,'laya.d3.core.glitter.Glitter',_super);
		var __proto=Glitter.prototype;
		/**@private */
		__proto._changeRenderObject=function(index){
			var renderObjects=this._glitterRender.renderObject._renderElements;
			var renderElement=renderObjects[index];
			(renderElement)|| (renderElement=renderObjects[index]=new RenderElement());
			renderElement._renderObject=this._glitterRender.renderObject;
			var material=this._glitterRender.sharedMaterials[index];
			(material)|| (material=GlitterMaterial.defaultMaterial);
			var element=this._templet;
			renderElement._mainSortID=0;
			renderElement._sprite3D=this;
			renderElement.renderObj=element;
			renderElement._material=material;
			return renderElement;
		}

		/**@private */
		__proto._onMaterialChanged=function(_glitterRender,index,material){
			var renderElementCount=_glitterRender.renderObject._renderElements.length;
			(index < renderElementCount)&& this._changeRenderObject(index);
		}

		/**@private */
		__proto._clearSelfRenderObjects=function(){
			this.scene.removeFrustumCullingObject(this._glitterRender.renderObject);
		}

		/**@private */
		__proto._addSelfRenderObjects=function(){
			this.scene.addFrustumCullingObject(this._glitterRender.renderObject);
		}

		/**
		*@private
		*更新闪光。
		*@param state 渲染状态参数。
		*/
		__proto._update=function(state){
			this._templet._update(state.elapsedTime);
			state.owner=this;
			Stat.spriteCount++;
			this._childs.length && this._updateChilds(state);
		}

		/**
		*通过位置添加刀光。
		*@param position0 位置0。
		*@param position1 位置1。
		*/
		__proto.addGlitterByPositions=function(position0,position1){
			this._templet.addVertexPosition(position0,position1);
		}

		/**
		*通过位置和速度添加刀光。
		*@param position0 位置0。
		*@param velocity0 速度0。
		*@param position1 位置1。
		*@param velocity1 速度1。
		*/
		__proto.addGlitterByPositionsVelocitys=function(position0,velocity0,position1,velocity1){
			this._templet.addVertexPositionVelocity(position0,velocity0,position1,velocity1);
		}

		__proto.cloneTo=function(destObject){
			_super.prototype.cloneTo.call(this,destObject);
			var destGlitter=destObject;
			var destTemplet=destGlitter.templet;
			destTemplet.lifeTime=this._templet.lifeTime;
			destTemplet.minSegmentDistance=this._templet.minSegmentDistance;
			destTemplet.minInterpDistance=this._templet.minInterpDistance;
			destTemplet.maxSlerpCount=this._templet.maxSlerpCount;
			destTemplet.color.copyFrom(this._templet.color);
			destTemplet._maxSegments=this._templet._maxSegments;
			var destGlitterRender=destGlitter._glitterRender;
			destGlitterRender.sharedMaterials=this._glitterRender.sharedMaterials;
			destGlitterRender.enable=this._glitterRender.enable;
		}

		/**
		*<p>销毁此对象。</p>
		*@param destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
		*/
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			_super.prototype.destroy.call(this,destroyChild);
			this._glitterRender.destroy();
			this._templet=null;
		}

		/**
		*获取闪光模板。
		*@return 闪光模板。
		*/
		__getset(0,__proto,'templet',function(){
			return this._templet;
		});

		/**
		*获取刀光渲染器。
		*@return 刀光渲染器。
		*/
		__getset(0,__proto,'glitterRender',function(){
			return this._glitterRender;
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
			this.on(/*laya.events.Event.ADDED*/"added",this,this._$3__onAdded);
			this.on(/*laya.events.Event.REMOVED*/"removed",this,this._$3__onRemoved);
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
		__proto._$3__onRemoved=function(){
			this.scene._removeLight(this);
		}

		/**
		*@private
		*灯光节点添加事件处理函数。
		*/
		__proto._$3__onAdded=function(){
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
		*获取灯光的类型。
		*@return 灯光的类型。
		*/
		__getset(0,__proto,'lightType',function(){
			return-1;
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
			this._meshFilter=null;
			this._meshRender=null;
			MeshSprite3D.__super.call(this,name);
			this._meshFilter=new MeshFilter(this);
			this._meshRender=new MeshRender(this);
			this._meshFilter.on(/*laya.events.Event.MESH_CHANGED*/"meshchanged",this,this._onMeshChanged);
			this._meshRender.on(/*laya.events.Event.MATERIAL_CHANGED*/"materialchanged",this,this._onMaterialChanged);
			if (mesh){
				this._meshFilter.sharedMesh=mesh;
				if ((mesh instanceof laya.d3.resource.models.Mesh ))
					if (mesh.loaded)
				this._meshRender.sharedMaterials=(mesh).materials;
				else
				mesh.once(/*laya.events.Event.LOADED*/"loaded",this,this._applyMeshMaterials);
			}
		}

		__class(MeshSprite3D,'laya.d3.core.MeshSprite3D',_super);
		var __proto=MeshSprite3D.prototype;
		/**@private */
		__proto._changeRenderObjectByMesh=function(index){
			var renderObjects=this._meshRender.renderObject._renderElements;
			var renderElement=renderObjects[index];
			(renderElement)|| (renderElement=renderObjects[index]=new RenderElement());
			renderElement._renderObject=this._meshRender.renderObject;
			var material=this._meshRender.sharedMaterials[index];
			(material)|| (material=StandardMaterial.defaultMaterial);
			var element=this._meshFilter.sharedMesh.getRenderElement(index);
			renderElement._mainSortID=this._getSortID(element,material);
			renderElement._sprite3D=this;
			renderElement.renderObj=element;
			renderElement._material=material;
			return renderElement;
		}

		/**@private */
		__proto._changeRenderObjectByMaterial=function(index,material){
			var renderElement=this._meshRender.renderObject._renderElements[index];
			var element=this._meshFilter.sharedMesh.getRenderElement(index);
			renderElement._mainSortID=this._getSortID(element,material);
			renderElement._sprite3D=this;
			renderElement.renderObj=element;
			renderElement._material=material;
			return renderElement;
		}

		/**@private */
		__proto._changeRenderObjectsByMesh=function(){
			var renderElementsCount=this._meshFilter.sharedMesh.getRenderElementsCount();
			this._meshRender.renderObject._renderElements.length=renderElementsCount;
			for (var i=0;i < renderElementsCount;i++)
			this._changeRenderObjectByMesh(i);
		}

		/**@private */
		__proto._onMeshChanged=function(meshFilter){
			var mesh=meshFilter.sharedMesh;
			if (mesh.loaded)
				this._changeRenderObjectsByMesh();
			else
			mesh.once(/*laya.events.Event.LOADED*/"loaded",this,this._onMeshLoaded);
		}

		/**@private */
		__proto._onMeshLoaded=function(sender){
			(sender===this.meshFilter.sharedMesh)&& (this._changeRenderObjectsByMesh());
		}

		/**@private */
		__proto._onMaterialChanged=function(meshRender,index,material){
			var renderElementCount=this._meshRender.renderObject._renderElements.length;
			(index < renderElementCount)&& this._changeRenderObjectByMaterial(index,material);
		}

		/**@private */
		__proto._clearSelfRenderObjects=function(){
			this.scene.removeFrustumCullingObject(this._meshRender.renderObject);
		}

		/**@private */
		__proto._addSelfRenderObjects=function(){
			this.scene.addFrustumCullingObject(this._meshRender.renderObject);
		}

		/**@private */
		__proto._applyMeshMaterials=function(mesh){
			var shaderMaterials=this._meshRender.sharedMaterials;
			var meshMaterials=mesh.materials;
			for (var i=0,n=meshMaterials.length;i < n;i++)
			(shaderMaterials[i])|| (shaderMaterials[i]=meshMaterials[i]);
			this._meshRender.sharedMaterials=shaderMaterials;
		}

		/**
		*@private
		*/
		__proto._update=function(state){
			state.owner=this;
			if (this._enable){
				this._updateComponents(state);
				this._lateUpdateComponents(state);
			}
			Stat.spriteCount++;
			this._childs.length && this._updateChilds(state);
		}

		__proto.cloneTo=function(destObject){
			_super.prototype.cloneTo.call(this,destObject);
			var meshSprite3D=destObject;
			meshSprite3D._meshFilter.sharedMesh=this._meshFilter.sharedMesh;
			var destMeshRender=meshSprite3D._meshRender;
			destMeshRender.enable=this._meshRender.enable;
			destMeshRender.sharedMaterials=this._meshRender.sharedMaterials;
			destMeshRender.castShadow=this._meshRender.castShadow;
			destMeshRender.receiveShadow=this._meshRender.receiveShadow;
		}

		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			_super.prototype.destroy.call(this,destroyChild);
			this._meshFilter.destroy();
			this._meshRender.destroy();
		}

		/**
		*获取网格过滤器。
		*@return 网格过滤器。
		*/
		__getset(0,__proto,'meshFilter',function(){
			return this._meshFilter;
		});

		/**
		*获取网格渲染器。
		*@return 网格渲染器。
		*/
		__getset(0,__proto,'meshRender',function(){
			return this._meshRender;
		});

		return MeshSprite3D;
	})(Sprite3D)


	/**
	*<code>Particle3D</code> 3D粒子。
	*/
	//class laya.d3.core.particle.Particle3D extends laya.d3.core.Sprite3D
	var Particle3D=(function(_super){
		function Particle3D(setting){
			this._setting=null;
			this._templet=null;
			this._particleRender=null;
			Particle3D.__super.call(this);
			this._setting=setting;
			this._particleRender=new ParticleRender(this);
			this._particleRender.on(/*laya.events.Event.MATERIAL_CHANGED*/"materialchanged",this,this._onMaterialChanged);
			var material=new ParticleMaterial();
			if (setting.textureName){
				material.diffuseTexture=Texture2D.load(setting.textureName);
			}
			this._particleRender.sharedMaterial=material;
			this._templet=new ParticleTemplet3D(this,setting);
			if (setting.blendState===0)
				material.renderMode=/*laya.d3.core.material.BaseMaterial.RENDERMODE_DEPTHREAD_TRANSPARENT*/5;
			else if (setting.blendState===1)
			material.renderMode=/*laya.d3.core.material.BaseMaterial.RENDERMODE_DEPTHREAD_ADDTIVE*/7;
			this._changeRenderObject(0);
		}

		__class(Particle3D,'laya.d3.core.particle.Particle3D',_super);
		var __proto=Particle3D.prototype;
		/**@private */
		__proto._changeRenderObject=function(index){
			var renderObjects=this._particleRender.renderObject._renderElements;
			var renderElement=renderObjects[index];
			(renderElement)|| (renderElement=renderObjects[index]=new RenderElement());
			renderElement._renderObject=this._particleRender.renderObject;
			var material=this._particleRender.sharedMaterials[index];
			(material)|| (material=ParticleMaterial.defaultMaterial);
			var element=this._templet;
			renderElement._mainSortID=0;
			renderElement._sprite3D=this;
			renderElement.renderObj=element;
			renderElement._material=material;
			return renderElement;
		}

		/**@private */
		__proto._onMaterialChanged=function(_particleRender,index,material){
			var renderElementCount=_particleRender.renderObject._renderElements.length;
			(index < renderElementCount)&& this._changeRenderObject(index);
		}

		/**@private */
		__proto._clearSelfRenderObjects=function(){
			this.scene.removeFrustumCullingObject(this._particleRender.renderObject);
		}

		/**@private */
		__proto._addSelfRenderObjects=function(){
			this.scene.addFrustumCullingObject(this._particleRender.renderObject);
		}

		/**
		*更新粒子。
		*@param state 渲染相关状态参数。
		*/
		__proto._update=function(state){
			this._templet.update(state.elapsedTime);
			state.owner=this;
			Stat.spriteCount++;
			this._childs.length && this._updateChilds(state);
		}

		/**
		*添加粒子。
		*@param position 粒子位置。
		*@param velocity 粒子速度。
		*/
		__proto.addParticle=function(position,velocity){
			Vector3.add(this.transform.localPosition,position,position);
			this._templet.addParticle(position,velocity);
		}

		__proto.cloneTo=function(destObject){
			_super.prototype.cloneTo.call(this,destObject);
			var destParticle3D=destObject;
			destParticle3D._templet=this._templet;
			var destParticleRender=destParticle3D._particleRender;
			destParticleRender.sharedMaterials=this._particleRender.sharedMaterials;
			destParticleRender.enable=this._particleRender.enable;
		}

		/**
		*<p>销毁此对象。</p>
		*@param destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
		*/
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			_super.prototype.destroy.call(this,destroyChild);
			this._particleRender.destroy();
			this._templet=null;
		}

		/**
		*获取粒子模板。
		*@return 粒子模板。
		*/
		__getset(0,__proto,'templet',function(){
			return this._templet;
		});

		/**
		*获取粒子渲染器。
		*@return 粒子渲染器。
		*/
		__getset(0,__proto,'particleRender',function(){
			return this._particleRender;
		});

		return Particle3D;
	})(Sprite3D)


	/**
	*<code>ShuriKenParticle3D</code> 3D粒子。
	*/
	//class laya.d3.core.particleShuriKen.ShuriKenParticle3D extends laya.d3.core.Sprite3D
	var ShuriKenParticle3D=(function(_super){
		function ShuriKenParticle3D(material){
			this._particleSystem=null;
			this._particleRender=null;
			ShuriKenParticle3D.__super.call(this);
			this._particleRender=new ShurikenParticleRender(this);
			this._particleRender.on(/*laya.events.Event.MATERIAL_CHANGED*/"materialchanged",this,this._onMaterialChanged);
			this._particleSystem=new ShurikenParticleSystem(this);
			this._changeRenderObject(0);
			(material)&& (this._particleRender.sharedMaterial=material);
		}

		__class(ShuriKenParticle3D,'laya.d3.core.particleShuriKen.ShuriKenParticle3D',_super);
		var __proto=ShuriKenParticle3D.prototype;
		/**@private */
		__proto._changeRenderObject=function(index){
			var renderObjects=this._particleRender.renderObject._renderElements;
			var renderElement=renderObjects[index];
			(renderElement)|| (renderElement=renderObjects[index]=new RenderElement());
			renderElement._renderObject=this._particleRender.renderObject;
			var material=this._particleRender.sharedMaterials[index];
			(material)|| (material=ShurikenParticleMaterial.defaultMaterial);
			var element=this._particleSystem;
			renderElement._mainSortID=0;
			renderElement._sprite3D=this;
			renderElement.renderObj=element;
			renderElement._material=material;
			return renderElement;
		}

		/**@private */
		__proto._onMaterialChanged=function(_particleRender,index,material){
			var renderElementCount=_particleRender.renderObject._renderElements.length;
			(index < renderElementCount)&& this._changeRenderObject(index);
		}

		/**@private */
		__proto._clearSelfRenderObjects=function(){
			this.scene.removeFrustumCullingObject(this._particleRender.renderObject);
		}

		/**@private */
		__proto._addSelfRenderObjects=function(){
			this.scene.addFrustumCullingObject(this._particleRender.renderObject);
		}

		/**
		*更新粒子。
		*@param state 渲染相关状态参数。
		*/
		__proto._update=function(state){
			state.owner=this;
			this._particleSystem.update(state);
			Stat.spriteCount++;
			this._childs.length && this._updateChilds(state);
		}

		__proto.cloneTo=function(destObject){
			_super.prototype.cloneTo.call(this,destObject);
			var destShuriKenParticle3D=destObject;
			var destParticleSystem=destShuriKenParticle3D._particleSystem;
			destParticleSystem.duration=this._particleSystem.duration;
			destParticleSystem.looping=this._particleSystem.looping;
			destParticleSystem.prewarm=this._particleSystem.prewarm;
			destParticleSystem.startDelayType=this._particleSystem.startDelayType;
			destParticleSystem.startDelay=this._particleSystem.startDelay;
			destParticleSystem.startDelayMin=this._particleSystem.startDelayMin;
			destParticleSystem.startDelayMax=this._particleSystem.startDelayMax;
			destParticleSystem.startLifetimeType=this._particleSystem.startLifetimeType;
			destParticleSystem.startLifetimeConstant=this._particleSystem.startLifetimeConstant;
			this._particleSystem.startLifeTimeGradient.cloneTo(destParticleSystem.startLifeTimeGradient);
			destParticleSystem.startLifetimeConstantMin=this._particleSystem.startLifetimeConstantMin;
			destParticleSystem.startLifetimeConstantMax=this._particleSystem.startLifetimeConstantMax;
			this._particleSystem.startLifeTimeGradientMin.cloneTo(destParticleSystem.startLifeTimeGradientMin);
			this._particleSystem.startLifeTimeGradientMax.cloneTo(destParticleSystem.startLifeTimeGradientMax);
			destParticleSystem.startSpeedType=this._particleSystem.startSpeedType;
			destParticleSystem.startSpeedConstant=this._particleSystem.startSpeedConstant;
			destParticleSystem.startSpeedConstantMin=this._particleSystem.startSpeedConstantMin;
			destParticleSystem.startSpeedConstantMax=this._particleSystem.startSpeedConstantMax;
			destParticleSystem.threeDStartSize=this._particleSystem.threeDStartSize;
			destParticleSystem.startSizeType=this._particleSystem.startSizeType;
			destParticleSystem.startSizeConstant=this._particleSystem.startSizeConstant;
			destParticleSystem.startSizeConstantMin=this._particleSystem.startSizeConstantMin;
			destParticleSystem.startSizeConstantMax=this._particleSystem.startSizeConstantMax;
			destParticleSystem.threeDStartRotation=this._particleSystem.threeDStartRotation;
			destParticleSystem.startRotationType=this._particleSystem.startRotationType;
			destParticleSystem.startRotationConstant=this._particleSystem.startRotationConstant;
			destParticleSystem.startSizeConstantSeparate=this._particleSystem.startSizeConstantSeparate;
			destParticleSystem.startRotationConstantMin=this._particleSystem.startRotationConstantMin;
			destParticleSystem.startRotationConstantMax=this._particleSystem.startRotationConstantMax;
			destParticleSystem.startSizeConstantMinSeparate=this._particleSystem.startSizeConstantMinSeparate;
			destParticleSystem.startSizeConstantMaxSeparate=this._particleSystem.startSizeConstantMaxSeparate;
			destParticleSystem.randomizeRotationDirection=this._particleSystem.randomizeRotationDirection;
			destParticleSystem.startColorType=this._particleSystem.startColorType;
			destParticleSystem.startColorConstant.copyFrom(this._particleSystem.startColorConstant);
			destParticleSystem.startColorConstantMin.copyFrom(this._particleSystem.startColorConstantMin);
			destParticleSystem.startColorConstantMax.copyFrom(this._particleSystem.startColorConstantMax);
			destParticleSystem.gravity.copyFrom(this._particleSystem.gravity);
			destParticleSystem.gravityModifier=this._particleSystem.gravityModifier;
			destParticleSystem.simulationSpace=this._particleSystem.simulationSpace;
			destParticleSystem.scaleMode=this._particleSystem.scaleMode;
			destParticleSystem.playOnAwake=this._particleSystem.playOnAwake;
			this._particleSystem.velocityOverLifetime.cloneTo(destParticleSystem.velocityOverLifetime);
			this._particleSystem.colorOverLifetime.cloneTo(destParticleSystem.colorOverLifetime);
			this._particleSystem.sizeOverLifetime.cloneTo(destParticleSystem.sizeOverLifetime);
			this._particleSystem.rotationOverLifetime.cloneTo(destParticleSystem.rotationOverLifetime);
			this._particleSystem.textureSheetAnimation.cloneTo(destParticleSystem.textureSheetAnimation);
			var destParticleRender=destShuriKenParticle3D._particleRender;
			destParticleRender.sharedMaterials=this._particleRender.sharedMaterials;
			destParticleRender.enable=this._particleRender.enable;
			destParticleRender.renderMode=this._particleRender.renderMode;
			destParticleRender.stretchedBillboardCameraSpeedScale=this._particleRender.stretchedBillboardCameraSpeedScale;
			destParticleRender.stretchedBillboardSpeedScale=this._particleRender.stretchedBillboardSpeedScale;
			destParticleRender.stretchedBillboardLengthScale=this._particleRender.stretchedBillboardLengthScale;
		}

		/**
		*<p>销毁此对象。</p>
		*@param destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
		*/
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			_super.prototype.destroy.call(this,destroyChild);
			this._particleRender.destroy();
			this._particleSystem=null;
		}

		/**
		*获取粒子系统。
		*@return 粒子系统。
		*/
		__getset(0,__proto,'particleSystem',function(){
			return this._particleSystem;
		});

		/**
		*获取粒子渲染器。
		*@return 粒子渲染器。
		*/
		__getset(0,__proto,'particleRender',function(){
			return this._particleRender;
		});

		return ShuriKenParticle3D;
	})(Sprite3D)


	/**
	*...
	*@author ...
	*/
	//class laya.d3.core.material.GlitterMaterial extends laya.d3.core.material.BaseMaterial
	var GlitterMaterial=(function(_super){
		function GlitterMaterial(){
			GlitterMaterial.__super.call(this);
			this.setShaderName("GLITTER");
		}

		__class(GlitterMaterial,'laya.d3.core.material.GlitterMaterial',_super);
		var __proto=GlitterMaterial.prototype;
		__proto._setLoopShaderParams=function(state,projectionView,worldMatrix,mesh,material){
			var glitter=state.owner;
			var templet=glitter.templet;
			state.shaderValue.pushValue("UNICOLOR",templet.color.elements);
			state.shaderValue.pushValue("MVPMATRIX",state.projectionViewMatrix.elements);
			state.shaderValue.pushValue("DURATION",templet.lifeTime);
			state.shaderValue.pushValue("ALBEDO",templet._albedo.elements);
			state.shaderValue.pushValue("CURRENTTIME",templet._currentTime);
		}

		/**
		*设置漫反射贴图。
		*@param value 漫反射贴图。
		*/
		/**
		*获取漫反射贴图。
		*@return 漫反射贴图。
		*/
		__getset(0,__proto,'diffuseTexture',function(){
			return this._getTexture(0);
			},function(value){
			if (value){
				this._addShaderDefine(/*laya.d3.shader.ShaderDefines3D.DIFFUSEMAP*/0x1);
				}else {
				this._removeShaderDefine(/*laya.d3.shader.ShaderDefines3D.DIFFUSEMAP*/0x1);
			}
			this._setTexture(value,0,"DIFFUSETEXTURE");
		});

		GlitterMaterial.load=function(url){
			return Laya.loader.create(url,null,null,GlitterMaterial);
		}

		GlitterMaterial.TIME="TIME";
		GlitterMaterial.DIFFUSETEXTURE="DIFFUSETEXTURE";
		GlitterMaterial.MVPMATRIX="MVPMATRIX";
		GlitterMaterial.ALBEDO="ALBEDO";
		GlitterMaterial.CURRENTTIME="CURRENTTIME";
		GlitterMaterial.UNICOLOR="UNICOLOR";
		GlitterMaterial.DURATION="DURATION";
		GlitterMaterial._diffuseTextureIndex=0;
		__static(GlitterMaterial,
		['defaultMaterial',function(){return this.defaultMaterial=new GlitterMaterial();}
		]);
		return GlitterMaterial;
	})(BaseMaterial)


	/**
	*...
	*@author ...
	*/
	//class laya.d3.core.material.ParticleMaterial extends laya.d3.core.material.BaseMaterial
	var ParticleMaterial=(function(_super){
		function ParticleMaterial(){
			ParticleMaterial.__super.call(this);
			this._addShaderDefine(/*laya.d3.shader.ShaderDefines3D.PARTICLE3D*/0x40000);
			this.setShaderName("PARTICLE");
		}

		__class(ParticleMaterial,'laya.d3.core.material.ParticleMaterial',_super);
		var __proto=ParticleMaterial.prototype;
		__proto._setLoopShaderParams=function(state,projectionView,worldMatrix,mesh,material){
			var particle=state.owner;
			var templet=particle.templet;
			var setting=templet.settings;
			state.shaderValue.pushValue("DURATION",setting.duration);
			state.shaderValue.pushValue("GRAVITY",setting.gravity);
			state.shaderValue.pushValue("ENDVELOCITY",setting.endVelocity);
			state.shaderValue.pushValue("MVPMATRIX",worldMatrix.elements);
			state.shaderValue.pushValue("MATRIX1",state.viewMatrix.elements);
			state.shaderValue.pushValue("MATRIX2",state.projectionMatrix.elements);
			var aspectRadio=state.viewport.width / state.viewport.height;
			var viewportScale=new Vector2(0.5 / aspectRadio,-0.5);
			state.shaderValue.pushValue("VIEWPORTSCALE",viewportScale.elements);
			state.shaderValue.pushValue("CURRENTTIME",templet._currentTime);
		}

		/**
		*设置漫反射贴图。
		*@param value 漫反射贴图。
		*/
		/**
		*获取漫反射贴图。
		*@return 漫反射贴图。
		*/
		__getset(0,__proto,'diffuseTexture',function(){
			return this._getTexture(0);
			},function(value){
			if (value){
				this._addShaderDefine(/*laya.d3.shader.ShaderDefines3D.DIFFUSEMAP*/0x1);
				}else {
				this._removeShaderDefine(/*laya.d3.shader.ShaderDefines3D.DIFFUSEMAP*/0x1);
			}
			this._setTexture(value,0,"DIFFUSETEXTURE");
		});

		ParticleMaterial.load=function(url){
			return Laya.loader.create(url,null,null,ParticleMaterial);
		}

		ParticleMaterial.WORLDMATRIX="MVPMATRIX";
		ParticleMaterial.VIEWMATRIX="MATRIX1";
		ParticleMaterial.PROJECTIONMATRIX="MATRIX2";
		ParticleMaterial.VIEWPORTSCALE="VIEWPORTSCALE";
		ParticleMaterial.CURRENTTIME="CURRENTTIME";
		ParticleMaterial.DURATION="DURATION";
		ParticleMaterial.GRAVITY="GRAVITY";
		ParticleMaterial.ENDVELOCITY="ENDVELOCITY";
		ParticleMaterial.DIFFUSETEXTURE="DIFFUSETEXTURE";
		ParticleMaterial._diffuseTextureIndex=0;
		__static(ParticleMaterial,
		['defaultMaterial',function(){return this.defaultMaterial=new ParticleMaterial();}
		]);
		return ParticleMaterial;
	})(BaseMaterial)


	/**
	*...
	*@author ...
	*/
	//class laya.d3.core.material.StandardMaterial extends laya.d3.core.material.BaseMaterial
	var StandardMaterial=(function(_super){
		function StandardMaterial(){
			this._transformUV=null;
			StandardMaterial.__super.call(this);
			this._setColor(0,"MATERIALAMBIENT",StandardMaterial.AMBIENTCOLORVALUE);
			this._setColor(1,"MATERIALDIFFUSE",StandardMaterial.DIFFUSECOLORVALUE);
			this._setColor(2,"MATERIALSPECULAR",StandardMaterial.SPECULARCOLORVALUE);
			this._setColor(3,"MATERIALREFLECT",StandardMaterial.REFLECTCOLORVALUE);
			this._setColor(4,"ALBEDO",StandardMaterial.ALBEDOVALUE);
			this._setNumber(0,"ALPHATESTVALUE",0.5);
			this.setShaderName("SIMPLE");
		}

		__class(StandardMaterial,'laya.d3.core.material.StandardMaterial',_super);
		var __proto=StandardMaterial.prototype;
		/**
		*禁用灯光。
		*/
		__proto.disableLight=function(){
			this._addDisableShaderDefine(/*laya.d3.shader.ShaderDefines3D.POINTLIGHT*/0x2000 | /*laya.d3.shader.ShaderDefines3D.SPOTLIGHT*/0x4000 | /*laya.d3.shader.ShaderDefines3D.DIRECTIONLIGHT*/0x1000);
		}

		/**
		*禁用雾化。
		*/
		__proto.disableFog=function(){
			this._addDisableShaderDefine(/*laya.d3.shader.ShaderDefines3D.FOG*/0x200);
		}

		__proto._setLoopShaderParams=function(state,projectionView,worldMatrix,mesh,material){
			(this._transformUV)&& (this._transformUV.matrix);
			var pvw;
			if (worldMatrix===Matrix4x4.DEFAULT){
				pvw=projectionView;
				}else {
				pvw=StandardMaterial._tempMatrix4x40;
				Matrix4x4.multiply(projectionView,worldMatrix,pvw);
			}
			state.shaderValue.pushValue("MATRIX1",worldMatrix.elements);
			state.shaderValue.pushValue("MVPMATRIX",pvw.elements);
		}

		/**
		*克隆。
		*@param destObject 克隆源。
		*/
		__proto.cloneTo=function(destObject){
			var destStandardMaterial=destObject;
			destStandardMaterial._transformUV=this._transformUV;
			_super.prototype.cloneTo.call(this,destStandardMaterial);
		}

		/**
		*设置环境光颜色。
		*@param value 环境光颜色。
		*/
		__getset(0,__proto,'ambientColor',function(){
			return this._getColor(0);
			},function(value){
			this._setColor(0,"MATERIALAMBIENT",value);
		});

		/**
		*设置反射率。
		*@param value 反射率。
		*/
		__getset(0,__proto,'albedo',function(){
			return this._getColor(4);
			},function(value){
			this._setColor(4,"ALBEDO",value);
		});

		/**
		*设置漫反射光颜色。
		*@param value 漫反射光颜色。
		*/
		__getset(0,__proto,'diffuseColor',function(){
			return this._getColor(1);
			},function(value){
			this._setColor(1,"MATERIALDIFFUSE",value);
		});

		/**
		*设置高光颜色。
		*@param value 高光颜色。
		*/
		__getset(0,__proto,'specularColor',function(){
			return this._getColor(2);
			},function(value){
			this._setColor(2,"MATERIALSPECULAR",value);
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
			return this._getTexture(1);
			},function(value){
			if (value){
				this._addShaderDefine(/*laya.d3.shader.ShaderDefines3D.NORMALMAP*/0x2);
				}else {
				this._removeShaderDefine(/*laya.d3.shader.ShaderDefines3D.NORMALMAP*/0x2);
			}
			this._setTexture(value,1,"NORMALTEXTURE");
		});

		/**
		*设置反射颜色。
		*@param value 反射颜色。
		*/
		__getset(0,__proto,'reflectColor',function(){
			return this._getColor(3);
			},function(value){
			this._setColor(3,"MATERIALREFLECT",value);
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
			return this._getTexture(0);
			},function(value){
			if (value){
				this._addShaderDefine(/*laya.d3.shader.ShaderDefines3D.DIFFUSEMAP*/0x1);
				}else {
				this._removeShaderDefine(/*laya.d3.shader.ShaderDefines3D.DIFFUSEMAP*/0x1);
			}
			this._setTexture(value,0,"DIFFUSETEXTURE");
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
			return this._getNumber(0);
			},function(value){
			this._setNumber(0,"ALPHATESTVALUE",value);
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
			return this._getTexture(2);
			},function(value){
			if (value){
				this._addShaderDefine(/*laya.d3.shader.ShaderDefines3D.SPECULARMAP*/0x4);
				}else {
				this._removeShaderDefine(/*laya.d3.shader.ShaderDefines3D.SPECULARMAP*/0x4);
			}
			this._setTexture(value,2,"SPECULARTEXTURE");
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
			return this._getTexture(3);
			},function(value){
			if (value){
				this._addShaderDefine(/*laya.d3.shader.ShaderDefines3D.EMISSIVEMAP*/0x8);
				}else {
				this._removeShaderDefine(/*laya.d3.shader.ShaderDefines3D.EMISSIVEMAP*/0x8);
			}
			this._setTexture(value,3,"EMISSIVETEXTURE");
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
			return this._getTexture(4);
			},function(value){
			if (value){
				this._addShaderDefine(/*laya.d3.shader.ShaderDefines3D.AMBIENTMAP*/0x10);
				}else {
				this._removeShaderDefine(/*laya.d3.shader.ShaderDefines3D.AMBIENTMAP*/0x10);
			}
			this._setTexture(value,4,"AMBIENTTEXTURE");
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
			return this._getTexture(5);
			},function(value){
			if (value){
				this._addShaderDefine(/*laya.d3.shader.ShaderDefines3D.REFLECTMAP*/0x20);
				}else {
				this._removeShaderDefine(/*laya.d3.shader.ShaderDefines3D.REFLECTMAP*/0x20);
			}
			this._setTexture(value,5,"REFLECTTEXTURE");
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
			this._setMatrix4x4(0,"MATRIX2",value.matrix);
			if (value)
				this._addShaderDefine(/*laya.d3.shader.ShaderDefines3D.UVTRANSFORM*/0x100);
			else
			this._removeShaderDefine(/*laya.d3.shader.ShaderDefines3D.UVTRANSFORM*/0x100);
		});

		StandardMaterial.load=function(url){
			return Laya.loader.create(url,null,null,StandardMaterial);
		}

		StandardMaterial.WORLDMATRIX="MATRIX1";
		StandardMaterial.MVPMATRIX="MVPMATRIX";
		StandardMaterial.DIFFUSETEXTURE="DIFFUSETEXTURE";
		StandardMaterial.NORMALTEXTURE="NORMALTEXTURE";
		StandardMaterial.SPECULARTEXTURE="SPECULARTEXTURE";
		StandardMaterial.EMISSIVETEXTURE="EMISSIVETEXTURE";
		StandardMaterial.AMBIENTTEXTURE="AMBIENTTEXTURE";
		StandardMaterial.REFLECTTEXTURE="REFLECTTEXTURE";
		StandardMaterial.Bones="MATRIXARRAY0";
		StandardMaterial.ALBEDO="ALBEDO";
		StandardMaterial.ALPHATESTVALUE="ALPHATESTVALUE";
		StandardMaterial.UVANIAGE="UVAGEX";
		StandardMaterial.MATERIALAMBIENT="MATERIALAMBIENT";
		StandardMaterial.MATERIALDIFFUSE="MATERIALDIFFUSE";
		StandardMaterial.MATERIALSPECULAR="MATERIALSPECULAR";
		StandardMaterial.MATERIALREFLECT="MATERIALREFLECT";
		StandardMaterial.UVMATRIX="MATRIX2";
		StandardMaterial.UVAGE="FLOAT0";
		StandardMaterial._ambientColorIndex=0;
		StandardMaterial._diffuseColorIndex=1;
		StandardMaterial._speclarColorIndex=2;
		StandardMaterial._reflectColorIndex=3;
		StandardMaterial._albedoColorIndex=4;
		StandardMaterial._alphaTestValueIndex=0;
		StandardMaterial._diffuseTextureIndex=0;
		StandardMaterial._normalTextureIndex=1;
		StandardMaterial._specularTextureIndex=2;
		StandardMaterial._emissiveTextureIndex=3;
		StandardMaterial._ambientTextureIndex=4;
		StandardMaterial._reflectTextureIndex=5;
		StandardMaterial.TRANSFORMUV=0;
		__static(StandardMaterial,
		['_tempMatrix4x40',function(){return this._tempMatrix4x40=new Matrix4x4();},'defaultMaterial',function(){return this.defaultMaterial=new StandardMaterial();},'AMBIENTCOLORVALUE',function(){return this.AMBIENTCOLORVALUE=new Vector3(0.6,0.6,0.6);},'DIFFUSECOLORVALUE',function(){return this.DIFFUSECOLORVALUE=new Vector3(1.0,1.0,1.0);},'SPECULARCOLORVALUE',function(){return this.SPECULARCOLORVALUE=new Vector4(1.0,1.0,1.0,8.0);},'REFLECTCOLORVALUE',function(){return this.REFLECTCOLORVALUE=new Vector3(1.0,1.0,1.0);},'ALBEDOVALUE',function(){return this.ALBEDOVALUE=new Vector4(1.0,1.0,1.0,1.0);}
		]);
		return StandardMaterial;
	})(BaseMaterial)


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
			this.memorySize=byteLength;
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
			this.memorySize=0;
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
	*...
	*@author ...
	*/
	//class laya.d3.core.particleShuriKen.ShurikenParticleMaterial extends laya.d3.core.material.BaseMaterial
	var ShurikenParticleMaterial=(function(_super){
		function ShurikenParticleMaterial(){
			this._tempRotationMatrix=new Matrix4x4();
			this._uvLength=new Vector2();
			ShurikenParticleMaterial.__super.call(this);
			this.setShaderName("PARTICLESHURIKEN");
		}

		__class(ShurikenParticleMaterial,'laya.d3.core.particleShuriKen.ShurikenParticleMaterial',_super);
		var __proto=ShurikenParticleMaterial.prototype;
		__proto._setLoopShaderParams=function(state,projectionView,worldMatrix,mesh,material){
			var particle=state.owner;
			var particleSystem=particle.particleSystem;
			var particleRender=particle.particleRender;
			var transform=particle.transform;
			var finalGravityE=ShurikenParticleMaterial._tempGravity.elements;
			var gravityE=particleSystem.gravity.elements;
			var gravityModifier=particleSystem.gravityModifier;
			finalGravityE[0]=gravityE[0] *gravityModifier;
			finalGravityE[1]=gravityE[1] *gravityModifier;
			finalGravityE[2]=gravityE[2] *gravityModifier;
			var shaderValues=state.shaderValue;
			shaderValues.pushValue("GRAVITY",finalGravityE);
			switch (particleSystem.simulationSpace){
				case 0:
					shaderValues.pushValue("WORLDPOSITION",Vector3.ONE.elements);
					break ;
				case 1:
					shaderValues.pushValue("WORLDPOSITION",transform.position.elements);
					break ;
				default :
					throw new Error("ShurikenParticleMaterial: SimulationSpace value is invalid.");
				}
			Matrix4x4.createFromQuaternion(transform.rotation,this._tempRotationMatrix);
			shaderValues.pushValue("WORLDROTATIONMATRIX",this._tempRotationMatrix.elements);
			shaderValues.pushValue("THREEDSTARTROTATION",particleSystem.threeDStartRotation);
			shaderValues.pushValue("SCALINGMODE",particleSystem.scaleMode);
			switch (particleSystem.scaleMode){
				case 0:
					shaderValues.pushValue("POSITIONSCALE",transform.scale.elements);
					shaderValues.pushValue("SIZESCALE",transform.scale.elements);
					break ;
				case 1:
					shaderValues.pushValue("POSITIONSCALE",transform.localScale.elements);
					shaderValues.pushValue("SIZESCALE",transform.localScale.elements);
					break ;
				case 2:
					shaderValues.pushValue("POSITIONSCALE",transform.scale.elements);
					shaderValues.pushValue("SIZESCALE",Vector3.ONE.elements);
					break ;
				}
			shaderValues.pushValue("CAMERADIRECTION",state.camera.forward.elements);
			shaderValues.pushValue("CAMERAUP",state.camera.up.elements);
			shaderValues.pushValue("MATRIX1",state.viewMatrix.elements);
			shaderValues.pushValue("MATRIX2",state.projectionMatrix.elements);
			shaderValues.pushValue("STRETCHEDBILLBOARDLENGTHSCALE",particleRender.stretchedBillboardLengthScale);
			shaderValues.pushValue("STRETCHEDBILLBOARDSPEEDSCALE",particleRender.stretchedBillboardSpeedScale);
			shaderValues.pushValue("CURRENTTIME",particleSystem.currentTime);
			switch (particleRender.renderMode){
				case 0:
					state.shaderDefs.add(/*laya.d3.shader.ShaderDefines3D.SPHERHBILLBOARD*/0x80000);
					break ;
				case 1:
					state.shaderDefs.add(/*laya.d3.shader.ShaderDefines3D.STRETCHEDBILLBOARD*/0x100000);
					break ;
				case 2:
					state.shaderDefs.add(/*laya.d3.shader.ShaderDefines3D.HORIZONTALBILLBOARD*/0x200000);
					break ;
				case 3:
					state.shaderDefs.add(/*laya.d3.shader.ShaderDefines3D.VERTICALBILLBOARD*/0x400000);
					break ;
				};
			var velocityOverLifetime=particleSystem.velocityOverLifetime;
			if (velocityOverLifetime && velocityOverLifetime.enbale){
				state.shaderDefs.add(/*laya.d3.shader.ShaderDefines3D.VELOCITYOVERLIFETIME*/0x10000000);
				var velocity=velocityOverLifetime.velocity;
				var velocityType=velocity.type;
				shaderValues.pushValue("VOLTYPE",velocityType);
				switch (velocityType){
					case 0:
						shaderValues.pushValue("VOLVELOCITYCONST",velocity.constant.elements);
						break ;
					case 1:
						shaderValues.pushValue("VOLVELOCITYGRADIENTX",velocity.gradientX._elements);
						shaderValues.pushValue("VOLVELOCITYGRADIENTY",velocity.gradientY._elements);
						shaderValues.pushValue("VOLVELOCITYGRADIENTZ",velocity.gradientZ._elements);
						break ;
					case 2:
						shaderValues.pushValue("VOLVELOCITYCONST",velocity.constantMin.elements);
						shaderValues.pushValue("VOLVELOCITYCONSTMAX",velocity.constantMax.elements);
						break ;
					case 3:
						shaderValues.pushValue("VOLVELOCITYGRADIENTX",velocity.gradientXMin._elements);
						shaderValues.pushValue("VOLVELOCITYGRADIENTXMAX",velocity.gradientXMax._elements);
						shaderValues.pushValue("VOLVELOCITYGRADIENTY",velocity.gradientYMin._elements);
						shaderValues.pushValue("VOLVELOCITYGRADIENTYMAX",velocity.gradientYMax._elements);
						shaderValues.pushValue("VOLVELOCITYGRADIENTZ",velocity.gradientZMin._elements);
						shaderValues.pushValue("VOLVELOCITYGRADIENTZMAX",velocity.gradientZMax._elements);
						break ;
					};
				var spaceType=velocityOverLifetime.space;
				shaderValues.pushValue("VOLSPACETYPE",spaceType);
			};
			var colorOverLifetime=particleSystem.colorOverLifetime;
			if (colorOverLifetime && colorOverLifetime.enbale){
				var color=colorOverLifetime.color;
				switch (color.type){
					case 1:
						state.shaderDefs.add(/*laya.d3.shader.ShaderDefines3D.COLOROVERLIFETIME*/0x800000);
						var gradientColor=color.gradient;
						shaderValues.pushValue("COLOROVERLIFEGRADIENTALPHAS",gradientColor._alphaElements);
						shaderValues.pushValue("COLOROVERLIFEGRADIENTCOLORS",gradientColor._rgbElements);
						break ;
					case 3:
						state.shaderDefs.add(/*laya.d3.shader.ShaderDefines3D.RANDOMCOLOROVERLIFETIME*/0x1000000);
						var minGradientColor=color.gradientMin;
						var maxGradientColor=color.gradientMax;
						shaderValues.pushValue("COLOROVERLIFEGRADIENTALPHAS",minGradientColor._alphaElements);
						shaderValues.pushValue("COLOROVERLIFEGRADIENTCOLORS",minGradientColor._rgbElements);
						shaderValues.pushValue("MAXCOLOROVERLIFEGRADIENTALPHAS",maxGradientColor._alphaElements);
						shaderValues.pushValue("MAXCOLOROVERLIFEGRADIENTCOLORS",maxGradientColor._rgbElements);
						break ;
					}
			};
			var sizeOverLifetime=particleSystem.sizeOverLifetime;
			if (sizeOverLifetime && sizeOverLifetime.enbale){
				var size=sizeOverLifetime.size;
				var sizeType=size.type;
				var sizeSeparate=false;
				switch (sizeType){
					case 0:
						sizeSeparate=size.separateAxes;
						state.shaderDefs.add(/*laya.d3.shader.ShaderDefines3D.SIZEOVERLIFETIME*/0x2000000);
						shaderValues.pushValue("SOLTYPE",sizeType);
						shaderValues.pushValue("SOLSEPRARATE",sizeSeparate);
						if (sizeSeparate){
							shaderValues.pushValue("SOLSIZEGRADIENTX",size.gradientSizeX._elements);
							shaderValues.pushValue("SOLSIZEGRADIENTY",size.gradientSizeY._elements);
							shaderValues.pushValue("SOLSizeGradientZ",size.gradientSizeZ._elements);
							}else {
							shaderValues.pushValue("SOLSIZEGRADIENT",size.gradientSize._elements);
						}
						break ;
					case 2:
						sizeSeparate=size.separateAxes;
						state.shaderDefs.add(/*laya.d3.shader.ShaderDefines3D.SIZEOVERLIFETIME*/0x2000000);
						shaderValues.pushValue("SOLTYPE",sizeType);
						shaderValues.pushValue("SOLSEPRARATE",sizeSeparate);
						if (sizeSeparate){
							shaderValues.pushValue("SOLSIZEGRADIENTX",size.gradientXMin._elements);
							shaderValues.pushValue("SOLSIZEGRADIENTXMAX",size.gradientXMax._elements);
							shaderValues.pushValue("SOLSIZEGRADIENTY",size.gradientYMin._elements);
							shaderValues.pushValue("SOLSIZEGRADIENTYMAX",size.gradientYMax._elements);
							shaderValues.pushValue("SOLSizeGradientZ",size.gradientZMin._elements);
							shaderValues.pushValue("SOLSizeGradientZMAX",size.gradientZMax._elements);
							}else {
							shaderValues.pushValue("SOLSIZEGRADIENT",size.gradientMin._elements);
							shaderValues.pushValue("SOLSizeGradientMax",size.gradientMax._elements);
						}
						break ;
					}
			};
			var rotationOverLifetime=particleSystem.rotationOverLifetime;
			if (rotationOverLifetime && rotationOverLifetime.enbale){
				state.shaderDefs.add(/*laya.d3.shader.ShaderDefines3D.ROTATIONOVERLIFETIME*/0x4000000);
				var rotation=rotationOverLifetime.angularVelocity;
				var rotationType=rotation.type;
				var rotationSeparate=rotation.separateAxes;
				shaderValues.pushValue("ROLTYPE",rotationType);
				shaderValues.pushValue("ROLSEPRARATE",rotationSeparate);
				switch (rotationType){
					case 0:
						if (rotationSeparate){
							shaderValues.pushValue("ROLANGULARVELOCITYCONSTSEPRARATE",rotation.constantSeparate.elements);
							}else {
							shaderValues.pushValue("ROLANGULARVELOCITYCONST",rotation.constant);
						}
						break ;
					case 1:
						if (rotationSeparate){
							shaderValues.pushValue("ROLANGULARVELOCITYGRADIENTX",rotation.gradientX._elements);
							shaderValues.pushValue("ROLANGULARVELOCITYGRADIENTY",rotation.gradientY._elements);
							shaderValues.pushValue("ROLANGULARVELOCITYGRADIENTZ",rotation.gradientZ._elements);
							}else {
							shaderValues.pushValue("ROLANGULARVELOCITYGRADIENT",rotation.gradient._elements);
						}
						break ;
					case 2:
						if (rotationSeparate){
							shaderValues.pushValue("ROLANGULARVELOCITYCONSTSEPRARATE",rotation.constantMinSeparate.elements);
							shaderValues.pushValue("ROLANGULARVELOCITYCONSTMAXSEPRARATE",rotation.constantMaxSeparate.elements);
							}else {
							shaderValues.pushValue("ROLANGULARVELOCITYCONST",rotation.constantMin);
							shaderValues.pushValue("ROLANGULARVELOCITYCONSTMAX",rotation.constantMax);
						}
						break ;
					case 3:
						if (rotationSeparate){
							shaderValues.pushValue("ROLANGULARVELOCITYGRADIENTX",rotation.gradientXMin._elements);
							shaderValues.pushValue("ROLANGULARVELOCITYGRADIENTXMAX",rotation.gradientXMax._elements);
							shaderValues.pushValue("ROLANGULARVELOCITYGRADIENTY",rotation.gradientYMin._elements);
							shaderValues.pushValue("ROLANGULARVELOCITYGRADIENTYMAX",rotation.gradientYMax._elements);
							shaderValues.pushValue("ROLANGULARVELOCITYGRADIENTZ",rotation.gradientZMin._elements);
							shaderValues.pushValue("ROLANGULARVELOCITYGRADIENTZMAX",rotation.gradientZMax._elements);
							}else {
							shaderValues.pushValue("ROLANGULARVELOCITYGRADIENT",rotation.gradientMin._elements);
							shaderValues.pushValue("ROLANGULARVELOCITYGRADIENTMAX",rotation.gradientMax._elements);
						}
						break ;
					}
			};
			var textureSheetAnimation=particleSystem.textureSheetAnimation;
			if (textureSheetAnimation && textureSheetAnimation.enbale){
				var frameOverTime=textureSheetAnimation.frame;
				var textureAniType=frameOverTime.type;
				if (textureAniType===1 || textureAniType===3){
					state.shaderDefs.add(/*laya.d3.shader.ShaderDefines3D.TEXTURESHEETANIMATION*/0x8000000);
					shaderValues.pushValue("TEXTURESHEETANIMATIONTYPE",textureAniType);
					shaderValues.pushValue("TEXTURESHEETANIMATIONCYCLES",textureSheetAnimation.cycles);
					var title=textureSheetAnimation.tiles;
					var _uvLengthE=this._uvLength.elements;
					_uvLengthE[0]=1.0 / title.x;
					_uvLengthE[1]=1.0 / title.y;
					shaderValues.pushValue("TEXTURESHEETANIMATIONSUBUVLENGTH",this._uvLength.elements);
				}
				switch (textureAniType){
					case 1:
						shaderValues.pushValue("TEXTURESHEETANIMATIONGRADIENTUVS",frameOverTime.frameOverTimeData._elements);
						break ;
					case 3:
						shaderValues.pushValue("TEXTURESHEETANIMATIONGRADIENTUVS",frameOverTime.frameOverTimeDataMin._elements);
						shaderValues.pushValue("TEXTURESHEETANIMATIONGRADIENTMAXUVS",frameOverTime.frameOverTimeDataMax._elements);
						break ;
					}
			}
		}

		/**
		*设置漫反射贴图。
		*@param value 漫反射贴图。
		*/
		/**
		*获取漫反射贴图。
		*@return 漫反射贴图。
		*/
		__getset(0,__proto,'diffuseTexture',function(){
			return this._getTexture(0);
			},function(value){
			if (value){
				this._addShaderDefine(/*laya.d3.shader.ShaderDefines3D.DIFFUSEMAP*/0x1);
				}else {
				this._removeShaderDefine(/*laya.d3.shader.ShaderDefines3D.DIFFUSEMAP*/0x1);
			}
			this._setTexture(value,0,"DIFFUSETEXTURE");
		});

		ShurikenParticleMaterial.load=function(url){
			return Laya.loader.create(url,null,null,ShurikenParticleMaterial);
		}

		ShurikenParticleMaterial.WORLDPOSITION="WORLDPOSITION";
		ShurikenParticleMaterial.WORLDROTATIONMATRIX="WORLDROTATIONMATRIX";
		ShurikenParticleMaterial.THREEDSTARTROTATION="THREEDSTARTROTATION";
		ShurikenParticleMaterial.SCALINGMODE="SCALINGMODE";
		ShurikenParticleMaterial.POSITIONSCALE="POSITIONSCALE";
		ShurikenParticleMaterial.SIZESCALE="SIZESCALE";
		ShurikenParticleMaterial.VIEWMATRIX="MATRIX1";
		ShurikenParticleMaterial.PROJECTIONMATRIX="MATRIX2";
		ShurikenParticleMaterial.CURRENTTIME="CURRENTTIME";
		ShurikenParticleMaterial.GRAVITY="GRAVITY";
		ShurikenParticleMaterial.DIFFUSETEXTURE="DIFFUSETEXTURE";
		ShurikenParticleMaterial.CAMERADIRECTION="CAMERADIRECTION";
		ShurikenParticleMaterial.CAMERAUP="CAMERAUP";
		ShurikenParticleMaterial.STRETCHEDBILLBOARDLENGTHSCALE="STRETCHEDBILLBOARDLENGTHSCALE";
		ShurikenParticleMaterial.STRETCHEDBILLBOARDSPEEDSCALE="STRETCHEDBILLBOARDSPEEDSCALE";
		ShurikenParticleMaterial.VOLTYPE="VOLTYPE";
		ShurikenParticleMaterial.VOLVELOCITYCONST="VOLVELOCITYCONST";
		ShurikenParticleMaterial.VOLVELOCITYGRADIENTX="VOLVELOCITYGRADIENTX";
		ShurikenParticleMaterial.VOLVELOCITYGRADIENTY="VOLVELOCITYGRADIENTY";
		ShurikenParticleMaterial.VOLVELOCITYGRADIENTZ="VOLVELOCITYGRADIENTZ";
		ShurikenParticleMaterial.VOLVELOCITYCONSTMAX="VOLVELOCITYCONSTMAX";
		ShurikenParticleMaterial.VOLVELOCITYGRADIENTXMAX="VOLVELOCITYGRADIENTXMAX";
		ShurikenParticleMaterial.VOLVELOCITYGRADIENTYMAX="VOLVELOCITYGRADIENTYMAX";
		ShurikenParticleMaterial.VOLVELOCITYGRADIENTZMAX="VOLVELOCITYGRADIENTZMAX";
		ShurikenParticleMaterial.VOLSPACETYPE="VOLSPACETYPE";
		ShurikenParticleMaterial.COLOROVERLIFEGRADIENTALPHAS="COLOROVERLIFEGRADIENTALPHAS";
		ShurikenParticleMaterial.COLOROVERLIFEGRADIENTCOLORS="COLOROVERLIFEGRADIENTCOLORS";
		ShurikenParticleMaterial.MAXCOLOROVERLIFEGRADIENTALPHAS="MAXCOLOROVERLIFEGRADIENTALPHAS";
		ShurikenParticleMaterial.MAXCOLOROVERLIFEGRADIENTCOLORS="MAXCOLOROVERLIFEGRADIENTCOLORS";
		ShurikenParticleMaterial.SOLTYPE="SOLTYPE";
		ShurikenParticleMaterial.SOLSEPRARATE="SOLSEPRARATE";
		ShurikenParticleMaterial.SOLSIZEGRADIENT="SOLSIZEGRADIENT";
		ShurikenParticleMaterial.SOLSIZEGRADIENTX="SOLSIZEGRADIENTX";
		ShurikenParticleMaterial.SOLSIZEGRADIENTY="SOLSIZEGRADIENTY";
		ShurikenParticleMaterial.SOLSizeGradientZ="SOLSizeGradientZ";
		ShurikenParticleMaterial.SOLSizeGradientMax="SOLSizeGradientMax";
		ShurikenParticleMaterial.SOLSIZEGRADIENTXMAX="SOLSIZEGRADIENTXMAX";
		ShurikenParticleMaterial.SOLSIZEGRADIENTYMAX="SOLSIZEGRADIENTYMAX";
		ShurikenParticleMaterial.SOLSizeGradientZMAX="SOLSizeGradientZMAX";
		ShurikenParticleMaterial.ROLTYPE="ROLTYPE";
		ShurikenParticleMaterial.ROLSEPRARATE="ROLSEPRARATE";
		ShurikenParticleMaterial.ROLANGULARVELOCITYCONST="ROLANGULARVELOCITYCONST";
		ShurikenParticleMaterial.ROLANGULARVELOCITYCONSTSEPRARATE="ROLANGULARVELOCITYCONSTSEPRARATE";
		ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENT="ROLANGULARVELOCITYGRADIENT";
		ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENTX="ROLANGULARVELOCITYGRADIENTX";
		ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENTY="ROLANGULARVELOCITYGRADIENTY";
		ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENTZ="ROLANGULARVELOCITYGRADIENTZ";
		ShurikenParticleMaterial.ROLANGULARVELOCITYCONSTMAX="ROLANGULARVELOCITYCONSTMAX";
		ShurikenParticleMaterial.ROLANGULARVELOCITYCONSTMAXSEPRARATE="ROLANGULARVELOCITYCONSTMAXSEPRARATE";
		ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENTMAX="ROLANGULARVELOCITYGRADIENTMAX";
		ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENTXMAX="ROLANGULARVELOCITYGRADIENTXMAX";
		ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENTYMAX="ROLANGULARVELOCITYGRADIENTYMAX";
		ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENTZMAX="ROLANGULARVELOCITYGRADIENTZMAX";
		ShurikenParticleMaterial.TEXTURESHEETANIMATIONTYPE="TEXTURESHEETANIMATIONTYPE";
		ShurikenParticleMaterial.TEXTURESHEETANIMATIONCYCLES="TEXTURESHEETANIMATIONCYCLES";
		ShurikenParticleMaterial.TEXTURESHEETANIMATIONSUBUVLENGTH="TEXTURESHEETANIMATIONSUBUVLENGTH";
		ShurikenParticleMaterial.TEXTURESHEETANIMATIONGRADIENTUVS="TEXTURESHEETANIMATIONGRADIENTUVS";
		ShurikenParticleMaterial.TEXTURESHEETANIMATIONGRADIENTMAXUVS="TEXTURESHEETANIMATIONGRADIENTMAXUVS";
		ShurikenParticleMaterial._diffuseTextureIndex=0;
		__static(ShurikenParticleMaterial,
		['_tempGravity',function(){return this._tempGravity=new Vector3();},'defaultMaterial',function(){return this.defaultMaterial=new ShurikenParticleMaterial();}
		]);
		return ShurikenParticleMaterial;
	})(BaseMaterial)


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
			this._cacheAnimationDatas=[];
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
			this._player.on(/*laya.events.Event.STOPPED*/"stopped",this,function(){
				if (_$this._player.returnToZeroStopped){
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
			if (!this._templet || !this._templet.loaded || this._player.state!==/*laya.ani.AnimationState.playing*/2)
				return;
			var rate=this._player.playbackRate *state.scene.timer.scale;
			var frameIndex=(this._player.isCache && rate >=1.0)? this.currentFrameIndex :-1;
			var animationClipIndex=this.currentAnimationClipIndex;
			if (frameIndex!==-1 && this._lastFrameIndex===frameIndex){
				laya.d3.component.Component3D.prototype._update.call(this,state);
				return;
			}
			if (this._player.isCache && rate >=1.0){
				var cache=this._templet.getAnimationDataWithCache(this._player.cacheFrameRate,this._cacheAnimationDatas,animationClipIndex,frameIndex);
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
			if (this._player.isCache && rate >=1.0){
				this._currentAnimationData=new Float32Array(nodeCount *10);
				}else{
				(this._tempCurAnimationData)|| (this._tempCurAnimationData=new Float32Array(nodeCount *10));
				this._currentAnimationData=this._tempCurAnimationData;
			}
			if (this._player.isCache && rate >=1.0)
				this._templet.getOriginalData(animationClipIndex,this._currentAnimationData,this._player._fullFrames[animationClipIndex],frameIndex,this._player.currentPlayTime);
			else
			this._templet.getOriginalDataUnfixedRate(animationClipIndex,this._currentAnimationData,this._player.currentPlayTime);
			if (this._player.isCache && rate >=1.0){
				this._templet.setAnimationDataWithCache(this._player.cacheFrameRate,this._cacheAnimationDatas,animationClipIndex,frameIndex,this._currentAnimationData);
			}
			this._lastFrameIndex=frameIndex;
			laya.d3.component.Component3D.prototype._update.call(this,state);
			this._effect();
		}

		return CameraAnimations;
	})(KeyframeAnimations)


	/**
	*<code>RigidAnimations</code> 类用于创建变换动画组件。
	*/
	//class laya.d3.component.animation.RigidAnimations extends laya.d3.component.animation.KeyframeAnimations
	var RigidAnimations=(function(_super){
		function RigidAnimations(){
			this._animationSprites=null;
			this._animationSpritesInitLocalMatrix=null;
			this._tempCurAnimationData=null;
			this._curOriginalData=null;
			this._lastFrameIndex=-1;
			this._curAnimationDatas=null;
			RigidAnimations.__super.call(this);
			this._animationSprites=[];
			this._animationSpritesInitLocalMatrix=[];
		}

		__class(RigidAnimations,'laya.d3.component.animation.RigidAnimations',_super);
		var __proto=RigidAnimations.prototype;
		/**
		*@private
		*/
		__proto._init=function(){
			var nodes=this._templet.getNodes(this.currentAnimationClipIndex);
			var curParentSprite=this._owner;
			var nodeLength=nodes.length;
			var pathStart=0;
			var extentDatas=new Uint16Array(this._templet.getPublicExtData());
			for (var i=0;i < nodeLength;i++){
				var hierarchys=extentDatas.slice(pathStart+1,pathStart+1+extentDatas[pathStart]);
				pathStart+=(extentDatas[pathStart]+1);
				for (var j=1;j < hierarchys.length;j++){
					var childIndex=hierarchys[j];
					curParentSprite=curParentSprite._childs[hierarchys[j]];
				};
				var curSprite=curParentSprite.getChildByName(nodes[i].name);
				if (!curSprite)
					break ;
				this._animationSprites[i]=curSprite;
				var localMatrix=this._animationSpritesInitLocalMatrix[i];
				(localMatrix)|| (localMatrix=this._animationSpritesInitLocalMatrix[i]=new Matrix4x4());
				curSprite.transform.localMatrix.cloneTo(localMatrix);
				curParentSprite=this._owner;
			}
		}

		/**
		*@private
		*/
		__proto._animtionPlay=function(){
			if (this._templet.loaded)
				this._init();
			else
			this._templet.once(/*laya.events.Event.LOADED*/"loaded",this,this._init);
		}

		/**
		*@private
		*/
		__proto._animtionStop=function(){
			this._lastFrameIndex=-1;
			if (this._player.returnToZeroStopped){
				this._curAnimationDatas=null;
				for (var i=0;i < this._animationSprites.length;i++)
				this._animationSprites[i].transform.localMatrix=this._animationSpritesInitLocalMatrix[i];
			}
		}

		/**
		*@private
		*摄像机动画作用函数。
		*/
		__proto._effectAnimation=function(nodes){
			for (var nodeIndex=0,nodeLength=this._animationSprites.length;nodeIndex < nodeLength;nodeIndex++){
				var sprite=this._animationSprites[nodeIndex];
				var matrix=sprite.transform.localMatrix;
				var matrixE=matrix.elements;
				for (var i=0;i < 16;i++)
				matrixE[i]=this._curAnimationDatas[nodeIndex *16+i];
				sprite.transform.localMatrix=matrix;
			}
		}

		/**
		*@private
		*初始化载入摄像机动画组件。
		*@param owner 所属精灵对象。
		*/
		__proto._load=function(owner){
			_super.prototype._load.call(this,owner);
			this._player.on(/*laya.events.Event.STOPPED*/"stopped",this,this._animtionStop);
			this._player.on(/*laya.events.Event.PLAYED*/"played",this,this._animtionPlay);
		}

		/**
		*@private
		*更新摄像机动画组件。
		*@param state 渲染状态。
		*/
		__proto._update=function(state){
			if (this._player.state!==/*laya.ani.AnimationState.playing*/2 || !this._templet || !this._templet.loaded)
				return;
			var rate=this._player.playbackRate *state.scene.timer.scale;
			var cachePlayRate=this._player.cachePlayRate;
			var isCache=this._player.isCache && rate >=cachePlayRate;
			var frameIndex=isCache ? this.currentFrameIndex :-1;
			if (frameIndex!==-1 && this._lastFrameIndex===frameIndex)
				return;
			var animationClipIndex=this.currentAnimationClipIndex;
			var nodes=this._templet.getNodes(animationClipIndex);
			var animationDatasCache=this._templet._animationDatasCache;
			if (isCache){
				var cacheData=this._templet.getAnimationDataWithCache(cachePlayRate,animationDatasCache,animationClipIndex,frameIndex);
				if (cacheData){
					this._curAnimationDatas=cacheData;
					this._lastFrameIndex=frameIndex;
					this._effectAnimation(nodes);
					return;
				}
			};
			var nodeFloatCount=nodes.length *16;
			if (isCache){
				this._curAnimationDatas=new Float32Array(nodeFloatCount);
				}else{
				(this._tempCurAnimationData)|| (this._tempCurAnimationData=new Float32Array(nodeFloatCount));
				this._curAnimationDatas=this._tempCurAnimationData;
			}
			this._curOriginalData || (this._curOriginalData=new Float32Array(this._templet.getTotalkeyframesLength(animationClipIndex)));
			if (isCache)
				this._templet.getOriginalData(animationClipIndex,this._curOriginalData,this._player._fullFrames[animationClipIndex],frameIndex,this._player.currentFrameTime);
			else
			this._templet.getOriginalDataUnfixedRate(animationClipIndex,this._curOriginalData,this._player.currentPlayTime);
			Utils3D._computeRootAnimationData(nodes,this._curOriginalData,this._curAnimationDatas);
			if (isCache){
				this._templet.setAnimationDataWithCache(cachePlayRate,animationDatasCache,animationClipIndex,frameIndex,this._curAnimationDatas);
			}
			this._lastFrameIndex=frameIndex;
			this._effectAnimation(nodes);
		}

		/**
		*@private
		*卸载组件时执行。
		*/
		__proto._unload=function(owner){
			_super.prototype._unload.call(this,owner);
			this._player.off(/*laya.events.Event.STOPPED*/"stopped",this,this._animtionStop);
			this._player.off(/*laya.events.Event.PLAYED*/"played",this,this._animtionPlay);
		}

		/**
		*设置url地址。
		*@param value 地址。
		*/
		__getset(0,__proto,'url',null,function(value){
			_super.prototype._$set_url.call(this,value);
			this._curOriginalData=null;
			this._curAnimationDatas=null;
			this._tempCurAnimationData=null;
			(this._templet._animationDatasCache)|| (this._templet._animationDatasCache=[]);
		});

		__getset(0,__proto,'templet',_super.prototype._$get_templet,function(value){
			_super.prototype._$set_templet.call(this,value);
			this._curOriginalData=null;
			this._curAnimationDatas=null;
			this._tempCurAnimationData=null;
			(this._templet._animationDatasCache)|| (this._templet._animationDatasCache=[]);
		});

		return RigidAnimations;
	})(KeyframeAnimations)


	/**
	*<code>SkinAnimations</code> 类用于创建蒙皮动画组件。
	*/
	//class laya.d3.component.animation.SkinAnimations extends laya.d3.component.animation.KeyframeAnimations
	var SkinAnimations=(function(_super){
		function SkinAnimations(){
			this._tempCurAnimationData=null;
			this._tempCurBonesData=null;
			this._curOriginalData=null;
			this._extenData=null;
			this._lastFrameIndex=-1;
			this._curMeshAnimationData=null;
			this._curBonesDatas=null;
			this._curAnimationDatas=null;
			this._ownerMesh=null;
			SkinAnimations.__super.call(this);
		}

		__class(SkinAnimations,'laya.d3.component.animation.SkinAnimations',_super);
		var __proto=SkinAnimations.prototype;
		/**@private */
		__proto._getAnimationDatasWithCache=function(rate,mesh,cacheDatas,aniIndex,frameIndex){
			var aniDatas=cacheDatas[aniIndex];
			if (!aniDatas){
				return null;
				}else {
				var rateDatas=aniDatas[rate];
				if (!rateDatas)
					return null;
				else {
					var meshDatas=rateDatas[mesh.id];
					if (!meshDatas)
						return null;
					else
					return meshDatas[frameIndex];
				}
			}
		}

		/**@private */
		__proto._setAnimationDatasWithCache=function(rate,mesh,cacheDatas,aniIndex,frameIndex,animationDatas){
			var aniDatas=(cacheDatas[aniIndex])|| (cacheDatas[aniIndex]={});
			var rateDatas=(aniDatas[rate])|| (aniDatas[rate]={});
			var meshDatas=(rateDatas[mesh.id])|| (rateDatas[mesh.id]=[]);
			meshDatas[frameIndex]=animationDatas;
		}

		/**@private */
		__proto._onAnimationPlayMeshLoaded=function(){
			var renderElements=this._ownerMesh.meshRender.renderObject._renderElements;
			for (var i=0,n=renderElements.length;i < n;i++)
			renderElements[i]._canDynamicBatch=false;
		}

		/**@private */
		__proto._onAnimationPlay=function(){
			var mesh=this._ownerMesh.meshFilter.sharedMesh;
			if (mesh.loaded)
				this._onAnimationPlayMeshLoaded();
			else
			mesh.on(/*laya.events.Event.LOADED*/"loaded",this,this._onAnimationPlayMeshLoaded);
		}

		/**@private */
		__proto._onAnimationStop=function(){
			this._lastFrameIndex=-1;
			if (this._player.returnToZeroStopped){
				this._curBonesDatas=null;
				this._curAnimationDatas=null;
			};
			var renderElements=this._ownerMesh.meshRender.renderObject._renderElements;
			for (var i=0,n=renderElements.length;i < n;i++)
			renderElements[i]._canDynamicBatch=true;
		}

		/**
		*@private
		*初始化载入蒙皮动画组件。
		*@param owner 所属精灵对象。
		*/
		__proto._load=function(owner){
			_super.prototype._load.call(this,owner);
			this._ownerMesh=(owner);
			this._player.on(/*laya.events.Event.PLAYED*/"played",this,this._onAnimationPlay);
			this._player.on(/*laya.events.Event.STOPPED*/"stopped",this,this._onAnimationStop);
		}

		/**
		*预缓存帧动画数据（需确保动画模板、模型模板都已加载完成）。
		*@param animationClipIndex 动画索引
		*@param meshTemplet 动画模板
		*/
		__proto.preComputeKeyFrames=function(animationClipIndex){
			if (!this._templet.loaded || !this._ownerMesh.meshFilter.sharedMesh.loaded)
				throw new Error("SkinAnimations: must to be sure animation templet and mesh templet has loaded.");
			var cachePlayRate=this._player.cachePlayRate;
			var cacheFrameRateInterval=this._player.cacheFrameRateInterval *cachePlayRate;
			var maxKeyFrame=Math.floor(this._templet.getAniDuration(animationClipIndex)/ cacheFrameRateInterval);
			for (var frameIndex=0;frameIndex <=maxKeyFrame;frameIndex++){
				var boneDatasCache=this._templet._animationDatasCache[0];
				var animationDatasCache=this._templet._animationDatasCache[1];
				var mesh=this._ownerMesh.meshFilter.sharedMesh;
				var cacheAnimationDatas=this._getAnimationDatasWithCache(cachePlayRate,mesh,animationDatasCache,animationClipIndex,frameIndex);
				if (cacheAnimationDatas){
					continue ;
				};
				var bones=this._templet.getNodes(animationClipIndex);
				var boneFloatCount=bones.length *16;
				(this._curMeshAnimationData)|| (this._curMeshAnimationData=new Float32Array(boneFloatCount));
				var i=0,n=0;
				this._curAnimationDatas=[];
				for (i=0,n=mesh.getSubMeshCount();i < n;i++)
				this._curAnimationDatas[i]=new Float32Array(mesh.getSubMesh(i)._boneIndices.length *16);
				this._curBonesDatas=new Float32Array(boneFloatCount);
				this._curOriginalData || (this._curOriginalData=new Float32Array(this._templet.getTotalkeyframesLength(animationClipIndex)));
				this._templet.getOriginalData(animationClipIndex,this._curOriginalData,this._player._fullFrames[animationClipIndex],frameIndex,cacheFrameRateInterval *frameIndex);
				var inverseAbsoluteBindPoses=mesh.InverseAbsoluteBindPoses;
				if (inverseAbsoluteBindPoses){
					Utils3D._computeBoneAndAnimationDatasByBindPoseMatrxix(bones,this._curOriginalData,inverseAbsoluteBindPoses,this._curBonesDatas,this._curMeshAnimationData);
					}else {
					this._extenData || (this._extenData=new Float32Array(this._templet.getPublicExtData()));
					Utils3D._computeBoneAndAnimationDatas(bones,this._curOriginalData,this._extenData,this._curBonesDatas,this._curMeshAnimationData);
				}
				for (i=0,n=mesh.getSubMeshCount();i < n;i++){
					var subMesh=mesh.getSubMesh(i);
					SkinAnimations._computeSubMeshAniDatas(i,subMesh._boneIndices,this._curMeshAnimationData,this._curAnimationDatas);
				}
				this._setAnimationDatasWithCache(cachePlayRate,mesh,animationDatasCache,animationClipIndex,frameIndex,this._curAnimationDatas);
				this._templet.setAnimationDataWithCache(cachePlayRate,boneDatasCache,animationClipIndex,frameIndex,this._curBonesDatas);
			}
		}

		/**
		*@private
		*更新蒙皮动画组件。
		*@param state 渲染状态参数。
		*/
		__proto._update=function(state){
			var mesh=this._ownerMesh.meshFilter.sharedMesh;
			if (this._player.state!==/*laya.ani.AnimationState.playing*/2 || !this._templet || !this._templet.loaded || !mesh.loaded)
				return;
			var rate=this._player.playbackRate *state.scene.timer.scale;
			var cachePlayRate=this._player.cachePlayRate;
			var isCache=this._player.isCache && rate >=cachePlayRate;
			var frameIndex=isCache ? this.currentFrameIndex :-1;
			if (frameIndex!==-1 && this._lastFrameIndex===frameIndex)
				return;
			var animationClipIndex=this.currentAnimationClipIndex;
			var boneDatasCache=this._templet._animationDatasCache[0];
			var animationDatasCache=this._templet._animationDatasCache[1];
			if (isCache){
				var cacheAnimationDatas=this._getAnimationDatasWithCache(cachePlayRate,mesh,animationDatasCache,animationClipIndex,frameIndex);
				if (cacheAnimationDatas){
					this._curAnimationDatas=cacheAnimationDatas;
					this._curBonesDatas=this._templet.getAnimationDataWithCache(cachePlayRate,boneDatasCache,animationClipIndex,frameIndex);
					this._lastFrameIndex=frameIndex;
					return;
				}
			};
			var isCacheBonesDatas=false;
			if (isCache){
				this._curBonesDatas=this._templet.getAnimationDataWithCache(cachePlayRate,boneDatasCache,animationClipIndex,frameIndex);
				isCacheBonesDatas=this._curBonesDatas ? true :false;
			};
			var bones=this._templet.getNodes(animationClipIndex);
			var boneFloatCount=bones.length *16;
			(this._curMeshAnimationData)|| (this._curMeshAnimationData=new Float32Array(boneFloatCount));
			var i=0,n=0;
			if (isCache){
				this._curAnimationDatas=[];
				for (i=0,n=mesh.getSubMeshCount();i < n;i++)
				this._curAnimationDatas[i]=new Float32Array(mesh.getSubMesh(i)._boneIndices.length *16);
				(isCacheBonesDatas)|| (this._curBonesDatas=new Float32Array(boneFloatCount));
				}else {
				if (!this._tempCurAnimationData){
					this._tempCurAnimationData=[];
					for (i=0,n=mesh.getSubMeshCount();i < n;i++)
					this._tempCurAnimationData[i]=new Float32Array(mesh.getSubMesh(i)._boneIndices.length *16);
				}
				(this._tempCurBonesData)|| (this._tempCurBonesData=new Float32Array(boneFloatCount));
				this._curAnimationDatas=this._tempCurAnimationData;
				this._curBonesDatas=this._tempCurBonesData;
			}
			this._curOriginalData || (this._curOriginalData=new Float32Array(this._templet.getTotalkeyframesLength(animationClipIndex)));
			if (isCache)
				this._templet.getOriginalData(animationClipIndex,this._curOriginalData,this._player._fullFrames[animationClipIndex],frameIndex,this._player.currentFrameTime);
			else
			this._templet.getOriginalDataUnfixedRate(animationClipIndex,this._curOriginalData,this._player.currentPlayTime);
			var inverseAbsoluteBindPoses=mesh.InverseAbsoluteBindPoses;
			if (inverseAbsoluteBindPoses){
				if (isCache && isCacheBonesDatas)
					Utils3D._computeAnimationDatasByArrayAndMatrixFast(inverseAbsoluteBindPoses,this._curBonesDatas,this._curMeshAnimationData);
				else
				Utils3D._computeBoneAndAnimationDatasByBindPoseMatrxix(bones,this._curOriginalData,inverseAbsoluteBindPoses,this._curBonesDatas,this._curMeshAnimationData);
				}else {
				this._extenData || (this._extenData=new Float32Array(this._templet.getPublicExtData()));
				if (isCache && isCacheBonesDatas)
					Utils3D._computeAnimationDatas(this._extenData,this._curBonesDatas,this._curMeshAnimationData);
				else
				Utils3D._computeBoneAndAnimationDatas(bones,this._curOriginalData,this._extenData,this._curBonesDatas,this._curMeshAnimationData);
			}
			for (i=0,n=mesh.getSubMeshCount();i < n;i++){
				var subMesh=mesh.getSubMesh(i);
				SkinAnimations._computeSubMeshAniDatas(i,subMesh._boneIndices,this._curMeshAnimationData,this._curAnimationDatas);
			}
			if (isCache){
				this._setAnimationDatasWithCache(cachePlayRate,mesh,animationDatasCache,animationClipIndex,frameIndex,this._curAnimationDatas);
				(isCacheBonesDatas)|| (this._templet.setAnimationDataWithCache(cachePlayRate,boneDatasCache,animationClipIndex,frameIndex,this._curBonesDatas));
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
				state.shaderDefs.addInt(/*laya.d3.shader.ShaderDefines3D.BONE*/0x8000);
				var subMeshIndex=state.renderElement.renderObj.indexOfHost;
				state.shaderValue.pushValue(/*laya.d3.core.material.StandardMaterial.Bones*/"MATRIXARRAY0",this._curAnimationDatas[subMeshIndex]);
			}
		}

		__proto._unload=function(owner){
			_super.prototype._unload.call(this,owner);
			this._player.off(/*laya.events.Event.STOPPED*/"stopped",this,this._onAnimationStop);
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
		__getset(0,__proto,'url',null,function(value){
			_super.prototype._$set_url.call(this,value);
			this._curOriginalData=this._extenData=null;
			this._curMeshAnimationData=null;
			this._tempCurBonesData=null;
			this._tempCurAnimationData=null;
			(this._templet._animationDatasCache)|| (this._templet._animationDatasCache=[[],[]]);
		});

		__getset(0,__proto,'templet',_super.prototype._$get_templet,function(value){
			_super.prototype._$set_templet.call(this,value);
			this._curOriginalData=this._extenData=null;
			this._curMeshAnimationData=null;
			this._tempCurBonesData=null;
			this._tempCurAnimationData=null;
			(this._templet._animationDatasCache)|| (this._templet._animationDatasCache=[[],[]]);
		});

		SkinAnimations._computeSubMeshAniDatas=function(subMeshIndex,index,bonesData,animationDatas){
			var data=animationDatas[subMeshIndex];
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
			this._materials=this._mesh.meshRender.sharedMaterials;
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
			if (!this._templet || !this._templet.loaded || this.player.state!==/*laya.ani.AnimationState.playing*/2)
				return;
			var animationClipIndex=this.currentAnimationClipIndex;
			var unfixedIndexes=this._templet.getNodesCurrentFrameIndex(animationClipIndex,this.player.currentPlayTime);
			for (var i=0;i < this._nodes.length;i++){
				var index=unfixedIndexes[i];
				this._keyframeAges[i]=(this.player.currentPlayTime-this._nodes[i].keyFrame[index].startTime)/ this._nodes[i].keyFrame[index].duration;
				this._ages[i]=this.player.currentPlayTime / this._nodes[i].playTime;
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
			this._indexOfHost=0;
			PrimitiveMesh.__super.call(this);
			this._indexOfHost=0;
		}

		__class(PrimitiveMesh,'laya.d3.resource.models.PrimitiveMesh',_super);
		var __proto=PrimitiveMesh.prototype;
		Laya.imps(__proto,{"laya.d3.core.render.IRenderable":true})
		__proto._getVertexBuffer=function(index){
			(index===void 0)&& (index=0);
			if (index===0)
				return this._vertexBuffer;
			else
			return null;
		}

		__proto._getIndexBuffer=function(){
			return this._indexBuffer;
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

		__proto._beforeRender=function(state){
			this._vertexBuffer._bind();
			this._indexBuffer._bind();
			return true;
		}

		__proto._render=function(state){
			state.context.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,this._numberIndices,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,0);
			Stat.drawCall++;
			Stat.trianglesFaces+=this._numberIndices / 3;
		}

		__getset(0,__proto,'indexOfHost',function(){
			return this._indexOfHost;
		});

		__getset(0,__proto,'_vertexBufferCount',function(){
			return 1;
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
	*<code>Mesh</code> 类用于创建文件网格数据模板。
	*/
	//class laya.d3.resource.models.Mesh extends laya.d3.resource.models.BaseMesh
	var Mesh=(function(_super){
		function Mesh(){
			this._materials=null;
			this._subMeshes=null;
			this._bindPoses=null;
			this._inverseBindPoses=null;
			Mesh.__super.call(this);
			this._subMeshes=[];
			this._materials=[];
			if (this._loaded)
				this._generateBoundingObject();
			else
			this.once(/*laya.events.Event.LOADED*/"loaded",this,this._generateBoundingObject);
		}

		__class(Mesh,'laya.d3.resource.models.Mesh',_super);
		var __proto=Mesh.prototype;
		__proto._generateBoundingObject=function(){
			var pos=this.positions;
			this._boundingBox=new BoundBox(new Vector3(),new Vector3());
			BoundBox.createfromPoints(pos,this._boundingBox);
			this._boundingSphere=new BoundSphere(new Vector3(),0);
			BoundSphere.createfromPoints(pos,this._boundingSphere);
		}

		/**
		*添加子网格（开发者禁止修改）。
		*@param subMesh 子网格。
		*/
		__proto._add=function(subMesh){
			subMesh._indexInMesh=this._subMeshes.length;
			this._subMeshes.push(subMesh);
			this._subMeshCount++;
		}

		/**
		*移除子网格（开发者禁止修改）。
		*@param subMesh 子网格。
		*@return 是否成功。
		*/
		__proto._remove=function(subMesh){
			var index=this._subMeshes.indexOf(subMesh);
			if (index < 0)return false;
			this._subMeshes.splice(index,1);
			this._subMeshCount--;
			return true;
		}

		/**
		*@private
		*/
		__proto.onAsynLoaded=function(url,data){
			var preBasePath=URL.basePath;
			URL.basePath=URL.getPath(URL.formatURL(url));
			new LoadModel(data,this,this._materials,url);
			URL.basePath=preBasePath;
			this._loaded=true;
			this.event(/*laya.events.Event.LOADED*/"loaded",this);
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
				var vertexBuffer=subMesh._getVertexBuffer();
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
		*获取材质队列的浅拷贝。
		*@return 材质队列的浅拷贝。
		*/
		__getset(0,__proto,'materials',function(){
			return this._materials.slice();
		});

		/**
		*获取网格的默认绑定动作矩阵。
		*@return 网格的默认绑定动作矩阵。
		*/
		__getset(0,__proto,'bindPoses',function(){
			return this._bindPoses;
		});

		/**
		*获取网格的全局默认绑定动作逆矩阵。
		*@return 网格的全局默认绑定动作逆矩阵。
		*/
		__getset(0,__proto,'InverseAbsoluteBindPoses',function(){
			return this._inverseBindPoses;
		});

		Mesh.load=function(url){
			return Laya.loader.create(url,null,null,Mesh);
		}

		return Mesh;
	})(BaseMesh)


	/**
	*<code>RenderTarget</code> 类用于创建渲染目标。
	*/
	//class laya.d3.resource.RenderTexture extends laya.d3.resource.BaseTexture
	var RenderTexture=(function(_super){
		function RenderTexture(width,height,surfaceFormat,surfaceType,depthStencilFormat,mipMap,repeat,minFifter,magFifter){
			this._alreadyResolved=false;
			this._surfaceFormat=0;
			this._surfaceType=0;
			this._depthStencilFormat=0;
			this._frameBuffer=null;
			this._depthStencilBuffer=null;
			(surfaceFormat===void 0)&& (surfaceFormat=/*laya.webgl.WebGLContext.RGBA*/0x1908);
			(surfaceType===void 0)&& (surfaceType=/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401);
			(depthStencilFormat===void 0)&& (depthStencilFormat=/*laya.webgl.WebGLContext.DEPTH_COMPONENT16*/0x81A5);
			(mipMap===void 0)&& (mipMap=false);
			(repeat===void 0)&& (repeat=false);
			(minFifter===void 0)&& (minFifter=-1);
			(magFifter===void 0)&& (magFifter=-1);
			RenderTexture.__super.call(this);
			this._width=width;
			this._height=height;
			this._size=new Size(width,height);
			this._surfaceFormat=surfaceFormat;
			this._surfaceType=surfaceType;
			this._depthStencilFormat=depthStencilFormat;
			this._mipmap=mipMap;
			this._repeat=repeat;
			this._minFifter=minFifter;
			this._magFifter=magFifter;
			this.activeResource();
			this._loaded=true;
			this._alreadyResolved=true;
		}

		__class(RenderTexture,'laya.d3.resource.RenderTexture',_super);
		var __proto=RenderTexture.prototype;
		__proto.recreateResource=function(){
			this.startCreate();
			var gl=WebGL.mainContext;
			this._frameBuffer=gl.createFramebuffer();
			this._source=gl.createTexture();
			var preTarget=WebGLContext.curBindTexTarget;
			var preTexture=WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl,/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,this._source);
			gl.texImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,this._width,this._height,0,this._surfaceFormat,this._surfaceType,null);
			var minFifter=this._minFifter;
			var magFifter=this._magFifter;
			var repeat=this._repeat ? /*laya.webgl.WebGLContext.REPEAT*/0x2901 :/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F;
			var isPot=Arith.isPOT(this._width,this._height);
			if (isPot){
				if (this._mipmap)
					(minFifter!==-1)|| (minFifter=/*laya.webgl.WebGLContext.LINEAR_MIPMAP_LINEAR*/0x2703);
				else
				(minFifter!==-1)|| (minFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				(magFifter!==-1)|| (magFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,minFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MAG_FILTER*/0x2800,magFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_S*/0x2802,repeat);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_T*/0x2803,repeat);
				this._mipmap && gl.generateMipmap(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1);
				}else {
				(minFifter!==-1)|| (minFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				(magFifter!==-1)|| (magFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,minFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MAG_FILTER*/0x2800,magFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_S*/0x2802,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_T*/0x2803,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
			}
			gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,this._frameBuffer);
			gl.framebufferTexture2D(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,/*laya.webgl.WebGLContext.COLOR_ATTACHMENT0*/0x8CE0,/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,this._source,0);
			if (this._depthStencilFormat){
				this._depthStencilBuffer=gl.createRenderbuffer();
				gl.bindRenderbuffer(/*laya.webgl.WebGLContext.RENDERBUFFER*/0x8D41,this._depthStencilBuffer);
				gl.renderbufferStorage(/*laya.webgl.WebGLContext.RENDERBUFFER*/0x8D41,this._depthStencilFormat,this._width,this._height);
				switch (this._depthStencilFormat){
					case /*laya.webgl.WebGLContext.DEPTH_COMPONENT16*/0x81A5:
						gl.framebufferRenderbuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,/*laya.webgl.WebGLContext.DEPTH_ATTACHMENT*/0x8D00,/*laya.webgl.WebGLContext.RENDERBUFFER*/0x8D41,this._depthStencilBuffer);
						break ;
					case /*laya.webgl.WebGLContext.STENCIL_INDEX8*/0x8D48:
						gl.framebufferRenderbuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,/*laya.webgl.WebGLContext.STENCIL_ATTACHMENT*/0x8D20,/*laya.webgl.WebGLContext.RENDERBUFFER*/0x8D41,this._depthStencilBuffer);
						break ;
					case /*laya.webgl.WebGLContext.DEPTH_STENCIL*/0x84F9:
						gl.framebufferRenderbuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,/*laya.webgl.WebGLContext.DEPTH_STENCIL_ATTACHMENT*/0x821A,/*laya.webgl.WebGLContext.RENDERBUFFER*/0x8D41,this._depthStencilBuffer);
						break ;
					}
			}
			gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,null);
			(preTarget && preTexture)&& (WebGLContext.bindTexture(gl,preTarget,preTexture));
			gl.bindRenderbuffer(/*laya.webgl.WebGLContext.RENDERBUFFER*/0x8D41,null);
			this.memorySize=this._width *this._height *4;
			this.completeCreate();
		}

		/**
		*开始绑定。
		*/
		__proto.start=function(){
			WebGL.mainContext.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,this.frameBuffer);
			RenderTexture._currentRenderTarget=this;
			this._alreadyResolved=false;
		}

		/**
		*结束绑定。
		*/
		__proto.end=function(){
			WebGL.mainContext.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,null);
			RenderTexture._currentRenderTarget=null;
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
			gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,this._frameBuffer);
			var canRead=(gl.checkFramebufferStatus(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40)===/*laya.webgl.WebGLContext.FRAMEBUFFER_COMPLETE*/0x8CD5);
			if (!canRead){
				gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,null);
				return null;
			};
			var pixels=new Uint8Array(this._width *this._height *4);
			gl.readPixels(x,y,width,height,this._surfaceFormat,this._surfaceType,pixels);
			gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,null);
			return pixels;
		}

		/**
		*销毁资源。
		*/
		__proto.detoryResource=function(){
			if (this._frameBuffer){
				var gl=WebGL.mainContext;
				gl.deleteTexture(this._source);
				gl.deleteFramebuffer(this._frameBuffer);
				gl.deleteRenderbuffer(this._depthStencilBuffer);
				this._source=null;
				this._frameBuffer=null;
				this._depthStencilBuffer=null;
				this.memorySize=0;
			}
		}

		/**
		*获取表面格式。
		*@return 表面格式。
		*/
		__getset(0,__proto,'surfaceFormat',function(){
			return this._surfaceFormat;
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
		*获取RenderTarget数据源,如果alreadyResolved等于false，则返回null。
		*@return RenderTarget数据源。
		*/
		__getset(0,__proto,'source',function(){
			if (this._alreadyResolved)
				return _super.prototype._$get_source.call(this);
			else
			return null;
		});

		__getset(0,__proto,'depthStencilBuffer',function(){
			return this._depthStencilBuffer;
		});

		__getset(0,__proto,'frameBuffer',function(){
			return this._frameBuffer;
		});

		RenderTexture._currentRenderTarget=null
		return RenderTexture;
	})(BaseTexture)


	/**
	*<code>SolidColorTexture2D</code> 二维纯色纹理。
	*/
	//class laya.d3.resource.SolidColorTexture2D extends laya.d3.resource.BaseTexture
	var SolidColorTexture2D=(function(_super){
		function SolidColorTexture2D(color){
			this._color=null;
			this._pixels=null;
			SolidColorTexture2D.__super.call(this);
			this._width=1;
			this._height=1;
			this._size=new Size(this.width,this.height);
			this._color=color;
			this._pixels=new Uint8Array([color.x *255,color.y *255,color.z *255,color.w *255]);
		}

		__class(SolidColorTexture2D,'laya.d3.resource.SolidColorTexture2D',_super);
		var __proto=SolidColorTexture2D.prototype;
		/**
		*@private
		*/
		__proto._createWebGlTexture=function(){
			var gl=WebGL.mainContext;
			var glTex=this._source=gl.createTexture();
			var w=this._width;
			var h=this._height;
			var preTarget=WebGLContext.curBindTexTarget;
			var preTexture=WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl,/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,glTex);
			gl.texImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,w,h,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,this._pixels);
			var minFifter=this._minFifter;
			var magFifter=this._magFifter;
			var repeat=this._repeat ? /*laya.webgl.WebGLContext.REPEAT*/0x2901 :/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F;
			var isPot=Arith.isPOT(w,h);
			if (isPot){
				if (this._mipmap)
					(minFifter!==-1)|| (minFifter=/*laya.webgl.WebGLContext.LINEAR_MIPMAP_LINEAR*/0x2703);
				else
				(minFifter!==-1)|| (minFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				(magFifter!==-1)|| (magFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,minFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MAG_FILTER*/0x2800,magFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_S*/0x2802,repeat);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_T*/0x2803,repeat);
				this._mipmap && gl.generateMipmap(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1);
				}else {
				(minFifter!==-1)|| (minFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				(magFifter!==-1)|| (magFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,minFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MAG_FILTER*/0x2800,magFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_S*/0x2802,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_T*/0x2803,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
			}
			(preTarget && preTexture)&& (WebGLContext.bindTexture(gl,preTarget,preTexture));
			if (isPot)
				this.memorySize=w *h *4 *(1+1 / 3);
			else
			this.memorySize=w *h *4;
		}

		/**
		*重新创建资源，如果异步创建中被强制释放再创建，则需等待释放完成后再重新加载创建。
		*/
		__proto.recreateResource=function(){
			this.startCreate();
			this._createWebGlTexture();
			this.completeCreate();
		}

		/**
		*销毁资源。
		*/
		__proto.detoryResource=function(){
			if (this._source){
				WebGL.mainContext.deleteTexture(this._source);
				this._source=null;
				this.memorySize=0;
			}
		}

		__getset(0,__proto,'source',function(){
			return _super.prototype._$get_source.call(this);
		});

		__static(SolidColorTexture2D,
		['magentaTexture',function(){return this.magentaTexture=new SolidColorTexture2D(new Vector4(1.0,0.0,1.0,1.0));},'grayTexture',function(){return this.grayTexture=new SolidColorTexture2D(new Vector4(0.5,0.5,0.5,1.0));}
		]);
		return SolidColorTexture2D;
	})(BaseTexture)


	/**
	*<code>Sky</code> 类用于创建天空盒。
	*/
	//class laya.d3.resource.models.SkyBox extends laya.d3.resource.models.Sky
	var SkyBox=(function(_super){
		function SkyBox(){
			this._sharderNameID=0;
			this._shader=null;
			this._numberVertices=0;
			this._numberIndices=0;
			this._vertexBuffer=null;
			this._indexBuffer=null;
			this._alphaBlending=1.0;
			this._colorIntensity=1.0;
			this._textureCube=null;
			this._shaderValue=new ValusArray();
			SkyBox.__super.call(this);
			this.name="Skybox-"+SkyBox._nameNumber;
			SkyBox._nameNumber++;
			this.loadShaderParams();
			this.recreateResource();
		}

		__class(SkyBox,'laya.d3.resource.models.SkyBox',_super);
		var __proto=SkyBox.prototype;
		/**
		*@private
		*/
		__proto._getShader=function(state){
			var shaderDefs=state.shaderDefs;
			var preDef=shaderDefs._value;
			var nameID=shaderDefs._value+this._sharderNameID */*laya.webgl.shader.Shader.SHADERNAME2ID*/0.0002;
			this._shader=Shader.withCompile(this._sharderNameID,state.shaderDefs.toNameDic(),nameID,null);
			shaderDefs._value=preDef;
			return this._shader;
		}

		/**
		*@private
		*/
		__proto.recreateResource=function(){
			this.startCreate();
			this._numberVertices=36;
			this._numberIndices=36;
			var indices=new Uint16Array(this._numberIndices);
			var vertexFloatStride=SkyBox._vertexDeclaration.vertexStride / 4;
			var vertices=new Float32Array(this._numberVertices *vertexFloatStride);
			var width=1.0;
			var height=1.0;
			var depth=1.0;
			var halfWidth=width / 2.0;
			var halfHeight=height / 2.0;
			var halfDepth=depth / 2.0;
			var topLeftFront=new Vector3(-halfWidth,halfHeight,halfDepth);
			var bottomLeftFront=new Vector3(-halfWidth,-halfHeight,halfDepth);
			var topRightFront=new Vector3(halfWidth,halfHeight,halfDepth);
			var bottomRightFront=new Vector3(halfWidth,-halfHeight,halfDepth);
			var topLeftBack=new Vector3(-halfWidth,halfHeight,-halfDepth);
			var topRightBack=new Vector3(halfWidth,halfHeight,-halfDepth);
			var bottomLeftBack=new Vector3(-halfWidth,-halfHeight,-halfDepth);
			var bottomRightBack=new Vector3(halfWidth,-halfHeight,-halfDepth);
			var vertexCount=0;
			vertexCount=this._addVertex(vertices,vertexCount,topLeftFront);
			vertexCount=this._addVertex(vertices,vertexCount,bottomLeftFront);
			vertexCount=this._addVertex(vertices,vertexCount,topRightFront);
			vertexCount=this._addVertex(vertices,vertexCount,bottomLeftFront);
			vertexCount=this._addVertex(vertices,vertexCount,bottomRightFront);
			vertexCount=this._addVertex(vertices,vertexCount,topRightFront);
			vertexCount=this._addVertex(vertices,vertexCount,topLeftBack);
			vertexCount=this._addVertex(vertices,vertexCount,topRightBack);
			vertexCount=this._addVertex(vertices,vertexCount,bottomLeftBack);
			vertexCount=this._addVertex(vertices,vertexCount,bottomLeftBack);
			vertexCount=this._addVertex(vertices,vertexCount,topRightBack);
			vertexCount=this._addVertex(vertices,vertexCount,bottomRightBack);
			vertexCount=this._addVertex(vertices,vertexCount,topLeftFront);
			vertexCount=this._addVertex(vertices,vertexCount,topRightBack);
			vertexCount=this._addVertex(vertices,vertexCount,topLeftBack);
			vertexCount=this._addVertex(vertices,vertexCount,topLeftFront);
			vertexCount=this._addVertex(vertices,vertexCount,topRightFront);
			vertexCount=this._addVertex(vertices,vertexCount,topRightBack);
			vertexCount=this._addVertex(vertices,vertexCount,bottomLeftFront);
			vertexCount=this._addVertex(vertices,vertexCount,bottomLeftBack);
			vertexCount=this._addVertex(vertices,vertexCount,bottomRightBack);
			vertexCount=this._addVertex(vertices,vertexCount,bottomLeftFront);
			vertexCount=this._addVertex(vertices,vertexCount,bottomRightBack);
			vertexCount=this._addVertex(vertices,vertexCount,bottomRightFront);
			vertexCount=this._addVertex(vertices,vertexCount,topLeftFront);
			vertexCount=this._addVertex(vertices,vertexCount,bottomLeftBack);
			vertexCount=this._addVertex(vertices,vertexCount,bottomLeftFront);
			vertexCount=this._addVertex(vertices,vertexCount,topLeftBack);
			vertexCount=this._addVertex(vertices,vertexCount,bottomLeftBack);
			vertexCount=this._addVertex(vertices,vertexCount,topLeftFront);
			vertexCount=this._addVertex(vertices,vertexCount,topRightFront);
			vertexCount=this._addVertex(vertices,vertexCount,bottomRightFront);
			vertexCount=this._addVertex(vertices,vertexCount,bottomRightBack);
			vertexCount=this._addVertex(vertices,vertexCount,topRightBack);
			vertexCount=this._addVertex(vertices,vertexCount,topRightFront);
			vertexCount=this._addVertex(vertices,vertexCount,bottomRightBack);
			for (var i=0;i < 36;i++)
			indices[i]=i;
			this._vertexBuffer=new VertexBuffer3D(SkyBox._vertexDeclaration,this._numberVertices,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4,true);
			this._indexBuffer=new IndexBuffer3D(/*laya.d3.graphics.IndexBuffer3D.INDEXTYPE_USHORT*/"ushort",this._numberIndices,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4,true);
			this._vertexBuffer.setData(vertices);
			this._indexBuffer.setData(indices);
			this.memorySize=(this._vertexBuffer.byteLength+this._indexBuffer.byteLength)*2;
			this.completeCreate();
		}

		/**
		*@private
		*/
		__proto._addVertex=function(vertices,index,position){
			var posE=position.elements;
			vertices[index+0]=posE[0];
			vertices[index+1]=posE[1];
			vertices[index+2]=posE[2];
			return index+3;
		}

		/**
		*@private
		*/
		__proto.loadShaderParams=function(){
			this._sharderNameID=Shader.nameKey.get("SkyBox");
			this._shaderValue.pushValue(/*laya.d3.resource.models.Sky.DIFFUSETEXTURE*/"DIFFUSETEXTURE",null);
		}

		__proto._render=function(state){
			if (this._textureCube && this._textureCube.loaded){
				this._vertexBuffer._bind();
				this._indexBuffer._bind();
				this._shader=this._getShader(state);
				var presz=this._shaderValue.length;
				this._shaderValue.pushArray(state.shaderValue);
				this._shaderValue.pushArray(this._vertexBuffer.vertexDeclaration.shaderValues);
				state.camera.transform.worldMatrix.cloneTo(SkyBox._tempMatrix4x40);
				SkyBox._tempMatrix4x40.transpose();
				Matrix4x4.multiply(state.projectionMatrix,SkyBox._tempMatrix4x40,SkyBox._tempMatrix4x41);
				this._shaderValue.pushValue(/*laya.d3.resource.models.Sky.MVPMATRIX*/"MVPMATRIX",SkyBox._tempMatrix4x41.elements);
				this._shaderValue.pushValue(/*laya.d3.resource.models.Sky.INTENSITY*/"INTENSITY",this._colorIntensity);
				this._shaderValue.pushValue(/*laya.d3.resource.models.Sky.ALPHABLENDING*/"ALPHABLENDING",this.alphaBlending);
				this._shaderValue.data[1]=this.textureCube.source;
				this._shader.uploadArray(this._shaderValue.data,this._shaderValue.length,null);
				this._shaderValue.length=presz;
				WebGL.mainContext.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,36,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,0);
				Stat.trianglesFaces+=12;
				Stat.drawCall++;
			}
		}

		/**
		*设置透明混合度。
		*@param value 透明混合度。
		*/
		/**
		*获取透明混合度。
		*@return 透明混合度。
		*/
		__getset(0,__proto,'alphaBlending',function(){
			return this._alphaBlending;
			},function(value){
			this._alphaBlending=value;
			if (this._alphaBlending < 0)
				this._alphaBlending=0;
			if (this._alphaBlending > 1)
				this._alphaBlending=1;
		});

		/**
		*设置天空立方体纹理。
		*@param value 天空立方体纹理。
		*/
		/**
		*获取天空立方体纹理。
		*@return 天空立方体纹理。
		*/
		__getset(0,__proto,'textureCube',function(){
			return this._textureCube;
			},function(value){
			this._textureCube=value;
		});

		/**
		*设置颜色强度。
		*@param value 颜色强度。
		*/
		/**
		*获取颜色强度。
		*@return 颜色强度。
		*/
		__getset(0,__proto,'colorIntensity',function(){
			return this._colorIntensity;
			},function(value){
			this._colorIntensity=value;
			if (this._colorIntensity < 0)
				this._colorIntensity=0;
		});

		SkyBox._nameNumber=1;
		__static(SkyBox,
		['_tempMatrix4x40',function(){return this._tempMatrix4x40=new Matrix4x4();},'_tempMatrix4x41',function(){return this._tempMatrix4x41=new Matrix4x4();},'_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(12,[new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION")]);}
		]);
		return SkyBox;
	})(Sky)


	/**
	*<code>Sky</code> 类用于创建天空盒。
	*/
	//class laya.d3.resource.models.SkyDome extends laya.d3.resource.models.Sky
	var SkyDome=(function(_super){
		function SkyDome(){
			this._sharderNameID=0;
			this._shader=null;
			this._numberVertices=0;
			this._numberIndices=0;
			this._vertexBuffer=null;
			this._indexBuffer=null;
			this._alphaBlending=1.0;
			this._colorIntensity=1.0;
			this._texture=null;
			this._stacks=16;
			this._slices=16;
			this._radius=1;
			this._shaderValue=new ValusArray();
			SkyDome.__super.call(this);
			this.name="SkyDome-"+SkyDome._nameNumber;
			SkyDome._nameNumber++;
			this.loadShaderParams();
			this.recreateResource();
		}

		__class(SkyDome,'laya.d3.resource.models.SkyDome',_super);
		var __proto=SkyDome.prototype;
		/**
		*@private
		*/
		__proto._getShader=function(state){
			var shaderDefs=state.shaderDefs;
			var preDef=shaderDefs._value;
			var nameID=shaderDefs._value+this._sharderNameID */*laya.webgl.shader.Shader.SHADERNAME2ID*/0.0002;
			this._shader=Shader.withCompile(this._sharderNameID,state.shaderDefs.toNameDic(),nameID,null);
			shaderDefs._value=preDef;
			return this._shader;
		}

		/**
		*@private
		*/
		__proto.recreateResource=function(){
			this.startCreate();
			this._numberVertices=(this._stacks+1)*(this._slices+1);
			this._numberIndices=(3 *this._stacks *(this._slices+1))*2;
			var indices=new Uint16Array(this._numberIndices);
			var vertexFloatStride=SkyDome._vertexDeclaration.vertexStride / 4;
			var vertices=new Float32Array(this._numberVertices *vertexFloatStride);
			var stackAngle=Math.PI / this._stacks;
			var sliceAngle=(Math.PI *2.0)/ this._slices;
			var vertexIndex=0;
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
					vertices[vertexCount+3]=slice / this._slices;
					vertices[vertexCount+4]=stack / this._stacks;
					vertexCount+=vertexFloatStride;
					if (stack !=(this._stacks-1)){
						indices[indexCount++]=vertexIndex+1;
						indices[indexCount++]=vertexIndex;
						indices[indexCount++]=vertexIndex+(this._slices+1);
						indices[indexCount++]=vertexIndex+(this._slices+1);
						indices[indexCount++]=vertexIndex;
						indices[indexCount++]=vertexIndex+(this._slices);
						vertexIndex++;
					}
				}
			}
			this._vertexBuffer=new VertexBuffer3D(SkyDome._vertexDeclaration,this._numberVertices,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4);
			this._indexBuffer=new IndexBuffer3D(/*laya.d3.graphics.IndexBuffer3D.INDEXTYPE_USHORT*/"ushort",this._numberIndices,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4);
			this._vertexBuffer.setData(vertices);
			this._indexBuffer.setData(indices);
			this.memorySize=(this._vertexBuffer.byteLength+this._indexBuffer.byteLength)*2;
			this.completeCreate();
		}

		/**
		*@private
		*/
		__proto.loadShaderParams=function(){
			this._sharderNameID=Shader.nameKey.get("SkyDome");
			this._shaderValue.pushValue(/*laya.d3.resource.models.Sky.DIFFUSETEXTURE*/"DIFFUSETEXTURE",null);
		}

		__proto._render=function(state){
			if (this._texture && this._texture.loaded){
				this._vertexBuffer._bind();
				this._indexBuffer._bind();
				this._shader=this._getShader(state);
				var presz=this._shaderValue.length;
				this._shaderValue.pushArray(state.shaderValue);
				this._shaderValue.pushArray(this._vertexBuffer.vertexDeclaration.shaderValues);
				state.camera.transform.worldMatrix.cloneTo(SkyDome._tempMatrix4x40);
				SkyDome._tempMatrix4x40.transpose();
				Matrix4x4.multiply(state.projectionMatrix,SkyDome._tempMatrix4x40,SkyDome._tempMatrix4x41);
				this._shaderValue.pushValue(/*laya.d3.resource.models.Sky.MVPMATRIX*/"MVPMATRIX",SkyDome._tempMatrix4x41.elements);
				this._shaderValue.pushValue(/*laya.d3.resource.models.Sky.INTENSITY*/"INTENSITY",this._colorIntensity);
				this._shaderValue.pushValue(/*laya.d3.resource.models.Sky.ALPHABLENDING*/"ALPHABLENDING",this.alphaBlending);
				this._shaderValue.data[1]=this.texture.source;
				this._shader.uploadArray(this._shaderValue.data,this._shaderValue.length,null);
				this._shaderValue.length=presz;
				WebGL.mainContext.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,this._indexBuffer.indexCount,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,0);
				Stat.trianglesFaces+=this._numberIndices / 3;
				Stat.drawCall++;
			}
		}

		/**
		*设置透明混合度。
		*@param value 透明混合度。
		*/
		/**
		*获取透明混合度。
		*@return 透明混合度。
		*/
		__getset(0,__proto,'alphaBlending',function(){
			return this._alphaBlending;
			},function(value){
			this._alphaBlending=value;
			if (this._alphaBlending < 0)
				this._alphaBlending=0;
			if (this._alphaBlending > 1)
				this._alphaBlending=1;
		});

		/**
		*设置颜色强度。
		*@param value 颜色强度。
		*/
		/**
		*获取颜色强度。
		*@return 颜色强度。
		*/
		__getset(0,__proto,'colorIntensity',function(){
			return this._colorIntensity;
			},function(value){
			this._colorIntensity=value;
			if (this._colorIntensity < 0)
				this._colorIntensity=0;
		});

		/**
		*设置天空立方体纹理。
		*@param value 天空立方体纹理。
		*/
		/**
		*获取天空立方体纹理。
		*@return 天空立方体纹理。
		*/
		__getset(0,__proto,'texture',function(){
			return this._texture;
			},function(value){
			this._texture=value;
		});

		SkyDome._nameNumber=1;
		__static(SkyDome,
		['_tempMatrix4x40',function(){return this._tempMatrix4x40=new Matrix4x4();},'_tempMatrix4x41',function(){return this._tempMatrix4x41=new Matrix4x4();},'_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(20,[new VertexElement(0,/*laya.d3.graphics.VertexElementFormat.Vector3*/"vector3",/*laya.d3.graphics.VertexElementUsage.POSITION0*/"POSITION"),new VertexElement(12,/*laya.d3.graphics.VertexElementFormat.Vector2*/"vector2",/*laya.d3.graphics.VertexElementUsage.TEXTURECOORDINATE0*/"UV")]);}
		]);
		return SkyDome;
	})(Sky)


	/**
	*<code>Texture2D</code> 二维纹理。
	*/
	//class laya.d3.resource.Texture2D extends laya.d3.resource.BaseTexture
	var Texture2D=(function(_super){
		function Texture2D(){
			this._src=null;
			this._image=null;
			this._recreateLock=false;
			this._needReleaseAgain=false;
			Texture2D.__super.call(this);
		}

		__class(Texture2D,'laya.d3.resource.Texture2D',_super);
		var __proto=Texture2D.prototype;
		/**
		*@private
		*/
		__proto._onTextureLoaded=function(img){
			this._image=img;
			var w=img.width;
			var h=img.height;
			this._width=w;
			this._height=h;
			this._size=new Size(w,h);
		}

		/**
		*@private
		*/
		__proto._createWebGlTexture=function(){
			if (!this._image){
				throw "create GLTextur err:no data:"+this._image;
			};
			var gl=WebGL.mainContext;
			var glTex=this._source=gl.createTexture();
			var w=this._width;
			var h=this._height;
			var preTarget=WebGLContext.curBindTexTarget;
			var preTexture=WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl,/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,glTex);
			gl.texImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,this._image);
			var minFifter=this._minFifter;
			var magFifter=this._magFifter;
			var repeat=this._repeat ? /*laya.webgl.WebGLContext.REPEAT*/0x2901 :/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F;
			var isPot=Arith.isPOT(w,h);
			if (isPot){
				if (this._mipmap)
					(minFifter!==-1)|| (minFifter=/*laya.webgl.WebGLContext.LINEAR_MIPMAP_LINEAR*/0x2703);
				else
				(minFifter!==-1)|| (minFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				(magFifter!==-1)|| (magFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,minFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MAG_FILTER*/0x2800,magFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_S*/0x2802,repeat);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_T*/0x2803,repeat);
				this._mipmap && gl.generateMipmap(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1);
				}else {
				(minFifter!==-1)|| (minFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				(magFifter!==-1)|| (magFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,minFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MAG_FILTER*/0x2800,magFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_S*/0x2802,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_T*/0x2803,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
			}
			(preTarget && preTexture)&& (WebGLContext.bindTexture(gl,preTarget,preTexture));
			this._image.onload=null;
			this._image=null;
			if (isPot)
				this.memorySize=w *h *4 *(1+1 / 3);
			else
			this.memorySize=w *h *4;
			this._recreateLock=false;
		}

		/**
		*重新创建资源，如果异步创建中被强制释放再创建，则需等待释放完成后再重新加载创建。
		*/
		__proto.recreateResource=function(){
			if (this._src==null || this._src==="")
				return;
			this._needReleaseAgain=false;
			if (!this._image){
				this._recreateLock=true;
				this.startCreate();
				var _this=this;
				this._image=new Browser.window.Image();
				this._image.crossOrigin="";
				this._image.onload=function (){
					if (_this._needReleaseAgain){
						_this._needReleaseAgain=false;
						_this._image.onload=null;
						_this._image=null;
						return;
					}
					_this._createWebGlTexture();
					_this.completeCreate();
				};
				this._image.src=this._src;
				}else {
				if (this._recreateLock){
					return;
				}
				this.startCreate();
				this._createWebGlTexture();
				this.completeCreate();
			}
		}

		/**
		*@private
		*/
		__proto.onAsynLoaded=function(url,data){
			this._src=url;
			this._onTextureLoaded(data);
			this.activeResource();
			this._loaded=true;
			this.event(/*laya.events.Event.LOADED*/"loaded",this);
		}

		/**
		*销毁资源。
		*/
		__proto.detoryResource=function(){
			if (this._recreateLock){
				this._needReleaseAgain=true;
			}
			if (this._source){
				WebGL.mainContext.deleteTexture(this._source);
				this._source=null;
				this._image=null;
				this.memorySize=0;
			}
		}

		/**
		*获取文件路径全名。
		*/
		__getset(0,__proto,'src',function(){
			return this._src;
		});

		Texture2D.load=function(url){
			return Laya.loader.create(url,null,null,Texture2D);
		}

		return Texture2D;
	})(BaseTexture)


	//class laya.d3.resource.TextureCube extends laya.d3.resource.BaseTexture
	var TextureCube=(function(_super){
		function TextureCube(){
			this._texCount=6;
			//this._images=null;
			//this._srcs=null;
			this._recreateLock=false;
			this._needReleaseAgain=false;
			TextureCube.__super.call(this);
		}

		__class(TextureCube,'laya.d3.resource.TextureCube',_super);
		var __proto=TextureCube.prototype;
		/**
		*@private
		*/
		__proto._onTextureLoaded=function(images){
			this._images=images;
			var minWidth=2147483647;
			var minHeight=2147483647;
			for (var i=0;i < 6;i++){
				var image=images[i];
				minWidth=Math.min(minWidth,image.width);
				minHeight=Math.min(minHeight,image.height);
			}
			this._width=minWidth;
			this._height=minHeight;
			this._size=new Size(minWidth,minHeight);
		}

		__proto._createWebGlTexture=function(){
			var i=0;
			for (i=0;i < this._texCount;i++){
				if (!this._images[i]){
					throw "create GLTextur err:no data:"+this._images[i];
				}
			};
			var gl=WebGL.mainContext;
			var glTex=this._source=gl.createTexture();
			var w=this._width;
			var h=this._height;
			var preTarget=WebGLContext.curBindTexTarget;
			var preTexture=WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl,/*laya.webgl.WebGLContext.TEXTURE_CUBE_MAP*/0x8513,glTex);
			gl.texImage2D(/*laya.webgl.WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_X*/0x8515,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,this._images[0]);
			gl.texImage2D(/*laya.webgl.WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_X*/0x8516,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,this._images[1]);
			gl.texImage2D(/*laya.webgl.WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_Y*/0x8517,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,this._images[2]);
			gl.texImage2D(/*laya.webgl.WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_Y*/0x8518,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,this._images[3]);
			gl.texImage2D(/*laya.webgl.WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_Z*/0x8519,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,this._images[4]);
			gl.texImage2D(/*laya.webgl.WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_Z*/0x851A,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,this._images[5]);
			var minFifter=this.minFifter;
			var magFifter=this.magFifter;
			var repeat=this.repeat ? /*laya.webgl.WebGLContext.REPEAT*/0x2901 :/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F;
			var isPOT=Arith.isPOT(w,h);
			if (isPOT){
				if (this.mipmap)
					(minFifter!==-1)|| (minFifter=/*laya.webgl.WebGLContext.LINEAR_MIPMAP_LINEAR*/0x2703);
				else
				(minFifter!==-1)|| (minFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				(magFifter!==-1)|| (magFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_CUBE_MAP*/0x8513,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,minFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_CUBE_MAP*/0x8513,/*laya.webgl.WebGLContext.TEXTURE_MAG_FILTER*/0x2800,magFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_CUBE_MAP*/0x8513,/*laya.webgl.WebGLContext.TEXTURE_WRAP_S*/0x2802,repeat);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_CUBE_MAP*/0x8513,/*laya.webgl.WebGLContext.TEXTURE_WRAP_T*/0x2803,repeat);
				this.mipmap && gl.generateMipmap(/*laya.webgl.WebGLContext.TEXTURE_CUBE_MAP*/0x8513);
				}else {
				(minFifter!==-1)|| (minFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				(magFifter!==-1)|| (magFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_CUBE_MAP*/0x8513,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,minFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_CUBE_MAP*/0x8513,/*laya.webgl.WebGLContext.TEXTURE_MAG_FILTER*/0x2800,magFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_CUBE_MAP*/0x8513,/*laya.webgl.WebGLContext.TEXTURE_WRAP_S*/0x2802,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_CUBE_MAP*/0x8513,/*laya.webgl.WebGLContext.TEXTURE_WRAP_T*/0x2803,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
			}
			(preTarget && preTexture)&& (WebGLContext.bindTexture(gl,preTarget,preTexture));
			for (i=0;i < 6;i++){
				this._images[i].onload=null;
				this._images[i]=null;
			}
			if (isPOT)
				this.memorySize=w *h *4 *(1+1 / 3)*this._texCount;
			else
			this.memorySize=w *h *4 *this._texCount;
			this._recreateLock=false;
		}

		__proto.recreateResource=function(){
			var _$this=this;
			if (this._srcs==null)
				return;
			this._needReleaseAgain=false;
			if (!this._images[0]){
				this._recreateLock=true;
				this.startCreate();
				var _this=this;
				for (var i=0;i < this._texCount;i++){
					this._images[i]=new Browser.window.Image();
					this._images[i].crossOrigin="";
					var index=i;
					this._images[index].onload=function (){
						var j=0;
						if (_this._needReleaseAgain){
							for (j=0;j < _$this._texCount;j++)
							if (!_this._images[j].complete)
								return;
							_this._needReleaseAgain=false;
							for (j=0;j < _$this._texCount;j++){
								_this._images[j].onload=null;
								_this._images[j]=null;
							}
							return;
						}
						for (j=0;j < _$this._texCount;j++)
						if (!_this._images[j].complete)
							return;
						_this._createWebGlTexture();
						_this.completeCreate();
					};
					this._images[i].src=this._srcs[i];
				}
				}else {
				if (this._recreateLock){
					return;
				}
				this.startCreate();
				this._createWebGlTexture();
				this.completeCreate();
			}
		}

		/**
		*@private
		*/
		__proto.onAsynLoaded=function(url,data){
			this._srcs=url;
			this._onTextureLoaded(data);
			this.activeResource();
			this._loaded=true;
			this.event(/*laya.events.Event.LOADED*/"loaded",this);
		}

		__proto.detoryResource=function(){
			if (this._recreateLock){
				this._needReleaseAgain=true;
			}
			if (this._source){
				WebGL.mainContext.deleteTexture(this._source);
				this._source=null;
				this.memorySize=0;
			}
		}

		/**
		*文件路径全名。
		*/
		__getset(0,__proto,'srcs',function(){
			return this._srcs;
		});

		TextureCube.load=function(url){
			return Laya.loader.create(url,null,null,TextureCube);
		}

		return TextureCube;
	})(BaseTexture)


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
		__proto.renderCamera=function(gl,state,camera){
			this._prepareRenderToRenderState(camera,state);
			this.beforeRender(state);
			var renderTarget=camera.renderTarget;
			if (renderTarget){
				renderTarget.start();
				Matrix4x4.multiply(this._invertYScaleMatrix,camera.projectionMatrix,this._invertYProjectionMatrix);
				Matrix4x4.multiply(this._invertYScaleMatrix,camera.projectionViewMatrix,this._invertYProjectionViewMatrix);
				state.projectionMatrix=this._invertYProjectionMatrix;
				state.projectionViewMatrix=this._invertYProjectionViewMatrix;
				}else {
				state.projectionMatrix=camera.projectionMatrix;
				state.projectionViewMatrix=camera.projectionViewMatrix;
			}
			state.viewMatrix=camera.viewMatrix;
			state.viewport=camera.viewport;
			this._preRenderScene(gl,state);
			this._clear(gl,state);
			this._renderScene(gl,state);
			this.lateRender(state);
			(renderTarget)&& (renderTarget.end());
		}

		/**
		*@private
		*/
		__proto.renderSubmit=function(){
			var gl=WebGL.mainContext;
			var state=this._renderState;
			this._set3DRenderConfig(gl);
			for (var i=0,n=this._cameraPool.length;i < n;i++){
				var camera=this._cameraPool [i];
				if (camera.enable)
					this.renderCamera(gl,state,camera);
			}
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
		__proto.renderCamera=function(gl,state,cameraVR){
			this._prepareRenderToRenderState(cameraVR,state);
			state.shaderDefs.add(/*laya.d3.shader.ShaderDefines3D.VR*/0x40);
			this.beforeRender(state);
			var renderTarget=cameraVR.renderTarget;
			if (renderTarget){
				renderTarget.start();
				Matrix4x4.multiply(this._invertYScaleMatrix,cameraVR.leftProjectionMatrix,this._invertYProjectionMatrix);
				Matrix4x4.multiply(this._invertYScaleMatrix,cameraVR.leftProjectionViewMatrix,this._invertYProjectionViewMatrix);
				state.projectionMatrix=this._invertYProjectionMatrix;
				state.projectionViewMatrix=this._invertYProjectionViewMatrix;
				}else {
				state.projectionMatrix=cameraVR.leftProjectionMatrix;
				state.projectionViewMatrix=cameraVR.leftProjectionViewMatrix;
			}
			state.viewMatrix=cameraVR.leftViewMatrix;
			state.viewport=cameraVR.leftViewport;
			this._preRenderScene(gl,state);
			this._clear(gl,state);
			this._renderScene(gl,state);
			if (renderTarget){
				renderTarget.start();
				Matrix4x4.multiply(this._invertYScaleMatrix,cameraVR.rightProjectionMatrix,this._invertYProjectionMatrix);
				Matrix4x4.multiply(this._invertYScaleMatrix,cameraVR.rightProjectionViewMatrix,this._invertYProjectionViewMatrix);
				state.projectionMatrix=this._invertYProjectionMatrix;
				state.projectionViewMatrix=this._invertYProjectionViewMatrix;
				}else {
				state.projectionMatrix=cameraVR.rightProjectionMatrix;
				state.projectionViewMatrix=cameraVR.rightProjectionViewMatrix;
			}
			state.viewMatrix=cameraVR.rightViewMatrix;
			state.viewport=cameraVR.rightViewport;
			this._preRenderScene(gl,state);
			this._clear(gl,state);
			this._renderScene(gl,state);
			this.lateRender(state);
			(renderTarget)&& (renderTarget.end());
		}

		/**
		*@private
		*/
		__proto.renderSubmit=function(){
			var gl=WebGL.mainContext;
			var state=this._renderState;
			this._set3DRenderConfig(gl);
			for (var i=0,n=this._cameraPool.length;i < n;i++){
				var cameraVR=this._cameraPool [i];
				if (cameraVR.enable)
					this.renderCamera(gl,state,cameraVR);
			}
			this._set2DRenderConfig(gl);
			return 1;
		}

		return VRScene;
	})(BaseScene)


	/**
	*<code>Camera</code> 类用于创建摄像机。
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
		*计算从世界空间准换三维坐标到屏幕空间。
		*@param position 世界空间的位置。
		*@return out 输出位置。
		*/
		__proto.worldToViewportPoint=function(position,out){
			Matrix4x4.multiply(this._projectionMatrix,this._viewMatrix,this._projectionViewMatrix);
			this.viewport.project(position,this._projectionViewMatrix,out);
			if (out.z < 0.0 || out.z > 1.0){
				var outE=out.elements;
				outE[0]=outE[1]=outE[2]=NaN;
			}
		}

		/**
		*计算从世界空间准换三维坐标到裁切空间。
		*@param position 世界空间的位置。
		*@return out 输出位置。
		*/
		__proto.worldToNormalizedViewportPoint=function(position,out){
			Matrix4x4.multiply(this._projectionMatrix,this._viewMatrix,this._projectionViewMatrix);
			this.normalizedViewport.project(position,this._projectionViewMatrix,out);
			if (out.z < 0.0 || out.z > 1.0){
				var outE=out.elements;
				outE[0]=outE[1]=outE[2]=NaN;
			}
		}

		/**
		*获取视图投影矩阵。
		*@return 视图投影矩阵。
		*/
		__getset(0,__proto,'projectionViewMatrix',function(){
			Matrix4x4.multiply(this.projectionMatrix,this.viewMatrix,this._projectionViewMatrix);
			return this._projectionViewMatrix;
		});

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

		__getset(0,__proto,'needViewport',function(){
			var nVp=this.normalizedViewport;
			return nVp.x===0 && nVp.y===0 && nVp.width===1 && nVp.height===1;
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

		/**设置投影矩阵。*/
		/**获取投影矩阵。*/
		__getset(0,__proto,'projectionMatrix',function(){
			return this._projectionMatrix;
			},function(value){
			this._projectionMatrix=value;
			this._useUserProjectionMatrix=true;
		});

		/**
		*获取视图矩阵。
		*@return 视图矩阵。
		*/
		__getset(0,__proto,'viewMatrix',function(){
			this.transform.worldMatrix.invert(this._viewMatrix);
			return this._viewMatrix;
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
				state.shaderDefs.add(/*laya.d3.shader.ShaderDefines3D.DIRECTIONLIGHT*/0x1000);
				shaderValue.pushValue(/*laya.d3.core.scene.BaseScene.LIGHTDIRDIFFUSE*/"LIGHTDIRDIFFUSE",this.diffuseColor.elements);
				shaderValue.pushValue(/*laya.d3.core.scene.BaseScene.LIGHTDIRAMBIENT*/"LIGHTDIRAMBIENT",this.ambientColor.elements);
				shaderValue.pushValue(/*laya.d3.core.scene.BaseScene.LIGHTDIRSPECULAR*/"LIGHTDIRSPECULAR",this.specularColor.elements);
				shaderValue.pushValue(/*laya.d3.core.scene.BaseScene.LIGHTDIRECTION*/"LIGHTDIRECTION",this.direction.elements);
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
				state.shaderDefs.add(/*laya.d3.shader.ShaderDefines3D.POINTLIGHT*/0x2000);
				shaderValue.pushValue(/*laya.d3.core.scene.BaseScene.POINTLIGHTDIFFUSE*/"POINTLIGHTDIFFUSE",this.diffuseColor.elements);
				shaderValue.pushValue(/*laya.d3.core.scene.BaseScene.POINTLIGHTAMBIENT*/"POINTLIGHTAMBIENT",this.ambientColor.elements);
				shaderValue.pushValue(/*laya.d3.core.scene.BaseScene.POINTLIGHTSPECULAR*/"POINTLIGHTSPECULAR",this.specularColor.elements);
				shaderValue.pushValue(/*laya.d3.core.scene.BaseScene.POINTLIGHTPOS*/"POINTLIGHTPOS",this.transform.position.elements);
				shaderValue.pushValue(/*laya.d3.core.scene.BaseScene.POINTLIGHTRANGE*/"POINTLIGHTRANGE",this.range);
				shaderValue.pushValue(/*laya.d3.core.scene.BaseScene.POINTLIGHTATTENUATION*/"POINTLIGHTATTENUATION",this.attenuation.elements);
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
		*获取点光的类型。
		*@return 点光的类型。
		*/
		__getset(0,__proto,'lightType',function(){
			return 2;
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
				state.shaderDefs.add(/*laya.d3.shader.ShaderDefines3D.SPOTLIGHT*/0x4000);
				shaderValue.pushValue(/*laya.d3.core.scene.BaseScene.SPOTLIGHTDIFFUSE*/"SPOTLIGHTDIFFUSE",this.diffuseColor.elements);
				shaderValue.pushValue(/*laya.d3.core.scene.BaseScene.SPOTLIGHTAMBIENT*/"SPOTLIGHTAMBIENT",this.ambientColor.elements);
				shaderValue.pushValue(/*laya.d3.core.scene.BaseScene.SPOTLIGHTSPECULAR*/"SPOTLIGHTSPECULAR",this.specularColor.elements);
				shaderValue.pushValue(/*laya.d3.core.scene.BaseScene.SPOTLIGHTPOS*/"SPOTLIGHTPOS",this.transform.position.elements);
				shaderValue.pushValue(/*laya.d3.core.scene.BaseScene.SPOTLIGHTDIRECTION*/"SPOTLIGHTDIRECTION",this.direction.elements);
				shaderValue.pushValue(/*laya.d3.core.scene.BaseScene.SPOTLIGHTRANGE*/"SPOTLIGHTRANGE",this.range);
				shaderValue.pushValue(/*laya.d3.core.scene.BaseScene.SPOTLIGHTSPOT*/"SPOTLIGHTSPOT",this.spot);
				shaderValue.pushValue(/*laya.d3.core.scene.BaseScene.SPOTLIGHTATTENUATION*/"SPOTLIGHTATTENUATION",this.attenuation.elements);
			}
		}

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
		*获取聚光的类型。
		*@return 聚光的类型。
		*/
		__getset(0,__proto,'lightType',function(){
			return 3;
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

		return SpotLight;
	})(LightSprite)


	/**
	*<code>TerrainMeshSprite3D</code> 类用于创建网格。
	*/
	//class laya.d3.core.MeshTerrainSprite3D extends laya.d3.core.MeshSprite3D
	var MeshTerrainSprite3D=(function(_super){
		function MeshTerrainSprite3D(mesh,heightMap,name){
			this._minX=NaN;
			this._minZ=NaN;
			this._cellSize=null;
			this._heightMap=null;
			MeshTerrainSprite3D.__super.call(this,mesh,name);
			this._heightMap=heightMap;
			this._cellSize=new Vector2();
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
		__proto._initCreateFromMesh=function(heightMapWidth,heightMapHeight){
			this._heightMap=HeightMap.creatFromMesh(this.meshFilter.sharedMesh,heightMapWidth,heightMapHeight,this._cellSize);
			var boundingBox=this.meshFilter.sharedMesh.boundingBox;
			var min=boundingBox.min;
			var max=boundingBox.max;
			this._minX=min.x;
			this._minZ=min.z;
		}

		/**
		*@private
		*/
		__proto._createFromMeshAndHeightMapMeshLoaded=function(sender,texture,minHeight,maxHeight){
			this._initCreateFromMeshHeightMap(texture,minHeight,maxHeight);
		}

		/**
		*@private
		*/
		__proto._initCreateFromMeshHeightMap=function(texture,minHeight,maxHeight){
			var _$this=this;
			var boundingBox=this.meshFilter.sharedMesh.boundingBox;
			if (texture.loaded){
				this._heightMap=HeightMap.createFromImage(texture,minHeight,maxHeight);
				this._computeCellSize(boundingBox);
				}else {
				texture.once(/*laya.events.Event.LOADED*/"loaded",null,function(){
					_$this._heightMap=HeightMap.createFromImage(texture,minHeight,maxHeight);
					_$this._computeCellSize(boundingBox);
				});
			};
			var min=boundingBox.min;
			var max=boundingBox.max;
			this._minX=min.x;
			this._minZ=min.z;
		}

		/**
		*@private
		*/
		__proto._computeCellSize=function(boundingBox){
			var min=boundingBox.min;
			var max=boundingBox.max;
			var minX=min.x;
			var minZ=min.z;
			var maxX=max.x;
			var maxZ=max.z;
			var widthSize=maxX-minX;
			var heightSize=maxZ-minZ;
			this._cellSize.elements[0]=widthSize / (this._heightMap.width-1);
			this._cellSize.elements[1]=heightSize / (this._heightMap.height-1);
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
			if (isNaN(h01)|| isNaN(h10))
				return NaN;
			if (s+t <=1.0){
				var h00=this._heightMap.getHeight(row,col);
				if (isNaN(h00))
					return NaN;
				uy=h01-h00;
				vy=h10-h00;
				return (h00+s *uy+t *vy)*scaleY+translateY;
				}else {
				var h11=this._heightMap.getHeight((row+1),col+1);
				if (isNaN(h11))
					return NaN;
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
		*获取地形X轴长度。
		*@return 地形X轴长度。
		*/
		__getset(0,__proto,'width',function(){
			return (this._heightMap.width-1)*this._cellSize.x *this._getScaleX();
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
		*获取地形Z轴长度。
		*@return 地形Z轴长度。
		*/
		__getset(0,__proto,'depth',function(){
			return (this._heightMap.height-1)*this._cellSize.y *this._getScaleZ();
		});

		MeshTerrainSprite3D.createFromMesh=function(mesh,heightMapWidth,heightMapHeight,name){
			var meshTerrainSprite3D=new MeshTerrainSprite3D(mesh,null,name);
			if (mesh.loaded)
				meshTerrainSprite3D._initCreateFromMesh(heightMapWidth,heightMapHeight);
			else
			mesh.once(/*laya.events.Event.LOADED*/"loaded",meshTerrainSprite3D,meshTerrainSprite3D._initCreateFromMesh,[heightMapWidth,heightMapHeight]);
			return meshTerrainSprite3D;
		}

		MeshTerrainSprite3D.createFromMeshAndHeightMap=function(mesh,texture,minHeight,maxHeight,name){
			var meshTerrainSprite3D=new MeshTerrainSprite3D(mesh,null,name);
			if (mesh.loaded)
				meshTerrainSprite3D._initCreateFromMeshHeightMap(texture,minHeight,maxHeight);
			else
			mesh.once(/*laya.events.Event.LOADED*/"loaded",meshTerrainSprite3D,meshTerrainSprite3D._createFromMeshAndHeightMapMeshLoaded,[texture,maxHeight]);
			return meshTerrainSprite3D;
		}

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
		*获取左投影视图矩阵。
		*@return 左投影视图矩阵。
		*/
		__getset(0,__proto,'leftProjectionViewMatrix',function(){
			Matrix4x4.multiply(this.leftProjectionMatrix,this.leftViewMatrix,this._leftProjectionViewMatrix);
			return this._leftProjectionViewMatrix;
		});

		/**
		*获取右投影矩阵。
		*@return 右投影矩阵。
		*/
		__getset(0,__proto,'rightProjectionMatrix',function(){
			return this._rightProjectionMatrix;
		});

		/**
		*获取右投影视图矩阵。
		*@return 右投影视图矩阵。
		*/
		__getset(0,__proto,'rightProjectionViewMatrix',function(){
			Matrix4x4.multiply(this.rightProjectionMatrix,this.rightViewMatrix,this._rightProjectionViewMatrix);
			return this._rightProjectionViewMatrix;
		});

		return VRCamera;
	})(BaseCamera)


	/**
	*<code>Sphere</code> 类用于创建球体。
	*/
	//class laya.d3.resource.models.BoxMesh extends laya.d3.resource.models.PrimitiveMesh
	var BoxMesh=(function(_super){
		function BoxMesh(long,width,height){
			this._long=NaN;
			this._width=NaN;
			this._height=NaN;
			(long===void 0)&& (long=1);
			(width===void 0)&& (width=1);
			(height===void 0)&& (height=1);
			BoxMesh.__super.call(this);
			this._long=long;
			this._width=width;
			this._height=height;
			this.recreateResource();
			this._loaded=true;
			var pos=this.positions;
			this._boundingBox=new BoundBox(new Vector3(),new Vector3());
			BoundBox.createfromPoints(pos,this._boundingBox);
			this._boundingSphere=new BoundSphere(new Vector3(),0);
			BoundSphere.createfromPoints(pos,this._boundingSphere);
		}

		__class(BoxMesh,'laya.d3.resource.models.BoxMesh',_super);
		var __proto=BoxMesh.prototype;
		__proto.recreateResource=function(){
			this.startCreate();
			this._numberVertices=24;
			this._numberIndices=36;
			var indices=new Uint16Array(this._numberIndices);
			var vertexDeclaration=VertexPositionNormalTexture.vertexDeclaration;
			var vertexFloatStride=vertexDeclaration.vertexStride / 4;
			var vertices=new Float32Array(this._numberVertices*vertexFloatStride);
			var halfLong=this._long / 2;
			var halfWidth=this._width / 2;
			var nPointNum=0;
			vertices[nPointNum+0]=-halfLong;vertices[nPointNum+1]=this._height;vertices[nPointNum+2]=-halfWidth;
			vertices[nPointNum+3]=0;vertices[nPointNum+4]=1;vertices[nPointNum+5]=0;
			vertices[nPointNum+6]=0;vertices[nPointNum+7]=0;nPointNum+=8;
			vertices[nPointNum+0]=halfLong;vertices[nPointNum+1]=this._height;vertices[nPointNum+2]=-halfWidth;
			vertices[nPointNum+3]=0;vertices[nPointNum+4]=1;vertices[nPointNum+5]=0;
			vertices[nPointNum+6]=1;vertices[nPointNum+7]=0;nPointNum+=8;
			vertices[nPointNum+0]=halfLong;vertices[nPointNum+1]=this._height;vertices[nPointNum+2]=halfWidth;
			vertices[nPointNum+3]=0;vertices[nPointNum+4]=1;vertices[nPointNum+5]=0;
			vertices[nPointNum+6]=1;vertices[nPointNum+7]=1;nPointNum+=8;
			vertices[nPointNum+0]=-halfLong;vertices[nPointNum+1]=this._height;vertices[nPointNum+2]=halfWidth;
			vertices[nPointNum+3]=0;vertices[nPointNum+4]=1;vertices[nPointNum+5]=0;
			vertices[nPointNum+6]=0;vertices[nPointNum+7]=1;nPointNum+=8;
			vertices[nPointNum+0]=-halfLong;vertices[nPointNum+1]=0;vertices[nPointNum+2]=-halfWidth;
			vertices[nPointNum+3]=0;vertices[nPointNum+4]=-1;vertices[nPointNum+5]=0;
			vertices[nPointNum+6]=1;vertices[nPointNum+7]=0;nPointNum+=8;
			vertices[nPointNum+0]=halfLong;vertices[nPointNum+1]=0;vertices[nPointNum+2]=-halfWidth;
			vertices[nPointNum+3]=0;vertices[nPointNum+4]=-1;vertices[nPointNum+5]=0;
			vertices[nPointNum+6]=0;vertices[nPointNum+7]=0;nPointNum+=8;
			vertices[nPointNum+0]=halfLong;vertices[nPointNum+1]=0;vertices[nPointNum+2]=halfWidth;
			vertices[nPointNum+3]=0;vertices[nPointNum+4]=-1;vertices[nPointNum+5]=0;
			vertices[nPointNum+6]=0;vertices[nPointNum+7]=1;nPointNum+=8;
			vertices[nPointNum+0]=-halfLong;vertices[nPointNum+1]=0;vertices[nPointNum+2]=halfWidth;
			vertices[nPointNum+3]=0;vertices[nPointNum+4]=-1;vertices[nPointNum+5]=0;
			vertices[nPointNum+6]=1;vertices[nPointNum+7]=1;nPointNum+=8;
			vertices[nPointNum+0]=-halfLong;vertices[nPointNum+1]=this._height;vertices[nPointNum+2]=-halfWidth;
			vertices[nPointNum+3]=-1;vertices[nPointNum+4]=0;vertices[nPointNum+5]=0;
			vertices[nPointNum+6]=0;vertices[nPointNum+7]=0;nPointNum+=8;
			vertices[nPointNum+0]=-halfLong;vertices[nPointNum+1]=this._height;vertices[nPointNum+2]=halfWidth;
			vertices[nPointNum+3]=-1;vertices[nPointNum+4]=0;vertices[nPointNum+5]=0;
			vertices[nPointNum+6]=1;vertices[nPointNum+7]=0;nPointNum+=8;
			vertices[nPointNum+0]=-halfLong;vertices[nPointNum+1]=0;vertices[nPointNum+2]=halfWidth;
			vertices[nPointNum+3]=-1;vertices[nPointNum+4]=0;vertices[nPointNum+5]=0;
			vertices[nPointNum+6]=1;vertices[nPointNum+7]=1;nPointNum+=8;
			vertices[nPointNum+0]=-halfLong;vertices[nPointNum+1]=0;vertices[nPointNum+2]=-halfWidth;
			vertices[nPointNum+3]=-1;vertices[nPointNum+4]=0;vertices[nPointNum+5]=0;
			vertices[nPointNum+6]=0;vertices[nPointNum+7]=1;nPointNum+=8;
			vertices[nPointNum+0]=halfLong;vertices[nPointNum+1]=this._height;vertices[nPointNum+2]=-halfWidth;
			vertices[nPointNum+3]=1;vertices[nPointNum+4]=0;vertices[nPointNum+5]=0;
			vertices[nPointNum+6]=1;vertices[nPointNum+7]=0;nPointNum+=8;
			vertices[nPointNum+0]=halfLong;vertices[nPointNum+1]=this._height;vertices[nPointNum+2]=halfWidth;
			vertices[nPointNum+3]=1;vertices[nPointNum+4]=0;vertices[nPointNum+5]=0;
			vertices[nPointNum+6]=0;vertices[nPointNum+7]=0;nPointNum+=8;
			vertices[nPointNum+0]=halfLong;vertices[nPointNum+1]=0;vertices[nPointNum+2]=halfWidth;
			vertices[nPointNum+3]=1;vertices[nPointNum+4]=0;vertices[nPointNum+5]=0;
			vertices[nPointNum+6]=0;vertices[nPointNum+7]=1;nPointNum+=8;
			vertices[nPointNum+0]=halfLong;vertices[nPointNum+1]=0;vertices[nPointNum+2]=-halfWidth;
			vertices[nPointNum+3]=1;vertices[nPointNum+4]=0;vertices[nPointNum+5]=0;
			vertices[nPointNum+6]=1;vertices[nPointNum+7]=1;nPointNum+=8;
			vertices[nPointNum+0]=-halfLong;vertices[nPointNum+1]=this._height;vertices[nPointNum+2]=halfWidth;
			vertices[nPointNum+3]=0;vertices[nPointNum+4]=0;vertices[nPointNum+5]=1;
			vertices[nPointNum+6]=0;vertices[nPointNum+7]=0;nPointNum+=8;
			vertices[nPointNum+0]=halfLong;vertices[nPointNum+1]=this._height;vertices[nPointNum+2]=halfWidth;
			vertices[nPointNum+3]=0;vertices[nPointNum+4]=0;vertices[nPointNum+5]=1;
			vertices[nPointNum+6]=1;vertices[nPointNum+7]=0;nPointNum+=8;
			vertices[nPointNum+0]=halfLong;vertices[nPointNum+1]=0;vertices[nPointNum+2]=halfWidth;
			vertices[nPointNum+3]=0;vertices[nPointNum+4]=0;vertices[nPointNum+5]=1;
			vertices[nPointNum+6]=1;vertices[nPointNum+7]=1;nPointNum+=8;
			vertices[nPointNum+0]=-halfLong;vertices[nPointNum+1]=0;vertices[nPointNum+2]=halfWidth;
			vertices[nPointNum+3]=0;vertices[nPointNum+4]=0;vertices[nPointNum+5]=1;
			vertices[nPointNum+6]=0;vertices[nPointNum+7]=1;nPointNum+=8;
			vertices[nPointNum+0]=-halfLong;vertices[nPointNum+1]=this._height;vertices[nPointNum+2]=-halfWidth;
			vertices[nPointNum+3]=0;vertices[nPointNum+4]=0;vertices[nPointNum+5]=-1;
			vertices[nPointNum+6]=1;vertices[nPointNum+7]=0;nPointNum+=8;
			vertices[nPointNum+0]=halfLong;vertices[nPointNum+1]=this._height;vertices[nPointNum+2]=-halfWidth;
			vertices[nPointNum+3]=0;vertices[nPointNum+4]=0;vertices[nPointNum+5]=-1;
			vertices[nPointNum+6]=0;vertices[nPointNum+7]=0;nPointNum+=8;
			vertices[nPointNum+0]=halfLong;vertices[nPointNum+1]=0;vertices[nPointNum+2]=-halfWidth;
			vertices[nPointNum+3]=0;vertices[nPointNum+4]=0;vertices[nPointNum+5]=-1;
			vertices[nPointNum+6]=0;vertices[nPointNum+7]=1;nPointNum+=8;
			vertices[nPointNum+0]=-halfLong;vertices[nPointNum+1]=0;vertices[nPointNum+2]=-halfWidth;
			vertices[nPointNum+3]=0;vertices[nPointNum+4]=0;vertices[nPointNum+5]=-1;
			vertices[nPointNum+6]=1;vertices[nPointNum+7]=1;
			var nFaceNum=0;
			indices[nFaceNum+0]=0;indices[nFaceNum+1]=1;indices[nFaceNum+2]=2;nFaceNum+=3;
			indices[nFaceNum+0]=2;indices[nFaceNum+1]=3;indices[nFaceNum+2]=0;nFaceNum+=3;
			indices[nFaceNum+0]=4;indices[nFaceNum+1]=7;indices[nFaceNum+2]=6;nFaceNum+=3;
			indices[nFaceNum+0]=6;indices[nFaceNum+1]=5;indices[nFaceNum+2]=4;nFaceNum+=3;
			indices[nFaceNum+0]=8;indices[nFaceNum+1]=9;indices[nFaceNum+2]=10;nFaceNum+=3;
			indices[nFaceNum+0]=10;indices[nFaceNum+1]=11;indices[nFaceNum+2]=8;nFaceNum+=3;
			indices[nFaceNum+0]=12;indices[nFaceNum+1]=15;indices[nFaceNum+2]=14;nFaceNum+=3;
			indices[nFaceNum+0]=14;indices[nFaceNum+1]=13;indices[nFaceNum+2]=12;nFaceNum+=3;
			indices[nFaceNum+0]=16;indices[nFaceNum+1]=17;indices[nFaceNum+2]=18;nFaceNum+=3;
			indices[nFaceNum+0]=18;indices[nFaceNum+1]=19;indices[nFaceNum+2]=16;nFaceNum+=3;
			indices[nFaceNum+0]=20;indices[nFaceNum+1]=23;indices[nFaceNum+2]=22;nFaceNum+=3;
			indices[nFaceNum+0]=22;indices[nFaceNum+1]=21;indices[nFaceNum+2]=20;
			this._vertexBuffer=new VertexBuffer3D(vertexDeclaration,this._numberVertices,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4,true);
			this._indexBuffer=new IndexBuffer3D(/*laya.d3.graphics.IndexBuffer3D.INDEXTYPE_USHORT*/"ushort",this._numberIndices,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4,true);
			this._vertexBuffer.setData(vertices);
			this._indexBuffer.setData(indices);
			this.memorySize=(this._vertexBuffer.byteLength+this._indexBuffer.byteLength)*2;
			this.completeCreate();
		}

		/**
		*设置长度（改变此属性会重新生成顶点和索引）
		*@param value 长度
		*/
		/**
		*返回长度
		*@return 长
		*/
		__getset(0,__proto,'long',function(){
			return this._long;
			},function(value){
			this._long=value;
			this.recreateResource();
		});

		/**
		*设置宽度（改变此属性会重新生成顶点和索引）
		*@param value 宽度
		*/
		/**
		*返回宽度
		*@return 宽
		*/
		__getset(0,__proto,'width',function(){
			return this._width;
			},function(value){
			this._width=value;
			this.recreateResource();
		});

		/**
		*设置高度（改变此属性会重新生成顶点和索引）
		*@param value 高度
		*/
		/**
		*返回高度
		*@return 高
		*/
		__getset(0,__proto,'height',function(){
			return this._height;
			},function(value){
			this._height=value;
			this.recreateResource();
		});

		return BoxMesh;
	})(PrimitiveMesh)


	/**
	*<code>MeshCylinder</code> 类用于创建圆柱。
	*/
	//class laya.d3.resource.models.CylinderMesh extends laya.d3.resource.models.PrimitiveMesh
	var CylinderMesh=(function(_super){
		function CylinderMesh(radius,height,stacks,slices){
			this._radius=NaN;
			this._height=NaN;
			this._slices=0;
			this._stacks=0;
			(radius===void 0)&& (radius=10);
			(height===void 0)&& (height=10);
			(stacks===void 0)&& (stacks=8);
			(slices===void 0)&& (slices=8);
			CylinderMesh.__super.call(this);
			this._radius=radius;
			this._height=height;
			this._stacks=stacks;
			this._slices=slices;
			this.recreateResource();
			this._loaded=true;
			var pos=this.positions;
			this._boundingBox=new BoundBox(new Vector3(),new Vector3());
			BoundBox.createfromPoints(pos,this._boundingBox);
			this._boundingSphere=new BoundSphere(new Vector3(),0);
			BoundSphere.createfromPoints(pos,this._boundingSphere);
		}

		__class(CylinderMesh,'laya.d3.resource.models.CylinderMesh',_super);
		var __proto=CylinderMesh.prototype;
		__proto.recreateResource=function(){
			this.startCreate();
			this._numberVertices=(this._stacks+1+2)*(this._slices+1);
			this._numberIndices=(this._slices-1+this._stacks*this._slices)*2*3;
			var indices=new Uint16Array(this._numberIndices);
			var vertexDeclaration=VertexPositionNormalTexture.vertexDeclaration;
			var vertexFloatStride=vertexDeclaration.vertexStride / 4;
			var vertices=new Float32Array(this._numberVertices *vertexFloatStride);
			var sliceAngle=(Math.PI *2.0)/ this._slices;
			var cAng=0;
			var buttomUVCenterX=0.5;
			var buttomUVCenterY=0.5;
			var buttomUVR=0.5;
			var capUVCenterX=0.5;
			var capUVCenterY=0.5;
			var wallUVLeft=0;
			var wallUVTop=0;
			var wallUVRight=1;
			var wallUVBottom=1;
			var indexCount=0;
			var vertexIndex=0;
			var vertexCount=0;
			var cv=0;
			for (var slice=0;slice < (this._slices+1);slice++){
				var x=Math.cos(cAng);
				var y=Math.sin(cAng);
				cAng+=sliceAngle;
				vertices[cv++]=this._radius *x;vertices[cv++]=this._radius *y;vertices[cv++]=0;
				vertices[cv++]=0;vertices[cv++]=0;vertices[cv++]=-1;
				vertices[cv++]=buttomUVR *x+buttomUVCenterX;vertices[cv++]=buttomUVR *y+buttomUVCenterY;
			}
			for (slice=2;slice < (this._slices+1);slice++){
				indices[indexCount++]=0;
				indices[indexCount++]=slice-1;
				indices[indexCount++]=slice;
			}
			vertexCount+=(this._slices+1);
			var hdist=this._height / this._stacks;
			var cz=0;
			for (var h=0;h < this._stacks+1;h++){
				for (slice=0;slice < (this._slices+1);slice++){
					var tx=vertices[ slice*vertexFloatStride];
					var ty=vertices[ slice*vertexFloatStride+1];
					vertices[cv++]=tx;vertices[cv++]=ty;vertices[cv++]=cz;
					vertices[cv++]=tx;vertices[cv++]=ty;vertices[cv++]=0;
					vertices[cv++]=wallUVLeft+slice *(wallUVRight-wallUVLeft)/ this._slices;
					vertices[cv++]=wallUVBottom+h *(wallUVTop-wallUVBottom)/ this._stacks;
					if (h > 0 && slice > 0){
						var v1=vertexCount-1;
						var v2=vertexCount;
						var v3=vertexCount-(this._slices+1);
						var v4=vertexCount-(this._slices+1)-1;
						indices[indexCount++]=v4;indices[indexCount++]=v1;indices[indexCount++]=v2;
						indices[indexCount++]=v4;indices[indexCount++]=v2;indices[indexCount++]=v3;
					}
					vertexCount++;
				}
				cz+=hdist;
			}
			for (slice=0;slice < (this._slices+1);slice++){
				tx=vertices[ slice*vertexFloatStride];
				ty=vertices[ slice*vertexFloatStride+1];
				vertices[cv++]=tx;vertices[cv++]=ty;vertices[cv++]=this._height;
				vertices[cv++]=0;vertices[cv++]=0;vertices[cv++]=1;
				vertices[cv++]=buttomUVR*tx/this._radius+capUVCenterX;vertices[cv++]=buttomUVR*ty/this._radius+capUVCenterY;
			}
			for (slice=2;slice < (this._slices+1);slice++){
				indices[indexCount++]=vertexCount;
				indices[indexCount++]=vertexCount+slice;
				indices[indexCount++]=vertexCount+slice-1;
			}
			vertexCount+=(this._slices+1);
			this._vertexBuffer=new VertexBuffer3D(vertexDeclaration,this._numberVertices,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4,true);
			this._indexBuffer=new IndexBuffer3D(/*laya.d3.graphics.IndexBuffer3D.INDEXTYPE_USHORT*/"ushort",this._numberIndices,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4,true);
			this._vertexBuffer.setData(vertices);
			this._indexBuffer.setData(indices);
			this.memorySize=(this._vertexBuffer.byteLength+this._indexBuffer.byteLength)*2;
			this.completeCreate();
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

		return CylinderMesh;
	})(PrimitiveMesh)


	/**
	*<code>Sphere</code> 类用于创建球体。
	*/
	//class laya.d3.resource.models.SphereMesh extends laya.d3.resource.models.PrimitiveMesh
	var SphereMesh=(function(_super){
		function SphereMesh(radius,stacks,slices){
			this._radius=NaN;
			this._slices=0;
			this._stacks=0;
			(radius===void 0)&& (radius=10);
			(stacks===void 0)&& (stacks=8);
			(slices===void 0)&& (slices=8);
			SphereMesh.__super.call(this);
			this._radius=radius;
			this._stacks=stacks;
			this._slices=slices;
			this.recreateResource();
			this._loaded=true;
			var pos=this.positions;
			this._boundingBox=new BoundBox(new Vector3(),new Vector3());
			BoundBox.createfromPoints(pos,this._boundingBox);
			this._boundingSphere=new BoundSphere(new Vector3(),0);
			BoundSphere.createfromPoints(pos,this._boundingSphere);
		}

		__class(SphereMesh,'laya.d3.resource.models.SphereMesh',_super);
		var __proto=SphereMesh.prototype;
		__proto.recreateResource=function(){
			this.startCreate();
			this._numberVertices=(this._stacks+1)*(this._slices+1);
			this._numberIndices=(3 *this._stacks *(this._slices+1))*2;
			var indices=new Uint16Array(this._numberIndices);
			var vertexDeclaration=VertexPositionNormalTexture.vertexDeclaration;
			var vertexFloatStride=vertexDeclaration.vertexStride / 4;
			var vertices=new Float32Array(this._numberVertices *vertexFloatStride);
			var stackAngle=Math.PI / this._stacks;
			var sliceAngle=(Math.PI *2.0)/ this._slices;
			var vertexIndex=0;
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
						indices[indexCount++]=vertexIndex+(this._slices+1);
						indices[indexCount++]=vertexIndex;
						indices[indexCount++]=vertexIndex+1;
						indices[indexCount++]=vertexIndex+(this._slices);
						indices[indexCount++]=vertexIndex;
						indices[indexCount++]=vertexIndex+(this._slices+1);
						vertexIndex++;
					}
				}
			}
			this._vertexBuffer=new VertexBuffer3D(vertexDeclaration,this._numberVertices,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4,true);
			this._indexBuffer=new IndexBuffer3D(/*laya.d3.graphics.IndexBuffer3D.INDEXTYPE_USHORT*/"ushort",this._numberIndices,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4,true);
			this._vertexBuffer.setData(vertices);
			this._indexBuffer.setData(indices);
			this.memorySize=(this._vertexBuffer.byteLength+this._indexBuffer.byteLength)*2;
			this.completeCreate();
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

		return SphereMesh;
	})(PrimitiveMesh)



})(window,document,Laya);
