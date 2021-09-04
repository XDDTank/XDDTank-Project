package ddt.view.sceneCharacter
{
   import arena.model.ArenaPlayerStates;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ChatManager;
   import ddt.utils.Helpers;
   import ddt.utils.PositionUtils;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatEvent;
   import ddt.view.chat.ChatInputView;
   import ddt.view.chat.chatBall.ChatBallPlayer;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.VipLevelIcon;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import vip.VipController;
   
   public class SceneCharacterPlayer extends SceneCharacterPlayerBase
   {
       
      
      protected var _scenePlayerInfo:SceneCharacterPlayerInfo;
      
      protected var _sceneCharacterStateSet:SceneCharacterStateSet;
      
      protected var _sceneCharacterSetNatural:SceneCharacterSet;
      
      protected var _sceneCharacterActionSetNatural:SceneCharacterActionSet;
      
      protected var _headBitmapData:BitmapData;
      
      protected var _bodyBitmapData:BitmapData;
      
      protected var _rectangle:Rectangle;
      
      public var playerWitdh:Number = 120;
      
      public var playerHeight:Number = 175;
      
      protected var _sceneCharacterLoaderBody:SceneCharacterLoaderBody;
      
      protected var _sceneCharacterLoaderHead:SceneCharacterLoaderHead;
      
      protected var _defaultBody:MovieClip;
      
      protected var _isChatBall:Boolean = true;
      
      protected var _chatBallView:ChatBallPlayer;
      
      protected var _sceneScene:SceneScene;
      
      protected var _currentWalkStartPoint:Point;
      
      protected var _spName:Sprite;
      
      protected var _lblName:FilterFrameText;
      
      protected var _vipName:GradientText;
      
      protected var _vipIcon:VipLevelIcon;
      
      protected var _fightIcon:MovieClip;
      
      protected var _levelIcon:LevelIcon;
      
      protected var _tombstone:MovieClip;
      
      protected var _relive:MovieClip;
      
      public function SceneCharacterPlayer(param1:SceneCharacterPlayerInfo, param2:Function = null)
      {
         this._rectangle = new Rectangle();
         this._scenePlayerInfo = param1;
         super(param2);
         this.initView();
         this.initEvent();
      }
      
      public function get currentWalkStartPoint() : Point
      {
         return this._currentWalkStartPoint;
      }
      
      public function get playerInfo() : PlayerInfo
      {
         return this._scenePlayerInfo.playerInfo;
      }
      
      public function get scenePlayerInfo() : SceneCharacterPlayerInfo
      {
         return this._scenePlayerInfo;
      }
      
      public function set scenePlayerInfo(param1:SceneCharacterPlayerInfo) : void
      {
         this._scenePlayerInfo = param1;
      }
      
      public function get sceneScene() : SceneScene
      {
         return this._sceneScene;
      }
      
      public function set sceneScene(param1:SceneScene) : void
      {
         this._sceneScene = param1;
      }
      
      public function get defaultBody() : MovieClip
      {
         return this._defaultBody;
      }
      
      public function set setSceneCharacterDirectionDefault(param1:SceneCharacterDirection) : void
      {
         if(param1 == SceneCharacterDirection.LT || param1 == SceneCharacterDirection.RT)
         {
            if(sceneCharacterStateType == "natural")
            {
               sceneCharacterActionType = "naturalStandBack";
            }
         }
         else if(param1 == SceneCharacterDirection.LB || param1 == SceneCharacterDirection.RB)
         {
            if(sceneCharacterStateType == "natural")
            {
               sceneCharacterActionType = "naturalStandFront";
            }
         }
      }
      
      public function updatePlayer() : void
      {
         this.refreshCharacterState();
         this.characterMirror();
         this.playerWalkPath();
         update();
         this.updateStatus();
      }
      
      protected function playerWalkPath() : void
      {
         if(_walkPath != null && _walkPath.length > 0 && this.scenePlayerInfo.walkPath.length > 0 && _walkPath != this.scenePlayerInfo.walkPath)
         {
            this.fixPlayerPath();
         }
         if(this.scenePlayerInfo && this.scenePlayerInfo.walkPath && this.scenePlayerInfo.walkPath.length <= 0 && !_tween.isPlaying)
         {
            return;
         }
         this.playerWalk(this.scenePlayerInfo.walkPath);
      }
      
      override public function playerWalk(param1:Array) : void
      {
         var _loc2_:Number = NaN;
         if(_walkPath != null && _tween.isPlaying && _walkPath == this.scenePlayerInfo.walkPath)
         {
            return;
         }
         _walkPath = this.scenePlayerInfo.walkPath;
         if(_walkPath && _walkPath.length > 0)
         {
            this._currentWalkStartPoint = _walkPath[0];
            sceneCharacterDirection = SceneCharacterDirection.getDirection(playerPoint,this._currentWalkStartPoint);
            dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,true));
            _loc2_ = Point.distance(this._currentWalkStartPoint,playerPoint);
            _tween.start(_loc2_ / _moveSpeed,"x",this._currentWalkStartPoint.x,"y",this._currentWalkStartPoint.y);
            _walkPath.shift();
         }
         else
         {
            dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,false));
         }
      }
      
      protected function fixPlayerPath() : void
      {
         var _loc3_:Array = null;
         if(this.scenePlayerInfo.currenWalkStartPoint == null)
         {
            return;
         }
         var _loc1_:int = -1;
         var _loc2_:int = 0;
         while(_loc2_ < _walkPath.length)
         {
            if(_walkPath[_loc2_].x == this.scenePlayerInfo.currenWalkStartPoint.x && _walkPath[_loc2_].y == this.scenePlayerInfo.currenWalkStartPoint.y)
            {
               _loc1_ = _loc2_;
               break;
            }
            _loc2_++;
         }
         if(_loc1_ > 0)
         {
            _loc3_ = _walkPath.slice(0,_loc1_);
            this.scenePlayerInfo.walkPath = _loc3_.concat(this.scenePlayerInfo.walkPath);
         }
      }
      
      protected function characterMirror() : void
      {
         character.scaleX = !!sceneCharacterDirection.isMirror ? Number(-1) : Number(1);
         character.x = !!sceneCharacterDirection.isMirror ? Number(this.playerWitdh / 2) : Number(-this.playerWitdh / 2);
         character.y = -this.playerHeight;
      }
      
      protected function refreshCharacterState() : void
      {
         if((sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT) && _tween.isPlaying)
         {
            sceneCharacterActionType = "naturalWalkBack";
         }
         else if((sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB) && _tween.isPlaying)
         {
            sceneCharacterActionType = "naturalWalkFront";
         }
         moveSpeed = this.scenePlayerInfo.playerMoveSpeed;
      }
      
      protected function initView() : void
      {
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this._defaultBody = ClassUtils.CreatInstance("asset.consortion.bodyDefaultPlayer") as MovieClip;
         this.setDefaultBodyPos();
         this._sceneCharacterStateSet = new SceneCharacterStateSet();
         this._sceneCharacterActionSetNatural = new SceneCharacterActionSet();
         this.sceneCharacterLoadHead();
         moveSpeed = 0.15;
         if(this._isChatBall)
         {
            if(!this._chatBallView)
            {
               this._chatBallView = new ChatBallPlayer();
            }
            this._chatBallView.x = (this.playerWitdh - this._chatBallView.width) / 2 - this.playerWitdh / 2;
            this._chatBallView.y = -this.playerHeight + 40;
            addChild(this._chatBallView);
         }
         else
         {
            if(this._chatBallView)
            {
               this._chatBallView.clear();
               if(this._chatBallView.parent)
               {
                  this._chatBallView.parent.removeChild(this._chatBallView);
               }
               this._chatBallView.dispose();
            }
            this._chatBallView = null;
         }
         if(!this._lblName)
         {
            this._lblName = ComponentFactory.Instance.creat("conostion.sencemap.playerNameTxt");
         }
         this._lblName.mouseEnabled = false;
         this._lblName.text = this.scenePlayerInfo && this.scenePlayerInfo.playerInfo && this.scenePlayerInfo.playerInfo.NickName ? this.scenePlayerInfo.playerInfo.NickName : "";
         this._lblName.textColor = 6029065;
         if(!this._spName)
         {
            this._spName = new Sprite();
         }
         if(this.scenePlayerInfo.playerInfo.IsVIP)
         {
            this._vipName = VipController.instance.getVipNameTxt(-1,this.scenePlayerInfo.playerInfo.VIPtype);
            this._vipName.textSize = 16;
            this._vipName.x = this._lblName.x;
            this._vipName.y = this._lblName.y;
            this._vipName.text = this._lblName.text;
            this._spName.addChild(this._vipName);
            DisplayUtils.removeDisplay(this._lblName);
         }
         else
         {
            this._spName.addChild(this._lblName);
            DisplayUtils.removeDisplay(this._vipName);
         }
         if(this.scenePlayerInfo.playerInfo.IsVIP && !this._vipIcon)
         {
            this._vipIcon = ComponentFactory.Instance.creatCustomObject("consortion.sencemap.VipLvIcon");
            if(this.scenePlayerInfo.playerInfo.VIPtype >= 2)
            {
               this._vipIcon.y -= 5;
            }
            this._vipIcon.setInfo(this.scenePlayerInfo.playerInfo,false);
         }
         if(this._vipIcon)
         {
            this._spName.addChild(this._vipIcon);
            this._lblName.x = this._vipIcon.x + this._vipIcon.width;
            if(this._vipName)
            {
               this._vipName.x = this._lblName.x;
            }
         }
         this._levelIcon = new LevelIcon();
         this._levelIcon.visible = false;
         this._levelIcon.setInfo(this.playerInfo.Grade,this.playerInfo.Repute,this.playerInfo.WinCount,this.playerInfo.TotalCount,this.playerInfo.FightPower,this.playerInfo.Offer,true,false,0);
         PositionUtils.setPos(this._levelIcon,"ddtarena.scenePlayer.vipiconPos");
         this._spName.addChild(this._levelIcon);
         this.drawSpName();
         this._fightIcon = ComponentFactory.Instance.creat("asset.worldBoss.fighting");
         addChild(this._fightIcon);
         this._fightIcon.visible = false;
         this._fightIcon.gotoAndStop(1);
         this._tombstone = ComponentFactory.Instance.creat("asset.worldBoos.tombstone");
         PositionUtils.setPos(this._tombstone,"sceneCharactreplayer.tombPos");
         addChild(this._tombstone);
         this._tombstone.visible = false;
         this._tombstone.gotoAndStop(1);
         this._relive = ComponentFactory.Instance.creat("asset.worldboss.resurrect");
         this._relive.stop();
         this._relive.visible = false;
         addChildAt(this._relive,0);
      }
      
      protected function drawSpName() : void
      {
         this._spName.x = -this._spName.width / 2;
         this._spName.y = -this.playerHeight;
         this._spName.graphics.beginFill(0,0.5);
         var _loc1_:int = Boolean(this._vipIcon) ? int(this._lblName.textWidth + this._vipIcon.width) : int(this._lblName.textWidth + 8);
         if(this.scenePlayerInfo.playerInfo.IsVIP)
         {
            _loc1_ = Boolean(this._vipIcon) ? int(this._vipName.width + this._vipIcon.width + 8) : int(this._vipName.width + 8);
            this._spName.x = -(this._vipIcon.width + this._vipName.width) / 2;
            this._levelIcon.x = this._vipIcon.x;
         }
         else
         {
            this._levelIcon.x = this._lblName.x - this._levelIcon.width - 10;
         }
         this._spName.graphics.drawRoundRect(-4,0,_loc1_,22,5,5);
         this._spName.graphics.endFill();
         addChild(this._spName);
      }
      
      protected function updateStatus() : void
      {
         if(this.scenePlayerInfo.playerStauts == ArenaPlayerStates.FIGHT)
         {
            if(this._fightIcon.visible == false)
            {
               this._fightIcon.visible = true;
               this._fightIcon.gotoAndPlay(1);
            }
         }
         else
         {
            this._fightIcon.gotoAndStop(1);
            this._fightIcon.visible = false;
         }
         if(this.scenePlayerInfo.playerStauts == ArenaPlayerStates.DEATH)
         {
            if(this._tombstone.visible == false)
            {
               this._tombstone.visible = true;
               this._tombstone.gotoAndPlay(1);
               character.visible = false;
            }
         }
         else
         {
            this._tombstone.visible = false;
            character.visible = true;
         }
      }
      
      protected function initEvent() : void
      {
         addEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.__characterDirectionChange);
         this.scenePlayerInfo.addEventListener(SceneCharacterEvent.CHARACTER_PLAYER_POS_CHANGED,this.__onPlayerPosChange);
         ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT,this.__getChat);
         this._relive.addEventListener(Event.COMPLETE,this.__reliveComplete);
      }
      
      protected function setDefaultBodyPos() : void
      {
      }
      
      protected function __characterDirectionChange(param1:SceneCharacterEvent) : void
      {
         this.scenePlayerInfo.scenePlayerDirection = sceneCharacterDirection;
         if(Boolean(param1.data))
         {
            if(sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT)
            {
               if(sceneCharacterStateType == "natural")
               {
                  sceneCharacterActionType = "naturalWalkBack";
               }
            }
            else if(sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB)
            {
               if(sceneCharacterStateType == "natural")
               {
                  sceneCharacterActionType = "naturalWalkFront";
               }
            }
         }
         else if(sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT)
         {
            if(sceneCharacterStateType == "natural")
            {
               sceneCharacterActionType = "naturalStandBack";
            }
         }
         else if(sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB)
         {
            if(sceneCharacterStateType == "natural")
            {
               sceneCharacterActionType = "naturalStandFront";
            }
         }
      }
      
      protected function __getChat(param1:ChatEvent) : void
      {
         if(!this._isChatBall || !param1.data)
         {
            return;
         }
         var _loc2_:ChatData = ChatData(param1.data).clone();
         if(!_loc2_)
         {
            return;
         }
         _loc2_.msg = Helpers.deCodeString(_loc2_.msg);
         if(_loc2_.channel == ChatInputView.PRIVATE)
         {
            return;
         }
         if(_loc2_ && this.scenePlayerInfo.playerInfo && _loc2_.senderID == this.scenePlayerInfo.playerInfo.ID)
         {
            this._chatBallView.setText(_loc2_.msg,this.scenePlayerInfo.playerInfo.paopaoType);
            if(!this._chatBallView.parent && character)
            {
               addChildAt(this._chatBallView,this.getChildIndex(character) + 1);
            }
         }
      }
      
      protected function __reliveComplete(param1:Event) : void
      {
         this._relive.stop();
         this._relive.visible = false;
      }
      
      protected function __onPlayerPosChange(param1:SceneCharacterEvent) : void
      {
         playerPoint = this.scenePlayerInfo.playerPos;
      }
      
      protected function sceneCharacterLoadHead() : void
      {
         this._sceneCharacterLoaderHead = new SceneCharacterLoaderHead(this.playerInfo);
         this._sceneCharacterLoaderHead.load(this.sceneCharacterLoaderHeadCallBack);
      }
      
      protected function sceneCharacterLoaderHeadCallBack(param1:SceneCharacterLoaderHead, param2:Boolean = true) : void
      {
         this._headBitmapData = param1.getContent()[0] as BitmapData;
         if(param1)
         {
            param1.dispose();
         }
         if(!param2 || !this._headBitmapData)
         {
            if(_callBack != null)
            {
               _callBack(this,false);
            }
            return;
         }
         this.sceneCharacterStateNatural();
      }
      
      protected function sceneCharacterStateNatural() : void
      {
         var _loc1_:BitmapData = null;
         this._sceneCharacterSetNatural = new SceneCharacterSet();
         var _loc2_:Vector.<Point> = new Vector.<Point>();
         _loc2_.push(new Point(0,0));
         _loc2_.push(new Point(0,0));
         _loc2_.push(new Point(0,-1));
         _loc2_.push(new Point(0,2));
         _loc2_.push(new Point(0,0));
         _loc2_.push(new Point(0,-1));
         _loc2_.push(new Point(0,2));
         if(!this._rectangle)
         {
            this._rectangle = new Rectangle();
         }
         this._rectangle.x = 0;
         this._rectangle.y = 0;
         this._rectangle.width = this.playerWitdh;
         this._rectangle.height = this.playerHeight;
         _loc1_ = new BitmapData(this.playerWitdh,this.playerHeight,true,0);
         _loc1_.copyPixels(this._headBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontHead","NaturalFrontAction",_loc1_,1,1,this.playerWitdh,this.playerHeight,1,_loc2_,true,7));
         this._rectangle.x = this.playerWitdh;
         this._rectangle.y = 0;
         this._rectangle.width = this.playerWitdh;
         this._rectangle.height = this.playerHeight;
         _loc1_ = new BitmapData(this.playerWitdh,this.playerHeight,true,0);
         _loc1_.copyPixels(this._headBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontEyesCloseHead","NaturalFrontEyesCloseAction",_loc1_,1,1,this.playerWitdh,this.playerHeight,2));
         this._rectangle.x = this.playerWitdh * 2;
         this._rectangle.y = 0;
         this._rectangle.width = this.playerWitdh;
         this._rectangle.height = this.playerHeight;
         _loc1_ = new BitmapData(this.playerWitdh,this.playerHeight * 2,true,0);
         _loc1_.copyPixels(this._headBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalBackHead","NaturalBackAction",_loc1_,1,1,this.playerWitdh,this.playerHeight,6,_loc2_,true,7));
         this.sceneCharacterLoadBodyNatural();
      }
      
      protected function sceneCharacterLoadBodyNatural() : void
      {
         this._sceneCharacterLoaderBody = new SceneCharacterLoaderBody(this.playerInfo);
         this._sceneCharacterLoaderBody.load(this.sceneCharacterLoaderBodyNaturalCallBack);
      }
      
      protected function sceneCharacterLoaderBodyNaturalCallBack(param1:SceneCharacterLoaderBody, param2:Boolean) : void
      {
         var _loc3_:BitmapData = null;
         if(!this._sceneCharacterSetNatural)
         {
            return;
         }
         this._bodyBitmapData = param1.getContent()[0] as BitmapData;
         if(param1)
         {
            param1.dispose();
         }
         if(!param2 || !this._bodyBitmapData)
         {
            if(_callBack != null)
            {
               _callBack(this,false);
            }
            return;
         }
         if(!this._rectangle)
         {
            this._rectangle = new Rectangle();
         }
         this._rectangle.x = 0;
         this._rectangle.y = 0;
         this._rectangle.width = this._bodyBitmapData.width;
         this._rectangle.height = this.playerHeight;
         _loc3_ = new BitmapData(this._bodyBitmapData.width,this.playerHeight,true,0);
         _loc3_.copyPixels(this._bodyBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontBody","NaturalFrontAction",_loc3_,1,7,this.playerWitdh,this.playerHeight,3));
         this._rectangle.x = 0;
         this._rectangle.y = 0;
         this._rectangle.width = this.playerWitdh;
         this._rectangle.height = this.playerHeight;
         _loc3_ = new BitmapData(this.playerWitdh,this.playerHeight,true,0);
         _loc3_.copyPixels(this._bodyBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontEyesCloseBody","NaturalFrontEyesCloseAction",_loc3_,1,1,this.playerWitdh,this.playerHeight,4));
         this._rectangle.x = 0;
         this._rectangle.y = this.playerHeight;
         this._rectangle.width = this._bodyBitmapData.width;
         this._rectangle.height = this.playerHeight;
         _loc3_ = new BitmapData(this._bodyBitmapData.width,this.playerHeight,true,0);
         _loc3_.copyPixels(this._bodyBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalBackBody","NaturalBackAction",_loc3_,1,7,this.playerWitdh,this.playerHeight,5));
         var _loc4_:SceneCharacterActionItem = new SceneCharacterActionItem("naturalStandFront",[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7],true);
         this._sceneCharacterActionSetNatural.push(_loc4_);
         var _loc5_:SceneCharacterActionItem = new SceneCharacterActionItem("naturalStandBack",[8],false);
         this._sceneCharacterActionSetNatural.push(_loc5_);
         var _loc6_:SceneCharacterActionItem = new SceneCharacterActionItem("naturalWalkFront",[1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6],true);
         this._sceneCharacterActionSetNatural.push(_loc6_);
         var _loc7_:SceneCharacterActionItem = new SceneCharacterActionItem("naturalWalkBack",[9,9,9,10,10,10,11,11,11,12,12,12,13,13,13,14,14,14],true);
         this._sceneCharacterActionSetNatural.push(_loc7_);
         var _loc8_:SceneCharacterStateItem = new SceneCharacterStateItem("natural",this._sceneCharacterSetNatural,this._sceneCharacterActionSetNatural);
         this._sceneCharacterStateSet.push(_loc8_);
         super.sceneCharacterStateSet = this._sceneCharacterStateSet;
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(SceneCharacterEvent.CHARACTER_PLAYER_POS_CHANGED,this.__characterDirectionChange);
         this.scenePlayerInfo.removeEventListener(SceneCharacterEvent.CHARACTER_PLAYER_POS_CHANGED,this.__onPlayerPosChange);
         ChatManager.Instance.model.removeEventListener(ChatEvent.ADD_CHAT,this.__getChat);
         this._relive.removeEventListener(Event.COMPLETE,this.__reliveComplete);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._lblName);
         this._lblName = null;
         ObjectUtils.disposeObject(this._vipName);
         this._vipName = null;
         ObjectUtils.disposeObject(this._vipIcon);
         this._vipIcon = null;
         ObjectUtils.disposeObject(this._levelIcon);
         this._levelIcon = null;
         ObjectUtils.disposeObject(this._spName);
         this._spName = null;
         ObjectUtils.disposeObject(this._fightIcon);
         this._fightIcon = null;
         ObjectUtils.disposeObject(this._tombstone);
         this._tombstone = null;
         ObjectUtils.disposeObject(this._relive);
         this._relive = null;
         this._scenePlayerInfo = null;
         ObjectUtils.disposeObject(this._defaultBody);
         this._defaultBody = null;
         ObjectUtils.disposeObject(this._chatBallView);
         this._chatBallView = null;
         _callBack = null;
         this._sceneCharacterSetNatural.dispose();
         this._sceneCharacterSetNatural = null;
         this._sceneCharacterActionSetNatural.dispose();
         this._sceneCharacterActionSetNatural = null;
         this._sceneCharacterStateSet.dispose();
         this._sceneCharacterStateSet = null;
         ObjectUtils.disposeObject(this._sceneCharacterLoaderBody);
         this._sceneCharacterLoaderBody = null;
         ObjectUtils.disposeObject(this._sceneCharacterLoaderHead);
         this._sceneCharacterLoaderHead = null;
         if(this._headBitmapData)
         {
            this._headBitmapData.dispose();
         }
         this._headBitmapData = null;
         if(this._bodyBitmapData)
         {
            this._bodyBitmapData.dispose();
         }
         this._bodyBitmapData = null;
         this._rectangle = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
