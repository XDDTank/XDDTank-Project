// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.DefyAfficheViewFrame

package game.view
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.controls.TextButton;
    import room.model.RoomInfo;
    import com.pickgliss.ui.controls.TextInput;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.utils.FilterWordManager;
    import ddt.manager.MessageTipManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.SocketManager;
    import flash.events.MouseEvent;
    import ddt.manager.LeavePageManager;
    import flash.events.Event;
    import ddt.data.player.SelfInfo;
    import ddt.manager.PathManager;
    import ddt.manager.ExternalInterfaceManager;
    import ddt.manager.ServerManager;
    import com.pickgliss.ui.ComponentFactory;

    public class DefyAfficheViewFrame extends Frame 
    {

        private static const ANNOUNCEMENT_FEE:int = 50;

        private var _bg:ScaleBitmapImage;
        private var _defyAffichebtn:TextButton;
        private var _defyAffichebtn1:TextButton;
        private var _roomInfo:RoomInfo;
        private var _str:String;
        private var _textInput:TextInput;
        private var _titText:FilterFrameText;
        private var _titleInfoText:FilterFrameText;

        public function DefyAfficheViewFrame()
        {
            this.initView();
            this.initEvent();
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            this._bg = null;
            this._defyAffichebtn = null;
            this._defyAffichebtn1 = null;
            this._textInput = null;
            this._titText = null;
            this._titleInfoText = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function inputCheck():Boolean
        {
            if (this._textInput.text != "")
            {
                if (FilterWordManager.isGotForbiddenWords(this._textInput.text, "name"))
                {
                    MessageTipManager.getInstance().show("公告中包含非法字符");
                    return (false);
                };
            };
            return (true);
        }

        public function set roomInfo(_arg_1:RoomInfo):void
        {
            this._roomInfo = _arg_1;
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function __alertSendDefy(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame;
            _arg_1.currentTarget.removeEventListener(FrameEvent.RESPONSE, this.__alertSendDefy);
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                    if (PlayerManager.Instance.Self.totalMoney < ANNOUNCEMENT_FEE)
                    {
                        _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.point"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.BLCAK_BLOCKGOUND);
                        _local_2.moveEnable = false;
                        _local_2.addEventListener(FrameEvent.RESPONSE, this.__leaveToFill);
                        return;
                    };
                    this.handleString();
                    this._str = (this._str + this._textInput.text);
                    SocketManager.Instance.out.sendDefyAffiche(this._str);
                    this.dispose();
                    return;
            };
        }

        private function __cancelClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.dispose();
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    SoundManager.instance.play("008");
                    this.dispose();
                    return;
            };
        }

        private function __leaveToFill(_arg_1:FrameEvent):void
        {
            _arg_1.currentTarget.removeEventListener(FrameEvent.RESPONSE, this.__alertSendDefy);
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                    LeavePageManager.leaveToFillPath();
                    return;
            };
        }

        private function __okClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if ((!(this.inputCheck())))
            {
                return;
            };
            var _local_2:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.DefyAfficheView.hint", ANNOUNCEMENT_FEE), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.BLCAK_BLOCKGOUND);
            _local_2.moveEnable = false;
            _local_2.addEventListener(FrameEvent.RESPONSE, this.__alertSendDefy);
        }

        private function __texeInput(_arg_1:Event):void
        {
            var _local_2:String = String((30 - this._textInput.text.length));
            this._titText.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.afficheTitText", _local_2);
        }

        private function handleString():void
        {
            var _local_1:int;
            this._str = "";
            this._str = (("[" + PlayerManager.Instance.Self.NickName) + "]");
            this._str = (this._str + LanguageMgr.GetTranslation("tank.view.DefyAfficheView.afficheCaput"));
            if (this._roomInfo.defyInfo)
            {
                _local_1 = 0;
                while (_local_1 < this._roomInfo.defyInfo[1].length)
                {
                    this._str = (this._str + (("[" + this._roomInfo.defyInfo[1][_local_1]) + "]"));
                    _local_1++;
                };
            };
            this._str = (this._str + LanguageMgr.GetTranslation("tank.view.DefyAfficheView.afficheLast"));
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._textInput.textField.addEventListener(Event.CHANGE, this.__texeInput);
            this._defyAffichebtn.addEventListener(MouseEvent.CLICK, this.__okClick);
            this._defyAffichebtn1.addEventListener(MouseEvent.CLICK, this.__cancelClick);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._defyAffichebtn.removeEventListener(MouseEvent.CLICK, this.__okClick);
            this._defyAffichebtn1.removeEventListener(MouseEvent.CLICK, this.__cancelClick);
        }

        private function initView():void
        {
            var _local_1:SelfInfo;
            if (PathManager.solveExternalInterfaceEnabel())
            {
                _local_1 = PlayerManager.Instance.Self;
                ExternalInterfaceManager.sendToAgent(10, _local_1.ID, _local_1.NickName, ServerManager.Instance.zoneName);
            };
            titleText = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.affiche");
            this._bg = ComponentFactory.Instance.creatComponentByStylename("game.view.DefyAfficheViewFrame.bg");
            addToContent(this._bg);
            this._titText = ComponentFactory.Instance.creatComponentByStylename("game.view.titleText");
            this._titText.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.afficheTitText", "12");
            addToContent(this._titText);
            this._titleInfoText = ComponentFactory.Instance.creatComponentByStylename("game.view.titleInfoText");
            this._titleInfoText.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.afficheInfoText", ANNOUNCEMENT_FEE);
            addToContent(this._titleInfoText);
            this._textInput = ComponentFactory.Instance.creatComponentByStylename("game.defyAfficheTextInput");
            this._textInput.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.afficheInfo");
            addToContent(this._textInput);
            this._defyAffichebtn = ComponentFactory.Instance.creatComponentByStylename("game.defyAffichebtn");
            this._defyAffichebtn.text = LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm");
            addToContent(this._defyAffichebtn);
            this._defyAffichebtn1 = ComponentFactory.Instance.creatComponentByStylename("game.defyAffichebtn1");
            this._defyAffichebtn1.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.cancel");
            addToContent(this._defyAffichebtn1);
        }


    }
}//package game.view

