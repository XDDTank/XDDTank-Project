// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.weddingRoom.frame.WeddingRoomGiftFrameView

package church.view.weddingRoom.frame
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.PlayerManager;
    import ddt.manager.SoundManager;
    import ddt.manager.ChurchManager;
    import flash.events.Event;
    import com.pickgliss.ui.LayerManager;

    public class WeddingRoomGiftFrameView extends BaseAlerFrame 
    {

        private static const LEAST_GIFT_MONEY:int = 200;

        private var _bg:Bitmap;
        private var _alertInfo:AlertInfo;
        private var _txtMoney:FilterFrameText;
        private var _contentText:FilterFrameText;
        private var _noticeText:FilterFrameText;

        public function WeddingRoomGiftFrameView()
        {
            this.initialize();
        }

        protected function initialize():void
        {
            this.setView();
            this.setEvent();
        }

        private function setView():void
        {
            cancelButtonStyle = "core.simplebt";
            submitButtonStyle = "core.simplebt";
            this._alertInfo = new AlertInfo();
            this._alertInfo.title = LanguageMgr.GetTranslation("church.room.giftFrameBgAssetForGuest.titleText");
            this._alertInfo.moveEnable = false;
            info = this._alertInfo;
            this.escEnable = true;
            this._bg = ComponentFactory.Instance.creatBitmap("asset.church.room.giftFrameBgAssetForGuest");
            PositionUtils.setPos(this._bg, "asset.church.room.giftFrameBgAsset.bg.pos");
            addToContent(this._bg);
            this._contentText = ComponentFactory.Instance.creat("church.room.frame.WeddingRoomGiftFrameView.contentText");
            this._contentText.text = LanguageMgr.GetTranslation("church.room.frame.WeddingRoomGiftFrameView.contentText");
            addToContent(this._contentText);
            this._noticeText = ComponentFactory.Instance.creat("church.room.frame.WeddingRoomGiftFrameView.noticeText");
            this._noticeText.text = LanguageMgr.GetTranslation("church.room.frame.WeddingRoomGiftFrameView.noticeText", LEAST_GIFT_MONEY);
            addToContent(this._noticeText);
            this._txtMoney = ComponentFactory.Instance.creat("church.weddingRoom.frame.WeddingRoomGiftFrameMoneyTextAsset");
            this._txtMoney.selectable = false;
            addToContent(this._txtMoney);
        }

        public function set txtMoney(_arg_1:String):void
        {
            this._txtMoney.text = _arg_1;
        }

        private function setEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
        }

        private function checkMoney():void
        {
            var _local_1:uint = uint(Math.floor((PlayerManager.Instance.Self.Money / LEAST_GIFT_MONEY)));
            var _local_2:uint = uint(((Math.ceil((Number(this._txtMoney.text) / LEAST_GIFT_MONEY)) == 0) ? 1 : uint(Math.ceil((Number(this._txtMoney.text) / LEAST_GIFT_MONEY)))));
            if (_local_2 >= _local_1)
            {
                _local_2 = _local_1;
            };
            this._txtMoney.text = String((_local_2 * LEAST_GIFT_MONEY));
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
                    this.dispose();
                    ChurchManager.instance.dispatchEvent(new Event(ChurchManager.SUBMIT_REFUND));
                    return;
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function removeView():void
        {
            this._alertInfo = null;
            if (this._bg)
            {
                if (this._bg.parent)
                {
                    this._bg.parent.removeChild(this._bg);
                };
                this._bg.bitmapData.dispose();
                this._bg.bitmapData = null;
            };
            this._bg = null;
            if (this._contentText)
            {
                if (this._contentText.parent)
                {
                    this._contentText.parent.removeChild(this._contentText);
                };
                this._contentText.dispose();
            };
            this._contentText = null;
            if (this._noticeText)
            {
                if (this._noticeText.parent)
                {
                    this._txtMoney.parent.removeChild(this._noticeText);
                };
                this._noticeText.dispose();
            };
            this._noticeText = null;
            if (this._txtMoney)
            {
                if (this._txtMoney.parent)
                {
                    this._txtMoney.parent.removeChild(this._txtMoney);
                };
                this._txtMoney.dispose();
            };
            this._txtMoney = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
            dispatchEvent(new Event(Event.CLOSE));
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeEvent();
            this.removeView();
        }


    }
}//package church.view.weddingRoom.frame

