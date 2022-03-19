// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//platformapi.tencent.view.closeFriend.LevelUpAwardFrame

package platformapi.tencent.view.closeFriend
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.ListPanel;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.ListItemEvent;
    import ddt.manager.ItemManager;
    import flash.events.MouseEvent;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.PlayerManager;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import ddt.manager.SocketManager;
    import ddt.data.player.InvitedFirendListPlayer;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.LayerManager;

    public class LevelUpAwardFrame extends Frame 
    {

        private var _bg1:Scale9CornerImage;
        private var _bg2:Scale9CornerImage;
        private var _titleBitmap:Bitmap;
        private var _titleBGBitmap:Bitmap;
        private var _titleTipBitmap:Bitmap;
        private var _borderBitmap:Bitmap;
        private var _tableBGBitmap:Bitmap;
        private var _playerList:ListPanel;
        private var _currentItem:LevelUpAwardFramePlayerItem;
        private var cellArray:Array;

        public function LevelUpAwardFrame()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            titleText = LanguageMgr.GetTranslation("tank.view.im.InviteAwardFrame.title");
            this._bg1 = ComponentFactory.Instance.creatComponentByStylename("IMFrame.levelUpAward.BG1");
            this._bg2 = ComponentFactory.Instance.creatComponentByStylename("IMFrame.levelUpAward.BG2");
            this._titleBitmap = ComponentFactory.Instance.creatBitmap("asset.IM.levelUpFrame.title");
            this._titleBGBitmap = ComponentFactory.Instance.creatBitmap("asset.IM.inviteFrame.titleBG");
            this._titleTipBitmap = ComponentFactory.Instance.creatBitmap("asset.IM.levelUpFrame.titleTip");
            this._borderBitmap = ComponentFactory.Instance.creatBitmap("asset.IM.levelUpFrame.border");
            this._tableBGBitmap = ComponentFactory.Instance.creatBitmap("asset.IM.levelUpFrame.tableBG");
            this._playerList = ComponentFactory.Instance.creatComponentByStylename("IMFrame.levelUpAward.playerList");
            this._playerList.list.updateListView();
            this._playerList.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK, this.__itemClick);
            this.fillPlayerInfo();
            addToContent(this._bg1);
            addToContent(this._bg2);
            addToContent(this._borderBitmap);
            addToContent(this._tableBGBitmap);
            addToContent(this._titleBGBitmap);
            addToContent(this._titleBitmap);
            addToContent(this._titleTipBitmap);
            addToContent(this._playerList);
            this.cellArray = new Array();
            this.initCell();
        }

        private function initCell():void
        {
            var _local_3:int;
            var _local_4:LevelUpAwardFrameLevelGift;
            var _local_1:String = LanguageMgr.GetTranslation("tank.view.im.LevelAwardFrame.txt2");
            var _local_2:Array = _local_1.split(",");
            _local_3 = 0;
            while (_local_3 < 6)
            {
                _local_4 = new LevelUpAwardFrameLevelGift();
                _local_4.x = (245 + ((_local_3 % 2) * 180));
                _local_4.y = (108 + (int((_local_3 / 2)) * 76));
                addToContent(_local_4);
                _local_4.step = (_local_3 + 1);
                _local_4.info = ItemManager.Instance.getTemplateById((16094 + _local_3));
                this.cellArray.push(_local_4);
                _local_4.addEventListener(MouseEvent.CLICK, this.__onAwardItemClicked);
                _local_3++;
            };
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            PlayerManager.Instance.addEventListener(Event.CHANGE, this.__onUpdate);
        }

        private function __onUpdate(_arg_1:Event):void
        {
            this.update();
        }

        private function update():void
        {
            var _local_1:LevelUpAwardFrameLevelGift;
            var _local_2:int;
            if ((!(this._currentItem)))
            {
                _local_2 = 0;
            }
            else
            {
                _local_2 = this._currentItem.info.awardStep;
            };
            for each (_local_1 in this.cellArray)
            {
                _local_1.taken = (_local_2 >= _local_1.step);
            };
        }

        private function __onAwardItemClicked(_arg_1:MouseEvent):void
        {
            var _local_2:LevelUpAwardFrameLevelGift = (_arg_1.target as LevelUpAwardFrameLevelGift);
            SoundManager.instance.playButtonSound();
            if ((!(_local_2)))
            {
                return;
            };
            if (_local_2.taken)
            {
                return;
            };
            if ((!(this._currentItem)))
            {
                return;
            };
            SocketManager.Instance.out.sendInvitedFriendAward(1, _local_2.step, this._currentItem.info.UserID);
        }

        private function fillPlayerInfo():void
        {
            var _local_1:InvitedFirendListPlayer;
            for each (_local_1 in PlayerManager.Instance.CloseFriendsLevelRewardList)
            {
                this._playerList.vectorListModel.append(_local_1);
            };
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                SoundManager.instance.playButtonSound();
                ObjectUtils.disposeObject(this);
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function __itemClick(_arg_1:ListItemEvent):void
        {
            SoundManager.instance.play("008");
            if ((!(this._currentItem)))
            {
                this._currentItem = (_arg_1.cell as LevelUpAwardFramePlayerItem);
                this._currentItem.setListCellStatus(this._playerList.list, true, _arg_1.index);
            }
            else
            {
                if (this._currentItem != (_arg_1.cell as LevelUpAwardFramePlayerItem))
                {
                    this._currentItem.setListCellStatus(this._playerList.list, false, _arg_1.index);
                    this._currentItem = (_arg_1.cell as LevelUpAwardFramePlayerItem);
                    this._currentItem.setListCellStatus(this._playerList.list, true, _arg_1.index);
                };
            };
            this.updateAwardInfo();
        }

        private function updateAwardInfo():void
        {
            this.update();
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            PlayerManager.Instance.removeEventListener(Event.CHANGE, this.__onUpdate);
        }

        override public function dispose():void
        {
            this.removeEvent();
            if (this._bg1)
            {
                ObjectUtils.disposeObject(this._bg1);
            };
            this._bg1 = null;
            if (this._bg2)
            {
                ObjectUtils.disposeObject(this._bg2);
            };
            this._bg2 = null;
            if (this._borderBitmap)
            {
                ObjectUtils.disposeObject(this._borderBitmap);
            };
            this._borderBitmap = null;
            if (this._titleBitmap)
            {
                ObjectUtils.disposeObject(this._titleBitmap);
            };
            this._titleBitmap = null;
            if (this._titleBGBitmap)
            {
                ObjectUtils.disposeObject(this._titleBGBitmap);
            };
            this._titleBGBitmap = null;
            if (this._titleTipBitmap)
            {
                ObjectUtils.disposeObject(this._titleTipBitmap);
            };
            this._titleTipBitmap = null;
            if (this._tableBGBitmap)
            {
                ObjectUtils.disposeObject(this._tableBGBitmap);
            };
            this._tableBGBitmap = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
            super.dispose();
        }


    }
}//package platformapi.tencent.view.closeFriend

