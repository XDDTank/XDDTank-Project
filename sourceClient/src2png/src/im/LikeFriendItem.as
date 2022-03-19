﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//im.LikeFriendItem

package im
{
    import flash.display.Sprite;
    import com.pickgliss.ui.controls.cell.IListCell;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import ddt.view.common.LevelIcon;
    import ddt.view.common.SexIcon;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.data.player.LikeFriendInfo;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import flash.filters.ColorMatrixFilter;
    import com.pickgliss.ui.text.GradientText;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import ddt.manager.ChatManager;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerTipManager;
    import com.pickgliss.utils.ObjectUtils;
    import vip.VipController;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.controls.list.List;
    import flash.display.DisplayObject;

    public class LikeFriendItem extends Sprite implements IListCell, Disposeable 
    {

        private var _friendBG:ScaleFrameImage;
        private var _isSelected:Boolean;
        private var _levelIcon:LevelIcon;
        private var _sexIcon:SexIcon;
        private var _nameText:FilterFrameText;
        private var _info:LikeFriendInfo;
        private var _privateChatBtn:SimpleBitmapButton;
        private var _myColorMatrix_filter:ColorMatrixFilter;
        private var _vipName:GradientText;

        public function LikeFriendItem()
        {
            this.init();
            this.initEvent();
        }

        private function init():void
        {
            this.buttonMode = true;
            this._myColorMatrix_filter = new ColorMatrixFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0]);
            this._friendBG = ComponentFactory.Instance.creat("IM.item.FriendItemBg");
            this._friendBG.setFrame(1);
            addChild(this._friendBG);
            this._levelIcon = ComponentFactory.Instance.creatCustomObject("IM.item.levelIcon");
            this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
            addChild(this._levelIcon);
            this._sexIcon = new SexIcon(false);
            var _local_1:Point = ComponentFactory.Instance.creatCustomObject("IM.IMListPlayerItemCell.sexIconPos");
            this._sexIcon.x = _local_1.x;
            this._sexIcon.y = _local_1.y;
            addChild(this._sexIcon);
            this._nameText = ComponentFactory.Instance.creat("IM.item.name");
            this._nameText.text = "";
            addChild(this._nameText);
            this._privateChatBtn = ComponentFactory.Instance.creat("IM.ConsortiaListItem.privateChatBtn");
            this._privateChatBtn.tipData = LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.private");
            this._privateChatBtn.visible = false;
            addChild(this._privateChatBtn);
        }

        private function initEvent():void
        {
            addEventListener(MouseEvent.MOUSE_OVER, this.__itemOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.__itemOut);
            addEventListener(MouseEvent.CLICK, this.__itemClick);
            this._privateChatBtn.addEventListener(MouseEvent.CLICK, this.__privateChatBtnClick);
        }

        private function __privateChatBtnClick(_arg_1:MouseEvent):void
        {
            ChatManager.Instance.privateChatTo(this._info.NickName, this._info.ID);
            ChatManager.Instance.setFocus();
            SoundManager.instance.play("008");
        }

        private function __itemClick(_arg_1:MouseEvent):void
        {
            if ((!(_arg_1.target is SimpleBitmapButton)))
            {
                PlayerTipManager.show(this._info, localToGlobal(new Point(0, 0)).y);
                SoundManager.instance.play("008");
            };
        }

        private function __itemOver(_arg_1:MouseEvent):void
        {
            if ((!(this._info.isSelected)))
            {
                this._friendBG.setFrame(2);
            };
            this._privateChatBtn.visible = true;
        }

        private function __itemOut(_arg_1:MouseEvent):void
        {
            if ((!(this._info.isSelected)))
            {
                this._friendBG.setFrame(1);
            };
            this._privateChatBtn.visible = false;
        }

        private function update():void
        {
            if (this._info.isSelected)
            {
                this._friendBG.setFrame(3);
            }
            else
            {
                this._friendBG.setFrame(1);
            };
            this._levelIcon.setInfo(this._info.Grade, this._info.Repute, this._info.WinCount, this._info.TotalCount, this._info.FightPower, this._info.Offer, true);
            this._sexIcon.setSex(this._info.Sex);
            this._sexIcon.x = ((this._levelIcon.x + this._levelIcon.width) + 2);
            if (this._nameText)
            {
                this._nameText.dispose();
            };
            this._nameText = ComponentFactory.Instance.creat("IM.item.name");
            this._nameText.text = this._info.NickName;
            this._nameText.x = ((this._sexIcon.x + this._sexIcon.width) + 2);
            if (this._info.playerState.StateID == 0)
            {
                this.filters = [this._myColorMatrix_filter];
            }
            else
            {
                this.filters = null;
            };
            if (this._info.IsVIP)
            {
                ObjectUtils.disposeObject(this._vipName);
                this._vipName = VipController.instance.getVipNameTxt(139, this._info.VIPtype);
                this._vipName.x = this._nameText.x;
                this._vipName.y = this._nameText.y;
                this._vipName.text = this._nameText.text;
                addChild(this._vipName);
            };
            addChild(this._nameText);
            PositionUtils.adaptNameStyle(this._info, this._nameText, this._vipName);
        }

        public function setListCellStatus(_arg_1:List, _arg_2:Boolean, _arg_3:int):void
        {
        }

        public function getCellValue():*
        {
            return (this._info);
        }

        public function setCellValue(_arg_1:*):void
        {
            this._info = _arg_1;
            this.update();
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function dispose():void
        {
            if (this._friendBG)
            {
                this._friendBG.dispose();
                this._friendBG = null;
            };
            if (this._levelIcon)
            {
                this._levelIcon.dispose();
                this._levelIcon = null;
            };
            if (this._sexIcon)
            {
                this._sexIcon.dispose();
                this._sexIcon = null;
            };
            if (this._nameText)
            {
                this._nameText.dispose();
                this._nameText = null;
            };
            if (this._privateChatBtn)
            {
                this._privateChatBtn.dispose();
                this._privateChatBtn = null;
            };
            if (this._vipName)
            {
                ObjectUtils.disposeObject(this._vipName);
            };
            this._vipName = null;
            this._myColorMatrix_filter = null;
        }


    }
}//package im
