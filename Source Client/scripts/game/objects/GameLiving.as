package game.objects
{
   import com.greensock.TweenLite;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffType;
   import ddt.events.GameEvent;
   import ddt.events.LivingCommandEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.DialogManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.view.PropItemView;
   import ddt.view.chat.chatBall.ChatBallBase;
   import ddt.view.chat.chatBall.ChatBallPlayer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.actions.BaseAction;
   import game.actions.LivingFallingAction;
   import game.actions.LivingJumpAction;
   import game.actions.LivingMoveAction;
   import game.actions.LivingTurnAction;
   import game.animations.AnimationLevel;
   import game.animations.ShockMapAnimation;
   import game.model.Living;
   import game.view.AutoPropEffect;
   import game.view.EffectIconContainer;
   import game.view.IDisplayPack;
   import game.view.LeftPlayerCartoonView;
   import game.view.buff.FightBuffBar;
   import game.view.effects.BaseMirariEffectIcon;
   import game.view.effects.ShootPercentView;
   import game.view.effects.ShowEffect;
   import game.view.map.MapView;
   import game.view.smallMap.SmallLiving;
   import game.view.smallMap.SmallPlayer;
   import phy.object.PhysicalObj;
   import phy.object.PhysicsLayer;
   import phy.object.SmallObject;
   import road.game.resource.ActionMovie;
   import road.game.resource.ActionMovieEvent;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import road7th.data.StringObject;
   import road7th.utils.AutoDisappear;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import room.model.RoomInfo;
   import tank.events.ActionEvent;
   
   public class GameLiving extends PhysicalObj
   {
      
      protected static var SHOCK_EVENT:String = "shockEvent";
      
      protected static var SHOCK_EVENT2:String = "shockEvent2";
      
      protected static var SHIELD:String = "shield";
      
      protected static var BOMB_EVENT:String = "bombEvent";
      
      public static var SHOOT_PREPARED:String = "shootPrepared";
      
      protected static var RENEW:String = "renew";
      
      protected static var NEED_FOCUS:String = "focus";
      
      protected static var PLAY_EFFECT:String = "playeffect";
      
      protected static var PLAYER_EFFECT:String = "effect";
      
      protected static var ATTACK_COMPLETE_FOCUS:String = "attackCompleteFocus";
      
      public static const stepY:int = 7;
      
      public static const npcStepX:int = 1;
      
      public static const npcStepY:int = 3;
      
      public static const OVERFRAME:int = 10;
       
      
      protected var _info:Living;
      
      protected var _actionMovie:ActionMovie;
      
      protected var _chatballview:ChatBallBase;
      
      protected var _smallView:SmallLiving;
      
      protected var speedMult:int = 1;
      
      protected var _nickName:FilterFrameText;
      
      protected var _targetBlood:int;
      
      protected var targetAttackEffect:int;
      
      protected var _originalHeight:Number;
      
      protected var _originalWidth:Number;
      
      public var bodyWidth:Number;
      
      public var bodyHeight:Number;
      
      public var isExist:Boolean = true;
      
      protected var _turns:int;
      
      private var _offsetX:Number = 0;
      
      private var _offsetY:Number = 0;
      
      private var _speedX:Number = 3;
      
      private var _speedY:Number = 7;
      
      protected var _bloodStripBg:Bitmap;
      
      protected var _HPStrip:ScaleFrameImage;
      
      protected var _fightToolBoxSkill:MovieClip;
      
      protected var _bloodWidth:int;
      
      protected var _buffBar:FightBuffBar;
      
      private var _fightPower:FilterFrameText;
      
      private var _buffEffect:DictionaryData;
      
      protected var _doDieAction:Boolean;
      
      private var _dropGoodsTween:TweenLite;
      
      private var _timeoutMark1:uint;
      
      private var _timeoutMark2:uint;
      
      private var _goodsMovie:MovieClip;
      
      private var _iconWrapper:MovieClipWrapper;
      
      private var _effectIconContainer:EffectIconContainer;
      
      protected var counter:int = 1;
      
      protected var ap:Number = 0;
      
      private var _timer:Timer;
      
      private var _defautBitmap:Bitmap;
      
      protected var effectForzen:Sprite;
      
      protected var lock:MovieClip;
      
      protected var _isDie:Boolean = false;
      
      protected var _effRect:Rectangle;
      
      private var _attackEffectPlayer:PhysicalObj;
      
      private var _attackEffectPlaying:Boolean = false;
      
      protected var _attackEffectPos:Point;
      
      protected var _moviePool:Object;
      
      private var _hiddenByServer:Boolean;
      
      protected var _propArray:Array;
      
      private var _onSmallMap:Boolean = true;
      
      public function GameLiving(param1:Living)
      {
         this._buffEffect = new DictionaryData();
         this._attackEffectPos = new Point(0,5);
         this._moviePool = new Object();
         this._info = param1;
         this.initView();
         this.initListener();
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("tian.moveSpeed");
         this._speedX = _loc2_.x;
         this._speedY = _loc2_.y;
         super(param1.LivingID);
         this.initSkillMC();
      }
      
      public static function getAttackEffectAssetByID(param1:int) : MovieClip
      {
         return ClassUtils.CreatInstance("asset.game.AttackEffect" + param1.toString()) as MovieClip;
      }
      
      public function get stepX() : int
      {
         return this._speedX * this.speedMult;
      }
      
      public function get stepY() : int
      {
         return this._speedY * this.speedMult;
      }
      
      override public function get x() : Number
      {
         return super.x + this._offsetX;
      }
      
      override public function get y() : Number
      {
         return super.y + this._offsetY;
      }
      
      public function get EffectIcon() : EffectIconContainer
      {
         if(this._effectIconContainer == null)
         {
         }
         return this._effectIconContainer;
      }
      
      override public function get layer() : int
      {
         if(this.info.isBottom)
         {
            return PhysicsLayer.AppointBottom;
         }
         return PhysicsLayer.GameLiving;
      }
      
      public function get info() : Living
      {
         return this._info;
      }
      
      public function get map() : MapView
      {
         return _map as MapView;
      }
      
      private function __fightPowerChanged(param1:LivingEvent) : void
      {
         if(this._info.fightPower > 0 && this._info.fightPower <= 100)
         {
            this.fightPowerVisible = true;
            this._fightPower.text = LanguageMgr.GetTranslation("ddt.games.powerText",this._info.fightPower);
         }
         else
         {
            this._fightPower.text = "";
         }
      }
      
      public function set fightPowerVisible(param1:Boolean) : void
      {
         this._fightPower.visible = param1;
      }
      
      public function playFightToolBoxSkill() : void
      {
         if(!this._fightToolBoxSkill)
         {
            this.initSkillMC();
         }
         this._fightToolBoxSkill.soundTransform = SoundManager.instance.getNowSoundTransform();
         this._fightToolBoxSkill.visible = true;
         this._fightToolBoxSkill.play();
      }
      
      protected function initView() : void
      {
         this._propArray = [];
         this._bloodStripBg = ComponentFactory.Instance.creatBitmap("asset.game.smallHPStripBgAsset");
         this._HPStrip = ComponentFactory.Instance.creatComponentByStylename("asset.game.HPStrip");
         this._HPStrip.x += this._bloodStripBg.x = -this._bloodStripBg.width / 2 + 2;
         this._HPStrip.y += this._bloodStripBg.y = 20;
         this._bloodWidth = this._HPStrip.width;
         addChild(this._bloodStripBg);
         addChild(this._HPStrip);
         this._HPStrip.setFrame(this.info.team);
         this._fightPower = ComponentFactory.Instance.creatComponentByStylename("GameLiving.fightPower");
         this._nickName = ComponentFactory.Instance.creatComponentByStylename("GameLiving.nickName");
         if(this.info.playerInfo != null)
         {
            this._nickName.text = this.info.playerInfo.NickName;
         }
         else
         {
            this._nickName.text = this.info.name;
         }
         this._nickName.setFrame(this.info.team);
         this._nickName.x = -this._nickName.width / 2 + 2;
         this._nickName.y = this._bloodStripBg.y + this._bloodStripBg.height / 2 + 4;
         this._buffBar = new FightBuffBar();
         this._buffBar.y = -98;
         addChild(this._buffBar);
         this._buffBar.update(this._info.turnBuffs);
         this._buffBar.x = -(this._buffBar.width / 2);
         addChild(this._nickName);
         this._fightPower.x = this._nickName.x - 27;
         this._fightPower.y = this._nickName.y - 130;
         addChild(this._fightPower);
         this.initSmallMapObject();
         mouseChildren = mouseEnabled = false;
      }
      
      private function initSkillMC() : void
      {
         this._fightToolBoxSkill = ComponentFactory.Instance.creat("asset.game.fightToolBoxSkill.mc") as MovieClip;
         this._fightToolBoxSkill.gotoAndStop(1);
         this._fightToolBoxSkill.addFrameScript(OVERFRAME,this.__skillMCdone);
         this._fightToolBoxSkill.visible = false;
         addChild(this._fightToolBoxSkill);
      }
      
      private function __skillMCdone() : void
      {
         if(this._fightToolBoxSkill)
         {
            this._fightToolBoxSkill.stop();
            this._fightToolBoxSkill.visible = false;
            this._fightToolBoxSkill.addFrameScript(OVERFRAME,null);
            ObjectUtils.disposeObject(this._fightToolBoxSkill);
            this._fightToolBoxSkill = null;
         }
      }
      
      protected function initSmallMapObject() : void
      {
         var _loc1_:SmallPlayer = null;
         if(this._info.isPlayer())
         {
            _loc1_ = new SmallPlayer();
            this._smallView = _loc1_;
         }
         else
         {
            this._smallView = new SmallLiving();
         }
         this._smallView.info = this._info;
      }
      
      protected function initEffectIcon() : void
      {
      }
      
      protected function initFreezonRect() : void
      {
         this._effRect = new Rectangle(0,24,200,200);
      }
      
      public function addChildrenByPack(param1:IDisplayPack) : void
      {
         var _loc2_:DisplayObject = null;
         for each(_loc2_ in param1.content)
         {
            addChild(_loc2_);
         }
      }
      
      protected function initListener() : void
      {
         this._info.addEventListener(LivingEvent.BEAT,this.__beat);
         this._info.addEventListener(LivingEvent.BEGIN_NEW_TURN,this.__beginNewTurn);
         this._info.addEventListener(LivingEvent.BLOOD_CHANGED,this.__bloodChanged);
         this._info.addEventListener(LivingEvent.DIE,this.__die);
         this._info.addEventListener(LivingEvent.DIR_CHANGED,this.__dirChanged);
         this._info.addEventListener(LivingEvent.FALL,this.__fall);
         this._info.addEventListener(LivingEvent.FORZEN_CHANGED,this.__forzenChanged);
         this._info.addEventListener(LivingEvent.HIDDEN_CHANGED,this.__hiddenChanged);
         this._info.addEventListener(LivingEvent.PLAY_MOVIE,this.__playMovie);
         this._info.addEventListener(LivingEvent.TURN_ROTATION,this.__turnRotation);
         this._info.addEventListener(LivingEvent.JUMP,this.__jump);
         this._info.addEventListener(LivingEvent.MOVE_TO,this.__moveTo);
         this._info.addEventListener(LivingEvent.MAX_HP_CHANGED,this.__maxHpChanged);
         this._info.addEventListener(LivingEvent.LOCK_STATE,this.__lockStateChanged);
         this._info.addEventListener(LivingEvent.POS_CHANGED,this.__posChanged);
         this._info.addEventListener(LivingEvent.SHOOT,this.__shoot);
         this._info.addEventListener(LivingEvent.PREPARE_SHOOT,this.__prepareShoot);
         this._info.addEventListener(LivingEvent.TRANSMIT,this.__transmit);
         this._info.addEventListener(LivingEvent.SAY,this.__say);
         this._info.addEventListener(LivingEvent.START_MOVING,this.__startMoving);
         this._info.addEventListener(LivingEvent.CHANGE_STATE,this.__changeState);
         this._info.addEventListener(LivingEvent.SHOW_ATTACK_EFFECT,this.__showAttackEffect);
         this._info.addEventListener(LivingEvent.BOMBED,this.__bombed);
         this._info.addEventListener(LivingEvent.PLAYSKILLMOVIE,this.__playSkillMovie);
         this._info.addEventListener(LivingEvent.BUFF_CHANGED,this.__buffChanged);
         this._info.addEventListener(LivingEvent.FIGHTPOWER_CHANGE,this.__fightPowerChanged);
         this._info.addEventListener(LivingEvent.PLAY_CONTINUOUS_EFFECT,this.__playContinuousEffect);
         this._info.addEventListener(LivingEvent.REMOVE_CONTINUOUS_EFFECT,this.__removeContinuousEffect);
         this._info.addEventListener(LivingCommandEvent.COMMAND,this.__onLivingCommand);
         if(this._chatballview)
         {
            this._chatballview.addEventListener(Event.COMPLETE,this.onChatBallComplete);
         }
      }
      
      protected function __removeContinuousEffect(param1:LivingEvent) : void
      {
         this.removeBuffEffect(int(param1.paras[0]));
      }
      
      protected function __playContinuousEffect(param1:LivingEvent) : void
      {
         this.showBuffEffect(param1.paras[0],int(param1.paras[1]));
      }
      
      private function __buffChanged(param1:LivingEvent) : void
      {
         if(param1.paras[0] == BuffType.Turn && this._info && this._info.isLiving)
         {
            this._buffBar.update(this._info.turnBuffs);
            if(this._info.turnBuffs.length > 0)
            {
               this._buffBar.x = 5 - this._buffBar.width / 2;
               this._buffBar.y = this.bodyHeight * -1 - 23;
               addChild(this._buffBar);
            }
            else if(this._buffBar.parent)
            {
               this._buffBar.parent.removeChild(this._buffBar);
            }
         }
      }
      
      protected function __removeSkillMovie(param1:LivingEvent) : void
      {
      }
      
      protected function __applySkill(param1:LivingEvent) : void
      {
      }
      
      protected function __playSkillMovie(param1:LivingEvent) : void
      {
         this.showEffect(param1.paras[0]);
      }
      
      protected function __skillMovieComplete(param1:Event) : void
      {
         var _loc2_:MovieClipWrapper = param1.currentTarget as MovieClipWrapper;
         _loc2_.removeEventListener(Event.COMPLETE,this.__skillMovieComplete);
      }
      
      protected function __bombed(param1:LivingEvent) : void
      {
      }
      
      protected function removeListener() : void
      {
         if(this._info)
         {
            this._info.removeEventListener(LivingEvent.BEAT,this.__beat);
            this._info.removeEventListener(LivingEvent.BEGIN_NEW_TURN,this.__beginNewTurn);
            this._info.removeEventListener(LivingEvent.BLOOD_CHANGED,this.__bloodChanged);
            this._info.removeEventListener(LivingEvent.DIE,this.__die);
            this._info.removeEventListener(LivingEvent.DIR_CHANGED,this.__dirChanged);
            this._info.removeEventListener(LivingEvent.FALL,this.__fall);
            this._info.removeEventListener(LivingEvent.FORZEN_CHANGED,this.__forzenChanged);
            this._info.removeEventListener(LivingEvent.HIDDEN_CHANGED,this.__hiddenChanged);
            this._info.removeEventListener(LivingEvent.PLAY_MOVIE,this.__playMovie);
            this._info.removeEventListener(LivingEvent.TURN_ROTATION,this.__turnRotation);
            this._info.removeEventListener(LivingEvent.PLAYSKILLMOVIE,this.__playSkillMovie);
            this._info.removeEventListener(LivingEvent.REMOVESKILLMOVIE,this.__removeSkillMovie);
            this._info.removeEventListener(LivingEvent.JUMP,this.__jump);
            this._info.removeEventListener(LivingEvent.MOVE_TO,this.__moveTo);
            this._info.removeEventListener(LivingEvent.LOCK_STATE,this.__lockStateChanged);
            this._info.removeEventListener(LivingEvent.POS_CHANGED,this.__posChanged);
            this._info.removeEventListener(LivingEvent.SHOOT,this.__shoot);
            this._info.removeEventListener(LivingEvent.PREPARE_SHOOT,this.__prepareShoot);
            this._info.removeEventListener(LivingEvent.TRANSMIT,this.__transmit);
            this._info.removeEventListener(LivingEvent.SAY,this.__say);
            this._info.removeEventListener(LivingEvent.START_MOVING,this.__startMoving);
            this._info.removeEventListener(LivingEvent.CHANGE_STATE,this.__changeState);
            this._info.removeEventListener(LivingEvent.SHOW_ATTACK_EFFECT,this.__showAttackEffect);
            this._info.removeEventListener(LivingEvent.BOMBED,this.__bombed);
            this._info.removeEventListener(LivingEvent.APPLY_SKILL,this.__applySkill);
            this._info.removeEventListener(LivingEvent.BUFF_CHANGED,this.__buffChanged);
            this._info.removeEventListener(LivingEvent.FIGHTPOWER_CHANGE,this.__fightPowerChanged);
            this._info.removeEventListener(LivingEvent.MAX_HP_CHANGED,this.__maxHpChanged);
            this._info.removeEventListener(LivingEvent.PLAY_CONTINUOUS_EFFECT,this.__playContinuousEffect);
            this._info.removeEventListener(LivingEvent.REMOVE_CONTINUOUS_EFFECT,this.__removeContinuousEffect);
            this._info.removeEventListener(LivingCommandEvent.COMMAND,this.__onLivingCommand);
         }
         if(this._chatballview)
         {
            this._chatballview.removeEventListener(Event.COMPLETE,this.onChatBallComplete);
         }
         this.removeActionEvent();
      }
      
      protected function __shockMap(param1:ActionEvent) : void
      {
         if(this.map)
         {
            this.map.animateSet.addAnimation(new ShockMapAnimation(this,param1.param as int,20));
         }
      }
      
      protected function __shockMap2(param1:Event) : void
      {
         if(this.map)
         {
            this.map.animateSet.addAnimation(new ShockMapAnimation(this,30,20));
         }
      }
      
      protected function __renew(param1:Event) : void
      {
         this._info.showAttackEffect(2);
      }
      
      protected function __startBlank(param1:Event) : void
      {
         addEventListener(Event.ENTER_FRAME,this.drawBlank);
      }
      
      protected function drawBlank(param1:Event) : void
      {
         if(this.counter <= 15)
         {
            graphics.clear();
            this.ap = 1 / 225 * (this.counter * this.counter);
            graphics.beginFill(16777215,this.ap);
            graphics.drawRect(-3000,-1800,7000,4200);
         }
         else if(this.counter <= 23)
         {
            graphics.clear();
            this.ap = 1;
            graphics.beginFill(16777215,this.ap);
            graphics.drawRect(-3000,-1800,7000,4200);
         }
         else if(this.counter <= 75)
         {
            graphics.clear();
            this.ap -= 0.02;
            graphics.beginFill(16777215,this.ap);
            graphics.drawRect(-3000,-1800,7000,4200);
         }
         else
         {
            graphics.clear();
            removeEventListener(Event.ENTER_FRAME,this.drawBlank);
         }
         ++this.counter;
      }
      
      protected function __showDefence(param1:Event) : void
      {
         var _loc2_:ShowEffect = new ShowEffect(ShowEffect.GUARD);
         _loc2_.x = this.x + this.offset();
         _loc2_.y = this.y - 50 + this.offset(25);
         _map.addChild(_loc2_);
      }
      
      protected function __addEffectHandler(param1:DictionaryEvent) : void
      {
         var _loc2_:BaseMirariEffectIcon = param1.data as BaseMirariEffectIcon;
         this.EffectIcon.handleEffect(_loc2_.mirariType,_loc2_.getEffectIcon());
      }
      
      protected function __removeEffectHandler(param1:DictionaryEvent) : void
      {
         var _loc2_:BaseMirariEffectIcon = param1.data as BaseMirariEffectIcon;
         this.EffectIcon.removeEffect(_loc2_.mirariType);
      }
      
      protected function __clearEffectHandler(param1:DictionaryEvent) : void
      {
         this.EffectIcon.clearEffectIcon();
      }
      
      protected function __sizeChangeHandler(param1:Event) : void
      {
         this.EffectIcon.x = 5 - this.EffectIcon.width / 2;
         this.EffectIcon.y = this.bodyHeight * -1 - this.EffectIcon.height;
      }
      
      protected function __changeState(param1:LivingEvent) : void
      {
      }
      
      protected function initMovie() : void
      {
         var _loc1_:Class = null;
         if(ModuleLoader.hasDefinition(this.info.actionMovieName))
         {
            _loc1_ = ModuleLoader.getDefinition(this.info.actionMovieName) as Class;
            if(this._actionMovie)
            {
               this.removeActionEvent();
               this._actionMovie.dispose();
               this._actionMovie = null;
            }
            this._actionMovie = new _loc1_();
            this.initActionEvent();
            this._info.actionMovieBitmap = new Bitmap(this.getBodyBitmapData("show2"));
            this._info.thumbnail = this.getBodyBitmapData("show");
            this._actionMovie.mouseEnabled = false;
            this._actionMovie.mouseChildren = false;
            this._actionMovie.scrollRect = null;
            addChild(this._actionMovie);
            this._actionMovie.gotoAndStop(1);
            this._actionMovie.scaleX = -this._info.direction;
         }
         else
         {
            this._actionMovie = ClassUtils.CreatInstance("asset.game.defaultImage") as ActionMovie;
            this._actionMovie.mouseEnabled = false;
            this._actionMovie.mouseChildren = false;
            this._actionMovie.scrollRect = null;
            addChild(this._actionMovie);
            this._timer = new Timer(500);
            this._timer.addEventListener(TimerEvent.TIMER,this.__checkActionIsReady);
            this._timer.start();
         }
         this.initChatball();
      }
      
      protected function __checkActionIsReady(param1:TimerEvent) : void
      {
         if(ModuleLoader.hasDefinition(this.info.actionMovieName))
         {
            if(this._timer)
            {
               this._timer.removeEventListener(TimerEvent.TIMER,this.__checkActionIsReady);
               this._timer.stop();
               this._timer = null;
            }
            this.initMovie();
            dispatchEvent(new LivingEvent(LivingEvent.LIVING_READY));
         }
      }
      
      private function initActionEvent() : void
      {
         this._actionMovie.addEventListener("renew",this.__renew);
         this._actionMovie.addEventListener(SHOCK_EVENT2,this.__shockMap2);
         this._actionMovie.addEventListener(SHOCK_EVENT,this.__shockMap);
         this._actionMovie.addEventListener(NEED_FOCUS,this.__needFocus);
         this._actionMovie.addEventListener(SHIELD,this.__showDefence);
         this._actionMovie.addEventListener(ATTACK_COMPLETE_FOCUS,this.__attackCompleteFocus);
         this._actionMovie.addEventListener(BOMB_EVENT,this.__startBlank);
         this._actionMovie.addEventListener(PLAY_EFFECT,this.__playEffect);
         this._actionMovie.addEventListener(PLAYER_EFFECT,this.__playerEffect);
      }
      
      private function removeActionEvent() : void
      {
         if(this._actionMovie)
         {
            this._actionMovie.removeEventListener("renew",this.__renew);
            this._actionMovie.removeEventListener(SHOCK_EVENT2,this.__shockMap2);
            this._actionMovie.removeEventListener(SHOCK_EVENT,this.__shockMap);
            this._actionMovie.removeEventListener(NEED_FOCUS,this.__needFocus);
            this._actionMovie.removeEventListener(SHIELD,this.__showDefence);
            this._actionMovie.removeEventListener(BOMB_EVENT,this.__startBlank);
            this._actionMovie.removeEventListener(PLAY_EFFECT,this.__playEffect);
            this._actionMovie.removeEventListener(PLAYER_EFFECT,this.__playerEffect);
         }
      }
      
      protected function initChatball() : void
      {
         this._chatballview = new ChatBallPlayer();
         this._originalHeight = this._actionMovie.height;
         this._originalWidth = this._actionMovie.width;
         addChild(this._chatballview);
      }
      
      protected function __startMoving(param1:LivingEvent) : void
      {
         var _loc2_:Point = _map.findYLineNotEmptyPointDown(this.x,this.y,_map.height);
         if(_loc2_ == null)
         {
            _loc2_ = new Point(this.x,_map.height + 1);
         }
         this._info.fallTo(_loc2_,20);
      }
      
      protected function __say(param1:LivingEvent) : void
      {
         if(this._info.isHidden)
         {
            return;
         }
         this._chatballview.x = 0;
         this._chatballview.y = 0;
         addChild(this._chatballview);
         var _loc2_:String = param1.paras[0] as String;
         var _loc3_:int = 0;
         if(param1.paras[1])
         {
            _loc3_ = param1.paras[1];
         }
         this._chatballview.setText(_loc2_,_loc3_);
         this.fitChatBallPos();
      }
      
      protected function fitChatBallPos() : void
      {
         this._chatballview.x = this.popPos.x;
         this._chatballview.y = this.popPos.y;
         this._chatballview.directionX = this.movie.scaleX;
         if(this.popDir)
         {
            this._chatballview.directionY = this.popDir.y - this._chatballview.y;
         }
      }
      
      protected function get popPos() : Point
      {
         var _loc1_:Point = null;
         if(this.movie["popupPos"])
         {
            _loc1_ = new Point(this.movie["popupPos"].x,this.movie["popupPos"].y);
         }
         else
         {
            _loc1_ = new Point(-(this.movie.width * 0.4) * this.movie.scaleX,-(this.movie.height * 0.8) * this.movie.scaleY);
         }
         return _loc1_;
      }
      
      protected function get popDir() : Point
      {
         if(this.movie["popupDir"])
         {
            return new Point(this.movie["popupDir"].x,this.movie["popupDir"].y);
         }
         return this.popPos;
      }
      
      override public function collidedByObject(param1:PhysicalObj) : void
      {
      }
      
      protected function __beat(param1:LivingEvent) : void
      {
         if(_isLiving)
         {
            this.targetAttackEffect = param1.paras[0][0].attackEffect;
            this._actionMovie.doAction(param1.paras[0][0].action,this.updateTargetsBlood,param1.paras);
         }
      }
      
      protected function updateTargetsBlood(param1:Array) : void
      {
         var _loc4_:Living = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] && param1[_loc3_].target && param1[_loc3_].target.isLiving)
            {
               _loc4_ = param1[_loc3_].target;
               _loc4_.isHidden = false;
               _loc4_.showAttackEffect(param1[_loc3_].attackEffect);
               _loc4_.updateBlood(param1[_loc3_].targetBlood,3,param1[_loc3_].damage);
               if(!_loc2_)
               {
                  if(GameManager.Instance.Current.self.LivingID == _loc4_.LivingID)
                  {
                     this.map.setCenter(_loc4_.pos.x,_loc4_.pos.y - 150,true,AnimationLevel.MIDDLE,_loc4_.LivingID);
                  }
               }
               if(_loc4_.isSelf)
               {
                  _loc2_ = true;
               }
            }
            _loc3_++;
         }
      }
      
      protected function __beginNewTurn(param1:LivingEvent) : void
      {
      }
      
      protected function __playMovie(param1:LivingEvent) : void
      {
         this.doAction(param1.paras[0]);
      }
      
      protected function __turnRotation(param1:LivingEvent) : void
      {
         this.act(new LivingTurnAction(this,param1.paras[0],param1.paras[1],param1.paras[2]));
      }
      
      protected function __bloodChanged(param1:LivingEvent) : void
      {
         var _loc3_:ShootPercentView = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Point = null;
         if(!this.isExist || !_map)
         {
            return;
         }
         var _loc2_:Number = param1.value - param1.old;
         var _loc6_:int = param1.paras[0];
         var _loc7_:Boolean = this.info.isSelf;
         var _loc8_:ShootPercentView = GameManager.Instance.petReduceList.pop();
         if(_loc8_)
         {
            _loc8_.play();
         }
         switch(_loc6_)
         {
            case 0:
               _loc2_ = param1.paras[1];
               if(_loc2_ != 0 && this._info.blood != 0)
               {
                  _loc3_ = new ShootPercentView(Math.abs(_loc2_),1,true,_loc7_);
                  _loc3_.x = this.x - 20;
                  _loc3_.y = this.y - 50 + this.offset(25);
                  _loc3_.scaleX = _loc3_.scaleY = 0.8 + Math.random() * 0.4;
                  _map.addToPhyLayer(_loc3_);
                  if(this._info.isHidden)
                  {
                     if(this._info.team == GameManager.Instance.Current.selfGamePlayer.team)
                     {
                        _loc3_.alpha == 0.5;
                     }
                     else
                     {
                        this.visible = false;
                        _loc3_.alpha = 0;
                     }
                  }
               }
               break;
            case 90:
               _loc3_ = new ShootPercentView(0,2,false,_loc7_);
               _loc3_.x = this.x + this.offset();
               _loc3_.y = this.y - 50 + this.offset(25);
               _loc3_.scaleX = _loc3_.scaleY = 0.8 + Math.random() * 0.4;
               _map.addToPhyLayer(_loc3_);
               break;
            case 5:
               break;
            case 3:
               _loc5_ = param1.paras[1];
               _loc2_ = _loc5_;
               if(_loc2_ != 0)
               {
                  _loc3_ = new ShootPercentView(Math.abs(_loc2_),1,false,_loc7_);
                  _loc3_.x = this.x + 50 + this.offset(10);
                  _loc3_.y = this.y - 50 + this.offset(25);
                  _loc3_.scaleX = _loc3_.scaleY = 0.8 + Math.random() * 0.4;
                  _map.addToPhyLayer(_loc3_);
               }
               break;
            case 11:
               _loc5_ = param1.paras[1];
               if(_loc5_ < 0)
               {
                  _loc2_ = _loc5_;
               }
               if(_loc2_ != 0)
               {
                  _loc3_ = new ShootPercentView(Math.abs(_loc2_),param1.paras[0],false,_loc7_);
                  _loc3_.x = this.x + this.offset();
                  _loc3_.y = this.y - 50 + this.offset(25);
                  _loc3_.scaleX = _loc3_.scaleY = 0.8 + Math.random() * 0.4;
                  _map.addToPhyLayer(_loc3_);
               }
               break;
            default:
               _loc5_ = param1.paras[1];
               if(_loc5_ < 0)
               {
                  _loc2_ = _loc5_;
               }
               if(_loc2_ != 0)
               {
                  if(!(GameManager.Instance.isDieFight && this._info.isHidden))
                  {
                     _loc3_ = new ShootPercentView(Math.abs(_loc2_),param1.paras[0],false,_loc7_);
                     _loc3_.x = this.x + this.offset();
                     _loc3_.y = this.y - 50 + this.offset(25);
                     _loc3_.scaleX = _loc3_.scaleY = 0.8 + Math.random() * 0.4;
                     _map.addToPhyLayer(_loc3_);
                  }
               }
         }
         if(_loc3_)
         {
            _loc10_ = _map.localToGlobal(new Point(_loc3_.x,_loc3_.y));
            if(_loc10_.x > 900)
            {
               _loc9_ = 1;
            }
            else if(_loc10_.x < 100)
            {
               _loc9_ = 2;
            }
            else
            {
               _loc9_ = 0;
            }
            _loc3_.play(_loc9_);
         }
         this.updateBloodStrip();
      }
      
      protected function __maxHpChanged(param1:LivingEvent) : void
      {
         this.updateBloodStrip();
      }
      
      protected function updateBloodStrip() : void
      {
         if(this.info.blood < 0)
         {
            this._HPStrip.width = 0;
         }
         else
         {
            this._HPStrip.width = Math.floor(this._bloodWidth / this.info.maxBlood * this.info.blood);
         }
      }
      
      public function offset(param1:int = 30) : int
      {
         var _loc2_:int = int(Math.random() * 10);
         if(_loc2_ % 2 == 0)
         {
            return -int(Math.random() * param1);
         }
         return int(Math.random() * param1);
      }
      
      protected function __die(param1:LivingEvent) : void
      {
         if(_isLiving)
         {
            this._info.MirariEffects.removeEventListener(DictionaryEvent.ADD,this.__addEffectHandler);
            this._info.MirariEffects.removeEventListener(DictionaryEvent.REMOVE,this.__removeEffectHandler);
            this._info.MirariEffects.removeEventListener(DictionaryEvent.CLEAR,this.__clearEffectHandler);
            _isLiving = false;
            this.die();
         }
         this._doDieAction = param1.paras[0];
         if(GameManager.Instance.dropTaskGoodsId >= 0 && !DialogManager.Instance.getDropPoint(GameManager.Instance.dialogId))
         {
            if(this.info.LivingID == GameManager.Instance.dropTaskGoodsNpcId)
            {
               if(DialogManager.Instance.hasDialogs(GameManager.Instance.dialogId))
               {
                  if(DialogManager.Instance.dropGoodsBeforeDialog(GameManager.Instance.dialogId))
                  {
                     this.doDieAction();
                     this._timeoutMark1 = setTimeout(this.dropGoods,500);
                  }
                  else
                  {
                     this.showDialog(GameManager.Instance.dialogId);
                  }
               }
               else
               {
                  this.doDieAction();
                  this._timeoutMark1 = setTimeout(this.dropGoods,500);
               }
            }
         }
         else
         {
            this.doDieAction();
         }
      }
      
      override public function die() : void
      {
         this.info.isFrozen = false;
         this.info.isNoNole = false;
         this.info.isHidden = false;
         if(this._bloodStripBg && this._bloodStripBg.parent)
         {
            this._bloodStripBg.parent.removeChild(this._bloodStripBg);
         }
         if(this._HPStrip && this._HPStrip.parent)
         {
            this._HPStrip.parent.removeChild(this._HPStrip);
         }
         if(this._buffBar)
         {
            this._buffBar.dispose();
         }
         this._buffBar = null;
         this.removeAllPetBuffEffects();
      }
      
      protected function doDieAction() : void
      {
      }
      
      private function showDialog(param1:uint, param2:Function = null) : void
      {
         LayerManager.Instance.addToLayer(DialogManager.Instance.DialogBox,LayerManager.STAGE_TOP_LAYER);
         DialogManager.Instance.addEventListener(Event.COMPLETE,this.__dialogEndCallBack);
         DialogManager.Instance.showDialog(param1,2500,false,false,true,8);
      }
      
      private function __dialogEndCallBack(param1:Event) : void
      {
         DialogManager.Instance.removeEventListener(Event.COMPLETE,this.__dialogEndCallBack);
         ChatManager.Instance.chatDisabled = false;
         var _loc2_:Boolean = DialogManager.Instance.dropGoodsBeforeDialog(GameManager.Instance.dialogId);
         GameManager.Instance.dialogId = -1;
         if(GameManager.Instance.dropTaskGoodsId >= 0)
         {
            this.doDieAction();
            this._timeoutMark1 = setTimeout(this.dropGoods,500);
         }
      }
      
      private function tweenTaskGoods(param1:MovieClip, param2:Point) : void
      {
         this._dropGoodsTween = null;
         SoundManager.instance.play("204");
         this._dropGoodsTween = TweenLite.to(param1,0.7,{
            "x":param2.x,
            "y":param2.y,
            "scaleX":0.5,
            "scaleY":0.5,
            "onComplete":this.__onFinishTween,
            "onCompleteParams":[param1]
         });
      }
      
      private function __onFinishTween(param1:MovieClip) : void
      {
         var _loc2_:Point = null;
         if(param1)
         {
            if(param1.parent)
            {
               param1.parent.removeChild(param1);
            }
            param1 = null;
         }
         if(!(RoomManager.Instance.current && RoomManager.Instance.current.type == RoomInfo.SINGLE_DUNGEON))
         {
            return;
         }
         switch(GameManager.Instance.dropTaskGoodsId)
         {
            case GameManager.TASK_GOOD_THREE:
               this._iconWrapper = new MovieClipWrapper(ClassUtils.CreatInstance("asset.trainer7.getThreeIcon"),true,true);
               _loc2_ = ComponentFactory.Instance.creatCustomObject("trainer.explain.posGetThreeIcon");
               GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.GET_THREE_ICON));
               break;
            case GameManager.TASK_GOOD_ADDONE:
               this._iconWrapper = new MovieClipWrapper(ClassUtils.CreatInstance("asset.trainer8.getAddOneIcon"),true,true);
               _loc2_ = ComponentFactory.Instance.creatCustomObject("trainer.explain.posGetAddOneIcon");
               GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.GET_ADDONE_ICON));
               break;
            case GameManager.TASK_GOOD_POWMAX:
               this._iconWrapper = new MovieClipWrapper(ClassUtils.CreatInstance("asset.trainer10.getPowMaxIcon"),true,true);
               _loc2_ = ComponentFactory.Instance.creatCustomObject("trainer.explain.posGetPowMaxIcon");
               GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.GET_POWMAX_ICON));
               break;
            case GameManager.TASK_GOOD_ADDTWO:
               this._iconWrapper = new MovieClipWrapper(ClassUtils.CreatInstance("asset.trainer9.getAddTwoIcon"),true,true);
               _loc2_ = ComponentFactory.Instance.creatCustomObject("trainer.explain.posGetAddTwoIcon");
               GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.GET_ADDTWO_ICON));
         }
         this._iconWrapper.movie.x = _loc2_.x;
         this._iconWrapper.movie.y = _loc2_.y;
         SoundManager.instance.play("205");
         LayerManager.Instance.addToLayer(this._iconWrapper.movie,LayerManager.GAME_UI_LAYER,false);
         GameManager.Instance.dropTaskGoodsId = -1;
         GameManager.Instance.dropTaskGoodsNpcId = -1;
         GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.LOCK_SCREEN,false));
         if(GameManager.Instance.dialogId > 0)
         {
            if(DialogManager.Instance.hasDialogs(GameManager.Instance.dialogId))
            {
               this._timeoutMark1 = setTimeout(this.showDialog,1000,GameManager.Instance.dialogId);
            }
         }
      }
      
      private function dropGoods() : void
      {
         var _loc1_:Point = null;
         var _loc2_:String = null;
         GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.LOCK_SCREEN,true));
         switch(GameManager.Instance.dropTaskGoodsId)
         {
            case GameManager.TASK_GOOD_THREE:
               this._goodsMovie = ComponentFactory.Instance.creat("asset.trainer7.getThree");
               _loc2_ = "trainer.explain.posGetThree";
               break;
            case GameManager.TASK_GOOD_ADDONE:
               this._goodsMovie = ComponentFactory.Instance.creat("asset.trainer8.getAddOne");
               _loc2_ = "trainer.explain.posGetAddOne";
               break;
            case GameManager.TASK_GOOD_POWMAX:
               this._goodsMovie = ComponentFactory.Instance.creat("asset.trainer10.getPowMax");
               _loc2_ = "trainer.explain.posGetPowMax";
               break;
            case GameManager.TASK_GOOD_ADDTWO:
               this._goodsMovie = ComponentFactory.Instance.creat("asset.trainer9.getAddTwo");
               _loc2_ = "trainer.explain.posGetAddTwo";
         }
         _loc1_ = this.map.localToGlobal(this.info.pos);
         this._goodsMovie.x = _loc1_.x;
         this._goodsMovie.y = _loc1_.y;
         SoundManager.instance.play("203");
         LayerManager.Instance.addToLayer(this._goodsMovie,LayerManager.GAME_UI_LAYER);
         var _loc3_:Point = ComponentFactory.Instance.creatCustomObject(_loc2_);
         this._timeoutMark2 = setTimeout(this.tweenTaskGoods,4200,this._goodsMovie,_loc3_);
      }
      
      protected function __dirChanged(param1:LivingEvent) : void
      {
         if(this._info.direction > 0)
         {
            this.movie.scaleX = -1;
         }
         else
         {
            this.movie.scaleX = 1;
         }
      }
      
      protected function __forzenChanged(param1:LivingEvent) : void
      {
         if(this._info.isFrozen)
         {
            this.effectForzen = ClassUtils.CreatInstance("asset.gameFrostEffectAsset") as MovieClip;
            this.effectForzen.y = 24;
            addChild(this.effectForzen);
         }
         else if(this.effectForzen)
         {
            removeChild(this.effectForzen);
            this.effectForzen = null;
         }
      }
      
      protected function __lockStateChanged(param1:LivingEvent) : void
      {
         if(this._info.LockState)
         {
            this.lock = ClassUtils.CreatInstance("asset.gameII.LockAsset") as MovieClip;
            this.lock.x = 10;
            this.lock.y = 5;
            addChild(this.lock);
            if(param1.paras[0] == 2)
            {
               this.lock.y += 50;
               this.lock.scaleX = this.lock.scaleY = 0.8;
               this.lock.stop();
               this.lock.alpha = 0.7;
            }
         }
         else if(this.lock)
         {
            removeChild(this.lock);
            this.lock = null;
         }
      }
      
      protected function __hiddenChanged(param1:LivingEvent) : void
      {
         if(this._info.isHidden)
         {
            if(this._info.team != GameManager.Instance.Current.selfGamePlayer.team)
            {
               this.visible = false;
               if(this._smallView)
               {
                  this._smallView.visible = false;
                  this._smallView.alpha = 0;
               }
               alpha = 0;
            }
            else
            {
               alpha = 0.5;
               if(this._smallView)
               {
                  this._smallView.alpha = 0.5;
               }
            }
         }
         else
         {
            alpha = 1;
            this.visible = true;
            if(this._smallView)
            {
               this._smallView.visible = true;
               this._smallView.alpha = 1;
            }
            parent.addChild(this);
         }
      }
      
      protected function __posChanged(param1:LivingEvent) : void
      {
         var _loc2_:Number = NaN;
         pos = this._info.pos;
         if(_isLiving)
         {
            _loc2_ = calcObjectAngle(16);
            this._info.playerAngle = _loc2_;
         }
         if(this.map)
         {
            this.map.smallMap.updatePos(this.smallView,pos);
         }
      }
      
      protected function __jump(param1:LivingEvent) : void
      {
         this.doAction(param1.paras[2]);
         this.act(new LivingJumpAction(this,param1.paras[0],param1.paras[1],param1.paras[3]));
      }
      
      protected function __moveTo(param1:LivingEvent) : void
      {
         var _loc13_:Point = null;
         var _loc2_:String = param1.paras[4];
         this.doAction(_loc2_);
         var _loc3_:int = param1.paras[5];
         if(_loc3_ == 0)
         {
            _loc3_ = 7;
         }
         var _loc4_:Point = param1.paras[1] as Point;
         var _loc5_:int = param1.paras[2];
         var _loc6_:String = param1.paras[6];
         if(this.x == _loc4_.x && this.y == _loc4_.y)
         {
            return;
         }
         var _loc7_:Array = [];
         var _loc8_:int = this.x;
         var _loc9_:int = this.y;
         var _loc10_:Point = new Point(this.x,this.y);
         var _loc11_:int = _loc4_.x > _loc8_ ? int(1) : int(-1);
         var _loc12_:Point = new Point(this.x,this.y);
         if(_loc2_.substr(0,3) == "fly")
         {
            _loc13_ = new Point(_loc4_.x - _loc12_.x,_loc4_.y - _loc12_.y);
            while(_loc13_.length > _loc3_)
            {
               _loc13_.normalize(_loc3_);
               _loc12_ = new Point(_loc12_.x + _loc13_.x,_loc12_.y + _loc13_.y);
               _loc13_ = new Point(_loc4_.x - _loc12_.x,_loc4_.y - _loc12_.y);
               if(!_loc12_)
               {
                  _loc7_.push(_loc4_);
               }
               _loc7_.push(_loc12_);
            }
         }
         else
         {
            while((_loc4_.x - _loc8_) * _loc11_ > 0)
            {
               _loc12_ = _map.findNextWalkPoint(_loc8_,_loc9_,_loc11_,_loc3_ * npcStepX,_loc3_ * npcStepY);
               if(!_loc12_)
               {
                  break;
               }
               _loc7_.push(_loc12_);
               _loc8_ = _loc12_.x;
               _loc9_ = _loc12_.y;
            }
         }
         if(_loc7_.length > 0)
         {
            this._info.act(new LivingMoveAction(this,_loc7_,_loc5_,_loc6_));
         }
         else if(_loc6_ != "")
         {
            this.doAction(_loc6_);
         }
         else
         {
            this._info.doDefaultAction();
         }
      }
      
      public function canMoveDirection(param1:Number) : Boolean
      {
         return !this.map.IsOutMap(this.x + (15 + this.stepX) * param1,this.y);
      }
      
      public function canStand(param1:int, param2:int) : Boolean
      {
         return !this.map.IsEmpty(param1 - 1,param2) || !this.map.IsEmpty(param1 + 1,param2);
      }
      
      public function getNextWalkPoint(param1:int) : Point
      {
         if(this.canMoveDirection(param1))
         {
            return _map.findNextWalkPoint(this.x,this.y,param1,this.stepX,this.stepY);
         }
         return null;
      }
      
      private function __needFocus(param1:ActionMovieEvent) : void
      {
         if(param1.data)
         {
            this.needFocus(param1.data.x,param1.data.y,param1.data,param1.data.strategy != null);
         }
      }
      
      protected function __playEffect(param1:ActionMovieEvent) : void
      {
      }
      
      protected function __playerEffect(param1:ActionMovieEvent) : void
      {
      }
      
      public function needFocus(param1:int = 0, param2:int = 0, param3:Object = null, param4:Boolean = false) : void
      {
         this.map.livingSetCenter(this.x + param1,this.y + param2 - 150,param4,AnimationLevel.HIGHT,this._info.LivingID,param3);
      }
      
      public function followFocus(param1:int = 0, param2:int = 0, param3:Object = null, param4:Boolean = false) : void
      {
         this.map.livingSetCenter(this.x + param1,this.y + param2 - 150,param4,AnimationLevel.HIGHT,this._info.LivingID,param3);
      }
      
      private function __attackCompleteFocus(param1:ActionMovieEvent) : void
      {
         this.map.setSelfCenter(true,2,param1.data);
      }
      
      protected function __shoot(param1:LivingEvent) : void
      {
      }
      
      protected function __prepareShoot(param1:LivingEvent) : void
      {
      }
      
      protected function __transmit(param1:LivingEvent) : void
      {
         this.info.pos = param1.paras[0];
      }
      
      protected function __fall(param1:LivingEvent) : void
      {
         this._info.act(new LivingFallingAction(this,param1.paras[0],param1.paras[1],param1.paras[3]));
      }
      
      public function get actionMovie() : ActionMovie
      {
         return this._actionMovie;
      }
      
      public function get movie() : Sprite
      {
         return this._actionMovie;
      }
      
      public function doAction(param1:*) : void
      {
         if(this._actionMovie != null)
         {
            this._actionMovie.doAction(param1);
         }
      }
      
      public function showEffect(param1:String) : void
      {
         var _loc2_:AutoDisappear = null;
         if(param1 && ModuleLoader.hasDefinition(param1))
         {
            _loc2_ = new AutoDisappear(ClassUtils.CreatInstance(param1));
            addChild(_loc2_);
         }
      }
      
      public function showBuffEffect(param1:String, param2:int) : void
      {
         var _loc3_:DisplayObject = null;
         if(param1 && ModuleLoader.hasDefinition(param1))
         {
            if(!this._buffEffect)
            {
               return;
            }
            if(this._buffEffect && this._buffEffect.hasKey(param2))
            {
               this.removeBuffEffect(param2);
            }
            _loc3_ = ClassUtils.CreatInstance(param1) as DisplayObject;
            addChild(_loc3_);
            this._buffEffect.add(param2,_loc3_);
         }
      }
      
      public function removeBuffEffect(param1:int) : void
      {
         var _loc2_:DisplayObject = null;
         if(this._buffEffect && this._buffEffect.hasKey(param1))
         {
            _loc2_ = this._buffEffect[param1] as DisplayObject;
            if(_loc2_ && _loc2_.parent)
            {
               removeChild(_loc2_);
            }
            this._buffEffect.remove(param1);
         }
      }
      
      public function act(param1:BaseAction) : void
      {
         this._info.act(param1);
      }
      
      public function traceCurrentAction() : void
      {
         this._info.traceCurrentAction();
      }
      
      override public function update(param1:Number) : void
      {
         if(this._isDie)
         {
            return;
         }
         super.update(param1);
         this._info.update();
      }
      
      private function getBodyBitmapData(param1:String = "") : BitmapData
      {
         var _loc2_:Number = this._actionMovie.width;
         var _loc3_:Sprite = new Sprite();
         this.bodyWidth = this._actionMovie.width;
         this.bodyHeight = this._actionMovie.height;
         this._actionMovie.gotoAndStop(param1);
         var _loc4_:Boolean = false;
         if(LeftPlayerCartoonView.SHOW_BITMAP_WIDTH < this._actionMovie.width)
         {
            this._actionMovie.width = LeftPlayerCartoonView.SHOW_BITMAP_WIDTH;
            this._actionMovie.scaleY = this._actionMovie.scaleX;
            _loc4_ = true;
         }
         _loc3_.addChild(this._actionMovie);
         var _loc5_:Rectangle = this._actionMovie.getBounds(this._actionMovie);
         this._actionMovie.x = -_loc5_.x * this._actionMovie.scaleX;
         this._actionMovie.y = -_loc5_.y * this._actionMovie.scaleX;
         var _loc6_:BitmapData = new BitmapData(_loc3_.width,_loc3_.height,true,0);
         _loc6_.draw(_loc3_);
         if(_loc4_)
         {
            this._actionMovie.width = _loc2_;
            this._actionMovie.scaleY = this._actionMovie.scaleX = 1;
         }
         this._actionMovie.doAction("stand");
         this._actionMovie.x = this._actionMovie.y = 0;
         _loc3_.removeChild(this._actionMovie);
         return _loc6_;
      }
      
      protected function deleteSmallView() : void
      {
         if(this._bloodStripBg)
         {
            if(this._bloodStripBg.parent)
            {
               this._bloodStripBg.parent.removeChild(this._bloodStripBg);
            }
            this._bloodStripBg.bitmapData.dispose();
            this._bloodStripBg = null;
         }
         if(this._HPStrip)
         {
            if(this._HPStrip.parent)
            {
               this._HPStrip.parent.removeChild(this._HPStrip);
            }
            this._HPStrip.dispose();
            this._HPStrip = null;
         }
         if(this._nickName)
         {
            if(this._nickName.parent)
            {
               this._nickName.parent.removeChild(this._nickName);
            }
         }
         if(this._smallView)
         {
            this._smallView.dispose();
            this._smallView.visible = false;
         }
         this._smallView = null;
      }
      
      private function removeAllPetBuffEffects() : void
      {
         var _loc1_:DisplayObject = null;
         if(this._buffEffect)
         {
            for each(_loc1_ in this._buffEffect.list)
            {
               ObjectUtils.disposeObject(_loc1_);
            }
            this._buffEffect = null;
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:Object = null;
         super.dispose();
         this.removeListener();
         if(this._iconWrapper)
         {
            if(this._iconWrapper.movie)
            {
               if(this._iconWrapper.movie.parent)
               {
                  this._iconWrapper.movie.parent.removeChild(this._iconWrapper.movie);
               }
            }
         }
         if(this._timer)
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.__checkActionIsReady);
            this._timer.stop();
            this._timer = null;
         }
         if(GameManager.Instance.isLeaving)
         {
            if(this._dropGoodsTween)
            {
               this._dropGoodsTween.kill();
               this._dropGoodsTween = null;
            }
            if(this._timeoutMark1)
            {
               clearTimeout(this._timeoutMark1);
            }
            if(this._timeoutMark2)
            {
               clearTimeout(this._timeoutMark2);
            }
            if(this._goodsMovie)
            {
               if(this._goodsMovie.parent)
               {
                  this._goodsMovie.parent.removeChild(this._goodsMovie);
               }
               this._goodsMovie = null;
            }
         }
         this._info = null;
         this.deleteSmallView();
         this.removeAllPetBuffEffects();
         if(this._buffBar)
         {
            ObjectUtils.disposeObject(this._buffBar);
            this._buffBar = null;
         }
         if(this._fightPower)
         {
            ObjectUtils.disposeObject(this._fightPower);
         }
         this._fightPower = null;
         if(this._nickName)
         {
            this._nickName.dispose();
         }
         this._nickName = null;
         if(this._chatballview)
         {
            this._chatballview.dispose();
         }
         this._chatballview = null;
         if(this._actionMovie)
         {
            this._actionMovie.dispose();
            this._actionMovie = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
         this.__skillMCdone();
         this.cleanMovies();
         this.isExist = false;
         if(this._propArray)
         {
            for each(_loc1_ in this._propArray)
            {
               ObjectUtils.disposeObject(_loc1_);
            }
         }
         if(this._defautBitmap)
         {
            ObjectUtils.disposeObject(this._defautBitmap);
            this._defautBitmap = null;
         }
         this._propArray = null;
      }
      
      public function get EffectRect() : Rectangle
      {
         return this._effRect;
      }
      
      override public function get smallView() : SmallObject
      {
         return this._smallView;
      }
      
      protected function __showAttackEffect(param1:LivingEvent) : void
      {
         if(this._attackEffectPlaying)
         {
            return;
         }
         if(this._info == null)
         {
            return;
         }
         this._attackEffectPlaying = true;
         var _loc2_:int = param1.paras[0];
         var _loc3_:MovieClip = this.creatAttackEffectAssetByID(_loc2_);
         _loc3_.scaleX = -1 * this._info.direction;
         var _loc4_:MovieClipWrapper = new MovieClipWrapper(_loc3_,true,true);
         _loc4_.addEventListener(Event.COMPLETE,this.__playComplete);
         _loc4_.gotoAndPlay(1);
         this._attackEffectPlayer = new PhysicalObj(-1);
         this._attackEffectPlayer.addChild(_loc4_.movie);
         var _loc5_:Point = _map.globalToLocal(this.movie.localToGlobal(this._attackEffectPos));
         this._attackEffectPlayer.x = _loc5_.x;
         this._attackEffectPlayer.y = _loc5_.y;
         _map.addPhysical(this._attackEffectPlayer);
      }
      
      private function __playComplete(param1:Event) : void
      {
         if(param1.currentTarget)
         {
            param1.currentTarget.removeEventListener(Event.COMPLETE,this.__playComplete);
         }
         if(_map)
         {
            _map.removePhysical(this._attackEffectPlayer);
         }
         if(this._attackEffectPlayer && this._attackEffectPlayer.parent)
         {
            this._attackEffectPlayer.parent.removeChild(this._attackEffectPlayer);
         }
         this._attackEffectPlaying = false;
         this._attackEffectPlayer = null;
      }
      
      protected function hasMovie(param1:String) : Boolean
      {
         return this._moviePool.hasOwnProperty(param1);
      }
      
      protected function creatAttackEffectAssetByID(param1:int) : MovieClip
      {
         var _loc3_:MovieClip = null;
         var _loc2_:String = "asset.game.AttackEffect" + param1;
         if(this.hasMovie(_loc2_))
         {
            return this._moviePool[_loc2_] as MovieClip;
         }
         _loc3_ = ClassUtils.CreatInstance("asset.game.AttackEffect" + param1.toString()) as MovieClip;
         this._moviePool[_loc2_] = _loc3_;
         return _loc3_;
      }
      
      private function cleanMovies() : void
      {
         var _loc1_:* = null;
         var _loc2_:MovieClip = null;
         for(_loc1_ in this._moviePool)
         {
            _loc2_ = this._moviePool[_loc1_];
            _loc2_.stop();
            ObjectUtils.disposeObject(_loc2_);
            delete this._moviePool[_loc1_];
         }
      }
      
      public function showBlood(param1:Boolean) : void
      {
         this._bloodStripBg.visible = this._HPStrip.visible = param1;
         this._nickName.visible = param1;
      }
      
      public function showNpc(param1:Boolean) : void
      {
         if(this._smallView)
         {
            this._smallView.visible = !param1;
         }
      }
      
      override public function setActionMapping(param1:String, param2:String) : void
      {
         this._actionMovie.setActionMapping(param1,param2);
      }
      
      override public function set visible(param1:Boolean) : void
      {
         if(this.hiddenByServer)
         {
            return;
         }
         super.visible = param1;
         if(this._onSmallMap == false)
         {
            return;
         }
      }
      
      private function get hiddenByServer() : Boolean
      {
         return this._hiddenByServer;
      }
      
      private function set hiddenByServer(param1:Boolean) : void
      {
         if(param1)
         {
            super.visible = false;
         }
         else
         {
            super.visible = true;
         }
         this._hiddenByServer = param1;
      }
      
      protected function __onLivingCommand(param1:LivingCommandEvent) : void
      {
         switch(param1.commandType)
         {
            case "focusSelf":
               this.map.setCenter(GameManager.Instance.Current.selfGamePlayer.pos.x,GameManager.Instance.Current.selfGamePlayer.pos.x,false,AnimationLevel.MIDDLE,this._info.LivingID);
               break;
            case "focus":
               this.needFocus(param1.object.x,param1.object.y);
               return;
         }
      }
      
      protected function onChatBallComplete(param1:Event) : void
      {
         if(this._chatballview && this._chatballview.parent)
         {
            this._chatballview.parent.removeChild(this._chatballview);
         }
      }
      
      protected function doUseItemAnimation(param1:Boolean = false) : void
      {
         var _loc2_:MovieClipWrapper = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.ghostPcikPropAsset")),true,true);
         _loc2_.addFrameScriptAt(12,this.headPropEffect);
         SoundManager.instance.play("039");
         _loc2_.movie.x = 0;
         _loc2_.movie.y = -10;
         if(!param1)
         {
            addChild(_loc2_.movie);
         }
      }
      
      protected function headPropEffect() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:AutoPropEffect = null;
         var _loc3_:String = null;
         if(this._propArray && this._propArray.length > 0)
         {
            if(this._propArray[0] is String)
            {
               _loc3_ = this._propArray.shift();
               if(_loc3_ == "-1")
               {
                  _loc1_ = ComponentFactory.Instance.creatBitmap("game.crazyTank.view.specialKillAsset");
               }
               else
               {
                  _loc1_ = PropItemView.createView(_loc3_,60,60);
               }
               _loc2_ = new AutoPropEffect(_loc1_);
               _loc2_.x = -5;
               _loc2_.y = -140;
            }
            else
            {
               _loc1_ = this._propArray.shift() as DisplayObject;
               _loc2_ = new AutoPropEffect(_loc1_);
               _loc2_.x = 5;
               _loc2_.y = -140;
            }
            addChild(_loc2_);
         }
      }
      
      override public function startMoving() : void
      {
         super.startMoving();
         if(this._info)
         {
            this._info.isMoving = true;
         }
      }
      
      override public function stopMoving() : void
      {
         super.stopMoving();
         if(this._info)
         {
            this._info.isMoving = false;
         }
      }
      
      public function setProperty(param1:String, param2:String) : void
      {
         var _loc3_:StringObject = new StringObject(param2);
         switch(param1)
         {
            case "visible":
               this.hiddenByServer = !_loc3_.getBoolean();
               return;
            case "offsetX":
               this._offsetX = _loc3_.getInt();
               this.map.smallMap.updatePos(this._smallView,new Point(this.x,this.y));
               return;
            case "offsetY":
               this._offsetY = _loc3_.getInt();
               this.map.smallMap.updatePos(this._smallView,new Point(this.x,this.y));
               return;
            case "speedX":
               this.speedMult = _loc3_.getInt() / this._speedX;
               break;
            case "speedY":
               this.speedMult = _loc3_.getInt() / this._speedY;
               break;
            case "onSmallMap":
               this.smallView.visible = _loc3_.getBoolean();
               this._onSmallMap = _loc3_.getBoolean();
               if(this._onSmallMap)
               {
                  this._smallView.info = this._info;
               }
               break;
            default:
               this.info.setProperty(param1,param2);
         }
      }
   }
}
