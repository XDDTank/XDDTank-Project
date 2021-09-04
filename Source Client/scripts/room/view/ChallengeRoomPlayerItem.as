package room.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.events.RoomEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.FaceContainer;
   import ddt.view.PlayerPortraitView;
   import ddt.view.chat.ChatEvent;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.GameManager;
   import game.model.GameInfo;
   import room.RoomManager;
   import room.events.RoomPlayerEvent;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import vip.VipController;
   
   public class ChallengeRoomPlayerItem extends Sprite implements Disposeable
   {
       
      
      private var _bg:ScaleFrameImage;
      
      private var _ready:Bitmap;
      
      private var _nameTxt:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _levelIcon:LevelIcon;
      
      private var _portrait:PlayerPortraitView;
      
      private var _place:int;
      
      private var _face:FaceContainer;
      
      private var _info:RoomPlayer;
      
      private var _opened:Boolean;
      
      private var _hostPic:Bitmap;
      
      private var _hitArea:RoomPlayerArea;
      
      private var _switchInEnabled:Boolean;
      
      private var _onClickPlayerTip:RoomTouchItem;
      
      public function ChallengeRoomPlayerItem(param1:int)
      {
         super();
         this._place = param1;
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.smallPlayerItemGBAsset");
         this._bg.setFrame(3);
         addChild(this._bg);
         this._face = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.playerItem.face");
         addChild(this._face);
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.smallPlayerItem.facePos");
         this._face.x = _loc1_.x;
         this._face.y = _loc1_.y;
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("asset.ddroom.playerItem.NameTxt");
         this._hitArea = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.smallplayerItemClickArea");
         var _loc2_:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.smallPlayerItem.hitRect");
         this._hitArea.graphics.beginFill(0,0);
         this._hitArea.graphics.drawRect(_loc2_.x,_loc2_.y,_loc2_.width,_loc2_.height);
         this._hitArea.graphics.endFill();
         this._hitArea.buttonMode = true;
         addChild(this._hitArea);
      }
      
      public function set switchInEnabled(param1:Boolean) : void
      {
         this._switchInEnabled = param1;
         if(this._switchInEnabled && this._opened)
         {
            this._hitArea.visible = this._switchInEnabled;
         }
      }
      
      private function initEvents() : void
      {
         this._hitArea.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         RoomManager.Instance.current.addEventListener(RoomEvent.STARTED_CHANGED,this.__startHandler);
         ChatManager.Instance.addEventListener(ChatEvent.SHOW_FACE,this.__getFace);
         RoomManager.Instance.current.selfRoomPlayer.addEventListener(RoomPlayerEvent.IS_HOST_CHANGE,this.__updateButton);
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         SoundManager.instance.play("008");
         if(this._info)
         {
            if(this._onClickPlayerTip == null)
            {
               this._onClickPlayerTip = ComponentFactory.Instance.creatCustomObject("ddtroom.ClickTip");
            }
            this._onClickPlayerTip._place = this._info.place;
            this._onClickPlayerTip.roomPlayer = this._info;
            this._onClickPlayerTip.info = this._info.playerInfo;
            _loc2_ = this.localToGlobal(new Point(mouseX,mouseY));
            this._onClickPlayerTip.x = _loc2_.x;
            this._onClickPlayerTip.y = _loc2_.y;
            this._onClickPlayerTip.setVisible = true;
         }
         else
         {
            if(this._switchInEnabled && !RoomManager.Instance.current.selfRoomPlayer.isHost)
            {
               GameInSocketOut.sendGameRoomPlaceState(RoomManager.Instance.current.selfRoomPlayer.place,-1,true,this._place);
               return;
            }
            if(this._opened)
            {
               if(RoomManager.Instance.current.type == RoomInfo.CHALLENGE_ROOM)
               {
                  if(RoomManager.Instance.canSmallCloseItem(this))
                  {
                     GameInSocketOut.sendGameRoomPlaceState(this._place,!!this._opened ? int(0) : int(-1));
                  }
                  else
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.position"));
                  }
               }
               else
               {
                  GameInSocketOut.sendGameRoomPlaceState(this._place,!!this._opened ? int(0) : int(-1));
               }
            }
            else if(PlayerManager.Instance.Self.Grade >= 6)
            {
               GameInSocketOut.sendGameRoomPlaceState(this._place,!!this._opened ? int(0) : int(-1));
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.cantOpenMuti"));
            }
         }
      }
      
      private function __startHandler(param1:RoomEvent) : void
      {
         this.updateButtons();
      }
      
      private function __updateButton(param1:RoomPlayerEvent) : void
      {
         this.updateButtons();
      }
      
      private function __infoStateChange(param1:RoomPlayerEvent) : void
      {
         this.updatePlayerState();
         this.updateButtons();
      }
      
      private function __playerInfoChange(param1:PlayerPropertyEvent) : void
      {
         this._info.playerInfo.currentPet = this._info.playerInfo.pets[0];
         this.updateInfoView();
      }
      
      private function __getFace(param1:ChatEvent) : void
      {
         if(this._info == null)
         {
            return;
         }
         var _loc2_:Object = param1.data;
         if(_loc2_["playerid"] == this._info.playerInfo.ID)
         {
            this._face.setFace(_loc2_["faceid"]);
         }
         addChild(this._face);
      }
      
      public function get info() : RoomPlayer
      {
         return this._info;
      }
      
      public function set place(param1:int) : void
      {
         this._place = param1;
      }
      
      public function get place() : int
      {
         return this._place;
      }
      
      public function set info(param1:RoomPlayer) : void
      {
         var _loc2_:GameInfo = null;
         if(this._info)
         {
            this._info.removeEventListener(RoomPlayerEvent.READY_CHANGE,this.__infoStateChange);
            this._info.removeEventListener(RoomPlayerEvent.IS_HOST_CHANGE,this.__infoStateChange);
            this._info.playerInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerInfoChange);
            this._info = null;
            this._face.clearFace();
         }
         this._info = param1;
         if(this._info == null)
         {
            if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
            {
               this.switchInEnabled = true;
            }
         }
         if(this._info)
         {
            _loc2_ = GameManager.Instance.Current;
            if(_loc2_ != null && _loc2_.hasNextMission && RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM)
            {
               _loc2_.viewerToLiving(this._info.playerInfo.ID);
            }
            this._info.addEventListener(RoomPlayerEvent.READY_CHANGE,this.__infoStateChange);
            this._info.addEventListener(RoomPlayerEvent.IS_HOST_CHANGE,this.__infoStateChange);
            this._info.playerInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerInfoChange);
         }
         if(this._info && this._info.isSelf)
         {
            if(PlayerManager.Instance.Self.isUpGradeInGame && PlayerManager.Instance.Self.Grade > 15)
            {
               PlayerManager.Instance.Self.isUpGradeInGame = false;
            }
         }
         this.updateView();
      }
      
      private function headMask() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(0);
         _loc1_.graphics.drawRect(7,29,69,56);
         _loc1_.graphics.endFill();
         return _loc1_;
      }
      
      private function updateView() : void
      {
         this.updateBackground();
         this.updateInfoView();
         this.updateButtons();
         this.updatePlayerState();
         if(this._info)
         {
         }
      }
      
      private function updateBackground() : void
      {
         if(this._info)
         {
            this._bg.setFrame(3);
         }
         else
         {
            this._bg.setFrame(!!this._opened ? int(1) : int(2));
         }
      }
      
      private function updateInfoView() : void
      {
         var _loc1_:Sprite = null;
         if(this._ready && this._ready.visible)
         {
            this._ready.visible = false;
         }
         if(this._info)
         {
            if(this._portrait)
            {
               ObjectUtils.disposeObject(this._portrait);
               this._portrait = null;
            }
            if(this._portrait == null)
            {
               _loc1_ = this.headMask();
               this._portrait = ComponentFactory.Instance.creatCustomObject("ddtChallengeRoom.PortraitView",["left",1]);
               this._portrait.info = this._info.playerInfo;
               this._portrait.isShowFrame = false;
               addChild(this._portrait);
            }
            if(this._levelIcon == null)
            {
               this._levelIcon = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.playerItem.LevelIcon");
               PositionUtils.setPos(this._levelIcon,"asset.ddtChallengeSmallItemLevel.pos");
               addChild(this._levelIcon);
            }
            this._levelIcon.setInfo(this._info.playerInfo.Grade,this._info.playerInfo.Repute,this._info.playerInfo.WinCount,this._info.playerInfo.TotalCount,this._info.playerInfo.FightPower,this._info.playerInfo.Offer,true,false);
            if(this._info.isSelf)
            {
               this._levelIcon.allowClick();
            }
            this._nameTxt.text = this._info.playerInfo.NickName;
            if(this._nameTxt.text.length > 5)
            {
               this._nameTxt.text = this._nameTxt.text.substr(0,4) + ".";
            }
            PositionUtils.setPos(this._nameTxt,"asset.ddtChallengeSmallItemNameTxt.pos");
            addChild(this._nameTxt);
            if(this._info.playerInfo.IsVIP)
            {
               ObjectUtils.disposeObject(this._vipName);
               this._vipName = VipController.instance.getVipNameTxt(106,this._info.playerInfo.VIPtype);
               this._vipName.x = this._nameTxt.x;
               this._vipName.y = this._nameTxt.y;
               this._vipName.text = this._nameTxt.text;
               addChild(this._vipName);
            }
            PositionUtils.adaptNameStyle(this.info.playerInfo,this._nameTxt,this._vipName);
            if(this._info.isReady)
            {
               if(!this._ready)
               {
                  this._ready = ComponentFactory.Instance.creatBitmap("asset.ddchallengeSmallPlayerItem.ready");
               }
               addChild(this._ready);
               this._ready.visible = true;
            }
            else if(this._ready && this._ready.visible)
            {
               this._ready.visible = false;
            }
         }
         else
         {
            if(this._portrait)
            {
               ObjectUtils.disposeObject(this._portrait);
               this._portrait = null;
            }
            ObjectUtils.disposeObject(this._levelIcon);
            this._levelIcon = null;
            this._nameTxt.text = "";
            DisplayUtils.removeDisplay(this._vipName);
         }
      }
      
      public function updateButtons() : void
      {
         if(this._info)
         {
            this._hitArea.visible = true;
         }
         else if(RoomManager.Instance.current.started)
         {
            this._hitArea.visible = false;
         }
         else if(RoomManager.Instance.current.selfRoomPlayer.isViewer && this._switchInEnabled && this._opened)
         {
            this._hitArea.visible = true;
         }
         else
         {
            this._hitArea.visible = RoomManager.Instance.current.selfRoomPlayer.isHost;
         }
      }
      
      public function updatePlayerState() : void
      {
         if(this._info)
         {
            if(this._info.isReady)
            {
               if(!this._ready)
               {
                  this._ready = ComponentFactory.Instance.creatBitmap("asset.ddchallengeSmallPlayerItem.ready");
               }
               addChild(this._ready);
               this._ready.visible = true;
            }
            else if(this._ready && this._ready.visible)
            {
               this._ready.visible = false;
            }
            if(this._info.isHost)
            {
               if(!this._hostPic)
               {
                  this._hostPic = ComponentFactory.Instance.creatBitmap("asset.ddtroom.SmallplayerItem.host");
               }
               addChild(this._hostPic);
               this._hostPic.visible = true;
            }
            else if(this._hostPic && this._hostPic.visible)
            {
               this._hostPic.visible = false;
            }
         }
         else
         {
            if(this._ready && this._ready.visible)
            {
               this._ready.visible = false;
            }
            if(this._hostPic && this._hostPic.visible)
            {
               this._hostPic.visible = false;
            }
         }
      }
      
      private function removeEvents() : void
      {
         RoomManager.Instance.current.removeEventListener(RoomEvent.STARTED_CHANGED,this.__startHandler);
         ChatManager.Instance.removeEventListener(ChatEvent.SHOW_FACE,this.__getFace);
         if(this._info)
         {
            this._info.removeEventListener(RoomPlayerEvent.READY_CHANGE,this.__infoStateChange);
            this._info.removeEventListener(RoomPlayerEvent.IS_HOST_CHANGE,this.__infoStateChange);
            this._info.playerInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerInfoChange);
         }
         RoomManager.Instance.current.selfRoomPlayer.removeEventListener(RoomPlayerEvent.IS_HOST_CHANGE,this.__updateButton);
      }
      
      public function set opened(param1:Boolean) : void
      {
         this._opened = param1;
         this.updateView();
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg == null;
         }
         if(this._vipName)
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         if(this._levelIcon)
         {
            this._levelIcon.dispose();
         }
         this._levelIcon = null;
         if(this._face)
         {
            this._face.dispose();
         }
         this._face = null;
         ObjectUtils.disposeObject(this._portrait);
         if(this._hitArea)
         {
            ObjectUtils.disposeObject(this._hitArea);
         }
         this._hitArea = null;
         this._info = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
