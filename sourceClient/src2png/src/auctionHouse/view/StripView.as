// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.view.StripView

package auctionHouse.view
{
    import com.pickgliss.ui.controls.cell.IListCell;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Sprite;
    import ddt.command.StripTip;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Bitmap;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.controls.list.List;
    import auctionHouse.AuctionState;
    import com.pickgliss.ui.ShowTipManager;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;

    [Event(name="selectStrip", type="auctionHouse.event.AuctionHouseEvent")]
    public class StripView extends BaseStripView implements IListCell 
    {

        private var _seller:FilterFrameText;
        private var _lef:Sprite;
        private var _curPrice:StripCurPriceView;
        private var _vieTip:StripTip;
        private var _lefTip:StripTip;


        override protected function initView():void
        {
            super.initView();
            this._seller = ComponentFactory.Instance.creat("auctionHouse.BaseStripSeller");
            addChild(this._seller);
            var _local_1:Bitmap = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.StripIocnAsset");
            this._vieTip = ComponentFactory.Instance.creat("auctionHouse.view.StripIocn");
            this._vieTip.setView(_local_1);
            this._vieTip.tipData = LanguageMgr.GetTranslation("tank.auctionHouse.view.auctioned");
            addChildAt(this._vieTip, (getChildIndex(_leftTime) + 1));
            this._vieTip.visible = false;
            this._lef = this.drawRect(_leftTime.textWidth, _leftTime.textHeight);
            this._lef.alpha = 0;
            this._lefTip = ComponentFactory.Instance.creat("auctionHouse.view.StripLeftTime");
            this._lefTip.setView(this._lef);
            addChild(this._lefTip);
            this._curPrice = ComponentFactory.Instance.creat("auctionHouse.view.StripCurPriceView");
            addChild(this._curPrice);
            buttonMode = true;
        }

        private function drawRect(_arg_1:Number, _arg_2:Number):Sprite
        {
            var _local_3:Sprite = new Sprite();
            _local_3.graphics.beginFill(0xFFFFFF);
            _local_3.graphics.drawRect(0, 0, _arg_1, _arg_2);
            _local_3.graphics.endFill();
            return (_local_3);
        }

        public function setListCellStatus(_arg_1:List, _arg_2:Boolean, _arg_3:int):void
        {
            isSelect = _arg_2;
        }

        public function getCellValue():*
        {
            return (_info);
        }

        public function setCellValue(_arg_1:*):void
        {
            info = _arg_1;
        }

        override protected function updateInfo():void
        {
            super.updateInfo();
            if (AuctionState.CURRENTSTATE == AuctionState.SELL)
            {
                if (_info.BuyerName == "")
                {
                    this._seller.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.null");
                }
                else
                {
                    this._seller.text = _info.BuyerName;
                };
            }
            else
            {
                this._seller.text = _info.AuctioneerName;
                this._vieTip.visible = (!(_info.BuyerName == ""));
            };
            this._lef.width = (this._lefTip.width = _leftTime.width);
            this._lef.height = (this._lefTip.height = _leftTime.height);
            this._curPrice.info = _info;
            ShowTipManager.Instance.removeCurrentTip();
            this._lefTip.tipData = _info.getSithTimeDescription();
            this.mouseEnabled = true;
        }

        override internal function clearSelectStrip():void
        {
            super.clearSelectStrip();
            this._seller.text = "";
            if (((this._curPrice) && (this._curPrice.parent)))
            {
                this._curPrice.parent.removeChild(this._curPrice);
            };
            if (((this._vieTip) && (this._vieTip.parent)))
            {
                this._vieTip.parent.removeChild(this._vieTip);
            };
            this.mouseEnabled = false;
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._seller)
            {
                ObjectUtils.disposeObject(this._seller);
            };
            this._seller = null;
            if (this._vieTip)
            {
                ObjectUtils.disposeObject(this._vieTip);
            };
            this._vieTip = null;
            if (this._lef)
            {
                ObjectUtils.disposeObject(this._lef);
            };
            this._lef = null;
            if (this._curPrice)
            {
                ObjectUtils.disposeObject(this._curPrice);
            };
            this._curPrice = null;
            if (this._lefTip)
            {
                ObjectUtils.disposeObject(this._lefTip);
            };
            this._lefTip = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package auctionHouse.view

