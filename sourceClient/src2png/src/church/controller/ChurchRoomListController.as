// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.controller.ChurchRoomListController

package church.controller
{
    import ddt.states.BaseStateView;
    import church.model.ChurchRoomListModel;
    import church.view.ChurchMainViewFrame;
    import ddt.manager.SoundManager;
    import ddt.view.MainToolBar;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.data.player.SelfInfo;
    import road7th.comm.PackageIn;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.data.ChurchRoomInfo;
    import ddt.manager.PathManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.ExternalInterfaceManager;
    import ddt.manager.ServerManager;
    import ddt.manager.ChurchManager;
    import flash.events.Event;
    import ddt.states.StateType;

    public class ChurchRoomListController extends BaseStateView 
    {

        private static var _instance:ChurchRoomListController;
        public static const UNMARRY:String = "unmarry";

        private var _model:ChurchRoomListModel;
        private var _view:ChurchMainViewFrame;
        private var _mapSrcLoaded:Boolean = false;
        private var _mapServerReady:Boolean = false;


        public static function get Instance():ChurchRoomListController
        {
            if (_instance == null)
            {
                _instance = new (ChurchRoomListController)();
            };
            return (_instance);
        }


        override public function prepare():void
        {
            super.prepare();
        }

        public function setup():void
        {
            this.openChurch();
        }

        private function openChurch():void
        {
            this.init();
            this.addEvent();
            SoundManager.instance.playMusic("062");
        }

        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            super.enter(_arg_1, _arg_2);
            this.init();
            this.addEvent();
            MainToolBar.Instance.show();
            SoundManager.instance.playMusic("062");
        }

        private function init():void
        {
            this._model = new ChurchRoomListModel();
            this._view = ComponentFactory.Instance.creatCustomObject("ddtChurchMainViewFrame", [this, this._model]);
            this._view.show();
        }

        private function addEvent():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_CREATE, this.__addRoom);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_DISPOSE, this.__removeRoom);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_UPDATE, this.__updateRoom);
        }

        private function removeEvent():void
        {
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MARRY_ROOM_CREATE, this.__addRoom);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MARRY_ROOM_DISPOSE, this.__removeRoom);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MARRY_ROOM_UPDATE, this.__updateRoom);
        }

        private function __addRoom(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_6:SelfInfo;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:Boolean = _local_2.readBoolean();
            if ((!(_local_3)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.weddingRoom.WeddingRoomControler.addRoom"));
                return;
            };
            var _local_4:ChurchRoomInfo = new ChurchRoomInfo();
            _local_4.id = _local_2.readInt();
            _local_4.isStarted = _local_2.readBoolean();
            _local_4.roomName = _local_2.readUTF();
            _local_4.isLocked = _local_2.readBoolean();
            _local_4.mapID = _local_2.readInt();
            _local_4.valideTimes = _local_2.readInt();
            _local_4.currentNum = _local_2.readInt();
            _local_4.createID = _local_2.readInt();
            _local_4.createName = _local_2.readUTF();
            _local_4.groomID = _local_2.readInt();
            _local_4.groomName = _local_2.readUTF();
            _local_4.brideID = _local_2.readInt();
            _local_4.brideName = _local_2.readUTF();
            _local_4.creactTime = _local_2.readDate();
            var _local_5:int = _local_2.readByte();
            if (_local_5 == 1)
            {
                _local_4.status = ChurchRoomInfo.WEDDING_NONE;
            }
            else
            {
                _local_4.status = ChurchRoomInfo.WEDDING_ING;
            };
            if (PathManager.solveExternalInterfaceEnabel())
            {
                _local_6 = PlayerManager.Instance.Self;
                ExternalInterfaceManager.sendToAgent(8, _local_6.ID, _local_6.NickName, ServerManager.Instance.zoneName, -1, "", _local_6.SpouseName);
            };
            _local_4.discription = _local_2.readUTF();
            this._model.addRoom(_local_4);
        }

        private function __removeRoom(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            this._model.removeRoom(_local_2);
        }

        private function __updateRoom(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_4:ChurchRoomInfo;
            var _local_5:int;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:Boolean = _local_2.readBoolean();
            if (_local_3)
            {
                _local_4 = new ChurchRoomInfo();
                _local_4.id = _local_2.readInt();
                _local_4.isStarted = _local_2.readBoolean();
                _local_4.roomName = _local_2.readUTF();
                _local_4.isLocked = _local_2.readBoolean();
                _local_4.mapID = _local_2.readInt();
                _local_4.valideTimes = _local_2.readInt();
                _local_4.currentNum = _local_2.readInt();
                _local_4.createID = _local_2.readInt();
                _local_4.createName = _local_2.readUTF();
                _local_4.groomID = _local_2.readInt();
                _local_4.groomName = _local_2.readUTF();
                _local_4.brideID = _local_2.readInt();
                _local_4.brideName = _local_2.readUTF();
                _local_4.creactTime = _local_2.readDate();
                _local_5 = _local_2.readByte();
                if (_local_5 == 1)
                {
                    _local_4.status = ChurchRoomInfo.WEDDING_NONE;
                }
                else
                {
                    _local_4.status = ChurchRoomInfo.WEDDING_ING;
                };
                _local_4.discription = _local_2.readUTF();
                this._model.updateRoom(_local_4);
            };
        }

        public function createRoom(_arg_1:ChurchRoomInfo):void
        {
            if (ChurchManager.instance.selfRoom)
            {
                SocketManager.Instance.out.sendEnterRoom(0, "");
            };
            SocketManager.Instance.out.sendCreateRoom(_arg_1.roomName, ((_arg_1.password) ? _arg_1.password : ""), _arg_1.mapID, _arg_1.valideTimes, _arg_1.canInvite, _arg_1.discription);
        }

        public function unmarry(_arg_1:Boolean=false):void
        {
            if (ChurchManager.instance._selfRoom)
            {
                if (ChurchManager.instance._selfRoom.status == ChurchRoomInfo.WEDDING_ING)
                {
                    SocketManager.Instance.out.sendUnmarry(true);
                    SocketManager.Instance.out.sendUnmarry(_arg_1);
                    if (((this._model) && (ChurchManager.instance._selfRoom)))
                    {
                        this._model.removeRoom(ChurchManager.instance._selfRoom.id);
                    };
                    dispatchEvent(new Event(UNMARRY));
                    return;
                };
            };
            SocketManager.Instance.out.sendUnmarry(_arg_1);
            if (((this._model) && (ChurchManager.instance._selfRoom)))
            {
                this._model.removeRoom(ChurchManager.instance._selfRoom.id);
            };
            dispatchEvent(new Event(UNMARRY));
        }

        public function changeViewState(_arg_1:String):void
        {
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            super.leaving(_arg_1);
            SocketManager.Instance.out.sendExitMarryRoom();
            MainToolBar.Instance.backFunction = null;
            MainToolBar.Instance.hide();
            this.dispose();
        }

        override public function getBackType():String
        {
            return (StateType.MAIN);
        }

        override public function getType():String
        {
            return (StateType.MAIN);
        }

        override public function dispose():void
        {
            this.removeEvent();
            if (this._model)
            {
                this._model.dispose();
            };
            this._model = null;
            if (this._view)
            {
                if (this._view.parent)
                {
                    this._view.parent.removeChild(this._view);
                };
                this._view.dispose();
            };
            this._view = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package church.controller

