// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//vip.view.VipSpreeView

package vip.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import __AS3__.vec.Vector;
    import ddt.view.tips.GoodTip;
    import ddt.view.tips.EquipTipPanel;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.ServerConfigManager;
    import ddt.utils.PositionUtils;
    import ddt.manager.PlayerManager;
    import flash.events.Event;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.view.tips.GoodTipInfo;
    import ddt.manager.ItemManager;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class VipSpreeView extends Sprite implements Disposeable 
    {

        public static const HALF_YEAR_NUM:int = 10;
        public static const THREE_MONTH_NUM:int = 9;
        public static const ONE_MONTH_NUM:int = 9;

        private var _icon:ScaleFrameImage;
        private var _weaponIcon:ScaleFrameImage;
        private var _spreeItem:Vector.<SpreeItem>;
        private var type:int;
        private var _spreeTip:GoodTip;
        private var _equipTip:EquipTipPanel;
        private var _vipInformation:Array;
        private var _itemX:int;
        private var _rechargeItem:int;
        private var _ReceiveBg:Bitmap;

        public function VipSpreeView()
        {
            this.init();
        }

        private function init():void
        {
            this._icon = ComponentFactory.Instance.creatComponentByStylename("ddtvip.SpreeIcon");
            addChild(this._icon);
            this._weaponIcon = ComponentFactory.Instance.creatComponentByStylename("ddtvip.weaponIcon");
            addChild(this._weaponIcon);
            this._spreeItem = new Vector.<SpreeItem>();
            this._spreeTip = new GoodTip();
            this._equipTip = new EquipTipPanel();
            this._vipInformation = ServerConfigManager.instance.VIPRenewalPrice;
            this._ReceiveBg = ComponentFactory.Instance.creatBitmap("asset.ddtvip.ReceiveAsset");
            PositionUtils.setPos(this._ReceiveBg, "vip.VipFrame.ReceivePos");
            addChild(this._ReceiveBg);
            this._ReceiveBg.visible = false;
            this.updateView(PlayerManager.Instance.Self.VIPLevel);
            this.initEvent();
        }

        private function initEvent():void
        {
            PlayerManager.Instance.addEventListener(PlayerManager.VIP_STATE_CHANGE, this.__upVip);
        }

        private function removeEvent():void
        {
            PlayerManager.Instance.removeEventListener(PlayerManager.VIP_STATE_CHANGE, this.__upVip);
        }

        private function updateView(_arg_1:int):void
        {
            if ((((PlayerManager.Instance.Self.IsVIP) && (PlayerManager.Instance.Self.VIPtype == 2)) && (_arg_1 <= PlayerManager.Instance.Self.VIPLevel)))
            {
                if (this._ReceiveBg)
                {
                    this._ReceiveBg.visible = true;
                };
                if (this._icon)
                {
                    this._icon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                };
                if (this._weaponIcon)
                {
                    this._weaponIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                };
            }
            else
            {
                if (this._icon)
                {
                    this._icon.filters = null;
                };
                if (this._weaponIcon)
                {
                    this._weaponIcon.filters = null;
                };
                if (this._ReceiveBg)
                {
                    this._ReceiveBg.visible = false;
                };
            };
        }

        private function __upVip(_arg_1:Event):void
        {
            this.updateView(PlayerManager.Instance.Self.VIPLevel);
        }

        public function setView(_arg_1:int):void
        {
            this.type = _arg_1;
            if (this.type == 6)
            {
                this._icon.setFrame(1);
                this._weaponIcon.setFrame(1);
                this.updateView((this.type - 1));
                this.creatItem(HALF_YEAR_NUM);
                this.setTip(this.type);
            }
            else
            {
                if (this.type == 3)
                {
                    this._icon.setFrame(2);
                    this._weaponIcon.setFrame(2);
                    this.updateView(this.type);
                    this.creatItem(THREE_MONTH_NUM);
                    this.setTip(this.type);
                }
                else
                {
                    if (this.type == 1)
                    {
                        this._icon.setFrame(3);
                        this._weaponIcon.setFrame(3);
                        this.updateView(this.type);
                        this.creatItem(ONE_MONTH_NUM);
                        this.setTip(this.type);
                    };
                };
            };
        }

        private function setTip(_arg_1:int):void
        {
            var _local_3:ItemTemplateInfo;
            var _local_4:ItemTemplateInfo;
            var _local_2:GoodTipInfo = new GoodTipInfo();
            var _local_5:Array = this.resolveArr(_arg_1);
            _local_3 = ItemManager.Instance.getTemplateById(int(_local_5[1]));
            _local_4 = ItemManager.Instance.getTemplateById(int(_local_5[2]));
            _local_2.itemInfo = _local_3;
            this._spreeTip.tipData = _local_2;
            this._equipTip.tipData = _local_4;
            this._spreeTip.visible = false;
            this._equipTip.visible = false;
            this._icon.addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOverHandler);
            this._icon.addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOutHandler);
            this._weaponIcon.addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOverHandlerI);
            this._weaponIcon.addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOutHandlerI);
        }

        private function __mouseOverHandler(_arg_1:MouseEvent):void
        {
            var _local_2:Point;
            if (this._spreeTip)
            {
                this._spreeTip.visible = true;
                LayerManager.Instance.addToLayer(this._spreeTip, LayerManager.GAME_TOP_LAYER);
                _local_2 = this._icon.localToGlobal(new Point(0, 0));
                this._spreeTip.x = (_local_2.x + this._icon.width);
                this._spreeTip.y = _local_2.y;
            };
        }

        private function __mouseOutHandler(_arg_1:MouseEvent):void
        {
            if (this._spreeTip)
            {
                this._spreeTip.visible = false;
            };
        }

        private function __mouseOverHandlerI(_arg_1:MouseEvent):void
        {
            if (this._equipTip)
            {
                this._equipTip.visible = true;
                LayerManager.Instance.addToLayer(this._equipTip, LayerManager.GAME_TOP_LAYER);
                PositionUtils.setPos(this._equipTip, "vip.VipFrame.weaponTipPos");
            };
        }

        private function __mouseOutHandlerI(_arg_1:MouseEvent):void
        {
            if (this._equipTip)
            {
                this._equipTip.visible = false;
            };
        }

        public function VIPRechargeView(_arg_1:int):void
        {
            this.type = _arg_1;
            if (this.type == 6)
            {
                this._icon.setFrame(1);
                this._weaponIcon.setFrame(1);
                this.creatRechargeItem(HALF_YEAR_NUM);
                this.setTip(this.type);
            }
            else
            {
                if (this.type == 3)
                {
                    this._icon.setFrame(2);
                    this._weaponIcon.setFrame(2);
                    this.creatRechargeItem(THREE_MONTH_NUM);
                    this.setTip(this.type);
                }
                else
                {
                    if (this.type == 1)
                    {
                        this._icon.setFrame(3);
                        this._weaponIcon.setFrame(3);
                        this.creatRechargeItem(ONE_MONTH_NUM);
                        this.setTip(this.type);
                    };
                };
            };
        }

        private function creatRechargeItem(_arg_1:int):void
        {
            var _local_2:int;
            while (_local_2 < _arg_1)
            {
                this._spreeItem[_local_2] = ComponentFactory.Instance.creatCustomObject("vip.SpreeItem");
                this._spreeItem[_local_2].setItem(_local_2);
                if (_local_2 < 4)
                {
                    this._spreeItem[_local_2].x = (226 + (56 * _local_2));
                    this._spreeItem[_local_2].y = 2;
                }
                else
                {
                    if (_local_2 < 10)
                    {
                        this._spreeItem[_local_2].x = (1 + (57 * (_local_2 - 4)));
                        this._spreeItem[_local_2].y = 77;
                    }
                    else
                    {
                        this._spreeItem[_local_2].x = (1 + (57 * (_local_2 - 10)));
                        this._spreeItem[_local_2].y = 152;
                    };
                };
                addChild(this._spreeItem[_local_2]);
                _local_2++;
            };
        }

        private function creatItem(_arg_1:int):void
        {
            this.clearItem();
            var _local_2:int;
            while (_local_2 < _arg_1)
            {
                this._spreeItem[_local_2] = ComponentFactory.Instance.creatCustomObject("vip.SpreeItem");
                this._spreeItem[_local_2].setItem(_local_2);
                if (_local_2 < 4)
                {
                    this._spreeItem[_local_2].x = (230 + (56 * _local_2));
                    this._spreeItem[_local_2].y = 2;
                }
                else
                {
                    if (_local_2 < 10)
                    {
                        this._spreeItem[_local_2].x = (-1 + (57 * (_local_2 - 4)));
                        this._spreeItem[_local_2].y = 76;
                    }
                    else
                    {
                        this._spreeItem[_local_2].x = (-1 + (66 * (_local_2 - 10)));
                        this._spreeItem[_local_2].y = 144;
                    };
                };
                addChild(this._spreeItem[_local_2]);
                _local_2++;
            };
        }

        private function clearItem():void
        {
            var _local_1:int;
            while (_local_1 < this._spreeItem.length)
            {
                if (this._spreeItem[_local_1])
                {
                    this._spreeItem[_local_1].dispose();
                    this._spreeItem[_local_1] = null;
                };
                _local_1++;
            };
        }

        private function resolveArr(_arg_1:int):Array
        {
            var _local_2:String;
            if (_arg_1 == 6)
            {
                _local_2 = this._vipInformation[2];
                return (_local_2.split("|"));
            };
            if (_arg_1 == 3)
            {
                _local_2 = this._vipInformation[1];
                return (_local_2.split("|"));
            };
            if (_arg_1 == 1)
            {
                _local_2 = this._vipInformation[0];
                return (_local_2.split("|"));
            };
            return (null);
        }

        public function dispose():void
        {
            this.removeEvent();
            var _local_1:int;
            while (_local_1 < this._spreeItem.length)
            {
                ObjectUtils.disposeObject(this._spreeItem[_local_1]);
                this._spreeItem[_local_1] = null;
                _local_1++;
            };
            this._spreeItem = null;
            ObjectUtils.disposeObject(this._ReceiveBg);
            this._ReceiveBg = null;
            if (this._icon)
            {
                this._icon.removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOverHandler);
                this._icon.removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOutHandler);
                ObjectUtils.disposeObject(this._icon);
                this._icon = null;
            };
            if (this._weaponIcon)
            {
                this._weaponIcon.removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOverHandlerI);
                this._weaponIcon.removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOutHandlerI);
                ObjectUtils.disposeObject(this._weaponIcon);
                this._weaponIcon = null;
            };
            if (this._spreeTip)
            {
                ObjectUtils.disposeObject(this._spreeTip);
                this._spreeTip = null;
            };
            if (this._equipTip)
            {
                ObjectUtils.disposeObject(this._equipTip);
                this._equipTip = null;
            };
            ObjectUtils.disposeAllChildren(this);
        }


    }
}//package vip.view

