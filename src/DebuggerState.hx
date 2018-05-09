import debugger.IController;
import js.Promise;
import protocol.debug.Types;

typedef ThreadState = {
    var id:Int;
    var name:String;
    var status:ThreadStatus;
}

class DebuggerState {

    var breakpoints:Map<String, Array<Breakpoint>>;
    public var workspaceToAbsPath:Map<String, String>;
    public var absToWorkspace:Map<String, String>;
    public var threads:Array<ThreadState>;

    var workspaceFiles:Array<String>;
    var absFiles:Array<String>;

    public function new() {
        breakpoints = new Map<String, Array<Breakpoint>>();
        workspaceToAbsPath = new Map<String, String>();
        absToWorkspace = new Map<String, String>();
        workspaceFiles = [];
        absFiles = [];
    }

    public function getBreakpointsByPath(path:String, pathIsAbsolute:Bool=true) {
        return breakpoints.exists(path) ? breakpoints[path] : [];
    }

    public function setWorkspaceFiles(files:Array<String>) {
        workspaceFiles = files;
    }

    public function setAbsFiles(files:Array<String>) {
        absFiles = files;
    }

    public function setThreadsStatus(list:ThreadWhereList) {
        threads = [];
        while (true) {
            switch (list) {
                case Where(number, status, frameList, next):
                    threads.push({
                        id:number,
                        name:'Thread$number',
                        status:status
                    });
                    list = next;
                case Terminator:
                    break;
            }
        }
    }

    public function calcPathDictionaries() {
        for (i in 0...workspaceFiles.length) {
            workspaceToAbsPath[workspaceFiles[i]] = absFiles[i];
            absToWorkspace[absFiles[i]] = workspaceFiles[i];
        }
    }
}