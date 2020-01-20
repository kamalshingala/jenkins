# FX Currency Converter Overview

This application uses Westpac's FX Rates to Convert major foreign currencies to and from Australian dollars using https://www.westpac.com.au/bin/getJsonRates.wbc.fx.json API

## IIS Server Setup

* Enable IIS Server on your host
  * Open Control Panel on your windows server
  * Open Programs and Features
  * Click “Turn Windows features on or off“ and Enter Administrator credentials
  * Once Windows Features dialog box appears, Locate Internet Information Services and enable it
  * Finally Click OK
  * Windows will search and apply the changes to required files. 
  * Once completed, Click on Close.
* Open IIS Manager using `WIN Key + R` & Search `inetmgr`.
* IIS will use `C:\inetpub\wwwroot\` as default project. Copy and paste the Project folder in `C:\inetpub\`
* Setup a new website in IIS
  * To setup a new website in IIS 10, right-click on Sites and choose Add Website.
  * Give the site a name and browse to the physical path where the web files are stored. For e.g. `C:\inetpub\wpFXCalculator\`
  * In the binding section select protocol as `HTTP` and Port as any available port on a given machine for e.g. set port to `99`
  * Click OK to host the website on the localhost's IIS Server.
* Access FX Currency Converter website by navigating to `http//localhost:allocatedPort/` for e.g. `http://localhost:99/`

## Setup requirements if running from Westpac's IIS Server

* Deploy files from /wpFXCalculator to Westpac's IIS server
* Assuming https://www.westpac.com.au/bin/getJsonRates.wbc.fx.json API allows above Westpac server as part of the Access-Control-Allow-Origin list for CORS (Cross-Origin Resource Sharing) header
* Uncomment "fetch(`https://www.westpac.com.au/bin/getJsonRates.wbc.fx.json`)" line from /wpFXCalculator/function.js file and comment "fetch(`http://localhost:99//coversionRates.json`)" line

## Setup requirements if running from a given machine's IIS Server

* Deploy files from /wpFXCalculator to your IIS server
* Assuming https://www.westpac.com.au/bin/getJsonRates.wbc.fx.json API does not allow the given server as part of the Access-Control-Allow-Origin list for CORS (Cross-Origin Resource Sharing) header
* Uncomment "fetch(`http://localhost:99//coversionRates.json`)" line from /wpFXCalculator/function.js file and comment "fetch(`https://www.westpac.com.au/bin/getJsonRates.wbc.fx.json`)" line

## References
* IIS Server setup - https://helpdeskgeek.com/windows-10/install-and-setup-a-website-in-iis-on-windows-10/