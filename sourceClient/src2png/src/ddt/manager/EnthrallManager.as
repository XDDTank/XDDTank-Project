// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.EnthrallManager

package ddt.manager
{
    import ddt.view.enthrall.EnthrallView;
    import ddt.view.enthrall.ValidateFrame;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.events.TimeEvents;
    import com.pickgliss.manager.CacheSysManager;
    import ddt.constants.CacheConsts;
    import com.pickgliss.action.FunctionAction;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.states.StateType;
    import ddt.events.CrazyTankSocketEvent;
    import road7th.comm.PackageIn;
    import com.pickgliss.ui.LayerManager;
    import ddt.view.enthrall.Validate17173;

    public class EnthrallManager 
    {

        private static var _instance:EnthrallManager;
        public static var STATE_1:int = 60;
        public static var STATE_2:int = 120;
        public static var STATE_3:int = 175;
        public static var STATE_4:int = 180;

        private var _view:EnthrallView;
        private var _loadedTime:int = 0;
        private var _showEnthrallLight:Boolean = false;
        private var _popCIDChecker:Boolean = false;
        private var _enthrallSwicth:Boolean;
        private var _hasApproved:Boolean;
        private var _isMinor:Boolean;
        private var _interfaceID:int;
        private var validateFrame:ValidateFrame;
        private var inited:Boolean;
        private var initValid:Boolean;

        public function EnthrallManager(_arg_1:SingletonEnfocer)
        {
            this.inited = false;
        }

        public static function getInstance():EnthrallManager
        {
            if (_instance == null)
            {
                _instance = new EnthrallManager(new SingletonEnfocer());
            };
            return (_instance);
        }


        private function init():void
        {
            this.inited = true;
            this._view = ComponentFactory.Instance.creat("EnthrallViewSprite");
            this._view.manager = this;
            TimeManager.addEventListener(TimeEvents.MINUTES, this.__timerHandler);
            TimeManager.addEventListener(TimeEvents.SECONDS, this.__timer1Handler);
        }

        private function __timerHandler(_arg_1:TimeEvents):void
        {
            this._loadedTime++;
            TimeManager.Instance.enthrallTime = (TimeManager.Instance.enthrallTime + 1);
            if ((!(this._hasApproved)))
            {
                this.checkState();
            }
            else
            {
                if (((this._hasApproved) && (this._isMinor)))
                {
                    this.checkState();
                };
            };
        }

        private function checkState():void
        {
            var state:int;
            if ((!(StateManager.isInFight)))
            {
                if (((((TimeManager.Instance.enthrallTime == STATE_1) || (TimeManager.Instance.enthrallTime == STATE_2)) || (TimeManager.Instance.enthrallTime == STATE_3)) || (TimeManager.Instance.enthrallTime == STATE_4)))
                {
                    state = TimeManager.Instance.enthrallTime;
                    this.showantiAddictionFrame(state);
                };
            }
            else
            {
                if (((((TimeManager.Instance.enthrallTime == STATE_1) || (TimeManager.Instance.enthrallTime == STATE_2)) || (TimeManager.Instance.enthrallTime == STATE_3)) || (TimeManager.Instance.enthrallTime == STATE_4)))
                {
                    state = TimeManager.Instance.enthrallTime;
                    CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_FIGHT, new FunctionAction(function ():void
                    {
                        showantiAddictionFrame(state);
                    }));
                };
            };
        }

        private function showantiAddictionFrame(_arg_1:int):void
        {
            var _local_2:BaseAlerFrame;
            var _local_3:AlertInfo;
            var _local_4:AlertInfo;
            var _local_5:AlertInfo;
            var _local_6:AlertInfo;
            if (_arg_1 == STATE_1)
            {
                _local_3 = new AlertInfo();
                _local_3.title = LanguageMgr.GetTranslation("AlertDialog.Info");
                _local_3.buttonGape = 20;
                _local_3.showCancel = false;
                _local_3.submitLabel = LanguageMgr.GetTranslation("ok");
                _local_3.data = LanguageMgr.GetTranslation("tank.manager.enthrallRemind1");
                _local_2 = AlertManager.Instance.alert("SimpleAlert", _local_3);
                _local_2.addEventListener(FrameEvent.RESPONSE, this.__antiAddictionFrame);
            };
            if (_arg_1 == STATE_2)
            {
                _local_4 = new AlertInfo();
                _local_4.title = LanguageMgr.GetTranslation("AlertDialog.Info");
                _local_4.buttonGape = 20;
                _local_4.showCancel = false;
                _local_4.submitLabel = LanguageMgr.GetTranslation("ok");
                _local_4.data = LanguageMgr.GetTranslation("tank.manager.enthrallRemind2");
                _local_2 = AlertManager.Instance.alert("SimpleAlert", _local_4);
                _local_2.addEventListener(FrameEvent.RESPONSE, this.__antiAddictionFrame);
            };
            if (_arg_1 == STATE_3)
            {
                _local_5 = new AlertInfo();
                _local_5.title = LanguageMgr.GetTranslation("AlertDialog.Info");
                _local_5.buttonGape = 20;
                _local_5.showCancel = false;
                _local_5.submitLabel = LanguageMgr.GetTranslation("ok");
                _local_5.data = LanguageMgr.GetTranslation("tank.manager.enthrallRemind3");
                _local_2 = AlertManager.Instance.alert("SimpleAlert", _local_5);
                _local_2.addEventListener(FrameEvent.RESPONSE, this.__antiAddictionFrame);
            };
            if (_arg_1 == STATE_4)
            {
                _local_6 = new AlertInfo();
                _local_6.title = LanguageMgr.GetTranslation("AlertDialog.Info");
                _local_6.buttonGape = 20;
                _local_6.showCancel = false;
                _local_6.submitLabel = LanguageMgr.GetTranslation("ok");
                _local_6.data = LanguageMgr.GetTranslation("tank.manager.enthrallRemind4");
                _local_2 = AlertManager.Instance.alert("SimpleAlert", _local_6);
                _local_2.addEventListener(FrameEvent.RESPONSE, this.__antiAddictionFrame);
            };
        }

        private function __antiAddictionFrame(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.CLOSE_CLICK)))
            {
                _local_2.dispose();
            };
        }

        public function updateLight():void
        {
            this._view.update();
        }

        private function __timer1Handler(_arg_1:TimeEvents):void
        {
            if ((!(this._popCIDChecker)))
            {
                return;
            };
            if (StateManager.currentStateType == StateType.MAIN)
            {
                TimeManager.removeEventListener(TimeEvents.SECONDS, this.__timer1Handler);
            };
        }

        public function setup():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CID_CHECK, this.changeCIDChecker);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ENTHRALL_LIGHT, this.readStates);
        }

        private function get isSpecifiedDate():Boolean
        {
            var _local_1:Number = 9;
            var _local_2:Number = (TimeManager.Instance.Now().month + 1);
            var _local_3:Number = TimeManager.Instance.Now().date;
            if ((((_local_2 == _local_1) || (_local_2 == 10)) && (((((_local_3 == 8) || (_local_3 == 9)) || (_local_3 == 10)) || (_local_3 == 29)) || (_local_3 == 30))))
            {
                return (true);
            };
            return (false);
        }

        private function changeCIDChecker(_arg_1:CrazyTankSocketEvent):void
        {
            if ((!(this.inited)))
            {
                this.init();
            };
            var _local_2:PackageIn = _arg_1.pkg;
            this._popCIDChecker = _local_2.readBoolean();
            if (this._popCIDChecker)
            {
                TimeManager.addEventListener(TimeEvents.SECONDS, this.__timer1Handler);
            }
            else
            {
                this.closeCIDCheckerFrame();
            };
        }

        private function readStates(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            this._enthrallSwicth = _local_2.readBoolean();
            this._interfaceID = _local_2.readInt();
            this._hasApproved = _local_2.readBoolean();
            this._isMinor = _local_2.readBoolean();
            this.updateEnthrallView();
        }

        public function updateEnthrallView():void
        {
            if ((!(this._enthrallSwicth)))
            {
                this.hideEnthrallLight();
                return;
            };
            if ((!(this.inited)))
            {
                this.init();
            };
            if (((this._enthrallSwicth) && (StateManager.currentStateType == StateType.MAIN)))
            {
                if (this._hasApproved)
                {
                    if ((!(this._isMinor)))
                    {
                        this.hideEnthrallLight();
                    }
                    else
                    {
                        this.showEnthrallLight();
                    };
                }
                else
                {
                    if ((!(this.initValid)))
                    {
                        this.showCIDCheckerFrame();
                    };
                    this.showEnthrallLight();
                };
            }
            else
            {
                this.hideEnthrallLight();
            };
            this._view.changeBtn(false);
            this._view.changeToGameState(false);
            this._view.changeBtn(false);
            switch (StateManager.currentStateType)
            {
                case StateType.MAIN:
                    this._view.changeBtn((!(this._hasApproved)));
                    return;
                case StateType.TRAINER1:
                case StateType.TRAINER2:
                    this._view.changeToGameState(true);
                    return;
            };
        }

        private function closeCIDCheckerFrame():void
        {
            this.validateFrame.hide();
        }

        public function showCIDCheckerFrame():void
        {
            if (this.interfaceID != 0)
            {
                LayerManager.Instance.addToLayer((ComponentFactory.Instance.creat("EnthrallValidateFrame17173") as Validate17173), LayerManager.GAME_DYNAMIC_LAYER, true, 0, false);
                return;
            };
            if (((!(this.validateFrame)) || (!(this.validateFrame.parent))))
            {
                this.initValid = true;
                this.validateFrame = ComponentFactory.Instance.creat("EnthrallValidateFrame");
            };
            LayerManager.Instance.addToLayer(this.validateFrame, LayerManager.GAME_DYNAMIC_LAYER, true, 1, false);
        }

        public function showEnthrallLight():void
        {
            LayerManager.Instance.addToLayer(this._view, LayerManager.GAME_DYNAMIC_LAYER, false, 0, false);
            this.updateLight();
        }

        public function hideEnthrallLight():void
        {
            if (((this._view) && (this._view.parent)))
            {
                this._view.parent.removeChild(this._view);
            };
        }

        public function gameState(_arg_1:Number):void
        {
            this._view.x = (_arg_1 - 100);
            this._view.y = 15;
        }

        public function outGame():void
        {
            this._view.x = 110;
            this._view.y = 5;
        }

        public function get enthrallSwicth():Boolean
        {
            return (this._enthrallSwicth);
        }

        public function get isEnthrall():Boolean
        {
            return ((this.enthrallSwicth) && ((!(this._hasApproved)) || (this._isMinor)));
        }

        public function get interfaceID():int
        {
            if ((!(this._interfaceID)))
            {
                return (0);
            };
            return (this._interfaceID);
        }


    }
}//package ddt.manager

class SingletonEnfocer 
{


}


