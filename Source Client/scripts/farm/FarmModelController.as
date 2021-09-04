package farm
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import farm.event.FarmEvent;
   import farm.model.FarmModel;
   import farm.model.FieldVO;
   import farm.view.FarmCell;
   import farm.view.FarmGainFram;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import game.view.DropGoods;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class FarmModelController extends EventDispatcher
   {
      
      private static var _instance:FarmModelController;
       
      
      private var _model:FarmModel;
      
      private var _canGoFarm:Boolean = true;
      
      public var _moneyReflashCount:int;
      
      public var _cell:FarmCell;
      
      private var _frame:FarmGainFram;
      
      private var _frameOpen:Boolean = true;
      
      public function FarmModelController()
      {
         super();
      }
      
      public static function get instance() : FarmModelController
      {
         return _instance = _instance || new FarmModelController();
      }
      
      public function setup() : void
      {
         this._model = new FarmModel();
         this.initEvent();
      }
      
      public function get model() : FarmModel
      {
         return this._model;
      }
      
      public function refreshFarm() : void
      {
         this._model.currentFarmerName = PlayerManager.Instance.Self.NickName;
         SocketManager.Instance.out.refreshFarm();
      }
      
      public function sowSeed(param1:int, param2:int) : void
      {
         SocketManager.Instance.out.seeding(param1,param2);
      }
      
      public function getHarvest(param1:int) : void
      {
         SocketManager.Instance.out.toGather(param1);
      }
      
      public function farmPlantSpeed(param1:int, param2:int) : void
      {
         SocketManager.Instance.out.farmSpeed(param1,param2);
      }
      
      public function farmPlantDelete(param1:int) : void
      {
         SocketManager.Instance.out.FieldDelete(param1);
      }
      
      public function farmBack() : void
      {
         SocketManager.Instance.out.farmLeaving();
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REFRASH_FARM,this.__refreshFarm);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEEDING,this.__seeding);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAIN_FIELD,this.__gainFarm);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACCELERATE_FIELD,this.__speedFarm);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPROOT_FIELD,this.__farmPlantDelete);
      }
      
      protected function __seeding(param1:CrazyTankSocketEvent) : void
      {
         this.model.fieldsInfo = null;
         this.model.fieldsInfo = new DictionaryData();
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:FieldVO = new FieldVO();
         _loc3_.fieldID = _loc2_.readInt();
         _loc3_.seedID = _loc2_.readInt();
         _loc3_.plantTime = _loc2_.readDate();
         _loc3_.gainTime = _loc2_.readInt();
         this.model.fieldsInfo.add(_loc3_.fieldID,_loc3_);
         dispatchEvent(new FarmEvent(FarmEvent.SEED,_loc3_));
      }
      
      protected function __farmPlantDelete(param1:CrazyTankSocketEvent) : void
      {
         this.model.fieldsInfo = null;
         this.model.fieldsInfo = new DictionaryData();
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:FieldVO = new FieldVO();
         _loc3_.fieldID = _loc2_.readInt();
         _loc3_.seedID = _loc2_.readInt();
         _loc3_.plantTime = _loc2_.readDate();
         _loc3_.gainTime = _loc2_.readInt();
         this.model.fieldsInfo.add(_loc3_.fieldID,_loc3_);
         dispatchEvent(new FarmEvent(FarmEvent.PLANETDELETE,_loc3_));
      }
      
      private function __refreshFarm(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:FieldVO = null;
         this.model.fieldsInfo = null;
         this.model.fieldsInfo = new DictionaryData();
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new FieldVO();
            _loc5_.fieldID = _loc2_.readInt();
            _loc5_.seedID = _loc2_.readInt();
            _loc5_.plantTime = _loc2_.readDate();
            _loc5_.gainTime = _loc2_.readInt();
            this.model.fieldsInfo.add(_loc5_.fieldID,_loc5_);
            _loc4_++;
         }
         dispatchEvent(new FarmEvent(FarmEvent.FIELDS_INFO_READY));
      }
      
      private function __speedFarm(param1:CrazyTankSocketEvent) : void
      {
         this.model.fieldsInfo = null;
         this.model.fieldsInfo = new DictionaryData();
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:FieldVO = new FieldVO();
         _loc3_.fieldID = _loc2_.readInt();
         _loc3_.seedID = _loc2_.readInt();
         _loc3_.plantTime = _loc2_.readDate();
         _loc3_.gainTime = _loc2_.readInt();
         this.model.fieldsInfo.remove(_loc3_.fieldID);
         this._frameOpen = true;
         dispatchEvent(new FarmEvent(FarmEvent.PLANTSPEED,_loc3_));
      }
      
      private function __gainFarm(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:int = 0;
         var _loc9_:ItemTemplateInfo = null;
         var _loc10_:BaseCell = null;
         var _loc11_:Point = null;
         var _loc12_:DropGoods = null;
         this.model.fieldsInfo = null;
         this.model.fieldsInfo = new DictionaryData();
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:FieldVO = new FieldVO();
         _loc3_.fieldID = _loc2_.readInt();
         _loc3_.seedID = _loc2_.readInt();
         _loc3_.plantTime = _loc2_.readDate();
         _loc3_.gainTime = _loc2_.readInt();
         this.model.fieldsInfo.remove(_loc3_.fieldID);
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         if(_loc5_ <= 1)
         {
            _loc6_ = 1;
         }
         else
         {
            _loc6_ = 2;
         }
         var _loc7_:Point = new Point();
         PositionUtils.setPos(_loc7_,"farm.fieldsView.fieldPos" + _loc3_.fieldID);
         _loc7_.x += 386;
         _loc7_.y += 228;
         var _loc8_:int = 0;
         while(_loc8_ < _loc6_)
         {
            _loc9_ = ItemManager.Instance.getTemplateById(_loc4_);
            _loc10_ = new BaseCell(new Sprite(),_loc9_,false,false);
            _loc10_.setContentSize(40,40);
            _loc11_ = new Point(650,540);
            _loc12_ = new DropGoods(StageReferance.stage,_loc10_,_loc7_,_loc11_,_loc5_ / _loc6_);
            _loc12_.start(_loc12_.CHESTS_DROP);
            _loc8_++;
         }
         this._frameOpen = true;
         dispatchEvent(new FarmEvent(FarmEvent.GAIN_FIELD,_loc3_));
      }
      
      public function fieldGain() : Boolean
      {
         var _loc1_:Boolean = false;
         _loc1_ = false;
         var _loc2_:int = 0;
         while(_loc2_ < this._model.fieldsInfo.length)
         {
            if(this.model.fieldsInfo[_loc2_])
            {
               if(this.model.fieldsInfo[_loc2_].seedID != 0 && this.model.fieldsInfo[_loc2_].isGrownUp)
               {
                  _loc1_ = true;
                  break;
               }
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function showFeildGain() : void
      {
         if(this._frameOpen)
         {
            if(this.fieldGain())
            {
               if(!this._frame)
               {
                  this._frame = ComponentFactory.Instance.creatComponentByStylename("trainer.view.farmGainPlant");
                  LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,false,0,false);
                  LayerManager.Instance.getLayerByType(LayerManager.GAME_DYNAMIC_LAYER).setChildIndex(this._frame,0);
                  this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameResponse1);
               }
            }
         }
      }
      
      public function deleteGainPlant() : void
      {
         if(this._frame)
         {
            this._frame.removeEventListener(FrameEvent.RESPONSE,this.__frameResponse1);
            ObjectUtils.disposeObject(this._frame);
            this._frame = null;
         }
      }
      
      private function __frameResponse1(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__frameResponse1);
         ObjectUtils.disposeObject(this._frame);
         this._frame = null;
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            StateManager.setState(StateType.FARM);
         }
         else
         {
            this._frameOpen = false;
         }
      }
   }
}
