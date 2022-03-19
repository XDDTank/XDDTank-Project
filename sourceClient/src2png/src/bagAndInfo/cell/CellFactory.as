// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.cell.CellFactory

package bagAndInfo.cell
{
    import ddt.interfaces.ICellFactory;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.interfaces.ICell;
    import flash.display.Sprite;
    import shop.view.ShopPlayerCell;
    import shop.view.ShopItemCell;
    import flash.display.DisplayObject;
    import ddt.data.goods.ShopCarItemInfo;
    import ddt.manager.ShopManager;
    import ddt.manager.ItemManager;
    import ddt.data.goods.ShopItemInfo;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.ShowTipManager;

    public class CellFactory implements ICellFactory 
    {

        private static var _instance:CellFactory;


        public static function get instance():CellFactory
        {
            if (_instance == null)
            {
                _instance = new (CellFactory)();
            };
            return (_instance);
        }


        public function createBagCell(_arg_1:int, _arg_2:ItemTemplateInfo=null, _arg_3:Boolean=true):ICell
        {
            var _local_4:BagCell = new BagCell(_arg_1, _arg_2, _arg_3);
            this.fillTipProp(_local_4);
            return (_local_4);
        }

        public function createLockBagCell(_arg_1:int, _arg_2:ItemTemplateInfo=null, _arg_3:Boolean=true):ICell
        {
            var _local_4:LockBagCell = new LockBagCell(_arg_1, _arg_2, _arg_3);
            this.fillTipProp(_local_4);
            return (_local_4);
        }

        public function createAuctionBagCell(_arg_1:int, _arg_2:ItemTemplateInfo=null, _arg_3:Boolean=true):ICell
        {
            var _local_4:AuctionBagCell = new AuctionBagCell(_arg_1, _arg_2, _arg_3);
            this.fillTipProp(_local_4);
            return (_local_4);
        }

        public function createBankCell(_arg_1:int, _arg_2:ItemTemplateInfo=null, _arg_3:Boolean=true):ICell
        {
            var _local_4:BankCell = new BankCell(_arg_1, _arg_2, _arg_3);
            this.fillTipProp(_local_4);
            return (_local_4);
        }

        public function createPersonalInfoCell(_arg_1:int, _arg_2:ItemTemplateInfo=null, _arg_3:Boolean=true):ICell
        {
            var _local_4:BagCell = new PersonalInfoCell(_arg_1, _arg_2, _arg_3);
            this.fillTipProp(_local_4);
            return (_local_4);
        }

        public function createShopPlayerItemCell():ICell
        {
            var _local_1:Sprite = new Sprite();
            _local_1.graphics.beginFill(0xFFFFFF, 0);
            _local_1.graphics.drawRect(0, 0, 45, 45);
            _local_1.graphics.endFill();
            var _local_2:ShopPlayerCell = new ShopPlayerCell(_local_1);
            this.fillTipProp(_local_2);
            return (_local_2);
        }

        public function createShopCartItemCell():ICell
        {
            var _local_1:Sprite = new Sprite();
            _local_1.graphics.beginFill(0xFFFFFF, 0);
            _local_1.graphics.drawRect(0, 0, 64, 64);
            _local_1.graphics.endFill();
            var _local_2:ShopPlayerCell = new ShopPlayerCell(_local_1);
            this.fillTipProp(_local_2);
            return (_local_2);
        }

        public function createShopColorItemCell():ICell
        {
            var _local_1:Sprite = new Sprite();
            _local_1.graphics.beginFill(0xFFFFFF, 0);
            _local_1.graphics.drawRect(0, 0, 90, 90);
            _local_1.graphics.endFill();
            var _local_2:ShopPlayerCell = new ShopPlayerCell(_local_1);
            this.fillTipProp(_local_2);
            return (_local_2);
        }

        public function createShopItemCell(_arg_1:DisplayObject, _arg_2:ItemTemplateInfo=null, _arg_3:Boolean=true, _arg_4:Boolean=true):ICell
        {
            var _local_5:ShopItemCell = new ShopItemCell(_arg_1, _arg_2, _arg_3, _arg_4);
            this.fillTipProp(_local_5);
            return (_local_5);
        }

        private function fillTipProp(_arg_1:ICell):void
        {
            _arg_1.tipDirctions = "7,6,2,1,5,4,0,3,6";
            _arg_1.tipGapV = 10;
            _arg_1.tipGapH = 10;
            _arg_1.tipStyle = "core.GoodsTip";
        }

        public function createWeeklyItemCell(_arg_1:DisplayObject, _arg_2:int):ICell
        {
            var _local_5:ShopCarItemInfo;
            var _local_3:* = ShopManager.Instance.getShopItemByGoodsID(_arg_2);
            if ((!(_local_3)))
            {
                _local_3 = ItemManager.Instance.getTemplateById(_arg_2);
            };
            var _local_4:ShopPlayerCell = new ShopPlayerCell(_arg_1);
            if ((_local_3 is ItemTemplateInfo))
            {
                _local_4.info = _local_3;
            };
            if ((_local_3 is ShopItemInfo))
            {
                _local_5 = new ShopCarItemInfo(_local_3.GoodsID, _local_3.TemplateID);
                ObjectUtils.copyProperties(_local_5, _local_3);
                _local_4.shopItemInfo = _local_5;
            };
            ShowTipManager.Instance.removeTip(_local_4);
            return (_local_4);
        }


    }
}//package bagAndInfo.cell

