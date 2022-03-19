// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.DebugManager

package ddt.manager
{
    import flash.events.EventDispatcher;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;
    import flash.system.ApplicationDomain;
    import flash.display.LoaderInfo;
    import flash.utils.getDefinitionByName;
    import com.pickgliss.toplevel.StageReferance;
    import ddt.data.DebugCommand;
    import ddt.events.DebugEvent;
    import road7th.data.DictionaryData;
    import arena.model.ArenaScenePlayerInfo;
    import arena.ArenaManager;
    import flash.system.Capabilities;

    public class DebugManager extends EventDispatcher 
    {

        private static const USER:String = "admin";
        private static const PWD:String = "ddt";
        private static var _ins:DebugManager;

        private var _user:String;
        private var _pwd:String;
        private var _address:String = "127.0.0.1";
        private var _port:String = "5800";
        private var _started:Boolean = false;
        private var _loadedMonster:Boolean = false;
        private var _loader:Loader;
        private var _isDebug:Boolean;


        public static function getInstance():DebugManager
        {
            if (_ins == null)
            {
                _ins = new (DebugManager)();
            };
            return (_ins);
        }


        public function get enabled():Boolean
        {
            return ((this._started) && (this._loadedMonster));
        }

        private function loadMonster():void
        {
            if ((!(this._loadedMonster)))
            {
                this._loader = new Loader();
                this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.__monsterComplete);
                this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.__progress);
                this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.__ioError);
                this._loader.load(new URLRequest(PathManager.getMonsterPath()), new LoaderContext(false, ApplicationDomain.currentDomain));
            };
        }

        private function __progress(_arg_1:ProgressEvent):void
        {
            var _local_2:int = int(((_arg_1.bytesLoaded / _arg_1.bytesTotal) * 100));
            ChatManager.Instance.sysChatYellow((("Monster 已载入 " + _local_2) + "%"));
        }

        private function __ioError(_arg_1:IOErrorEvent):void
        {
            var _local_2:LoaderInfo = (_arg_1.currentTarget as LoaderInfo);
            _local_2.removeEventListener(Event.COMPLETE, this.__monsterComplete);
            _local_2.removeEventListener(ProgressEvent.PROGRESS, this.__progress);
            _local_2.removeEventListener(IOErrorEvent.IO_ERROR, this.__ioError);
            ChatManager.Instance.sysChatYellow(("Monster io error: " + _arg_1.text));
        }

        protected function __monsterComplete(_arg_1:Event):void
        {
            var _local_2:LoaderInfo = (_arg_1.currentTarget as LoaderInfo);
            _local_2.removeEventListener(Event.COMPLETE, this.__monsterComplete);
            _local_2.removeEventListener(ProgressEvent.PROGRESS, this.__progress);
            _local_2.removeEventListener(IOErrorEvent.IO_ERROR, this.__ioError);
            this._loadedMonster = true;
            ChatManager.Instance.sysChatYellow("Monster载入完成。");
        }

        public function startup(str:String):void
        {
            var arr:Array;
            var s:String;
            var param:Array;
            var monsterRef:Class;
            if ((!(this._started)))
            {
                arr = str.split(" -");
                for each (s in arr)
                {
                    param = s.split(" ");
                    switch (param[0])
                    {
                        case "u":
                            this._user = param[1];
                            break;
                        case "p":
                            this._pwd = param[1];
                            break;
                        case "host":
                            this._address = param[1];
                            break;
                        case "P":
                            this._port = param[1];
                            break;
                    };
                };
                try
                {
                    if (((!(this._user == USER)) || (!(this._pwd == PWD))))
                    {
                        return;
                    };
                    monsterRef = (getDefinitionByName("com.demonsters.debugger::MonsterDebugger") as Class);
                    if ((!(monsterRef["initialized"])))
                    {
                        var _local_3:* = monsterRef;
                        (_local_3["initialize"](StageReferance.stage));
                    };
                    _local_3 = monsterRef;
                    (_local_3["startup"](this._address, this._port, this.onDebuggerConnect));
                }
                catch(e:Error)
                {
                    ChatManager.Instance.sysChatYellow(e.toString());
                };
            };
        }

        private function onDebuggerConnect():void
        {
            ChatManager.Instance.sysChatYellow("Monster 已经启动。");
            this._started = true;
        }

        public function shutdown():void
        {
            var monsterRef:Class;
            if (this._started)
            {
                try
                {
                    monsterRef = (getDefinitionByName("com.demonsters.debugger::MonsterDebugger") as Class);
                    var _local_2:* = monsterRef;
                    (_local_2["shutdown"]());
                    ChatManager.Instance.sysChatYellow("Monster 已经关闭。");
                    this._started = false;
                }
                catch(e:Error)
                {
                    ChatManager.Instance.sysChatYellow(e.toString());
                };
            };
        }

        public function handle(_arg_1:String):void
        {
            var _local_2:String;
            if (_arg_1.split(" ")[0] == "#arena")
            {
                this.showArenaInfo(_arg_1);
            };
            if ((!(this._isDebug)))
            {
                return;
            };
            if ((!(this._started)))
            {
                if (_arg_1.split(" ")[0] == "#loadmonster")
                {
                    this.loadMonster();
                }
                else
                {
                    if (((_arg_1.split(" ")[0] == "#debug-startup") && (this._loadedMonster)))
                    {
                        this.startup(_arg_1);
                    }
                    else
                    {
                        if (_arg_1.split(" ")[0] == "#info")
                        {
                            this.info();
                        };
                    };
                };
            }
            else
            {
                if (this._loadedMonster)
                {
                    _local_2 = String(_arg_1.split(" ")[0]).replace("#", "");
                    switch (_local_2)
                    {
                        case DebugCommand.Shutdown:
                            this.shutdown();
                            break;
                    };
                };
            };
            dispatchEvent(new DebugEvent(DebugEvent.DEBUG, _arg_1));
        }

        private function showArenaInfo(_arg_1:String):void
        {
            var _local_2:String;
            var _local_3:DictionaryData;
            var _local_4:ArenaScenePlayerInfo;
            if (_arg_1.split(" ")[1] == "help")
            {
                ChatManager.Instance.sysChatYellow("输入:#arena 1 :场景信息、2 :本人信息、3[空格]名称 :此人信息");
            }
            else
            {
                if (_arg_1.split(" ")[1] == "1")
                {
                    ChatManager.Instance.sysChatYellow(((((("ID: " + ArenaManager.instance.model.selfInfo.sceneID) + "--Level:") + ArenaManager.instance.model.selfInfo.sceneLevel) + "--Count") + ArenaManager.instance.model.playerDic.length));
                }
                else
                {
                    if (_arg_1.split(" ")[1] == "2")
                    {
                        ChatManager.Instance.sysChatYellow((((((((((((((((((((((((("Blood: " + ArenaManager.instance.model.selfInfo.arenaCurrentBlood) + "--") + "Status:") + ArenaManager.instance.model.selfInfo.playerStauts) + "--") + "Position:X") + ArenaManager.instance.model.selfInfo.playerPos.x) + " Y") + ArenaManager.instance.model.selfInfo.playerPos.y) + "--") + "Flag:") + ArenaManager.instance.model.selfInfo.arenaFlag) + "--") + "Count:") + ArenaManager.instance.model.selfInfo.arenaCount) + "--") + "FightScore:") + ArenaManager.instance.model.selfInfo.arenaFightScore) + "--") + "WinScore:") + ArenaManager.instance.model.selfInfo.arenaWinScore) + "--") + "WinCount:") + ArenaManager.instance.model.selfInfo.arenaMaxWin));
                    }
                    else
                    {
                        if (_arg_1.split(" ")[1] == "3")
                        {
                            _local_2 = _arg_1.split(" ")[2];
                            _local_3 = ArenaManager.instance.model.playerDic;
                            for each (_local_4 in _local_3)
                            {
                                if (_local_4.playerInfo.NickName == _local_2)
                                {
                                    ChatManager.Instance.sysChatYellow(((((((((("Blood: " + _local_4.arenaCurrentBlood) + "--") + "Status:") + _local_4.playerStauts) + "--") + "Position:X") + _local_4.playerPos.x) + " X") + _local_4.playerPos.y));
                                };
                            };
                        };
                    };
                };
            };
        }

        private function info():void
        {
            var _local_1:String = "info:\n";
            var _local_2:String = Capabilities.playerType;
            var _local_3:String = Capabilities.version;
            var _local_4:Boolean = Capabilities.isDebugger;
            _local_1 = (_local_1 + ("PlayerType:" + _local_2));
            _local_1 = (_local_1 + ("\nPlayerVersion:" + _local_3));
            _local_1 = (_local_1 + ("\nisDebugger:" + _local_4));
            if (_local_2 == "Desktop")
            {
                _local_1 = (_local_1 + ("\ncpuArchitecture:" + Capabilities.cpuArchitecture));
            };
            _local_1 = (_local_1 + ("\nhasIME:" + Capabilities.hasIME));
            _local_1 = (_local_1 + ("\nlanguage:" + Capabilities.language));
            _local_1 = (_local_1 + ("\nos:" + Capabilities.os));
            _local_1 = (_local_1 + ("\nscreenResolutionX:" + Capabilities.screenResolutionX));
            _local_1 = (_local_1 + ("\nscreenResolutionY:" + Capabilities.screenResolutionY));
            ChatManager.Instance.sysChatYellow(_local_1);
        }

        public function get isDebug():Boolean
        {
            return (this._isDebug);
        }

        public function set isDebug(_arg_1:Boolean):void
        {
            this._isDebug = _arg_1;
        }


    }
}//package ddt.manager

