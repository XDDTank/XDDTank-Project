package activity.view.goodsExchange
{
   import activity.data.ActivityRewardInfo;
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   
   public class GoodsExchangeCell extends BaseCell
   {
       
      
      private var _rewardInfo:ActivityRewardInfo;
      
      private var _countText:FilterFrameText;
      
      private var _type:int;
      
      public function GoodsExchangeCell(param1:ActivityRewardInfo, param2:int)
      {
         this._rewardInfo = param1;
         var _loc3_:InventoryItemInfo = new InventoryItemInfo();
         _loc3_.TemplateID = int(this._rewardInfo.TemplateId);
         _loc3_.IsBinds = this._rewardInfo.IsBind;
         ItemManager.fill(_loc3_);
         _loc3_.StrengthenLevel = this._rewardInfo.getProperty()[0];
         _loc3_.Attack = this._rewardInfo.getProperty()[1];
         _loc3_.Defence = this._rewardInfo.getProperty()[2];
         _loc3_.Agility = this._rewardInfo.getProperty()[3];
         _loc3_.Luck = this._rewardInfo.getProperty()[4];
         _info = _loc3_;
         this._type = param2;
         _bg = ComponentFactory.Instance.creatBitmap("ddtcalendar.exchange.cellBg");
         super(_bg,_info);
         this._countText = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.cellCount");
         this._countText.text = "0";
         addChild(this._countText);
         this.updateCount();
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.__updateGoods);
      }
      
      public function checkCount() : Boolean
      {
         var _loc1_:int = PlayerManager.Instance.Self.findItemCount(_info.TemplateID);
         return _loc1_ >= this._rewardInfo.Count;
      }
      
      private function __updateGoods(param1:BagEvent) : void
      {
         this.updateCount();
      }
      
      private function updateCount() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:InventoryItemInfo = null;
         if(this._type == 1)
         {
            _loc1_ = this._rewardInfo.Property.split(",");
            _loc2_ = 0;
            _loc3_ = PlayerManager.Instance.Self.Bag.findItemsByTempleteID(_info.TemplateID);
            for each(_loc4_ in _loc3_)
            {
               if(!this._rewardInfo.IsBind)
               {
                  if(_loc4_.IsBinds)
                  {
                     continue;
                  }
               }
               else
               {
                  if(_loc1_.length >= 1 && _loc4_.StrengthenLevel < _loc1_[0])
                  {
                     continue;
                  }
                  if(_loc1_.length >= 2 && _loc4_.Attack < _loc1_[1])
                  {
                     continue;
                  }
                  if(_loc1_.length >= 3 && _loc4_.Defence < _loc1_[2])
                  {
                     continue;
                  }
                  if(_loc1_.length >= 4 && _loc4_.Agility < _loc1_[3])
                  {
                     continue;
                  }
                  if(_loc1_.length >= 5 && _loc4_.Luck < _loc1_[4])
                  {
                     continue;
                  }
               }
               _loc2_ += _loc4_.Count;
            }
            this._countText.text = _loc2_.toString() + "/" + this._rewardInfo.Count.toString();
         }
         else if(this._type == 0)
         {
            this._countText.text = this._rewardInfo.Count.toString();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.__updateGoods);
         ObjectUtils.disposeObject(this._countText);
         this._countText = null;
      }
   }
}
