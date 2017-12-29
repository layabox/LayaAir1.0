package laya.wx.mini {
	import laya.events.EventDispatcher;
	import laya.utils.Handler;
	
	public class MiniFileMgr extends EventDispatcher {
		/**加载文件列表**/
		private static var _fileTypeArr:Array = ['json', 'ani', 'xml', 'sk', 'txt', 'atlas', 'swf', 'part', 'fnt', 'proto', 'lh', 'lav', 'lani', 'lmat', 'lm', 'ltc'];
		/**读取文件操作接口**/
		private static var fs:* = __JS__('wx.getFileSystemManager()');
		/**下载文件接口**/
		private static var wxdown:* = __JS__('wx.downloadFile');
		/**文件缓存列表**/
		public static var filesListObj:Object = {};
		/**文件磁盘路径**/
		public static var fileNativeDir:String;
		/**存储在磁盘的文件列表名称**/
		public static var fileListName:String = "layaairfiles.txt";
		/**子域数据存储对象**/
		public static var ziyuFileData:Object = {};
		/**
		 *判断是否走file加载文件流程
		 * @param type
		 * @return
		 */
		public static function isLoadFile(type:String):Boolean {
			return _fileTypeArr.indexOf(type) != -1 ? true : false;
		}
		
		/**
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
		 * 检查文件是否需要更新
		 * @param tempFilePath 临时地址
		 * @param readyUrl 图片加载地址
		 */
		public static function onFileUpdate(tempFilePath:String, readyUrl:String):void {
			var temp:Array = tempFilePath.split("/");
			var tempFileName:String = temp[temp.length - 1];
			var fileObj:Object = getFileInfo(readyUrl);
			if (fileObj == null)
				onSaveFile(readyUrl, tempFileName);
			else {
				if (fileObj.readyUrl != readyUrl)
					remove(tempFileName, readyUrl);
			}
		}
		
		/**
		 * 文件是否存在
		 * @param fileName 文件路径
		 * @param callBack 回调
		 */
		public static function exits(fileName:String, callBack:Handler):void {
			var nativeFileName:String = getFileNativePath(fileName);
			fs.getFileInfo({filePath: nativeFileName, success: function(data):void {
				callBack != null && callBack.runWith([0, data]);
			}, fail: function(data):void {
				callBack != null && callBack.runWith([1, data]);
			}});
		}
		
		/**
		 * 本地读取
		 * @param nativeFileUrl 文件磁盘路径
		 * @param encoding 文件读取的编码格式
		 * @param callBack 回调处理
		 * @param readyUrl 文件请求加载地址
		 */
		public static function read(filePath:String, encoding:String = "ascill", callBack:Handler = null, readyUrl:String = ""):void {
			var fileUrl:String;
			if(readyUrl!= "")
			{
				fileUrl= getFileNativePath(filePath)
			}else
			{
				fileUrl = filePath;
			}
			fs.readFile({filePath: fileUrl, encoding: encoding, success: function(data):void {
				callBack != null && callBack.runWith([0, data]);
			}, fail: function(data):void {
				if (data && readyUrl != "")
					down(readyUrl, encoding, callBack, readyUrl);
				else
					callBack != null && callBack.runWith([1]);
			}});
		}
		
		/**
		 * 读取本地图片
		 * @param filePath
		 * @param callBack
		 */
		public static function readNativeFile(filePath:String, callBack:Handler = null):void {
			fs.readFile({filePath: filePath, encoding: "", success: function(data):void {
				callBack != null && callBack.runWith([0]);
			}, fail: function(data):void {
				callBack != null && callBack.runWith([1]);
			}});
		}
		
		/**
		 * 下载远端文件
		 * @param fileUrl  文件远端下载地址
		 * @param encode 文件编码
		 * @param callBack 完成回调
		 * @param readyUrl 文件真实下载地址
		 */
		public static function down(fileUrl:String, encoding:String = "ascill", callBack:Handler = null, readyUrl:String = ""):void {
			var savePath:String = getFileNativePath(readyUrl);
			var downloadTask:* = wxdown({url: fileUrl, filePath: savePath, success: function(data):void {
				if (data.statusCode === 200)
					readFile(data.filePath, encoding, callBack, readyUrl);
			}, fail: function(data):void {
				callBack != null && callBack.runWith([1, data]);
			}});
			//获取加载进度
			downloadTask.onProgressUpdate(function(data:*):void {
				callBack != null && callBack.runWith([2, data.progress]);
			});
		}
		
		/**
		 * 本地本地磁盘文件读取
		 * @param nativeFileUrl 文件磁盘临时地址
		 * @param encoding 文件设定读取的编码格式
		 * @param callBack 完成回调
		 * @param readyUrl 真实的下载地址
		 */
		public static function readFile(filePath:String, encoding:String = "ascill", callBack:Handler = null, readyUrl:String = ""):void {
			fs.readFile({filePath: filePath, encoding: encoding, success: function(data:*):void {
				if (filePath.indexOf("http://") != -1 || filePath.indexOf("https://") != -1)
					onFileUpdate(filePath, readyUrl);
				callBack != null && callBack.runWith([0, data]);
			}, fail: function(data:*):void {
				if (data)
					callBack != null && callBack.runWith([1, data]);
			}});
		}
		
		/**
		 * 下载远端文件
		 * @param fileUrl  文件远端下载地址
		 * @param encode 文件编码
		 * @param callBack 完成回调
		 * @param readyUrl 文件真实下载地址
		 */
		public static function downImg(fileUrl:String, callBack:Handler = null, readyUrl:String = ""):void {
			var downloadTask:* = wxdown({url: fileUrl, success: function(data):void {
				if (data.statusCode === 200) {
					copyFile(data.tempFilePath, readyUrl, callBack);
				}
			}, fail: function(data):void {
				callBack != null && callBack.runWith([1, data]);
			}});
		}
		
		/**
		 * 别名处理文件
		 * @param tempFilePath
		 * @param readyUrl
		 * @param callBack
		 */
		private static function copyFile(tempFilePath:String, readyUrl:String, callBack:Handler):void {
			var temp:Array = tempFilePath.split("/");
			var tempFileName:String = temp[temp.length - 1];
			var fileurlkey:String = readyUrl.split("?")[0];
			var fileObj:Object = getFileInfo(readyUrl);
			var saveFilePath:String = getFileNativePath(tempFileName);
			fs.copyFile({srcPath: tempFilePath, destPath: saveFilePath, success: function(data):void {
				if (!fileObj) {
					onSaveFile(readyUrl, tempFileName);
					callBack != null && callBack.runWith([0]);
				} else {
					if (fileObj.readyUrl != readyUrl)
						remove(tempFileName, readyUrl, callBack);
				}
			}, fail: function(data):void {
				callBack != null && callBack.runWith([1, data]);
			}});
		}
		
		/**
		 * 获取文件磁盘的路径(md5)
		 * @param fileName
		 * @return
		 */
		public static function getFileNativePath(fileName:String):String {
			return MiniFileMgr.fileNativeDir + "/" + fileName;
		}
		
		/**
		 * 从本地删除文件
		 * @param tempFileName 文件临时地址
		 * @param readyUrl 文件真实下载地址
		 * @param callBack 回调处理，在存储图片时用到
		 */
		public static function remove(tempFileName:String, readyUrl:String = "", callBack:Handler = null):void {
			var fileObj:Object = getFileInfo(readyUrl);
			var deleteFileUrl:String = getFileNativePath(fileObj.md5);
			Laya.loader.clearRes(fileObj.readyUrl);
			fs.unlink({filePath: deleteFileUrl, success: function(data:*):void {
				if (readyUrl != "")
					onSaveFile(readyUrl, tempFileName);
				callBack != null && callBack.runWith([0]);
			}, fail: function(data:*):void {
			}});
		}
		
		/**
		 * 存储更新文件列表
		 * @param readyUrl
		 * @param md5Name
		 */
		private static function onSaveFile(readyUrl:String, md5Name:String):void {
			var fileurlkey:String = readyUrl.split("?")[0];
			filesListObj[fileurlkey] = {md5: md5Name, readyUrl: readyUrl};
			fs.writeFile({filePath: fileNativeDir + "/" + fileListName, encoding: 'utf8', data: JSON.stringify(filesListObj), success: function(data):void {
			}, fail: function(data):void {
			}});
		}
		
		/**
		 * 判断资源目录是否存在
		 * @param dirPath 磁盘设定路径
		 * @param callBack 回调处理
		 */
		public static function existDir(dirPath:String, callBack:Handler):void {
			fs.mkdir({dirPath: dirPath, success: function(data:*):void {
				callBack != null && callBack.runWith([0, {data: JSON.stringify({})}]);
			}, fail: function(data:*):void {
				if (data.errMsg.indexOf("file already exists") != -1)
					readSync(fileListName, "utf8", callBack);
				else
					callBack != null && callBack.runWith([1, data]);
			}});
		}
		
		/**
		 * 本地读取
		 * @param nativeFileUrl 文件磁盘路径
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
				callBack != null && callBack.runWith([0, {data: filesListStr}]);
			} 
			catch(error:Error) 
			{
				callBack != null && callBack.runWith([1]);
			}
			
		}
		
		/**
		 * 设置磁盘文件存储路径
		 * @param value 磁盘路径
		 * @return
		 */
		public static function setNativeFileDir(value:String):void {
			fileNativeDir = __JS__('wx.env.USER_DATA_PATH') + value;
		}
	}
}

