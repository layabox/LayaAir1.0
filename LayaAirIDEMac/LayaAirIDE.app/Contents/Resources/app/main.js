const electron = require('electron');
const app = electron.app;
const BrowserWindow = electron.BrowserWindow;
const remote = electron.remote;
const globalShortcut = require('global-shortcut');

var mainWindow = null;

//单例控制
var shouldQuit = app.makeSingleInstance(function(commandLine, workingDirectory)
{
    if (mainWindow)
    {
        var arg = commandLine[1];
        console.log(arg)
        if (arg)
        {
            //startCompileLayaAir(arg);ins
        }
    }
    return true;
});
if (shouldQuit)
{
    app.quit();
    return;
}

// Quit when all windows are closed.
app.on('window-all-closed', function()
{
    app.quit();
});

app.on('ready', function()
{
    mainWindow = new BrowserWindow(
    {
        width: 800,
        height: 600,
        frame: false,
        autoHideMenuBar: true,
        useContentSize: true,
    });

    mainWindow.loadURL("file://" + __dirname + "/layaEditor/h5/index.html?v=1");
    mainWindow.focus();
    //mainWindow.openDevTools();

    //注册快捷键--------------------
    globalShortcut.register('ctrl+shift+alt+f12', function()
    {
        mainWindow.toggleDevTools();
    });
    var ipc = require("ipc");
    ipc.on('message', function(event, type, data)
    {
        console.log(type, data); // prints "ping"
        if (type == "cmd")
        {
            dealCmd(data);
        }
    });

    function dealCmd(data)
    {
        mainWindow[data.funName](data.param);
    }

    // Emitted when the window is closed.
    mainWindow.on('closed', function()
    {
        // Dereference the window object, usually you would store windows
        // in an array if your app supports multi windows, this is the time
        // when you should delete the corresponding element.
        mainWindow = null;
    });
});


// Quit when all windows are closed and no other one is listening to this.
app.on('window-all-closed', function()
{
    if (app.listeners('window-all-closed').length == 1)
        app.quit();
});