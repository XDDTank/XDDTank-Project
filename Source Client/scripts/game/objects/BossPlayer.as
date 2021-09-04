package game.objects
{
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.GameEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.SoundManager;
   import ddt.utils.Helpers;
   import ddt.view.FaceContainer;
   import ddt.view.character.GameCharacter;
   import ddt.view.character.ShowCharacter;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatEvent;
   import ddt.view.chat.chatBall.ChatBallPlayer;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.actions.GhostMoveAction;
   import game.actions.PlayerFallingAction;
   import game.actions.PlayerWalkAction;
   import game.actions.PrepareShootAction;
   import game.actions.ShootBombAction;
   import game.model.Living;
   import game.model.Player;
   import pet.date.PetSkillInfo;
   import phy.maps.Map;
   import road7th.data.DictionaryData;
   
   public class BossPlayer extends GameTurnedLiving
   {
       
      
      protected var _playerSprite:Sprite;
      
      protected var _petMovie:GamePetMovie;
      
      protected var _currentPetSkill:PetSkillInfo;
      
      protected var _shootAction:String = "beatA";
      
      protected var _player:Player;
      
      private var _character:ShowCharacter;
      
      private var _body:GameCharacter;
      
      private var _readyMc:MovieClip;
      
      protected var _facecontainer:FaceContainer;
      
      protected var _attackPlayerCite:MovieClip;
      
      private var _point:Point;
      
      public var UsedPetSkill:DictionaryData;
      
      public function BossPlayer(param1:Player, param2:ShowCharacter, param3:GameCharacter = null)
      {
         this.UsedPetSkill = new DictionaryData();
         this._character = param2;
         this._body = param3;
         this._player = param1 as Player;
         param1.defaultAction = Living.STAND_ACTION;
         super(param1);
         if(this.player.currentPet)
         {
            this._petMovie = new GamePetMovie(this.player.currentPet.petInfo,this);
            this._petMovie.addEventListener(GamePetMovie.PlayEffect,this.__playPlayerEffect);
         }
      }
      
      public function get character() : ShowCharacter
      {
         return this._character;
      }
      
      public function get body() : GameCharacter
      {
         return this._body;
      }
      
      public function get player() : Player
      {
         return this._player;
      }
      
      override protected function initMovie() : void
      {
         super.initMovie();
         _actionMovie.gotoAndPlay("born");
      }
      
      override protected function initView() : void
      {
         this._point = ComponentFactory.Instance.creatCustomObject("tian.shootSpeed1");
         this.initMovie();
         this._facecontainer = new FaceContainer();
         addChild(this._facecontainer);
         this._facecontainer.y = -150;
         super.initView();
         this._facecontainer.setNickName(_nickName.text);
         this._playerSprite = new Sprite();
         this._playerSprite.rotation = 0;
         this._playerSprite.visible = false;
         addChild(this._playerSprite);
         this._playerSprite.mouseChildren = this._playerSprite.mouseEnabled = false;
         this._body.x = 0;
         this._body.doAction(GameCharacter.SOUL);
         this._playerSprite.addChild(this._body as DisplayObject);
         this._attackPlayerCite = ClassUtils.CreatInstance("asset.game.AttackCiteAsset") as MovieClip;
         this._attackPlayerCite.y = -115;
         this._attackPlayerCite.mouseChildren = this._attackPlayerCite.mouseEnabled = false;
         this.__dirChanged(null);
      }
      
      override public function doAction(param1:*) : void
      {
         if(_actionMovie.currentAction != "stand" && _actionMovie.currentAction != "walk" && param1 == "walk")
         {
            return;
         }
         super.doAction(param1);
      }
      
      public function get point() : Point
      {
         return this._point;
      }
      
      override protected function initListener() : void
      {
         super.initListener();
         this.player.addEventListener(LivingEvent.POS_CHANGED,this.__posChanged);
         this.player.addEventListener(LivingEvent.USING_ITEM,this.__usingItem);
         this.player.addEventListener(LivingEvent.PLAYER_MOVETO,this.__playerMoveTo);
         this.player.addEventListener(LivingEvent.USE_PET_SKILL,this.__usePetSkill);
         this.player.addEventListener(LivingEvent.PET_BEAT,this.__petBeat);
         ChatManager.Instance.addEventListener(ChatEvent.SHOW_FACE,this.__getFace);
         ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT,this.__getChat);
         this.player.addEventListener(LivingEvent.READY_FOR_PLAYING,this.__onReady);
      }
      
      override protected function __beginNewTurn(param1:LivingEvent) : void
      {
         super.__beginNewTurn(param1);
         if(!_isLiving)
         {
         }
         if(contains(this._attackPlayerCite))
         {
            removeChild(this._attackPlayerCite);
         }
      }
      
      override protected function __shoot(param1:LivingEvent) : void
      {
         var _loc2_:Array = param1.paras[0];
         this.player.currentBomb = _loc2_[0].Template.ID;
         map.act(new PrepareShootAction(this));
         map.act(new ShootBombAction(this,_loc2_,param1.paras[1],this._point.y,this._shootAction));
         this._shootAction = ActionType.BEAT_A;
      }
      
      override protected function removeListener() : void
      {
         super.removeListener();
         this.player.removeEventListener(LivingEvent.POS_CHANGED,this.__posChanged);
         this.player.removeEventListener(LivingEvent.USING_ITEM,this.__usingItem);
         this.player.removeEventListener(LivingEvent.PLAYER_MOVETO,this.__playerMoveTo);
         this.player.removeEventListener(LivingEvent.USE_PET_SKILL,this.__usePetSkill);
         this.player.removeEventListener(LivingEvent.PET_BEAT,this.__petBeat);
         ChatManager.Instance.removeEventListener(ChatEvent.SHOW_FACE,this.__getFace);
         ChatManager.Instance.model.removeEventListener(ChatEvent.ADD_CHAT,this.__getChat);
         this.player.removeEventListener(LivingEvent.READY_FOR_PLAYING,this.__onReady);
      }
      
      protected function attackingViewChanged() : void
      {
         if(this.player.isAttacking && this.player.isLiving)
         {
            this._attackPlayerCite.gotoAndStop(_info.team);
            addChild(this._attackPlayerCite);
         }
         else if(contains(this._attackPlayerCite))
         {
            removeChild(this._attackPlayerCite);
         }
      }
      
      override protected function __attackingChanged(param1:LivingEvent) : void
      {
         super.__attackingChanged(param1);
         this.attackingViewChanged();
      }
      
      override protected function __dirChanged(param1:LivingEvent) : void
      {
         if(_info.direction > 0)
         {
            movie.scaleX = -1;
            this._playerSprite.scaleX = -1;
         }
         else
         {
            movie.scaleX = 1;
            this._playerSprite.scaleX = 1;
         }
         if(this._facecontainer)
         {
            this._facecontainer.scaleX = 1;
         }
      }
      
      protected function __playerMoveTo(param1:LivingEvent) : void
      {
         var _loc2_:int = param1.paras[0];
         switch(_loc2_)
         {
            case 0:
               act(new PlayerWalkAction(this,param1.paras[1],param1.paras[2]));
               break;
            case 1:
               act(new PlayerFallingAction(this,param1.paras[1],param1.paras[3],false));
               break;
            case 2:
               act(new GhostMoveAction(this,param1.paras[1],param1.paras[4]));
               break;
            case 3:
               act(new PlayerFallingAction(this,param1.paras[1],param1.paras[3],true));
               break;
            case 4:
               act(new PlayerWalkAction(this,param1.paras[1],param1.paras[2]));
         }
      }
      
      protected function __usePetSkill(param1:LivingEvent) : void
      {
         var _loc2_:PetSkillInfo = PetSkillManager.instance.getSkillByID(param1.value);
         if(_loc2_ == null)
         {
            throw new Error("找不到技能，技能ID为：" + param1.value);
         }
         if(_loc2_.isActiveSkill)
         {
            switch(_loc2_.BallType)
            {
               case PetSkillInfo.BALL_TYPE_0:
                  this.usePetSkill(_loc2_);
                  break;
               case PetSkillInfo.BALL_TYPE_1:
                  if(GameManager.Instance.Current.selfGamePlayer.team == info.team)
                  {
                     this._shootAction = _loc2_.Action;
                     GameManager.Instance.Current.selfGamePlayer.soulPropEnabled = false;
                     dispatchEvent(new GameEvent(GameEvent.BOSS_USE_SKILL));
                  }
                  break;
               case PetSkillInfo.BALL_TYPE_2:
                  if(GameManager.Instance.Current.selfGamePlayer.team == info.team)
                  {
                     GameManager.Instance.Current.selfGamePlayer.soulPropEnabled = false;
                  }
                  this.usePetSkill(_loc2_,this.stand);
                  break;
               case PetSkillInfo.BALL_TYPE_3:
                  this.usePetSkill(_loc2_);
            }
            this.UsedPetSkill.add(_loc2_.ID,_loc2_);
            SoundManager.instance.play("039");
         }
      }
      
      override protected function __bloodChanged(param1:LivingEvent) : void
      {
         if(param1.paras[0] == 0)
         {
            if(_actionMovie != null)
            {
               _actionMovie.doAction(Living.RENEW,super.__bloodChanged,[param1]);
            }
         }
         else if(param1.paras[0] == 10)
         {
            super.__bloodChanged(param1);
         }
         else
         {
            if(param1.paras[0] == 5)
            {
               updateBloodStrip();
               return;
            }
            super.__bloodChanged(param1);
            if(_info.State != 1)
            {
               this.doAction(Living.CRY_ACTION);
            }
         }
      }
      
      public function usePetSkill(param1:PetSkillInfo, param2:Function = null) : void
      {
         this._currentPetSkill = param1;
         this.playPetMovie(param1.Action,_info.pos,param2);
      }
      
      protected function playPetMovie(param1:String, param2:Point, param3:Function = null, param4:Array = null) : void
      {
         if(param3 != null)
         {
            this.actionMovie.doAction(param1,param3);
         }
      }
      
      public function stand() : void
      {
      }
      
      protected function __onReady(param1:Event) : void
      {
         if(GameManager.Instance.Current.getTeamLiveCount(_info.team) <= 1)
         {
            return;
         }
         if(!this.player.isShowReadyMC)
         {
            return;
         }
         if(this.player.isReady)
         {
            if(!this._readyMc)
            {
               this._readyMc = ComponentFactory.Instance.creat("game.object.bossplayer.readyAsset");
               addChild(this._readyMc);
            }
            this._readyMc.visible = true;
            this._readyMc.gotoAndStop(1);
         }
         else if(this._readyMc)
         {
            this._readyMc.gotoAndStop(2);
         }
      }
      
      protected function __petBeat(param1:LivingEvent) : void
      {
         var _loc2_:String = param1.paras[0];
         var _loc3_:Point = param1.paras[1];
         var _loc4_:Array = param1.paras[2];
         this.playPetMovie(_loc2_,_loc3_,this.updateHp,[_loc4_]);
      }
      
      protected function updateHp(param1:Array) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Living = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         for each(_loc2_ in param1)
         {
            _loc3_ = _loc2_.target;
            _loc4_ = _loc2_.hp;
            _loc5_ = _loc2_.damage;
            _loc6_ = _loc2_.dander;
            _loc3_.updateBlood(_loc4_,3,_loc5_);
            if(_loc3_ is Player)
            {
               Player(_loc3_).dander = _loc6_;
            }
         }
      }
      
      protected function __usingItem(param1:LivingEvent) : void
      {
         var _loc2_:ItemTemplateInfo = null;
         if(param1.paras[0] is ItemTemplateInfo)
         {
            _loc2_ = param1.paras[0];
            _propArray.push(_loc2_.Pic);
            doUseItemAnimation(EquipType.hasPropAnimation(param1.paras[0]) != null);
         }
         else if(param1.paras[0] is DisplayObject)
         {
            _propArray.push(param1.paras[0]);
            doUseItemAnimation();
         }
      }
      
      override public function setMap(param1:Map) : void
      {
         super.setMap(param1);
         if(param1)
         {
            this.__posChanged(null);
         }
      }
      
      override protected function initChatball() : void
      {
         _chatballview = new ChatBallPlayer();
         _originalHeight = this.height;
         _originalWidth = this.width;
         addChild(_chatballview);
      }
      
      protected function __getChat(param1:ChatEvent) : void
      {
         if(this.player.isHidden && this.player.team != GameManager.Instance.Current.selfGamePlayer.team)
         {
            return;
         }
         if(!this.player.isLiving)
         {
            return;
         }
         var _loc2_:ChatData = ChatData(param1.data).clone();
         _loc2_.msg = Helpers.deCodeString(_loc2_.msg);
         if(_loc2_.channel == 2 || _loc2_.channel == 3)
         {
            return;
         }
         if(_loc2_.zoneID == -1)
         {
            if(_loc2_.senderID == this.player.playerInfo.ID)
            {
               this.say(_loc2_.msg,this.player.playerInfo.paopaoType);
            }
         }
         else if(_loc2_.senderID == this.player.playerInfo.ID && _loc2_.zoneID == this.player.playerInfo.ZoneID)
         {
            this.say(_loc2_.msg,this.player.playerInfo.paopaoType);
         }
      }
      
      protected function say(param1:String, param2:int) : void
      {
         _chatballview.setText(param1,param2);
         addChild(_chatballview);
         fitChatBallPos();
      }
      
      protected function __getFace(param1:ChatEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.player.isHidden && this.player.team != GameManager.Instance.Current.selfGamePlayer.team)
         {
            return;
         }
         var _loc2_:Object = param1.data;
         if(_loc2_["playerid"] == this.player.playerInfo.ID)
         {
            _loc3_ = _loc2_["faceid"];
            _loc4_ = _loc2_["delay"];
            if(_loc3_ >= 49)
            {
               setTimeout(this.showFace,_loc4_,_loc3_);
            }
            else
            {
               this.showFace(_loc3_);
            }
            if(_loc3_ < 49 && _loc3_ > 0)
            {
               ChatManager.Instance.dispatchEvent(new ChatEvent(ChatEvent.SET_FACECONTIANER_LOCTION));
            }
         }
      }
      
      protected function showFace(param1:int) : void
      {
         if(this._facecontainer == null)
         {
            return;
         }
         this._facecontainer.scaleX = 1;
         this._facecontainer.setFace(param1);
      }
      
      override protected function __posChanged(param1:LivingEvent) : void
      {
         super.__posChanged(param1);
      }
      
      protected function __playPlayerEffect(param1:Event) : void
      {
         if(ModuleLoader.hasDefinition(this._currentPetSkill.EffectClassLink))
         {
            this.showEffect(this._currentPetSkill.EffectClassLink);
         }
      }
      
      override public function die() : void
      {
         super.die();
         this.player.isSpecialSkill = false;
         this.player.skill = -1;
         SoundManager.instance.play("042");
         _bloodStripBg.visible = _HPStrip.visible = false;
         _nickName.visible = false;
         if(contains(this._attackPlayerCite))
         {
            removeChild(this._attackPlayerCite);
         }
      }
      
      override protected function __die(param1:LivingEvent) : void
      {
         if(isMoving())
         {
            stopMoving();
         }
         super.__die(param1);
         if(param1.paras[0])
         {
            _actionMovie.doAction(Living.DIE_ACTION,this.dieActionCallback);
         }
      }
      
      private function dieActionCallback() : void
      {
         this._playerSprite.visible = true;
         _actionMovie.visible = false;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         while(this._playerSprite && this._playerSprite.numChildren > 0)
         {
            this._playerSprite.removeChildAt(0);
            ObjectUtils.disposeObject(this._playerSprite);
            this._playerSprite = null;
         }
         this._body = null;
         ObjectUtils.disposeObject(this._readyMc);
         this._readyMc = null;
         ObjectUtils.disposeObject(this._attackPlayerCite);
         this._attackPlayerCite = null;
         ObjectUtils.disposeObject(this._facecontainer);
         this._facecontainer = null;
      }
   }
}
