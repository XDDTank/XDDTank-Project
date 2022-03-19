// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.model.LocalPlayer

package game.model
{
    import flash.utils.Timer;
    import game.objects.LivingTypesEnum;
    import ddt.data.player.SelfInfo;
    import ddt.events.LivingEvent;
    import flash.geom.Point;
    import ddt.events.GameEvent;
    import ddt.manager.SocketManager;
    import game.objects.SimpleBox;
    import game.GameManager;
    import road7th.data.DictionaryData;
    import flash.events.TimerEvent;
    import ddt.manager.ChatManager;
    import ddt.data.EquipType;
    import ddt.data.UsePropErrorCode;
    import ddt.manager.SavePointManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.ItemManager;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.PropInfo;
    import ddt.manager.PlayerManager;
    import flash.display.DisplayObject;
    import ddt.manager.SoundManager;
    import ddt.manager.GameInSocketOut;
    import flash.events.Event;
    import ddt.manager.SharedManager;

    [Event(name="energyChanged", type="ddt.events.LivingEvent")]
    [Event(name="gunangleChanged", type="ddt.events.LivingEvent")]
    [Event(name="forceChanged", type="ddt.events.LivingEvent")]
    [Event(name="skip", type="ddt.events.LivingEvent")]
    [Event(name="sendShootAction", type="ddt.events.LivingEvent")]
    [Event(name="showMark", type="ddt.events.LivingEvent")]
    public class LocalPlayer extends Player 
    {

        public static const SET_ENABLE:String = "setEnable";

        public var _numObject:Object;
        private var _isUsedItem:Boolean = false;
        private var _isUsedPetSkillWithNoItem:Boolean = false;
        private var _usingFightToolBoxSkill:Boolean = false;
        public var shootType:int = 0;
        public var shootCount:int = 0;
        private var _allBombCount:int;
        public var shootTime:int;
        private var _gunAngle:Number = 0;
        private var _arrowRotation:Number;
        private var _force:Number = 0;
        private var _iscalcForce:Boolean = false;
        private var _selfDieTimer:Timer;
        public var isLast:Boolean = true;
        private var _selfDieTimeDelayPassed:Boolean = false;
        private var _flyCoolDown:int = 0;
        private var _flyEnabled:Boolean = true;
        private var _deputyWeaponEnabled:Boolean = true;
        private var _deputyWeaponCount:int;
        private var _fightToolBoxCount:int;
        private var _blockDeputyWeapon:Boolean = false;
        private var _deputyWeaponCoolDown:int;
        public var twoKillEnabled:Boolean = true;
        public var soulPropCount:int = 0;
        private var _threeKillEnabled:Boolean = true;
        private var _spellKillEnabled:Boolean = true;
        private var _propEnabled:Boolean = true;
        private var _FightProEnabled:Boolean = true;
        private var _petSkillEnabled:Boolean = true;
        private var _soulPropEnabled:Boolean = true;
        private var _customPropEnabled:Boolean = true;
        private var _lockRightProp:Boolean = false;
        private var _rightPropEnabled:Boolean = true;
        private var _weaponPropEnbled:Boolean;
        private var _lockDeputyWeapon:Boolean = false;
        private var _lockFly:Boolean = false;
        private var _lockSpellKill:Boolean = false;
        private var _lockProp:Boolean;
        private var _mouseState:Boolean;
        private var _isBeginShoot:Boolean;
        public var canNormalShoot:Boolean = true;
        public var NewHandEnemyBlood:int;
        public var NewHandSelfBlood:int;
        public var NewHandHurtSelfCounter:int;
        public var NewHandHurtEnemyCounter:int;
        public var NewHandBeEnemyHurtCounter:int;
        public var NewHandBloodCounter:int;
        public var NewHandEnemyIsFrozen:Boolean;
        public var lastFireBombs:Array;

        public function LocalPlayer(_arg_1:SelfInfo, _arg_2:int, _arg_3:int, _arg_4:int)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            this._numObject = {};
            this.typeLiving = LivingTypesEnum.NORMAL_PLAYER;
        }

        public function get isUsedPetSkillWithNoItem():Boolean
        {
            return (this._isUsedPetSkillWithNoItem);
        }

        public function set isUsedPetSkillWithNoItem(_arg_1:Boolean):void
        {
            this._isUsedPetSkillWithNoItem = _arg_1;
        }

        public function get usingFightToolBoxSkill():Boolean
        {
            return (this._usingFightToolBoxSkill);
        }

        public function set usingFightToolBoxSkill(_arg_1:Boolean):void
        {
            this._usingFightToolBoxSkill = _arg_1;
        }

        public function get isUsedItem():Boolean
        {
            return (this._isUsedItem);
        }

        public function set isUsedItem(_arg_1:Boolean):void
        {
            this._isUsedItem = _arg_1;
        }

        public function get selfInfo():SelfInfo
        {
            return (playerInfo as SelfInfo);
        }

        public function showMark(_arg_1:int):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.SHOW_MARK, 0, 0, (_arg_1 - 1)));
        }

        override public function set pos(_arg_1:Point):void
        {
            if (_arg_1.equals(_pos) == false)
            {
                if (((isLiving) && (onChange == true)))
                {
                    energy = (energy - (Math.abs((_arg_1.x - _pos.x)) * powerRatio));
                };
                super.pos = _arg_1;
            };
        }

        public function set allBombCount(_arg_1:int):void
        {
            this._allBombCount = (this.shootCount * _arg_1);
        }

        public function get allBombCount():int
        {
            return (this._allBombCount);
        }

        public function manuallySetGunAngle(_arg_1:Number):Boolean
        {
            var _local_2:int = this.gunAngle;
            this.gunAngle = _arg_1;
            return (!(_local_2 == this.gunAngle));
        }

        public function get gunAngle():Number
        {
            return (this._gunAngle);
        }

        public function set gunAngle(_arg_1:Number):void
        {
            if (_arg_1 == this._gunAngle)
            {
                return;
            };
            if (((currentBomb == 3) && ((_arg_1 < 0) || (_arg_1 > 90))))
            {
                return;
            };
            if (((!(currentBomb == 3)) && (_arg_1 < currentWeapInfo.armMinAngle)))
            {
                this._gunAngle = currentWeapInfo.armMinAngle;
                return;
            };
            if (((!(currentBomb == 3)) && (_arg_1 > currentWeapInfo.armMaxAngle)))
            {
                this._gunAngle = currentWeapInfo.armMaxAngle;
                return;
            };
            this._gunAngle = _arg_1;
            dispatchEvent(new LivingEvent(LivingEvent.GUNANGLE_CHANGED));
        }

        public function get arrowRotation():Number
        {
            return (this._arrowRotation);
        }

        public function set arrowRotation(_arg_1:Number):void
        {
            this._arrowRotation = _arg_1;
            dispatchEvent(new GameEvent(GameEvent.MOUSE_MODEL_CHANGE_ANGLE));
        }

        public function calcBombAngle():Number
        {
            return ((direction > 0) ? (playerAngle - this._gunAngle) : ((playerAngle + this._gunAngle) - 180));
        }

        public function get force():Number
        {
            return (this._force);
        }

        public function set force(_arg_1:Number):void
        {
            this._force = Math.min(_arg_1, Player.FORCE_MAX);
            dispatchEvent(new LivingEvent(LivingEvent.FORCE_CHANGED));
        }

        override public function beginNewTurn():void
        {
            super.beginNewTurn();
            this.checkAngle();
            dispatchEvent(new LivingEvent(LivingEvent.GUNANGLE_CHANGED));
            this.shootType = 0;
            this._usingFightToolBoxSkill = false;
            this._isUsedItem = (this._isUsedPetSkillWithNoItem = false);
            this._isBeginShoot = false;
        }

        override public function beginShoot():void
        {
            super.beginShoot();
            this._isBeginShoot = true;
        }

        private function checkAngle():void
        {
            if ((this._gunAngle < currentWeapInfo.armMinAngle))
            {
                this.gunAngle = currentWeapInfo.armMinAngle;
                return;
            };
            if ((this._gunAngle > currentWeapInfo.armMaxAngle))
            {
                this.gunAngle = currentWeapInfo.armMaxAngle;
                return;
            };
        }

        public function skip():void
        {
            if (isAttacking)
            {
                stopAttacking();
                dispatchEvent(new LivingEvent(LivingEvent.SKIP));
            };
        }

        public function set iscalcForce(_arg_1:Boolean):void
        {
            if (this._iscalcForce == _arg_1)
            {
                return;
            };
            this._iscalcForce = _arg_1;
            dispatchEvent(new LivingEvent(LivingEvent.IS_CALCFORCE_CHANGE));
        }

        public function get iscalcForce():Boolean
        {
            return (this._iscalcForce);
        }

        public function sendShootAction(_arg_1:Number):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.SEND_SHOOT_ACTION, 0, 0, _arg_1));
        }

        public function canUseProp(_arg_1:TurnedLiving):Boolean
        {
            return (((this == _arg_1) && (!(LockState))) || ((!(isLiving)) && (team == _arg_1.team)));
        }

        override public function pick(_arg_1:SimpleBox):void
        {
            super.pick(_arg_1);
            if (_arg_1.isGhost)
            {
                psychic = (psychic + _arg_1.psychic);
            };
            SocketManager.Instance.out.sendGamePick(_arg_1.Id);
        }

        override protected function setWeaponInfo():void
        {
            super.setWeaponInfo();
            this.gunAngle = currentWeapInfo.armMinAngle;
        }

        override public function reset():void
        {
            super.reset();
            this.lockDeputyWeapon = (this.lockFly = (this.lockSpellKill = false));
            this.soulPropEnabled = (this.threeKillEnabled = (this.flyEnabled = (this.deputyWeaponEnabled = (this.rightPropEnabled = (this.customPropEnabled = (this.weaponPropEnbled = true))))));
            this._flyCoolDown = (this._deputyWeaponCoolDown = 0);
            if (currentWeapInfo)
            {
                this.gunAngle = currentWeapInfo.armMinAngle;
            };
        }

        public function updateCoolDown():void
        {
            this._flyCoolDown--;
            this._deputyWeaponCoolDown--;
        }

        override public function die(_arg_1:Boolean=true):void
        {
            var _local_3:Living;
            var _local_2:DictionaryData = GameManager.Instance.Current.findTeam(team);
            for each (_local_3 in _local_2)
            {
                if (((!(_local_3.isSelf)) && (_local_3.isLiving)))
                {
                    this.isLast = false;
                    break;
                };
            };
            super.die(_arg_1);
            this._selfDieTimer = new Timer(500, 1);
            this._selfDieTimer.start();
            this._selfDieTimer.addEventListener(TimerEvent.TIMER, this.__onDieDelayPassed);
            this.rightPropEnabled = (this.spellKillEnabled = (this.weaponPropEnbled = false));
            if (isSelf)
            {
                ChatManager.Instance.view.output.ghostState = _arg_1;
            };
        }

        private function __onDieDelayPassed(_arg_1:TimerEvent):void
        {
            this.removeSelfDieTimer();
            this._selfDieTimeDelayPassed = true;
        }

        private function removeSelfDieTimer():void
        {
            if (this._selfDieTimer == null)
            {
                return;
            };
            this._selfDieTimer.stop();
            this._selfDieTimer.removeEventListener(TimerEvent.TIMER, this.__onDieDelayPassed);
            this._selfDieTimer = null;
        }

        public function get selfDieTimeDelayPassed():Boolean
        {
            return (this._selfDieTimeDelayPassed);
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeSelfDieTimer();
        }

        override public function set isAttacking(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.updateCoolDown();
            };
            if ((((this._flyCoolDown <= 0) && (energy >= EquipType.FLY_ENERGY)) && (!(this._lockFly))))
            {
                this.flyEnabled = true;
            };
            if ((((((hasDeputyWeapon()) && (this._deputyWeaponCoolDown <= 0)) && (energy >= currentDeputyWeaponInfo.energy)) && (!(this._lockDeputyWeapon))) && (_isLiving)))
            {
                this.deputyWeaponEnabled = true;
            };
            this.soulPropEnabled = (this.propEnabled = (this.spellKillEnabled = (this.threeKillEnabled = true)));
            this.isUsedPetSkillWithNoItem = false;
            super.isAttacking = _arg_1;
        }

        public function get flyCoolDown():int
        {
            return (this._flyCoolDown);
        }

        public function useFly():String
        {
            if (((this.flyEnabled) && (_isAttacking)))
            {
                this.useFlyImp();
            }
            else
            {
                if ((!(_isAttacking)))
                {
                    return (UsePropErrorCode.NotAttacking);
                };
                if ((((this._lockFly) || (_lockState)) && (!(_lockType == 0))))
                {
                    return (UsePropErrorCode.LockState);
                };
                if (_isLiving)
                {
                    if (this._flyCoolDown > 0)
                    {
                        return (UsePropErrorCode.FlyNotCoolDown);
                    };
                    if (_energy < EquipType.FLY_ENERGY)
                    {
                        return (UsePropErrorCode.EmptyEnergy);
                    };
                };
            };
            return (UsePropErrorCode.None);
        }

        private function useFlyImp():void
        {
            if (SavePointManager.Instance.isInSavePoint(19))
            {
                this._flyCoolDown = 0;
            }
            else
            {
                this._flyCoolDown = EquipType.FLY_CD;
            };
            SocketManager.Instance.out.sendAirPlane();
            var _local_1:InventoryItemInfo = new InventoryItemInfo();
            var _local_2:ItemTemplateInfo = ItemManager.Instance.getTemplateById(10016);
            _local_1.TemplateID = _local_2.TemplateID;
            _local_1.Pic = "2";
            _local_1.Property4 = _local_2.Property4;
            var _local_3:PropInfo = new PropInfo(_local_1);
            this.useItem(_local_3.Template);
            currentBomb = 3;
            this.flyEnabled = false;
            this.rightPropEnabled = false;
            this.deputyWeaponEnabled = false;
            this.deputyWeaponEnabled = false;
            this.spellKillEnabled = false;
        }

        public function useFightKitskill():String
        {
            if ((!(_isAttacking)))
            {
                return (UsePropErrorCode.NotAttacking);
            };
            if (((((_isLiving) && (this.fightToolBoxCount > 0)) && (PlayerManager.Instance.Self.fightToolBoxSkillNum > 0)) && (PlayerManager.Instance.Self.isUseFightByVip)))
            {
                this._usingFightToolBoxSkill = true;
                this.fightToolBoxCount--;
                GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.FIGHT_TOOL_BOX));
                dispatchEvent(new LivingEvent(LivingEvent.BEGIN_SHOOT));
                SocketManager.Instance.out.sendUseFightKitSkill(PlayerManager.Instance.Self.fightVipLevel);
            };
            return (UsePropErrorCode.None);
        }

        public function get flyEnabled():Boolean
        {
            return ((((((_isLiving) && (!(this._lockFly))) && (this._flyEnabled)) && (this._flyCoolDown <= 0)) && (_energy >= EquipType.FLY_ENERGY)) && (SavePointManager.Instance.savePoints[18]));
        }

        public function set flyEnabled(_arg_1:Boolean):void
        {
            if (this._flyEnabled != _arg_1)
            {
                this._flyEnabled = _arg_1;
                dispatchEvent(new LivingEvent(LivingEvent.FLY_CHANGED));
            };
        }

        public function set deputyWeaponEnabled(_arg_1:Boolean):void
        {
            if (this._deputyWeaponEnabled != _arg_1)
            {
                this._deputyWeaponEnabled = _arg_1;
                dispatchEvent(new LivingEvent(LivingEvent.DEPUTYWEAPON_CHANGED));
            };
        }

        public function get deputyWeaponEnabled():Boolean
        {
            if (hasDeputyWeapon())
            {
                return (((((((_isLiving) && (!(this._lockDeputyWeapon))) && (!(this._blockDeputyWeapon))) && (this._deputyWeaponEnabled)) && (this._deputyWeaponCoolDown <= 0)) && (_energy >= currentDeputyWeaponInfo.energy)) && (!(isBoss)));
            };
            return (false);
        }

        public function get deputyWeaponCount():int
        {
            return (this._deputyWeaponCount);
        }

        public function set deputyWeaponCount(_arg_1:int):void
        {
            if (this._deputyWeaponCount != _arg_1)
            {
                this._deputyWeaponCount = _arg_1;
                dispatchEvent(new LivingEvent(LivingEvent.DEPUTYWEAPON_CHANGED));
            };
        }

        public function get fightToolBoxCount():int
        {
            return (this._fightToolBoxCount);
        }

        public function set fightToolBoxCount(_arg_1:int):void
        {
            this._fightToolBoxCount = _arg_1;
            this._fightToolBoxCount = ((this._fightToolBoxCount < 0) ? 0 : this._fightToolBoxCount);
            if (this._fightToolBoxCount == 0)
            {
                if (isAttacking)
                {
                    stopAttacking();
                };
            };
        }

        public function blockDeputyWeapon():void
        {
            this._blockDeputyWeapon = true;
            this._deputyWeaponCoolDown = 100000;
            this.deputyWeaponEnabled = false;
        }

        public function allowDeputyWeapon():void
        {
            this._blockDeputyWeapon = false;
            this.deputyWeaponEnabled = true;
        }

        private function useDeputyWeaponImp():void
        {
            this._deputyWeaponCoolDown = currentDeputyWeaponInfo.coolDown;
            SocketManager.Instance.out.useDeputyWeapon();
            var _local_1:DisplayObject = currentDeputyWeaponInfo.getDeputyWeaponIcon();
            _local_1.x = (_local_1.x + 7);
            useItemByIcon(_local_1);
            energy = (energy - Number(currentDeputyWeaponInfo.energy));
            if (((hasDeputyWeapon()) && (currentDeputyWeaponInfo.ballId > 0)))
            {
                currentBomb = currentDeputyWeaponInfo.ballId;
            };
            this.isUsedPetSkillWithNoItem = true;
            this.deputyWeaponEnabled = false;
            if (EquipType.isAngel(currentDeputyWeaponInfo.Template))
            {
                this.spellKillEnabled = false;
                this.flyEnabled = false;
                this.rightPropEnabled = false;
                this.weaponPropEnbled = false;
            };
        }

        public function get deputyWeaponCoolDown():int
        {
            return (this._deputyWeaponCoolDown);
        }

        public function useDeputyWeapon():String
        {
            SoundManager.instance.play("008");
            var _local_1:Number = Number(currentDeputyWeaponInfo.energy);
            if (((this.deputyWeaponEnabled) && (_isAttacking)))
            {
                this.useDeputyWeaponImp();
                this.spellKillEnabled = false;
                this.rightPropEnabled = false;
                this.weaponPropEnbled = false;
                this.customPropEnabled = false;
                this.lockFly = false;
            }
            else
            {
                if (hasDeputyWeapon())
                {
                    if ((!(_isAttacking)))
                    {
                        return (UsePropErrorCode.NotAttacking);
                    };
                    if ((((this._lockDeputyWeapon) || (_lockState)) && (!(_lockType == 0))))
                    {
                        return (UsePropErrorCode.LockState);
                    };
                    if (this._deputyWeaponCount <= 0)
                    {
                        return (UsePropErrorCode.DeputyWeaponEmpty);
                    };
                    if (this._deputyWeaponCoolDown > 0)
                    {
                        return (UsePropErrorCode.DeputyWeaponNotCoolDown);
                    };
                    if (_energy < _local_1)
                    {
                        return (UsePropErrorCode.EmptyEnergy);
                    };
                };
            };
            return (UsePropErrorCode.None);
        }

        override public function setDeputyWeaponInfo():void
        {
            super.setDeputyWeaponInfo();
        }

        public function useProp(_arg_1:PropInfo, _arg_2:int):String
        {
            if (_isLiving)
            {
                return (this.usePropAtLive(_arg_1, _arg_2));
            };
            return (this.usePropAtSoul(_arg_1, _arg_2));
        }

        private function updateNums(_arg_1:PropInfo):void
        {
            var _local_2:int;
            if (this._numObject.hasOwnProperty(_arg_1.TemplateID))
            {
                _local_2 = (this._numObject[_arg_1.TemplateID] as int);
            };
            _local_2++;
            this._numObject[_arg_1.TemplateID] = _local_2;
        }

        private function sendProp(_arg_1:int, _arg_2:PropInfo):void
        {
            this.useItem(_arg_2.Template);
            GameInSocketOut.sendUseProp(_arg_1, _arg_2.Place, _arg_2.Template.TemplateID);
            dispatchEvent(new Event(LocalPlayer.SET_ENABLE));
            this.twoKillEnabled = false;
        }

        private function pushUseProp(_arg_1:int, _arg_2:PropInfo):Boolean
        {
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_3:Boolean;
            if (((_arg_2.TemplateID == EquipType.ADD_TWO_ATTACK) || (_arg_2.TemplateID == EquipType.ADD_ONE_ATTACK)))
            {
                _local_4 = (this._numObject[_arg_2.TemplateID] as int);
                if (_local_4 == 2)
                {
                    this.sendProp(_arg_1, _arg_2);
                    _local_3 = true;
                }
                else
                {
                    if (_local_4 > 2)
                    {
                        _local_3 = true;
                    };
                };
            };
            if ((((_arg_2.TemplateID == EquipType.ADD_TWO_ATTACK) || (_arg_2.TemplateID == EquipType.ADD_ONE_ATTACK)) || (_arg_2.TemplateID == EquipType.THREEKILL)))
            {
                _local_5 = (this._numObject[EquipType.ADD_TWO_ATTACK] as int);
                _local_6 = (this._numObject[EquipType.THREEKILL] as int);
                _local_7 = (this._numObject[EquipType.ADD_ONE_ATTACK] as int);
                if (((_local_5 >= 1) && (_local_6 >= 1)))
                {
                    this.sendProp(_arg_1, _arg_2);
                    _local_3 = true;
                }
                else
                {
                    if (((_local_6 >= 1) && (_local_7 >= 1)))
                    {
                        this.sendProp(_arg_1, _arg_2);
                        _local_3 = true;
                    }
                    else
                    {
                        if (((_local_5 >= 1) && (_local_7 >= 1)))
                        {
                            this.sendProp(_arg_1, _arg_2);
                            _local_3 = true;
                        };
                    };
                };
            };
            return (_local_3);
        }

        public function clearPropArr():void
        {
            this._numObject = {};
            this.twoKillEnabled = true;
        }

        override public function set dander(_arg_1:int):void
        {
            super.dander = _arg_1;
        }

        private function usePropAtSoul(_arg_1:PropInfo, _arg_2:int):String
        {
            var _local_3:ItemTemplateInfo;
            if (this._soulPropEnabled)
            {
                if (this.soulPropCount >= MaxSoulPropUsedCount)
                {
                    ChatManager.Instance.sysChatYellow("鬼魂使用道具:最大次数");
                    return (UsePropErrorCode.SoulPropOverFlow);
                };
                if (_arg_2 == 2)
                {
                    this.useItem(_arg_1.Template);
                    GameInSocketOut.sendUseProp(_arg_2, _arg_1.Place, _arg_1.Template.TemplateID);
                    this.soulPropCount++;
                }
                else
                {
                    if (psychic < _arg_1.needPsychic)
                    {
                        return (UsePropErrorCode.EmptyPsychic);
                    };
                    _local_3 = _arg_1.Template;
                    if (((GameManager.Instance.Current.currentLiving.isBoss) && (((((_local_3.TemplateID == 10016) || (_local_3.TemplateID == 10017)) || (_local_3.TemplateID == 10018)) || (_local_3.TemplateID == 10015)) || (_local_3.TemplateID == 10022))))
                    {
                        return (UsePropErrorCode.CHAGNE_PEOPLE);
                    };
                    this.useItem(_arg_1.Template);
                    GameInSocketOut.sendUseProp(_arg_2, _arg_1.Place, _arg_1.Template.TemplateID);
                    psychic = (psychic - _arg_1.needPsychic);
                    this.soulPropCount++;
                };
            };
            return (UsePropErrorCode.None);
        }

        private function usePropAtLive(_arg_1:PropInfo, _arg_2:int):String
        {
            if (((!(_isLiving)) && (_arg_2 == 1)))
            {
                return (UsePropErrorCode.NotLiving);
            };
            if ((!(_isAttacking)))
            {
                return (UsePropErrorCode.NotAttacking);
            };
            if (_lockState)
            {
                if (_lockType != 0)
                {
                    return (UsePropErrorCode.LockState);
                };
            }
            else
            {
                if (_energy < _arg_1.needEnergy)
                {
                    return (UsePropErrorCode.EmptyEnergy);
                };
                this.updateNums(_arg_1);
                if ((((_arg_1.TemplateID == EquipType.ADD_TWO_ATTACK) || (_arg_1.TemplateID == EquipType.ADD_ONE_ATTACK)) || (_arg_1.TemplateID == EquipType.THREEKILL)))
                {
                    if ((!(this.twoKillEnabled)))
                    {
                        GameInSocketOut.sendUseProp(_arg_2, _arg_1.Place, _arg_1.Template.TemplateID);
                        return (UsePropErrorCode.Done);
                    };
                    if (this.pushUseProp(_arg_2, _arg_1))
                    {
                        return (UsePropErrorCode.Done);
                    };
                };
                if (_arg_1.TemplateID == EquipType.THREEKILL)
                {
                    if (this.threeKillEnabled)
                    {
                        this.useItem(_arg_1.Template);
                        GameInSocketOut.sendUseProp(_arg_2, _arg_1.Place, _arg_1.Template.TemplateID);
                        return (UsePropErrorCode.Done);
                    };
                }
                else
                {
                    this.useItem(_arg_1.Template);
                    GameInSocketOut.sendUseProp(_arg_2, _arg_1.Place, _arg_1.Template.TemplateID);
                    return (UsePropErrorCode.Done);
                };
            };
            return (UsePropErrorCode.None);
        }

        override public function useItem(_arg_1:ItemTemplateInfo):void
        {
            if (_arg_1.TemplateID == EquipType.THREEKILL)
            {
                this.useThreeKillImp();
            };
            super.useItem(_arg_1);
        }

        public function get threeKillEnabled():Boolean
        {
            return (((this._threeKillEnabled) && (this._propEnabled)) && (this._rightPropEnabled));
        }

        public function set threeKillEnabled(_arg_1:Boolean):void
        {
            if (this._threeKillEnabled != _arg_1)
            {
                this._threeKillEnabled = _arg_1;
                dispatchEvent(new LivingEvent(LivingEvent.THREEKILL_CHANGED));
            };
        }

        private function useThreeKillImp():void
        {
            this.threeKillEnabled = false;
            this.spellKillEnabled = false;
            this.deputyWeaponEnabled = false;
        }

        public function useSpellKill():String
        {
            if (((this.spellKillEnabled) && (_isAttacking)))
            {
                this.useSpellKillImp();
                return (UsePropErrorCode.Done);
            };
            return (UsePropErrorCode.None);
        }

        public function useSkillDirectly(_arg_1:int, _arg_2:int):void
        {
            if (isAttacking)
            {
                dispatchEvent(new LivingEvent(LivingEvent.USE_SKILL_DIRECTLY, 0, 0, _arg_1, _arg_2));
            };
        }

        private function useSpellKillImp():void
        {
            this.spellKillEnabled = (this.flyEnabled = (this.threeKillEnabled = false));
            this.deputyWeaponEnabled = false;
            skill = 0;
            isSpecialSkill = true;
            this.dander = 0;
            GameInSocketOut.sendGameCMDStunt();
        }

        public function get spellKillEnabled():Boolean
        {
            return ((((this._spellKillEnabled) && (_dander >= Player.TOTAL_DANDER)) && (!(this._lockSpellKill))) && (_isLiving));
        }

        public function set spellKillEnabled(_arg_1:Boolean):void
        {
            if (this._spellKillEnabled != _arg_1)
            {
                this._spellKillEnabled = _arg_1;
                dispatchEvent(new LivingEvent(LivingEvent.SPELLKILL_CHANGED));
            };
        }

        public function set propEnabled(_arg_1:Boolean):void
        {
            if (this._propEnabled != _arg_1)
            {
                this._propEnabled = _arg_1;
                dispatchEvent(new LivingEvent(LivingEvent.PROPENABLED_CHANGED));
            };
        }

        public function get propEnabled():Boolean
        {
            return ((this._propEnabled) && (!(this._lockProp)));
        }

        public function set FightProEnabled(_arg_1:Boolean):void
        {
            this._FightProEnabled = _arg_1;
        }

        public function get FightProEnabled():Boolean
        {
            return (this._FightProEnabled);
        }

        public function set petSkillEnabled(_arg_1:Boolean):void
        {
            if (this._petSkillEnabled != _arg_1)
            {
                this._petSkillEnabled = _arg_1;
                dispatchEvent(new LivingEvent(LivingEvent.PROPENABLED_CHANGED));
            };
        }

        public function get petSkillEnabled():Boolean
        {
            return (this._petSkillEnabled);
        }

        public function set soulPropEnabled(_arg_1:Boolean):void
        {
            if (this._soulPropEnabled != _arg_1)
            {
                this._soulPropEnabled = _arg_1;
                dispatchEvent(new LivingEvent(LivingEvent.SOUL_PROP_ENABEL_CHANGED));
            };
        }

        public function get soulPropEnabled():Boolean
        {
            return ((this._soulPropEnabled) && (!(this._lockProp)));
        }

        public function get customPropEnabled():Boolean
        {
            return ((this._customPropEnabled) && (this._propEnabled));
        }

        public function set customPropEnabled(_arg_1:Boolean):void
        {
            if (this._customPropEnabled != _arg_1)
            {
                this._customPropEnabled = _arg_1;
                dispatchEvent(new LivingEvent(LivingEvent.CUSTOMENABLED_CHANGED));
            };
        }

        public function set lockRightProp(_arg_1:Boolean):void
        {
            if (this._lockRightProp != _arg_1)
            {
                this._lockRightProp = _arg_1;
                dispatchEvent(new LivingEvent(LivingEvent.RIGHTENABLED_CHANGED));
            };
        }

        public function get lockRightProp():Boolean
        {
            return (this._lockRightProp);
        }

        public function get rightPropEnabled():Boolean
        {
            return ((((this._rightPropEnabled) && (this._propEnabled)) && (_isLiving)) && (!(this._lockRightProp)));
        }

        public function set rightPropEnabled(_arg_1:Boolean):void
        {
            if (this._rightPropEnabled != _arg_1)
            {
                this._rightPropEnabled = _arg_1;
                dispatchEvent(new LivingEvent(LivingEvent.RIGHTENABLED_CHANGED));
            };
        }

        public function get weaponPropEnbled():Boolean
        {
            return (this._weaponPropEnbled);
        }

        public function set weaponPropEnbled(_arg_1:Boolean):void
        {
            if (this._weaponPropEnbled != _arg_1)
            {
                this._weaponPropEnbled = _arg_1;
                dispatchEvent(new LivingEvent(LivingEvent.WEAPONENABLED_CHANGE));
            };
        }

        public function get lockDeputyWeapon():Boolean
        {
            return (this._lockDeputyWeapon);
        }

        public function set lockDeputyWeapon(_arg_1:Boolean):void
        {
            if (this._lockDeputyWeapon != _arg_1)
            {
                this._lockDeputyWeapon = _arg_1;
                dispatchEvent(new LivingEvent(LivingEvent.DEPUTYWEAPON_CHANGED));
            };
        }

        public function get lockFly():Boolean
        {
            return (this._lockFly);
        }

        public function set lockFly(_arg_1:Boolean):void
        {
            if (this._lockFly != _arg_1)
            {
                this._lockFly = _arg_1;
                dispatchEvent(new LivingEvent(LivingEvent.FLY_CHANGED));
            };
        }

        public function get lockSpellKill():Boolean
        {
            return (this._lockSpellKill);
        }

        public function set lockSpellKill(_arg_1:Boolean):void
        {
            if (this._lockSpellKill != _arg_1)
            {
                this._lockSpellKill = _arg_1;
                dispatchEvent(new LivingEvent(LivingEvent.SPELLKILL_CHANGED));
            };
        }

        public function set lockProp(_arg_1:Boolean):void
        {
            if (this._lockProp != _arg_1)
            {
                this._lockProp = _arg_1;
                dispatchEvent(new LivingEvent(LivingEvent.PROPENABLED_CHANGED));
            };
        }

        public function get lockProp():Boolean
        {
            return (this._lockProp);
        }

        public function get shootEnabled():Boolean
        {
            return ((_isAttacking) && (_isLiving));
        }

        public function setCenter(_arg_1:Number, _arg_2:Number, _arg_3:Boolean):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.SETCENTER, 0, 0, _arg_1, _arg_2, _arg_3));
        }

        public function get mouseState():Boolean
        {
            return (SharedManager.Instance.mouseModel);
        }

        public function set mouseState(_arg_1:Boolean):void
        {
            SharedManager.Instance.mouseModel = _arg_1;
            SharedManager.Instance.save();
        }

        public function get isBeginShoot():Boolean
        {
            return (this._isBeginShoot);
        }


    }
}//package game.model

