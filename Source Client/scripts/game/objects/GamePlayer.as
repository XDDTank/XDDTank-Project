package game.objects
{
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.PlayerAction;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.LivingEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.Helpers;
   import ddt.view.ExpMovie;
   import ddt.view.FaceContainer;
   import ddt.view.character.GameCharacter;
   import ddt.view.character.ShowCharacter;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatEvent;
   import ddt.view.chat.chatBall.ChatBallPlayer;
   import ddt.view.common.LevelIcon;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.actions.GhostMoveAction;
   import game.actions.PlayerBeatAction;
   import game.actions.PlayerFallingAction;
   import game.actions.PlayerWalkAction;
   import game.actions.PrepareShootAction;
   import game.actions.SelfSkipAction;
   import game.actions.ShootBombAction;
   import game.actions.SkillActions.ResolveHurtAction;
   import game.actions.SkillActions.RevertAction;
   import game.actions.pet.PetBeatAction;
   import game.actions.pet.PetDefenceAction;
   import game.animations.AnimationLevel;
   import game.animations.BaseSetCenterAnimation;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.Player;
   import militaryrank.view.MilitaryIcon;
   import pet.date.PetSkillInfo;
   import phy.maps.Map;
   import playerParticle.PlayerParticle;
   import playerParticle.PlayerParticleManager;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.StringObject;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   
   public class GamePlayer extends GameTurnedLiving
   {
       
      
      protected var _player:Sprite;
      
      protected var _playerParticle:Sprite;
      
      protected var _attackPlayerCite:MovieClip;
      
      private var _levelIcon:LevelIcon;
      
      private var _militaryIcon:MilitaryIcon;
      
      protected var _consortiaName:FilterFrameText;
      
      private var _facecontainer:FaceContainer;
      
      private var _ballpos:Point;
      
      private var _expView:ExpMovie;
      
      private var _petMovie:GamePetMovie;
      
      private var _currentPetSkill:PetSkillInfo;
      
      protected var _gamePet:GamePet;
      
      private var _dieFightMC:MovieClip;
      
      private var _readyMc:MovieClip;
      
      private var _point:Point;
      
      private var _danderFire:MovieClip;
      
      public var UsedPetSkill:DictionaryData;
      
      private var _lastTurn:int;
      
      private var _character:ShowCharacter;
      
      private var _body:GameCharacter;
      
      private var _weaponMovie:MovieClip;
      
      private var _currentWeaponMovie:MovieClip;
      
      private var _currentWeaponMovieAction:String = "";
      
      private var labelMapping:Dictionary;
      
      public function GamePlayer(param1:Player, param2:ShowCharacter, param3:GameCharacter = null)
      {
         this.UsedPetSkill = new DictionaryData();
         this.labelMapping = new Dictionary();
         this._character = param2;
         this._body = param3;
         super(param1);
         this._ballpos = new Point(30,-20);
         if(param1.petLiving)
         {
            this._gamePet = new GamePet(param1.petLiving,this);
         }
      }
      
      override public function update(param1:Number) : void
      {
         super.update(param1);
         PlayerParticleManager.instance.showParticle(Id);
      }
      
      protected function __playPlayerEffect(param1:Event) : void
      {
         if(ModuleLoader.hasDefinition(this._currentPetSkill.EffectClassLink))
         {
            this.showEffect(this._currentPetSkill.EffectClassLink);
         }
      }
      
      public function get facecontainer() : FaceContainer
      {
         return this._facecontainer;
      }
      
      public function get gamePet() : GamePet
      {
         return this._gamePet;
      }
      
      public function set facecontainer(param1:FaceContainer) : void
      {
         this._facecontainer = param1;
      }
      
      public function get point() : Point
      {
         return this._point;
      }
      
      override protected function initView() : void
      {
         var _loc1_:GameInfo = null;
         var _loc2_:SelfInfo = null;
         this._point = ComponentFactory.Instance.creatCustomObject("tian.shootSpeed1");
         bodyHeight = 55;
         super.initView();
         this._playerParticle = new Sprite();
         this._playerParticle.y = -3;
         addChild(this._playerParticle);
         this._player = new Sprite();
         this._player.y = -3;
         addChild(this._player);
         _nickName.x = -19;
         this._body.x = 0;
         this._body.doAction(this.getAction("stand"));
         this._player.addChild(this._body as DisplayObject);
         this._player.mouseChildren = this._player.mouseEnabled = false;
         _chatballview = new ChatBallPlayer();
         this._attackPlayerCite = ClassUtils.CreatInstance("asset.game.AttackCiteAsset") as MovieClip;
         this._attackPlayerCite.y = -75;
         this._attackPlayerCite.mouseChildren = this._attackPlayerCite.mouseEnabled = false;
         if(this.player.isAttacking && !RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this._attackPlayerCite.gotoAndStop(_info.team);
            removeChild(this._attackPlayerCite);
         }
         this._militaryIcon = new MilitaryIcon(this.player.playerInfo);
         this._militaryIcon.setMilitary(this.player.playerInfo.MilitaryRankTotalScores);
         this._militaryIcon.x = -60;
         this._militaryIcon.y = _bloodStripBg.y - 5;
         addChild(this._militaryIcon);
         if(this.player.playerInfo.ConsortiaName || this.player.playerInfo.honor)
         {
            this._consortiaName = ComponentFactory.Instance.creatComponentByStylename("GameLiving.ConsortiaName");
            this._consortiaName.text = this.player.playerInfo.showDesignation;
            if(this.player.playerInfo.ConsortiaID != 0)
            {
               _loc1_ = GameManager.Instance.Current;
               _loc2_ = PlayerManager.Instance.Self;
               if(_loc2_.ConsortiaID == 0 || _loc2_.ConsortiaID == this.player.playerInfo.ConsortiaID && _loc2_.ZoneID == this.player.playerInfo.ZoneID || _loc1_ && _loc1_.gameMode == 2)
               {
                  this._consortiaName.setFrame(3);
               }
               else
               {
                  this._consortiaName.setFrame(2);
               }
            }
            else
            {
               this._consortiaName.setFrame(1);
            }
            this._consortiaName.x = _nickName.x;
            this._consortiaName.y = _nickName.y + _nickName.height / 2 + 5;
         }
         this._expView = new ExpMovie();
         addChild(this._expView);
         this._expView.y = -60;
         this._expView.x = -50;
         this._expView.scaleX = this._expView.scaleY = 1.5;
         this._facecontainer = new FaceContainer();
         addChild(this._facecontainer);
         this._facecontainer.y = -100;
         this._facecontainer.setNickName(_nickName.text);
         if(this._body.wing && !_info.playerInfo.wingHide)
         {
            this.addWing();
         }
         else
         {
            this.removeWing();
         }
         _propArray = new Array();
         this.__dirChanged(null);
         this._dieFightMC = ClassUtils.CreatInstance("asset.game.4.dian");
         this.addChild(this._dieFightMC);
         this._dieFightMC.visible = false;
      }
      
      protected function creatParticle() : PlayerParticle
      {
         var _loc1_:PlayerParticle = null;
         _loc1_ = new PlayerParticle(this);
         _loc1_.alpha = 0;
         _loc1_.visible = false;
         this._playerParticle.addChild(_loc1_);
         return _loc1_;
      }
      
      protected function cleanParticle(param1:PlayerParticle) : void
      {
         param1.alpha = 0;
         param1.visible = false;
      }
      
      override protected function initListener() : void
      {
         super.initListener();
         this.player.addEventListener(LivingEvent.POS_CHANGED,this.__posChanged);
         this.player.addEventListener(LivingEvent.USING_ITEM,this.__usingItem);
         this.player.addEventListener(LivingEvent.USING_SPECIAL_SKILL,this.__usingSpecialKill);
         this.player.addEventListener(LivingEvent.DANDER_CHANGED,this.__danderChanged);
         this.player.addEventListener(LivingEvent.PLAYER_MOVETO,this.__playerMoveTo);
         this.player.addEventListener(LivingEvent.USE_PET_SKILL,this.__usePetSkill);
         this.player.addEventListener(LivingEvent.PET_BEAT,this.__petBeat);
         this.player.addEventListener(LivingEvent.PET_DEFENCE,this.__petDefence);
         ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT,this.__getChat);
         ChatManager.Instance.addEventListener(ChatEvent.SHOW_FACE,this.__getFace);
         _info.addEventListener(LivingEvent.BOX_PICK,this.__boxPickHandler);
         this._body.addEventListener(Event.COMPLETE,this.__characterComplete);
         this.player.addEventListener(LivingEvent.DO_DIE_FIGHT,this.__onDieFightLightFlash);
         this.player.addEventListener(LivingEvent.READY_FOR_PLAYING,this.__onReady);
      }
      
      private function __characterComplete(param1:Event) : void
      {
         if(this._body && this._body.wing && !_info.playerInfo.wingHide)
         {
            this.addWing();
         }
         else
         {
            this.removeWing();
         }
      }
      
      override protected function removeListener() : void
      {
         super.removeListener();
         this.player.removeEventListener(LivingEvent.POS_CHANGED,this.__posChanged);
         this.player.removeEventListener(LivingEvent.USING_ITEM,this.__usingItem);
         this.player.removeEventListener(LivingEvent.USING_SPECIAL_SKILL,this.__usingSpecialKill);
         this.player.removeEventListener(LivingEvent.DANDER_CHANGED,this.__danderChanged);
         this.player.removeEventListener(LivingEvent.PLAYER_MOVETO,this.__playerMoveTo);
         this.player.removeEventListener(LivingEvent.USE_PET_SKILL,this.__usePetSkill);
         this.player.removeEventListener(LivingEvent.PET_BEAT,this.__petBeat);
         this.player.removeEventListener(LivingEvent.PET_DEFENCE,this.__petDefence);
         if(this._weaponMovie)
         {
            this._weaponMovie.addEventListener(Event.ENTER_FRAME,this.checkCurrentMovie);
         }
         if(this._petMovie)
         {
            this._petMovie.removeEventListener(GamePetMovie.PlayEffect,this.__playPlayerEffect);
         }
         ChatManager.Instance.model.removeEventListener(ChatEvent.ADD_CHAT,this.__getChat);
         ChatManager.Instance.removeEventListener(ChatEvent.SHOW_FACE,this.__getFace);
         _info.removeEventListener(LivingEvent.BOX_PICK,this.__boxPickHandler);
         this._body.removeEventListener(Event.COMPLETE,this.__characterComplete);
         this.player.removeEventListener(LivingEvent.DO_DIE_FIGHT,this.__onDieFightLightFlash);
         this.player.removeEventListener(LivingEvent.READY_FOR_PLAYING,this.__onReady);
      }
      
      protected function __onDieFightLightFlash(param1:LivingEvent) : void
      {
         if(!this._dieFightMC.visible)
         {
            this._dieFightMC.visible = true;
         }
         this._dieFightMC.gotoAndPlay(2);
      }
      
      override public function get movie() : Sprite
      {
         return this._player;
      }
      
      protected function __boxPickHandler(param1:LivingEvent) : void
      {
         if(PlayerManager.Instance.Self.FightBag.itemNumber > 3)
         {
            ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("tank.game.gameplayer.proplist.full"));
         }
      }
      
      override protected function __applySkill(param1:LivingEvent) : void
      {
         var _loc2_:Array = param1.paras;
         var _loc3_:int = _loc2_[0];
         switch(_loc3_)
         {
            case SkillType.ResolveHurt:
               this.applyResolveHurt(_loc2_[1]);
               break;
            case SkillType.Revert:
               this.applyRevert(_loc2_[1]);
         }
      }
      
      private function applyRevert(param1:PackageIn) : void
      {
         map.animateSet.addAnimation(new BaseSetCenterAnimation(x,y - 150,1,false,AnimationLevel.HIGHT,_info.LivingID));
         map.act(new RevertAction(map.spellKill(this),this.player,param1));
      }
      
      private function applyResolveHurt(param1:PackageIn) : void
      {
         map.animateSet.addAnimation(new BaseSetCenterAnimation(x,y - 150,1,false,AnimationLevel.HIGHT,_info.LivingID));
         map.act(new ResolveHurtAction(map.spellKill(this),this.player,param1));
      }
      
      protected function __usingItem(param1:LivingEvent) : void
      {
         var _loc2_:ItemTemplateInfo = null;
         if(param1.paras[0] is ItemTemplateInfo)
         {
            _loc2_ = param1.paras[0];
            _propArray.push(_loc2_.Pic);
            this.doUseItemAnimation(EquipType.hasPropAnimation(param1.paras[0]) != null);
         }
         else if(param1.paras[0] is DisplayObject)
         {
            _propArray.push(param1.paras[0]);
            this.doUseItemAnimation();
         }
      }
      
      protected function __usingSpecialKill(param1:LivingEvent) : void
      {
         _propArray.push("-1");
         this.doUseItemAnimation();
      }
      
      override protected function doUseItemAnimation(param1:Boolean = false) : void
      {
         var _loc2_:MovieClipWrapper = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.ghostPcikPropAsset")),true,true);
         _loc2_.addFrameScriptAt(12,headPropEffect);
         SoundManager.instance.play("039");
         _loc2_.movie.x = 0;
         _loc2_.movie.y = -10;
         if(!param1)
         {
            addChild(_loc2_.movie);
         }
         if(_isLiving)
         {
            this.doAction(this._body.handClipAction);
            this.body.WingState = GameCharacter.GAME_WING_CLIP;
         }
      }
      
      protected function __danderChanged(param1:LivingEvent) : void
      {
         if(this.player.dander >= Player.TOTAL_DANDER && _isLiving)
         {
            if(this._danderFire == null)
            {
               this._danderFire = MovieClip(ClassUtils.CreatInstance("asset.game.danderAsset"));
               this._danderFire.x = 3;
               this._danderFire.y = this._body.y + 5;
               this._danderFire.mouseChildren = this._danderFire.mouseEnabled = false;
            }
            this._danderFire.play();
            this._player.addChild(this._danderFire);
         }
         else if(this._danderFire && this._danderFire.parent)
         {
            this._danderFire.stop();
            this._player.removeChild(this._danderFire);
         }
      }
      
      override protected function __posChanged(param1:LivingEvent) : void
      {
         pos = this.player.pos;
         if(_isLiving)
         {
            this._player.rotation = calcObjectAngle();
            this.player.playerAngle = this._player.rotation;
         }
         if(map && map.smallMap)
         {
            map.smallMap.updatePos(smallView,pos);
         }
      }
      
      override protected function __dirChanged(param1:LivingEvent) : void
      {
         super.__dirChanged(param1);
         if(this._facecontainer)
         {
            this._facecontainer.scaleX = 1;
         }
         if(!this.player.isLiving)
         {
            this.setSoulPos();
         }
      }
      
      override protected function __attackingChanged(param1:LivingEvent) : void
      {
         super.__attackingChanged(param1);
         this.attackingViewChanged();
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
      
      override protected function __hiddenChanged(param1:LivingEvent) : void
      {
         super.__hiddenChanged(param1);
         if(_info.isHidden)
         {
            if(_info.team != GameManager.Instance.Current.selfGamePlayer.team)
            {
               if(this._gamePet)
               {
                  this._gamePet.alpha = 0;
               }
            }
            else if(this._gamePet)
            {
               this._gamePet.alpha = 0.5;
            }
            if(_chatballview)
            {
               _chatballview.visible = false;
            }
         }
         else
         {
            _nickName.visible = true;
            if(this._gamePet)
            {
               this._gamePet.alpha = 1;
            }
         }
      }
      
      override protected function __say(param1:LivingEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(!_info.isHidden)
         {
            _loc2_ = param1.paras[0];
            _loc3_ = 0;
            if(param1.paras[1])
            {
               _loc3_ = param1.paras[1];
            }
            if(_loc3_ != 9)
            {
               _loc3_ = this.player.playerInfo.paopaoType;
            }
            this.say(_loc2_,_loc3_);
         }
      }
      
      override protected function __bloodChanged(param1:LivingEvent) : void
      {
         super.__bloodChanged(param1);
         if(param1.paras[0] != 0)
         {
            if(_isLiving)
            {
               this._body.doAction(this.getAction("cry"));
               this._body.WingState = GameCharacter.GAME_WING_CRY;
            }
         }
         updateBloodStrip();
      }
      
      override protected function __shoot(param1:LivingEvent) : void
      {
         var _loc2_:Array = param1.paras[0];
         this.player.currentBomb = _loc2_[0].Template.ID;
         if(!this.player.isReady)
         {
            map.act(new PrepareShootAction(this));
         }
         this.player.isReady = false;
         map.act(new ShootBombAction(this,_loc2_,param1.paras[1],this._point.y));
      }
      
      override protected function __prepareShoot(param1:LivingEvent) : void
      {
         map.act(new PrepareShootAction(this));
      }
      
      override protected function __beat(param1:LivingEvent) : void
      {
         act(new PlayerBeatAction(this));
      }
      
      protected function __usePetSkill(param1:LivingEvent) : void
      {
         var _loc2_:PetSkillInfo = PetSkillManager.instance.getSkillByID(param1.value);
         if(_loc2_ == null)
         {
            throw new Error("找不到技能，技能ID为：" + param1.value);
         }
         if(_loc2_.Action.length > 0)
         {
            switch(_loc2_.BallType)
            {
               case PetSkillInfo.BALL_TYPE_0:
                  this.usePetSkill(_loc2_);
                  break;
               case PetSkillInfo.BALL_TYPE_1:
                  if(GameManager.Instance.Current.selfGamePlayer.team == info.team)
                  {
                     GameManager.Instance.Current.selfGamePlayer.soulPropEnabled = false;
                  }
                  this.usePetSkill(_loc2_);
                  break;
               case PetSkillInfo.BALL_TYPE_2:
                  if(GameManager.Instance.Current.selfGamePlayer.team == info.team)
                  {
                     GameManager.Instance.Current.selfGamePlayer.soulPropEnabled = false;
                  }
                  this.usePetSkill(_loc2_,this.skipSelfTurn);
                  break;
               case PetSkillInfo.BALL_TYPE_3:
                  this._gamePet.map.bringToFront(this._gamePet.info);
                  showEffect(_loc2_.EffectClassLink);
                  this.usePetSkill(_loc2_);
            }
         }
      }
      
      private function __petBeat(param1:LivingEvent) : void
      {
         var _loc2_:String = param1.paras[0];
         var _loc3_:Point = param1.paras[1];
         var _loc4_:Array = param1.paras[2];
         if(this._gamePet)
         {
            this._gamePet.act(new PetBeatAction(this._gamePet,this,_loc2_,_loc3_,_loc4_));
         }
         else
         {
            this.playPetMovie(_loc2_,_loc3_,this.updateHp,[_loc4_]);
         }
      }
      
      private function __petDefence(param1:LivingEvent) : void
      {
         var _loc2_:String = param1.paras[0];
         var _loc3_:Point = param1.paras[1];
         if(this._gamePet)
         {
            this._gamePet.act(new PetDefenceAction(this._gamePet,this,_loc2_,_loc3_));
         }
      }
      
      private function playPetMovie(param1:String, param2:Point, param3:Function = null, param4:Array = null) : void
      {
         if(!this._petMovie)
         {
            return;
         }
         this._petMovie.show(param2.x,param2.y);
         this._petMovie.direction = info.direction;
         if(param3 == null)
         {
            this._petMovie.doAction(param1,this.hidePetMovie);
         }
         else
         {
            this._petMovie.doAction(param1,param3,param4);
         }
      }
      
      public function hidePetMovie() : void
      {
         if(this._petMovie)
         {
            this._petMovie.hide();
         }
      }
      
      private function updateHp(param1:Array) : void
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
         if(this._petMovie)
         {
            this._petMovie.hide();
         }
      }
      
      public function usePetSkill(param1:PetSkillInfo, param2:Function = null, param3:Array = null) : void
      {
         this._currentPetSkill = param1;
         if(this._lastTurn != _turns)
         {
            this._lastTurn = _turns;
            if(this._gamePet)
            {
               if(param1.Action == "in")
               {
                  this._gamePet.info.actionManagerClear();
                  this.player.petDefence("in",this.player.pos);
               }
               else
               {
                  this._gamePet.actionMovie.doAction(param1.Action);
               }
            }
            else
            {
               this.playPetMovie(param1.Action,_info.pos,param2,param3);
            }
            this.UsedPetSkill.add(param1.ID,param1);
         }
      }
      
      private function skipSelfTurn() : void
      {
         this.hidePetMovie();
         if(info is LocalPlayer)
         {
            act(new SelfSkipAction(LocalPlayer(info)));
         }
      }
      
      override public function startMoving() : void
      {
         super.startMoving();
         PlayerParticleManager.instance.startParticle(this.creatParticle,this.cleanParticle,this);
      }
      
      override public function stopMoving() : void
      {
         super.stopMoving();
         PlayerParticleManager.instance.stopParticle(this);
      }
      
      protected function __playerMoveTo(param1:LivingEvent) : void
      {
         var _loc2_:int = param1.paras[0];
         switch(_loc2_)
         {
            case 0:
               act(new PlayerWalkAction(this,param1.paras[1],param1.paras[2],this.getAction("walk")));
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
               act(new PlayerWalkAction(this,param1.paras[1],param1.paras[2],this.getAction("stand")));
         }
      }
      
      override protected function __fall(param1:LivingEvent) : void
      {
         act(new PlayerFallingAction(this,param1.paras[0],true,false));
      }
      
      override protected function __moveTo(param1:LivingEvent) : void
      {
      }
      
      override protected function __jump(param1:LivingEvent) : void
      {
      }
      
      private function setSoulPos() : void
      {
         if(this._player.scaleX == -1)
         {
            this._body.x = -6;
         }
         else
         {
            this._body.x = -13;
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
         return info as Player;
      }
      
      private function addWing() : void
      {
         if(!this._body || this._body.wing == null)
         {
            return;
         }
         this._body.setWingPos(this._body.weaponX * this._body.scaleX,this._body.weaponY * this._body.scaleY);
         this._body.setWingScale(this._body.scaleX,this._body.scaleY);
         if(this._body.leftWing && this._body.leftWing.parent != this._player)
         {
            this._player.addChild(this._body.rightWing);
            this._player.addChildAt(this._body.leftWing,0);
         }
         this._body.switchWingVisible(_info.isLiving);
         this._body.WingState = GameCharacter.GAME_WING_WAIT;
      }
      
      private function removeWing() : void
      {
         if(this._body.leftWing && this._body.leftWing.parent)
         {
            this._body.leftWing.parent.removeChild(this._body.leftWing);
         }
         if(this._body.rightWing && this._body.rightWing.parent)
         {
            this._body.rightWing.parent.removeChild(this._body.rightWing);
         }
      }
      
      public function get weaponMovie() : MovieClip
      {
         return this._weaponMovie;
      }
      
      public function set weaponMovie(param1:MovieClip) : void
      {
         if(param1 != this._weaponMovie)
         {
            if(this._weaponMovie && this._weaponMovie.parent)
            {
               this._weaponMovie.removeEventListener(Event.ENTER_FRAME,this.checkCurrentMovie);
               this._weaponMovie.parent.removeChild(this._weaponMovie);
            }
            this._weaponMovie = param1;
            this._currentWeaponMovie = null;
            this._currentWeaponMovieAction = "";
            if(this._weaponMovie)
            {
               this._weaponMovie.stop();
               this._weaponMovie.addEventListener(Event.ENTER_FRAME,this.checkCurrentMovie);
               this._weaponMovie.x = this._body.weaponX * this._body.scaleX;
               this._weaponMovie.y = this._body.weaponY * this._body.scaleY;
               this._weaponMovie.scaleX = this._body.scaleX;
               this._weaponMovie.scaleY = this._body.scaleY;
               this._weaponMovie.visible = false;
               this._player.addChild(this._weaponMovie);
               if(this._body.wing && !_info.playerInfo.wingHide)
               {
                  this.addWing();
               }
               else
               {
                  this.removeWing();
               }
            }
         }
      }
      
      private function checkCurrentMovie(param1:Event) : void
      {
         if(this._weaponMovie == null)
         {
            return;
         }
         this._currentWeaponMovie = this._weaponMovie.getChildAt(0) as MovieClip;
         if(this._currentWeaponMovie && this._currentWeaponMovieAction != "")
         {
            this._weaponMovie.removeEventListener(Event.ENTER_FRAME,this.checkCurrentMovie);
            this.setWeaponMoiveActionSyc(this._currentWeaponMovieAction);
         }
      }
      
      public function setWeaponMoiveActionSyc(param1:String) : void
      {
         if(this._currentWeaponMovie)
         {
            this._currentWeaponMovie.gotoAndPlay(param1);
         }
         else
         {
            this._currentWeaponMovieAction = param1;
         }
      }
      
      override public function die() : void
      {
         super.die();
         this.player.isSpecialSkill = false;
         this.player.skill = -1;
         SoundManager.instance.play("042");
         this.weaponMovie = null;
         this._player.rotation = 0;
         this._player.y = 25;
         if(contains(this._attackPlayerCite))
         {
            removeChild(this._attackPlayerCite);
         }
         _bloodStripBg.visible = _HPStrip.visible = false;
         var _loc1_:TombView = new TombView();
         _loc1_.pos = this.pos;
         _map.addPhysical(_loc1_);
         _loc1_.startMoving();
         this.player.pos = new Point(x,y - 70);
         this.player.startMoving();
         this.doAction(GameCharacter.SOUL);
         this.setSoulPos();
         _nickName.y += 10;
         if(this._consortiaName)
         {
            this._consortiaName.y += 10;
         }
         if(this._levelIcon)
         {
            this._levelIcon.y += 20;
         }
         _map.setTopPhysical(this);
         if(this._danderFire && this._danderFire.parent)
         {
            this._danderFire.parent.removeChild(this._danderFire);
         }
         this._danderFire = null;
         if(this._petMovie)
         {
            this._petMovie.dispose();
         }
         this._petMovie = null;
         if(this._gamePet)
         {
            this._gamePet.dispose();
            this._gamePet = null;
         }
      }
      
      override protected function __beginNewTurn(param1:LivingEvent) : void
      {
         super.__beginNewTurn(param1);
         this.UsedPetSkill.clear();
         if(_isLiving)
         {
            this._body.doAction(this._body.standAction);
            this._body.randomCryType();
         }
         this.weaponMovie = null;
         this.player.skill = -1;
         _info.shootInterval = Player.SHOOT_INTERVAL;
         if(contains(this._attackPlayerCite))
         {
            removeChild(this._attackPlayerCite);
         }
      }
      
      private function __getChat(param1:ChatEvent) : void
      {
         if(this.player.isHidden && this.player.team != GameManager.Instance.Current.selfGamePlayer.team)
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
      
      private function say(param1:String, param2:int) : void
      {
         _chatballview.setText(param1,param2);
         addChild(_chatballview);
         fitChatBallPos();
      }
      
      override protected function get popPos() : Point
      {
         if(!_info.isLiving)
         {
            return new Point(18,-20);
         }
         return new Point(18,-40);
      }
      
      override protected function get popDir() : Point
      {
         return null;
      }
      
      private function __getFace(param1:ChatEvent) : void
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
      
      private function showFace(param1:int) : void
      {
         if(this._facecontainer == null)
         {
            return;
         }
         this._facecontainer.scaleX = 1;
         this._facecontainer.setFace(param1);
      }
      
      public function shootPoint() : Point
      {
         var _loc1_:Point = this._ballpos;
         _loc1_ = this._body.localToGlobal(_loc1_);
         return _map.globalToLocal(_loc1_);
      }
      
      override public function doAction(param1:*) : void
      {
         if(param1 is PlayerAction)
         {
            this._body.doAction(param1);
         }
      }
      
      override public function dispose() : void
      {
         this.removeListener();
         super.dispose();
         if(_chatballview)
         {
            _chatballview.dispose();
            _chatballview = null;
         }
         if(this._facecontainer)
         {
            this._facecontainer.dispose();
            this._facecontainer = null;
         }
         ObjectUtils.disposeObject(this._gamePet);
         this._gamePet = null;
         if(this._petMovie)
         {
            this._petMovie.dispose();
         }
         this._petMovie = null;
         ObjectUtils.disposeObject(this._militaryIcon);
         this._militaryIcon = null;
         if(this._consortiaName)
         {
            ObjectUtils.disposeObject(this._consortiaName);
         }
         this._consortiaName = null;
         if(this._attackPlayerCite)
         {
            if(this._attackPlayerCite.parent)
            {
               this._attackPlayerCite.parent.removeChild(this._attackPlayerCite);
            }
         }
         this._attackPlayerCite = null;
         this._character = null;
         this._body = null;
         if(this._weaponMovie)
         {
            this._weaponMovie.stop();
            this._weaponMovie = null;
         }
         if(this._danderFire && this._danderFire.parent)
         {
            this._danderFire.stop();
            this._player.removeChild(this._danderFire);
         }
         if(this._dieFightMC)
         {
            ObjectUtils.disposeObject(this._dieFightMC);
            this._dieFightMC = null;
         }
         while(this._player && this._player.numChildren > 0)
         {
            this._player.removeChildAt(0);
            ObjectUtils.disposeObject(this._player);
            this._player = null;
         }
         if(this._levelIcon)
         {
            if(this._levelIcon.parent)
            {
               this._levelIcon.parent.removeChild(this._levelIcon);
            }
            this._levelIcon.dispose();
         }
         this._levelIcon = null;
         ObjectUtils.disposeObject(this._expView);
         this._expView = null;
         ObjectUtils.disposeObject(this._readyMc);
         this._readyMc = null;
         PlayerParticleManager.instance.dispose();
         ObjectUtils.disposeAllChildren(this._playerParticle);
         ObjectUtils.disposeObject(this._playerParticle);
         this._playerParticle = null;
      }
      
      override protected function __bombed(param1:LivingEvent) : void
      {
         this.body.bombed();
      }
      
      override public function setMap(param1:Map) : void
      {
         super.setMap(param1);
         if(param1)
         {
            this.__posChanged(null);
         }
      }
      
      override public function setProperty(param1:String, param2:String) : void
      {
         var _loc3_:StringObject = null;
         var _loc4_:Number = NaN;
         _loc3_ = new StringObject(param2);
         switch(param1)
         {
            case "GhostGPUp":
               _loc4_ = _loc3_.getInt();
               this._expView.exp = _loc4_;
               this._expView.play();
               this._body.doAction(GameCharacter.SOUL_SMILE);
         }
         super.setProperty(param1,param2);
      }
      
      public function set gainEXP(param1:int) : void
      {
         _nickName.text = String(param1);
      }
      
      override public function setActionMapping(param1:String, param2:String) : void
      {
         if(param1.length <= 0)
         {
            return;
         }
         this.labelMapping[param1] = param2;
      }
      
      public function getAction(param1:String) : PlayerAction
      {
         if(this.labelMapping[param1])
         {
            param1 = this.labelMapping[param1];
         }
         switch(param1)
         {
            case "stand":
               return this._body.standAction;
            case "walk":
               return this._body.walkAction;
            case "cry":
               return GameCharacter.CRY;
            case "soul":
               return GameCharacter.SOUL;
            default:
               return this._body.standAction;
         }
      }
      
      protected function __onReady(param1:Event) : void
      {
         if(!this.player.isShowReadyMC)
         {
            return;
         }
         if(this.player.isReady && GameManager.Instance.Current.getTeamLiveCount(_info.team) > 1)
         {
            if(!this._readyMc)
            {
               this._readyMc = ComponentFactory.Instance.creat("game.object.gameplayer.readyAsset");
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
   }
}
