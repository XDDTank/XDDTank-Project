package ddt.manager
{
   import arena.ArenaManager;
   import arena.model.ArenaScenePlayerInfo;
   import com.pickgliss.toplevel.StageReferance;
   import ddt.data.DebugCommand;
   import ddt.events.DebugEvent;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.Capabilities;
   import flash.system.LoaderContext;
   import flash.utils.getDefinitionByName;
   import road7th.data.DictionaryData;
   
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
      
      public function DebugManager()
      {
         super();
      }
      
      public static function getInstance() : DebugManager
      {
         if(_ins == null)
         {
            _ins = new DebugManager();
         }
         return _ins;
      }
      
      public function get enabled() : Boolean
      {
         return this._started && this._loadedMonster;
      }
      
      private function loadMonster() : void
      {
         if(!this._loadedMonster)
         {
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.__monsterComplete);
            this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.__progress);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.__ioError);
            this._loader.load(new URLRequest(PathManager.getMonsterPath()),new LoaderContext(false,ApplicationDomain.currentDomain));
         }
      }
      
      private function __progress(param1:ProgressEvent) : void
      {
         var _loc2_:int = param1.bytesLoaded / param1.bytesTotal * 100;
         ChatManager.Instance.sysChatYellow("Monster 已载入 " + _loc2_ + "%");
      }
      
      private function __ioError(param1:IOErrorEvent) : void
      {
         var _loc2_:LoaderInfo = param1.currentTarget as LoaderInfo;
         _loc2_.removeEventListener(Event.COMPLETE,this.__monsterComplete);
         _loc2_.removeEventListener(ProgressEvent.PROGRESS,this.__progress);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.__ioError);
         ChatManager.Instance.sysChatYellow("Monster io error: " + param1.text);
      }
      
      protected function __monsterComplete(param1:Event) : void
      {
         var _loc2_:LoaderInfo = param1.currentTarget as LoaderInfo;
         _loc2_.removeEventListener(Event.COMPLETE,this.__monsterComplete);
         _loc2_.removeEventListener(ProgressEvent.PROGRESS,this.__progress);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.__ioError);
         this._loadedMonster = true;
         ChatManager.Instance.sysChatYellow("Monster载入完成。");
      }
      
      public function startup(param1:String) : void
      {
         var arr:Array = null;
         var s:String = null;
         var param:Array = null;
         var monsterRef:Class = null;
         var str:String = param1;
         if(!this._started)
         {
            arr = str.split(" -");
            for each(s in arr)
            {
               param = s.split(" ");
               switch(param[0])
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
               }
            }
            try
            {
               if(this._user != USER || this._pwd != PWD)
               {
                  return;
               }
               monsterRef = getDefinitionByName("com.demonsters.debugger::MonsterDebugger") as Class;
               if(!monsterRef["initialized"])
               {
                  monsterRef["initialize"](StageReferance.stage);
               }
               monsterRef["startup"](this._address,this._port,this.onDebuggerConnect);
            }
            catch(e:Error)
            {
               ChatManager.Instance.sysChatYellow(e.toString());
            }
         }
      }
      
      private function onDebuggerConnect() : void
      {
         ChatManager.Instance.sysChatYellow("Monster 已经启动。");
         this._started = true;
      }
      
      public function shutdown() : void
      {
         var monsterRef:Class = null;
         if(this._started)
         {
            try
            {
               monsterRef = getDefinitionByName("com.demonsters.debugger::MonsterDebugger") as Class;
               monsterRef["shutdown"]();
               ChatManager.Instance.sysChatYellow("Monster 已经关闭。");
               this._started = false;
            }
            catch(e:Error)
            {
               ChatManager.Instance.sysChatYellow(e.toString());
            }
         }
      }
      
      public function handle(param1:String) : void
      {
         var _loc2_:String = null;
         if(param1.split(" ")[0] == "#arena")
         {
            this.showArenaInfo(param1);
         }
         if(!this._isDebug)
         {
            return;
         }
         if(!this._started)
         {
            if(param1.split(" ")[0] == "#loadmonster")
            {
               this.loadMonster();
            }
            else if(param1.split(" ")[0] == "#debug-startup" && this._loadedMonster)
            {
               this.startup(param1);
            }
            else if(param1.split(" ")[0] == "#info")
            {
               this.info();
            }
         }
         else if(this._loadedMonster)
         {
            _loc2_ = String(param1.split(" ")[0]).replace("#","");
            switch(_loc2_)
            {
               case DebugCommand.Shutdown:
                  this.shutdown();
            }
         }
         dispatchEvent(new DebugEvent(DebugEvent.DEBUG,param1));
      }
      
      private function showArenaInfo(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:DictionaryData = null;
         var _loc4_:ArenaScenePlayerInfo = null;
         if(param1.split(" ")[1] == "help")
         {
            ChatManager.Instance.sysChatYellow("输入:#arena 1 :场景信息、2 :本人信息、3[空格]名称 :此人信息");
         }
         else if(param1.split(" ")[1] == "1")
         {
            ChatManager.Instance.sysChatYellow("ID: " + ArenaManager.instance.model.selfInfo.sceneID + "--Level:" + ArenaManager.instance.model.selfInfo.sceneLevel + "--Count" + ArenaManager.instance.model.playerDic.length);
         }
         else if(param1.split(" ")[1] == "2")
         {
            ChatManager.Instance.sysChatYellow("Blood: " + ArenaManager.instance.model.selfInfo.arenaCurrentBlood + "--" + "Status:" + ArenaManager.instance.model.selfInfo.playerStauts + "--" + "Position:X" + ArenaManager.instance.model.selfInfo.playerPos.x + " Y" + ArenaManager.instance.model.selfInfo.playerPos.y + "--" + "Flag:" + ArenaManager.instance.model.selfInfo.arenaFlag + "--" + "Count:" + ArenaManager.instance.model.selfInfo.arenaCount + "--" + "FightScore:" + ArenaManager.instance.model.selfInfo.arenaFightScore + "--" + "WinScore:" + ArenaManager.instance.model.selfInfo.arenaWinScore + "--" + "WinCount:" + ArenaManager.instance.model.selfInfo.arenaMaxWin);
         }
         else if(param1.split(" ")[1] == "3")
         {
            _loc2_ = param1.split(" ")[2];
            _loc3_ = ArenaManager.instance.model.playerDic;
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_.playerInfo.NickName == _loc2_)
               {
                  ChatManager.Instance.sysChatYellow("Blood: " + _loc4_.arenaCurrentBlood + "--" + "Status:" + _loc4_.playerStauts + "--" + "Position:X" + _loc4_.playerPos.x + " X" + _loc4_.playerPos.y);
               }
            }
         }
      }
      
      private function info() : void
      {
         var _loc1_:String = "info:\n";
         var _loc2_:String = Capabilities.playerType;
         var _loc3_:String = Capabilities.version;
         var _loc4_:Boolean = Capabilities.isDebugger;
         _loc1_ += "PlayerType:" + _loc2_;
         _loc1_ += "\nPlayerVersion:" + _loc3_;
         _loc1_ += "\nisDebugger:" + _loc4_;
         if(_loc2_ == "Desktop")
         {
            _loc1_ += "\ncpuArchitecture:" + Capabilities.cpuArchitecture;
         }
         _loc1_ += "\nhasIME:" + Capabilities.hasIME;
         _loc1_ += "\nlanguage:" + Capabilities.language;
         _loc1_ += "\nos:" + Capabilities.os;
         _loc1_ += "\nscreenResolutionX:" + Capabilities.screenResolutionX;
         _loc1_ += "\nscreenResolutionY:" + Capabilities.screenResolutionY;
         ChatManager.Instance.sysChatYellow(_loc1_);
      }
      
      public function get isDebug() : Boolean
      {
         return this._isDebug;
      }
      
      public function set isDebug(param1:Boolean) : void
      {
         this._isDebug = param1;
      }
   }
}
