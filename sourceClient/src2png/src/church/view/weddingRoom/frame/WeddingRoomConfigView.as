// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.weddingRoom.frame.WeddingRoomConfigView

package church.view.weddingRoom.frame
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import church.controller.ChurchRoomController;
    import church.model.ChurchRoomModel;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.SelectedIconButton;
    import com.pickgliss.ui.controls.TextInput;
    import com.pickgliss.ui.text.TextArea;
    import flash.geom.Point;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import ddt.manager.ChurchManager;
    import ddt.manager.SoundManager;
    import ddt.utils.FilterWordManager;
    import com.pickgliss.utils.StringUtils;
    import ddt.manager.MessageTipManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class WeddingRoomConfigView extends BaseAlerFrame 
    {

        private var _controller:ChurchRoomController;
        private var _model:ChurchRoomModel;
        private var _alertInfo:AlertInfo;
        private var _configRoomFrameTopBg:ScaleBitmapImage;
        private var _configRoomFrameBottomBg:ScaleBitmapImage;
        private var _roomNameTitle:Bitmap;
        private var _roomIntroTitle:Bitmap;
        private var _txtConfigRoomName:FilterFrameText;
        private var _chkConfigRoomPassword:SelectedIconButton;
        private var _txtConfigRoomPassword:TextInput;
        private var _txtConfigRoomIntro:TextArea;
        private var _configIntroMaxChBg:Bitmap;
        private var _roomConfigIntroMaxChLabel:FilterFrameText;
        private var _bg1:ScaleBitmapImage;
        private var _selectedIconButtonTxt:FilterFrameText;

        public function WeddingRoomConfigView()
        {
            this.initialize();
        }

        public function get controller():ChurchRoomController
        {
            return (this._controller);
        }

        public function set controller(_arg_1:ChurchRoomController):void
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
            var _local_1:Point;
            this._alertInfo = new AlertInfo();
            this._alertInfo.title = LanguageMgr.GetTranslation("church.churchScene.frame.ModifyRoomInfoFrame.titleText");
            this._alertInfo.moveEnable = false;
            info = this._alertInfo;
            this.escEnable = true;
            this._configRoomFrameTopBg = ComponentFactory.Instance.creat("church.weddingRoom.configRoomFrameTopBg");
            addToContent(this._configRoomFrameTopBg);
            this._configRoomFrameBottomBg = ComponentFactory.Instance.creat("church.weddingRoom.configRoomFrameBottomBg");
            addToContent(this._configRoomFrameBottomBg);
            this._roomNameTitle = ComponentFactory.Instance.creatBitmap("asset.church.roomCreateRoomNameTitleAsset");
            _local_1 = ComponentFactory.Instance.creat("church.room.RoomNameTitlePos");
            this._roomNameTitle.x = _local_1.x;
            this._roomNameTitle.y = _local_1.y;
            addToContent(this._roomNameTitle);
            this._roomIntroTitle = ComponentFactory.Instance.creatBitmap("asset.church.roomCreateIntroAsset");
            var _local_2:Point = ComponentFactory.Instance.creatCustomObject("church.room.CreateIntroPos");
            this._roomIntroTitle.x = _local_2.x;
            this._roomIntroTitle.y = _local_2.y;
            addToContent(this._roomIntroTitle);
            this._txtConfigRoomName = ComponentFactory.Instance.creat("church.weddingRoom.txtConfigRoomName");
            this._bg1 = ComponentFactory.Instance.creat("church.main.txtConfigRoomNameBG");
            addToContent(this._bg1);
            addToContent(this._txtConfigRoomName);
            this._chkConfigRoomPassword = ComponentFactory.Instance.creat("church.weddingRoom.chkConfigRoomPassword");
            addToContent(this._chkConfigRoomPassword);
            this._selectedIconButtonTxt = ComponentFactory.Instance.creat("church.main.WeddingRoomConfigView.SelectedIconButtonTxt");
            this._selectedIconButtonTxt.text = LanguageMgr.GetTranslation("church.main.WeddingRoomCreateView.SelectedIconButtonTxt1.text");
            this._chkConfigRoomPassword.addChild(this._selectedIconButtonTxt);
            this._txtConfigRoomPassword = ComponentFactory.Instance.creat("church.weddingRoom.txtConfigRoomPassword");
            this._txtConfigRoomPassword.displayAsPassword = true;
            this._txtConfigRoomPassword.enable = false;
            this._txtConfigRoomPassword.maxChars = 6;
            addToContent(this._txtConfigRoomPassword);
            this._txtConfigRoomIntro = ComponentFactory.Instance.creat("church.weddingRoom.txtConfigRoomIntro");
            this._txtConfigRoomIntro.maxChars = 300;
            addToContent(this._txtConfigRoomIntro);
            this._roomConfigIntroMaxChLabel = ComponentFactory.Instance.creat("church.weddingRoom.roomConfigIntroMaxChLabelAsset");
            addToContent(this._roomConfigIntroMaxChLabel);
            this.getRoomInfo();
        }

        private function setEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
            this._chkConfigRoomPassword.addEventListener(MouseEvent.CLICK, this.onRoomPasswordCheck);
            this._txtConfigRoomIntro.addEventListener(Event.CHANGE, this.onRemarkChange);
        }

        private function getRoomInfo():void
        {
            this._txtConfigRoomName.text = ChurchManager.instance.currentRoom.roomName;
            this._txtConfigRoomIntro.text = ChurchManager.instance.currentRoom.discription;
            this.onRemarkChange();
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
            if ((!(this.checkRoom())))
            {
                return;
            };
            var _local_1:String = FilterWordManager.filterWrod(this._txtConfigRoomIntro.text);
            ChurchManager.instance.currentRoom.roomName = this._txtConfigRoomName.text;
            ChurchManager.instance.currentRoom.discription = _local_1;
            this._controller.modifyDiscription(this._txtConfigRoomName.text, this._chkConfigRoomPassword.selected, this._txtConfigRoomPassword.text, _local_1);
            this.dispose();
        }

        private function checkRoom():Boolean
        {
            if (StringUtils.isEmpty(this._txtConfigRoomName.text))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.name"));
                return (false);
            };
            if (FilterWordManager.isGotForbiddenWords(this._txtConfigRoomName.text, "name"))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.string"));
                return (false);
            };
            if (((this._chkConfigRoomPassword.selected) && (FilterWordManager.IsNullorEmpty(this._txtConfigRoomPassword.text))))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.set"));
                this._txtConfigRoomPassword.setFocus();
                return (false);
            };
            return (true);
        }

        private function onRoomPasswordCheck(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._txtConfigRoomPassword.enable = this._chkConfigRoomPassword.selected;
            if (this._txtConfigRoomPassword.enable)
            {
                this._txtConfigRoomPassword.setFocus();
            }
            else
            {
                this._txtConfigRoomPassword.text = "";
            };
        }

        private function onRemarkChange(_arg_1:Event=null):void
        {
            this._roomConfigIntroMaxChLabel.text = ((LanguageMgr.GetTranslation("church.churchScene.frame.ModifyDiscriptionFrame.spare") + String((this._txtConfigRoomIntro.maxChars - this._txtConfigRoomIntro.text.length))) + LanguageMgr.GetTranslation("church.churchScene.frame.ModifyDiscriptionFrame.word"));
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function removeView():void
        {
            this._alertInfo = null;
            if (this._configRoomFrameTopBg)
            {
                if (this._configRoomFrameTopBg.parent)
                {
                    this._configRoomFrameTopBg.parent.removeChild(this._configRoomFrameTopBg);
                };
                this._configRoomFrameTopBg.dispose();
            };
            this._configRoomFrameTopBg = null;
            if (this._configRoomFrameBottomBg)
            {
                if (this._configRoomFrameBottomBg.parent)
                {
                    this._configRoomFrameBottomBg.parent.removeChild(this._configRoomFrameBottomBg);
                };
                this._configRoomFrameBottomBg.dispose();
            };
            this._configRoomFrameBottomBg = null;
            if (this._roomNameTitle)
            {
                if (this._roomNameTitle.parent)
                {
                    this._roomNameTitle.parent.removeChild(this._roomNameTitle);
                };
                this._roomNameTitle.bitmapData.dispose();
                this._roomNameTitle.bitmapData = null;
            };
            this._roomNameTitle = null;
            if (this._roomIntroTitle)
            {
                if (this._roomIntroTitle.parent)
                {
                    this._roomIntroTitle.parent.removeChild(this._roomIntroTitle);
                };
                this._roomIntroTitle.bitmapData.dispose();
                this._roomIntroTitle.bitmapData = null;
            };
            this._roomIntroTitle = null;
            if (this._txtConfigRoomName)
            {
                if (this._txtConfigRoomName.parent)
                {
                    this._txtConfigRoomName.parent.removeChild(this._txtConfigRoomName);
                };
                this._txtConfigRoomName.dispose();
            };
            this._txtConfigRoomName = null;
            if (this._bg1)
            {
                ObjectUtils.disposeObject(this._bg1);
            };
            this._bg1 = null;
            if (this._chkConfigRoomPassword)
            {
                if (this._chkConfigRoomPassword.parent)
                {
                    this._chkConfigRoomPassword.parent.removeChild(this._chkConfigRoomPassword);
                };
                this._chkConfigRoomPassword.dispose();
            };
            this._chkConfigRoomPassword = null;
            if (this._selectedIconButtonTxt)
            {
                if (this._selectedIconButtonTxt.parent)
                {
                    this._selectedIconButtonTxt.parent.removeChild(this._selectedIconButtonTxt);
                };
                this._selectedIconButtonTxt.dispose();
            };
            this._selectedIconButtonTxt = null;
            if (this._txtConfigRoomPassword)
            {
                if (this._txtConfigRoomPassword.parent)
                {
                    this._txtConfigRoomPassword.parent.removeChild(this._txtConfigRoomPassword);
                };
                this._txtConfigRoomPassword.dispose();
            };
            this._txtConfigRoomPassword = null;
            ObjectUtils.disposeObject(this._txtConfigRoomIntro);
            this._txtConfigRoomIntro = null;
            if (this._roomConfigIntroMaxChLabel)
            {
                if (this._roomConfigIntroMaxChLabel.parent)
                {
                    this._roomConfigIntroMaxChLabel.parent.removeChild(this._roomConfigIntroMaxChLabel);
                };
                this._roomConfigIntroMaxChLabel.dispose();
            };
            this._roomConfigIntroMaxChLabel = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
            dispatchEvent(new Event(Event.CLOSE));
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
            if (this._chkConfigRoomPassword)
            {
                this._chkConfigRoomPassword.removeEventListener(MouseEvent.CLICK, this.onRoomPasswordCheck);
            };
            if (this._txtConfigRoomIntro)
            {
                this._txtConfigRoomIntro.removeEventListener(Event.CHANGE, this.onRemarkChange);
            };
        }

        override public function dispose():void
        {
            this.removeEvent();
            this.removeView();
            super.dispose();
        }


    }
}//package church.view.weddingRoom.frame

