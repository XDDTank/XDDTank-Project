// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.transportSence.TransportManager

package consortion.transportSence
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import flash.geom.Point;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import road7th.comm.PackageIn;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import com.pickgliss.loader.LoaderEvent;
    import consortion.ConsortionModelControl;
    import ddt.data.player.ConsortiaPlayerInfo;
    import ddt.manager.PlayerManager;
    import consortion.ConsortionModel;
    import consortion.event.ConsortionEvent;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import __AS3__.vec.*;

    public class TransportManager extends EventDispatcher 
    {

        private static var _instance:TransportManager;
        private static const MAX_MESSAGE:uint = 50;

        private var _transportProposeFrame:TransportProposeFrame;
        private var _hijackProposeFrame:TransportHijackProposeFrame;
        private var _transportModel:TransportModel;
        private var _completeCount:uint = 0;
        private var _messageList:Vector.<TransportInfoContent>;
        public var currentCar:TransportCar;
        public var fightEndBack:Boolean;
        public var SelfPoint:Point;


        public static function get Instance():TransportManager
        {
            if ((!(TransportManager._instance)))
            {
                TransportManager._instance = new (TransportManager)();
            };
            return (TransportManager._instance);
        }


        public function setup():void
        {
            this._messageList = new Vector.<TransportInfoContent>();
            this._transportModel = new TransportModel();
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ENTER_TRNSPORT, this.__init);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_MEMBER_INFO, this.__updateMemberInfo);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_CAR_INFO, this.__updateCarInfo);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.INVITE_CONVOY, this.__showPropose);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GEGIN_CONVOY, this.__beginConvoy);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HIJACK_CAR, this.__carIsHijacked);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_CAR, this.__buyCarResult);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HIJACK_INFO_MESSAGE, this.__receiveHijackMessage);
        }

        private function __init(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_6:int;
            var _local_7:TransportCar;
            var _local_8:int;
            var _local_9:uint;
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:Boolean = _local_2.readBoolean();
            var _local_4:int = _local_2.readInt();
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                _local_6 = _local_2.readByte();
                _local_7 = new TransportCar(_local_6);
                _local_7.info.consortionId = _local_2.readInt();
                _local_7.info.consortionName = _local_2.readUTF();
                _local_7.info.ownerId = _local_2.readInt();
                _local_7.info.ownerName = _local_2.readUTF();
                _local_7.info.guarderId = _local_2.readInt();
                _local_7.info.guarderName = _local_2.readUTF();
                _local_7.info.hijackTimes = _local_2.readByte();
                _local_7.info.startDate = _local_2.readDate();
                _local_7.info.truckState = _local_2.readByte();
                _local_7.info.ownerLevel = _local_2.readByte();
                _local_7.speed = _local_2.readFloat();
                _local_7.info.lastHijackDate = _local_2.readDate();
                _local_8 = _local_2.readByte();
                if (_local_8 > 0)
                {
                    _local_7.info.hijackerIdList = new Vector.<int>();
                    _local_9 = 0;
                    while (_local_9 < _local_8)
                    {
                        _local_7.info.hijackerIdList.push(_local_2.readInt());
                        _local_9++;
                    };
                };
                _local_7.info.speed = _local_7.speed;
                this._transportModel.addObjects(_local_7);
                _local_5++;
            };
            this.SelfPoint = new Point(274, 615);
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onChatBallComplete);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CHAT_BALL);
        }

        private function __onLoadingClose(_arg_1:Event=null):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onLoadingClose);
        }

        private function __uiProgress(_arg_1:LoaderEvent):void
        {
            UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
        }

        private function __updateMemberInfo(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:int = _local_2.readInt();
            var _local_4:ConsortiaPlayerInfo = ConsortionModelControl.Instance.model.getConsortiaMemberInfo(_local_3);
            if (_local_4)
            {
                _local_4.ConvoyTimes = _local_2.readByte();
                _local_4.GuardTimes = _local_2.readByte();
                _local_4.HijackTimes = _local_2.readByte();
                _local_4.MaxHijackTimes = _local_2.readByte();
                _local_4.MaxConvoyTimes = _local_2.readByte();
                _local_4.MaxGuardTimes = _local_2.readByte();
                _local_4.GuardTruckId = _local_2.readInt();
                ConsortionModelControl.Instance.model.updataMember(_local_4);
                if (_local_4.ID == PlayerManager.Instance.Self.ID)
                {
                    ConsortionModel.REMAIN_CONVOY_TIME = (_local_4.MaxConvoyTimes - _local_4.ConvoyTimes);
                    ConsortionModel.REMAIN_GUARD_TIME = (_local_4.MaxGuardTimes - _local_4.GuardTimes);
                    ConsortionModel.REMAIN_HIJACK_TIME = (_local_4.MaxHijackTimes - _local_4.HijackTimes);
                    dispatchEvent(new ConsortionEvent(ConsortionEvent.UPDATE_MY_INFO));
                };
            };
        }

        private function __updateCarInfo(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_7:uint;
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:int = _local_2.readByte();
            var _local_4:TransportCarInfo = new TransportCarInfo(_local_3);
            _local_4.consortionId = _local_2.readInt();
            _local_4.consortionName = _local_2.readUTF();
            _local_4.ownerId = _local_2.readInt();
            _local_4.ownerName = _local_2.readUTF();
            _local_4.guarderId = _local_2.readInt();
            _local_4.guarderName = _local_2.readUTF();
            _local_4.hijackTimes = _local_2.readByte();
            _local_4.startDate = _local_2.readDate();
            _local_4.truckState = _local_2.readByte();
            _local_4.ownerLevel = _local_2.readByte();
            _local_4.speed = _local_2.readFloat();
            _local_4.lastHijackDate = _local_2.readDate();
            var _local_5:int = _local_2.readByte();
            if (_local_5 > 0)
            {
                _local_4.hijackerIdList = new Vector.<int>();
                _local_7 = 0;
                while (_local_7 < _local_5)
                {
                    _local_4.hijackerIdList.push(_local_2.readInt());
                    _local_7++;
                };
            };
            var _local_6:TransportCar = this._transportModel.getObjects()[_local_4.ownerId];
            if (_local_4.truckState != TransportCarInfo.ISREACHED)
            {
                if (_local_4.truckState == TransportCarInfo.ISREADY)
                {
                    if (_local_4.guarderId == 0)
                    {
                        dispatchEvent(new ConsortionEvent(ConsortionEvent.GUARDER_IS_LEAVING));
                    };
                }
                else
                {
                    if (_local_6)
                    {
                        _local_4.speed = _local_6.speed;
                        _local_4.nickName = _local_6.nickName;
                        _local_6.info = _local_4;
                    }
                    else
                    {
                        _local_6 = new TransportCar(_local_3);
                        _local_6.speed = _local_4.speed;
                        _local_6.info = _local_4;
                        this._transportModel.addObjects(_local_6);
                        dispatchEvent(new ConsortionEvent(ConsortionEvent.TRANSPORT_ADD_CAR, _local_6));
                    };
                };
            }
            else
            {
                dispatchEvent(new ConsortionEvent(ConsortionEvent.TRANSPORT_REMOVE_CAR, _local_6));
                if (((_local_4.ownerId == PlayerManager.Instance.Self.ID) || (_local_4.guarderId == PlayerManager.Instance.Self.ID)))
                {
                    if (ConsortionModel.REMAIN_CONVOY_TIME > 0)
                    {
                        dispatchEvent(new ConsortionEvent(ConsortionEvent.ENABLE_SENDCAR_BTN));
                    };
                };
            };
        }

        private function __carIsHijacked(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:int = _local_2.readInt();
            var _local_4:int = _local_2.readInt();
            var _local_5:String = _local_2.readUTF();
            var _local_6:int = _local_2.readByte();
            if (((StateManager.currentStateType == StateType.MAIN) || (StateManager.currentStateType == StateType.CONSORTION_TRANSPORT)))
            {
                if (this._hijackProposeFrame)
                {
                    if (this._hijackProposeFrame.isShowing)
                    {
                        return;
                    };
                };
                this._hijackProposeFrame = ComponentFactory.Instance.creat("transportSence.TransportHijackProposeFrame");
                this._hijackProposeFrame.setIdAndName(_local_3, _local_6, _local_4, _local_5);
                this._hijackProposeFrame.addEventListener(Event.CLOSE, this.__transportProposeFrameClose);
                this._hijackProposeFrame.show();
            }
            else
            {
                SocketManager.Instance.out.SendHijackAnswer(_local_3, _local_4, _local_5, false);
            };
        }

        private function __beginConvoy(_arg_1:CrazyTankSocketEvent):void
        {
            dispatchEvent(new ConsortionEvent(ConsortionEvent.TRANSPORT_CAR_BEGIN_CONVOY));
        }

        private function __receiveHijackMessage(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_9:TransportInfoContent;
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:String = _local_2.readUTF();
            var _local_4:String = _local_2.readUTF();
            var _local_5:int = _local_2.readInt();
            var _local_6:int = _local_2.readInt();
            var _local_7:TransportInfoContent = new TransportInfoContent(_local_3, _local_4, _local_5, _local_6);
            if (this._messageList.length >= MAX_MESSAGE)
            {
                _local_9 = this._messageList.shift();
                _local_9.dispose2();
            };
            var _local_8:String = PlayerManager.Instance.Self.NickName;
            if (((_local_3 == _local_8) || (_local_4 == _local_8)))
            {
                _local_7.isMyInfo = true;
            };
            this._messageList.push(_local_7);
            dispatchEvent(new ConsortionEvent(ConsortionEvent.TRANSPORT_ADD_MESSAGE, _local_7));
        }

        private function __buyCarResult(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_4:int;
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:Boolean = _local_2.readBoolean();
            if (_local_3)
            {
                _local_4 = _local_2.readByte();
                if (_local_4 == TransportCar.CARII)
                {
                    dispatchEvent(new ConsortionEvent(ConsortionEvent.BUY_HIGH_LEVEL_CAR));
                };
            };
        }

        private function __onChatBallComplete(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.CHAT_BALL)
            {
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onChatBallComplete);
                this.loadResFile(this.loadResComplete, PathManager.solveConsortionWalkSceneMapPath("map6"), BaseLoader.MODULE_LOADER);
                this.loadResFile(this.loadLivingComplete, PathManager.solveGameLivingPath("Living239"), BaseLoader.MODULE_LOADER);
                this.loadResFile(this.loadLivingComplete, PathManager.solveGameLivingPath("Living240"), BaseLoader.MODULE_LOADER);
            };
        }

        private function loadResFile(_arg_1:Function, _arg_2:String, _arg_3:int):void
        {
            var _local_4:BaseLoader;
            _local_4 = LoadResourceManager.instance.createLoader(_arg_2, _arg_3);
            _local_4.addEventListener(LoaderEvent.COMPLETE, _arg_1);
            _local_4.addEventListener(LoaderEvent.PROGRESS, this.__uiProgress);
            LoadResourceManager.instance.startLoad(_local_4);
        }

        private function loadLivingComplete(_arg_1:LoaderEvent):void
        {
        }

        private function loadResComplete(_arg_1:LoaderEvent):void
        {
            this.__onLoadingClose();
            StateManager.setState(StateType.CONSORTION_TRANSPORT);
        }

        private function __showPropose(_arg_1:CrazyTankSocketEvent=null):void
        {
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:int = _local_2.readInt();
            var _local_4:String = _local_2.readUTF();
            if (((StateManager.currentStateType == StateType.MAIN) || (StateManager.currentStateType == StateType.CONSORTION_TRANSPORT)))
            {
                if (this._transportProposeFrame)
                {
                    if (this._transportProposeFrame.isShowing)
                    {
                        return;
                    };
                };
                this._transportProposeFrame = ComponentFactory.Instance.creat("transportSence.TransportProposeFrame");
                this._transportProposeFrame.setIdAndName(_local_3, _local_4);
                this._transportProposeFrame.addEventListener(Event.CLOSE, this.__transportProposeFrameClose);
                this._transportProposeFrame.show();
            }
            else
            {
                SocketManager.Instance.out.SendInviteAnswer(_local_3, _local_4, false);
            };
        }

        private function __transportProposeFrameClose(_arg_1:Event):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            if (_local_2)
            {
                _local_2.removeEventListener(Event.CLOSE, this.__transportProposeFrameClose);
                _local_2.dispose();
            };
            _local_2 = null;
        }

        public function get transportModel():TransportModel
        {
            return (this._transportModel);
        }

        public function get messageList():Vector.<TransportInfoContent>
        {
            return (this._messageList);
        }


    }
}//package consortion.transportSence

