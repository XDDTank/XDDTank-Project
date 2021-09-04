package consortion.consortionsence
{
   import SingleDungeon.event.WalkMapEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.utils.Helpers;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatEvent;
   import ddt.view.chat.ChatInputView;
   import ddt.view.chat.chatBall.ChatBallPlayer;
   import ddt.view.common.VipLevelIcon;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.sceneCharacter.SceneCharacterEvent;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import vip.VipController;
   
   public class ConsortionWalkPlayer extends ConsortionWalkPlayerBase
   {
       
      
      private var _consortionPlayerInfo:ConsortionWalkPlayerInfo;
      
      private var _sceneScene:SceneScene;
      
      private var _isChatBall:Boolean = true;
      
      private var _chatBallView:ChatBallPlayer;
      
      private var _spName:Sprite;
      
      private var _lblName:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _vipIcon:VipLevelIcon;
      
      public var defaultBody:MovieClip;
      
      private var _currentWalkStartPoint:Point;
      
      public function ConsortionWalkPlayer(param1:ConsortionWalkPlayerInfo, param2:Function = null)
      {
         this._consortionPlayerInfo = param1;
         this._currentWalkStartPoint = this._consortionPlayerInfo.playerPos;
         super(param1.playerInfo,param2);
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.defaultBody = ClassUtils.CreatInstance("asset.consortion.bodyDefaultPlayer") as MovieClip;
         this.defaultBody.x = param1.playerPos.x;
         this.defaultBody.y = param1.playerPos.y - 70;
         this.initialize();
      }
      
      private function initialize() : void
      {
         moveSpeed = this._consortionPlayerInfo.playerMoveSpeed;
         if(this._isChatBall)
         {
            if(!this._chatBallView)
            {
               this._chatBallView = new ChatBallPlayer();
            }
            this._chatBallView.x = (playerWitdh - this._chatBallView.width) / 2 - playerWitdh / 2;
            this._chatBallView.y = -playerHeight + 40;
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
         this._lblName.text = this._consortionPlayerInfo && this._consortionPlayerInfo.playerInfo && this._consortionPlayerInfo.playerInfo.NickName ? this._consortionPlayerInfo.playerInfo.NickName : "";
         this._lblName.textColor = 6029065;
         if(!this._spName)
         {
            this._spName = new Sprite();
         }
         if(this._consortionPlayerInfo.playerInfo.IsVIP)
         {
            this._vipName = VipController.instance.getVipNameTxt(-1,this._consortionPlayerInfo.playerInfo.VIPtype);
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
         if(this._consortionPlayerInfo.playerInfo.IsVIP && !this._vipIcon)
         {
            this._vipIcon = ComponentFactory.Instance.creatCustomObject("consortion.sencemap.VipLvIcon");
            if(this._consortionPlayerInfo.playerInfo.VIPtype >= 2)
            {
               this._vipIcon.y -= 5;
            }
            this._vipIcon.setInfo(this._consortionPlayerInfo.playerInfo,false);
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
         this._spName.x = (playerWitdh - this._spName.width) / 2 - playerWitdh / 2;
         this._spName.y = -playerHeight;
         this._spName.graphics.beginFill(0,0.5);
         var _loc1_:int = Boolean(this._vipIcon) ? int(this._lblName.textWidth + this._vipIcon.width) : int(this._lblName.textWidth + 8);
         if(this._consortionPlayerInfo.playerInfo.IsVIP)
         {
            _loc1_ = Boolean(this._vipIcon) ? int(this._vipName.width + this._vipIcon.width + 8) : int(this._vipName.width + 8);
            this._spName.x = (playerWitdh - (this._vipIcon.width + this._vipName.width)) / 2 - playerWitdh / 2;
         }
         this._spName.graphics.drawRoundRect(-4,0,_loc1_,22,5,5);
         this._spName.graphics.endFill();
         addChildAt(this._spName,0);
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         addEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.__characterDirectionChange);
         this._consortionPlayerInfo.addEventListener(WalkMapEvent.WALKMAP_PLAYER_POS_CHANGED,this.__onPlayerPosChange);
         ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT,this.__getChat);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.__characterDirectionChange);
         if(this._consortionPlayerInfo)
         {
            this._consortionPlayerInfo.removeEventListener(WalkMapEvent.WALKMAP_PLAYER_POS_CHANGED,this.__onPlayerPosChange);
         }
         ChatManager.Instance.model.removeEventListener(ChatEvent.ADD_CHAT,this.__getChat);
      }
      
      private function __onPlayerPosChange(param1:WalkMapEvent) : void
      {
         playerPoint = this._consortionPlayerInfo.playerPos;
      }
      
      private function __characterDirectionChange(param1:SceneCharacterEvent) : void
      {
         this._consortionPlayerInfo.scenePlayerDirection = sceneCharacterDirection;
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
      }
      
      private function characterMirror() : void
      {
         character.scaleX = !!sceneCharacterDirection.isMirror ? Number(-1) : Number(1);
         character.x = !!sceneCharacterDirection.isMirror ? Number(playerWitdh / 2) : Number(-playerWitdh / 2);
         character.y = -playerHeight;
      }
      
      private function playerWalkPath() : void
      {
         if(_walkPath != null && _walkPath.length > 0 && this._consortionPlayerInfo.walkPath.length > 0 && _walkPath != this._consortionPlayerInfo.walkPath)
         {
            this.fixPlayerPath();
         }
         if(this._consortionPlayerInfo && this._consortionPlayerInfo.walkPath && this._consortionPlayerInfo.walkPath.length <= 0 && !_tween.isPlaying)
         {
            return;
         }
         this.playerWalk(this._consortionPlayerInfo.walkPath);
      }
      
      override public function playerWalk(param1:Array) : void
      {
         var _loc2_:Number = NaN;
         if(_walkPath != null && _tween.isPlaying && _walkPath == this._consortionPlayerInfo.walkPath)
         {
            return;
         }
         _walkPath = this._consortionPlayerInfo.walkPath;
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
      
      private function fixPlayerPath() : void
      {
         var _loc3_:Array = null;
         if(this._consortionPlayerInfo.currenWalkStartPoint == null)
         {
            return;
         }
         var _loc1_:int = -1;
         var _loc2_:int = 0;
         while(_loc2_ < _walkPath.length)
         {
            if(_walkPath[_loc2_].x == this._consortionPlayerInfo.currenWalkStartPoint.x && _walkPath[_loc2_].y == this._consortionPlayerInfo.currenWalkStartPoint.y)
            {
               _loc1_ = _loc2_;
               break;
            }
            _loc2_++;
         }
         if(_loc1_ > 0)
         {
            _loc3_ = _walkPath.slice(0,_loc1_);
            this._consortionPlayerInfo.walkPath = _loc3_.concat(this._consortionPlayerInfo.walkPath);
         }
      }
      
      public function get currentWalkStartPoint() : Point
      {
         return this._currentWalkStartPoint;
      }
      
      public function refreshCharacterState() : void
      {
         if((sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT) && _tween.isPlaying)
         {
            sceneCharacterActionType = "naturalWalkBack";
         }
         else if((sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB) && _tween.isPlaying)
         {
            sceneCharacterActionType = "naturalWalkFront";
         }
         moveSpeed = this._consortionPlayerInfo.playerMoveSpeed;
      }
      
      private function __getChat(param1:ChatEvent) : void
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
         if(_loc2_ && this._consortionPlayerInfo.playerInfo && _loc2_.senderID == this._consortionPlayerInfo.playerInfo.ID)
         {
            this._chatBallView.setText(_loc2_.msg,this._consortionPlayerInfo.playerInfo.paopaoType);
            if(!this._chatBallView.parent && character)
            {
               addChildAt(this._chatBallView,this.getChildIndex(character) + 1);
            }
         }
      }
      
      public function get consortionPlayerInfo() : ConsortionWalkPlayerInfo
      {
         return this._consortionPlayerInfo;
      }
      
      public function set consortionPlayerInfo(param1:ConsortionWalkPlayerInfo) : void
      {
         this._consortionPlayerInfo = param1;
      }
      
      public function get isChatBall() : Boolean
      {
         return this._isChatBall;
      }
      
      public function set isChatBall(param1:Boolean) : void
      {
         if(this._isChatBall == param1 || !this._chatBallView)
         {
            return;
         }
         this._isChatBall = param1;
         if(this._isChatBall)
         {
            addChildAt(this._chatBallView,this.getChildIndex(character) + 1);
         }
         else if(this._chatBallView && this._chatBallView.parent)
         {
            this._chatBallView.parent.removeChild(this._chatBallView);
         }
      }
      
      public function get sceneScene() : SceneScene
      {
         return this._sceneScene;
      }
      
      public function set sceneScene(param1:SceneScene) : void
      {
         this._sceneScene = param1;
      }
      
      public function get ID() : int
      {
         return this._consortionPlayerInfo.playerInfo.ID;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._sceneScene);
         this._sceneScene = null;
         ObjectUtils.disposeObject(this._chatBallView);
         this._chatBallView = null;
         ObjectUtils.disposeObject(this._lblName);
         this._lblName = null;
         ObjectUtils.disposeObject(this._vipName);
         this._vipName = null;
         ObjectUtils.disposeObject(this._vipIcon);
         this._vipIcon = null;
         ObjectUtils.disposeObject(this._spName);
         this._spName = null;
         ObjectUtils.disposeObject(this.defaultBody);
         this.defaultBody = null;
         this._consortionPlayerInfo = null;
         super.dispose();
      }
   }
}
