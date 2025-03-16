'use strict';

const { Gio, Meta } = imports.gi;
const Main = imports.ui.main;

const TerminalFocusInterface = `
<node>
  <interface name="org.gnome.Shell.Extensions.TerminalFocus">
    <method name="focusTerminal">
      <arg type="b" direction="out"/>
    </method>
    <method name="hasTerminalWindow">
      <arg type="b" direction="out"/>
    </method>
  </interface>
</node>`;

class TerminalFocusService {
    constructor() {
        this._dbusImpl = Gio.DBusExportedObject.wrapJSObject(
            TerminalFocusInterface, this);
        this._dbusImpl.export(Gio.DBus.session, 
            '/org/gnome/Shell/Extensions/TerminalFocus');
    }
    
    // Helper method to check if a window is a terminal
    _isTerminalWindow(wmClass) {
        return wmClass && (
            wmClass.toLowerCase().includes('gnome-terminal') || 
            wmClass.toLowerCase() === 'terminal' ||
            wmClass.toLowerCase() === 'org.gnome.terminal'
        );
    }
    
    // New method to check if a terminal window exists
    hasTerminalWindow() {
        let windows = global.display.get_tab_list(Meta.TabList.NORMAL, null);
        
        for (let i = 0; i < windows.length; i++) {
            let win = windows[i];
            let wmClass = win.get_wm_class();
            
            if (this._isTerminalWindow(wmClass)) {
                return true;
            }
        }
        
        return false;
    }
    
    focusTerminal() {
        // Get all windows
        let windows = global.display.get_tab_list(Meta.TabList.NORMAL, null);
        
        // Look for GNOME Terminal windows
        for (let i = 0; i < windows.length; i++) {
            let win = windows[i];
            let wmClass = win.get_wm_class();
            
            // Check if it's a terminal window
            if (this._isTerminalWindow(wmClass)) {
                // Found a terminal window, maximize and activate it
                win.maximize(Meta.MaximizeFlags.BOTH);
                Main.activateWindow(win);
                return true;
            }
        }
        
        return false;
    }
}

let terminalFocusService;

class Extension {
    constructor() {
    }
    
    enable() {
        terminalFocusService = new TerminalFocusService();
    }
    
    disable() {
        if (terminalFocusService) {
            terminalFocusService._dbusImpl.unexport();
            terminalFocusService = null;
        }
    }
}

function init() {
    return new Extension();
}
