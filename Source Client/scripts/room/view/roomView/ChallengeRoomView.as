package room.view.roomView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.player.SelfInfo;
   import ddt.events.RoomEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import game.view.DefyAfficheViewFrame;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import room.view.ChallengeRoomPlayerItem;
   import room.view.RoomPlayerItem;
   import room.view.RoomViewerItem;
   import room.view.smallMapInfoPanel.ChallengeRoomSmallMapInfoPanel;
   
   public class ChallengeRoomView extends BaseRoomView implements Disposeable
   {
      
      public static const PLAYER_POS_CHANGE:String = "playerposchange";
       
      
      private var _bg:Bitmap;
      
      private var _vsBg:Bitmap;
      
      private var _btnSwitchTeam:BaseButton;
      
      private var _playerItemContainers:Vector.<SimpleTileList>;
      
      private var _smallMapInfoPanel:ChallengeRoomSmallMapInfoPanel;
      
      private var _blueTeamBitmap:MovieClip;
      
      private var _redTeamBitmap:MovieClip;
      
      private var _self:SelfInfo;
      
      private var _ItemArr:Array;
      
      private var _clickTimer:Timer;
      
      public function ChallengeRoomView(param1:RoomInfo)
      {
         super(param1);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._btnSwitchTeam.dispose();
         this._smallMapInfoPanel.dispose();
         removeChild(this._bg);
         this._bg = null;
         removeChild(this._vsBg);
         this._vsBg = null;
         this._btnSwitchTeam = null;
         this._playerItemContainers = null;
         this._smallMapInfoPanel = null;
         this.__clickTimerHandler(null);
      }
      
      override protected function updateButtons() : void
      {
         var _loc4_:RoomPlayerItem = null;
         var _loc5_:ChallengeRoomPlayerItem = null;
         super.updateButtons();
         if(_info.selfRoomPlayer.isViewer)
         {
            this._btnSwitchTeam.enable = false;
            return;
         }
         if(RoomManager.Instance.current.selfRoomPlayer.isHost)
         {
            this._btnSwitchTeam.enable = _startBtn.visible;
            _cancelBtn.visible = !_startBtn.visible;
         }
         else
         {
            this._btnSwitchTeam.enable = _prepareBtn.visible;
            _cancelBtn.visible = !_prepareBtn.visible;
         }
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < _playerItems.length)
         {
            if(_loc3_ % 2 != 1)
            {
               _loc4_ = _playerItems[_loc3_] as RoomPlayerItem;
               if(_loc4_.info && _loc4_.info.team == RoomPlayer.BLUE_TEAM)
               {
                  _loc1_ = true;
               }
               if(_loc4_.info && _loc4_.info.team == RoomPlayer.RED_TEAM)
               {
                  _loc2_ = true;
               }
            }
            else
            {
               _loc5_ = _playerItems[_loc3_] as ChallengeRoomPlayerItem;
               if(_loc5_.info && _loc5_.info.team == RoomPlayer.BLUE_TEAM)
               {
                  _loc1_ = true;
               }
               if(_loc5_.info && _loc5_.info.team == RoomPlayer.RED_TEAM)
               {
                  _loc2_ = true;
               }
            }
            _loc3_++;
         }
         if(!_loc1_ || !_loc2_)
         {
            _startBtn.removeEventListener(MouseEvent.CLICK,__startClick);
            _startBtn.filters = [ComponentFactory.Instance.model.getSet("grayFilter")];
            if(_startBtn && _startBtn.hasOwnProperty("startA"))
            {
               _startBtn["startA"].gotoAndStop(1);
            }
            _startBtn.buttonMode = false;
         }
      }
      
      override protected function initEvents() : void
      {
         super.initEvents();
         this._btnSwitchTeam.addEventListener(MouseEvent.CLICK,this.__switchTeam);
      }
      
      override protected function initTileList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:RoomPlayerItem = null;
         var _loc3_:ChallengeRoomPlayerItem = null;
         super.initTileList();
         this._playerItemContainers = new Vector.<SimpleTileList>();
         this._playerItemContainers[RoomPlayer.BLUE_TEAM - 1] = new SimpleTileList(2);
         this._playerItemContainers[RoomPlayer.RED_TEAM - 1] = new SimpleTileList(2);
         this._playerItemContainers[RoomPlayer.BLUE_TEAM - 1].hSpace = this._playerItemContainers[RoomPlayer.RED_TEAM - 1].hSpace = 2;
         this._playerItemContainers[RoomPlayer.BLUE_TEAM - 1].vSpace = this._playerItemContainers[RoomPlayer.RED_TEAM - 1].vSpace = 4;
         PositionUtils.setPos(this._playerItemContainers[RoomPlayer.BLUE_TEAM - 1],"asset.ddtchallengeRoom.BlueTeamPos");
         PositionUtils.setPos(this._playerItemContainers[RoomPlayer.RED_TEAM - 1],"asset.ddtchallengeRoom.RedTeamPos");
         this._ItemArr = [ComponentFactory.Instance.creatCustomObject("asset.ddtchallengeRoom.itemPos1"),ComponentFactory.Instance.creatCustomObject("asset.ddtchallengeRoom.itemPos4"),ComponentFactory.Instance.creatCustomObject("asset.ddtchallengeRoom.itemPos2"),ComponentFactory.Instance.creatCustomObject("asset.ddtchallengeRoom.itemPos5"),ComponentFactory.Instance.creatCustomObject("asset.ddtchallengeRoom.itemPos3"),ComponentFactory.Instance.creatCustomObject("asset.ddtchallengeRoom.itemPos6")];
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = new RoomPlayerItem(_loc1_);
            _loc2_.x = this._ItemArr[_loc1_].x;
            _loc2_.y = this._ItemArr[_loc1_].y;
            addChild(_loc2_);
            _playerItems.push(_loc2_);
            _loc3_ = new ChallengeRoomPlayerItem(_loc1_ + 1);
            _loc3_.x = this._ItemArr[_loc1_ + 1].x;
            _loc3_.y = this._ItemArr[_loc1_ + 1].y;
            addChild(_loc3_);
            _playerItems.push(_loc3_);
            _loc1_ += 2;
         }
         PositionUtils.setPos(_viewerItems[0],"asset.ddtchallengeroom.ViewerItemPos_0");
         PositionUtils.setPos(_viewerItems[1],"asset.ddtchallengeroom.ViewerItemPos_1");
         addChild(_viewerItems[0]);
         addChild(_viewerItems[1]);
      }
      
      override protected function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.background.room.rightBg");
         PositionUtils.setPos(this._bg,"asset.ddtChallengeRomm.bgPos");
         this._vsBg = ComponentFactory.Instance.creatBitmap("asset.ddtdungeonRoom.VSbg");
         this._smallMapInfoPanel = ComponentFactory.Instance.creatCustomObject("asset.ddtchallengeRoom.smallMapInfoPanel");
         this._btnSwitchTeam = ComponentFactory.Instance.creatComponentByStylename("asset.ddtChallengeRoom.switchTeamBtn");
         this._blueTeamBitmap = ClassUtils.CreatInstance("asset.ddtChallengeRoom.blueBg") as MovieClip;
         PositionUtils.setPos(this._blueTeamBitmap,"asset.ddtchallengeroom.blueBgpos");
         this._redTeamBitmap = ClassUtils.CreatInstance("asset.ddtChallengeRoom.redBg") as MovieClip;
         PositionUtils.setPos(this._redTeamBitmap,"asset.ddtchallengeroom.redBgpos");
         this._smallMapInfoPanel.info = _info;
         this._self = PlayerManager.Instance.Self;
         addChild(this._bg);
         addChild(this._vsBg);
         addChild(this._btnSwitchTeam);
         super.initView();
         _btnBg.visible = false;
         _btnBgOne.visible = true;
         addChild(this._smallMapInfoPanel);
         PositionUtils.setPos(_startBtn,"asset.ddtroom.ChallengeRoomstartMoviePos");
         PositionUtils.setPos(_prepareBtn,"asset.ddtroom.ChallengeRoomstartMoviePos");
         PositionUtils.setPos(_cancelBtn,"asset.ddtroom.ChallengeRoomstartMoviePos");
         if(!_info.selfRoomPlayer.isViewer)
         {
            this.openDefyAffiche();
         }
      }
      
      private function openDefyAffiche() : void
      {
         var _loc2_:DefyAfficheViewFrame = null;
         if(!_info || !_info.defyInfo)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ <= _info.defyInfo[0].length)
         {
            if(this._self.NickName == _info.defyInfo[0][_loc1_])
            {
               if(_info.defyInfo[1].length != 0)
               {
                  _loc2_ = ComponentFactory.Instance.creatComponentByStylename("game.view.defyAfficheViewFrame");
                  _loc2_.roomInfo = _info;
                  _loc2_.show();
               }
            }
            _loc1_++;
         }
      }
      
      override protected function __switchClickEnabled(param1:RoomEvent) : void
      {
         var _loc3_:RoomPlayerItem = null;
         var _loc4_:ChallengeRoomPlayerItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < _playerItems.length)
         {
            if(_loc2_ % 2 != 1)
            {
               _loc3_ = _playerItems[_loc2_] as RoomPlayerItem;
               _loc3_.switchInEnabled = param1.params[0] == 1;
            }
            else
            {
               _loc4_ = _playerItems[_loc2_] as ChallengeRoomPlayerItem;
               _loc4_.switchInEnabled = param1.params[0] == 1;
            }
            _loc2_++;
         }
      }
      
      override protected function __updatePlayerItems(param1:RoomEvent) : void
      {
         this.initPlayerItems();
         this.updateButtons();
      }
      
      override protected function initPlayerItems() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc8_:RoomPlayerItem = null;
         var _loc9_:ChallengeRoomPlayerItem = null;
         var _loc11_:RoomViewerItem = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         while(_loc6_ < _playerItems.length)
         {
            if(_info.findPlayerByPlace(_loc6_) != null)
            {
               if(_info.findPlayerByPlace(_loc6_).isSelf)
               {
                  _loc1_ = _info.findPlayerByPlace(_loc6_).team;
                  RoomManager.Instance.beforePlace = _info.findPlayerByPlace(_loc6_).place;
                  break;
               }
               if(_info.findPlayerByPlace(_loc6_).isHost)
               {
                  _loc3_ = _info.findPlayerByPlace(_loc6_).place;
                  _loc4_ = _info.findPlayerByPlace(_loc6_).team;
               }
            }
            _loc6_++;
         }
         _loc2_ = RoomManager.Instance.beforePlace;
         var _loc7_:int = 0;
         while(_loc7_ < 2)
         {
            if(_info.findPlayerByPlace(_loc7_ + 6) != null)
            {
               if(_info.findPlayerByPlace(_loc7_ + 6).isSelf)
               {
                  _loc1_ = 0;
                  _loc5_ = true;
                  break;
               }
            }
            _loc7_++;
         }
         var _loc10_:int = 0;
         while(_loc10_ < _playerItems.length)
         {
            if(_info.findPlayerByPlace(_loc10_))
            {
               if(_loc1_ == 0)
               {
                  if(_loc10_ % 2 != 1)
                  {
                     _loc8_ = _playerItems[_loc10_] as RoomPlayerItem;
                     _loc8_.place = _loc10_;
                     _loc8_.disposeCharacterContainer();
                     _loc8_.info = _info.findPlayerByPlace(_loc10_);
                     _loc8_.opened = _info.placesState[_loc10_] != 0;
                  }
                  else
                  {
                     _loc9_ = _playerItems[_loc10_] as ChallengeRoomPlayerItem;
                     _loc9_.place = _loc10_;
                     _loc9_.info = _info.findPlayerByPlace(_loc10_);
                     _loc9_.opened = _info.placesState[_loc10_] != 0;
                  }
               }
               else if(_loc1_ == _info.findPlayerByPlace(_loc10_).team)
               {
                  _loc8_ = _playerItems[_loc10_ % 2 != 1 ? _loc10_ : _loc10_ - 1] as RoomPlayerItem;
                  _loc8_.place = _loc10_;
                  _loc8_.disposeCharacterContainer();
                  _loc8_.info = _info.findPlayerByPlace(_loc10_);
                  _loc8_.opened = _info.placesState[_loc10_] != 0;
               }
               else
               {
                  _loc9_ = _playerItems[_loc10_ % 2 == 1 ? _loc10_ : _loc10_ + 1] as ChallengeRoomPlayerItem;
                  _loc9_.place = _loc10_;
                  _loc9_.info = _info.findPlayerByPlace(_loc10_);
                  _loc9_.opened = _info.placesState[_loc10_] != 0;
               }
            }
            else if(_loc5_)
            {
               if(_loc10_ % 2 != 1)
               {
                  _loc8_ = _playerItems[_loc10_] as RoomPlayerItem;
                  _loc8_.place = _loc10_;
                  _loc8_.disposeCharacterContainer();
                  _loc8_.info = _info.findPlayerByPlace(_loc10_);
                  _loc8_.opened = _info.placesState[_loc10_] != 0;
               }
               else
               {
                  _loc9_ = _playerItems[_loc10_] as ChallengeRoomPlayerItem;
                  _loc9_.place = _loc10_;
                  _loc9_.info = _info.findPlayerByPlace(_loc10_);
                  _loc9_.opened = _info.placesState[_loc10_] != 0;
               }
            }
            else if(_loc10_ % 2 != 1)
            {
               if(_loc2_ % 2 != 1)
               {
                  _loc8_ = _playerItems[_loc10_] as RoomPlayerItem;
                  _loc8_.place = _loc10_;
                  _loc8_.disposeCharacterContainer();
                  _loc8_.info = _info.findPlayerByPlace(_loc10_);
                  _loc8_.opened = _info.placesState[_loc10_] != 0;
                  _loc9_ = _playerItems[_loc10_ + 1] as ChallengeRoomPlayerItem;
                  if(_loc10_ < 3)
                  {
                     _loc9_.place = _loc10_ + 1;
                  }
                  else if(_loc10_ == 5)
                  {
                     _loc9_.place = _loc10_;
                  }
                  _loc9_.info = _info.findPlayerByPlace(_loc10_);
                  _loc9_.opened = _info.placesState[_loc10_] != 0;
               }
               else
               {
                  _loc8_ = _playerItems[_loc10_] as RoomPlayerItem;
                  if(_loc10_ < 5)
                  {
                     _loc8_.place = _loc10_ + 1;
                  }
                  _loc8_.disposeCharacterContainer();
                  _loc8_.info = _info.findPlayerByPlace(_loc10_);
                  _loc8_.opened = _info.placesState[_loc10_] != 0;
                  _loc9_ = _playerItems[_loc10_ + 1] as ChallengeRoomPlayerItem;
                  _loc9_.place = _loc10_;
                  _loc9_.info = _info.findPlayerByPlace(_loc10_);
                  _loc9_.opened = _info.placesState[_loc10_] != 0;
               }
            }
            else if(_loc2_ % 2 != 1)
            {
               _loc9_ = _playerItems[_loc10_] as ChallengeRoomPlayerItem;
               if(_loc10_ <= 5)
               {
                  _loc9_.place = _loc10_;
               }
               _loc9_.info = _info.findPlayerByPlace(_loc10_);
               _loc9_.opened = _info.placesState[_loc10_] != 0;
            }
            else
            {
               _loc8_ = _playerItems[_loc10_ - 1] as RoomPlayerItem;
               if(_loc10_ != 5)
               {
                  _loc8_.place = _loc10_;
               }
               _loc8_.disposeCharacterContainer();
               _loc8_.info = _info.findPlayerByPlace(_loc10_);
               _loc8_.opened = _info.placesState[_loc10_] != 0;
            }
            _loc10_++;
         }
         PlayerManager.Instance.dispatchEvent(new Event(PlayerManager.UPDATE_ROOMPLAYER));
         if(isViewerRoom)
         {
            _loc10_ = 0;
            while(_loc10_ < 2)
            {
               if(_viewerItems && _viewerItems[_loc10_])
               {
                  _loc11_ = _viewerItems[_loc10_] as RoomViewerItem;
                  _loc11_.info = _info.findPlayerByPlace(_loc10_ + 6);
                  _loc11_.opened = _info.placesState[_loc10_ + 6] != 0;
               }
               _loc10_++;
            }
         }
      }
      
      override protected function removeEvents() : void
      {
         super.removeEvents();
         this._btnSwitchTeam.removeEventListener(MouseEvent.CLICK,this.__switchTeam);
      }
      
      private function __switchTeam(param1:MouseEvent) : void
      {
         SoundManager.instance.play("012");
         if(this._clickTimer && this._clickTimer.running)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.fightModelPropBar.error"));
            return;
         }
         if(!this._clickTimer)
         {
            this._clickTimer = new Timer(1000,1);
         }
         this._clickTimer.start();
         if(!_info.selfRoomPlayer.isReady || _info.selfRoomPlayer.isHost)
         {
            GameInSocketOut.sendGameTeam(int(_info.selfRoomPlayer.team == RoomPlayer.BLUE_TEAM ? RoomPlayer.RED_TEAM : RoomPlayer.BLUE_TEAM));
         }
      }
      
      private function __clickTimerHandler(param1:TimerEvent) : void
      {
         if(this._clickTimer)
         {
            this._clickTimer.stop();
            this._clickTimer = null;
         }
      }
   }
}
