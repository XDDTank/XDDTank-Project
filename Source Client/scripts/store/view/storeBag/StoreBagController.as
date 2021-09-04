package store.view.storeBag
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import store.data.StoreModel;
   
   public class StoreBagController
   {
       
      
      private var _model:StoreModel;
      
      private var _view:StoreBagView;
      
      public function StoreBagController(param1:StoreModel)
      {
         super();
         this._model = param1;
         this._view = ComponentFactory.Instance.creat("ddtstore.StoreBagView");
         this._view.setup(this);
         this.loadList();
      }
      
      public function getView() : DisplayObject
      {
         return this._view;
      }
      
      public function getPropCell(param1:int) : BagCell
      {
         if(param1 < 0)
         {
            return null;
         }
         return null;
      }
      
      public function getEquipCell(param1:int) : BagCell
      {
         if(param1 < 0)
         {
            return null;
         }
         return null;
      }
      
      public function loadList() : void
      {
         this.setList(this._model);
      }
      
      public function setList(param1:StoreModel) : void
      {
         this._view.setData(param1);
      }
      
      public function changeMsg(param1:int) : void
      {
      }
      
      public function get currentPanel() : int
      {
         return this._model.currentPanel;
      }
      
      public function get model() : StoreModel
      {
         return this._model;
      }
      
      public function getEnabled() : Boolean
      {
         return false;
      }
      
      public function setEnabled(param1:Boolean) : void
      {
      }
      
      public function dispose() : void
      {
         if(this._view)
         {
            ObjectUtils.disposeObject(this._view);
         }
         this._view = null;
         this._model = null;
      }
   }
}
