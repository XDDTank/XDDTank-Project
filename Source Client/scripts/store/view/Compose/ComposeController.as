package store.view.Compose
{
   import ddt.data.goods.ComposeListInfo;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TaskManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import store.analyze.ComposeItemAnalyzer;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class ComposeController extends EventDispatcher
   {
      
      private static var _instance:ComposeController;
      
      public static const COMPOSE_PLAY:String = "composeplaye";
       
      
      private var _model:ComposeModel;
      
      private var _playerComposeItemList:DictionaryData;
      
      public function ComposeController()
      {
         super();
         this._model = new ComposeModel();
      }
      
      public static function get instance() : ComposeController
      {
         if(!_instance)
         {
            _instance = new ComposeController();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._model.composeBigDic.add(1,"equip");
         this._model.composeBigDic.add(2,"jewelry");
         this._model.composeBigDic.add(3,"material");
         this._model.composeBigDic.add(4,"embedStone");
         this.initEvent();
      }
      
      public function get model() : ComposeModel
      {
         return this._model;
      }
      
      public function intComposeItemInfoDic(param1:ComposeItemAnalyzer) : void
      {
         this.model.composeItemInfoDic = param1.list;
      }
      
      public function getplayerComposeItemList(param1:int, param2:int) : DictionaryData
      {
         var _loc6_:ItemTemplateInfo = null;
         var _loc7_:EquipmentTemplateInfo = null;
         var _loc8_:Boolean = false;
         this._playerComposeItemList = new DictionaryData();
         var _loc3_:DictionaryData = ItemManager.Instance.getComposeInfoList(param2,0);
         var _loc4_:DictionaryData = PlayerManager.Instance.Self.composeSkills;
         var _loc5_:int = 0;
         for each(_loc6_ in _loc3_[param1])
         {
            _loc7_ = ItemManager.Instance.getEquipTemplateById(_loc6_.TemplateID);
            param2 = this.getInfoType(_loc7_);
            _loc8_ = false;
            switch(param2)
            {
               case 1:
                  _loc8_ = _loc7_ && (_loc7_.FormulaID == 0 || _loc4_[_loc6_.TemplateID]);
                  break;
               case 2:
                  _loc8_ = true;
                  break;
               case 3:
                  _loc8_ = true;
                  break;
               case 4:
                  _loc8_ = _loc7_ && (_loc7_.FormulaID == 0 || _loc4_[_loc6_.TemplateID]);
            }
            if(_loc8_)
            {
               this._playerComposeItemList.add(_loc5_,_loc6_);
               _loc5_++;
            }
         }
         return this._playerComposeItemList;
      }
      
      private function getInfoType(param1:EquipmentTemplateInfo) : int
      {
         if(param1)
         {
            if(param1.TemplateType == 12)
            {
               return 4;
            }
            if(param1.TemplateType > 6)
            {
               return 2;
            }
            return 1;
         }
         return 3;
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_COMPOSE_SKILL,this.__getComposeSkill);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_COMPOSE,this.__composeResponse);
      }
      
      private function __getComposeSkill(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:DictionaryData = new DictionaryData();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = _loc2_.readInt();
            if(_loc6_ != 0)
            {
               _loc4_.add(_loc6_,true);
            }
            _loc5_++;
         }
         if(PlayerManager.Instance.Self.composeSkills)
         {
            PlayerManager.Instance.Self.composeSkills.clear();
         }
         PlayerManager.Instance.Self.composeSkills = _loc4_;
         this.getMiddleItemDic();
         this.getSmallItemDic();
         this.model.dispatchEvent(new ComposeEvents(ComposeEvents.GET_SKILLS_COMPLETE));
      }
      
      private function getMiddleItemDic() : void
      {
         var _loc2_:Array = null;
         var _loc3_:DictionaryData = null;
         var _loc4_:ComposeListInfo = null;
         var _loc1_:int = 1;
         while(_loc1_ <= this.model.composeBigDic.length)
         {
            _loc2_ = new Array();
            _loc3_ = ItemManager.Instance.getComposeList(_loc1_);
            for each(_loc4_ in _loc3_.list)
            {
               if(_loc1_ == ComposeType.EQUIP)
               {
                  if(!this.judegLearnSuitBySuitID(_loc4_.ID))
                  {
                     continue;
                  }
               }
               _loc2_.push(_loc4_);
            }
            this.model.composeMiddelDic.add(this.model.composeBigDic[_loc1_],_loc2_);
            _loc1_++;
         }
      }
      
      private function getSmallItemDic() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:ComposeListInfo = null;
         for each(_loc1_ in this.model.composeMiddelDic)
         {
            _loc2_ = new Array();
            for each(_loc3_ in _loc1_)
            {
               _loc2_.push(this.getplayerComposeItemList(_loc3_.ID,_loc3_.Type));
            }
            this.model.composeSmallDic.add(this.model.composeBigDic[_loc1_[0].Type],_loc2_);
         }
      }
      
      private function __composeResponse(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         dispatchEvent(new Event(COMPOSE_PLAY));
         if(NewHandContainer.Instance.hasArrow(ArrowType.STR_WEAPON))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
         }
         TaskManager.instance.checkHighLight();
      }
      
      private function judegLearnSuitBySuitID(param1:int) : Boolean
      {
         var _loc4_:Array = null;
         var _loc6_:int = 0;
         var _loc2_:DictionaryData = ItemManager.Instance.getComposeList(ComposeType.EQUIP);
         var _loc3_:DictionaryData = PlayerManager.Instance.Self.composeSkills;
         var _loc5_:int = 1;
         while(_loc5_ <= 5)
         {
            _loc4_ = _loc2_[param1]["TemplateArray" + _loc5_];
            for each(_loc6_ in _loc4_)
            {
               if(_loc3_[_loc6_])
               {
                  return true;
               }
            }
            _loc5_++;
         }
         return false;
      }
   }
}
