﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.ChatFriendListPanel

package ddt.view.chat
{
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import com.pickgliss.ui.controls.SelectedTextButton;
    import com.pickgliss.ui.controls.ListPanel;
    import com.pickgliss.ui.controls.BaseButton;
    import ddt.manager.SoundManager;
    import flash.events.MouseEvent;
    import consortion.ConsortionModelControl;
    import ddt.manager.PlayerManager;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.events.ListItemEvent;
    import ddt.data.player.BasePlayer;
    import com.pickgliss.utils.ObjectUtils;

    public class ChatFriendListPanel extends ChatBasePanel implements Disposeable 
    {

        public static const FRIEND:uint = 0;
        public static const CONSORTIA:uint = 1;

        private var _bg:ScaleBitmapImage;
        private var _rule:ScaleBitmapImage;
        private var _btnGroup:SelectedButtonGroup;
        private var _btnConsortia:SelectedTextButton;
        private var _btnFriend:SelectedTextButton;
        private var _func:Function;
        private var _playerList:ListPanel;
        private var _showOffLineList:Boolean;
        private var _currentType:uint;


        public function setup(_arg_1:Function, _arg_2:Boolean=true):void
        {
            this._func = _arg_1;
            this._showOffLineList = _arg_2;
            this.__onFriendListComplete();
        }

        public function set currentType(_arg_1:int):void
        {
            this._currentType = _arg_1;
            this._btnGroup.selectIndex = this._currentType;
            this.updateBtns();
        }

        private function updateBtns():void
        {
            this._btnFriend.buttonMode = (this._btnGroup.selectIndex == CONSORTIA);
            this._btnConsortia.buttonMode = (!(this._btnFriend.buttonMode));
        }

        public function refreshAllList():void
        {
            this._btnGroup.selectIndex = FRIEND;
            this.__onFriendListComplete();
        }

        override public function set visible(_arg_1:Boolean):void
        {
            super.visible = _arg_1;
        }

        override protected function __hideThis(_arg_1:MouseEvent):void
        {
            if (((!(_arg_1.target is ScaleBitmapImage)) && (!(_arg_1.target is BaseButton))))
            {
                SoundManager.instance.play("008");
                setVisible = false;
                if (parent)
                {
                    parent.removeChild(this);
                };
            };
        }

        private function __btnsClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.stopImmediatePropagation();
            if (_arg_1.currentTarget == this._btnFriend)
            {
                this.__onFriendListComplete();
                this._currentType = FRIEND;
            }
            else
            {
                if (this._showOffLineList)
                {
                    this.setList(ConsortionModelControl.Instance.model.memberList.list);
                }
                else
                {
                    this.setList(ConsortionModelControl.Instance.model.onlineConsortiaMemberList);
                };
                this._currentType = CONSORTIA;
            };
        }

        private function _scrollClick(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
        }

        private function __onFriendListComplete(_arg_1:Event=null):void
        {
            if (this._showOffLineList)
            {
                this.setList(PlayerManager.Instance.friendList.list);
            }
            else
            {
                this.setList(PlayerManager.Instance.onlineFriendList);
            };
        }

        private function __updateConsortiaList(_arg_1:Event):void
        {
            this.setList(ConsortionModelControl.Instance.model.onlineConsortiaMemberList);
        }

        private function __updateFriendList(_arg_1:Event):void
        {
            this.setList(PlayerManager.Instance.onlineFriendList);
        }

        override protected function init():void
        {
            var _local_1:Rectangle;
            super.init();
            this._btnGroup = new SelectedButtonGroup();
            this._bg = ComponentFactory.Instance.creatComponentByStylename("chat.FriendListBg");
            this._rule = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.HRule");
            _local_1 = ComponentFactory.Instance.creatCustomObject("chat.FriendListRule.pos");
            this._rule.x = _local_1.x;
            this._rule.y = _local_1.y;
            this._rule.width = _local_1.width;
            this._playerList = ComponentFactory.Instance.creatComponentByStylename("chat.FriendList");
            this._btnFriend = ComponentFactory.Instance.creatComponentByStylename("chat.FriendListFriendBtn");
            this._btnConsortia = ComponentFactory.Instance.creatComponentByStylename("chat.FriendListConsortiaBtn");
            this._btnFriend.text = LanguageMgr.GetTranslation("chat.ChatFriendList.FriendBtnTxt");
            this._btnConsortia.text = LanguageMgr.GetTranslation("chat.ChatFriendList.ConsortiaBtnTxt");
            this._btnGroup.addSelectItem(this._btnFriend);
            this._btnGroup.addSelectItem(this._btnConsortia);
            this._btnGroup.selectIndex = FRIEND;
            this._btnFriend.displacement = (this._btnConsortia.displacement = false);
            addChild(this._bg);
            addChild(this._rule);
            addChild(this._btnFriend);
            addChild(this._btnConsortia);
            addChild(this._playerList);
        }

        override protected function initEvent():void
        {
            super.initEvent();
            this._btnFriend.addEventListener(MouseEvent.CLICK, this.__btnsClick);
            this._btnConsortia.addEventListener(MouseEvent.CLICK, this.__btnsClick);
            this._playerList.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK, this.__itemClick);
            PlayerManager.Instance.addEventListener(PlayerManager.FRIENDLIST_COMPLETE, this.__onFriendListComplete);
        }

        override protected function removeEvent():void
        {
            super.removeEvent();
            this._btnFriend.removeEventListener(MouseEvent.CLICK, this.__btnsClick);
            this._btnConsortia.removeEventListener(MouseEvent.CLICK, this.__btnsClick);
            this._playerList.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK, this.__itemClick);
            PlayerManager.Instance.removeEventListener(PlayerManager.FRIENDLIST_COMPLETE, this.__onFriendListComplete);
        }

        private function setList(_arg_1:Array):void
        {
            this._playerList.vectorListModel.clear();
            this._playerList.vectorListModel.appendAll(_arg_1);
            this._playerList.list.updateListView();
            this.updateBtns();
        }

        private function __itemClick(_arg_1:ListItemEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BasePlayer = (_arg_1.cellValue as BasePlayer);
            this._func(_local_2.NickName, _local_2.ID);
        }

        public function dispose():void
        {
            this.removeEvent();
            this._func = null;
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._btnGroup)
            {
                ObjectUtils.disposeObject(this._btnGroup);
            };
            this._btnGroup = null;
            if (this._btnConsortia)
            {
                ObjectUtils.disposeObject(this._btnConsortia);
            };
            this._btnConsortia = null;
            if (this._btnFriend)
            {
                ObjectUtils.disposeObject(this._btnFriend);
            };
            this._btnFriend = null;
            if (this._playerList)
            {
                ObjectUtils.disposeObject(this._playerList);
            };
            this._playerList = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package ddt.view.chat
