var app = require('app');
var path = require('path');
var BrowserWindow = require('browser-window');
var globalShortcut	= require('global-shortcut');
var childProcess	= require('child_process');
var compileProcess
// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
var mainWindow = null;

//单例控制
var shouldQuit = app.makeSingleInstance(function(commandLine, workingDirectory)
{
    if(mainWindow)
    {
        var arg = commandLine[1];
        console.log(arg)
        if(arg)
        {
            startCompileLayaAir(arg);
        }
    }
    return true;
});
if(shouldQuit)
{
    app.quit();
    return;
}
function startCompileLayaAir(arg)
{
    mainWindow.show();
    arg+=";iflash=false;chromerun=false"
    compileProcess = childProcess.spawn(__dirname+ "\\laya.js.exe", [arg]);
    compileProcess.stdout.on('data', function(chunk)
    {
        console.log(chunk);
    });
    compileProcess.stdout.on('close',function(){

        mainWindow.loadUrl(path.resolve(__dirname,"../../../LayaAirEditor/bin/h5/index.html"));
    });
}

// Quit when all windows are closed.
app.on('window-all-closed', function() {
  app.quit();
});

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
app.on('ready', function() {
  // Create the browser window.
  mainWindow = new BrowserWindow({width: 1000, height: 800, "min-width":800,"min-height":600,'auto-hide-menu-bar': true,'use-content-size': true,
    frame:false});

  console.log("start");
  if(process.argv.length>1)
  {
      var arg = process.argv[1];						//索引1后才是参数
      startCompileLayaAir(arg);
  }
  // and load the index.html of the app.
  mainWindow.loadUrl(path.resolve(__dirname,"layaEditor/h5/index.html"));

  //  	//注册快捷键--------------------
  globalShortcut.register('ctrl+shift+alt+f12', function()
  {
        mainWindow.toggleDevTools();
   });
  var ipc=require("ipc");
  ipc.on('message', function(event, type,data) 
  {
  console.log(type,data);  // prints "ping"
  if(type=="cmd")
  {
  	dealCmd(data);
  }
   });
   
   function dealCmd(data)
   {
   	mainWindow[data.funName](data.param);
   }

  // Emitted when the window is closed.
  mainWindow.on('closed', function() {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    mainWindow = null;
  });
});