package store
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.events.EventDispatcher;
   import road7th.comm.PackageIn;
   import store.analyze.RefiningAnayzer;
   import store.data.StoreModel;
   import store.events.StoreIIEvent;
   import store.states.BaseStoreView;
   import store.view.Compose.ComposeController;
   
   public class StoreController extends EventDispatcher
   {
      
      private static var _instance:StoreController;
      
      public static const TRANSFER_SUCCESS:String = "transferSuccess";
       
      
      private var _type:String;
      
      private var _model:StoreModel;
      
      private var _isShine:Boolean = false;
      
      private var _transform:ItemTemplateInfo;
      
      public function StoreController()
      {
         super();
         this.init();
         this.initEvents();
      }
      
      public static function get instance() : StoreController
      {
         if(!_instance)
         {
            _instance = new StoreController();
         }
         return _instance;
      }
      
      private function init() : void
      {
         this._model = new StoreModel(PlayerManager.Instance.Self);
         ComposeController.instance.setup();
      }
      
      public function setupRefining(param1:RefiningAnayzer) : void
      {
         this.Model.refiningConfig = param1.list;
      }
      
      private function initEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REFINING,this.__refiningReback);
      }
      
      private function __refiningReback(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Object = new Object();
         _loc3_["isCrit"] = _loc2_.readBoolean();
         _loc3_["exp"] = _loc2_.readInt();
         this.Model.dispatchEvent(new StoreIIEvent(StoreIIEvent.REFINING_REBACK,_loc3_));
      }
      
      private function removeEvents() : void
      {
      }
      
      public function startupEvent() : void
      {
      }
      
      public function shutdownEvent() : void
      {
      }
      
      public function getView(param1:int) : BaseStoreView
      {
         var _loc2_:BaseStoreView = new BaseStoreView(this,param1);
         PositionUtils.setPos(_loc2_,"ddtstore.BagStoreViewPos");
         return _loc2_;
      }
      
      public function get Type() : String
      {
         return this._type;
      }
      
      public function get Model() : StoreModel
      {
         return this._model;
      }
      
      public function dispose() : void
      {
         this.shutdownEvent();
         this.removeEvents();
         this._model.clear();
         this._model = null;
      }
      
      public function set isShine(param1:Boolean) : void
      {
         this._isShine = param1;
      }
      
      public function get isShine() : Boolean
      {
         return this._isShine;
      }
      
      public function set transform(param1:ItemTemplateInfo) : void
      {
         this._transform = param1;
      }
      
      public function get transform() : ItemTemplateInfo
      {
         return this._transform;
      }
      
      public function sendTransferShowLightEvent(param1:ItemTemplateInfo, param2:Boolean) : void
      {
         if(param2)
         {
            this.isShine = true;
            this.transform = param1;
         }
         else
         {
            this.isShine = false;
            this.transform = null;
         }
         this.Model.dispatchEvent(new StoreIIEvent(StoreIIEvent.TRANSFER_LIGHT,param1,param2));
      }
      
      public function sendRefining() : void
      {
         SocketManager.Instance.out.sendRefining();
      }
   }
}
