package laya.wx.mini {
	import laya.net.Loader;
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	/** @private **/
	public class MiniFileMgr{
		/**@private 读取文件操作接口**/
		private static var fs:* = __JS__('wx.getFileSystemManager()');
		/**@private 下载文件接口**/
		private static var wxdown:* = __JS__('wx.downloadFile');
		/**@private 文件缓存列表**/
		public static var filesListObj:Object = {};
		/**@private 文件磁盘路径**/
		public static var fileNativeDir:String;
		/**@private 存储在磁盘的文件列表名称**/
		public static var fileListName:String = "layaairfiles.txt";
		/**@private 子域数据存储对象**/
		public static var ziyuFileData:Object = {};
		/**加载路径设定(相当于URL.rootPath)**/
		public static var loadPath:String = "";
		/**@private **/
		public static const DESCENDING : int = 2;
		/**@private **/
		public static const NUMERIC : int = 16;
		/**
		 * @private 
		 * 是否是本地4M包文件 
		 * @param url
		 * @return 
		 */		
		public static function  isLocalNativeFile(url:String):Boolean
		{
			for(var i:int = 0,sz:int = MiniAdpter.nativefiles.length;i<sz;i++)
			{
				if(url.indexOf(MiniAdpter.nativefiles[i]) != -1)
					return true;
			}
			return false;
		}
		
		/**
		 * @private 
		 * 判断缓存里是否存在文件
		 * @param fileUrl
		 * @return
		 */
		public static function getFileInfo(fileUrl:String):Object {
			var fileNativePath:String = fileUrl.split("?")[0];
			var fileObj:Object = filesListObj[fileNativePath];//这里要去除?好的完整路径
			if (fileObj == null)
				return null;
			else
				return fileObj;
			return null;
		}
		
		/**
		 * @private 
		 * 本地读取
		 * @param filePath 文件磁盘路径
		 * @param encoding 文件读取的编码格式
		 * @param callBack 回调处理
		 * @param readyUrl 文件请求加载地址
		 * @param isSaveFile 是否自动缓存下载的文件,只有在开发者自己单独加载时生效
		 * @param fileType 文件类型
		 */
		public static function read(filePath:String, encoding:String = "ascill", callBack:Handler = null, readyUrl:String = "",isSaveFile:Boolean = false,fileType:String = ""):void {
			var fileUrl:String;
			if(readyUrl!= "" && (readyUrl.indexOf("http://") != -1 || readyUrl.indexOf("https://") != -1))
			{
				fileUrl= getFileNativePath(filePath)
			}else
			{
				fileUrl = filePath;
			}
			fs.readFile({filePath: fileUrl, encoding: encoding, success: function(data:Object):void {
				callBack != null && callBack.runWith([0, data]);
			}, fail: function(data:Object):void {
				if (data && readyUrl != "")
					downFiles(readyUrl, encoding, callBack, readyUrl,isSaveFile,fileType);
				else
					callBack != null && callBack.runWith([1]);
			}});
		}
		
		/**
		 * @private 
		 * 下载远端文件(非图片跟声音文件)
		 * @param fileUrl  文件远端下载地址
		 * @param encode 文件编码
		 * @param callBack 完成回调
		 * @param readyUrl 文件真实下载地址
		 * @param isSaveFile 是否自动缓存下载的文件,只有在开发者自己单独加载时生效
		 * @param fileType 文件类型
		 */
		public static function downFiles(fileUrl:String, encoding:String = "ascii", callBack:Handler = null, readyUrl:String = "",isSaveFile:Boolean = false,fileType:String = ""):void {
			var downloadTask:* = wxdown({url: fileUrl, success: function(data:Object):void {
				if (data.statusCode === 200)
					readFile(data.tempFilePath, encoding, callBack, readyUrl,isSaveFile,fileType);
			}, fail: function(data:Object):void {
				callBack != null && callBack.runWith([1, data]);
			}});
			//获取加载进度
			downloadTask.onProgressUpdate(function(data:Object):void {
				callBack != null && callBack.runWith([2, data.progress]);
			});
		}
		
		/**
		 * @private 
		 * 本地本地磁盘文件读取
		 * @param filePath 文件磁盘临时地址
		 * @param encoding 文件设定读取的编码格式
		 * @param callBack 完成回调
		 * @param readyUrl 真实的下载地址
		 * @param isSaveFile 是否自动缓存下载的文件,只有在开发者自己单独加载时生效
		 * @param fileType 文件类型
		 */
		public static function readFile(filePath:String, encoding:String = "ascill", callBack:Handler = null, readyUrl:String = "",isSaveFile:Boolean = false,fileType:String = ""):void {
			fs.readFile({filePath: filePath, encoding: encoding, success: function(data:Object):void {
				if (filePath.indexOf("http://") != -1 || filePath.indexOf("https://") != -1)
				{
					if(MiniAdpter.autoCacheFile || isSaveFile)
					{
						copyFile(filePath, readyUrl, callBack,encoding);
					}
				}
				else
					callBack != null && callBack.runWith([0, data]);
			}, fail: function(data:Object):void {
				if (data)
					callBack != null && callBack.runWith([1, data]);
			}});
		}
		
		/**
		 * @private 
		 * 下载远端文件(图片跟声音文件)
		 * @param fileUrl  文件远端下载地址
		 * @param encode 文件编码
		 * @param callBack 完成回调
		 * @param readyUrl 文件真实下载地址
		 * @param isSaveFile 是否自动缓存下载的文件,只有在开发者自己单独加载时生效
		 */
		public static function downOtherFiles(fileUrl:String, callBack:Handler = null, readyUrl:String = "",isSaveFile:Boolean = false):void {
			wxdown({url: fileUrl, success: function(data:Object):void {
				if (data.statusCode === 200) {
					if((MiniAdpter.autoCacheFile || isSaveFile )&& readyUrl.indexOf("wx.qlogo.cn")== -1)
						copyFile(data.tempFilePath, readyUrl, callBack);
					else
						callBack != null && callBack.runWith([0, data.tempFilePath]);
				}
			}, fail: function(data:Object):void {
				callBack != null && callBack.runWith([1, data]);
			}});
		}

		/**
		 * @private 
		 * 下载文件 
		 * @param fileUrl 文件远端地址
		 * @param fileType 文件类型(image、text、json、xml、arraybuffer、sound、atlas、font)
		 * @param callBack 文件加载回调,回调内容[errorCode码(0成功,1失败,2加载进度)
		 * @param encoding 文件编码默认 ascill，非图片文件加载需要设置相应的编码，二进制编码为空字符串
		 */				
		public static function downLoadFile(fileUrl:String, fileType:String = "",callBack:Handler = null,encoding:String = "ascii"):void
		{
			if(fileType == Loader.IMAGE || fileType == Loader.SOUND)
				downOtherFiles(fileUrl,callBack,fileUrl,true);
			else
				downFiles(fileUrl,encoding,callBack,fileUrl,true,fileType);
		}
		
		/**
		 * @private 
		 * 别名处理文件
		 * @param tempFilePath
		 * @param readyUrl
		 * @param callBack
		 * @param encoding 编码
		 */
		private static function copyFile(tempFilePath:String, readyUrl:String, callBack:Handler,encoding:String = ""):void {
			var temp:Array = tempFilePath.split("/");
			var tempFileName:String = temp[temp.length - 1];
			var fileurlkey:String = readyUrl.split("?")[0];
			var fileObj:Object = getFileInfo(readyUrl);
			var saveFilePath:String = getFileNativePath(tempFileName);
			
			//这里存储图片文件到磁盘里，需要检查磁盘空间容量是否已满50M，如果超过50M就需要清理掉不用的资源
			var totalSize:int = 50 * 1024 * 1024;//总量50M
			var chaSize:int = 4 * 1024 * 1024;//差值4M(预留加载缓冲空间,给文件列表用)
			var fileUseSize:int = getCacheUseSize();//目前使用量
			if (fileObj) {
				if (fileObj.readyUrl != readyUrl)
				{
					fs.getFileInfo({
						filePath:tempFilePath,
						success:function(data:Object):void
						{
							if((fileUseSize + chaSize + data.size) >= totalSize)
							{
								if(data.size > MiniAdpter.minClearSize)
									MiniAdpter.minClearSize = data.size;
								onClearCacheRes();//如果存储满了需要清理资源,检查没用的资源清理，然后在做存储
							}
							deleteFile(tempFileName, readyUrl, callBack,encoding,data.size);
						},
						fail:function(data:Object):void{
							callBack != null && callBack.runWith([1, data]);
						}
					});
				}
				else
					callBack != null && callBack.runWith([0]);
			}else
			{
				fs.getFileInfo({
					filePath:tempFilePath,
					success:function(data:Object):void
					{
						if((fileUseSize + chaSize + data.size) >= totalSize)
						{
							if(data.size > MiniAdpter.minClearSize)
								MiniAdpter.minClearSize = data.size;
							onClearCacheRes();//如果存储满了需要清理资源,检查没用的资源清理，然后在做存储
						}
						fs.copyFile({srcPath: tempFilePath, destPath: saveFilePath, success: function(data2:Object):void {
							onSaveFile(readyUrl, tempFileName,true,encoding,callBack,data.size);
						}, fail: function(data:Object):void {
							callBack != null && callBack.runWith([1, data]);
						}});
					},
					fail:function(data:Object):void{
						callBack != null && callBack.runWith([1, data]);
					}
				});
			}	
		}
		
		/**
		 * @private 
		 * 清理缓存到磁盘的图片,每次释放默认5M，可以配置
		 */		
		private static function onClearCacheRes():void
		{
			var memSize:int = MiniAdpter.minClearSize;
			var  tempFileListArr:Array = [];
			for(var key:String in filesListObj)
			{
				tempFileListArr.push(filesListObj[key]);
			}
			sortOn(tempFileListArr,"time",NUMERIC);//按时间进行排序
			var clearSize:int = 0;
			for(var i:int = 1,sz:int = tempFileListArr.length;i<sz;i++)
			{
				var fileObj:Object = tempFileListArr[i];
				if(clearSize >= memSize)
					break;//清理容量超过设置值就跳出清理操作
				clearSize += fileObj.size;
				deleteFile("",fileObj.readyUrl);
			}
		}
		/**
		 * @private 
		 * 数组排序
		 * @param array
		 * @param name
		 * @param options
		 * @return 
		 */		
		public static function sortOn(array:Array, name:*, options:int=0):Array
		{
			if (options == NUMERIC)	return array.sort( function (a:*, b:*):int { return a[name] - b[name]; } );
			if (options == (NUMERIC | DESCENDING))	return array.sort( function (a:*, b:*):int { return b[name] - a[name]; } );
			return array.sort( function (a,b):* { return a[name]-b[name] } );
		}
		
		/**
		 * @private 
		 * 获取文件磁盘的路径(md5)
		 * @param fileName
		 * @return
		 */
		public static function getFileNativePath(fileName:String):String {
			return MiniFileMgr.fileNativeDir + "/" + fileName;
		}
		
		/**
		 * @private 
		 * 从本地删除文件
		 * @param tempFileName 文件临时地址 ,为空字符串时就会从文件列表删除
		 * @param readyUrl 文件真实下载地址
		 * @param callBack 回调处理，在存储图片时用到
		 * @param encoding  文件编码
		 * @param fileSize 文件大小
		 */
		public static function deleteFile(tempFileName:String, readyUrl:String = "", callBack:Handler = null,encoding:String = "",fileSize:int = 0):void {
			var fileObj:Object = getFileInfo(readyUrl);
			var deleteFileUrl:String = getFileNativePath(fileObj.md5);
			fs.unlink({filePath: deleteFileUrl, success: function(data:Object):void {
				var isAdd:Boolean = tempFileName != "" ? true : false;
				if(tempFileName != "")
				{
					var saveFilePath:String = getFileNativePath(tempFileName);
					fs.copyFile({srcPath: tempFileName, destPath: saveFilePath, success: function(data:Object):void {
						onSaveFile(readyUrl, tempFileName,isAdd,encoding,callBack,data.size);
					}, fail: function(data:Object):void {
						callBack != null && callBack.runWith([1, data]);
					}});
				}else
				{
					onSaveFile(readyUrl, tempFileName,isAdd,encoding,callBack,fileSize);//清理文件列表
				}
			}, fail: function(data:Object):void {
			}});
		}
		
		/**
		 * @private 
		 * 清空缓存空间文件内容 
		 */		
		public static function deleteAll():void
		{
			var  tempFileListArr:Array = [];
			for(var key:String in filesListObj)
			{
				tempFileListArr.push(filesListObj[key]);
			}
			for(var i:int = 1,sz:int = tempFileListArr.length;i<sz;i++)
			{
				var fileObj:Object = tempFileListArr[i];
				deleteFile("",fileObj.readyUrl);
			}
		}
		
		/**
		 * @private 
		 * 存储更新文件列表
		 * @param readyUrl
		 * @param md5Name
		 * @param isAdd
		 * @param encoding
		 * @param callBack
		 * @param fileSize 文件大小
		 */
		public static function onSaveFile(readyUrl:String, md5Name:String,isAdd:Boolean = true,encoding:String = "",callBack:Handler = null,fileSize:int = 0):void {
			var fileurlkey:String = readyUrl.split("?")[0];
			if(filesListObj['fileUsedSize'] == null)
				filesListObj['fileUsedSize'] =  0;
			if(isAdd)
			{
				var fileNativeName:String = getFileNativePath(md5Name);
				//获取文件大小为异步操作，如果放到完成回调里可能会出现文件列表获取没有内容
				filesListObj[fileurlkey] = {md5: md5Name, readyUrl: readyUrl,size:fileSize,times:Browser.now(),encoding:encoding};
				filesListObj['fileUsedSize'] = parseInt(filesListObj['fileUsedSize']) + fileSize;
				writeFilesList(fileurlkey,JSON.stringify(filesListObj),true);
				callBack != null && callBack.runWith([0]);
			}else
			{
				if(filesListObj[fileurlkey])
				{
					var deletefileSize:int = parseInt(filesListObj[fileurlkey].size);
					filesListObj['fileUsedSize']=parseInt(filesListObj['fileUsedSize']) - deletefileSize;
					delete filesListObj[fileurlkey];
					writeFilesList(fileurlkey,JSON.stringify(filesListObj),false);
					callBack != null && callBack.runWith([0]);
				}
			}
		}
		
		/**
		 * @private 
		 * 写入文件列表数据 
		 * @param fileurlkey
		 * @param filesListStr 
		 */		
		private static function writeFilesList(fileurlkey:String,filesListStr:String,isAdd:Boolean):void
		{
			var listFilesPath:String = fileNativeDir + "/" + fileListName;
			fs.writeFile({filePath: listFilesPath, encoding: 'utf8', data: filesListStr, success: function(data:Object):void {
			}, fail: function(data:*):void {
			}});
//			__JS__('wx').setStorage({key:listFilesPath,data:filesListStr,success:function(data:Object):void{
//				trace("-----setStorage--success------------");
//				trace(data);
//			},fail:function(data:Object):void{
//				trace("-----setStorage--fail------------");
//				trace(data);
//			}});
			//主域向子域传递消息
			if(!MiniAdpter.isZiYu &&MiniAdpter.isPosMsgYu)
			{
				__JS__('wx').postMessage({url:fileurlkey,data:filesListObj[fileurlkey],isLoad:"filenative",isAdd:isAdd});
			}
		}
		
		/**
		 * @private 
		 *获取当前缓存使用的空间大小(字节数，除以1024 再除以1024可以换算成M)
		 * @return 
		 */		
		public static function getCacheUseSize():Number
		{
			if(filesListObj && filesListObj['fileUsedSize'])
				return filesListObj['fileUsedSize'];
			return 0;
		}
		/**
		 * @private 
		 * 判断资源目录是否存在
		 * @param dirPath 磁盘设定路径
		 * @param callBack 回调处理
		 */
		public static function existDir(dirPath:String, callBack:Handler):void {
			fs.mkdir({dirPath: dirPath, success: function(data:Object):void {
				callBack != null && callBack.runWith([0, {data: JSON.stringify({})}]);
			}, fail: function(data:Object):void {
				if (data.errMsg.indexOf("file already exists") != -1)
					readSync(fileListName, "utf8", callBack);
				else
					callBack != null && callBack.runWith([1, data]);
			}});
		}
		
		/**
		 * @private 
		 * 本地读取
		 * @param filePath 文件磁盘路径
		 * @param encoding 文件读取的编码格式
		 * @param callBack 回调处理
		 * @param readyUrl 文件请求加载地址
		 */
		public static function readSync(filePath:String, encoding:String = "ascill", callBack:Handler = null, readyUrl:String = ""):void {
			var fileUrl:String = getFileNativePath(filePath);
			var filesListStr:String
			try
			{
				filesListStr = fs.readFileSync(fileUrl, encoding);
//				var tempFilesListStr:String = __JS__('wx').getStorageSync(fileUrl);
//				trace("--------tempFilesListStr:" + tempFilesListStr);
				callBack != null && callBack.runWith([0, {data: filesListStr}]);
			} 
			catch(error:Error) 
			{
				callBack != null && callBack.runWith([1]);
			}
			
		}
		
		/**
		 * @private 
		 * 设置磁盘文件存储路径
		 * @param value 磁盘路径
		 * @return
		 */
		public static function setNativeFileDir(value:String):void {
			fileNativeDir = __JS__('wx.env.USER_DATA_PATH') + value;
		}
	}
}

