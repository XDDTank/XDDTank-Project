// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//im.IMLookupView

package im
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.TextInput;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.LanguageMgr;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import ddt.manager.PlayerManager;
    import road7th.data.DictionaryEvent;
    import com.pickgliss.toplevel.StageReferance;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import ddt.view.tips.PlayerTip;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.utils.DisplayUtils;
    import flash.display.DisplayObject;
    import ddt.manager.SoundManager;
    import ddt.data.player.PlayerInfo;
    import ddt.data.player.ConsortiaPlayerInfo;
    import ddt.manager.ChatManager;
    import com.pickgliss.events.InteractiveEvent;
    import ddt.data.CMFriendInfo;
    import consortion.ConsortionModelControl;
    import ddt.data.player.FriendListPlayer;
    import com.pickgliss.utils.ObjectUtils;

    public class IMLookupView extends Sprite implements Disposeable 
    {

        public const MAX_ITEM_NUM:int = 8;
        public const ITEM_MAX_HEIGHT:int = 33;
        public const ITEM_MIN_HEIGHT:int = 33;

        private var _bg:Scale9CornerImage;
        private var _cleanUpBtn:BaseButton;
        private var _inputText:TextInput;
        private var _bg2:ScaleBitmapImage;
        private var _currentList:Array;
        private var _itemArray:Array;
        private var _listType:int;
        private var _currentItemInfo:*;
        private var _currentItem:IMLookupItem;
        private var _list:VBox;
        private var _NAN:FilterFrameText;
        private var _lookBtn:Bitmap;

        public function IMLookupView()
        {
            this.init();
            this.initEvent();
        }

        private function init():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("im.Browse.baiduBG");
            addChild(this._bg);
            this._lookBtn = ComponentFactory.Instance.creatBitmap("asset.core.searchIcon");
            PositionUtils.setPos(this._lookBtn, "ListItemView.lookBtn");
            addChild(this._lookBtn);
            this._cleanUpBtn = ComponentFactory.Instance.creatComponentByStylename("IM.IMLookup.cleanUpBtn");
            this._cleanUpBtn.visible = false;
            addChild(this._cleanUpBtn);
            this._inputText = ComponentFactory.Instance.creatComponentByStylename("IM.IMLookup.textinput");
            addChild(this._inputText);
            this._bg2 = ComponentFactory.Instance.creatComponentByStylename("IM.IMLookup.lookUpBG");
            this._bg2.visible = false;
            addChild(this._bg2);
            this._list = ComponentFactory.Instance.creat("IM.IMLookup.lookupList");
            addChild(this._list);
            this._NAN = ComponentFactory.Instance.creatComponentByStylename("IM.IMLookup.IMLookupItemName");
            this._NAN.text = LanguageMgr.GetTranslation("ddt.FriendDropListCell.noFriend");
            this._NAN.visible = false;
            this._NAN.x = (this._bg2.x + 10);
            this._NAN.y = (this._bg2.y + 7);
            addChild(this._NAN);
        }

        private function initEvent():void
        {
            this._inputText.addEventListener(Event.CHANGE, this.__textInput);
            this._inputText.addEventListener(MouseEvent.CLICK, this.__inputClick);
            this._inputText.addEventListener(KeyboardEvent.KEY_DOWN, this.__stopEvent);
            PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.REMOVE, this.__updateList);
            if (PlayerManager.Instance.blackList)
            {
                PlayerManager.Instance.blackList.addEventListener(DictionaryEvent.REMOVE, this.__updateList);
            };
            if (PlayerManager.Instance.recentContacts)
            {
                PlayerManager.Instance.recentContacts.addEventListener(DictionaryEvent.REMOVE, this.__updateList);
            };
            this._cleanUpBtn.addEventListener(MouseEvent.CLICK, this.__cleanUpClick);
            StageReferance.stage.addEventListener(MouseEvent.CLICK, this.__stageClick);
        }

        private function __inputClick(_arg_1:MouseEvent):void
        {
            this.strTest();
        }

        private function __stageClick(_arg_1:MouseEvent):void
        {
            if (((((DisplayUtils.isTargetOrContain((_arg_1.target as DisplayObject), this._inputText)) || (_arg_1.target is ScaleFrameImage)) || (_arg_1.target is PlayerTip)) || (_arg_1.target is SimpleBitmapButton)))
            {
                return;
            };
            this.hide();
        }

        private function hide():void
        {
            this._bg2.visible = false;
            this._NAN.visible = false;
            this._cleanUpBtn.visible = false;
            this._list.visible = false;
            this._lookBtn.visible = true;
        }

        private function __stopEvent(_arg_1:KeyboardEvent):void
        {
            _arg_1.stopImmediatePropagation();
            _arg_1.stopPropagation();
        }

        private function __cleanUpClick(_arg_1:MouseEvent):void
        {
            this._inputText.text = "";
            this.strTest();
            SoundManager.instance.play("008");
        }

        private function __updateList(_arg_1:Event):void
        {
            if (((this._list) && (this._list.visible)))
            {
                this.strTest();
            };
        }

        private function __textInput(_arg_1:Event):void
        {
            this.strTest();
        }

        private function strTest():void
        {
            this.disposeItems();
            this.updateList();
            if (this._listType == IMView.FRIEND_LIST)
            {
                this.friendStrTest();
            }
            else
            {
                if (this._listType == IMView.CMFRIEND_LIST)
                {
                    this.CMFriendStrTest();
                };
            };
            this.setFlexBg();
        }

        private function friendStrTest():void
        {
            var _local_2:String;
            var _local_3:String;
            var _local_4:IMLookupItem;
            var _local_5:IMLookupItem;
            var _local_1:int;
            while (_local_1 < this._currentList.length)
            {
                if (this._itemArray.length >= this.MAX_ITEM_NUM)
                {
                    this.setFlexBg();
                    return;
                };
                _local_2 = "";
                _local_3 = "";
                if ((this._currentList[_local_1] is PlayerInfo))
                {
                    _local_2 = (this._currentList[_local_1] as PlayerInfo).NickName;
                    _local_3 = this._inputText.text;
                }
                else
                {
                    if ((this._currentList[_local_1] is ConsortiaPlayerInfo))
                    {
                        _local_2 = (this._currentList[_local_1] as ConsortiaPlayerInfo).NickName;
                        _local_3 = this._inputText.text;
                    };
                };
                if (_local_3 == "")
                {
                    this.setFlexBg();
                    return;
                };
                if ((!(_local_2)))
                {
                    this.setFlexBg();
                    return;
                };
                if (_local_2.indexOf(this._inputText.text) != -1)
                {
                    if ((this._currentList[_local_1] is PlayerInfo))
                    {
                        _local_4 = new IMLookupItem((this._currentList[_local_1] as PlayerInfo));
                        _local_4.addEventListener(MouseEvent.CLICK, this.__clickHandler);
                        this._list.addChild(_local_4);
                        this._itemArray.push(_local_4);
                    }
                    else
                    {
                        if ((this._currentList[_local_1] is ConsortiaPlayerInfo))
                        {
                            if (this.testAlikeName((this._currentList[_local_1] as ConsortiaPlayerInfo).NickName))
                            {
                                _local_5 = new IMLookupItem((this._currentList[_local_1] as ConsortiaPlayerInfo));
                                _local_5.addEventListener(MouseEvent.CLICK, this.__clickHandler);
                                this._list.addChild(_local_5);
                                this._itemArray.push(_local_5);
                            };
                        };
                    };
                };
                _local_1++;
            };
        }

        private function __doubleClickHandler(_arg_1:InteractiveEvent):void
        {
            ChatManager.Instance.privateChatTo((_arg_1.currentTarget as IMLookupItem).info.NickName, (_arg_1.currentTarget as IMLookupItem).info.ID);
        }

        private function __clickHandler(_arg_1:MouseEvent):void
        {
            this._currentItemInfo = (_arg_1.currentTarget as IMLookupItem).info;
            dispatchEvent(new Event(Event.CHANGE));
        }

        private function CMFriendStrTest():void
        {
            var _local_2:String;
            var _local_3:String;
            var _local_4:IMLookupItem;
            var _local_1:int;
            while (_local_1 < this._currentList.length)
            {
                if (this._itemArray.length >= this.MAX_ITEM_NUM)
                {
                    this.setFlexBg();
                    return;
                };
                _local_2 = (this._currentList[_local_1] as CMFriendInfo).NickName;
                if (_local_2 == "")
                {
                    _local_2 = (this._currentList[_local_1] as CMFriendInfo).OtherName;
                };
                _local_3 = this._inputText.text;
                if (_local_3 == "")
                {
                    this.setFlexBg();
                    return;
                };
                if (_local_2.indexOf(this._inputText.text) != -1)
                {
                    _local_4 = new IMLookupItem((this._currentList[_local_1] as CMFriendInfo));
                    _local_4.addEventListener(MouseEvent.CLICK, this.__clickHandler);
                    this._list.addChild(_local_4);
                    this._itemArray.push(_local_4);
                };
                _local_1++;
            };
        }

        private function setFlexBg():void
        {
            if (this._inputText.text == "")
            {
                this._bg2.visible = false;
                this._NAN.visible = false;
                this._cleanUpBtn.visible = false;
                this._lookBtn.visible = true;
            }
            else
            {
                if (((!(this._inputText.text == "")) && (this._itemArray.length == 0)))
                {
                    this._bg2.visible = true;
                    this._bg2.height = this.ITEM_MAX_HEIGHT;
                    this._NAN.visible = true;
                    this._cleanUpBtn.visible = true;
                    this._list.visible = true;
                    this._lookBtn.visible = false;
                }
                else
                {
                    this._NAN.visible = false;
                    this._cleanUpBtn.visible = true;
                    this._bg2.visible = true;
                    this._list.visible = true;
                    this._lookBtn.visible = false;
                    if (this._itemArray)
                    {
                        this._bg2.height = (((this._itemArray.length * this.ITEM_MIN_HEIGHT) == 0) ? this.ITEM_MAX_HEIGHT : (this._itemArray.length * this.ITEM_MIN_HEIGHT));
                    };
                };
            };
        }

        private function disposeItems():void
        {
            var _local_1:int;
            if (this._itemArray)
            {
                _local_1 = 0;
                while (_local_1 < this._itemArray.length)
                {
                    (this._itemArray[_local_1] as IMLookupItem).removeEventListener(MouseEvent.CLICK, this.__clickHandler);
                    (this._itemArray[_local_1] as IMLookupItem).dispose();
                    _local_1++;
                };
            };
            this._list.disposeAllChildren();
            this._itemArray = [];
        }

        private function updateList():void
        {
            if (this._listType == 0)
            {
                this._currentList = [];
                this._currentList = PlayerManager.Instance.friendList.list;
                this._currentList = this._currentList.concat(ConsortionModelControl.Instance.model.memberList.list);
                if (((PlayerManager.Instance.blackList) && (PlayerManager.Instance.blackList.list)))
                {
                    this._currentList = this._currentList.concat(PlayerManager.Instance.blackList.list);
                };
                if (((PlayerManager.Instance.recentContacts) && (PlayerManager.Instance.recentContacts.list)))
                {
                    this._currentList = this._currentList.concat(IMController.Instance.getRecentContactsStranger());
                };
            }
            else
            {
                if (this._listType == 2)
                {
                    this._currentList = [];
                    if ((!(PlayerManager.Instance.CMFriendList)))
                    {
                        return;
                    };
                    this._currentList = PlayerManager.Instance.CMFriendList.list;
                };
            };
        }

        private function testAlikeName(_arg_1:String):Boolean
        {
            var _local_2:Array = [];
            _local_2 = PlayerManager.Instance.friendList.list;
            _local_2 = _local_2.concat(PlayerManager.Instance.blackList.list);
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                if ((_local_2[_local_3] as FriendListPlayer).NickName == _arg_1)
                {
                    return (false);
                };
                _local_3++;
            };
            return (true);
        }

        public function set listType(_arg_1:int):void
        {
            this._listType = _arg_1;
            this.updateList();
        }

        public function get currentItemInfo():*
        {
            return (this._currentItemInfo);
        }

        public function dispose():void
        {
            this._inputText.removeEventListener(Event.CHANGE, this.__textInput);
            this._inputText.removeEventListener(MouseEvent.CLICK, this.__inputClick);
            this._inputText.removeEventListener(KeyboardEvent.KEY_DOWN, this.__stopEvent);
            PlayerManager.Instance.friendList.removeEventListener(DictionaryEvent.REMOVE, this.__updateList);
            if (PlayerManager.Instance.blackList)
            {
                PlayerManager.Instance.blackList.removeEventListener(DictionaryEvent.REMOVE, this.__updateList);
            };
            if (PlayerManager.Instance.recentContacts)
            {
                PlayerManager.Instance.recentContacts.addEventListener(DictionaryEvent.REMOVE, this.__updateList);
            };
            this._cleanUpBtn.removeEventListener(MouseEvent.CLICK, this.__cleanUpClick);
            StageReferance.stage.removeEventListener(MouseEvent.CLICK, this.__stageClick);
            this.disposeItems();
            if (this._bg2)
            {
                this._bg2.dispose();
                this._bg2 = null;
            };
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
                this._bg = null;
            };
            if (this._cleanUpBtn)
            {
                this._cleanUpBtn.dispose();
                this._cleanUpBtn = null;
            };
            if (this._inputText)
            {
                this._inputText.dispose();
                this._inputText = null;
            };
            if (this._currentItem)
            {
                this._currentItem.dispose();
                this._currentItem = null;
            };
            if (this._list)
            {
                this._list.dispose();
                this._list = null;
            };
            if (this._NAN)
            {
                ObjectUtils.disposeObject(this._NAN);
                this._NAN = null;
            };
        }


    }
}//package im

