// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//shop.manager.ShopBuyManager

package shop.manager
{
    import flash.display.DisplayObject;
    import ddt.data.goods.ItemPrice;
    import __AS3__.vec.Vector;
    import ddt.data.goods.ShopCarItemInfo;
    import shop.view.BuySingleGoodsView;
    import com.pickgliss.ui.LayerManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.goods.ShopItemInfo;
    import ddt.manager.ShopManager;
    import shop.view.ShopRightView;
    import ddt.manager.PlayerManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.data.player.PlayerInfo;
    import shop.view.BuyMultiGoodsView;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.*;

    public class ShopBuyManager 
    {

        private static var _instance:ShopBuyManager;

        private var view:DisplayObject;
        private var farmview:DisplayObject;


        public static function get Instance():ShopBuyManager
        {
            if (_instance == null)
            {
                _instance = new (ShopBuyManager)();
            };
            return (_instance);
        }

        public static function calcPrices(_arg_1:Vector.<ShopCarItemInfo>):Array
        {
            var _local_2:ItemPrice = new ItemPrice(null, null, null);
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            while (_local_6 < _arg_1.length)
            {
                _local_2.addItemPrice(_arg_1[_local_6].getCurrentPrice());
                _local_6++;
            };
            _local_3 = _local_2.moneyValue;
            _local_4 = _local_2.ddtMoneyValue;
            return ([_local_3, _local_4, _local_5]);
        }


        public function buy(_arg_1:int, _arg_2:int=1):void
        {
            this.view = new BuySingleGoodsView();
            LayerManager.Instance.addToLayer(this.view, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            BuySingleGoodsView(this.view).isDisCount = ((_arg_2 == 1) ? false : true);
            BuySingleGoodsView(this.view).goodsID = _arg_1;
        }

        public function buyAvatar(_arg_1:PlayerInfo):void
        {
            var _local_4:InventoryItemInfo;
            var _local_5:ShopItemInfo;
            var _local_6:int;
            var _local_7:ShopCarItemInfo;
            var _local_8:ShopCarItemInfo;
            var _local_2:Array = [];
            var _local_3:Vector.<ShopCarItemInfo> = new Vector.<ShopCarItemInfo>();
            if (_arg_1.Bag.items[0])
            {
                _local_2.push(_arg_1.Bag.items[0]);
            };
            if (_arg_1.Bag.items[1])
            {
                _local_2.push(_arg_1.Bag.items[1]);
            };
            if (_arg_1.Bag.items[2])
            {
                _local_2.push(_arg_1.Bag.items[2]);
            };
            if (_arg_1.Bag.items[3])
            {
                _local_2.push(_arg_1.Bag.items[3]);
            };
            if (_arg_1.Bag.items[4])
            {
                _local_2.push(_arg_1.Bag.items[4]);
            };
            if (_arg_1.Bag.items[5])
            {
                _local_2.push(_arg_1.Bag.items[5]);
            };
            if (_arg_1.Bag.items[6])
            {
                _local_2.push(_arg_1.Bag.items[6]);
            };
            if (_arg_1.Bag.items[7])
            {
                _local_2.push(_arg_1.Bag.items[7]);
            };
            if (_arg_1.Bag.items[8])
            {
                _local_2.push(_arg_1.Bag.items[8]);
            };
            if (_arg_1.Bag.items[9])
            {
                _local_2.push(_arg_1.Bag.items[9]);
            };
            for each (_local_4 in _local_2)
            {
                _local_5 = ShopManager.Instance.getMoneyShopItemByTemplateID(_local_4.TemplateID, true);
                if (_local_5 != null)
                {
                    _local_6 = _local_5.ShopID;
                    if (_local_6 == ShopRightView.VIP_SHOPID)
                    {
                        if (PlayerManager.Instance.Self.VIPLevel < 5) continue;
                        if (PlayerManager.Instance.Self.IsVIP)
                        {
                            _local_7 = new ShopCarItemInfo(_local_5.GoodsID, _local_5.TemplateID);
                            ObjectUtils.copyProperties(_local_7, _local_5);
                            _local_7.Color = _local_4.Color;
                            _local_7.skin = _local_4.Skin;
                            _local_3.push(_local_7);
                        };
                    }
                    else
                    {
                        _local_8 = new ShopCarItemInfo(_local_5.GoodsID, _local_5.TemplateID);
                        ObjectUtils.copyProperties(_local_8, _local_5);
                        _local_8.Color = _local_4.Color;
                        _local_8.skin = _local_4.Skin;
                        _local_3.push(_local_8);
                    };
                };
            };
            if (_local_3.length < _local_2.length)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.buyAvatarFail"));
            };
            if (_local_3.length == 0)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.buyAvatarFail2"));
            };
            if (_local_3.length > 0)
            {
                this.buyMutiGoods(_local_3);
            };
        }

        public function buyMutiGoods(_arg_1:Vector.<ShopCarItemInfo>):void
        {
            this.view = new BuyMultiGoodsView();
            BuyMultiGoodsView(this.view).setGoods(_arg_1);
            BuyMultiGoodsView(this.view).show();
        }

        public function get isShow():Boolean
        {
            return ((this.view) && (this.view.parent));
        }

        public function dispose():void
        {
            if (((this.view) && (this.view.parent)))
            {
                Disposeable(this.view).dispose();
                this.view = null;
            };
            if (((this.farmview) && (this.farmview.parent)))
            {
                Disposeable(this.farmview).dispose();
                this.farmview = null;
            };
        }


    }
}//package shop.manager

