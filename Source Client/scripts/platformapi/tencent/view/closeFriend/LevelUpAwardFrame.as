package platformapi.tencent.view.closeFriend
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.InvitedFirendListPlayer;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
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
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
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
         this._playerList.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
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
      
      private function initCell() : void
      {
         var _loc3_:int = 0;
         var _loc4_:LevelUpAwardFrameLevelGift = null;
         var _loc1_:String = LanguageMgr.GetTranslation("tank.view.im.LevelAwardFrame.txt2");
         var _loc2_:Array = _loc1_.split(",");
         _loc3_ = 0;
         while(_loc3_ < 6)
         {
            _loc4_ = new LevelUpAwardFrameLevelGift();
            _loc4_.x = 245 + _loc3_ % 2 * 180;
            _loc4_.y = 108 + int(_loc3_ / 2) * 76;
            addToContent(_loc4_);
            _loc4_.step = _loc3_ + 1;
            _loc4_.info = ItemManager.Instance.getTemplateById(16094 + _loc3_);
            this.cellArray.push(_loc4_);
            _loc4_.addEventListener(MouseEvent.CLICK,this.__onAwardItemClicked);
            _loc3_++;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         PlayerManager.Instance.addEventListener(Event.CHANGE,this.__onUpdate);
      }
      
      private function __onUpdate(param1:Event) : void
      {
         this.update();
      }
      
      private function update() : void
      {
         var _loc1_:LevelUpAwardFrameLevelGift = null;
         var _loc2_:int = 0;
         if(!this._currentItem)
         {
            _loc2_ = 0;
         }
         else
         {
            _loc2_ = this._currentItem.info.awardStep;
         }
         for each(_loc1_ in this.cellArray)
         {
            _loc1_.taken = _loc2_ >= _loc1_.step;
         }
      }
      
      private function __onAwardItemClicked(param1:MouseEvent) : void
      {
         var _loc2_:LevelUpAwardFrameLevelGift = param1.target as LevelUpAwardFrameLevelGift;
         SoundManager.instance.playButtonSound();
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.taken)
         {
            return;
         }
         if(!this._currentItem)
         {
            return;
         }
         SocketManager.Instance.out.sendInvitedFriendAward(1,_loc2_.step,this._currentItem.info.UserID);
      }
      
      private function fillPlayerInfo() : void
      {
         var _loc1_:InvitedFirendListPlayer = null;
         for each(_loc1_ in PlayerManager.Instance.CloseFriendsLevelRewardList)
         {
            this._playerList.vectorListModel.append(_loc1_);
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.playButtonSound();
            ObjectUtils.disposeObject(this);
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __itemClick(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._currentItem)
         {
            this._currentItem = param1.cell as LevelUpAwardFramePlayerItem;
            this._currentItem.setListCellStatus(this._playerList.list,true,param1.index);
         }
         else if(this._currentItem != param1.cell as LevelUpAwardFramePlayerItem)
         {
            this._currentItem.setListCellStatus(this._playerList.list,false,param1.index);
            this._currentItem = param1.cell as LevelUpAwardFramePlayerItem;
            this._currentItem.setListCellStatus(this._playerList.list,true,param1.index);
         }
         this.updateAwardInfo();
      }
      
      private function updateAwardInfo() : void
      {
         this.update();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         PlayerManager.Instance.removeEventListener(Event.CHANGE,this.__onUpdate);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this._bg1)
         {
            ObjectUtils.disposeObject(this._bg1);
         }
         this._bg1 = null;
         if(this._bg2)
         {
            ObjectUtils.disposeObject(this._bg2);
         }
         this._bg2 = null;
         if(this._borderBitmap)
         {
            ObjectUtils.disposeObject(this._borderBitmap);
         }
         this._borderBitmap = null;
         if(this._titleBitmap)
         {
            ObjectUtils.disposeObject(this._titleBitmap);
         }
         this._titleBitmap = null;
         if(this._titleBGBitmap)
         {
            ObjectUtils.disposeObject(this._titleBGBitmap);
         }
         this._titleBGBitmap = null;
         if(this._titleTipBitmap)
         {
            ObjectUtils.disposeObject(this._titleTipBitmap);
         }
         this._titleTipBitmap = null;
         if(this._tableBGBitmap)
         {
            ObjectUtils.disposeObject(this._tableBGBitmap);
         }
         this._tableBGBitmap = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
