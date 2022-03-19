// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.model.Living

package game.model
{
    import flash.events.EventDispatcher;
    import game.interfaces.ICommandedAble;
    import ddt.view.character.ShowCharacter;
    import road7th.data.DictionaryData;
    import __AS3__.vec.Vector;
    import ddt.data.FightBuffInfo;
    import ddt.data.FightContainerBuff;
    import flash.geom.Point;
    import game.actions.ActionManager;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.utils.Dictionary;
    import ddt.events.LivingEvent;
    import game.objects.LivingTypesEnum;
    import com.pickgliss.utils.ObjectUtils;
    import game.view.effects.BaseMirariEffectIcon;
    import ddt.data.BuffType;
    import ddt.manager.BuffManager;
    import game.GameManager;
    import game.actions.BaseAction;
    import ddt.data.player.PlayerInfo;
    import ddt.events.CrazyTankSocketEvent;
    import game.objects.SimpleBox;
    import ddt.events.LivingCommandEvent;
    import road7th.data.StringObject;
    import flash.events.Event;
    import __AS3__.vec.*;

    [Event(name="posChanged", type="ddt.events.LivingEvent")]
    [Event(name="dirChanged", type="ddt.events.LivingEvent")]
    [Event(name="forzenChanged", type="ddt.events.LivingEvent")]
    [Event(name="hiddenChanged", type="ddt.events.LivingEvent")]
    [Event(name="noholeChanged", type="ddt.events.LivingEvent")]
    [Event(name="die", type="ddt.events.LivingEvent")]
    [Event(name="angleChanged", type="ddt.events.LivingEvent")]
    [Event(name="bloodChanged", type="ddt.events.LivingEvent")]
    [Event(name="beginNewTurn", type="ddt.events.LivingEvent")]
    [Event(name="shoot", type="ddt.events.LivingEvent")]
    [Event(name="beat", type="ddt.events.LivingEvent")]
    [Event(name="transmit", type="ddt.events.LivingEvent")]
    [Event(name="moveTo", type="ddt.events.LivingEvent")]
    [Event(name="fall", type="ddt.events.LivingEvent")]
    [Event(name="jump", type="ddt.events.LivingEvent")]
    [Event(name="say", type="ddt.events.LivingEvent")]
    public class Living extends EventDispatcher implements ICommandedAble 
    {

        public static const CRY_ACTION:String = "cry";
        public static const STAND_ACTION:String = "stand";
        public static const DIE_ACTION:String = "die";
        public static const SHOOT_ACTION:String = "beat2";
        public static const BORN_ACTION:String = "born";
        public static const RENEW:String = "renew";
        public static const ANGRY_ACTION:String = "angry";
        public static const WALK_ACTION:String = "walk";
        public static const FIGHT_TOOL_SKILL:int = 1;
        public static const DEFENCE_ACTION:String = "shield";
        public static const SUICIDE:int = 6;
        public static const WOUND:int = 3;
        public static const FLASH_BACK:int = 7;
        public static const SAVE_WOUND:int = 31;
        public static const PET_REDUCE:int = 21;

        public var character:ShowCharacter;
        public var typeLiving:int;
        private var _state:int = 0;
        private var _onChange:Boolean;
        private var mIsReadyForShootting:Boolean = false;
        private var _mirariEffects:DictionaryData;
        private var _localBuffs:Vector.<FightBuffInfo> = new Vector.<FightBuffInfo>();
        private var _turnBuffs:Vector.<FightBuffInfo> = new Vector.<FightBuffInfo>();
        private var _petBuffs:Vector.<FightBuffInfo> = new Vector.<FightBuffInfo>();
        private var _noPicPetBuff:DictionaryData = new DictionaryData();
        public var maxEnergy:int = 0;
        public var isExist:Boolean = true;
        public var isBottom:Boolean;
        public var isShowReadyMC:Boolean;
        private var _fightPower:Number;
        private var _currentSelectId:int;
        public var state:Boolean;
        public var wishFreeTime:int = 3;
        private var _isLockFly:Boolean = false;
        private var _isLockAngle:Boolean;
        private var _payBuff:FightContainerBuff;
        private var _consortiaBuff:FightContainerBuff;
        private var _cardBuff:FightContainerBuff;
        private var _name:String = "";
        private var _livingID:int;
        private var _team:int;
        private var _fallingType:int = 0;
        protected var _pos:Point = new Point(0, 0);
        protected var _shootPos:Point = new Point(0, 0);
        private var _direction:int = 1;
        private var _maxBlood:int;
        private var _blood:int;
        private var _isFrozen:Boolean;
        private var _isGemGlow:Boolean;
        private var _gemDefense:Boolean;
        private var _isHidden:Boolean;
        private var _isNoNole:Boolean;
        protected var _lockState:Boolean;
        private var _dieFightBuffEnabled:Boolean = false;
        protected var _lockType:int = 1;
        protected var _isLiving:Boolean;
        private var _playerAngle:Number = 0;
        private var _actionMovieName:String;
        private var _isMoving:Boolean;
        public var isFalling:Boolean;
        private var _actionManager:ActionManager;
        private var _actionMovie:Bitmap;
        private var _thumbnail:BitmapData;
        private var _defaultAction:String = "";
        private var _cmdList:Dictionary;
        private var _shootInterval:int = Player.SHOOT_INTERVAL;
        protected var _psychic:int = 0;
        protected var _energy:Number = 1;
        private var _forbidMoving:Boolean = false;
        public var route:Vector.<Point>;
        private var _fightToolBoxSkill:Boolean = false;
        private var _isReady:Boolean;
        private var _lastBombIndex:int = -1;
        private var _isShoot:Boolean;

        public function Living(_arg_1:int, _arg_2:int, _arg_3:int)
        {
            this._livingID = _arg_1;
            this._team = _arg_2;
            this._maxBlood = _arg_3;
            this._actionManager = new ActionManager();
            this._mirariEffects = new DictionaryData();
            this.reset();
        }

        public function get MirariEffects():DictionaryData
        {
            return (this._mirariEffects);
        }

        public function get fightPower():Number
        {
            return (this._fightPower);
        }

        public function set fightPower(_arg_1:Number):void
        {
            this._fightPower = _arg_1;
            dispatchEvent(new LivingEvent(LivingEvent.FIGHTPOWER_CHANGE));
        }

        public function get currentSelectId():int
        {
            return (this._currentSelectId);
        }

        public function set currentSelectId(_arg_1:int):void
        {
            this._currentSelectId = _arg_1;
            dispatchEvent(new LivingEvent(LivingEvent.WISHSELECT_CHANGE));
        }

        public function get isBoss():Boolean
        {
            return (((this.typeLiving == LivingTypesEnum.SIMPLE_BOSS) || (this.typeLiving == LivingTypesEnum.SIMPLE_BOSS_NORMAL)) || (this.typeLiving == LivingTypesEnum.SIMPLE_BOSS_HARD));
        }

        public function reset():void
        {
            this._blood = this._maxBlood;
            this._isLiving = true;
            this._isFrozen = false;
            this._gemDefense = false;
            this._isHidden = false;
            this._isNoNole = false;
            this.isLockAngle = false;
            this._localBuffs = new Vector.<FightBuffInfo>();
            this._turnBuffs = new Vector.<FightBuffInfo>();
            this._petBuffs = new Vector.<FightBuffInfo>();
            ObjectUtils.disposeObject(this._payBuff);
            this._payBuff = null;
            ObjectUtils.disposeObject(this._consortiaBuff);
            this._consortiaBuff = null;
            ObjectUtils.disposeObject(this._cardBuff);
            this._cardBuff = null;
        }

        public function clearEffectIcon():void
        {
            this._mirariEffects.clear();
        }

        public function set isLockFly(_arg_1:Boolean):void
        {
            this._isLockFly = _arg_1;
            dispatchEvent(new LivingEvent(LivingEvent.LOCKFLY_CHANGED, 0, 0, this._isLockFly));
        }

        public function get isLockFly():Boolean
        {
            return (this._isLockFly);
        }

        public function get isLockAngle():Boolean
        {
            return (this._isLockAngle);
        }

        public function set isLockAngle(_arg_1:Boolean):void
        {
            if (this._isLockAngle == _arg_1)
            {
                return;
            };
            var _local_2:int;
            var _local_3:int;
            if (this._isLockAngle)
            {
                _local_2 = 1;
            };
            if (_arg_1)
            {
                _local_3 = 1;
            };
            this._isLockAngle = _arg_1;
            dispatchEvent(new LivingEvent(LivingEvent.LOCKANGLE_CHANGE, _local_3, _local_2));
        }

        public function hasEffect(_arg_1:BaseMirariEffectIcon):Boolean
        {
            return (!(this._mirariEffects[String(_arg_1.mirariType)] == null));
        }

        public function get localBuffs():Vector.<FightBuffInfo>
        {
            return (this._localBuffs);
        }

        public function get turnBuffs():Vector.<FightBuffInfo>
        {
            return (this._turnBuffs);
        }

        public function get petBuffs():Vector.<FightBuffInfo>
        {
            return (this._petBuffs);
        }

        private function addPayBuff(_arg_1:FightBuffInfo):void
        {
            if (this._payBuff == null)
            {
                this._payBuff = new FightContainerBuff(-1);
                this._localBuffs.unshift(this._payBuff);
            };
            this._payBuff.addFightBuff(_arg_1);
        }

        private function addConsortiaBuff(_arg_1:int, _arg_2:FightBuffInfo):void
        {
            this._consortiaBuff = new FightContainerBuff(_arg_1, BuffType.CONSORTIA);
            this._consortiaBuff.data = _arg_2.data;
            this._consortiaBuff.displayid = _arg_2.displayid;
            this._localBuffs.unshift(this._consortiaBuff);
            this._consortiaBuff.addFightBuff(_arg_2);
        }

        private function addCardBuff(_arg_1:FightBuffInfo):void
        {
            if (this._cardBuff == null)
            {
                this._cardBuff = new FightContainerBuff(-1, BuffType.CARD_BUFF);
                this._localBuffs.unshift(this._cardBuff);
            };
            this._cardBuff.addFightBuff(_arg_1);
        }

        public function addBuff(_arg_1:FightBuffInfo):void
        {
            _arg_1.isSelf = this.isSelf;
            if (BuffType.isConsortiaBuff(_arg_1))
            {
                this.addConsortiaBuff(_arg_1.displayid, _arg_1);
                return;
            };
            if (BuffType.isPayBuff(_arg_1))
            {
                this.addPayBuff(_arg_1);
                return;
            };
            if (BuffType.isCardBuff(_arg_1))
            {
                this.addCardBuff(_arg_1);
                return;
            };
            if (_arg_1.type == BuffType.Local)
            {
                this._localBuffs.push(_arg_1);
            }
            else
            {
                if (_arg_1.type == BuffType.MILITARY_BUFF)
                {
                    this._localBuffs.push(_arg_1);
                }
                else
                {
                    if (_arg_1.type == BuffType.ARENA_BUFF)
                    {
                        this._localBuffs.push(_arg_1);
                    }
                    else
                    {
                        if (this.hasBuff(_arg_1, this._turnBuffs))
                        {
                            return;
                        };
                        this._turnBuffs.push(_arg_1);
                    };
                };
            };
            _arg_1.execute(this);
            dispatchEvent(new LivingEvent(LivingEvent.BUFF_CHANGED, 0, 0, _arg_1.type));
        }

        public function addPetBuff(_arg_1:FightBuffInfo):void
        {
            var _local_2:Boolean;
            var _local_3:FightBuffInfo;
            if (_arg_1.buffPic != "-1")
            {
                _local_2 = false;
                for each (_local_3 in this._petBuffs)
                {
                    if (_local_3.id == _arg_1.id)
                    {
                        _local_3.Count++;
                        _local_2 = true;
                        break;
                    };
                };
                if ((!(_local_2)))
                {
                    this._petBuffs.push(_arg_1);
                };
            }
            else
            {
                this._noPicPetBuff.add(_arg_1.id, true);
            };
            _arg_1.execute(this);
            dispatchEvent(new LivingEvent(LivingEvent.BUFF_CHANGED, 0, 0, _arg_1.type));
        }

        public function removePetBuff(_arg_1:FightBuffInfo):void
        {
            var _local_2:int = this._petBuffs.length;
            var _local_3:int = _arg_1.id;
            var _local_4:int;
            while (_local_4 < _local_2)
            {
                if (this._petBuffs[_local_4].id == _local_3)
                {
                    this._petBuffs[_local_4].unExecute(this);
                    this._petBuffs.splice(_local_4, 1);
                    dispatchEvent(new LivingEvent(LivingEvent.BUFF_CHANGED, 0, 0, _arg_1.type));
                    break;
                };
                _local_4++;
            };
            if (((_arg_1.buffPic == "-1") && (this._noPicPetBuff[_arg_1.id])))
            {
                this._noPicPetBuff.remove(_arg_1.id);
                _arg_1.unExecute(this);
            };
        }

        private function hasBuff(_arg_1:FightBuffInfo, _arg_2:Vector.<FightBuffInfo>):Boolean
        {
            var _local_3:FightBuffInfo;
            for each (_local_3 in _arg_2)
            {
                if (_local_3.id == _arg_1.id)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function removeBuff(_arg_1:int):void
        {
            var _local_2:Vector.<FightBuffInfo>;
            var _local_3:int;
            if (((BuffType.isLocalBuffByID(_arg_1)) || (BuffType.isMilitaryBuff(_arg_1))))
            {
                _local_2 = this._localBuffs;
                _local_3 = BuffType.Local;
            }
            else
            {
                _local_2 = this._turnBuffs;
                _local_3 = BuffType.Turn;
            };
            var _local_4:int = _local_2.length;
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                if (_local_2[_local_5].id == _arg_1)
                {
                    _local_2[_local_5].unExecute(this);
                    _local_2.splice(_local_5, 1);
                    if (_local_3 == BuffType.Local)
                    {
                        this._localBuffs = this._localBuffs.sort(this.buffCompare);
                    }
                    else
                    {
                        this._turnBuffs = this._turnBuffs.sort(this.buffCompare);
                    };
                    dispatchEvent(new LivingEvent(LivingEvent.BUFF_CHANGED, 0, 0, _local_3));
                    return;
                };
                _local_5++;
            };
        }

        protected function buffCompare(_arg_1:FightBuffInfo, _arg_2:FightBuffInfo):Number
        {
            if (_arg_1.priority == _arg_2.priority)
            {
                return (0);
            };
            if (_arg_1.priority < _arg_2.priority)
            {
                return (1);
            };
            return (-1);
        }

        public function handleMirariEffect(_arg_1:BaseMirariEffectIcon):void
        {
            if (_arg_1.single)
            {
                if ((!(this.hasEffect(_arg_1))))
                {
                    this._mirariEffects.add(_arg_1.mirariType, _arg_1);
                };
            }
            else
            {
                this._mirariEffects.add(_arg_1.mirariType, _arg_1);
            };
            _arg_1.excuteEffect(this);
        }

        public function removeMirariEffect(_arg_1:BaseMirariEffectIcon):void
        {
            _arg_1.dispose();
            this._mirariEffects.remove(_arg_1.mirariType);
            _arg_1.unExcuteEffect(this);
        }

        public function dispose():void
        {
            this.isExist = false;
            if (this._actionMovie)
            {
                if (this._actionMovie.parent)
                {
                    this._actionMovie.parent.removeChild(this._actionMovie);
                };
                this._actionMovie.bitmapData.dispose();
            };
            this._actionMovie = null;
            if (this._thumbnail)
            {
                this._thumbnail.dispose();
            };
            this._thumbnail = null;
            this.character = null;
            if (this._mirariEffects)
            {
                this._mirariEffects.clear();
            };
            this._mirariEffects = null;
            if (this._actionManager)
            {
                this._actionManager.clear();
            };
            this._actionManager = null;
        }

        public function set name(_arg_1:String):void
        {
            this._name = _arg_1;
        }

        public function get name():String
        {
            return (this._name);
        }

        public function get LivingID():int
        {
            return (this._livingID);
        }

        public function get team():int
        {
            return (this._team);
        }

        public function set team(_arg_1:int):void
        {
            this._team = _arg_1;
        }

        public function set fallingType(_arg_1:int):void
        {
            this._fallingType = 0;
        }

        public function get fallingType():int
        {
            return (this._fallingType);
        }

        public function get onChange():Boolean
        {
            return (this._onChange);
        }

        public function set onChange(_arg_1:Boolean):void
        {
            this._onChange = _arg_1;
        }

        public function get pos():Point
        {
            return (this._pos);
        }

        public function set pos(_arg_1:Point):void
        {
            if ((!(_arg_1)))
            {
                return;
            };
            if (this._pos.equals(_arg_1) == false)
            {
                this._pos = _arg_1;
                dispatchEvent(new LivingEvent(LivingEvent.POS_CHANGED));
            };
        }

        public function get shootPos():Point
        {
            return (new Point((-(this._shootPos.x) * this.direction), this._shootPos.y));
        }

        public function set shootPos(_arg_1:Point):void
        {
            this._shootPos = _arg_1;
        }

        public function get direction():int
        {
            return (this._direction);
        }

        public function set direction(_arg_1:int):void
        {
            if (this._direction == _arg_1)
            {
                return;
            };
            this._direction = _arg_1;
            this.sendCommand("changeDir");
            dispatchEvent(new LivingEvent(LivingEvent.DIR_CHANGED));
        }

        public function get maxBlood():int
        {
            return (this._maxBlood);
        }

        public function set maxBlood(_arg_1:int):void
        {
            this._maxBlood = _arg_1;
            dispatchEvent(new LivingEvent(LivingEvent.MAX_HP_CHANGED));
        }

        public function get blood():int
        {
            return (this._blood);
        }

        public function set blood(_arg_1:int):void
        {
            this._blood = ((_arg_1 > this.maxBlood) ? this.maxBlood : _arg_1);
        }

        public function initBlood(_arg_1:int):void
        {
            this.blood = _arg_1;
            dispatchEvent(new LivingEvent(LivingEvent.BLOOD_CHANGED, _arg_1, 0, 5));
        }

        public function get isFrozen():Boolean
        {
            return (this._isFrozen);
        }

        public function set isFrozen(_arg_1:Boolean):void
        {
            if (this._isFrozen == _arg_1)
            {
                return;
            };
            this._isFrozen = _arg_1;
            dispatchEvent(new LivingEvent(LivingEvent.FORZEN_CHANGED));
        }

        public function get isGemGlow():Boolean
        {
            return (this._isGemGlow);
        }

        public function set isGemGlow(_arg_1:Boolean):void
        {
            if (this._isGemGlow != _arg_1)
            {
                this._isGemGlow = _arg_1;
                dispatchEvent(new LivingEvent(LivingEvent.GEM_GLOW_CHANGED));
            };
        }

        public function get gemDefense():Boolean
        {
            return (this._gemDefense);
        }

        public function set gemDefense(_arg_1:Boolean):void
        {
            if (this._gemDefense == _arg_1)
            {
                return;
            };
            this._gemDefense = _arg_1;
            dispatchEvent(new LivingEvent(LivingEvent.GEM_DEFENSE_CHANGED));
        }

        public function get isHidden():Boolean
        {
            return (this._isHidden);
        }

        public function set isHidden(_arg_1:Boolean):void
        {
            if (_arg_1 == this._isHidden)
            {
                return;
            };
            this._isHidden = _arg_1;
            dispatchEvent(new LivingEvent(LivingEvent.HIDDEN_CHANGED));
        }

        public function get isNoNole():Boolean
        {
            return (this._isNoNole);
        }

        public function set isNoNole(_arg_1:Boolean):void
        {
            if (this._isNoNole != _arg_1)
            {
                this._isNoNole = _arg_1;
                if (this._isNoNole)
                {
                    this.addBuff(BuffManager.creatBuff(BuffType.NoHole));
                }
                else
                {
                    this.removeBuff(BuffType.NoHole);
                };
            };
        }

        public function set LockState(_arg_1:Boolean):void
        {
            if (this._lockState != _arg_1)
            {
                this._lockState = _arg_1;
                if (this._lockState)
                {
                    if ((((this.LockType == 1) || (this.LockType == 2)) || (this.LockType == 3)))
                    {
                        this.addBuff(BuffManager.creatBuff(BuffType.LockState));
                    };
                }
                else
                {
                    this.removeBuff(BuffType.LockState);
                };
            };
        }

        public function get LockState():Boolean
        {
            return (this._lockState);
        }

        public function set DieFightBuffEnabled(_arg_1:Boolean):void
        {
            if (this._dieFightBuffEnabled != _arg_1)
            {
                this._dieFightBuffEnabled = _arg_1;
                if (this._dieFightBuffEnabled)
                {
                    this.addBuff(BuffManager.creatBuff(BuffType.DieFight));
                }
                else
                {
                    this.removeBuff(BuffType.DieFight);
                };
            };
        }

        public function get DieFightBuffEnabled():Boolean
        {
            return (this._dieFightBuffEnabled);
        }

        public function set LockType(_arg_1:int):void
        {
            this._lockType = _arg_1;
        }

        public function get LockType():int
        {
            return (this._lockType);
        }

        public function get isLiving():Boolean
        {
            return (this._isLiving);
        }

        public function die(_arg_1:Boolean=true):void
        {
            if (this._isLiving)
            {
                this._isLiving = false;
                dispatchEvent(new LivingEvent(LivingEvent.DIE, 0, 0, _arg_1));
                this._turnBuffs = new Vector.<FightBuffInfo>();
                dispatchEvent(new LivingEvent(LivingEvent.BUFF_CHANGED, 0, 0, BuffType.Turn));
                while (GameManager.Instance.dropGoodslist.length > 0)
                {
                    GameManager.Instance.dropGoodslist.pop().start();
                };
            };
        }

        public function get playerAngle():Number
        {
            return (this._playerAngle);
        }

        public function set playerAngle(_arg_1:Number):void
        {
            this._playerAngle = _arg_1;
            dispatchEvent(new LivingEvent(LivingEvent.ANGLE_CHANGED));
        }

        public function get actionMovieName():String
        {
            return (this._actionMovieName);
        }

        public function set actionMovieName(_arg_1:String):void
        {
            this._actionMovieName = _arg_1;
        }

        public function get isMoving():Boolean
        {
            return (this._isMoving);
        }

        public function set isMoving(_arg_1:Boolean):void
        {
            this._isMoving = _arg_1;
        }

        public function updateBlood(_arg_1:int, _arg_2:int, _arg_3:int=0, _arg_4:int=-1):void
        {
            var _local_5:int;
            var _local_6:int;
            if ((!(this.isLiving)))
            {
                return;
            };
            if (_arg_2 == WOUND)
            {
                if (((_arg_4 == -1) || (_arg_4 > this._lastBombIndex)))
                {
                    this._blood = _arg_1;
                };
                dispatchEvent(new LivingEvent(LivingEvent.BLOOD_CHANGED, _arg_1, this._blood, _arg_2, _arg_3));
            }
            else
            {
                if (_arg_2 == FLASH_BACK)
                {
                    _local_5 = this._blood;
                    this._blood = (this._blood - _arg_3);
                    dispatchEvent(new LivingEvent(LivingEvent.BLOOD_CHANGED, this._blood, _local_5, _arg_2, _arg_3));
                }
                else
                {
                    if (((!(this._blood == _arg_1)) || (GameManager.Instance.Current.gameMode == 17)))
                    {
                        _local_6 = this._blood;
                        this.blood = _arg_1;
                        if (((!(_arg_2 == SUICIDE)) && (this._isLiving)))
                        {
                            dispatchEvent(new LivingEvent(LivingEvent.BLOOD_CHANGED, _arg_1, _local_6, _arg_2, _arg_3));
                        };
                    }
                    else
                    {
                        if (((_arg_2 == 0) && (_arg_1 >= this._blood)))
                        {
                            dispatchEvent(new LivingEvent(LivingEvent.BLOOD_CHANGED, _arg_1, this._blood, _arg_2, _arg_3));
                        };
                    };
                };
            };
            if (this._blood <= 0)
            {
                this._blood = 0;
                this.die((!(_arg_2 == SUICIDE)));
            };
        }

        public function get actionCount():int
        {
            if (this._actionManager)
            {
                return (this._actionManager.actionCount);
            };
            return (0);
        }

        public function traceCurrentAction():void
        {
            this._actionManager.traceAllRemainAction();
        }

        public function act(_arg_1:BaseAction):void
        {
            if (((_arg_1) && (this._actionManager)))
            {
                this._actionManager.act(_arg_1);
            };
        }

        public function update():void
        {
            if (this._actionManager != null)
            {
                this._actionManager.execute();
            };
        }

        public function actionManagerClear():void
        {
            this._actionManager.clear();
        }

        public function excuteAtOnce():void
        {
            this._actionManager.executeAtOnce();
            this._actionManager.clear();
        }

        public function set actionMovieBitmap(_arg_1:Bitmap):void
        {
            this._actionMovie = _arg_1;
        }

        public function get actionMovieBitmap():Bitmap
        {
            return (this._actionMovie);
        }

        public function isPlayer():Boolean
        {
            return (false);
        }

        public function get isSelf():Boolean
        {
            return (false);
        }

        public function get playerInfo():PlayerInfo
        {
            return (null);
        }

        public function startMoving():void
        {
            dispatchEvent(new LivingEvent(LivingEvent.START_MOVING));
        }

        public function beginNewTurn():void
        {
            this._isShoot = false;
            dispatchEvent(new LivingEvent(LivingEvent.BEGIN_NEW_TURN));
        }

        public function shoot(_arg_1:Array, _arg_2:CrazyTankSocketEvent):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.SHOOT, 0, 0, _arg_1, _arg_2));
            this.mIsReadyForShootting = false;
        }

        public function doPrepare():void
        {
            if ((!(this.mIsReadyForShootting)))
            {
                dispatchEvent(new LivingEvent(LivingEvent.PREPARE_SHOOT));
            };
            this.mIsReadyForShootting = true;
        }

        public function beat(_arg_1:Array):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.BEAT, 0, 0, _arg_1));
        }

        public function beatenBy(_arg_1:Living):void
        {
            _arg_1.addEventListener(LivingEvent.BEAT, this.__beatenBy);
        }

        private function __beatenBy(_arg_1:LivingEvent):void
        {
            var _local_2:Living = _arg_1.paras[1];
            var _local_3:int = _arg_1.paras[2];
            var _local_4:int = _arg_1.value;
            var _local_5:int = _arg_1.paras[3];
            if (this.isLiving)
            {
                this.isHidden = false;
                this.showAttackEffect(_local_5);
                this.updateBlood(_local_4, 3, _local_3);
            };
        }

        public function transmit(_arg_1:Point):void
        {
            if (this._pos.equals(_arg_1) == false)
            {
                this._pos = _arg_1;
                dispatchEvent(new LivingEvent(LivingEvent.POS_CHANGED));
            };
        }

        public function showAttackEffect(_arg_1:int):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.SHOW_ATTACK_EFFECT, 0, 0, _arg_1));
        }

        public function moveTo(_arg_1:Number, _arg_2:Point, _arg_3:Number, _arg_4:Boolean, _arg_5:String="", _arg_6:int=3, _arg_7:String=""):void
        {
            if (((this.isPlayer()) || (this._isLiving)))
            {
                if (_arg_2.x > this._pos.x)
                {
                    this.direction = 1;
                }
                else
                {
                    this.direction = -1;
                };
                dispatchEvent(new LivingEvent(LivingEvent.MOVE_TO, 0, 0, _arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7));
            };
        }

        public function changePos(_arg_1:Point, _arg_2:String=""):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.CHANGE_POS, 0, 0, _arg_1));
        }

        public function fallTo(_arg_1:Point, _arg_2:int, _arg_3:String="", _arg_4:int=0):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.FALL, 0, 0, _arg_1, _arg_2, _arg_3, _arg_4));
        }

        public function jumpTo(_arg_1:Point, _arg_2:int, _arg_3:String="", _arg_4:int=0):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.JUMP, 0, 0, _arg_1, _arg_2, _arg_3, _arg_4));
        }

        public function set State(_arg_1:int):void
        {
            if (this._state == _arg_1)
            {
                return;
            };
            this._state = _arg_1;
            dispatchEvent(new LivingEvent(LivingEvent.CHANGE_STATE));
        }

        public function get State():int
        {
            return (this._state);
        }

        public function say(_arg_1:String, _arg_2:int=0):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.SAY, 0, 0, _arg_1, _arg_2));
        }

        public function playMovie(_arg_1:String, _arg_2:Function=null, _arg_3:Array=null):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.PLAY_MOVIE, 0, 0, _arg_1, _arg_2, _arg_3));
        }

        public function turnRotation(_arg_1:int, _arg_2:int, _arg_3:String):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.TURN_ROTATION, 0, 0, _arg_1, _arg_2, _arg_3));
        }

        public function set defaultAction(_arg_1:String):void
        {
            this._defaultAction = _arg_1;
            dispatchEvent(new LivingEvent(LivingEvent.DEFAULT_ACTION_CHANGED));
        }

        public function get defaultAction():String
        {
            return (this._defaultAction);
        }

        public function doDefaultAction():void
        {
            this.playMovie(this._defaultAction);
        }

        public function pick(_arg_1:SimpleBox):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.BOX_PICK, 0, 0, _arg_1));
        }

        private function cmdX(_arg_1:int):void
        {
        }

        public function get commandList():Dictionary
        {
            if ((!(this._cmdList)))
            {
                this.initCommand();
            };
            return (this._cmdList);
        }

        public function initCommand():void
        {
            this._cmdList = new Dictionary();
            this._cmdList["x"] = this.cmdX;
        }

        public function command(_arg_1:String, _arg_2:*):Boolean
        {
            if (this.commandList[_arg_1])
            {
                var _local_3:* = this.commandList;
                (_local_3[_arg_1](_arg_2));
            };
            return (true);
        }

        public function sendCommand(_arg_1:String, _arg_2:Object=null):void
        {
            dispatchEvent(new LivingCommandEvent("someCommand"));
        }

        public function setProperty(property:String, value:String):void
        {
            var vo:StringObject = new StringObject(value);
            switch (property)
            {
                default:
                    try
                    {
                        if (vo.isBoolean)
                        {
                            this[property] = vo.getBoolean();
                            return;
                        };
                        if (vo.isInt)
                        {
                            this[property] = vo.getInt();
                            return;
                        };
                        this[property] = vo;
                    }
                    catch(e:Error)
                    {
                    };
            };
        }

        public function bomd():void
        {
            dispatchEvent(new LivingEvent(LivingEvent.BOMBED));
        }

        public function showEffect(_arg_1:String):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.PLAYSKILLMOVIE, 0, 0, _arg_1));
        }

        public function showBuffEffect(_arg_1:String, _arg_2:int):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.PLAY_CONTINUOUS_EFFECT, 0, 0, _arg_1, _arg_2));
        }

        public function removeBuffEffect(_arg_1:int):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.REMOVE_CONTINUOUS_EFFECT, 0, 0, _arg_1));
        }

        public function removeSkillMovie(_arg_1:int):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.REMOVESKILLMOVIE, 0, 0, _arg_1));
        }

        public function applySkill(_arg_1:int, ... _args):void
        {
            var _local_3:LivingEvent;
            if (((_args == null) || (_args.length == 0)))
            {
                _local_3 = new LivingEvent(LivingEvent.APPLY_SKILL, 0, 0, _arg_1);
            }
            else
            {
                if (_args.length == 1)
                {
                    _local_3 = new LivingEvent(LivingEvent.APPLY_SKILL, 0, 0, _arg_1, _args[0]);
                }
                else
                {
                    if (_args.length == 2)
                    {
                        _local_3 = new LivingEvent(LivingEvent.APPLY_SKILL, 0, 0, _arg_1, _args[0], _args[1]);
                    }
                    else
                    {
                        if (_args.length == 3)
                        {
                            _local_3 = new LivingEvent(LivingEvent.APPLY_SKILL, 0, 0, _arg_1, _args[0], _args[1], _args[2]);
                        }
                        else
                        {
                            if (_args.length == 4)
                            {
                                _local_3 = new LivingEvent(LivingEvent.APPLY_SKILL, 0, 0, _arg_1, _args[0], _args[1], _args[2], _args[3]);
                            };
                        };
                    };
                };
            };
            dispatchEvent(_local_3);
        }

        public function get shootInterval():int
        {
            return (this._shootInterval);
        }

        public function set shootInterval(_arg_1:int):void
        {
            this._shootInterval = _arg_1;
        }

        public function get maxPsychic():int
        {
            return (Player.MaxPsychic);
        }

        public function get psychic():int
        {
            return ((this._psychic >= 0) ? this._psychic : 0);
        }

        public function set psychic(_arg_1:int):void
        {
            if (((!(this._psychic == _arg_1)) && (_arg_1 <= this.maxPsychic)))
            {
                this._psychic = _arg_1;
                dispatchEvent(new LivingEvent(LivingEvent.PSYCHIC_CHANGED));
            };
        }

        public function get energy():Number
        {
            return (this._energy);
        }

        public function set energy(_arg_1:Number):void
        {
            if (((!(_arg_1 == this._energy)) && (_arg_1 <= this.maxEnergy)))
            {
                this._energy = ((_arg_1 >= 0) ? _arg_1 : 0);
                dispatchEvent(new LivingEvent(LivingEvent.ENERGY_CHANGED));
            };
        }

        public function get forbidMoving():Boolean
        {
            return (this._forbidMoving);
        }

        public function set forbidMoving(_arg_1:Boolean):void
        {
            this._forbidMoving = _arg_1;
        }

        public function get thumbnail():BitmapData
        {
            return (this._thumbnail);
        }

        public function set thumbnail(_arg_1:BitmapData):void
        {
            if (this._thumbnail != null)
            {
                this._thumbnail.dispose();
            };
            this._thumbnail = _arg_1;
            dispatchEvent(new Event(Event.COMPLETE));
        }

        public function explainType(_arg_1:int):void
        {
            this._fightToolBoxSkill = (!(((1 << (FIGHT_TOOL_SKILL - 1)) & _arg_1) == 0));
        }

        public function get fightToolBoxSkill():Boolean
        {
            return (this._fightToolBoxSkill);
        }

        public function doDieFightLight():void
        {
            dispatchEvent(new LivingEvent(LivingEvent.DO_DIE_FIGHT));
        }

        public function get isReady():Boolean
        {
            return (this._isReady);
        }

        public function set isReady(_arg_1:Boolean):void
        {
            if (this._isReady == _arg_1)
            {
                return;
            };
            this._isReady = _arg_1;
            dispatchEvent(new LivingEvent(LivingEvent.READY_FOR_PLAYING));
        }

        public function getHorizonDistance(_arg_1:Living):int
        {
            if (_arg_1)
            {
                return (Math.abs((this.pos.x - _arg_1.pos.x)));
            };
            return (0);
        }

        public function get isShoot():Boolean
        {
            return (this._isShoot);
        }

        public function set isShoot(_arg_1:Boolean):void
        {
            this._isShoot = _arg_1;
        }

        public function get lastBombIndex():int
        {
            return (this._lastBombIndex);
        }

        public function set lastBombIndex(_arg_1:int):void
        {
            this._lastBombIndex = _arg_1;
        }


    }
}//package game.model

