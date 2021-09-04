package im
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.list.DropList;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.data.player.SelfInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.PlayerPortraitView;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.utils.Dictionary;
   import road7th.utils.StringHelper;
   import vip.VipController;
   
   public class IMView extends Frame
   {
      
      public static var IS_SHOW_SUB:Boolean;
      
      private static const ALL_STATE:Array = [new PlayerState(PlayerState.ONLINE,PlayerState.MANUAL),new PlayerState(PlayerState.AWAY,PlayerState.MANUAL),new PlayerState(PlayerState.BUSY,PlayerState.MANUAL),new PlayerState(PlayerState.NO_DISTRUB,PlayerState.MANUAL),new PlayerState(PlayerState.SHOPPING,PlayerState.MANUAL)];
      
      public static const FRIEND_LIST:int = 0;
      
      public static const CMFRIEND_LIST:int = 2;
      
      public static const CONSORTIA_LIST:int = 1;
      
      public static const LIKEFRIEND_LIST:int = 3;
       
      
      private var _CMSelectedBtn:SelectedTextButton;
      
      private var _IMSelectedBtn:SelectedTextButton;
      
      private var _likePersonSelectedBtn:SelectedTextButton;
      
      private var _addBlackFrame:AddBlackFrame;
      
      private var _addBleak:TextButton;
      
      private var _addFriend:TextButton;
      
      private var _inviteBtn:TextButton;
      
      private var _addFriendFrame:AddFriendFrame;
      
      private var _bg:Bitmap;
      
      private var _consortiaListBtn:SelectedTextButton;
      
      private var _levelIcon:LevelIcon;
      
      private var _selectedButtonGroup:SelectedButtonGroup;
      
      private var _currentListType:int;
      
      private var _friendList:IMListView;
      
      private var _consortiaList:ConsortiaListView;
      
      private var _CMfriendList:CMFriendList;
      
      private var _likeFriendList:LikeFriendListView;
      
      private var _listContent:Sprite;
      
      private var _selfName:FilterFrameText;
      
      private var _selfNameBg:Bitmap;
      
      private var _vipName:GradientText;
      
      private var _playerPortrait:PlayerPortraitView;
      
      private var _imLookupView:IMLookupView;
      
      private var _stateSelectBtn:StateIconButton;
      
      private var _stateList:DropList;
      
      private var _replyInput:AutoReplyInput;
      
      private var _state:FilterFrameText;
      
      private var _hBox:HBox;
      
      private var _btnBg:Scale9CornerImage;
      
      public function IMView()
      {
         super();
         super.init();
         this.initContent();
         this.initEvent();
      }
      
      private function initContent() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.game.ToolStripView.friend");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.ddtimPlayerList.bg");
         addToContent(this._bg);
         this._btnBg = ComponentFactory.Instance.creatComponentByStylename("ddtim.imFrame.btnBg");
         addToContent(this._btnBg);
         this.showFigure();
         this._selfNameBg = ComponentFactory.Instance.creatBitmap("asset.ddtimplayerName.bg");
         addToContent(this._selfNameBg);
         this._selfName = ComponentFactory.Instance.creatComponentByStylename("IM.IMList.selfName");
         this._selfName.text = PlayerManager.Instance.Self.NickName;
         if(PlayerManager.Instance.Self.IsVIP)
         {
            this._vipName = VipController.instance.getVipNameTxt(138,PlayerManager.Instance.Self.VIPtype);
            this._vipName.textSize = 18;
            this._vipName.x = this._selfName.x;
            this._vipName.y = this._selfName.y;
            this._vipName.text = this._selfName.text;
            addToContent(this._vipName);
         }
         else
         {
            addToContent(this._selfName);
         }
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("IM.btnHbox");
         addToContent(this._hBox);
         this._IMSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("IMView.IMSelectedBtn");
         this._IMSelectedBtn.text = LanguageMgr.GetTranslation("tank.view.im.Friend");
         this._hBox.addChild(this._IMSelectedBtn);
         this._consortiaListBtn = ComponentFactory.Instance.creatComponentByStylename("IMView.consortiaListBtn");
         this._consortiaListBtn.text = LanguageMgr.GetTranslation("tank.view.im.consorita");
         this._hBox.addChild(this._consortiaListBtn);
         if(PathManager.CommnuntyMicroBlog())
         {
            this._CMSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("IMView.MBSelectedBtn");
            this._CMSelectedBtn.text = LanguageMgr.GetTranslation("tank.view.im.MB");
            if(SharedManager.Instance.isCommunity && PathManager.CommunityExist())
            {
               this._hBox.addChild(this._CMSelectedBtn);
            }
         }
         else
         {
            this._CMSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("IMView.CMSelectedBtn");
            this._CMSelectedBtn.text = LanguageMgr.GetTranslation("tank.view.im.CM");
            if(SharedManager.Instance.isCommunity && PathManager.CommunityExist())
            {
               this._hBox.addChild(this._CMSelectedBtn);
            }
         }
         if(!(SharedManager.Instance.isCommunity && PathManager.CommunityExist()))
         {
            this._likePersonSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("IMView.LikeSelectedBtnII");
         }
         else
         {
            this._likePersonSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("IMView.LikeSelectedBtn");
         }
         this._likePersonSelectedBtn.text = LanguageMgr.GetTranslation("tank.view.im.Like");
         this._hBox.addChild(this._likePersonSelectedBtn);
         this._selectedButtonGroup = new SelectedButtonGroup();
         this._selectedButtonGroup.addSelectItem(this._IMSelectedBtn);
         this._selectedButtonGroup.addSelectItem(this._consortiaListBtn);
         this._selectedButtonGroup.addSelectItem(this._CMSelectedBtn);
         this._selectedButtonGroup.addSelectItem(this._likePersonSelectedBtn);
         this._selectedButtonGroup.selectIndex = 0;
         this._hBox.arrange();
         this._addFriend = ComponentFactory.Instance.creatComponentByStylename("IM.AddFriendBtn");
         this._addFriend.text = LanguageMgr.GetTranslation("tank.view.im.addFriendBtn");
         this._addFriend.tipData = LanguageMgr.GetTranslation("tank.view.im.AddFriendFrame.add");
         addToContent(this._addFriend);
         this._addBleak = ComponentFactory.Instance.creatComponentByStylename("IM.AddBleakBtn");
         this._addBleak.text = LanguageMgr.GetTranslation("tank.view.im.addBleakBtn");
         this._addBleak.tipData = LanguageMgr.GetTranslation("tank.view.im.AddBlackListFrame.btnText");
         addToContent(this._addBleak);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("IM.imView.LevelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_BIG);
         addToContent(this._levelIcon);
         this._listContent = new Sprite();
         addToContent(this._listContent);
         this._imLookupView = new IMLookupView();
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("IM.IMView.IMLookupViewPos");
         this._imLookupView.x = _loc1_.x;
         this._imLookupView.y = _loc1_.y;
         addToContent(this._imLookupView);
         this._stateSelectBtn = ComponentFactory.Instance.creatCustomObject("IM.stateIconButton");
         addToContent(this._stateSelectBtn);
         this._stateList = ComponentFactory.Instance.creatComponentByStylename("IMView.stateList");
         this._stateList.targetDisplay = this._stateSelectBtn;
         this._stateList.showLength = 5;
         this._state = ComponentFactory.Instance.creatComponentByStylename("IM.stateIconBtn.stateNameTxt");
         this._state.text = "[" + PlayerManager.Instance.Self.playerState.convertToString() + "]";
         addToContent(this._state);
         this._replyInput = ComponentFactory.Instance.creatCustomObject("im.autoReplyInput");
         addToContent(this._replyInput);
         var _loc2_:SelfInfo = PlayerManager.Instance.Self;
         this._levelIcon.setInfo(_loc2_.Grade,_loc2_.Repute,_loc2_.WinCount,_loc2_.TotalCount,_loc2_.FightPower,_loc2_.Offer,true,false);
         this._currentListType = 0;
         this.setListType();
         this.__onStateChange(new PlayerPropertyEvent("*",new Dictionary()));
      }
      
      private function initEvent() : void
      {
         this._IMSelectedBtn.addEventListener(MouseEvent.CLICK,this.__IMBtnClick);
         this._CMSelectedBtn.addEventListener(MouseEvent.CLICK,this.__CMBtnClick);
         this._consortiaListBtn.addEventListener(MouseEvent.CLICK,this.__consortiaListBtnClick);
         this._likePersonSelectedBtn.addEventListener(MouseEvent.CLICK,this.__likeBtnClick);
         this._addFriend.addEventListener(MouseEvent.CLICK,this.__addFriendBtnClick);
         this._addBleak.addEventListener(MouseEvent.CLICK,this.__addBleakBtnClick);
         this._selectedButtonGroup.addEventListener(Event.CHANGE,this.__buttonGroupChange);
         this._stateSelectBtn.addEventListener(MouseEvent.CLICK,this.__stateSelectClick);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__hideStateList);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onStateChange);
      }
      
      private function __CMBtnClick(param1:MouseEvent) : void
      {
         IMController.Instance.createConsortiaLoader();
         IMController.Instance.addEventListener(Event.COMPLETE,this.__CMFriendLoadComplete);
         SoundManager.instance.play("008");
      }
      
      private function __CMFriendLoadComplete(param1:Event) : void
      {
         IMController.Instance.removeEventListener(Event.COMPLETE,this.__CMFriendLoadComplete);
         this._currentListType = CMFRIEND_LIST;
         this.setListType();
      }
      
      private function __IMBtnClick(param1:MouseEvent) : void
      {
         this._currentListType = FRIEND_LIST;
         this.setListType();
         SoundManager.instance.play("008");
      }
      
      private function __inviteBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:URLRequest = null;
         var _loc3_:URLVariables = null;
         var _loc4_:URLLoader = null;
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("im.IMView.inviteInfo"));
         SoundManager.instance.play("008");
         if(!StringHelper.isNullOrEmpty(PathManager.CommunityInvite()))
         {
            _loc2_ = new URLRequest(PathManager.CommunityInvite());
            _loc3_ = new URLVariables();
            _loc3_["fuid"] = String(PlayerManager.Instance.Self.LoginName);
            _loc3_["fnick"] = PlayerManager.Instance.Self.NickName;
            _loc3_["tuid"] = this._CMfriendList.currentCMFInfo.UserName;
            _loc3_["serverid"] = String(ServerManager.Instance.AgentID);
            _loc3_["rnd"] = Math.random();
            _loc2_.data = _loc3_;
            _loc4_ = new URLLoader(_loc2_);
            _loc4_.load(_loc2_);
         }
      }
      
      private function __consortiaListBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.ConsortiaID <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("im.IMView.infoText"));
            this._selectedButtonGroup.selectIndex = this._currentListType;
            return;
         }
         this._currentListType = CONSORTIA_LIST;
         this.setListType();
      }
      
      private function __likeBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._currentListType = LIKEFRIEND_LIST;
         this.setListType();
      }
      
      private function __addBleakBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._addFriendFrame && this._addFriendFrame.parent)
         {
            this._addFriendFrame.dispose();
            this._addFriendFrame = null;
         }
         if(this._addBlackFrame && this._addBlackFrame.parent)
         {
            this._addBlackFrame.dispose();
            this._addBlackFrame = null;
            return;
         }
         this._addBlackFrame = ComponentFactory.Instance.creat("AddBlackFrame");
         LayerManager.Instance.addToLayer(this._addBlackFrame,LayerManager.GAME_DYNAMIC_LAYER);
         if(StateManager.currentStateType == StateType.MAIN)
         {
            ChatManager.Instance.lock = false;
         }
         if(StateManager.isInFight)
         {
            ComponentSetting.SEND_USELOG_ID(127);
         }
      }
      
      private function __buttonGroupChange(param1:Event) : void
      {
         this._hBox.arrange();
      }
      
      private function __addFriendBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._currentListType == FRIEND_LIST || this._currentListType == CONSORTIA_LIST || this._currentListType == LIKEFRIEND_LIST)
         {
            if(this._addBlackFrame && this._addBlackFrame.parent)
            {
               this._addBlackFrame.dispose();
               this._addBlackFrame = null;
            }
            if(this._addFriendFrame && this._addFriendFrame.parent)
            {
               this._addFriendFrame.dispose();
               this._addFriendFrame = null;
               return;
            }
            this._addFriendFrame = ComponentFactory.Instance.creat("AddFriendFrame");
            LayerManager.Instance.addToLayer(this._addFriendFrame,LayerManager.GAME_DYNAMIC_LAYER);
         }
         else if(this._CMfriendList && this._CMfriendList.currentCMFInfo && this._CMfriendList.currentCMFInfo.IsExist)
         {
            IMController.Instance.addFriend(this._CMfriendList.currentCMFInfo.NickName);
         }
         if(StateManager.currentStateType == StateType.MAIN)
         {
            ChatManager.Instance.lock = false;
         }
         if(StateManager.isInFight)
         {
            ComponentSetting.SEND_USELOG_ID(126);
         }
      }
      
      private function showFigure() : void
      {
         var _loc1_:PlayerInfo = PlayerManager.Instance.Self;
         this._playerPortrait = ComponentFactory.Instance.creatCustomObject("im.PlayerPortrait",["right",0,ComponentFactory.Instance.creatBitmap("asset.IM.playerIconBg")]);
         this._playerPortrait.info = _loc1_;
         addToContent(this._playerPortrait);
      }
      
      private function setListType() : void
      {
         if(this._friendList && this._friendList.parent)
         {
            this._friendList.parent.removeChild(this._friendList);
            this._friendList.dispose();
            this._friendList = null;
         }
         if(this._consortiaList && this._consortiaList.parent)
         {
            this._consortiaList.parent.removeChild(this._consortiaList);
            this._consortiaList.dispose();
            this._consortiaList = null;
         }
         if(this._CMfriendList && this._CMfriendList.parent)
         {
            this._CMfriendList.parent.removeChild(this._CMfriendList);
            this._CMfriendList.dispose();
            this._CMfriendList = null;
         }
         if(this._likeFriendList && this._likeFriendList.parent)
         {
            this._likeFriendList.parent.removeChild(this._likeFriendList);
            this._likeFriendList.dispose();
            this._likeFriendList = null;
         }
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("IM.IMList.listPos");
         switch(this._currentListType)
         {
            case 0:
               this._friendList = new IMListView();
               this._friendList.x = 8;
               this._friendList.y = _loc1_.x;
               this._listContent.addChild(this._friendList);
               this._addBleak.visible = true;
               this._addFriend.visible = true;
               this._imLookupView.listType = FRIEND_LIST;
               break;
            case 1:
               this._consortiaList = new ConsortiaListView();
               this._consortiaList.x = 8;
               this._consortiaList.y = _loc1_.x;
               this._listContent.addChild(this._consortiaList);
               this._addBleak.visible = true;
               this._addFriend.visible = true;
               this._imLookupView.listType = FRIEND_LIST;
               break;
            case 2:
               this._CMfriendList = new CMFriendList();
               this._CMfriendList.x = 8;
               this._CMfriendList.y = _loc1_.y;
               if(this._listContent)
               {
                  this._listContent.addChild(this._CMfriendList);
               }
               this._addFriend.visible = false;
               this._addBleak.visible = false;
               this._imLookupView.listType = CMFRIEND_LIST;
               break;
            case LIKEFRIEND_LIST:
               this._likeFriendList = new LikeFriendListView();
               this._likeFriendList.x = 8;
               this._likeFriendList.y = _loc1_.x;
               if(this._listContent)
               {
                  this._listContent.addChild(this._likeFriendList);
               }
               this._addBleak.visible = true;
               this._addFriend.visible = true;
               this._imLookupView.listType = LIKEFRIEND_LIST;
         }
      }
      
      private function __onStateChange(param1:PlayerPropertyEvent) : void
      {
         if(PlayerManager.Instance.Self.playerState.StateID == 1)
         {
            this._replyInput.visible = false;
         }
         else
         {
            this._replyInput.visible = true;
         }
         if(param1.changedProperties["State"])
         {
            this._state.text = "[" + PlayerManager.Instance.Self.playerState.convertToString() + "]";
            this._stateSelectBtn.setFrame(PlayerManager.Instance.Self.playerState.StateID);
         }
      }
      
      private function __hideStateList(param1:MouseEvent) : void
      {
         if(this._stateList.parent)
         {
            this._stateList.parent.removeChild(this._stateList);
         }
      }
      
      private function __stateSelectClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         if(this._stateList.parent == null)
         {
            addToContent(this._stateList);
         }
         this._stateList.dataList = ALL_STATE;
      }
      
      private function removeEvent() : void
      {
         this._IMSelectedBtn.removeEventListener(MouseEvent.CLICK,this.__IMBtnClick);
         this._CMSelectedBtn.removeEventListener(MouseEvent.CLICK,this.__CMBtnClick);
         this._consortiaListBtn.removeEventListener(MouseEvent.CLICK,this.__consortiaListBtnClick);
         this._likePersonSelectedBtn.removeEventListener(MouseEvent.CLICK,this.__likeBtnClick);
         this._addFriend.removeEventListener(MouseEvent.CLICK,this.__addFriendBtnClick);
         this._addBleak.removeEventListener(MouseEvent.CLICK,this.__addBleakBtnClick);
         IMController.Instance.removeEventListener(Event.COMPLETE,this.__CMFriendLoadComplete);
         this._stateSelectBtn.removeEventListener(MouseEvent.CLICK,this.__stateSelectClick);
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__hideStateList);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onStateChange);
      }
      
      override public function dispose() : void
      {
         IMController.Instance.isShow = false;
         this.removeEvent();
         if(this._bg && this._bg.parent)
         {
            this._bg.parent.removeChild(this._bg);
            this._bg = null;
         }
         if(this._btnBg && this._btnBg.parent)
         {
            this._btnBg.parent.removeChild(this._btnBg);
            this._btnBg.dispose();
            this._btnBg = null;
         }
         if(this._listContent && this._listContent.parent)
         {
            this._listContent.parent.removeChild(this._listContent);
            this._listContent = null;
         }
         if(this._selfName && this._selfName.parent)
         {
            this._selfName.parent.removeChild(this._selfName);
            this._selfName.dispose();
            this._selfName = null;
         }
         if(this._levelIcon && this._levelIcon.parent)
         {
            this._levelIcon.parent.removeChild(this._levelIcon);
            this._levelIcon.dispose();
            this._levelIcon = null;
         }
         if(this._consortiaListBtn && this._consortiaListBtn.parent)
         {
            this._consortiaListBtn.parent.removeChild(this._consortiaListBtn);
            this._consortiaListBtn.dispose();
            this._consortiaListBtn = null;
         }
         if(this._likePersonSelectedBtn)
         {
            ObjectUtils.disposeObject(this._likePersonSelectedBtn);
         }
         this._likePersonSelectedBtn = null;
         if(this._addFriend && this._addFriend.parent)
         {
            this._addFriend.parent.removeChild(this._addFriend);
            this._addFriend.dispose();
            this._addFriend = null;
         }
         if(this._addBleak && this._addBleak.parent)
         {
            this._addBleak.parent.removeChild(this._addBleak);
            this._addBleak.dispose();
            this._addBleak = null;
         }
         if(this._IMSelectedBtn && this._IMSelectedBtn.parent)
         {
            this._IMSelectedBtn.parent.removeChild(this._IMSelectedBtn);
            this._IMSelectedBtn.dispose();
            this._IMSelectedBtn = null;
         }
         if(this._CMSelectedBtn && this._CMSelectedBtn.parent)
         {
            this._CMSelectedBtn.parent.removeChild(this._CMSelectedBtn);
            this._CMSelectedBtn.dispose();
            this._CMSelectedBtn = null;
         }
         if(this._imLookupView && this._imLookupView.parent)
         {
            this._imLookupView.parent.removeChild(this._imLookupView);
            this._imLookupView.dispose();
            this._imLookupView = null;
         }
         if(this._friendList && this._friendList.parent)
         {
            this._friendList.parent.removeChild(this._friendList);
            this._friendList.dispose();
            this._friendList = null;
         }
         if(this._consortiaList && this._consortiaList.parent)
         {
            this._consortiaList.parent.removeChild(this._consortiaList);
            this._consortiaList.dispose();
            this._consortiaList = null;
         }
         if(this._CMfriendList && this._CMfriendList.parent)
         {
            this._CMfriendList.parent.removeChild(this._CMfriendList);
            this._CMfriendList.dispose();
            this._CMfriendList = null;
         }
         if(this._addFriendFrame)
         {
            this._addFriendFrame.dispose();
            this._addFriendFrame = null;
         }
         if(this._addBlackFrame)
         {
            this._addBlackFrame.dispose();
            this._addBlackFrame = null;
         }
         if(this._stateList)
         {
            this._stateList.dispose();
            this._stateList = null;
         }
         if(this._stateSelectBtn)
         {
            this._stateSelectBtn.dispose();
            this._stateSelectBtn = null;
         }
         if(this._likeFriendList)
         {
            this._likeFriendList.dispose();
            this._likeFriendList = null;
         }
         if(this._vipName)
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         this._selectedButtonGroup.dispose();
         this._selectedButtonGroup = null;
         super.dispose();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
