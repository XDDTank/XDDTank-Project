// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.ChatNamePanel

package ddt.view.chat
{
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.controls.IconButton;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PathManager;
    import flash.events.MouseEvent;
    import im.IMController;
    import bagAndInfo.info.PlayerInfoViewControl;
    import ddt.manager.ChatManager;

    public class ChatNamePanel extends ChatBasePanel 
    {

        public var playerName:String;
        public var channel:String = "";
        public var message:String = "";
        private var _bg:Image;
        private var _blackListBtn:IconButton;
        private var _viewInfoBtn:IconButton;
        private var _addFriendBtn:IconButton;
        private var _privateChat:IconButton;
        private var _btnContainer:VBox;


        override protected function init():void
        {
            super.init();
            this._bg = ComponentFactory.Instance.creatComponentByStylename("core.commonTipBg");
            this._btnContainer = ComponentFactory.Instance.creatComponentByStylename("chat.NamePanelList");
            this._blackListBtn = ComponentFactory.Instance.creatComponentByStylename("chat.ItemBlackList");
            this._viewInfoBtn = ComponentFactory.Instance.creatComponentByStylename("chat.ItemInfo");
            this._addFriendBtn = ComponentFactory.Instance.creatComponentByStylename("chat.ItemMakeFriend");
            this._privateChat = ComponentFactory.Instance.creatComponentByStylename("chat.ItemPrivateChat");
            this._bg.width = 102;
            this._bg.height = 102;
            addChild(this._bg);
            addChild(this._btnContainer);
            this._btnContainer.addChild(this._blackListBtn);
            this._btnContainer.addChild(this._viewInfoBtn);
            this._btnContainer.addChild(this._addFriendBtn);
            this._btnContainer.addChild(this._privateChat);
            if (PathManager.solveFeedbackEnable())
            {
            };
        }

        override protected function initEvent():void
        {
            super.initEvent();
            this._blackListBtn.addEventListener(MouseEvent.CLICK, this.__onBtnClicked);
            this._viewInfoBtn.addEventListener(MouseEvent.CLICK, this.__onBtnClicked);
            this._addFriendBtn.addEventListener(MouseEvent.CLICK, this.__onBtnClicked);
            this._privateChat.addEventListener(MouseEvent.CLICK, this.__onBtnClicked);
            if (PathManager.solveFeedbackEnable())
            {
            };
        }

        public function get getHeight():int
        {
            return (this._bg.height);
        }

        private function __onBtnClicked(_arg_1:MouseEvent):void
        {
            switch (_arg_1.currentTarget)
            {
                case this._blackListBtn:
                    IMController.Instance.addBlackList(this.playerName);
                    return;
                case this._viewInfoBtn:
                    PlayerInfoViewControl.viewByNickName(this.playerName);
                    PlayerInfoViewControl.isOpenFromBag = false;
                    return;
                case this._addFriendBtn:
                    IMController.Instance.addFriend(this.playerName);
                    return;
                case this._privateChat:
                    ChatManager.Instance.privateChatTo(this.playerName);
                    return;
            };
        }

        override protected function removeEvent():void
        {
            super.removeEvent();
            this._blackListBtn.removeEventListener(MouseEvent.CLICK, this.__onBtnClicked);
            this._viewInfoBtn.removeEventListener(MouseEvent.CLICK, this.__onBtnClicked);
            this._addFriendBtn.removeEventListener(MouseEvent.CLICK, this.__onBtnClicked);
            this._privateChat.removeEventListener(MouseEvent.CLICK, this.__onBtnClicked);
        }


    }
}//package ddt.view.chat

