// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//fightToolBox.FightToolBoxController

package fightToolBox
{
    import fightToolBox.view.FightToolBoxFrame;
    import fightToolBox.view.FightToolBoxRechargeAlert;
    import ddt.manager.ServerConfigManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.SocketManager;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import ddt.data.player.SelfInfo;
    import ddt.manager.TimeManager;
    import com.pickgliss.ui.ComponentFactory;

    public class FightToolBoxController 
    {

        private static var _instance:FightToolBoxController;

        private var _model:FightToolBoxModel;
        private var _useFirst:Boolean = true;
        private var _loadComplete:Boolean = false;
        private var _loadRecharge:Boolean = false;
        private var _frame:FightToolBoxFrame;
        private var _rechargeAlert:FightToolBoxRechargeAlert;
        private var _hasShow:Boolean = false;

        public function FightToolBoxController()
        {
            this._model = new FightToolBoxModel();
            this._model.fightVipTime_low = ServerConfigManager.instance.fightVipTime;
            this._model.fightVipPrice_low = ServerConfigManager.instance.fightVipPrices;
            this._model.guideDamageRatio_0 = ServerConfigManager.instance.fightVipGuideDamageRatio;
            this._model.powerDamageRatio = ServerConfigManager.instance.fightVipPowerDamageRatio;
            this._model.powerDamageIncrease = ServerConfigManager.instance.fightVipPowerDamageIncrease;
            this._model.headShotDamageRatio = ServerConfigManager.instance.fightVipheadShotDamageRatio;
            this._model.guideDamageIncrease = ServerConfigManager.instance.fightVipGuideDamageIncrease;
        }

        public static function get instance():FightToolBoxController
        {
            if ((!(_instance)))
            {
                _instance = new (FightToolBoxController)();
            };
            return (_instance);
        }


        private function addEvent():void
        {
            PlayerManager.Instance.addEventListener(PlayerManager.UPDATE_FIGHT_VIP, this.__updateFrame);
        }

        public function get model():FightToolBoxModel
        {
            return (this._model);
        }

        public function sendOpen(_arg_1:String, _arg_2:int):void
        {
            SocketManager.Instance.out.sendfightVip(1, _arg_1, _arg_2);
        }

        public function show():void
        {
            if (this._loadComplete)
            {
                this.showFrame();
            }
            else
            {
                if (this._useFirst)
                {
                    UIModuleSmallLoading.Instance.progress = 0;
                    UIModuleSmallLoading.Instance.show();
                    UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
                    UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__progressShow);
                    UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__complainShow);
                    UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.FIGHT_TOOL_BOX);
                };
            };
        }

        public function showRechargeAlert():void
        {
            var _local_1:SelfInfo = PlayerManager.Instance.Self;
            var _local_2:Date = new Date((_local_1.fightVipStartTime.getTime() + ((_local_1.fightVipValidDate * 60) * 1000)));
            var _local_3:Date = TimeManager.Instance.Now();
            var _local_4:int = int(Math.ceil((((((_local_2.getTime() - _local_3.getTime()) / 1000) / 60) / 60) / 24)));
            if ((((_local_1.isFightVip) && (_local_4 <= 1)) && (!(this._hasShow))))
            {
                if (_local_2.getTime() > _local_1.LastDate.getTime())
                {
                    if (_local_1.isSameDay)
                    {
                        return;
                    };
                };
                if (this._loadComplete)
                {
                    this._rechargeAlert = new FightToolBoxRechargeAlert();
                    this._rechargeAlert.show();
                    this._hasShow = true;
                }
                else
                {
                    if (this._useFirst)
                    {
                        this._loadRecharge = true;
                        UIModuleSmallLoading.Instance.progress = 0;
                        UIModuleSmallLoading.Instance.show();
                        UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
                        UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__progressShow);
                        UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__complainShow);
                        UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.FIGHT_TOOL_BOX);
                    };
                };
            };
        }

        private function showFrame():void
        {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("FightToolBoxFrame");
            this._frame.show();
            this.addEvent();
        }

        public function hide():void
        {
            PlayerManager.Instance.removeEventListener(PlayerManager.UPDATE_FIGHT_VIP, this.__updateFrame);
            if (this._frame != null)
            {
                this._frame.dispose();
            };
            this._frame = null;
        }

        private function __progressShow(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.FIGHT_TOOL_BOX)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }

        private function __onClose(_arg_1:Event):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__complainShow);
        }

        private function __complainShow(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.FIGHT_TOOL_BOX)
            {
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__progressShow);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__complainShow);
                UIModuleSmallLoading.Instance.hide();
                this._loadComplete = true;
                this._useFirst = false;
                if (this._loadRecharge)
                {
                    this.showRechargeAlert();
                    this._loadRecharge = false;
                }
                else
                {
                    this.show();
                };
            };
        }

        private function __updateFrame(_arg_1:Event):void
        {
            this._frame.update();
        }


    }
}//package fightToolBox

