// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.buff.buffButton.PayBuffButton

package ddt.view.buff.buffButton
{
    import __AS3__.vec.Vector;
    import ddt.data.BuffInfo;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import com.pickgliss.ui.ShowTipManager;
    import flash.events.MouseEvent;
    import ddt.data.goods.ShopItemInfo;
    import ddt.data.goods.ShopCarItemInfo;
    import ddt.manager.SoundManager;
    import ddt.manager.ShopManager;
    import ddt.data.EquipType;
    import com.pickgliss.utils.ObjectUtils;
    import shop.view.SetsShopView;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.view.tips.BuffTipInfo;
    import ddt.manager.LanguageMgr;
    import __AS3__.vec.*;

    public class PayBuffButton extends BuffButton 
    {

        private var _buffs:Vector.<BuffInfo> = new Vector.<BuffInfo>();
        private var _isActived:Boolean = false;
        private var _timer:Timer;
        private var _str:String;
        private var _isMouseOver:Boolean = false;

        public function PayBuffButton(_arg_1:String="")
        {
            if (_arg_1 == "")
            {
                this._str = "asset.core.payBuffAsset";
            }
            else
            {
                this._str = _arg_1;
            };
            super(this._str);
            _tipStyle = "core.PayBuffTip";
            info = new BuffInfo(BuffInfo.Pay_Buff);
            this._timer = new Timer(10000);
            this._timer.addEventListener(TimerEvent.TIMER, this.__timerTick);
            this._timer.start();
        }

        override public function dispose():void
        {
            super.dispose();
            this._timer.removeEventListener(TimerEvent.TIMER, this.__timerTick);
            this._timer.stop();
            this._timer = null;
        }

        private function __timerTick(_arg_1:TimerEvent):void
        {
            this.validBuff();
            if (this._isMouseOver)
            {
                ShowTipManager.Instance.showTip(this);
            };
        }

        private function validBuff():void
        {
            var _local_1:int;
            var _local_2:BuffInfo;
            if (this._isActived)
            {
                _local_1 = 0;
                for each (_local_2 in this._buffs)
                {
                    _local_2.calculatePayBuffValidDay();
                    if ((!(_local_2.valided)))
                    {
                        _local_1++;
                    };
                };
                if (_local_1 >= this._buffs.length)
                {
                    this.setAcived(false);
                };
            };
        }

        override protected function __onclick(_arg_1:MouseEvent):void
        {
            if ((!(CanClick)))
            {
                return;
            };
            this.shop();
        }

        private function shop():void
        {
            var _local_2:ShopItemInfo;
            var _local_3:ShopCarItemInfo;
            SoundManager.instance.play("008");
            var _local_1:Array = [];
            _local_2 = ShopManager.Instance.getGoodsByTemplateID(EquipType.Caddy_Good);
            _local_3 = new ShopCarItemInfo(_local_2.ShopID, _local_2.TemplateID);
            ObjectUtils.copyProperties(_local_3, _local_2);
            _local_1.push(_local_3);
            _local_2 = ShopManager.Instance.getGoodsByTemplateID(EquipType.Save_Life);
            _local_3 = new ShopCarItemInfo(_local_2.ShopID, _local_2.TemplateID);
            ObjectUtils.copyProperties(_local_3, _local_2);
            _local_1.push(_local_3);
            _local_2 = ShopManager.Instance.getGoodsByTemplateID(EquipType.Agility_Get);
            _local_3 = new ShopCarItemInfo(_local_2.ShopID, _local_2.TemplateID);
            ObjectUtils.copyProperties(_local_3, _local_2);
            _local_1.push(_local_3);
            _local_2 = ShopManager.Instance.getGoodsByTemplateID(EquipType.ReHealth);
            _local_3 = new ShopCarItemInfo(_local_2.ShopID, _local_2.TemplateID);
            ObjectUtils.copyProperties(_local_3, _local_2);
            _local_1.push(_local_3);
            _local_2 = ShopManager.Instance.getGoodsByTemplateID(EquipType.Level_Try);
            _local_3 = new ShopCarItemInfo(_local_2.ShopID, _local_2.TemplateID);
            ObjectUtils.copyProperties(_local_3, _local_2);
            _local_1.push(_local_3);
            _local_2 = ShopManager.Instance.getGoodsByTemplateID(EquipType.Card_Get);
            _local_3 = new ShopCarItemInfo(_local_2.ShopID, _local_2.TemplateID);
            ObjectUtils.copyProperties(_local_3, _local_2);
            _local_1.push(_local_3);
            var _local_4:SetsShopView = new SetsShopView();
            _local_4.initialize(_local_1);
            LayerManager.Instance.addToLayer(_local_4, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            ShowTipManager.Instance.hideTip(this);
        }

        public function addBuff(_arg_1:BuffInfo):void
        {
            var _local_2:int;
            while (_local_2 < this._buffs.length)
            {
                if (this._buffs[_local_2].Type == _arg_1.Type)
                {
                    this._buffs[_local_2] = _arg_1;
                    this.setAcived(true);
                    return;
                };
                _local_2++;
            };
            this._buffs.push(_arg_1);
            this.setAcived(true);
            this.__timerTick(null);
        }

        public function setAcived(_arg_1:Boolean):void
        {
            if (this._isActived == _arg_1)
            {
                return;
            };
            this._isActived = _arg_1;
            if (this._isActived)
            {
                filters = null;
            }
            else
            {
                filters = ComponentFactory.Instance.creatFilters("grayFilter");
            };
        }

        override protected function __onMouseOver(_arg_1:MouseEvent):void
        {
            if (this._isActived)
            {
                filters = ComponentFactory.Instance.creatFilters("lightFilter");
            };
            this._isMouseOver = true;
        }

        override protected function __onMouseOut(_arg_1:MouseEvent):void
        {
            if (this._isActived)
            {
                filters = null;
            };
            this._isMouseOver = false;
        }

        override public function get tipData():Object
        {
            _tipData = new BuffTipInfo();
            this.validBuff();
            if (_info)
            {
                _tipData.isActive = this._isActived;
                _tipData.describe = ((this._isActived) ? "" : LanguageMgr.GetTranslation("tank.view.buff.PayBuff.Note"));
                _tipData.name = LanguageMgr.GetTranslation("tank.view.buff.PayBuff.Name");
                _tipData.isFree = false;
                _tipData.linkBuffs = this._buffs;
            };
            return (_tipData);
        }


    }
}//package ddt.view.buff.buffButton

