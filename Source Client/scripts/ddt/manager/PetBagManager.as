package ddt.manager
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.SelfInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import pet.date.PetInfo;
   import petsBag.data.PetBagModel;
   import petsBag.view.PetInfoFrame;
   import road7th.data.DictionaryData;
   
   public class PetBagManager extends EventDispatcher
   {
      
      private static var _instance:PetBagManager;
       
      
      private var _isloading:Boolean;
      
      public var petModel:PetBagModel;
      
      private var _petInfoFrame:PetInfoFrame;
      
      private var _petIndex:int;
      
      private var _popuMsg:Array;
      
      private var _timer:Timer;
      
      private var _openSpace:Boolean;
      
      public function PetBagManager()
      {
         this._popuMsg = [];
         super();
      }
      
      public static function instance() : PetBagManager
      {
         if(!_instance)
         {
            _instance = new PetBagManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.petModel = new PetBagModel();
         this.petModel.selfInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerChange);
      }
      
      public function pushMsg(param1:String) : void
      {
         this._popuMsg.push(param1);
         if(!this._timer)
         {
            this._timer = new Timer(2000);
            this._timer.addEventListener(TimerEvent.TIMER,this.__popu);
            this._timer.start();
         }
      }
      
      private function __popu(param1:TimerEvent) : void
      {
         var _loc2_:String = "";
         if(this._popuMsg.length > 0)
         {
            _loc2_ = this._popuMsg.shift();
            MessageTipManager.getInstance().show(_loc2_);
            ChatManager.Instance.sysChatYellow(_loc2_);
         }
         else
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__popu);
            this._timer = null;
            this._popuMsg = [];
         }
      }
      
      public function getPicStr(param1:PetInfo) : String
      {
         return param1.Pic + "/icon" + param1.TemplateID % 10;
      }
      
      protected function __playerChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties[SelfInfo.PET])
         {
            if(this._petInfoFrame)
            {
               this._petInfoFrame.update();
            }
         }
      }
      
      public function sendPetMove(param1:int, param2:int) : void
      {
         SocketManager.Instance.out.sendPetMove(param1,param2);
      }
      
      public function sendPetCall(param1:int) : void
      {
         var _loc2_:DictionaryData = this.petModel.selfInfo.pets;
         var _loc3_:int = 9;
         while(++_loc3_ < 30)
         {
            if(!_loc2_[_loc3_])
            {
               SocketManager.Instance.out.sendPetMove(param1,_loc3_);
               break;
            }
         }
      }
      
      public function openPetFrame(param1:int = -1) : void
      {
         this._petIndex = param1;
         if(this._isloading)
         {
            if(!this._petInfoFrame)
            {
               SocketManager.Instance.out.sendUpdatePetSpace();
               this._petInfoFrame = ComponentFactory.Instance.creat("petsBag.view.infoFrame",[this.petModel]);
               this._petInfoFrame.show(this._petIndex);
            }
         }
         else
         {
            this.loadUI();
         }
      }
      
      private function loadUI() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.NEW_PETS_BAG);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createPets);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__activeProgress);
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createPets);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__activeProgress);
      }
      
      private function __activeProgress(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      private function __createPets(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.NEW_PETS_BAG)
         {
            this.isloading = true;
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__activeProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createPets);
            this.openPetFrame(this._petIndex);
         }
      }
      
      public function closePetFrame() : void
      {
         this._petInfoFrame = null;
      }
      
      public function closePetSpace() : void
      {
         this.openPetFrame();
      }
      
      public function showUserGuilde() : void
      {
      }
      
      public function get isloading() : Boolean
      {
         return this._isloading;
      }
      
      public function set isloading(param1:Boolean) : void
      {
         this._isloading = param1;
      }
      
      public function setPetConfig() : void
      {
         this.petModel.petOpenLevel = int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.PET_OPEN_LEVEL).Value);
         this.petModel.PetMagicLevel1 = int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.PET_MAGIC_LEVEL1).Value);
         this.petModel.PetMagicLevel2 = int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.PET_MAGIC_LEVEL2).Value);
         this.petModel.AdvanceStoneTemplateId = int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.ADVANCE_STONE_TEMPLETEID).Value);
         this.petModel.initPetPropertyRate(ServerConfigManager.instance.findInfoByName(ServerConfigManager.PET_ADD_PROPERTY_RATE).Value);
         this.petModel.initPetLifeRate(ServerConfigManager.instance.findInfoByName(ServerConfigManager.PET_ADD_LIFE_RATE).Value);
      }
   }
}
