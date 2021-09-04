package ddt.command
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class OpenAllFrame extends BaseAlerFrame
   {
       
      
      private var _number:NumberSelecter;
      
      private var _cell:BaseCell;
      
      private var _itemInfo:InventoryItemInfo;
      
      private var _bg:Image;
      
      public function OpenAllFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.showSubmit = true;
         _loc1_.showCancel = false;
         _loc1_.title = LanguageMgr.GetTranslation("ddt.bagCell.openAll");
         info = _loc1_;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtcore.CellBg");
         addToContent(this._bg);
         this._number = ComponentFactory.Instance.creatCustomObject("openAllFrame.numberSelecter");
         addToContent(this._number);
         var _loc2_:Sprite = new Sprite();
         _loc2_.addChild(ComponentFactory.Instance.creatBitmap("asset.ddtcore.EquipCellBG"));
         this._cell = new BaseCell(_loc2_);
         this._cell.x = this._bg.x + 4;
         this._cell.y = this._bg.y + 4;
         addToContent(this._cell);
         this._cell.tipDirctions = "7,0";
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
         this._number.addEventListener(NumberSelecter.NUMBER_CLOSE,this.__numberClose);
      }
      
      private function __numberClose(param1:Event) : void
      {
         ObjectUtils.disposeObject(this);
      }
      
      private function removeEvnets() : void
      {
         this._number.removeEventListener(NumberSelecter.NUMBER_CLOSE,this.__numberClose);
         removeEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      public function set ItemInfo(param1:ItemTemplateInfo) : void
      {
         this._itemInfo = param1 as InventoryItemInfo;
         this._cell.info = param1;
         var _loc2_:int = this._itemInfo.Count > 99 ? int(99) : int(this._itemInfo.Count);
         this.maxLimit = _loc2_;
         this._number.number = _loc2_;
      }
      
      public function set maxLimit(param1:int) : void
      {
         this._number.maximum = param1;
      }
      
      private function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(EquipType.isCard(this._itemInfo))
            {
               SocketManager.Instance.out.sendUseCard(this._itemInfo.BagType,this._itemInfo.Place,[this._itemInfo.TemplateID],this._itemInfo.PayType,false,this._number.number);
            }
            else
            {
               SocketManager.Instance.out.sendItemOpenUp(this._itemInfo.BagType,this._itemInfo.Place,this._number.number);
            }
         }
         ObjectUtils.disposeObject(this);
      }
      
      override public function dispose() : void
      {
         this.removeEvnets();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._number);
         this._number = null;
         ObjectUtils.disposeObject(this._cell);
         this._cell = null;
         this._itemInfo = null;
         super.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
