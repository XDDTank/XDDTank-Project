package store.view.storeBag
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.TaskManager;
   import road7th.data.DictionaryEvent;
   import store.StoreController;
   import store.events.StoreBagEvent;
   import store.events.StoreIIEvent;
   
   public class StoreSingleBagListView extends StoreBagListView
   {
      
      public static const SINGLEBAG:int = 49;
       
      
      private var _templateID:int = -1;
      
      private var _categoryID:Number = -1;
      
      private var _templeteType:int = -1;
      
      private var _showLight:Boolean = false;
      
      public function StoreSingleBagListView()
      {
         super();
      }
      
      override protected function createPanel() : void
      {
         panel = ComponentFactory.Instance.creat("ddtstore.StoreBagView.BagSingleScrollPanel");
         addChild(panel);
         panel.hScrollProxy = ScrollPanel.OFF;
         panel.vScrollProxy = ScrollPanel.ON;
         StoreController.instance.Model.addEventListener(StoreIIEvent.TRANSFER_LIGHT,this.__showLight);
      }
      
      private function __showLight(param1:StoreIIEvent) : void
      {
         var _loc2_:EquipmentTemplateInfo = null;
         if(param1.data)
         {
            _loc2_ = ItemManager.Instance.getEquipTemplateById(param1.data.TemplateID);
            this._templateID = param1.data.TemplateID;
            this._categoryID = param1.data.CategoryID;
            this._templeteType = _loc2_.TemplateType;
            this._showLight = param1.bool;
         }
         else
         {
            this._categoryID = -1;
            this._showLight = param1.bool;
         }
         this.showLight(this._categoryID,this._showLight,this._templeteType);
      }
      
      private function showLight(param1:Number, param2:Boolean, param3:int = -1) : void
      {
         var _loc4_:StoreBagCell = null;
         var _loc5_:StoreBagCell = null;
         var _loc6_:EquipmentTemplateInfo = null;
         for each(_loc4_ in _cells)
         {
            if(!(SavePointManager.Instance.isInSavePoint(9) && !TaskManager.instance.isNewHandTaskCompleted(7)))
            {
               if(!_loc4_.locked)
               {
                  _loc4_.light = false;
               }
            }
         }
         if(param1 != -1)
         {
            for each(_loc5_ in _cells)
            {
               if(_loc5_.info && _loc5_.info.CategoryID == param1)
               {
                  if(this._templeteType != -1)
                  {
                     _loc6_ = ItemManager.Instance.getEquipTemplateById(_loc5_.info.TemplateID);
                     if(_loc6_.TemplateType == this._templeteType)
                     {
                        _loc5_.light = param2;
                     }
                  }
                  else
                  {
                     _loc5_.light = param2;
                  }
               }
            }
         }
      }
      
      override public function dispose() : void
      {
         StoreController.instance.Model.removeEventListener(StoreIIEvent.TRANSFER_LIGHT,this.__showLight);
         super.dispose();
      }
      
      override protected function __addGoods(param1:DictionaryEvent) : void
      {
         super.__addGoods(param1);
         this.showLight(this._categoryID,true);
      }
      
      override protected function __removeGoods(param1:StoreBagEvent) : void
      {
         super.__removeGoods(param1);
      }
   }
}
