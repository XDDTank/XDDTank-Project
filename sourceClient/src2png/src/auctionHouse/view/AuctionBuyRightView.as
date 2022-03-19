// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.view.AuctionBuyRightView

package auctionHouse.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.ScrollPanel;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.image.ScaleLeftRightImage;
    import ddt.manager.LanguageMgr;
    import auctionHouse.event.AuctionHouseEvent;
    import ddt.data.auctionHouse.AuctionGoodsInfo;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class AuctionBuyRightView extends Sprite implements Disposeable 
    {

        private var panel:ScrollPanel;
        private var _strips:Vector.<AuctionBuyStripView>;
        private var _selectStrip:AuctionBuyStripView;
        private var _list:VBox;
        private var _nameTxt:FilterFrameText;
        private var _bidNumberTxt:FilterFrameText;
        private var _RemainingTimeTxt:FilterFrameText;
        private var _bidpriceTxt:FilterFrameText;
        private var _statusTxt:FilterFrameText;
        private var _mouthfulTxt:FilterFrameText;
        private var _tableline:Bitmap;
        private var _tableline1:Bitmap;
        private var _tableline2:Bitmap;
        private var _tableline3:Bitmap;
        private var _tableline4:Bitmap;
        private var _tableline5:Bitmap;

        public function AuctionBuyRightView()
        {
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            var _local_1:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("asset.auctionHouse.BuyBG");
            addChild(_local_1);
            var _local_2:ScaleLeftRightImage = ComponentFactory.Instance.creatComponentByStylename("ddtauction.sellItemBG5");
            addChild(_local_2);
            var _local_3:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("asset.auctionHouse.BuyBGI");
            addChild(_local_3);
            this._nameTxt = ComponentFactory.Instance.creat("ddtauction.nameTxt");
            this._nameTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.name");
            addChild(this._nameTxt);
            this._bidNumberTxt = ComponentFactory.Instance.creat("ddtauction.bidNumerTxt");
            this._bidNumberTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.number");
            addChild(this._bidNumberTxt);
            this._bidNumberTxt.x = 275;
            this._RemainingTimeTxt = ComponentFactory.Instance.creat("ddtauction.remainingTimeTxt");
            this._RemainingTimeTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.timer");
            addChild(this._RemainingTimeTxt);
            this._RemainingTimeTxt.x = 384;
            this._bidpriceTxt = ComponentFactory.Instance.creat("ddtauction.BidPriceTxt");
            this._bidpriceTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.price");
            addChild(this._bidpriceTxt);
            this._bidpriceTxt.x = 807;
            this._statusTxt = ComponentFactory.Instance.creat("ddtauction.statusTxt");
            this._statusTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.status");
            addChild(this._statusTxt);
            this._statusTxt.x = 638;
            this._mouthfulTxt = ComponentFactory.Instance.creat("ddtauction.mouthfulTxt");
            this._mouthfulTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.mouthful");
            addChild(this._mouthfulTxt);
            this._mouthfulTxt.x = 522;
            this._tableline = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
            addChild(this._tableline);
            this._tableline.x = 289;
            this._tableline1 = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
            addChild(this._tableline1);
            this._tableline1.x = 339;
            this._tableline2 = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
            addChild(this._tableline2);
            this._tableline2.x = 501;
            this._tableline3 = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
            addChild(this._tableline3);
            this._tableline3.x = 606;
            this._tableline4 = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
            addChild(this._tableline4);
            this._tableline4.x = 739;
            this._tableline.y = (this._tableline1.y = (this._tableline2.y = (this._tableline3.y = (this._tableline4.y = 10))));
            this._list = new VBox();
            this._strips = new Vector.<AuctionBuyStripView>();
            this.panel = ComponentFactory.Instance.creat("auctionHouse.BrowseBuyScrollpanel");
            this.panel.hScrollProxy = ScrollPanel.OFF;
            this.panel.vScrollProxy = ScrollPanel.ON;
            this.panel.setView(this._list);
            addChild(this.panel);
            this.invalidatePanel();
        }

        private function addEvent():void
        {
        }

        private function removeEvent():void
        {
        }

        internal function addAuction(_arg_1:AuctionGoodsInfo):void
        {
            _arg_1.index = this._strips.length;
            var _local_2:AuctionBuyStripView = new AuctionBuyStripView();
            _local_2.info = _arg_1;
            _local_2.addEventListener(AuctionHouseEvent.SELECT_STRIP, this.__selectStrip);
            this._strips.push(_local_2);
            this._list.addChild(_local_2);
            this.invalidatePanel();
        }

        private function invalidatePanel():void
        {
            this.panel.invalidateViewport();
        }

        internal function clearList():void
        {
            this._clearItems();
            this._selectStrip = null;
            this._strips = new Vector.<AuctionBuyStripView>();
        }

        private function _clearItems():void
        {
            this._strips.splice(0, this._strips.length);
            this._list.disposeAllChildren();
            this._list.height = 0;
            this.invalidatePanel();
        }

        internal function getSelectInfo():AuctionGoodsInfo
        {
            if (this._selectStrip)
            {
                return (this._selectStrip.info);
            };
            return (null);
        }

        internal function deleteItem():void
        {
            var _local_1:int;
            while (_local_1 < this._strips.length)
            {
                if (this._selectStrip == this._strips[_local_1])
                {
                    this._selectStrip.removeEventListener(AuctionHouseEvent.SELECT_STRIP, this.__selectStrip);
                    this._selectStrip.dispose();
                    this._strips.splice(_local_1, 1);
                    this._selectStrip = null;
                    return;
                };
                _local_1++;
            };
        }

        internal function clearSelectStrip():void
        {
            var _local_1:AuctionBuyStripView;
            for each (_local_1 in this._strips)
            {
                if (this._selectStrip == _local_1)
                {
                    this._selectStrip.removeEventListener(AuctionHouseEvent.SELECT_STRIP, this.__selectStrip);
                    this._selectStrip.clearSelectStrip();
                    this._selectStrip = null;
                    break;
                };
            };
        }

        internal function updateAuction(_arg_1:AuctionGoodsInfo):void
        {
            var _local_2:AuctionBuyStripView;
            for each (_local_2 in this._strips)
            {
                if (_local_2.info.AuctionID == _arg_1.AuctionID)
                {
                    _arg_1.BagItemInfo = _local_2.info.BagItemInfo;
                    _local_2.info = _arg_1;
                    break;
                };
            };
        }

        private function __selectStrip(_arg_1:AuctionHouseEvent):void
        {
            if (this._selectStrip)
            {
                this._selectStrip.isSelect = false;
            };
            var _local_2:AuctionBuyStripView = (_arg_1.target as AuctionBuyStripView);
            _local_2.isSelect = true;
            this._selectStrip = _local_2;
            dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
        }

        public function dispose():void
        {
            var _local_1:AuctionBuyStripView;
            this.removeEvent();
            if (this.panel)
            {
                ObjectUtils.disposeObject(this.panel);
            };
            this.panel = null;
            if (this._selectStrip)
            {
                ObjectUtils.disposeObject(this._selectStrip);
            };
            this._selectStrip = null;
            if (this._list)
            {
                ObjectUtils.disposeObject(this._list);
            };
            this._list = null;
            for each (_local_1 in this._strips)
            {
                if (_local_1)
                {
                    ObjectUtils.disposeObject(_local_1);
                };
                _local_1 = null;
            };
            this._strips = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package auctionHouse.view

