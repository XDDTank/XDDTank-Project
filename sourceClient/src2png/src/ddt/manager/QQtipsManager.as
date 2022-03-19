// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.QQtipsManager

package ddt.manager
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import ddt.view.qqTips.QQTipsInfo;
    import flash.events.IEventDispatcher;
    import ddt.events.CrazyTankSocketEvent;
    import flash.events.KeyboardEvent;
    import road7th.comm.PackageIn;
    import flash.events.Event;
    import ddt.states.StateType;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.view.qqTips.QQTipsView;
    import __AS3__.vec.*;

    public class QQtipsManager extends EventDispatcher 
    {

        private static var _instance:QQtipsManager;
        public static const COLSE_QQ_TIPSVIEW:String = "Close_QQ_tipsView";

        private var _qqInfoList:Vector.<QQTipsInfo>;
        private var _isShowTipNow:Boolean;
        public var isGotoShop:Boolean = false;
        public var indexCurrentShop:int;

        public function QQtipsManager(_arg_1:IEventDispatcher=null)
        {
            super(_arg_1);
        }

        public static function get instance():QQtipsManager
        {
            if (_instance == null)
            {
                _instance = new (QQtipsManager)();
            };
            return (_instance);
        }


        public function setup():void
        {
            this._qqInfoList = new Vector.<QQTipsInfo>();
            this.initEvents();
        }

        private function initEvents():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QQTIPS_GET_INFO, this.__getInfo);
        }

        private function __keyDown(_arg_1:KeyboardEvent):void
        {
        }

        private function __getInfo(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:QQTipsInfo = new QQTipsInfo();
            _local_3.title = _local_2.readUTF();
            _local_3.content = _local_2.readUTF();
            _local_3.maxLevel = _local_2.readInt();
            _local_3.minLevel = _local_2.readInt();
            _local_3.outInType = _local_2.readInt();
            if (_local_3.outInType == 0)
            {
                _local_3.moduleType = _local_2.readInt();
                _local_3.inItemID = _local_2.readInt();
            }
            else
            {
                _local_3.url = _local_2.readUTF();
            };
            if (((_local_3.minLevel <= PlayerManager.Instance.Self.Grade) && (PlayerManager.Instance.Self.Grade <= _local_3.maxLevel)))
            {
                if (this._qqInfoList.length > 0)
                {
                    this._qqInfoList.splice(0, this._qqInfoList.length);
                };
                this._qqInfoList.push(_local_3);
            };
            this.checkState();
        }

        public function checkState():void
        {
            if (((this._qqInfoList.length > 0) && (this.getStateAble(StateManager.currentStateType))))
            {
                if (this.isShowTipNow)
                {
                    dispatchEvent(new Event(COLSE_QQ_TIPSVIEW));
                };
                this.__showQQTips();
            };
        }

        public function checkStateView(_arg_1:String):void
        {
            if (((this._qqInfoList.length > 0) && (this.getStateAble(_arg_1))))
            {
                this.__showQQTips();
            };
        }

        private function getStateAble(_arg_1:String):Boolean
        {
            if ((((((((((((_arg_1 == StateType.MAIN) || (_arg_1 == StateType.AUCTION)) || (_arg_1 == StateType.DDTCHURCH_ROOM_LIST)) || (_arg_1 == StateType.ROOM_LIST)) || (_arg_1 == StateType.CONSORTIA)) || (_arg_1 == StateType.DUNGEON_LIST)) || (_arg_1 == StateType.HOT_SPRING_ROOM_LIST)) || (_arg_1 == StateType.FIGHT_LIB)) || (_arg_1 == StateType.ACADEMY_REGISTRATION)) || (_arg_1 == StateType.CIVIL)) || (_arg_1 == StateType.TOFFLIST)))
            {
                return (true);
            };
            return (false);
        }

        private function __showQQTips():void
        {
            var _local_1:QQTipsView = ComponentFactory.Instance.creatCustomObject("coreIconQQ.QQTipsView");
            _local_1.qqInfo = this._qqInfoList.shift();
            _local_1.show();
            this.isShowTipNow = true;
        }

        public function set isShowTipNow(_arg_1:Boolean):void
        {
            this._isShowTipNow = _arg_1;
        }

        public function get isShowTipNow():Boolean
        {
            return (this._isShowTipNow);
        }

        public function gotoShop(_arg_1:int):void
        {
            if (_arg_1 > 3)
            {
                return;
            };
            this.isGotoShop = true;
            this.indexCurrentShop = _arg_1;
            StateManager.setState(StateType.SHOP);
        }


    }
}//package ddt.manager

