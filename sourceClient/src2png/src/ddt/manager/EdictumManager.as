// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.EdictumManager

package ddt.manager
{
    import flash.events.EventDispatcher;
    import road7th.data.DictionaryData;
    import flash.events.IEventDispatcher;
    import ddt.events.CrazyTankSocketEvent;
    import road7th.comm.PackageIn;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import ddt.data.analyze.LoadEdictumAnalyze;
    import ddt.states.StateType;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.view.edictum.EdictumFrame;

    public class EdictumManager extends EventDispatcher 
    {

        private static var _instance:EdictumManager;

        private var unShowArr:Array = new Array();
        private var edictumDataList:DictionaryData;

        public function EdictumManager(_arg_1:IEventDispatcher=null)
        {
        }

        public static function get Instance():EdictumManager
        {
            if (_instance == null)
            {
                _instance = new (EdictumManager)();
            };
            return (_instance);
        }


        public function setup():void
        {
            this.initEvents();
        }

        private function initEvents():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.EDICTUM_GET_VERSION, this.__getEdictumVersion);
        }

        private function __getEdictumVersion(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:Array = new Array();
            var _local_5:int;
            while (_local_5 < _local_3)
            {
                _local_4.push(_local_2.readInt());
                _local_5++;
            };
            this.__checkVersion(_local_4);
        }

        private function __checkVersion(_arg_1:Array):void
        {
            var _local_2:String = SharedManager.Instance.edictumVersion;
            var _local_3:Array = new Array();
            var _local_4:int;
            while (_local_4 < _arg_1.length)
            {
                if (_local_2.indexOf(_arg_1[_local_4].toString()) != -1)
                {
                    _local_3.push(_arg_1[_local_4]);
                }
                else
                {
                    this.unShowArr.push(_arg_1[_local_4]);
                };
                _local_4++;
            };
            SharedManager.Instance.edictumVersion = _local_3.join("|");
            if (this.unShowArr.length > 0)
            {
                this.__loadEdictumData();
            };
        }

        private function __loadEdictumData():void
        {
            var _local_1:BaseLoader = LoadResourceManager.instance.createLoader(this.__getURL(), BaseLoader.REQUEST_LOADER);
            _local_1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBuddyListFailure");
            _local_1.analyzer = new LoadEdictumAnalyze(this.__returnWebSiteInfoHandler);
            LoadResourceManager.instance.startLoad(_local_1);
        }

        private function __returnWebSiteInfoHandler(_arg_1:LoadEdictumAnalyze):void
        {
            this.edictumDataList = _arg_1.edictumDataList;
            this.showEdictum();
        }

        private function __getURL():String
        {
            return (PathManager.solveRequestPath(("GMTipAllByIDs.ashx?ids=" + this.unShowArr.join(","))));
        }

        public function showEdictum():void
        {
            if (((((this.unShowArr.length == 0) || (this.edictumDataList == null)) || (this.edictumDataList[this.unShowArr[0]] == null)) || (!(StateManager.currentStateType == StateType.MAIN))))
            {
                return;
            };
            var _local_1:EdictumFrame = ComponentFactory.Instance.creatComponentByStylename("edictum.EdictumFrame");
            var _local_2:int = this.unShowArr.shift();
            _local_1.data = this.edictumDataList[_local_2];
            SharedManager.Instance.edictumVersion = ((SharedManager.Instance.edictumVersion + ",") + _local_2);
            _local_1.show();
        }


    }
}//package ddt.manager

