/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
var os = require('os');
var vscode = require('vscode');
var appInsights = require('applicationinsights');
var winreg = require('winreg');
var TelemetryReporter = (function () {
    function TelemetryReporter(extensionId, extensionVersion, key) {
        this.extensionId = extensionId;
        this.extensionVersion = extensionVersion;
        //check if another instance is already initialized
        if (appInsights.client) {
            this.appInsightsClient = appInsights.getClient(key);
            // no other way to enable offline mode
            this.appInsightsClient.channel.setOfflineMode(true);
        }
        else {
            this.appInsightsClient = appInsights.setup(key)
                .setAutoCollectRequests(false)
                .setAutoCollectPerformance(false)
                .setAutoCollectExceptions(false)
                .setOfflineMode(true)
                .start()
                .client;
        }
        //prevent AI from reporting PII
        this.setupAIClient(this.appInsightsClient);
        //check if it's an Asimov key to change the endpoint
        if (key && key.indexOf('AIF-') === 0) {
            this.appInsightsClient.config.endpointUrl = "https://vortex.data.microsoft.com/collect/v1";
        }
        this.loadCommonProperties();
        if (vscode && vscode.env) {
            this.loadVSCodeCommonProperties(vscode.env.machineId, vscode.env.sessionId, vscode.version);
        }
    }
    TelemetryReporter.prototype.setupAIClient = function (client) {
        if (client && client.context &&
            client.context.keys && client.context.tags) {
            var machineNameKey = client.context.keys.deviceMachineName;
            client.context.tags[machineNameKey] = '';
        }
    };
    TelemetryReporter.prototype.loadVSCodeCommonProperties = function (machineId, sessionId, version) {
        this.commonProperties = this.commonProperties || Object.create(null);
        this.commonProperties['vscodemachineid'] = machineId;
        this.commonProperties['vscodesessionid'] = sessionId;
        this.commonProperties['vscodeversion'] = version;
    };
    TelemetryReporter.prototype.loadCommonProperties = function () {
        var _this = this;
        this.commonProperties = this.commonProperties || Object.create(null);
        this.commonProperties['os'] = os.platform();
        this.commonProperties['osversion'] = os.release();
        this.commonProperties['extname'] = this.extensionId;
        this.commonProperties['extversion'] = this.extensionVersion;
        // add SQM data for windows machines
        if (process.platform === 'win32') {
            this.getWinRegKeyData(TelemetryReporter.SQM_KEY, TelemetryReporter.REGISTRY_USERID_VALUE, winreg.HKCU, function (error, result) {
                if (!error && result) {
                    _this.commonProperties['sqmid'] = result;
                }
            });
            this.getWinRegKeyData(TelemetryReporter.SQM_KEY, TelemetryReporter.REGISTRY_MACHINEID_VALUE, winreg.HKLM, function (error, result) {
                if (!error && result) {
                    _this.commonProperties['sqmmachineid'] = result;
                }
            });
        }
    };
    TelemetryReporter.prototype.addCommonProperties = function (properties) {
        for (var prop in this.commonProperties) {
            properties['common.' + prop] = this.commonProperties[prop];
        }
        return properties;
    };
    TelemetryReporter.prototype.getWinRegKeyData = function (key, name, hive, callback) {
        if (process.platform === 'win32') {
            try {
                var reg = new winreg({
                    hive: hive,
                    key: key
                });
                reg.get(name, function (e, result) {
                    if (e || !result) {
                        callback(e, null);
                    }
                    else {
                        callback(null, result.value);
                    }
                });
            }
            catch (err) {
                callback(err, null);
            }
        }
        else {
            callback(null, null);
        }
    };
    TelemetryReporter.prototype.sendTelemetryEvent = function (eventName, properties, measures) {
        if (eventName) {
            properties = properties || Object.create(null);
            properties = this.addCommonProperties(properties);
            this.appInsightsClient.trackEvent(this.extensionId + "/" + eventName, properties, measures);
        }
    };
    TelemetryReporter.SQM_KEY = '\\SOFTWARE\\Microsoft\\SQMClient';
    TelemetryReporter.REGISTRY_USERID_VALUE = 'UserId';
    TelemetryReporter.REGISTRY_MACHINEID_VALUE = 'MachineId';
    return TelemetryReporter;
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = TelemetryReporter;
//# sourceMappingURL=telemetryReporter.js.map