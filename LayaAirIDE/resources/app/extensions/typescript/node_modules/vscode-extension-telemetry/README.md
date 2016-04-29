# vscode-extension-telemetry
This module provides a consistent way for first-party extensions to report telemetry over Application Insights. 

# install 
`npm install vscode-extension-telemetry`

# usage
 ```javascript
 let TelemetryReporter = require('vscode-extension-telemetry'); 
 
 // all events will be prefixed with this event name
 const extensionId = '<your extension unique name>';
 
 // extension version will be reported as a property with each event 
 const extensionVersion = '<your extension version>'; 
 
 // the application insights key
 const key = '<you key>'; 
 
 let reporter = new TelemetryReporter(extensionId, extensionVersion, key); 
 
 reporter.sendTelemetryEvent('sampleEvent', { 'stringProp': 'some string' }, { 'numericMeasure': 123});
 
 ```
# common properties
- `common.extname`
- `common.extversion`
- `common.vscodemachineid` 
- `common.vscodesessionid`
- `common.vscodeversion` 
- `common.os`
- `common.osversion`
- `common.sqmid`  
- `common.sqmmachineid`

# License
[MIT](LICENSE)