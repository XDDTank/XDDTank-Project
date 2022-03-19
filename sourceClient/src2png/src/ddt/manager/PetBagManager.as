// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.PetBagManager

package ddt.manager
{
    import flash.events.EventDispatcher;
    import petsBag.data.PetBagModel;
    import petsBag.view.PetInfoFrame;
    import flash.utils.Timer;
    import ddt.events.PlayerPropertyEvent;
    import flash.events.TimerEvent;
    import pet.date.PetInfo;
    import ddt.data.player.SelfInfo;
    import road7th.data.DictionaryData;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import ddt.data.UIModuleTypes;
    import com.pickgliss.events.UIModuleEvent;

    public class PetBagManager extends EventDispatcher 
    {

        private static var _instance:PetBagManager;

        private var _isloading:Boolean;
        public var petModel:PetBagModel;
        private var _petInfoFrame:PetInfoFrame;
        private var _petIndex:int;
        private var _popuMsg:Array = [];
        private var _timer:Timer;
        private var _openSpace:Boolean;


        public static function instance():PetBagManager
        {
            if ((!(_instance)))
            {
                _instance = new (PetBagManager)();
            };
            return (_instance);
        }


        public function setup():void
        {
            this.petModel = new PetBagModel();
            this.petModel.selfInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__playerChange);
        }

        public function pushMsg(_arg_1:String):void
        {
            this._popuMsg.push(_arg_1);
            if ((!(this._timer)))
            {
                this._timer = new Timer(2000);
                this._timer.addEventListener(TimerEvent.TIMER, this.__popu);
                this._timer.start();
            };
        }

        private function __popu(_arg_1:TimerEvent):void
        {
            var _local_2:String = "";
            if (this._popuMsg.length > 0)
            {
                _local_2 = this._popuMsg.shift();
                MessageTipManager.getInstance().show(_local_2);
                ChatManager.Instance.sysChatYellow(_local_2);
            }
            else
            {
                this._timer.stop();
                this._timer.removeEventListener(TimerEvent.TIMER, this.__popu);
                this._timer = null;
                this._popuMsg = [];
            };
        }

        public function getPicStr(_arg_1:PetInfo):String
        {
            return ((_arg_1.Pic + "/icon") + (_arg_1.TemplateID % 10));
        }

        protected function __playerChange(_arg_1:PlayerPropertyEvent):void
        {
            if (_arg_1.changedProperties[SelfInfo.PET])
            {
                if (this._petInfoFrame)
                {
                    this._petInfoFrame.update();
                };
            };
        }

        public function sendPetMove(_arg_1:int, _arg_2:int):void
        {
            SocketManager.Instance.out.sendPetMove(_arg_1, _arg_2);
        }

        public function sendPetCall(_arg_1:int):void
        {
            var _local_2:DictionaryData = this.petModel.selfInfo.pets;
            var _local_3:int = 9;
            while (++_local_3 < 30)
            {
                if ((!(_local_2[_local_3])))
                {
                    SocketManager.Instance.out.sendPetMove(_arg_1, _local_3);
                    return;
                };
            };
        }

        public function openPetFrame(_arg_1:int=-1):void
        {
            this._petIndex = _arg_1;
            if (this._isloading)
            {
                if ((!(this._petInfoFrame)))
                {
                    SocketManager.Instance.out.sendUpdatePetSpace();
                    this._petInfoFrame = ComponentFactory.Instance.creat("petsBag.view.infoFrame", [this.petModel]);
                    this._petInfoFrame.show(this._petIndex);
                };
            }
            else
            {
                this.loadUI();
            };
        }

        private function loadUI():void
        {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.NEW_PETS_BAG);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__createPets);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__activeProgress);
        }

        private function __onClose(_arg_1:Event):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__createPets);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__activeProgress);
        }

        private function __activeProgress(_arg_1:UIModuleEvent):void
        {
            UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
        }

        private function __createPets(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.NEW_PETS_BAG)
            {
                this.isloading = true;
                UIModuleSmallLoading.Instance.hide();
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__activeProgress);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__createPets);
                this.openPetFrame(this._petIndex);
            };
        }

        public function closePetFrame():void
        {
            this._petInfoFrame = null;
        }

        public function closePetSpace():void
        {
            this.openPetFrame();
        }

        public function showUserGuilde():void
        {
        }

        public function get isloading():Boolean
        {
            return (this._isloading);
        }

        public function set isloading(_arg_1:Boolean):void
        {
            this._isloading = _arg_1;
        }

        public function setPetConfig():void
        {
            this.petModel.petOpenLevel = int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.PET_OPEN_LEVEL).Value);
            this.petModel.PetMagicLevel1 = int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.PET_MAGIC_LEVEL1).Value);
            this.petModel.PetMagicLevel2 = int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.PET_MAGIC_LEVEL2).Value);
            this.petModel.AdvanceStoneTemplateId = int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.ADVANCE_STONE_TEMPLETEID).Value);
            this.petModel.initPetPropertyRate(ServerConfigManager.instance.findInfoByName(ServerConfigManager.PET_ADD_PROPERTY_RATE).Value);
            this.petModel.initPetLifeRate(ServerConfigManager.instance.findInfoByName(ServerConfigManager.PET_ADD_LIFE_RATE).Value);
        }


    }
}//package ddt.manager

