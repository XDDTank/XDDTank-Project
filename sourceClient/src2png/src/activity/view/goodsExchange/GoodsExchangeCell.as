// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.goodsExchange.GoodsExchangeCell

package activity.view.goodsExchange
{
    import bagAndInfo.cell.BaseCell;
    import activity.data.ActivityRewardInfo;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.ItemManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import ddt.events.BagEvent;
    import com.pickgliss.utils.ObjectUtils;

    public class GoodsExchangeCell extends BaseCell 
    {

        private var _rewardInfo:ActivityRewardInfo;
        private var _countText:FilterFrameText;
        private var _type:int;

        public function GoodsExchangeCell(_arg_1:ActivityRewardInfo, _arg_2:int)
        {
            this._rewardInfo = _arg_1;
            var _local_3:InventoryItemInfo = new InventoryItemInfo();
            _local_3.TemplateID = int(this._rewardInfo.TemplateId);
            _local_3.IsBinds = this._rewardInfo.IsBind;
            ItemManager.fill(_local_3);
            _local_3.StrengthenLevel = this._rewardInfo.getProperty()[0];
            _local_3.Attack = this._rewardInfo.getProperty()[1];
            _local_3.Defence = this._rewardInfo.getProperty()[2];
            _local_3.Agility = this._rewardInfo.getProperty()[3];
            _local_3.Luck = this._rewardInfo.getProperty()[4];
            _info = _local_3;
            this._type = _arg_2;
            _bg = ComponentFactory.Instance.creatBitmap("ddtcalendar.exchange.cellBg");
            super(_bg, _info);
            this._countText = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.cellCount");
            this._countText.text = "0";
            addChild(this._countText);
            this.updateCount();
            PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE, this.__updateGoods);
        }

        public function checkCount():Boolean
        {
            var _local_1:int = PlayerManager.Instance.Self.findItemCount(_info.TemplateID);
            return (_local_1 >= this._rewardInfo.Count);
        }

        private function __updateGoods(_arg_1:BagEvent):void
        {
            this.updateCount();
        }

        private function updateCount():void
        {
            var _local_1:Array;
            var _local_2:int;
            var _local_3:Array;
            var _local_4:InventoryItemInfo;
            if (this._type == 1)
            {
                _local_1 = this._rewardInfo.Property.split(",");
                _local_2 = 0;
                _local_3 = PlayerManager.Instance.Self.Bag.findItemsByTempleteID(_info.TemplateID);
                for each (_local_4 in _local_3)
                {
                    if ((!(this._rewardInfo.IsBind)))
                    {
                        if (_local_4.IsBinds) continue;
                    }
                    else
                    {
                        if (((_local_1.length >= 1) && (_local_4.StrengthenLevel < _local_1[0]))) continue;
                        if (((_local_1.length >= 2) && (_local_4.Attack < _local_1[1]))) continue;
                        if (((_local_1.length >= 3) && (_local_4.Defence < _local_1[2]))) continue;
                        if (((_local_1.length >= 4) && (_local_4.Agility < _local_1[3]))) continue;
                        if (((_local_1.length >= 5) && (_local_4.Luck < _local_1[4]))) continue;
                    };
                    _local_2 = (_local_2 + _local_4.Count);
                };
                this._countText.text = ((_local_2.toString() + "/") + this._rewardInfo.Count.toString());
            }
            else
            {
                if (this._type == 0)
                {
                    this._countText.text = this._rewardInfo.Count.toString();
                };
            };
        }

        override public function dispose():void
        {
            super.dispose();
            PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE, this.__updateGoods);
            ObjectUtils.disposeObject(this._countText);
            this._countText = null;
        }


    }
}//package activity.view.goodsExchange

