var fs = require('fs');
var path = require('path');
var electron = require('electron');
var remote = electron.remote;
var ipc = electron.ipcRenderer;
var windowId = remote.getCurrentWindow().id;
var windclipHLaya = 36;


// We get the global settings through a remote call from the browser
// because its value can change dynamically.
var globalSettings;
var globalSettingsValue = remote.getGlobal('globalSettingsValue');
if (globalSettingsValue) {
    globalSettings = JSON.parse(globalSettingsValue);
} else {
    globalSettings = {
        settings: {},
        keybindings: []
    };
}

// disable pinch zoom & apply zoom level early to avoid glitches
var windowConfiguration = globalSettings.settings && globalSettings.settings.window;
webFrame.setZoomLevelLimits(1, 1);
if (windowConfiguration && typeof windowConfiguration.zoomLevel === 'number' && windowConfiguration.zoomLevel !== 0) {
    webFrame.setZoomLevel(windowConfiguration.zoomLevel);
}
// Load the loader and start loading the workbench
var rootUrl = uriFromPath(configuration.appRoot) + '/out';
// In the bundled version the nls plugin is packaged with the loader so the NLS Plugins
// loads as soon as the loader loads. To be able to have pseudo translation
createScript(rootUrl + '/vs/loader.js', function () {
    var nlsConfig;
    try {
        var config = process.env['VSCODE_NLS_CONFIG'];
        if (config) {
            nlsConfig = JSON.parse(config);
        }
    } catch (e) {
    }
    if (!nlsConfig) {
        nlsConfig = getNlsPluginConfiguration(configuration);
    }
    require.config({
        baseUrl: rootUrl,
        'vs/nls': nlsConfig,
        recordStats: configuration.enablePerformance
    });
    if (nlsConfig.pseudo) {
        require(['vs/nls'], function (nlsPlugin) {
            nlsPlugin.setPseudoTranslation(nlsConfig.pseudo);
        });
    }

    var hasWorkspaceContext = configuration.workspacePath;

    window.MonacoEnvironment = {
        'enableTasks': hasWorkspaceContext,
        'enableJavaScriptRewriting': true,
        'enableSendASmile': !!configuration.sendASmile,
        'enableTypeScriptServiceMode': true || !process.env['VSCODE_TSWORKER'],
        'enableTypeScriptServiceModeForJS': !!process.env['CODE_TSJS'] || !!process.env['VSCODE_TSJS']
    };

    var timers = window.MonacoEnvironment.timers = {
        start: new Date()
    };

    if (configuration.enablePerformance) {
        var programStart = remote.getGlobal('programStart');
        var vscodeStart = remote.getGlobal('vscodeStart');

        if (programStart) {
            timers.beforeProgram = new Date(programStart);
            timers.afterProgram = new Date(vscodeStart);
        }

        timers.vscodeStart = new Date(vscodeStart);
        timers.start = new Date(programStart || vscodeStart);
    }

    timers.beforeLoad = new Date();

    require([
        'vs/workbench/workbench.main',
        'vs/nls!vs/workbench/workbench.main',
        'vs/css!vs/workbench/workbench.main'
    ], function () {
        timers.afterLoad = new Date();

        var main = require('vs/workbench/electron-browser/main');
        main.startup(configuration, globalSettings).then(function () {
            mainStarted = true;
        }, function (error) {
            onError(error, enableDeveloperTools)
        });
    });
});
//var fs = require("fs");
//var path = require("path")
//function mkdirsSync(dirname, mode){
//    console.log(dirname);
//    if(fs.existsSync(dirname)){
//        return true;
//    }else{
//        if(mkdirsSync(path.dirname(dirname), mode)){
//            fs.mkdirSync(dirname, mode);
//            return true;
//        }
//    }
//}
//mkdirsSync("c:/a/a/a/a/a/a/a/a/a")