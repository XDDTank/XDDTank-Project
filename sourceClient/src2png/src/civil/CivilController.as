// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//civil.CivilController

package civil
{
    import ddt.states.BaseStateView;
    import civil.view.CivilViewFrame;
    import civil.view.CivilRegisterFrame;
    import ddt.manager.SocketManager;
    import ddt.view.MainToolBar;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.ComponentFactory;
    import cityWide.CityWideManager;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.Event;
    import com.pickgliss.ui.LayerManager;
    import ddt.data.player.CivilPlayerInfo;
    import ddt.utils.RequestVairableCreater;
    import flash.net.URLVariables;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import ddt.manager.LanguageMgr;
    import ddt.data.analyze.CivilMemberListAnalyze;
    import com.pickgliss.loader.LoaderEvent;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.LeavePageManager;
    import ddt.states.StateType;

    public class CivilController extends BaseStateView 
    {

        private static var _instance:CivilController;

        private var _model:CivilModel;
        private var _view:CivilViewFrame;
        private var _register:CivilRegisterFrame;


        public static function get Instance():CivilController
        {
            if (_instance == null)
            {
                _instance = new (CivilController)();
            };
            return (_instance);
        }


        public function setup():void
        {
            this.init();
        }

        override public function prepare():void
        {
            super.prepare();
        }

        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            super.enter(_arg_1, _arg_2);
            SocketManager.Instance.out.sendCurrentState(1);
            this.init(_arg_2);
            MainToolBar.Instance.show();
        }

        private function init(_arg_1:Boolean=true):void
        {
            this._model = new CivilModel(_arg_1);
            this.loadCivilMemberList(1, (!(PlayerManager.Instance.Self.Sex)));
            this._model.sex = (!(PlayerManager.Instance.Self.Sex));
            this._view = ComponentFactory.Instance.creatCustomObject("ddtCivilViewFrame", [this, this._model]);
            this._view.show();
            CityWideManager.Instance.toSendOpenCityWide();
        }

        override public function dispose():void
        {
            this._model.dispose();
            this._model = null;
            ObjectUtils.disposeObject(this._view);
            this._view = null;
            if (this._register)
            {
                this._register.removeEventListener(Event.COMPLETE, this.__onRegisterComplete);
                this._register.dispose();
                this._register = null;
            };
        }

        public function Register():void
        {
            this._register = ComponentFactory.Instance.creatComponentByStylename("civil.register.CivilRegisterFrame");
            this._register.model = this._model;
            this._register.addEventListener(Event.COMPLETE, this.__onRegisterComplete);
            LayerManager.Instance.addToLayer(this._register, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function __onRegisterComplete(_arg_1:Event):void
        {
            this._register.removeEventListener(Event.COMPLETE, this.__onRegisterComplete);
            ObjectUtils.disposeObject(this._register);
            this._register = null;
        }

        public function get currentcivilInfo():CivilPlayerInfo
        {
            if (this._model)
            {
                return (this._model.currentcivilItemInfo);
            };
            return (null);
        }

        public function set currentcivilInfo(_arg_1:CivilPlayerInfo):void
        {
            if (this._model)
            {
                this._model.currentcivilItemInfo = _arg_1;
            };
        }

        public function upLeftView(_arg_1:CivilPlayerInfo):void
        {
            if (this._model)
            {
                this._model.currentcivilItemInfo = _arg_1;
            };
        }

        public function loadCivilMemberList(_arg_1:int=0, _arg_2:Boolean=true, _arg_3:String=""):void
        {
            var _local_4:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_4["page"] = _arg_1;
            _local_4["name"] = _arg_3;
            _local_4["sex"] = _arg_2;
            var _local_5:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("MarryInfoPageList.ashx"), BaseLoader.REQUEST_LOADER, _local_4);
            _local_5.loadErrorMessage = LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.infoError");
            _local_5.analyzer = new CivilMemberListAnalyze(this.__loadCivilMemberList);
            _local_5.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            LoadResourceManager.instance.startLoad(_local_5);
        }

        private function __onLoadError(_arg_1:LoaderEvent):void
        {
            var _local_2:String = _arg_1.loader.loadErrorMessage;
            if (_arg_1.loader.analyzer)
            {
                _local_2 = ((_arg_1.loader.loadErrorMessage + "\n") + _arg_1.loader.analyzer.message);
            };
            var _local_3:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("aler"), _arg_1.loader.loadErrorMessage, LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
            _local_3.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
        }

        private function __onAlertResponse(_arg_1:FrameEvent):void
        {
            _arg_1.currentTarget.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
            ObjectUtils.disposeObject(_arg_1.currentTarget);
            LeavePageManager.leaveToLoginPath();
        }

        private function __loadCivilMemberList(_arg_1:CivilMemberListAnalyze):void
        {
            if (this._model)
            {
                if (this._model.TotalPage != _arg_1._totalPage)
                {
                    this._model.TotalPage = _arg_1._totalPage;
                };
                this._model.civilPlayers = _arg_1.civilMemberList;
            };
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            MainToolBar.Instance.hide();
            super.leaving(_arg_1);
            this.dispose();
        }

        override public function getType():String
        {
            return (StateType.CIVIL);
        }

        override public function getBackType():String
        {
            return (StateType.MAIN);
        }


    }
}//package civil

