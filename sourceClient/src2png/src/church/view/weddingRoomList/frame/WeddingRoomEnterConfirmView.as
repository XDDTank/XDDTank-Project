// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.weddingRoomList.frame.WeddingRoomEnterConfirmView

package church.view.weddingRoomList.frame
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import church.controller.ChurchRoomListController;
    import ddt.data.ChurchRoomInfo;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.text.TextArea;
    import flash.display.Sprite;
    import ddt.manager.TimeManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.ui.LayerManager;

    public class WeddingRoomEnterConfirmView extends BaseAlerFrame 
    {

        private var _controller:ChurchRoomListController;
        private var _churchRoomInfo:ChurchRoomInfo;
        private var _bg:Bitmap;
        private var _flower:Bitmap;
        private var _bmpLine1:Bitmap;
        private var _imgLine3:Image;
        private var _imgLine4:Image;
        private var _imgLine5:Image;
        private var _roomNameText:FilterFrameText;
        private var _groomText:FilterFrameText;
        private var _grideText:FilterFrameText;
        private var _countText:FilterFrameText;
        private var _spareTime:FilterFrameText;
        private var _alertInfo:AlertInfo;
        private var _txtDescription:TextArea;
        private var _textDescriptionBg:Sprite;
        private var _weddingRoomEnterInputPasswordView:WeddingRoomEnterInputPasswordView;

        public function WeddingRoomEnterConfirmView()
        {
            this.initialize();
        }

        protected function initialize():void
        {
            this.setView();
            this.setEvent();
        }

        public function set controller(_arg_1:ChurchRoomListController):void
        {
            this._controller = _arg_1;
        }

        public function set churchRoomInfo(_arg_1:ChurchRoomInfo):void
        {
            this._churchRoomInfo = _arg_1;
            this._roomNameText.text = this._churchRoomInfo.roomName;
            this._groomText.text = this._churchRoomInfo.groomName;
            this._grideText.text = this._churchRoomInfo.brideName;
            this._countText.text = this._churchRoomInfo.currentNum.toString();
            var _local_2:int = int((((this._churchRoomInfo.valideTimes * 60) - ((TimeManager.Instance.Now().time / (1000 * 60)) - (this._churchRoomInfo.creactTime.time / (1000 * 60)))) / 60));
            if (_local_2 >= 0)
            {
                _local_2 = Math.floor(_local_2);
            }
            else
            {
                _local_2 = Math.ceil(_local_2);
            };
            var _local_3:int = (int(((this._churchRoomInfo.valideTimes * 60) - ((TimeManager.Instance.Now().time / (1000 * 60)) - (this._churchRoomInfo.creactTime.time / (1000 * 60))))) % 60);
            if (((_local_2 < 0) || (_local_3 < 0)))
            {
                this._spareTime.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.time");
            }
            else
            {
                this._spareTime.text = (((_local_2.toString() + LanguageMgr.GetTranslation("hours")) + _local_3.toString()) + LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.minute"));
            };
            this._txtDescription.text = this._churchRoomInfo.discription;
        }

        private function setView():void
        {
            this._alertInfo = new AlertInfo();
            this._alertInfo.title = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.titleText");
            this._alertInfo.moveEnable = false;
            this._alertInfo.submitLabel = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.into");
            info = this._alertInfo;
            this.escEnable = true;
            this._flower = ComponentFactory.Instance.creatBitmap("asset.churchroomlist.flowers");
            PositionUtils.setPos(this._flower, "WeddingRoomEnterConfirmView.titleFlowers.pos");
            addToContent(this._flower);
            this._bg = ComponentFactory.Instance.creatBitmap("church.main.roomEnterConfirmBg");
            addToContent(this._bg);
            this._roomNameText = ComponentFactory.Instance.creat("church.main.roomEnterRoomNameTextAsset");
            addToContent(this._roomNameText);
            this._groomText = ComponentFactory.Instance.creat("church.main.roomEnterGroomTextAsset");
            addToContent(this._groomText);
            this._grideText = ComponentFactory.Instance.creat("church.main.roomEnterBrideTextAsset");
            addToContent(this._grideText);
            this._countText = ComponentFactory.Instance.creat("church.main.roomEnterCountTextAsset");
            addToContent(this._countText);
            this._spareTime = ComponentFactory.Instance.creat("church.main.roomEnterSpareTimeTextAsset");
            addToContent(this._spareTime);
            this._txtDescription = ComponentFactory.Instance.creat("church.view.weddingRoomList.frame.txtRoomEnterDescriptionAsset");
            addToContent(this._txtDescription);
        }

        private function setEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
        }

        private function onFrameResponse(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    SoundManager.instance.play("008");
                    this.dispose();
                    return;
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    this.enterRoomConfirm();
                    return;
            };
        }

        private function enterRoomConfirm():void
        {
            SoundManager.instance.play("008");
            if (this._churchRoomInfo.isLocked)
            {
                this._weddingRoomEnterInputPasswordView = ComponentFactory.Instance.creat("church.main.weddingRoomList.WeddingRoomEnterInputPasswordView");
                this._weddingRoomEnterInputPasswordView.churchRoomInfo = this._churchRoomInfo;
                this._weddingRoomEnterInputPasswordView.submitButtonEnable = false;
                this._weddingRoomEnterInputPasswordView.show();
            }
            else
            {
                SocketManager.Instance.out.sendEnterRoom(this._churchRoomInfo.id, "");
            };
            this.dispose();
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
        }

        private function removeView():void
        {
            if (this._flower)
            {
                if (this._flower.parent)
                {
                    this._flower.parent.removeChild(this._flower);
                };
                this._flower.bitmapData.dispose();
                this._flower.bitmapData = null;
            };
            this._flower = null;
            if (this._bg)
            {
                if (this._bg.parent)
                {
                    this._bg.parent.removeChild(this._bg);
                };
            };
            this._bg = null;
            if (this._roomNameText)
            {
                if (this._roomNameText.parent)
                {
                    this._roomNameText.parent.removeChild(this._roomNameText);
                };
                this._roomNameText.dispose();
            };
            this._roomNameText = null;
            if (this._groomText)
            {
                if (this._groomText.parent)
                {
                    this._groomText.parent.removeChild(this._groomText);
                };
                this._groomText.dispose();
            };
            this._groomText = null;
            if (this._grideText)
            {
                if (this._grideText.parent)
                {
                    this._grideText.parent.removeChild(this._grideText);
                };
                this._grideText.dispose();
            };
            this._grideText = null;
            if (this._countText)
            {
                if (this._countText.parent)
                {
                    this._countText.parent.removeChild(this._countText);
                };
                this._countText.dispose();
            };
            this._countText = null;
            if (this._spareTime)
            {
                if (this._spareTime.parent)
                {
                    this._spareTime.parent.removeChild(this._spareTime);
                };
                this._spareTime.dispose();
            };
            this._spareTime = null;
            this._alertInfo = null;
            this._txtDescription = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeEvent();
            this.removeView();
        }


    }
}//package church.view.weddingRoomList.frame

