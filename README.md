# <img src="examples/Polybolos/Polybolos-logo.jpg" alt="Polybolos siege engine" style="width:15%; height:auto;" /> Polybolos

*Customizable web UI launcher application for Mac OSX.*  
_Wraps a run script and URL to make accessing web UIs feel like launching applications._

Polybolos lets you create Mac OSX launcher applications that can start local services (such as web UIs), wait for the local or a remote service to become ready, then open the web UI in Google Chrome, focusing on an existing tab if available, or opening a new tab if not. This approach prevents the hassle of searching for tabs, and the disorder of opening redundant tabs for the target service.

<p align="center">
  <a href="https://en.wikipedia.org/wiki/Polybolos" target="_blank" rel="noopener noreferrer">
    <img src="media/Polybolos.jpeg" alt="Polybolos siege engine" style="width:33%; height:auto;" />
  </a>
</p>

<sub>Artwork: [SBA73](https://commons.wikimedia.org/wiki/User:SBA73), [Polybolos — Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Polybolos.JPG), Licensed under [CC BY-SA 2.0](https://creativecommons.org/licenses/by-sa/2.0/).</sub>

A polybolos (pronounced _poly-BOH-los_) is an ancient Greek multi-launcher. In a similar spirit, this project enables repeated launching without manual steps beyond running the app to trigger access to a web UI.

## Features

- **Launch like an app:** Starts and accesses local web services or remote web UIs more like a native app.
- **Orchestrate a service:** Runs your setup script and waits for the service to be ready.
- **Avoid redundant tabs:** Finds an existing browser tab for your service, preventing duplicate tabs.
- **Easily make more launchers:** Simply duplicate to create another launcher app for any web UI.

## Quick Start

### 1. Create a Generic Polybolos Launcher Application

1. Open the OSX **Automator** application and create a **New Document**.  
   Choose **Application** as the type.

   _Consider storing Polybolos launcher applications in a dedicated location to keep them organized._

2. In the new Automator window, search for the action **Run AppleScript** and drag it into the workflow.

3. Replace the workflow’s default text with the contents of `Polybolos.scpt` from this repository.

   > _Note: Running the script in Automator at this point is expected to show an error like_  
   > `sh: /path/to/launcher.env: No such file or directory`,  
   > _because you haven’t yet customized the application._

4. (Optional) Save this generic launcher as `Polybolos.app` if you’d like a source template. Otherwise, proceed.

## Customize the generic Polybolos launcher for your service

1. Save (in Automator) or duplicate (in Finder) the launcher application, setting its name to the desired service (for example: `LibreChat.app`, `OpenWebUI.app`, or `Perplexity.app`).

2. (Optional) Select and set an icon for the launcher.  
   _ICNS or SVG format is suggested. The free app [Image2icon](https://apps.apple.com/us/app/image2icon-make-your-icons/id992115977?mt=12) can convert an image to an ICNS icon file matching the format of macOS apps._

3. In Finder, right-click the new app and select **Get Info** (or use Cmd-I). Drag your SVG file to the icon shown at the top of the Info window for your app.

4. Create a folder in the same directory as your app, with the same name as your app but excluding the `.app` extension.

### Customize the configuration for your launcher

See sample configurations in the `examples` directory of this repository.

**To create a configuration:**

- Ensure the configuration directory’s name matches your launcher’s name, **without the `.app` extension**.

- In the configuration directory:
  - Create `launcher.env` and set the `TARGET_BASE` variable to the target web UI, e.g.:  
    `TARGET_BASE="http://localhost:"`  
    or  
    `TARGET_BASE="http://some-site.com"`
  - Create `launcher.sh`, a script that sets up the service (handling both running and not running states) and waits until the service is reachable before returning.

### 2. Customize the Launcher for Your Service

1. Save (in Automator) or duplicate (in Finder) your launcher application, setting its name to your desired service (for example: `LibreChat.app`, `OpenWebUI.app`, or `Perplexity.app`).

2. (Optional) Select an icon for the launcher.  
   _SVG format is suggested._

3. In Finder, right-click the new app and select **Get Info** (Cmd-I). Drag your SVG file to the icon at the top of the Info window for your app.

4. **Create a folder in the same directory as your app**, with the same name as your app but excluding the `.app` extension.

#### Configuration Setup

See sample configurations in the `examples` directory of this repository.

- The configuration directory _must_ match your application's name, minus `.app`.

- In the configuration directory:
  - Create `launcher.env` and set the `TARGET_BASE` variable to your web UI, e.g.  
    `TARGET_BASE="http://localhost:8080"`  
    or  
    `TARGET_BASE="http://some-site.com"`
  - Create `launcher.sh`, a script that prepares the service (starting it if needed), and waits until it is reachable before returning.

### 3. Grant Permissions for your app to manage the service and Google Chrome

- Double-click the app to start.
- If prompted, grant file access permissions (especially if the app is in your iCloud path).
- Approve pop-ups requesting access to control System Events and Google Chrome.
- If you see `"Polybolos.app" would like to control this computer using accessibility features.`,  
  open System Settings → Privacy & Security → Accessibility, and enable access for your application.
- Once permissions are granted, your launcher will be able to start the service as needed and open or focus its web UI.
- Drag the launcher to your Dock for convenience, or launch via **Spotlight** (Cmd-Space).

## Running and Maintaining Launchers

- Running your launcher ensures the service is active and accesses its web UI in Google Chrome. 
- To create more launchers, duplicate an existing Polybolos app, give it a unique name and icon, set up a matching configuration directory, and grant permissions as above. 
- Check back here for updates or improvements to scripts and examples.

## Contributions

- Pull requests are welcome for launcher configurations to include in the `examples` directory.
  - Please include attribution when submitting example launchers.
- Explore customizing the AppleScript (`Polybolos.scpt`) if you want to support more browsers or features.
- Let me know if you create a different version that adds other capabilities. 

Polybolos is released under the [MIT License](LICENSE).
