package shop.manager
{
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemPrice;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import flash.display.DisplayObject;
   import shop.view.BuyMultiGoodsView;
   import shop.view.BuySingleGoodsView;
   import shop.view.ShopRightView;
   
   public class ShopBuyManager
   {
      
      private static var _instance:ShopBuyManager;
       
      
      private var view:DisplayObject;
      
      private var farmview:DisplayObject;
      
      public function ShopBuyManager()
      {
         super();
      }
      
      public static function get Instance() : ShopBuyManager
      {
         if(_instance == null)
         {
            _instance = new ShopBuyManager();
         }
         return _instance;
      }
      
      public static function calcPrices(param1:Vector.<ShopCarItemInfo>) : Array
      {
         var _loc2_:ItemPrice = new ItemPrice(null,null,null);
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         while(_loc6_ < param1.length)
         {
            _loc2_.addItemPrice(param1[_loc6_].getCurrentPrice());
            _loc6_++;
         }
         _loc3_ = _loc2_.moneyValue;
         _loc4_ = _loc2_.ddtMoneyValue;
         return [_loc3_,_loc4_,_loc5_];
      }
      
      public function buy(param1:int, param2:int = 1) : void
      {
         this.view = new BuySingleGoodsView();
         LayerManager.Instance.addToLayer(this.view,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         BuySingleGoodsView(this.view).isDisCount = param2 == 1 ? Boolean(false) : Boolean(true);
         BuySingleGoodsView(this.view).goodsID = param1;
      }
      
      public function buyAvatar(param1:PlayerInfo) : void
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:ShopItemInfo = null;
         var _loc6_:int = 0;
         var _loc7_:ShopCarItemInfo = null;
         var _loc8_:ShopCarItemInfo = null;
         var _loc2_:Array = [];
         var _loc3_:Vector.<ShopCarItemInfo> = new Vector.<ShopCarItemInfo>();
         if(param1.Bag.items[0])
         {
            _loc2_.push(param1.Bag.items[0]);
         }
         if(param1.Bag.items[1])
         {
            _loc2_.push(param1.Bag.items[1]);
         }
         if(param1.Bag.items[2])
         {
            _loc2_.push(param1.Bag.items[2]);
         }
         if(param1.Bag.items[3])
         {
            _loc2_.push(param1.Bag.items[3]);
         }
         if(param1.Bag.items[4])
         {
            _loc2_.push(param1.Bag.items[4]);
         }
         if(param1.Bag.items[5])
         {
            _loc2_.push(param1.Bag.items[5]);
         }
         if(param1.Bag.items[6])
         {
            _loc2_.push(param1.Bag.items[6]);
         }
         if(param1.Bag.items[7])
         {
            _loc2_.push(param1.Bag.items[7]);
         }
         if(param1.Bag.items[8])
         {
            _loc2_.push(param1.Bag.items[8]);
         }
         if(param1.Bag.items[9])
         {
            _loc2_.push(param1.Bag.items[9]);
         }
         for each(_loc4_ in _loc2_)
         {
            _loc5_ = ShopManager.Instance.getMoneyShopItemByTemplateID(_loc4_.TemplateID,true);
            if(_loc5_ != null)
            {
               _loc6_ = _loc5_.ShopID;
               if(_loc6_ == ShopRightView.VIP_SHOPID)
               {
                  if(PlayerManager.Instance.Self.VIPLevel >= 5)
                  {
                     if(PlayerManager.Instance.Self.IsVIP)
                     {
                        _loc7_ = new ShopCarItemInfo(_loc5_.GoodsID,_loc5_.TemplateID);
                        ObjectUtils.copyProperties(_loc7_,_loc5_);
                        _loc7_.Color = _loc4_.Color;
                        _loc7_.skin = _loc4_.Skin;
                        _loc3_.push(_loc7_);
                     }
                  }
               }
               else
               {
                  _loc8_ = new ShopCarItemInfo(_loc5_.GoodsID,_loc5_.TemplateID);
                  ObjectUtils.copyProperties(_loc8_,_loc5_);
                  _loc8_.Color = _loc4_.Color;
                  _loc8_.skin = _loc4_.Skin;
                  _loc3_.push(_loc8_);
               }
            }
         }
         if(_loc3_.length < _loc2_.length)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.buyAvatarFail"));
         }
         if(_loc3_.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.buyAvatarFail2"));
         }
         if(_loc3_.length > 0)
         {
            this.buyMutiGoods(_loc3_);
         }
      }
      
      public function buyMutiGoods(param1:Vector.<ShopCarItemInfo>) : void
      {
         this.view = new BuyMultiGoodsView();
         BuyMultiGoodsView(this.view).setGoods(param1);
         BuyMultiGoodsView(this.view).show();
      }
      
      public function get isShow() : Boolean
      {
         return this.view && this.view.parent;
      }
      
      public function dispose() : void
      {
         if(this.view && this.view.parent)
         {
            Disposeable(this.view).dispose();
            this.view = null;
         }
         if(this.farmview && this.farmview.parent)
         {
            Disposeable(this.farmview).dispose();
            this.farmview = null;
         }
      }
   }
}
