package store.view.refining
{
   import bagAndInfo.cell.CellContentCreator;
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import store.StoreCell;
   
   public class RefiningEquipCell extends StoreCell
   {
      
      public static const CONTENTSIZE:int = 70;
       
      
      private var _actionState:Boolean;
      
      private var _text:FilterFrameText;
      
      public function RefiningEquipCell()
      {
         var _loc1_:Sprite = new Sprite();
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtstore.BlankCellBG");
         _loc1_.addChild(_loc2_);
         super(_loc1_,1);
         setContentSize(CONTENTSIZE,CONTENTSIZE);
         shinerPos = ComponentFactory.Instance.creatCustomObject("ddtstore.refining.equipCellShinePos");
         this._text = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreRefiningBG.EquipmentCellText");
         this._text.htmlText = LanguageMgr.GetTranslation("store.storeRefiningBG.equipcell.txt");
         addChild(this._text);
      }
      
      override protected function creatPic() : void
      {
         if(_info && (!_pic || !_pic.info || _info.TemplateID != _pic.info.TemplateID))
         {
            ObjectUtils.disposeObject(_pic);
            _pic = null;
            _pic = new CellContentCreator();
            _pic.info = _info;
            _pic.loadSync(createContentComplete);
            addChild(_pic);
         }
         else
         {
            ObjectUtils.disposeObject(_pic);
            _pic = null;
         }
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         super.info = param1;
         tipStyle = "ddtstore.StrengthTips";
         if(param1 == null)
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         param1.action = DragEffect.NONE;
         DragManager.acceptDrag(this);
         dispatchEvent(new RefiningEvent(RefiningEvent.MOVE,_loc2_));
      }
      
      public function get actionState() : Boolean
      {
         return this._actionState;
      }
      
      public function set actionState(param1:Boolean) : void
      {
         this._actionState = param1;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._text);
         this._text = null;
         super.dispose();
      }
   }
}
