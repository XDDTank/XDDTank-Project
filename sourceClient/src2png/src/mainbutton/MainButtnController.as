// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//mainbutton.MainButtnController

package mainbutton
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.LayerManager;
    import mainbutton.data.MainButtonManager;
    import ddt.manager.PlayerManager;
    import activity.ActivityController;
    import ddt.manager.ServerConfigManager;
    import ddt.data.BuffInfo;
    import __AS3__.vec.*;

    public class MainButtnController extends EventDispatcher 
    {

        private static var _instance:MainButtnController;
        public static var useFirst:Boolean = true;
        public static var loadComplete:Boolean = false;
        public static var ACTIVITIES:String = "1";
        public static var ROULETTE:String = "2";
        public static var VIP:String = "3";
        public static var SIGN:String = "5";
        public static var AWARD:String = "6";
        public static var ANGELBLESS:String = "7";
        public static var FIGHTTOOLBOX:String = "8";
        public static var PACKAGEPURCHAESBOX:String = "9";
        public static var ONLINE_AWEAD:String = "10";
        public static var FIRTST_CHARGE:String = "12";
        public static var WEEKEND:String = "13";
        public static var TURN_PLATE:String = "14";
        public static var FIGHT_ROBOT:String = "15";
        public static var DEAILY_RECEIVE:String = "16";
        public static var DDT_ACTIVITY:String = "ddtactivity";
        public static var DDT_AWARD:String = "ddtaward";
        public static var ICONCLOSE:String = "iconClose";
        public static var CLOSESIGN:String = "closeSign";
        public static var ICONOPEN:String = "iconOpen";

        public var btnList:Vector.<MainButton>;
        private var _currntType:String;
        private var _awardFrame:AwardFrame;
        private var _dailAwardState:Boolean;
        private var _vipAwardState:Boolean;


        public static function get instance():MainButtnController
        {
            if ((!(_instance)))
            {
                _instance = new (MainButtnController)();
            };
            return (_instance);
        }


        public function show(_arg_1:String):void
        {
            this._currntType = _arg_1;
            if (loadComplete)
            {
                this.showFrame(this._currntType);
            }
            else
            {
                if (useFirst)
                {
                    UIModuleSmallLoading.Instance.progress = 0;
                    UIModuleSmallLoading.Instance.show();
                    UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
                    UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__progressShow);
                    UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__complainShow);
                    UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTMAINBTN);
                    useFirst = false;
                };
            };
        }

        private function showFrame(_arg_1:String):void
        {
            switch (_arg_1)
            {
                case MainButtnController.DDT_AWARD:
                    this._awardFrame = ComponentFactory.Instance.creatCustomObject("ddtmainbutton.AwardFrame");
                    LayerManager.Instance.addToLayer(this._awardFrame, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
                    return;
            };
        }

        private function __onClose(_arg_1:Event):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__complainShow);
        }

        private function __progressShow(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDTMAINBTN)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }

        private function __complainShow(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDTMAINBTN)
            {
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__progressShow);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__complainShow);
                UIModuleSmallLoading.Instance.hide();
                loadComplete = true;
                this.showFrame(this._currntType);
            };
        }

        public function set DailyAwardState(_arg_1:Boolean):void
        {
            this._dailAwardState = _arg_1;
        }

        public function get DailyAwardState():Boolean
        {
            return (this._dailAwardState);
        }

        public function set VipAwardState(_arg_1:Boolean):void
        {
            this._vipAwardState = _arg_1;
        }

        public function get VipAwardState():Boolean
        {
            return (this._vipAwardState);
        }

        public function test():Vector.<MainButton>
        {
            this.btnList = new Vector.<MainButton>();
            var _local_1:MainButton = MainButtonManager.instance.getInfoByID(ACTIVITIES);
            var _local_2:MainButton = MainButtonManager.instance.getInfoByID(ROULETTE);
            var _local_3:MainButton = MainButtonManager.instance.getInfoByID(VIP);
            var _local_4:MainButton = MainButtonManager.instance.getInfoByID(SIGN);
            var _local_5:MainButton = MainButtonManager.instance.getInfoByID(AWARD);
            var _local_6:MainButton = MainButtonManager.instance.getInfoByID(ANGELBLESS);
            var _local_7:MainButton = MainButtonManager.instance.getInfoByID(FIGHTTOOLBOX);
            var _local_8:MainButton = MainButtonManager.instance.getInfoByID(PACKAGEPURCHAESBOX);
            var _local_9:MainButton = MainButtonManager.instance.getInfoByID(VIP);
            var _local_10:MainButton = MainButtonManager.instance.getInfoByID(FIRTST_CHARGE);
            var _local_11:MainButton = MainButtonManager.instance.getInfoByID(WEEKEND);
            var _local_12:MainButton = MainButtonManager.instance.getInfoByID(TURN_PLATE);
            var _local_13:MainButton = MainButtonManager.instance.getInfoByID(FIGHT_ROBOT);
            var _local_14:MainButton = MainButtonManager.instance.getInfoByID(DEAILY_RECEIVE);
            if (PlayerManager.Instance.Self.Grade >= 13)
            {
                _local_4.btnMark = 5;
                _local_4.btnServerVisable = 1;
                _local_4.btnCompleteVisable = 1;
                this.btnList.push(_local_4);
            };
            if (ActivityController.instance.checkHasFirstCharge() != null)
            {
                _local_10.btnMark = 12;
                _local_10.btnServerVisable = 1;
                _local_10.btnCompleteVisable = 1;
                this.btnList.push(_local_10);
            };
            if (_local_1.IsShow)
            {
                _local_1.btnMark = 1;
                _local_1.btnServerVisable = 1;
                _local_1.btnCompleteVisable = 1;
                this.btnList.push(_local_1);
            }
            else
            {
                _local_1.btnMark = 1;
                _local_1.btnServerVisable = 2;
                _local_1.btnCompleteVisable = 2;
            };
            if (_local_2.IsShow)
            {
                _local_2.btnMark = 2;
                _local_2.btnServerVisable = 1;
                _local_2.btnCompleteVisable = 1;
                this.btnList.push(_local_2);
            }
            else
            {
                _local_2.btnMark = 2;
                _local_2.btnServerVisable = 2;
                _local_2.btnCompleteVisable = 2;
            };
            if (_local_3.IsShow)
            {
                _local_3.btnMark = 3;
                _local_3.btnServerVisable = 1;
                _local_3.btnCompleteVisable = 1;
                this.btnList.push(_local_3);
            }
            else
            {
                _local_3.btnMark = 3;
                _local_3.btnServerVisable = 2;
                _local_3.btnCompleteVisable = 2;
            };
            if (_local_6.IsShow)
            {
                _local_6.btnMark = 7;
                _local_6.btnServerVisable = 1;
                _local_6.btnCompleteVisable = 1;
                this.btnList.push(_local_6);
            }
            else
            {
                _local_6.btnMark = 7;
                _local_6.btnServerVisable = 2;
                _local_6.btnCompleteVisable = 2;
            };
            if (_local_8.IsShow)
            {
                _local_8.btnMark = 9;
                _local_8.btnServerVisable = 1;
                _local_8.btnCompleteVisable = 1;
                this.btnList.push(_local_8);
            }
            else
            {
                _local_8.btnMark = 9;
                _local_8.btnServerVisable = 2;
                _local_8.btnCompleteVisable = 2;
            };
            if (PlayerManager.Instance.Self.IsVIP)
            {
                if ((((PlayerManager.Instance.Self.canTakeVipReward) || (this._dailAwardState)) && (_local_5.IsShow)))
                {
                    _local_5.btnMark = 6;
                    _local_5.btnServerVisable = 1;
                    _local_5.btnCompleteVisable = 1;
                    this.btnList.push(_local_5);
                }
                else
                {
                    _local_5.btnServerVisable = 2;
                    _local_5.btnCompleteVisable = 2;
                };
            }
            else
            {
                if (((this._dailAwardState) && (_local_5.IsShow)))
                {
                    _local_5.btnMark = 6;
                    _local_5.btnServerVisable = 1;
                    _local_5.btnCompleteVisable = 1;
                    this.btnList.push(_local_5);
                }
                else
                {
                    _local_5.btnServerVisable = 2;
                    _local_5.btnCompleteVisable = 2;
                };
            };
            if (((_local_11.IsShow) && (PlayerManager.Instance.Self.returnEnergy > 0)))
            {
                _local_11.btnMark = 13;
                _local_11.btnServerVisable = 1;
                _local_11.btnCompleteVisable = 1;
                this.btnList.push(_local_11);
            }
            else
            {
                _local_11.btnMark = 13;
                _local_11.btnServerVisable = 2;
                _local_11.btnCompleteVisable = 2;
            };
            if (((_local_12.IsShow) && (PlayerManager.Instance.Self.Grade >= 13)))
            {
                _local_12.btnMark = 14;
                _local_12.btnServerVisable = 1;
                _local_12.btnCompleteVisable = 1;
                this.btnList.push(_local_12);
            }
            else
            {
                _local_12.btnMark = 14;
                _local_12.btnServerVisable = 2;
                _local_12.btnCompleteVisable = 2;
            };
            if (((_local_13.IsShow) && (PlayerManager.Instance.Self.Grade >= ServerConfigManager.instance.getShadowNpcLimit())))
            {
                _local_13.btnMark = 15;
                _local_13.btnServerVisable = 1;
                _local_13.btnCompleteVisable = 1;
                this.btnList.push(_local_13);
            }
            else
            {
                _local_13.btnMark = 14;
                _local_13.btnServerVisable = 2;
                _local_13.btnCompleteVisable = 2;
            };
            if ((!(PlayerManager.Instance.Self.isAward)))
            {
                _local_14.btnMark = 16;
                _local_14.btnServerVisable = 1;
                _local_14.btnCompleteVisable = 1;
                this.btnList.push(_local_14);
            }
            else
            {
                _local_14.btnMark = 16;
                _local_14.btnServerVisable = 2;
                _local_14.btnCompleteVisable = 2;
            };
            var _local_15:BuffInfo = PlayerManager.Instance.Self.buffInfo[BuffInfo.GET_ONLINE_REWARS];
            if (_local_15)
            {
                if (((_local_15.ValidCount == 1) && (PlayerManager.Instance.Self.consortionStatus)))
                {
                    _local_7.btnMark = 11;
                    _local_7.btnServerVisable = 1;
                    _local_7.btnCompleteVisable = 1;
                    this.btnList.push(_local_7);
                };
            };
            return (this.btnList);
        }


    }
}//package mainbutton

