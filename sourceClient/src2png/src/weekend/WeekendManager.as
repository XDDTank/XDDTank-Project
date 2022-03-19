// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//weekend.WeekendManager

package weekend
{
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.manager.PlayerManager;
    import ddt.manager.ServerConfigManager;
    import com.pickgliss.utils.ObjectUtils;
    import road7th.comm.PackageIn;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import ddt.data.UIModuleTypes;
    import com.pickgliss.events.UIModuleEvent;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.LayerManager;

    public class WeekendManager 
    {

        private static var _instance:WeekendManager;

        private var _frame:WeekendFrame;
        private var _loadComplete:Boolean;

        public function WeekendManager()
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ENERGY_RETURN, this.__returnEnergy);
        }

        public static function get instance():WeekendManager
        {
            if ((!(_instance)))
            {
                _instance = new (WeekendManager)();
            };
            return (_instance);
        }


        public function setup():void
        {
        }

        public function getNormalEnergy():int
        {
            var _local_1:Number = (PlayerManager.Instance.Self.returnEnergy * this.getNormalPercent());
            _local_1 = Math.max(_local_1, 1);
            return (int(_local_1));
        }

        public function getMoneyEnergy():int
        {
            var _local_1:Number = ((PlayerManager.Instance.Self.returnEnergy * this.getNormalPercent()) * this.getMoneyPercent());
            _local_1 = Math.max(_local_1, 1);
            return (int(_local_1));
        }

        public function getNormalPercent():Number
        {
            var _local_1:String = ServerConfigManager.instance.getReturnEnergyInfo();
            var _local_2:Array = _local_1.split("|");
            return (Number(_local_2[0]) / 100);
        }

        public function getMoneyPercent():Number
        {
            var _local_1:String = ServerConfigManager.instance.getReturnEnergyInfo();
            var _local_2:Array = _local_1.split("|");
            return (Number(_local_2[1]) / 100);
        }

        public function getNeedMoney():Number
        {
            var _local_1:String = ServerConfigManager.instance.getReturnEnergyInfo();
            var _local_2:Array = _local_1.split("|");
            return (Number(_local_2[2]) / 100);
        }

        public function sendSocket(_arg_1:Boolean):void
        {
            SocketManager.Instance.out.sendReturnEnergyRequest(_arg_1);
        }

        public function show():void
        {
            if (this._loadComplete)
            {
                this.initFrame();
            }
            else
            {
                this.load();
            };
        }

        public function hide():void
        {
            ObjectUtils.disposeObject(this._frame);
            this._frame;
        }

        private function __returnEnergy(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            PlayerManager.Instance.Self.returnEnergy = _local_2.readInt();
        }

        private function load():void
        {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.WEEKEND);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__loadComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__activeProgress);
        }

        private function __loadComplete(_arg_1:UIModuleEvent):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__loadComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__activeProgress);
            this._loadComplete = true;
            this.initFrame();
        }

        private function __onClose(_arg_1:Event):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__loadComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__activeProgress);
        }

        private function __activeProgress(_arg_1:UIModuleEvent):void
        {
            UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
        }

        private function initFrame():void
        {
            this._frame = ComponentFactory.Instance.creatCustomObject("weekend.WeekendFrame");
            LayerManager.Instance.addToLayer(this._frame, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }


    }
}//package weekend

