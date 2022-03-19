// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.objects.GameLiving

package game.objects
{
    import phy.object.PhysicalObj;
    import game.model.Living;
    import road.game.resource.ActionMovie;
    import ddt.view.chat.chatBall.ChatBallBase;
    import game.view.smallMap.SmallLiving;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import flash.display.MovieClip;
    import game.view.buff.FightBuffBar;
    import road7th.data.DictionaryData;
    import com.greensock.TweenLite;
    import road7th.utils.MovieClipWrapper;
    import game.view.EffectIconContainer;
    import flash.utils.Timer;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ClassUtils;
    import phy.object.PhysicsLayer;
    import game.view.map.MapView;
    import ddt.manager.LanguageMgr;
    import ddt.events.LivingEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;
    import game.view.smallMap.SmallPlayer;
    import flash.display.DisplayObject;
    import game.view.IDisplayPack;
    import ddt.events.LivingCommandEvent;
    import flash.events.Event;
    import ddt.data.BuffType;
    import game.animations.ShockMapAnimation;
    import tank.events.ActionEvent;
    import game.view.effects.ShowEffect;
    import game.view.effects.BaseMirariEffectIcon;
    import road7th.data.DictionaryEvent;
    import com.pickgliss.loader.ModuleLoader;
    import flash.events.TimerEvent;
    import ddt.view.chat.chatBall.ChatBallPlayer;
    import game.GameManager;
    import game.animations.AnimationLevel;
    import game.actions.LivingTurnAction;
    import game.view.effects.ShootPercentView;
    import ddt.manager.DialogManager;
    import flash.utils.setTimeout;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.ChatManager;
    import room.RoomManager;
    import room.model.RoomInfo;
    import ddt.events.GameEvent;
    import game.actions.LivingJumpAction;
    import game.actions.LivingMoveAction;
    import road.game.resource.ActionMovieEvent;
    import game.actions.LivingFallingAction;
    import road7th.utils.AutoDisappear;
    import game.actions.BaseAction;
    import game.view.LeftPlayerCartoonView;
    import flash.display.BitmapData;
    import flash.utils.clearTimeout;
    import phy.object.SmallObject;
    import game.view.AutoPropEffect;
    import ddt.view.PropItemView;
    import road7th.data.StringObject;

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
        private var _buffEffect:DictionaryData = new DictionaryData();
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
        protected var _attackEffectPos:Point = new Point(0, 5);
        protected var _moviePool:Object = new Object();
        private var _hiddenByServer:Boolean;
        protected var _propArray:Array;
        private var _onSmallMap:Boolean = true;

        public function GameLiving(_arg_1:Living)
        {
            this._info = _arg_1;
            this.initView();
            this.initListener();
            var _local_2:Point = ComponentFactory.Instance.creatCustomObject("tian.moveSpeed");
            this._speedX = _local_2.x;
            this._speedY = _local_2.y;
            super(_arg_1.LivingID);
            this.initSkillMC();
        }

        public static function getAttackEffectAssetByID(_arg_1:int):MovieClip
        {
            return (ClassUtils.CreatInstance(("asset.game.AttackEffect" + _arg_1.toString())) as MovieClip);
        }


        public function get stepX():int
        {
            return (this._speedX * this.speedMult);
        }

        public function get stepY():int
        {
            return (this._speedY * this.speedMult);
        }

        override public function get x():Number
        {
            return (super.x + this._offsetX);
        }

        override public function get y():Number
        {
            return (super.y + this._offsetY);
        }

        public function get EffectIcon():EffectIconContainer
        {
            if (this._effectIconContainer == null)
            {
            };
            return (this._effectIconContainer);
        }

        override public function get layer():int
        {
            if (this.info.isBottom)
            {
                return (PhysicsLayer.AppointBottom);
            };
            return (PhysicsLayer.GameLiving);
        }

        public function get info():Living
        {
            return (this._info);
        }

        public function get map():MapView
        {
            return (_map as MapView);
        }

        private function __fightPowerChanged(_arg_1:LivingEvent):void
        {
            if (((this._info.fightPower > 0) && (this._info.fightPower <= 100)))
            {
                this.fightPowerVisible = true;
                this._fightPower.text = LanguageMgr.GetTranslation("ddt.games.powerText", this._info.fightPower);
            }
            else
            {
                this._fightPower.text = "";
            };
        }

        public function set fightPowerVisible(_arg_1:Boolean):void
        {
            this._fightPower.visible = _arg_1;
        }

        public function playFightToolBoxSkill():void
        {
            if ((!(this._fightToolBoxSkill)))
            {
                this.initSkillMC();
            };
            this._fightToolBoxSkill.soundTransform = SoundManager.instance.getNowSoundTransform();
            this._fightToolBoxSkill.visible = true;
            this._fightToolBoxSkill.play();
        }

        protected function initView():void
        {
            this._propArray = [];
            this._bloodStripBg = ComponentFactory.Instance.creatBitmap("asset.game.smallHPStripBgAsset");
            this._HPStrip = ComponentFactory.Instance.creatComponentByStylename("asset.game.HPStrip");
            this._HPStrip.x = (this._HPStrip.x + (this._bloodStripBg.x = ((-(this._bloodStripBg.width) / 2) + 2)));
            this._HPStrip.y = (this._HPStrip.y + (this._bloodStripBg.y = 20));
            this._bloodWidth = this._HPStrip.width;
            addChild(this._bloodStripBg);
            addChild(this._HPStrip);
            this._HPStrip.setFrame(this.info.team);
            this._fightPower = ComponentFactory.Instance.creatComponentByStylename("GameLiving.fightPower");
            this._nickName = ComponentFactory.Instance.creatComponentByStylename("GameLiving.nickName");
            if (this.info.playerInfo != null)
            {
                this._nickName.text = this.info.playerInfo.NickName;
            }
            else
            {
                this._nickName.text = this.info.name;
            };
            this._nickName.setFrame(this.info.team);
            this._nickName.x = ((-(this._nickName.width) / 2) + 2);
            this._nickName.y = ((this._bloodStripBg.y + (this._bloodStripBg.height / 2)) + 4);
            this._buffBar = new FightBuffBar();
            this._buffBar.y = -98;
            addChild(this._buffBar);
            this._buffBar.update(this._info.turnBuffs);
            this._buffBar.x = -(this._buffBar.width / 2);
            addChild(this._nickName);
            this._fightPower.x = (this._nickName.x - 27);
            this._fightPower.y = (this._nickName.y - 130);
            addChild(this._fightPower);
            this.initSmallMapObject();
            mouseChildren = (mouseEnabled = false);
        }

        private function initSkillMC():void
        {
            this._fightToolBoxSkill = (ComponentFactory.Instance.creat("asset.game.fightToolBoxSkill.mc") as MovieClip);
            this._fightToolBoxSkill.gotoAndStop(1);
            this._fightToolBoxSkill.addFrameScript(OVERFRAME, this.__skillMCdone);
            this._fightToolBoxSkill.visible = false;
            addChild(this._fightToolBoxSkill);
        }

        private function __skillMCdone():void
        {
            if (this._fightToolBoxSkill)
            {
                this._fightToolBoxSkill.stop();
                this._fightToolBoxSkill.visible = false;
                this._fightToolBoxSkill.addFrameScript(OVERFRAME, null);
                ObjectUtils.disposeObject(this._fightToolBoxSkill);
                this._fightToolBoxSkill = null;
            };
        }

        protected function initSmallMapObject():void
        {
            var _local_1:SmallPlayer;
            if (this._info.isPlayer())
            {
                _local_1 = new SmallPlayer();
                this._smallView = _local_1;
            }
            else
            {
                this._smallView = new SmallLiving();
            };
            this._smallView.info = this._info;
        }

        protected function initEffectIcon():void
        {
        }

        protected function initFreezonRect():void
        {
            this._effRect = new Rectangle(0, 24, 200, 200);
        }

        public function addChildrenByPack(_arg_1:IDisplayPack):void
        {
            var _local_2:DisplayObject;
            for each (_local_2 in _arg_1.content)
            {
                addChild(_local_2);
            };
        }

        protected function initListener():void
        {
            this._info.addEventListener(LivingEvent.BEAT, this.__beat);
            this._info.addEventListener(LivingEvent.BEGIN_NEW_TURN, this.__beginNewTurn);
            this._info.addEventListener(LivingEvent.BLOOD_CHANGED, this.__bloodChanged);
            this._info.addEventListener(LivingEvent.DIE, this.__die);
            this._info.addEventListener(LivingEvent.DIR_CHANGED, this.__dirChanged);
            this._info.addEventListener(LivingEvent.FALL, this.__fall);
            this._info.addEventListener(LivingEvent.FORZEN_CHANGED, this.__forzenChanged);
            this._info.addEventListener(LivingEvent.HIDDEN_CHANGED, this.__hiddenChanged);
            this._info.addEventListener(LivingEvent.PLAY_MOVIE, this.__playMovie);
            this._info.addEventListener(LivingEvent.TURN_ROTATION, this.__turnRotation);
            this._info.addEventListener(LivingEvent.JUMP, this.__jump);
            this._info.addEventListener(LivingEvent.MOVE_TO, this.__moveTo);
            this._info.addEventListener(LivingEvent.MAX_HP_CHANGED, this.__maxHpChanged);
            this._info.addEventListener(LivingEvent.LOCK_STATE, this.__lockStateChanged);
            this._info.addEventListener(LivingEvent.POS_CHANGED, this.__posChanged);
            this._info.addEventListener(LivingEvent.SHOOT, this.__shoot);
            this._info.addEventListener(LivingEvent.PREPARE_SHOOT, this.__prepareShoot);
            this._info.addEventListener(LivingEvent.TRANSMIT, this.__transmit);
            this._info.addEventListener(LivingEvent.SAY, this.__say);
            this._info.addEventListener(LivingEvent.START_MOVING, this.__startMoving);
            this._info.addEventListener(LivingEvent.CHANGE_STATE, this.__changeState);
            this._info.addEventListener(LivingEvent.SHOW_ATTACK_EFFECT, this.__showAttackEffect);
            this._info.addEventListener(LivingEvent.BOMBED, this.__bombed);
            this._info.addEventListener(LivingEvent.PLAYSKILLMOVIE, this.__playSkillMovie);
            this._info.addEventListener(LivingEvent.BUFF_CHANGED, this.__buffChanged);
            this._info.addEventListener(LivingEvent.FIGHTPOWER_CHANGE, this.__fightPowerChanged);
            this._info.addEventListener(LivingEvent.PLAY_CONTINUOUS_EFFECT, this.__playContinuousEffect);
            this._info.addEventListener(LivingEvent.REMOVE_CONTINUOUS_EFFECT, this.__removeContinuousEffect);
            this._info.addEventListener(LivingCommandEvent.COMMAND, this.__onLivingCommand);
            if (this._chatballview)
            {
                this._chatballview.addEventListener(Event.COMPLETE, this.onChatBallComplete);
            };
        }

        protected function __removeContinuousEffect(_arg_1:LivingEvent):void
        {
            this.removeBuffEffect(int(_arg_1.paras[0]));
        }

        protected function __playContinuousEffect(_arg_1:LivingEvent):void
        {
            this.showBuffEffect(_arg_1.paras[0], int(_arg_1.paras[1]));
        }

        private function __buffChanged(_arg_1:LivingEvent):void
        {
            if ((((_arg_1.paras[0] == BuffType.Turn) && (this._info)) && (this._info.isLiving)))
            {
                this._buffBar.update(this._info.turnBuffs);
                if (this._info.turnBuffs.length > 0)
                {
                    this._buffBar.x = (5 - (this._buffBar.width / 2));
                    this._buffBar.y = ((this.bodyHeight * -1) - 23);
                    addChild(this._buffBar);
                }
                else
                {
                    if (this._buffBar.parent)
                    {
                        this._buffBar.parent.removeChild(this._buffBar);
                    };
                };
            };
        }

        protected function __removeSkillMovie(_arg_1:LivingEvent):void
        {
        }

        protected function __applySkill(_arg_1:LivingEvent):void
        {
        }

        protected function __playSkillMovie(_arg_1:LivingEvent):void
        {
            this.showEffect(_arg_1.paras[0]);
        }

        protected function __skillMovieComplete(_arg_1:Event):void
        {
            var _local_2:MovieClipWrapper = (_arg_1.currentTarget as MovieClipWrapper);
            _local_2.removeEventListener(Event.COMPLETE, this.__skillMovieComplete);
        }

        protected function __bombed(_arg_1:LivingEvent):void
        {
        }

        protected function removeListener():void
        {
            if (this._info)
            {
                this._info.removeEventListener(LivingEvent.BEAT, this.__beat);
                this._info.removeEventListener(LivingEvent.BEGIN_NEW_TURN, this.__beginNewTurn);
                this._info.removeEventListener(LivingEvent.BLOOD_CHANGED, this.__bloodChanged);
                this._info.removeEventListener(LivingEvent.DIE, this.__die);
                this._info.removeEventListener(LivingEvent.DIR_CHANGED, this.__dirChanged);
                this._info.removeEventListener(LivingEvent.FALL, this.__fall);
                this._info.removeEventListener(LivingEvent.FORZEN_CHANGED, this.__forzenChanged);
                this._info.removeEventListener(LivingEvent.HIDDEN_CHANGED, this.__hiddenChanged);
                this._info.removeEventListener(LivingEvent.PLAY_MOVIE, this.__playMovie);
                this._info.removeEventListener(LivingEvent.TURN_ROTATION, this.__turnRotation);
                this._info.removeEventListener(LivingEvent.PLAYSKILLMOVIE, this.__playSkillMovie);
                this._info.removeEventListener(LivingEvent.REMOVESKILLMOVIE, this.__removeSkillMovie);
                this._info.removeEventListener(LivingEvent.JUMP, this.__jump);
                this._info.removeEventListener(LivingEvent.MOVE_TO, this.__moveTo);
                this._info.removeEventListener(LivingEvent.LOCK_STATE, this.__lockStateChanged);
                this._info.removeEventListener(LivingEvent.POS_CHANGED, this.__posChanged);
                this._info.removeEventListener(LivingEvent.SHOOT, this.__shoot);
                this._info.removeEventListener(LivingEvent.PREPARE_SHOOT, this.__prepareShoot);
                this._info.removeEventListener(LivingEvent.TRANSMIT, this.__transmit);
                this._info.removeEventListener(LivingEvent.SAY, this.__say);
                this._info.removeEventListener(LivingEvent.START_MOVING, this.__startMoving);
                this._info.removeEventListener(LivingEvent.CHANGE_STATE, this.__changeState);
                this._info.removeEventListener(LivingEvent.SHOW_ATTACK_EFFECT, this.__showAttackEffect);
                this._info.removeEventListener(LivingEvent.BOMBED, this.__bombed);
                this._info.removeEventListener(LivingEvent.APPLY_SKILL, this.__applySkill);
                this._info.removeEventListener(LivingEvent.BUFF_CHANGED, this.__buffChanged);
                this._info.removeEventListener(LivingEvent.FIGHTPOWER_CHANGE, this.__fightPowerChanged);
                this._info.removeEventListener(LivingEvent.MAX_HP_CHANGED, this.__maxHpChanged);
                this._info.removeEventListener(LivingEvent.PLAY_CONTINUOUS_EFFECT, this.__playContinuousEffect);
                this._info.removeEventListener(LivingEvent.REMOVE_CONTINUOUS_EFFECT, this.__removeContinuousEffect);
                this._info.removeEventListener(LivingCommandEvent.COMMAND, this.__onLivingCommand);
            };
            if (this._chatballview)
            {
                this._chatballview.removeEventListener(Event.COMPLETE, this.onChatBallComplete);
            };
            this.removeActionEvent();
        }

        protected function __shockMap(_arg_1:ActionEvent):void
        {
            if (this.map)
            {
                this.map.animateSet.addAnimation(new ShockMapAnimation(this, (_arg_1.param as int), 20));
            };
        }

        protected function __shockMap2(_arg_1:Event):void
        {
            if (this.map)
            {
                this.map.animateSet.addAnimation(new ShockMapAnimation(this, 30, 20));
            };
        }

        protected function __renew(_arg_1:Event):void
        {
            this._info.showAttackEffect(2);
        }

        protected function __startBlank(_arg_1:Event):void
        {
            addEventListener(Event.ENTER_FRAME, this.drawBlank);
        }

        protected function drawBlank(_arg_1:Event):void
        {
            if (this.counter <= 15)
            {
                graphics.clear();
                this.ap = ((1 / 225) * (this.counter * this.counter));
                graphics.beginFill(0xFFFFFF, this.ap);
                graphics.drawRect(-3000, -1800, 7000, 4200);
            }
            else
            {
                if (this.counter <= 23)
                {
                    graphics.clear();
                    this.ap = 1;
                    graphics.beginFill(0xFFFFFF, this.ap);
                    graphics.drawRect(-3000, -1800, 7000, 4200);
                }
                else
                {
                    if (this.counter <= 75)
                    {
                        graphics.clear();
                        this.ap = (this.ap - 0.02);
                        graphics.beginFill(0xFFFFFF, this.ap);
                        graphics.drawRect(-3000, -1800, 7000, 4200);
                    }
                    else
                    {
                        graphics.clear();
                        removeEventListener(Event.ENTER_FRAME, this.drawBlank);
                    };
                };
            };
            this.counter++;
        }

        protected function __showDefence(_arg_1:Event):void
        {
            var _local_2:ShowEffect = new ShowEffect(ShowEffect.GUARD);
            _local_2.x = (this.x + this.offset());
            _local_2.y = ((this.y - 50) + this.offset(25));
            _map.addChild(_local_2);
        }

        protected function __addEffectHandler(_arg_1:DictionaryEvent):void
        {
            var _local_2:BaseMirariEffectIcon = (_arg_1.data as BaseMirariEffectIcon);
            this.EffectIcon.handleEffect(_local_2.mirariType, _local_2.getEffectIcon());
        }

        protected function __removeEffectHandler(_arg_1:DictionaryEvent):void
        {
            var _local_2:BaseMirariEffectIcon = (_arg_1.data as BaseMirariEffectIcon);
            this.EffectIcon.removeEffect(_local_2.mirariType);
        }

        protected function __clearEffectHandler(_arg_1:DictionaryEvent):void
        {
            this.EffectIcon.clearEffectIcon();
        }

        protected function __sizeChangeHandler(_arg_1:Event):void
        {
            this.EffectIcon.x = (5 - (this.EffectIcon.width / 2));
            this.EffectIcon.y = ((this.bodyHeight * -1) - this.EffectIcon.height);
        }

        protected function __changeState(_arg_1:LivingEvent):void
        {
        }

        protected function initMovie():void
        {
            var _local_1:Class;
            if (ModuleLoader.hasDefinition(this.info.actionMovieName))
            {
                _local_1 = (ModuleLoader.getDefinition(this.info.actionMovieName) as Class);
                if (this._actionMovie)
                {
                    this.removeActionEvent();
                    this._actionMovie.dispose();
                    this._actionMovie = null;
                };
                this._actionMovie = new (_local_1)();
                this.initActionEvent();
                this._info.actionMovieBitmap = new Bitmap(this.getBodyBitmapData("show2"));
                this._info.thumbnail = this.getBodyBitmapData("show");
                this._actionMovie.mouseEnabled = false;
                this._actionMovie.mouseChildren = false;
                this._actionMovie.scrollRect = null;
                addChild(this._actionMovie);
                this._actionMovie.gotoAndStop(1);
                this._actionMovie.scaleX = -(this._info.direction);
            }
            else
            {
                this._actionMovie = (ClassUtils.CreatInstance("asset.game.defaultImage") as ActionMovie);
                this._actionMovie.mouseEnabled = false;
                this._actionMovie.mouseChildren = false;
                this._actionMovie.scrollRect = null;
                addChild(this._actionMovie);
                this._timer = new Timer(500);
                this._timer.addEventListener(TimerEvent.TIMER, this.__checkActionIsReady);
                this._timer.start();
            };
            this.initChatball();
        }

        protected function __checkActionIsReady(_arg_1:TimerEvent):void
        {
            if (ModuleLoader.hasDefinition(this.info.actionMovieName))
            {
                if (this._timer)
                {
                    this._timer.removeEventListener(TimerEvent.TIMER, this.__checkActionIsReady);
                    this._timer.stop();
                    this._timer = null;
                };
                this.initMovie();
                dispatchEvent(new LivingEvent(LivingEvent.LIVING_READY));
            };
        }

        private function initActionEvent():void
        {
            this._actionMovie.addEventListener("renew", this.__renew);
            this._actionMovie.addEventListener(SHOCK_EVENT2, this.__shockMap2);
            this._actionMovie.addEventListener(SHOCK_EVENT, this.__shockMap);
            this._actionMovie.addEventListener(NEED_FOCUS, this.__needFocus);
            this._actionMovie.addEventListener(SHIELD, this.__showDefence);
            this._actionMovie.addEventListener(ATTACK_COMPLETE_FOCUS, this.__attackCompleteFocus);
            this._actionMovie.addEventListener(BOMB_EVENT, this.__startBlank);
            this._actionMovie.addEventListener(PLAY_EFFECT, this.__playEffect);
            this._actionMovie.addEventListener(PLAYER_EFFECT, this.__playerEffect);
        }

        private function removeActionEvent():void
        {
            if (this._actionMovie)
            {
                this._actionMovie.removeEventListener("renew", this.__renew);
                this._actionMovie.removeEventListener(SHOCK_EVENT2, this.__shockMap2);
                this._actionMovie.removeEventListener(SHOCK_EVENT, this.__shockMap);
                this._actionMovie.removeEventListener(NEED_FOCUS, this.__needFocus);
                this._actionMovie.removeEventListener(SHIELD, this.__showDefence);
                this._actionMovie.removeEventListener(BOMB_EVENT, this.__startBlank);
                this._actionMovie.removeEventListener(PLAY_EFFECT, this.__playEffect);
                this._actionMovie.removeEventListener(PLAYER_EFFECT, this.__playerEffect);
            };
        }

        protected function initChatball():void
        {
            this._chatballview = new ChatBallPlayer();
            this._originalHeight = this._actionMovie.height;
            this._originalWidth = this._actionMovie.width;
            addChild(this._chatballview);
        }

        protected function __startMoving(_arg_1:LivingEvent):void
        {
            var _local_2:Point = _map.findYLineNotEmptyPointDown(this.x, this.y, _map.height);
            if (_local_2 == null)
            {
                _local_2 = new Point(this.x, (_map.height + 1));
            };
            this._info.fallTo(_local_2, 20);
        }

        protected function __say(_arg_1:LivingEvent):void
        {
            if (this._info.isHidden)
            {
                return;
            };
            this._chatballview.x = 0;
            this._chatballview.y = 0;
            addChild(this._chatballview);
            var _local_2:String = (_arg_1.paras[0] as String);
            var _local_3:int;
            if (_arg_1.paras[1])
            {
                _local_3 = _arg_1.paras[1];
            };
            this._chatballview.setText(_local_2, _local_3);
            this.fitChatBallPos();
        }

        protected function fitChatBallPos():void
        {
            this._chatballview.x = this.popPos.x;
            this._chatballview.y = this.popPos.y;
            this._chatballview.directionX = this.movie.scaleX;
            if (this.popDir)
            {
                this._chatballview.directionY = (this.popDir.y - this._chatballview.y);
            };
        }

        protected function get popPos():Point
        {
            var _local_1:Point;
            if (this.movie["popupPos"])
            {
                _local_1 = new Point(this.movie["popupPos"].x, this.movie["popupPos"].y);
            }
            else
            {
                _local_1 = new Point((-(this.movie.width * 0.4) * this.movie.scaleX), (-(this.movie.height * 0.8) * this.movie.scaleY));
            };
            return (_local_1);
        }

        protected function get popDir():Point
        {
            if (this.movie["popupDir"])
            {
                return (new Point(this.movie["popupDir"].x, this.movie["popupDir"].y));
            };
            return (this.popPos);
        }

        override public function collidedByObject(_arg_1:PhysicalObj):void
        {
        }

        protected function __beat(_arg_1:LivingEvent):void
        {
            if (_isLiving)
            {
                this.targetAttackEffect = _arg_1.paras[0][0].attackEffect;
                this._actionMovie.doAction(_arg_1.paras[0][0].action, this.updateTargetsBlood, _arg_1.paras);
            };
        }

        protected function updateTargetsBlood(_arg_1:Array):void
        {
            var _local_4:Living;
            if (_arg_1 == null)
            {
                return;
            };
            var _local_2:Boolean;
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                if ((((_arg_1[_local_3]) && (_arg_1[_local_3].target)) && (_arg_1[_local_3].target.isLiving)))
                {
                    _local_4 = _arg_1[_local_3].target;
                    _local_4.isHidden = false;
                    _local_4.showAttackEffect(_arg_1[_local_3].attackEffect);
                    _local_4.updateBlood(_arg_1[_local_3].targetBlood, 3, _arg_1[_local_3].damage);
                    if ((!(_local_2)))
                    {
                        if (GameManager.Instance.Current.self.LivingID == _local_4.LivingID)
                        {
                            this.map.setCenter(_local_4.pos.x, (_local_4.pos.y - 150), true, AnimationLevel.MIDDLE, _local_4.LivingID);
                        };
                    };
                    if (_local_4.isSelf)
                    {
                        _local_2 = true;
                    };
                };
                _local_3++;
            };
        }

        protected function __beginNewTurn(_arg_1:LivingEvent):void
        {
        }

        protected function __playMovie(_arg_1:LivingEvent):void
        {
            this.doAction(_arg_1.paras[0]);
        }

        protected function __turnRotation(_arg_1:LivingEvent):void
        {
            this.act(new LivingTurnAction(this, _arg_1.paras[0], _arg_1.paras[1], _arg_1.paras[2]));
        }

        protected function __bloodChanged(_arg_1:LivingEvent):void
        {
            var _local_3:ShootPercentView;
            var _local_4:int;
            var _local_5:int;
            var _local_9:int;
            var _local_10:Point;
            if (((!(this.isExist)) || (!(_map))))
            {
                return;
            };
            var _local_2:Number = (_arg_1.value - _arg_1.old);
            var _local_6:int = _arg_1.paras[0];
            var _local_7:Boolean = this.info.isSelf;
            var _local_8:ShootPercentView = GameManager.Instance.petReduceList.pop();
            if (_local_8)
            {
                _local_8.play();
            };
            switch (_local_6)
            {
                case 0:
                    _local_2 = _arg_1.paras[1];
                    if (((!(_local_2 == 0)) && (!(this._info.blood == 0))))
                    {
                        _local_3 = new ShootPercentView(Math.abs(_local_2), 1, true, _local_7);
                        _local_3.x = (this.x - 20);
                        _local_3.y = ((this.y - 50) + this.offset(25));
                        _local_3.scaleX = (_local_3.scaleY = (0.8 + (Math.random() * 0.4)));
                        _map.addToPhyLayer(_local_3);
                        if (this._info.isHidden)
                        {
                            if (this._info.team == GameManager.Instance.Current.selfGamePlayer.team)
                            {
                                (_local_3.alpha == 0.5);
                            }
                            else
                            {
                                this.visible = false;
                                _local_3.alpha = 0;
                            };
                        };
                    };
                    break;
                case 90:
                    _local_3 = new ShootPercentView(0, 2, false, _local_7);
                    _local_3.x = (this.x + this.offset());
                    _local_3.y = ((this.y - 50) + this.offset(25));
                    _local_3.scaleX = (_local_3.scaleY = (0.8 + (Math.random() * 0.4)));
                    _map.addToPhyLayer(_local_3);
                    break;
                case 5:
                    break;
                case 3:
                    _local_5 = _arg_1.paras[1];
                    _local_2 = _local_5;
                    if (_local_2 != 0)
                    {
                        _local_3 = new ShootPercentView(Math.abs(_local_2), 1, false, _local_7);
                        _local_3.x = ((this.x + 50) + this.offset(10));
                        _local_3.y = ((this.y - 50) + this.offset(25));
                        _local_3.scaleX = (_local_3.scaleY = (0.8 + (Math.random() * 0.4)));
                        _map.addToPhyLayer(_local_3);
                    };
                    break;
                case 11:
                    _local_5 = _arg_1.paras[1];
                    if (_local_5 < 0)
                    {
                        _local_2 = _local_5;
                    };
                    if (_local_2 != 0)
                    {
                        _local_3 = new ShootPercentView(Math.abs(_local_2), _arg_1.paras[0], false, _local_7);
                        _local_3.x = (this.x + this.offset());
                        _local_3.y = ((this.y - 50) + this.offset(25));
                        _local_3.scaleX = (_local_3.scaleY = (0.8 + (Math.random() * 0.4)));
                        _map.addToPhyLayer(_local_3);
                    };
                    break;
                default:
                    _local_5 = _arg_1.paras[1];
                    if (_local_5 < 0)
                    {
                        _local_2 = _local_5;
                    };
                    if (_local_2 != 0)
                    {
                        if (!((GameManager.Instance.isDieFight) && (this._info.isHidden)))
                        {
                            _local_3 = new ShootPercentView(Math.abs(_local_2), _arg_1.paras[0], false, _local_7);
                            _local_3.x = (this.x + this.offset());
                            _local_3.y = ((this.y - 50) + this.offset(25));
                            _local_3.scaleX = (_local_3.scaleY = (0.8 + (Math.random() * 0.4)));
                            _map.addToPhyLayer(_local_3);
                        };
                    };
            };
            if (_local_3)
            {
                _local_10 = _map.localToGlobal(new Point(_local_3.x, _local_3.y));
                if (_local_10.x > 900)
                {
                    _local_9 = 1;
                }
                else
                {
                    if (_local_10.x < 100)
                    {
                        _local_9 = 2;
                    }
                    else
                    {
                        _local_9 = 0;
                    };
                };
                _local_3.play(_local_9);
            };
            this.updateBloodStrip();
        }

        protected function __maxHpChanged(_arg_1:LivingEvent):void
        {
            this.updateBloodStrip();
        }

        protected function updateBloodStrip():void
        {
            if (this.info.blood < 0)
            {
                this._HPStrip.width = 0;
            }
            else
            {
                this._HPStrip.width = Math.floor(((this._bloodWidth / this.info.maxBlood) * this.info.blood));
            };
        }

        public function offset(_arg_1:int=30):int
        {
            var _local_2:int = int((Math.random() * 10));
            if ((_local_2 % 2) == 0)
            {
                return (-(int((Math.random() * _arg_1))));
            };
            return (int((Math.random() * _arg_1)));
        }

        protected function __die(_arg_1:LivingEvent):void
        {
            if (_isLiving)
            {
                this._info.MirariEffects.removeEventListener(DictionaryEvent.ADD, this.__addEffectHandler);
                this._info.MirariEffects.removeEventListener(DictionaryEvent.REMOVE, this.__removeEffectHandler);
                this._info.MirariEffects.removeEventListener(DictionaryEvent.CLEAR, this.__clearEffectHandler);
                _isLiving = false;
                this.die();
            };
            this._doDieAction = _arg_1.paras[0];
            if (((GameManager.Instance.dropTaskGoodsId >= 0) && (!(DialogManager.Instance.getDropPoint(GameManager.Instance.dialogId)))))
            {
                if (this.info.LivingID == GameManager.Instance.dropTaskGoodsNpcId)
                {
                    if (DialogManager.Instance.hasDialogs(GameManager.Instance.dialogId))
                    {
                        if (DialogManager.Instance.dropGoodsBeforeDialog(GameManager.Instance.dialogId))
                        {
                            this.doDieAction();
                            this._timeoutMark1 = setTimeout(this.dropGoods, 500);
                        }
                        else
                        {
                            this.showDialog(GameManager.Instance.dialogId);
                        };
                    }
                    else
                    {
                        this.doDieAction();
                        this._timeoutMark1 = setTimeout(this.dropGoods, 500);
                    };
                };
            }
            else
            {
                this.doDieAction();
            };
        }

        override public function die():void
        {
            this.info.isFrozen = false;
            this.info.isNoNole = false;
            this.info.isHidden = false;
            if (((this._bloodStripBg) && (this._bloodStripBg.parent)))
            {
                this._bloodStripBg.parent.removeChild(this._bloodStripBg);
            };
            if (((this._HPStrip) && (this._HPStrip.parent)))
            {
                this._HPStrip.parent.removeChild(this._HPStrip);
            };
            if (this._buffBar)
            {
                this._buffBar.dispose();
            };
            this._buffBar = null;
            this.removeAllPetBuffEffects();
        }

        protected function doDieAction():void
        {
        }

        private function showDialog(_arg_1:uint, _arg_2:Function=null):void
        {
            LayerManager.Instance.addToLayer(DialogManager.Instance.DialogBox, LayerManager.STAGE_TOP_LAYER);
            DialogManager.Instance.addEventListener(Event.COMPLETE, this.__dialogEndCallBack);
            DialogManager.Instance.showDialog(_arg_1, 2500, false, false, true, 8);
        }

        private function __dialogEndCallBack(_arg_1:Event):void
        {
            DialogManager.Instance.removeEventListener(Event.COMPLETE, this.__dialogEndCallBack);
            ChatManager.Instance.chatDisabled = false;
            var _local_2:Boolean = DialogManager.Instance.dropGoodsBeforeDialog(GameManager.Instance.dialogId);
            GameManager.Instance.dialogId = -1;
            if (GameManager.Instance.dropTaskGoodsId >= 0)
            {
                this.doDieAction();
                this._timeoutMark1 = setTimeout(this.dropGoods, 500);
            };
        }

        private function tweenTaskGoods(_arg_1:MovieClip, _arg_2:Point):void
        {
            this._dropGoodsTween = null;
            SoundManager.instance.play("204");
            this._dropGoodsTween = TweenLite.to(_arg_1, 0.7, {
                "x":_arg_2.x,
                "y":_arg_2.y,
                "scaleX":0.5,
                "scaleY":0.5,
                "onComplete":this.__onFinishTween,
                "onCompleteParams":[_arg_1]
            });
        }

        private function __onFinishTween(_arg_1:MovieClip):void
        {
            var _local_2:Point;
            if (_arg_1)
            {
                if (_arg_1.parent)
                {
                    _arg_1.parent.removeChild(_arg_1);
                };
                _arg_1 = null;
            };
            if ((!((RoomManager.Instance.current) && (RoomManager.Instance.current.type == RoomInfo.SINGLE_DUNGEON))))
            {
                return;
            };
            switch (GameManager.Instance.dropTaskGoodsId)
            {
                case GameManager.TASK_GOOD_THREE:
                    this._iconWrapper = new MovieClipWrapper(ClassUtils.CreatInstance("asset.trainer7.getThreeIcon"), true, true);
                    _local_2 = ComponentFactory.Instance.creatCustomObject("trainer.explain.posGetThreeIcon");
                    GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.GET_THREE_ICON));
                    break;
                case GameManager.TASK_GOOD_ADDONE:
                    this._iconWrapper = new MovieClipWrapper(ClassUtils.CreatInstance("asset.trainer8.getAddOneIcon"), true, true);
                    _local_2 = ComponentFactory.Instance.creatCustomObject("trainer.explain.posGetAddOneIcon");
                    GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.GET_ADDONE_ICON));
                    break;
                case GameManager.TASK_GOOD_POWMAX:
                    this._iconWrapper = new MovieClipWrapper(ClassUtils.CreatInstance("asset.trainer10.getPowMaxIcon"), true, true);
                    _local_2 = ComponentFactory.Instance.creatCustomObject("trainer.explain.posGetPowMaxIcon");
                    GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.GET_POWMAX_ICON));
                    break;
                case GameManager.TASK_GOOD_ADDTWO:
                    this._iconWrapper = new MovieClipWrapper(ClassUtils.CreatInstance("asset.trainer9.getAddTwoIcon"), true, true);
                    _local_2 = ComponentFactory.Instance.creatCustomObject("trainer.explain.posGetAddTwoIcon");
                    GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.GET_ADDTWO_ICON));
                    break;
            };
            this._iconWrapper.movie.x = _local_2.x;
            this._iconWrapper.movie.y = _local_2.y;
            SoundManager.instance.play("205");
            LayerManager.Instance.addToLayer(this._iconWrapper.movie, LayerManager.GAME_UI_LAYER, false);
            GameManager.Instance.dropTaskGoodsId = -1;
            GameManager.Instance.dropTaskGoodsNpcId = -1;
            GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.LOCK_SCREEN, false));
            if (GameManager.Instance.dialogId > 0)
            {
                if (DialogManager.Instance.hasDialogs(GameManager.Instance.dialogId))
                {
                    this._timeoutMark1 = setTimeout(this.showDialog, 1000, GameManager.Instance.dialogId);
                };
            };
        }

        private function dropGoods():void
        {
            var _local_1:Point;
            var _local_2:String;
            GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.LOCK_SCREEN, true));
            switch (GameManager.Instance.dropTaskGoodsId)
            {
                case GameManager.TASK_GOOD_THREE:
                    this._goodsMovie = ComponentFactory.Instance.creat("asset.trainer7.getThree");
                    _local_2 = "trainer.explain.posGetThree";
                    break;
                case GameManager.TASK_GOOD_ADDONE:
                    this._goodsMovie = ComponentFactory.Instance.creat("asset.trainer8.getAddOne");
                    _local_2 = "trainer.explain.posGetAddOne";
                    break;
                case GameManager.TASK_GOOD_POWMAX:
                    this._goodsMovie = ComponentFactory.Instance.creat("asset.trainer10.getPowMax");
                    _local_2 = "trainer.explain.posGetPowMax";
                    break;
                case GameManager.TASK_GOOD_ADDTWO:
                    this._goodsMovie = ComponentFactory.Instance.creat("asset.trainer9.getAddTwo");
                    _local_2 = "trainer.explain.posGetAddTwo";
                    break;
            };
            _local_1 = this.map.localToGlobal(this.info.pos);
            this._goodsMovie.x = _local_1.x;
            this._goodsMovie.y = _local_1.y;
            SoundManager.instance.play("203");
            LayerManager.Instance.addToLayer(this._goodsMovie, LayerManager.GAME_UI_LAYER);
            var _local_3:Point = ComponentFactory.Instance.creatCustomObject(_local_2);
            this._timeoutMark2 = setTimeout(this.tweenTaskGoods, 4200, this._goodsMovie, _local_3);
        }

        protected function __dirChanged(_arg_1:LivingEvent):void
        {
            if (this._info.direction > 0)
            {
                this.movie.scaleX = -1;
            }
            else
            {
                this.movie.scaleX = 1;
            };
        }

        protected function __forzenChanged(_arg_1:LivingEvent):void
        {
            if (this._info.isFrozen)
            {
                this.effectForzen = (ClassUtils.CreatInstance("asset.gameFrostEffectAsset") as MovieClip);
                this.effectForzen.y = 24;
                addChild(this.effectForzen);
            }
            else
            {
                if (this.effectForzen)
                {
                    removeChild(this.effectForzen);
                    this.effectForzen = null;
                };
            };
        }

        protected function __lockStateChanged(_arg_1:LivingEvent):void
        {
            if (this._info.LockState)
            {
                this.lock = (ClassUtils.CreatInstance("asset.gameII.LockAsset") as MovieClip);
                this.lock.x = 10;
                this.lock.y = 5;
                addChild(this.lock);
                if (_arg_1.paras[0] == 2)
                {
                    this.lock.y = (this.lock.y + 50);
                    this.lock.scaleX = (this.lock.scaleY = 0.8);
                    this.lock.stop();
                    this.lock.alpha = 0.7;
                };
            }
            else
            {
                if (this.lock)
                {
                    removeChild(this.lock);
                    this.lock = null;
                };
            };
        }

        protected function __hiddenChanged(_arg_1:LivingEvent):void
        {
            if (this._info.isHidden)
            {
                if (this._info.team != GameManager.Instance.Current.selfGamePlayer.team)
                {
                    this.visible = false;
                    if (this._smallView)
                    {
                        this._smallView.visible = false;
                        this._smallView.alpha = 0;
                    };
                    alpha = 0;
                }
                else
                {
                    alpha = 0.5;
                    if (this._smallView)
                    {
                        this._smallView.alpha = 0.5;
                    };
                };
            }
            else
            {
                alpha = 1;
                this.visible = true;
                if (this._smallView)
                {
                    this._smallView.visible = true;
                    this._smallView.alpha = 1;
                };
                parent.addChild(this);
            };
        }

        protected function __posChanged(_arg_1:LivingEvent):void
        {
            var _local_2:Number;
            pos = this._info.pos;
            if (_isLiving)
            {
                _local_2 = calcObjectAngle(16);
                this._info.playerAngle = _local_2;
            };
            if (this.map)
            {
                this.map.smallMap.updatePos(this.smallView, pos);
            };
        }

        protected function __jump(_arg_1:LivingEvent):void
        {
            this.doAction(_arg_1.paras[2]);
            this.act(new LivingJumpAction(this, _arg_1.paras[0], _arg_1.paras[1], _arg_1.paras[3]));
        }

        protected function __moveTo(_arg_1:LivingEvent):void
        {
            var _local_13:Point;
            var _local_2:String = _arg_1.paras[4];
            this.doAction(_local_2);
            var _local_3:int = _arg_1.paras[5];
            if (_local_3 == 0)
            {
                _local_3 = 7;
            };
            var _local_4:Point = (_arg_1.paras[1] as Point);
            var _local_5:int = _arg_1.paras[2];
            var _local_6:String = _arg_1.paras[6];
            if (((this.x == _local_4.x) && (this.y == _local_4.y)))
            {
                return;
            };
            var _local_7:Array = [];
            var _local_8:int = this.x;
            var _local_9:int = this.y;
            var _local_10:Point = new Point(this.x, this.y);
            var _local_11:int = ((_local_4.x > _local_8) ? 1 : -1);
            var _local_12:Point = new Point(this.x, this.y);
            if (_local_2.substr(0, 3) == "fly")
            {
                _local_13 = new Point((_local_4.x - _local_12.x), (_local_4.y - _local_12.y));
                while (_local_13.length > _local_3)
                {
                    _local_13.normalize(_local_3);
                    _local_12 = new Point((_local_12.x + _local_13.x), (_local_12.y + _local_13.y));
                    _local_13 = new Point((_local_4.x - _local_12.x), (_local_4.y - _local_12.y));
                    if (_local_12)
                    {
                        _local_7.push(_local_12);
                    }
                    else
                    {
                        _local_7.push(_local_4);
                        break;
                    };
                };
            }
            else
            {
                while (((_local_4.x - _local_8) * _local_11) > 0)
                {
                    _local_12 = _map.findNextWalkPoint(_local_8, _local_9, _local_11, (_local_3 * npcStepX), (_local_3 * npcStepY));
                    if (_local_12)
                    {
                        _local_7.push(_local_12);
                        _local_8 = _local_12.x;
                        _local_9 = _local_12.y;
                    }
                    else
                    {
                        break;
                    };
                };
            };
            if (_local_7.length > 0)
            {
                this._info.act(new LivingMoveAction(this, _local_7, _local_5, _local_6));
            }
            else
            {
                if (_local_6 != "")
                {
                    this.doAction(_local_6);
                }
                else
                {
                    this._info.doDefaultAction();
                };
            };
        }

        public function canMoveDirection(_arg_1:Number):Boolean
        {
            return (!(this.map.IsOutMap((this.x + ((15 + this.stepX) * _arg_1)), this.y)));
        }

        public function canStand(_arg_1:int, _arg_2:int):Boolean
        {
            return ((!(this.map.IsEmpty((_arg_1 - 1), _arg_2))) || (!(this.map.IsEmpty((_arg_1 + 1), _arg_2))));
        }

        public function getNextWalkPoint(_arg_1:int):Point
        {
            if (this.canMoveDirection(_arg_1))
            {
                return (_map.findNextWalkPoint(this.x, this.y, _arg_1, this.stepX, this.stepY));
            };
            return (null);
        }

        private function __needFocus(_arg_1:ActionMovieEvent):void
        {
            if (_arg_1.data)
            {
                this.needFocus(_arg_1.data.x, _arg_1.data.y, _arg_1.data, (!(_arg_1.data.strategy == null)));
            };
        }

        protected function __playEffect(_arg_1:ActionMovieEvent):void
        {
        }

        protected function __playerEffect(_arg_1:ActionMovieEvent):void
        {
        }

        public function needFocus(_arg_1:int=0, _arg_2:int=0, _arg_3:Object=null, _arg_4:Boolean=false):void
        {
            this.map.livingSetCenter((this.x + _arg_1), ((this.y + _arg_2) - 150), _arg_4, AnimationLevel.HIGHT, this._info.LivingID, _arg_3);
        }

        public function followFocus(_arg_1:int=0, _arg_2:int=0, _arg_3:Object=null, _arg_4:Boolean=false):void
        {
            this.map.livingSetCenter((this.x + _arg_1), ((this.y + _arg_2) - 150), _arg_4, AnimationLevel.HIGHT, this._info.LivingID, _arg_3);
        }

        private function __attackCompleteFocus(_arg_1:ActionMovieEvent):void
        {
            this.map.setSelfCenter(true, 2, _arg_1.data);
        }

        protected function __shoot(_arg_1:LivingEvent):void
        {
        }

        protected function __prepareShoot(_arg_1:LivingEvent):void
        {
        }

        protected function __transmit(_arg_1:LivingEvent):void
        {
            this.info.pos = _arg_1.paras[0];
        }

        protected function __fall(_arg_1:LivingEvent):void
        {
            this._info.act(new LivingFallingAction(this, _arg_1.paras[0], _arg_1.paras[1], _arg_1.paras[3]));
        }

        public function get actionMovie():ActionMovie
        {
            return (this._actionMovie);
        }

        public function get movie():Sprite
        {
            return (this._actionMovie);
        }

        public function doAction(_arg_1:*):void
        {
            if (this._actionMovie != null)
            {
                this._actionMovie.doAction(_arg_1);
            };
        }

        public function showEffect(_arg_1:String):void
        {
            var _local_2:AutoDisappear;
            if (((_arg_1) && (ModuleLoader.hasDefinition(_arg_1))))
            {
                _local_2 = new AutoDisappear(ClassUtils.CreatInstance(_arg_1));
                addChild(_local_2);
            };
        }

        public function showBuffEffect(_arg_1:String, _arg_2:int):void
        {
            var _local_3:DisplayObject;
            if (((_arg_1) && (ModuleLoader.hasDefinition(_arg_1))))
            {
                if ((!(this._buffEffect)))
                {
                    return;
                };
                if (((this._buffEffect) && (this._buffEffect.hasKey(_arg_2))))
                {
                    this.removeBuffEffect(_arg_2);
                };
                _local_3 = (ClassUtils.CreatInstance(_arg_1) as DisplayObject);
                addChild(_local_3);
                this._buffEffect.add(_arg_2, _local_3);
            };
        }

        public function removeBuffEffect(_arg_1:int):void
        {
            var _local_2:DisplayObject;
            if (((this._buffEffect) && (this._buffEffect.hasKey(_arg_1))))
            {
                _local_2 = (this._buffEffect[_arg_1] as DisplayObject);
                if (((_local_2) && (_local_2.parent)))
                {
                    removeChild(_local_2);
                };
                this._buffEffect.remove(_arg_1);
            };
        }

        public function act(_arg_1:BaseAction):void
        {
            this._info.act(_arg_1);
        }

        public function traceCurrentAction():void
        {
            this._info.traceCurrentAction();
        }

        override public function update(_arg_1:Number):void
        {
            if (this._isDie)
            {
                return;
            };
            super.update(_arg_1);
            this._info.update();
        }

        private function getBodyBitmapData(_arg_1:String=""):BitmapData
        {
            var _local_2:Number = this._actionMovie.width;
            var _local_3:Sprite = new Sprite();
            this.bodyWidth = this._actionMovie.width;
            this.bodyHeight = this._actionMovie.height;
            this._actionMovie.gotoAndStop(_arg_1);
            var _local_4:Boolean;
            if (LeftPlayerCartoonView.SHOW_BITMAP_WIDTH < this._actionMovie.width)
            {
                this._actionMovie.width = LeftPlayerCartoonView.SHOW_BITMAP_WIDTH;
                this._actionMovie.scaleY = this._actionMovie.scaleX;
                _local_4 = true;
            };
            _local_3.addChild(this._actionMovie);
            var _local_5:Rectangle = this._actionMovie.getBounds(this._actionMovie);
            this._actionMovie.x = (-(_local_5.x) * this._actionMovie.scaleX);
            this._actionMovie.y = (-(_local_5.y) * this._actionMovie.scaleX);
            var _local_6:BitmapData = new BitmapData(_local_3.width, _local_3.height, true, 0);
            _local_6.draw(_local_3);
            if (_local_4)
            {
                this._actionMovie.width = _local_2;
                this._actionMovie.scaleY = (this._actionMovie.scaleX = 1);
            };
            this._actionMovie.doAction("stand");
            this._actionMovie.x = (this._actionMovie.y = 0);
            _local_3.removeChild(this._actionMovie);
            return (_local_6);
        }

        protected function deleteSmallView():void
        {
            if (this._bloodStripBg)
            {
                if (this._bloodStripBg.parent)
                {
                    this._bloodStripBg.parent.removeChild(this._bloodStripBg);
                };
                this._bloodStripBg.bitmapData.dispose();
                this._bloodStripBg = null;
            };
            if (this._HPStrip)
            {
                if (this._HPStrip.parent)
                {
                    this._HPStrip.parent.removeChild(this._HPStrip);
                };
                this._HPStrip.dispose();
                this._HPStrip = null;
            };
            if (this._nickName)
            {
                if (this._nickName.parent)
                {
                    this._nickName.parent.removeChild(this._nickName);
                };
            };
            if (this._smallView)
            {
                this._smallView.dispose();
                this._smallView.visible = false;
            };
            this._smallView = null;
        }

        private function removeAllPetBuffEffects():void
        {
            var _local_1:DisplayObject;
            if (this._buffEffect)
            {
                for each (_local_1 in this._buffEffect.list)
                {
                    ObjectUtils.disposeObject(_local_1);
                };
                this._buffEffect = null;
            };
        }

        override public function dispose():void
        {
            var _local_1:Object;
            super.dispose();
            this.removeListener();
            if (this._iconWrapper)
            {
                if (this._iconWrapper.movie)
                {
                    if (this._iconWrapper.movie.parent)
                    {
                        this._iconWrapper.movie.parent.removeChild(this._iconWrapper.movie);
                    };
                };
            };
            if (this._timer)
            {
                this._timer.removeEventListener(TimerEvent.TIMER, this.__checkActionIsReady);
                this._timer.stop();
                this._timer = null;
            };
            if (GameManager.Instance.isLeaving)
            {
                if (this._dropGoodsTween)
                {
                    this._dropGoodsTween.kill();
                    this._dropGoodsTween = null;
                };
                if (this._timeoutMark1)
                {
                    clearTimeout(this._timeoutMark1);
                };
                if (this._timeoutMark2)
                {
                    clearTimeout(this._timeoutMark2);
                };
                if (this._goodsMovie)
                {
                    if (this._goodsMovie.parent)
                    {
                        this._goodsMovie.parent.removeChild(this._goodsMovie);
                    };
                    this._goodsMovie = null;
                };
            };
            this._info = null;
            this.deleteSmallView();
            this.removeAllPetBuffEffects();
            if (this._buffBar)
            {
                ObjectUtils.disposeObject(this._buffBar);
                this._buffBar = null;
            };
            if (this._fightPower)
            {
                ObjectUtils.disposeObject(this._fightPower);
            };
            this._fightPower = null;
            if (this._nickName)
            {
                this._nickName.dispose();
            };
            this._nickName = null;
            if (this._chatballview)
            {
                this._chatballview.dispose();
            };
            this._chatballview = null;
            if (this._actionMovie)
            {
                this._actionMovie.dispose();
                this._actionMovie = null;
            };
            if (parent)
            {
                parent.removeChild(this);
            };
            this.__skillMCdone();
            this.cleanMovies();
            this.isExist = false;
            if (this._propArray)
            {
                for each (_local_1 in this._propArray)
                {
                    ObjectUtils.disposeObject(_local_1);
                };
            };
            if (this._defautBitmap)
            {
                ObjectUtils.disposeObject(this._defautBitmap);
                this._defautBitmap = null;
            };
            this._propArray = null;
        }

        public function get EffectRect():Rectangle
        {
            return (this._effRect);
        }

        override public function get smallView():SmallObject
        {
            return (this._smallView);
        }

        protected function __showAttackEffect(_arg_1:LivingEvent):void
        {
            if (this._attackEffectPlaying)
            {
                return;
            };
            if (this._info == null)
            {
                return;
            };
            this._attackEffectPlaying = true;
            var _local_2:int = _arg_1.paras[0];
            var _local_3:MovieClip = this.creatAttackEffectAssetByID(_local_2);
            _local_3.scaleX = (-1 * this._info.direction);
            var _local_4:MovieClipWrapper = new MovieClipWrapper(_local_3, true, true);
            _local_4.addEventListener(Event.COMPLETE, this.__playComplete);
            _local_4.gotoAndPlay(1);
            this._attackEffectPlayer = new PhysicalObj(-1);
            this._attackEffectPlayer.addChild(_local_4.movie);
            var _local_5:Point = _map.globalToLocal(this.movie.localToGlobal(this._attackEffectPos));
            this._attackEffectPlayer.x = _local_5.x;
            this._attackEffectPlayer.y = _local_5.y;
            _map.addPhysical(this._attackEffectPlayer);
        }

        private function __playComplete(_arg_1:Event):void
        {
            if (_arg_1.currentTarget)
            {
                _arg_1.currentTarget.removeEventListener(Event.COMPLETE, this.__playComplete);
            };
            if (_map)
            {
                _map.removePhysical(this._attackEffectPlayer);
            };
            if (((this._attackEffectPlayer) && (this._attackEffectPlayer.parent)))
            {
                this._attackEffectPlayer.parent.removeChild(this._attackEffectPlayer);
            };
            this._attackEffectPlaying = false;
            this._attackEffectPlayer = null;
        }

        protected function hasMovie(_arg_1:String):Boolean
        {
            return (this._moviePool.hasOwnProperty(_arg_1));
        }

        protected function creatAttackEffectAssetByID(_arg_1:int):MovieClip
        {
            var _local_3:MovieClip;
            var _local_2:String = ("asset.game.AttackEffect" + _arg_1);
            if (this.hasMovie(_local_2))
            {
                return (this._moviePool[_local_2] as MovieClip);
            };
            _local_3 = (ClassUtils.CreatInstance(("asset.game.AttackEffect" + _arg_1.toString())) as MovieClip);
            this._moviePool[_local_2] = _local_3;
            return (_local_3);
        }

        private function cleanMovies():void
        {
            var _local_1:String;
            var _local_2:MovieClip;
            for (_local_1 in this._moviePool)
            {
                _local_2 = this._moviePool[_local_1];
                _local_2.stop();
                ObjectUtils.disposeObject(_local_2);
                delete this._moviePool[_local_1];
            };
        }

        public function showBlood(_arg_1:Boolean):void
        {
            this._bloodStripBg.visible = (this._HPStrip.visible = _arg_1);
            this._nickName.visible = _arg_1;
        }

        public function showNpc(_arg_1:Boolean):void
        {
            if (this._smallView)
            {
                this._smallView.visible = (!(_arg_1));
            };
        }

        override public function setActionMapping(_arg_1:String, _arg_2:String):void
        {
            this._actionMovie.setActionMapping(_arg_1, _arg_2);
        }

        override public function set visible(_arg_1:Boolean):void
        {
            if (this.hiddenByServer)
            {
                return;
            };
            super.visible = _arg_1;
            if (this._onSmallMap == false)
            {
                return;
            };
        }

        private function get hiddenByServer():Boolean
        {
            return (this._hiddenByServer);
        }

        private function set hiddenByServer(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                super.visible = false;
            }
            else
            {
                super.visible = true;
            };
            this._hiddenByServer = _arg_1;
        }

        protected function __onLivingCommand(_arg_1:LivingCommandEvent):void
        {
            switch (_arg_1.commandType)
            {
                case "focusSelf":
                    this.map.setCenter(GameManager.Instance.Current.selfGamePlayer.pos.x, GameManager.Instance.Current.selfGamePlayer.pos.x, false, AnimationLevel.MIDDLE, this._info.LivingID);
                    return;
                case "focus":
                    this.needFocus(_arg_1.object.x, _arg_1.object.y);
                    return;
            };
        }

        protected function onChatBallComplete(_arg_1:Event):void
        {
            if (((this._chatballview) && (this._chatballview.parent)))
            {
                this._chatballview.parent.removeChild(this._chatballview);
            };
        }

        protected function doUseItemAnimation(_arg_1:Boolean=false):void
        {
            var _local_2:MovieClipWrapper = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.ghostPcikPropAsset")), true, true);
            _local_2.addFrameScriptAt(12, this.headPropEffect);
            SoundManager.instance.play("039");
            _local_2.movie.x = 0;
            _local_2.movie.y = -10;
            if ((!(_arg_1)))
            {
                addChild(_local_2.movie);
            };
        }

        protected function headPropEffect():void
        {
            var _local_1:DisplayObject;
            var _local_2:AutoPropEffect;
            var _local_3:String;
            if (((this._propArray) && (this._propArray.length > 0)))
            {
                if ((this._propArray[0] is String))
                {
                    _local_3 = this._propArray.shift();
                    if (_local_3 == "-1")
                    {
                        _local_1 = ComponentFactory.Instance.creatBitmap("game.crazyTank.view.specialKillAsset");
                    }
                    else
                    {
                        _local_1 = PropItemView.createView(_local_3, 60, 60);
                    };
                    _local_2 = new AutoPropEffect(_local_1);
                    _local_2.x = -5;
                    _local_2.y = -140;
                }
                else
                {
                    _local_1 = (this._propArray.shift() as DisplayObject);
                    _local_2 = new AutoPropEffect(_local_1);
                    _local_2.x = 5;
                    _local_2.y = -140;
                };
                addChild(_local_2);
            };
        }

        override public function startMoving():void
        {
            super.startMoving();
            if (this._info)
            {
                this._info.isMoving = true;
            };
        }

        override public function stopMoving():void
        {
            super.stopMoving();
            if (this._info)
            {
                this._info.isMoving = false;
            };
        }

        public function setProperty(_arg_1:String, _arg_2:String):void
        {
            var _local_3:StringObject = new StringObject(_arg_2);
            switch (_arg_1)
            {
                case "visible":
                    this.hiddenByServer = (!(_local_3.getBoolean()));
                    return;
                case "offsetX":
                    this._offsetX = _local_3.getInt();
                    this.map.smallMap.updatePos(this._smallView, new Point(this.x, this.y));
                    return;
                case "offsetY":
                    this._offsetY = _local_3.getInt();
                    this.map.smallMap.updatePos(this._smallView, new Point(this.x, this.y));
                    return;
                case "speedX":
                    this.speedMult = (_local_3.getInt() / this._speedX);
                    return;
                case "speedY":
                    this.speedMult = (_local_3.getInt() / this._speedY);
                    return;
                case "onSmallMap":
                    this.smallView.visible = _local_3.getBoolean();
                    this._onSmallMap = _local_3.getBoolean();
                    if (this._onSmallMap)
                    {
                        this._smallView.info = this._info;
                    };
                    return;
                default:
                    this.info.setProperty(_arg_1, _arg_2);
            };
        }


    }
}//package game.objects

