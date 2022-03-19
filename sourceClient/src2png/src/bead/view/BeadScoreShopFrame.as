// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bead.view.BeadScoreShopFrame

package bead.view
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.ScaleLeftRightImage;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.data.player.SelfInfo;
    import ddt.manager.PlayerManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import bead.BeadManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.events.PlayerPropertyEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.LayerManager;

    public class BeadScoreShopFrame extends Frame 
    {

        private var _bg:Image;
        private var _bottomBg:Scale9CornerImage;
        private var _myScorePic:Bitmap;
        private var _pageInput:ScaleLeftRightImage;
        private var _pageBg:ScaleLeftRightImage;
        private var _firstPageTurnBtn:BaseButton;
        private var _leftPageTurnBtn:BaseButton;
        private var _rightPageTurnBtn:BaseButton;
        private var _lastPageTurnBtn:BaseButton;
        private var _returnBtn:BaseButton;
        private var _scoreTxt:FilterFrameText;
        private var _pageTxt:FilterFrameText;
        private var _beadShopCellList:BeadShopCellList;
        private var _self:SelfInfo;
        private var _curPage:int;
        private var _totalPage:int;

        public function BeadScoreShopFrame()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            this._self = PlayerManager.Instance.Self;
            titleText = LanguageMgr.GetTranslation("beadSystem.bead.scoreShopFrame.title");
            this._bg = ComponentFactory.Instance.creatComponentByStylename("beadSystem.scoreShop.bg");
            this._bottomBg = ComponentFactory.Instance.creatComponentByStylename("bead.scoreShop.bottomBg");
            this._myScorePic = ComponentFactory.Instance.creatBitmap("asset.beadSystem.myScorePic");
            PositionUtils.setPos(this._myScorePic, "bead.myScorePicPos");
            this._pageBg = ComponentFactory.Instance.creatComponentByStylename("core.newScaleLeftRightImage.ScaleLeftRightImage3");
            PositionUtils.setPos(this._pageBg, "bead.shop.pageBgPos");
            this._firstPageTurnBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.scoreShop.firstPageTurnBtn");
            this._leftPageTurnBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.scoreShop.leftPageTurnBtn");
            this._rightPageTurnBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.scoreShop.rightPageTurnBtn");
            this._lastPageTurnBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.scoreShop.lastPageTurnBtn");
            this._returnBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.scoreShop.returnBtn");
            this._pageInput = ComponentFactory.Instance.creatComponentByStylename("beadSystem.CurrentPageInput");
            this._scoreTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.scoreShop.scoreTxt");
            this.refreshScore(null);
            this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.scoreShop.pageTxt");
            this._curPage = 1;
            this._totalPage = Math.ceil((BeadManager.instance.scoreShopItemList.length / BeadShopCellList.TotalCount));
            this.refreshPageTxt();
            this._beadShopCellList = ComponentFactory.Instance.creatCustomObject("beadShopCellList");
            this._beadShopCellList.show(this._curPage);
            addToContent(this._bg);
            addToContent(this._bottomBg);
            addToContent(this._pageBg);
            addToContent(this._pageInput);
            addToContent(this._myScorePic);
            addToContent(this._firstPageTurnBtn);
            addToContent(this._leftPageTurnBtn);
            addToContent(this._rightPageTurnBtn);
            addToContent(this._lastPageTurnBtn);
            addToContent(this._returnBtn);
            addToContent(this._scoreTxt);
            addToContent(this._pageTxt);
            addToContent(this._beadShopCellList);
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this._response);
            this._self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.refreshScore, false, 0, true);
            this._firstPageTurnBtn.addEventListener(MouseEvent.CLICK, this.gotoPageHandler, false, 0, true);
            this._leftPageTurnBtn.addEventListener(MouseEvent.CLICK, this.gotoPageHandler, false, 0, true);
            this._rightPageTurnBtn.addEventListener(MouseEvent.CLICK, this.gotoPageHandler, false, 0, true);
            this._lastPageTurnBtn.addEventListener(MouseEvent.CLICK, this.gotoPageHandler, false, 0, true);
            this._returnBtn.addEventListener(MouseEvent.CLICK, this.returnHandler, false, 0, true);
        }

        private function gotoPageHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseButton = (_arg_1.currentTarget as BaseButton);
            switch (_local_2)
            {
                case this._firstPageTurnBtn:
                    this._curPage = 1;
                    break;
                case this._leftPageTurnBtn:
                    this._curPage--;
                    this._curPage = ((this._curPage < 1) ? this._totalPage : this._curPage);
                    break;
                case this._rightPageTurnBtn:
                    this._curPage++;
                    this._curPage = ((this._curPage > this._totalPage) ? 1 : this._curPage);
                    break;
                case this._lastPageTurnBtn:
                    this._curPage = this._totalPage;
                    break;
            };
            this.refreshPageTxt();
            this._beadShopCellList.show(this._curPage);
        }

        private function returnHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.closeThis();
        }

        private function refreshPageTxt():void
        {
            this._pageTxt.text = ((this._curPage + "/") + this._totalPage);
        }

        private function refreshScore(_arg_1:PlayerPropertyEvent):void
        {
            this._scoreTxt.text = this._self.beadScore.toString();
        }

        private function _response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                this.closeThis();
            };
        }

        private function closeThis():void
        {
            ObjectUtils.disposeObject(this);
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this._response);
            this._self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.refreshScore);
            this._firstPageTurnBtn.removeEventListener(MouseEvent.CLICK, this.gotoPageHandler);
            this._leftPageTurnBtn.removeEventListener(MouseEvent.CLICK, this.gotoPageHandler);
            this._rightPageTurnBtn.removeEventListener(MouseEvent.CLICK, this.gotoPageHandler);
            this._lastPageTurnBtn.removeEventListener(MouseEvent.CLICK, this.gotoPageHandler);
            this._returnBtn.removeEventListener(MouseEvent.CLICK, this.returnHandler);
        }

        override public function dispose():void
        {
            this.removeEvent();
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._bottomBg)
            {
                ObjectUtils.disposeObject(this._bottomBg);
            };
            this._bottomBg = null;
            if (this._pageBg)
            {
                ObjectUtils.disposeObject(this._pageBg);
            };
            this._pageBg = null;
            if (this._pageInput)
            {
                ObjectUtils.disposeObject(this._pageInput);
            };
            this._pageInput = null;
            if (this._firstPageTurnBtn)
            {
                ObjectUtils.disposeObject(this._firstPageTurnBtn);
            };
            this._firstPageTurnBtn = null;
            if (this._leftPageTurnBtn)
            {
                ObjectUtils.disposeObject(this._leftPageTurnBtn);
            };
            this._leftPageTurnBtn = null;
            if (this._rightPageTurnBtn)
            {
                ObjectUtils.disposeObject(this._rightPageTurnBtn);
            };
            this._rightPageTurnBtn = null;
            if (this._lastPageTurnBtn)
            {
                ObjectUtils.disposeObject(this._lastPageTurnBtn);
            };
            this._lastPageTurnBtn = null;
            if (this._returnBtn)
            {
                ObjectUtils.disposeObject(this._returnBtn);
            };
            this._returnBtn = null;
            if (this._scoreTxt)
            {
                ObjectUtils.disposeObject(this._scoreTxt);
            };
            this._scoreTxt = null;
            if (this._pageTxt)
            {
                ObjectUtils.disposeObject(this._pageTxt);
            };
            this._pageTxt = null;
            if (this._beadShopCellList)
            {
                ObjectUtils.disposeObject(this._beadShopCellList);
            };
            this._beadShopCellList = null;
            super.dispose();
        }


    }
}//package bead.view

