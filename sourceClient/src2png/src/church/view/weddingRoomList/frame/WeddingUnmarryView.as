// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.weddingRoomList.frame.WeddingUnmarryView

package church.view.weddingRoomList.frame
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import church.controller.ChurchRoomListController;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import church.view.weddingRoomList.CalculateDate;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.LeavePageManager;
    import baglocked.BaglockedManager;
    import ddt.command.QuickBuyFrame;
    import ddt.data.EquipType;
    import com.pickgliss.ui.LayerManager;

    public class WeddingUnmarryView extends BaseAlerFrame 
    {

        private var _controller:ChurchRoomListController;
        private var _alertInfo:AlertInfo;
        private var _text1:FilterFrameText;
        private var _text2:FilterFrameText;
        private var _text3:FilterFrameText;
        private var _bg:Bitmap;
        private var _bgTxt:FilterFrameText;
        private var _titleBg:Bitmap;
        private var _needMoney:int;
        private var _textBG:Scale9CornerImage;
        private var _textI:FilterFrameText;
        private var _textII:FilterFrameText;

        public function WeddingUnmarryView()
        {
            this.initialize();
        }

        public function set controller(_arg_1:ChurchRoomListController):void
        {
            this._controller = _arg_1;
        }

        protected function initialize():void
        {
            this.setView();
            this.setEvent();
        }

        private function setView():void
        {
            this._alertInfo = new AlertInfo();
            this._alertInfo.title = "离婚";
            this._alertInfo.moveEnable = false;
            this.escEnable = true;
            info = this._alertInfo;
            this._bg = ComponentFactory.Instance.creatBitmap("asset.church.UnmarryAsset");
            addToContent(this._bg);
            this._bgTxt = ComponentFactory.Instance.creatComponentByStylename("church.view.weddingRoomList.WeddingUnmarryViewT4");
            this._bgTxt.text = LanguageMgr.GetTranslation("church.main.WeddingUnmarryView.text3.text");
            addToContent(this._bgTxt);
            this._textBG = ComponentFactory.Instance.creatComponentByStylename("church.main.WeddingUnmarryView.textBG");
            addToContent(this._textBG);
            this._textI = ComponentFactory.Instance.creatComponentByStylename("church.main.WeddingUnmarryView.text1");
            this._textI.text = LanguageMgr.GetTranslation("church.main.WeddingUnmarryView.text1.text");
            addToContent(this._textI);
            this._textII = ComponentFactory.Instance.creatComponentByStylename("church.main.WeddingUnmarryView.text2");
            this._textII.text = LanguageMgr.GetTranslation("church.main.WeddingUnmarryView.text2.text");
            addToContent(this._textII);
            this._text1 = ComponentFactory.Instance.creatComponentByStylename("church.view.weddingRoomList.WeddingUnmarryViewT1");
            addToContent(this._text1);
            this._text2 = ComponentFactory.Instance.creatComponentByStylename("church.view.weddingRoomList.WeddingUnmarryViewT2");
            addToContent(this._text2);
            this._text3 = ComponentFactory.Instance.creatComponentByStylename("church.view.weddingRoomList.WeddingUnmarryViewT3");
            this._text3.htmlText = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.note", CalculateDate.getDivoceMoney2());
            addToContent(this._text3);
        }

        public function setText(_arg_1:String="", _arg_2:String=""):void
        {
            this._text1.htmlText = _arg_1;
            this._text2.htmlText = _arg_2;
        }

        private function removeView():void
        {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            if (this._bgTxt)
            {
                ObjectUtils.disposeObject(this._bgTxt);
            };
            this._bgTxt = null;
            if (this._textBG)
            {
                ObjectUtils.disposeObject(this._textBG);
            };
            this._textBG = null;
            if (this._textI)
            {
                ObjectUtils.disposeObject(this._textI);
            };
            this._textI = null;
            if (this._textII)
            {
                ObjectUtils.disposeObject(this._textII);
            };
            this._textII = null;
            if (this._text1)
            {
                this._text1.dispose();
            };
            this._text1 = null;
            if (this._text2)
            {
                this._text2.dispose();
            };
            this._text2 = null;
        }

        private function setEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
        }

        private function onFrameResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.dispose();
                    return;
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    this.confirmSubmit();
                    return;
            };
        }

        private function confirmSubmit():void
        {
            if (PlayerManager.Instance.Self.totalMoney < this._needMoney)
            {
                LeavePageManager.showFillFrame();
                return;
            };
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            this._controller.unmarry();
            this.dispose();
        }

        private function _responseV(_arg_1:FrameEvent):void
        {
            var _local_2:QuickBuyFrame;
            SoundManager.instance.play("008");
            (_arg_1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE, this._responseV);
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                _local_2 = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
                _local_2.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
                _local_2.itemID = EquipType.GOLD_BOX;
                LayerManager.Instance.addToLayer(_local_2, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            };
            ObjectUtils.disposeObject(_arg_1.currentTarget);
        }

        public function show(_arg_1:int):void
        {
            this._needMoney = _arg_1;
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeEvent();
            this.removeView();
        }


    }
}//package church.view.weddingRoomList.frame

