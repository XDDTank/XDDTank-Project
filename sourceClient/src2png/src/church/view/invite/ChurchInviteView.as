// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.invite.ChurchInviteView

package church.view.invite
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.controls.ListPanel;
    import com.pickgliss.ui.controls.SelectedTextButton;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import invite.data.InvitePlayerInfo;
    import ddt.data.player.PlayerInfo;
    import ddt.data.player.ConsortiaPlayerInfo;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ChurchInviteView extends BaseAlerFrame 
    {

        private var _bg:Scale9CornerImage;
        private var _itemBG:MutipleImage;
        private var _controller:ChurchInviteController;
        private var _model:ChurchInviteModel;
        private var _alertInfo:AlertInfo;
        private var _currentTab:int;
        private var _refleshCount:int;
        private var _listPanel:ListPanel;
        private var _inviteFriendBtn:SelectedTextButton;
        private var _inviteConsortiaBtn:SelectedTextButton;
        private var _btnGroup:SelectedButtonGroup;
        private var _currentList:Array;

        public function ChurchInviteView()
        {
            this.setView();
        }

        private function setView():void
        {
            this._refleshCount = 0;
            this._alertInfo = new AlertInfo();
            this._alertInfo.title = LanguageMgr.GetTranslation("tank.invite.InviteView.request");
            this._alertInfo.cancelLabel = LanguageMgr.GetTranslation("tank.invite.InviteView.close");
            this._alertInfo.submitLabel = LanguageMgr.GetTranslation("tank.invite.InviteView.list");
            info = this._alertInfo;
            this.escEnable = true;
            this._bg = ComponentFactory.Instance.creat("church.ChurchInviteView.guestListBg");
            addToContent(this._bg);
            this._itemBG = ComponentFactory.Instance.creatComponentByStylename("church.ChurchInvitePlayerItem.listItemBG");
            addToContent(this._itemBG);
            this._inviteFriendBtn = ComponentFactory.Instance.creat("church.room.inviteFriendBtnAsset");
            this._inviteFriendBtn.text = LanguageMgr.GetTranslation("tank.view.chat.ChatInputView.friend");
            addToContent(this._inviteFriendBtn);
            this._inviteConsortiaBtn = ComponentFactory.Instance.creat("church.room.inviteConsortiaBtnAsset");
            this._inviteConsortiaBtn.text = LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.consortia");
            addToContent(this._inviteConsortiaBtn);
            this._listPanel = ComponentFactory.Instance.creatComponentByStylename("church.room.invitePlayerListAsset");
            addToContent(this._listPanel);
            this._btnGroup = new SelectedButtonGroup();
            this._btnGroup.addSelectItem(this._inviteFriendBtn);
            this._btnGroup.addSelectItem(this._inviteConsortiaBtn);
            this._btnGroup.selectIndex = 0;
        }

        private function setEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
            if (this._model)
            {
                this._model.addEventListener(ChurchInviteModel.LIST_UPDATE, this.listUpdate);
            };
            if (this._btnGroup)
            {
                this._btnGroup.addEventListener(Event.CHANGE, this.__changeHandler);
            };
            if (this._inviteFriendBtn)
            {
                this._inviteFriendBtn.addEventListener(MouseEvent.CLICK, this.__soundPlay);
            };
            if (this._inviteConsortiaBtn)
            {
                this._inviteConsortiaBtn.addEventListener(MouseEvent.CLICK, this.__soundPlay);
            };
        }

        private function onFrameResponse(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    SoundManager.instance.play("008");
                    this.hide();
                    return;
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    this.sumbitConfirm();
                    return;
            };
        }

        private function sumbitConfirm(_arg_1:MouseEvent=null):void
        {
            SoundManager.instance.play("008");
            this._controller.refleshList(this._currentTab);
        }

        private function __changeHandler(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            switch (this._btnGroup.selectIndex)
            {
                case 0:
                    if (this._currentTab == 0)
                    {
                        return;
                    };
                    this._currentTab = 0;
                    break;
                case 1:
                    if (this._currentTab == 1)
                    {
                        return;
                    };
                    this._currentTab = 1;
                    break;
            };
            this._controller.refleshList(this._currentTab);
        }

        private function listUpdate(_arg_1:Event=null):void
        {
            var _local_4:InvitePlayerInfo;
            var _local_5:PlayerInfo;
            var _local_6:InvitePlayerInfo;
            var _local_7:ConsortiaPlayerInfo;
            var _local_8:PlayerInfo;
            var _local_9:Object;
            this._currentList = [];
            var _local_2:int;
            while (_local_2 < this._model.currentList.length)
            {
                if ((this._model.currentList[_local_2] is PlayerInfo))
                {
                    _local_4 = new InvitePlayerInfo();
                    _local_5 = (this._model.currentList[_local_2] as PlayerInfo);
                    _local_4.NickName = _local_5.NickName;
                    _local_4.Sex = _local_5.Sex;
                    _local_4.Grade = _local_5.Grade;
                    _local_4.Repute = _local_5.Repute;
                    _local_4.WinCount = _local_5.WinCount;
                    _local_4.TotalCount = _local_5.TotalCount;
                    _local_4.FightPower = _local_5.FightPower;
                    _local_4.ID = _local_5.ID;
                    _local_4.Offer = _local_5.Offer;
                    _local_4.VIPtype = _local_5.VIPtype;
                    _local_4.invited = false;
                    this._currentList.push(_local_4);
                }
                else
                {
                    if ((this._model.currentList[_local_2] is ConsortiaPlayerInfo))
                    {
                        _local_6 = new InvitePlayerInfo();
                        _local_7 = (this._model.currentList[_local_2] as ConsortiaPlayerInfo);
                        _local_6.NickName = _local_7.NickName;
                        _local_6.Sex = _local_7.Sex;
                        _local_6.Grade = _local_7.Grade;
                        _local_6.Repute = _local_7.Repute;
                        _local_6.WinCount = _local_7.WinCount;
                        _local_6.TotalCount = _local_7.TotalCount;
                        _local_6.FightPower = _local_7.FightPower;
                        _local_6.ID = _local_7.ID;
                        _local_6.Offer = _local_7.Offer;
                        _local_6.VIPtype = _local_7.VIPtype;
                        _local_6.invited = false;
                        this._currentList.push(_local_6);
                    };
                };
                _local_2++;
            };
            this._listPanel.vectorListModel.clear();
            var _local_3:int;
            while (_local_3 < this._model.currentList.length)
            {
                _local_8 = (this._currentList[_local_3] as PlayerInfo);
                _local_9 = this.changeData(_local_8, (_local_3 + 1));
                this._listPanel.vectorListModel.insertElementAt(_local_9, _local_3);
                _local_3++;
            };
            this._listPanel.list.updateListView();
        }

        private function __soundPlay(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
        }

        private function changeData(_arg_1:PlayerInfo, _arg_2:int):Object
        {
            var _local_3:Object = new Object();
            _local_3["playerInfo"] = _arg_1;
            _local_3["index"] = _arg_2;
            return (_local_3);
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true);
            this.setEvent();
            this.listUpdate();
            this._controller.refleshList(this._currentTab);
        }

        public function hide():void
        {
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get model():ChurchInviteModel
        {
            return (this._model);
        }

        public function set model(_arg_1:ChurchInviteModel):void
        {
            this._model = _arg_1;
        }

        public function get controller():ChurchInviteController
        {
            return (this._controller);
        }

        public function set controller(_arg_1:ChurchInviteController):void
        {
            this._controller = _arg_1;
        }

        private function removeEvent():void
        {
            if (this._model)
            {
                this._model.removeEventListener(ChurchInviteModel.LIST_UPDATE, this.listUpdate);
            };
            removeEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
            if (this._btnGroup)
            {
                this._btnGroup.removeEventListener(Event.CHANGE, this.__changeHandler);
            };
            if (this._inviteFriendBtn)
            {
                this._inviteFriendBtn.removeEventListener(MouseEvent.CLICK, this.__soundPlay);
            };
            if (this._inviteConsortiaBtn)
            {
                this._inviteConsortiaBtn.removeEventListener(MouseEvent.CLICK, this.__soundPlay);
            };
        }

        private function removeView():void
        {
            this._controller = null;
            this._model = null;
            this._alertInfo = null;
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._itemBG);
            this._itemBG = null;
            ObjectUtils.disposeObject(this._listPanel);
            this._listPanel = null;
            ObjectUtils.disposeObject(this._inviteFriendBtn);
            this._inviteFriendBtn = null;
            ObjectUtils.disposeObject(this._inviteConsortiaBtn);
            this._inviteConsortiaBtn = null;
            if (this._btnGroup)
            {
                this._btnGroup.dispose();
            };
            this._btnGroup = null;
            if (parent)
            {
                parent.removeChild(this);
            };
            dispatchEvent(new Event(Event.CLOSE));
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeEvent();
            this.removeView();
        }


    }
}//package church.view.invite

