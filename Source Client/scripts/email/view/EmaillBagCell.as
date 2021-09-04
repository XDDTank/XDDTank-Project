package email.view
{
   import auctionHouse.event.AuctionSellEvent;
   import auctionHouse.view.AuctionSellLeftAler;
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import bagAndInfo.cell.LinkedBagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import flash.events.MouseEvent;
   
   public class EmaillBagCell extends LinkedBagCell
   {
       
      
      private var _temporaryCount:int;
      
      private var _temporaryInfo:InventoryItemInfo;
      
      private var _goodsCount:int;
      
      public function EmaillBagCell()
      {
         super(null);
         this._goodsCount = 1;
         _bg.alpha = 0;
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         var _loc3_:AuctionSellLeftAler = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(_loc2_ && param1.action == DragEffect.MOVE)
         {
            param1.action = DragEffect.NONE;
            if(_loc2_.IsBinds)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.EmaillIIBagCell.isBinds"));
            }
            else if(_loc2_.getRemainDate() <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.EmaillIIBagCell.RemainDate"));
            }
            else
            {
               this._goodsCount = 1;
               bagCell = param1.source as BagCell;
               param1.action = DragEffect.LINK;
               this._temporaryCount = bagCell.itemInfo.Count;
               this._temporaryInfo = bagCell.itemInfo;
               if(bagCell.locked == false)
               {
                  bagCell.locked = true;
                  return;
               }
               if(bagCell.itemInfo.Count > 1)
               {
                  _loc3_ = ComponentFactory.Instance.creat("auctionHouse.AuctionSellLeftAler");
                  _loc3_.titleText = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagBreak");
                  _loc3_.show(this._temporaryInfo.Count);
                  _loc3_.addEventListener(AuctionSellEvent.SELL,this._alerSell);
                  _loc3_.addEventListener(AuctionSellEvent.NOTSELL,this._alerNotSell);
               }
            }
            DragManager.acceptDrag(this);
         }
      }
      
      private function _alerSell(param1:AuctionSellEvent) : void
      {
         var _loc2_:AuctionSellLeftAler = param1.currentTarget as AuctionSellLeftAler;
         this._temporaryInfo.Count = param1.sellCount;
         this._goodsCount = param1.sellCount;
         this.info = this._temporaryInfo;
         if(bagCell)
         {
            bagCell.itemInfo.Count = this._temporaryCount;
         }
         _loc2_.dispose();
         if(_loc2_ && _loc2_.parent)
         {
            removeChild(_loc2_);
         }
         _loc2_ = null;
      }
      
      private function _alerNotSell(param1:AuctionSellEvent) : void
      {
         var _loc2_:AuctionSellLeftAler = param1.currentTarget as AuctionSellLeftAler;
         this.info = null;
         bagCell.locked = false;
         bagCell = null;
         _loc2_.dispose();
         if(_loc2_ && _loc2_.parent)
         {
            removeChild(_loc2_);
         }
         _loc2_ = null;
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         super.info = param1;
         this.updateCount();
      }
      
      override public function updateCount() : void
      {
         if(_tbxCount == null)
         {
            return;
         }
         if(_info && itemInfo && itemInfo.MaxCount > 1)
         {
            _tbxCount.visible = true;
            _tbxCount.text = String(itemInfo.Count);
            addChild(_tbxCount);
         }
         else
         {
            _tbxCount.visible = false;
         }
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
         buttonMode = true;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ShowTipManager.Instance.removeAllTip();
      }
      
      public function get goodsCount() : int
      {
         return this._goodsCount;
      }
   }
}
