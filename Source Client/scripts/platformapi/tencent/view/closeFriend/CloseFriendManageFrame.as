package platformapi.tencent.view.closeFriend
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import platformapi.tencent.TencentExternalInterfaceManager;
   
   public class CloseFriendManageFrame extends Frame implements Disposeable
   {
       
      
      private const MAXCOUNT:int = 6;
      
      private var _titleBg:MutipleImage;
      
      private var _bg:MutipleImage;
      
      private var _successInviteBM:Bitmap;
      
      private var _myInvitorBM:Bitmap;
      
      private var _successInviteText:FilterFrameText;
      
      private var _myInvitorText:FilterFrameText;
      
      private var _pageText:FilterFrameText;
      
      private var _friendListView:CloseFriendListView;
      
      private var _inviteBtn:SimpleBitmapButton;
      
      private var _InvitingAwardButton:SimpleBitmapButton;
      
      private var _grownAward:SimpleBitmapButton;
      
      private var _preButton:SimpleBitmapButton;
      
      private var _nextButton:SimpleBitmapButton;
      
      private var _playerList:Array;
      
      private var _page:int;
      
      private var _pageCount:int;
      
      private var _invitingCount:String;
      
      private var _myInvitor:String;
      
      public function CloseFriendManageFrame()
      {
         super();
         this.addEvent();
      }
      
      override protected function init() : void
      {
         super.init();
         this.titleText = LanguageMgr.GetTranslation("im.closeFriend.closeFriendTitle");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("IM.CloseFriend.Bg");
         addToContent(this._bg);
         this._titleBg = ComponentFactory.Instance.creatComponentByStylename("IM.CloseFriend.title");
         addToContent(this._titleBg);
         this._successInviteBM = ComponentFactory.Instance.creatBitmap("asset.IM.CloseFriend.successInvite");
         addToContent(this._successInviteBM);
         this._myInvitorBM = ComponentFactory.Instance.creatBitmap("asset.IM.CloseFriend.myInvitor");
         addToContent(this._myInvitorBM);
         this._friendListView = new CloseFriendListView();
         PositionUtils.setPos(this._friendListView,"IM.CloseFriend.listViewPos");
         addToContent(this._friendListView);
         this._inviteBtn = ComponentFactory.Instance.creatComponentByStylename("IM.CloseFriend.inviteBtn");
         addToContent(this._inviteBtn);
         this._InvitingAwardButton = ComponentFactory.Instance.creatComponentByStylename("IM.CloseFriend.invitingAwardBtn");
         addToContent(this._InvitingAwardButton);
         this._grownAward = ComponentFactory.Instance.creatComponentByStylename("IM.CloseFriend.grownBtn");
         addToContent(this._grownAward);
         this._preButton = ComponentFactory.Instance.creatComponentByStylename("IM.CloseFriend.preBtn");
         addToContent(this._preButton);
         this._nextButton = ComponentFactory.Instance.creatComponentByStylename("IM.CloseFriend.nextBtn");
         addToContent(this._nextButton);
         this._successInviteText = ComponentFactory.Instance.creatComponentByStylename("IM.CloseFriend.successInviteText.txt");
         addToContent(this._successInviteText);
         this._myInvitorText = ComponentFactory.Instance.creatComponentByStylename("IM.CloseFriend.myInvitorText.txt");
         addToContent(this._myInvitorText);
         this._pageText = ComponentFactory.Instance.creatComponentByStylename("IM.CloseFriend.page.txt");
         addToContent(this._pageText);
         this.initData();
      }
      
      private function initData() : void
      {
         this.playerList = PlayerManager.Instance.CloseFriendsManagerList;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._inviteBtn.addEventListener(MouseEvent.CLICK,this.__onInviteClicked);
         this._InvitingAwardButton.addEventListener(MouseEvent.CLICK,this.__onInviteAwardClicked);
         this._grownAward.addEventListener(MouseEvent.CLICK,this.__onLevelAwardClicked);
         this._preButton.addEventListener(MouseEvent.CLICK,this.preClick);
         this._nextButton.addEventListener(MouseEvent.CLICK,this.nextClick);
      }
      
      private function __onInviteClicked(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         TencentExternalInterfaceManager.invite();
      }
      
      private function __onInviteAwardClicked(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         LayerManager.Instance.addToLayer(ComponentFactory.Instance.creat("IMFrame.inviteAward"),LayerManager.GAME_DYNAMIC_LAYER,true,1);
      }
      
      private function __onLevelAwardClicked(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         LayerManager.Instance.addToLayer(ComponentFactory.Instance.creat("IMFrame.levelUpAward"),LayerManager.GAME_DYNAMIC_LAYER,true,1);
      }
      
      private function preClick(param1:Event) : void
      {
         SoundManager.instance.playButtonSound();
         --this.page;
      }
      
      private function nextClick(param1:Event) : void
      {
         SoundManager.instance.playButtonSound();
         ++this.page;
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._inviteBtn.removeEventListener(MouseEvent.CLICK,this.__onInviteClicked);
         this._InvitingAwardButton.removeEventListener(MouseEvent.CLICK,this.__onInviteAwardClicked);
         this._grownAward.removeEventListener(MouseEvent.CLICK,this.__onLevelAwardClicked);
         this._preButton.removeEventListener(MouseEvent.CLICK,this.preClick);
         this._nextButton.removeEventListener(MouseEvent.CLICK,this.nextClick);
      }
      
      private function showClosefriend(param1:int) : void
      {
         if(this._playerList == null)
         {
            this._pageText.text = "0/0";
            return;
         }
         this._pageText.text = this._page + "/" + this._pageCount;
         var _loc2_:int = param1 * this.MAXCOUNT;
         if(_loc2_ > this._playerList.length)
         {
            _loc2_ = this.playerList.length;
         }
         var _loc3_:Array = new Array();
         var _loc4_:int = (param1 - 1) * this.MAXCOUNT;
         while(_loc4_ < _loc2_)
         {
            _loc3_.push(this._playerList[_loc4_]);
            _loc4_++;
         }
         this._friendListView.playerList = _loc3_;
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.playButtonSound();
            ObjectUtils.disposeObject(this);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this._titleBg.dispose();
         this._titleBg = null;
         this._bg.dispose();
         this._bg = null;
         ObjectUtils.disposeObject(this._successInviteBM);
         this._successInviteBM = null;
         ObjectUtils.disposeObject(this._myInvitorBM);
         this._myInvitorBM = null;
         this._successInviteText.dispose();
         this._successInviteText = null;
         this._myInvitorText.dispose();
         this._myInvitorText = null;
         this._pageText.dispose();
         this._pageText = null;
         this._friendListView.dispose();
         this._friendListView = null;
         this._inviteBtn.dispose();
         this._inviteBtn = null;
         this._InvitingAwardButton.dispose();
         this._InvitingAwardButton = null;
         this._grownAward.dispose();
         this._grownAward = null;
         this._preButton.dispose();
         this._preButton = null;
         this._nextButton.dispose();
         this._nextButton = null;
      }
      
      public function get playerList() : Array
      {
         return this._playerList;
      }
      
      public function set playerList(param1:Array) : void
      {
         this._playerList = param1;
         if(this._playerList == null)
         {
            return;
         }
         this._friendListView.playerList = param1;
         this._pageCount = (this._playerList.length - 1) / this.MAXCOUNT + 1;
         this.page = 1;
         this._successInviteText.text = String(this._playerList.length);
         if(PlayerManager.Instance.inviter)
         {
            this._myInvitorText.text = PlayerManager.Instance.inviter.NickName;
         }
      }
      
      public function get page() : int
      {
         return this._page;
      }
      
      public function set page(param1:int) : void
      {
         this._page = param1;
         this._page = this._page < 0 ? int(0) : int(this._page);
         this._page = this._page < this._pageCount ? int(this._page) : int(this._pageCount);
         this._preButton.enable = this._page > 1;
         this._nextButton.enable = this._page < this._pageCount;
         this.showClosefriend(this._page);
      }
      
      public function get myInvitor() : String
      {
         return this._myInvitor;
      }
      
      public function set myInvitor(param1:String) : void
      {
         this._myInvitor = param1;
         this._myInvitorText.text = this._myInvitor;
      }
      
      public function get invitingCount() : String
      {
         return this._invitingCount;
      }
      
      public function set invitingCount(param1:String) : void
      {
         this._invitingCount = param1;
         this._successInviteText.text = this._invitingCount;
      }
   }
}
