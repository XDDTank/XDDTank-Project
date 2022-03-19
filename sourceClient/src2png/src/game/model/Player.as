// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.model.Player

package game.model
{
    import game.view.map.MapView;
    import ddt.data.player.PlayerInfo;
    import ddt.view.character.GameCharacter;
    import room.model.WeaponInfo;
    import room.model.WebSpeedInfo;
    import room.model.DeputyWeaponInfo;
    import game.objects.LivingTypesEnum;
    import ddt.events.PlayerPropertyEvent;
    import ddt.data.player.SelfInfo;
    import ddt.events.LivingEvent;
    import flash.geom.Point;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.display.DisplayObject;
    import room.RoomManager;
    import ddt.manager.SoundManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.ItemManager;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import ddt.manager.PlayerManager;
    import ddt.manager.PetSkillManager;
    import pet.date.PetSkillInfo;

    [Event(name="beginShoot", type="ddt.events.LivingEvent")]
    [Event(name="addState", type="ddt.events.LivingEvent")]
    [Event(name="usingItem", type="ddt.events.LivingEvent")]
    [Event(name="usingSpecialSkill", type="ddt.events.LivingEvent")]
    [Event(name="danderChanged", type="ddt.events.LivingEvent")]
    [Event(name="bombChanged", type="ddt.events.LivingEvent")]
    public class Player extends TurnedLiving 
    {

        public static const MaxPsychic:int = 999;
        public static const MaxSoulPropUsedCount:int = 2;
        public static var MOVE_SPEED:Number = 10;
        public static var GHOST_MOVE_SPEED:Number = 8;
        public static var FALL_SPEED:Number = 12;
        public static const FORCE_MAX:int = 2000;
        public static const FORCE_STEP:int = 24;
        public static const TOTAL_DANDER:int = 200;
        public static const SHOOT_INTERVAL:uint = 24;
        public static const SHOOT_TIMER:uint = 1000;
        public static const TOTAL_BLOOD:int = 1000;
        public static const TOTAL_LEADER_BLOOD:int = 2000;
        public static const FULL_HP:int = 1;
        public static const LACK_HP:int = 2;

        private var _currentMap:MapView;
        public var isPlayAnimation:int;
        protected var _maxForce:int = 2000;
        private var _isDispose:Boolean = false;
        private var _info:PlayerInfo;
        private var _movie:GameCharacter;
        public var _expObj:Object;
        public var isUpGrade:Boolean;
        private var _isWin:Boolean;
        public var CurrentLevel:int;
        public var CurrentGP:int;
        public var TotalKill:int;
        public var TotalHurt:int;
        public var TotalHitTargetCount:int;
        public var TotalShootCount:int;
        public var GetCardCount:int;
        private var _bossCardCount:int;
        public var GainOffer:int;
        public var GainGP:int;
        public var VipGP:int;
        public var MarryGP:int;
        public var AcademyGP:int;
        public var zoneName:String;
        public var fightRobotRewardGold:int;
        public var fightRobotRewardMagicSoul:int;
        private var _powerRatio:int = 100;
        private var _skill:int = -1;
        private var _isSpecialSkill:Boolean;
        protected var _dander:int;
        private var _currentWeapInfo:WeaponInfo;
        private var _currentBomb:int;
        public var webSpeedInfo:WebSpeedInfo;
        private var _currentDeputyWeaponInfo:DeputyWeaponInfo;
        private var _turnTime:int = 0;
        private var _reverse:int = 1;
        private var _isAutoGuide:Boolean = false;
        private var _pet:Pet;
        public var hasLevelAgain:Boolean = false;
        public var hasGardGet:Boolean = false;
        public var wishKingCount:int;
        public var wishKingEnergy:int;
        public var npcID:int;
        public var bossType:int;
        public var bossName:String;
        public var bossCreateAction:String;
        protected var _petLiving:PetLiving;

        public function Player(_arg_1:PlayerInfo, _arg_2:int, _arg_3:int, _arg_4:int)
        {
            this._info = _arg_1;
            super(_arg_2, _arg_3, _arg_4);
            this.setWeaponInfo();
            this.setDeputyWeaponInfo();
            this.webSpeedInfo = new WebSpeedInfo(this._info.webSpeed);
            this.initEvent();
            this.typeLiving = LivingTypesEnum.NORMAL_PLAYER;
        }

        public function get currentMap():MapView
        {
            return (this._currentMap);
        }

        public function set currentMap(_arg_1:MapView):void
        {
            this._currentMap = _arg_1;
        }

        public function get BossCardCount():int
        {
            return (this._bossCardCount);
        }

        public function set BossCardCount(_arg_1:int):void
        {
            this._bossCardCount = _arg_1;
        }

        private function initEvent():void
        {
            this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__playerPropChanged);
        }

        private function removeEvent():void
        {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__playerPropChanged);
        }

        override public function dispose():void
        {
            if ((!(this._isDispose)))
            {
                return;
            };
            this._isDispose = true;
            this.removeEvent();
            this.movie = null;
            character = null;
            if (this._currentWeapInfo)
            {
                this._currentWeapInfo.dispose();
            };
            this._currentWeapInfo = null;
            if (this._currentDeputyWeaponInfo)
            {
                this._currentDeputyWeaponInfo.dispose();
            };
            this._currentDeputyWeaponInfo = null;
            this.webSpeedInfo = null;
            this._info = null;
            super.dispose();
        }

        override public function reset():void
        {
            super.reset();
            if (this._petLiving)
            {
                this._petLiving.dispose();
                this._petLiving = null;
            };
            _isAttacking = false;
            this._dander = 0;
            if (this._movie)
            {
                this._movie.State = FULL_HP;
            };
        }

        override public function get playerInfo():PlayerInfo
        {
            return (this._info);
        }

        override public function get isSelf():Boolean
        {
            return (this._info is SelfInfo);
        }

        public function get movie():GameCharacter
        {
            return (this._movie);
        }

        public function set movie(_arg_1:GameCharacter):void
        {
            this._movie = _arg_1;
        }

        public function get isWin():Boolean
        {
            return (this._isWin);
        }

        public function set isWin(_arg_1:Boolean):void
        {
            this._isWin = _arg_1;
        }

        public function set MP(_arg_1:int):void
        {
            if (this.currentPet)
            {
                this.currentPet.MP = _arg_1;
            };
        }

        public function set expObj(_arg_1:Object):void
        {
            this._expObj = _arg_1;
        }

        public function get expObj():Object
        {
            return (this._expObj);
        }

        public function playerMoveTo(_arg_1:Number, _arg_2:Point, _arg_3:Number, _arg_4:Boolean, _arg_5:Array=null):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.PLAYER_MOVETO, 0, 0, _arg_1, _arg_2, _arg_3, _arg_4, _arg_5));
        }

        public function beginShoot():void
        {
            dispatchEvent(new LivingEvent(LivingEvent.BEGIN_SHOOT));
        }

        public function useItem(_arg_1:ItemTemplateInfo):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.USING_ITEM, 0, 0, _arg_1));
        }

        public function useItemByIcon(_arg_1:DisplayObject):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.USING_ITEM, 0, 0, _arg_1));
        }

        public function get maxForce():int
        {
            return (this._maxForce);
        }

        public function set maxForce(_arg_1:int):void
        {
            if (this._maxForce != _arg_1)
            {
                this._maxForce = _arg_1;
                dispatchEvent(new LivingEvent(LivingEvent.MAXFORCE_CHANGED, this._maxForce));
            };
        }

        public function get powerRatio():Number
        {
            return (this._powerRatio / 100);
        }

        public function set powerRatio(_arg_1:Number):void
        {
            this._powerRatio = _arg_1;
        }

        public function get skill():int
        {
            return (this._skill);
        }

        public function set skill(_arg_1:int):void
        {
            this._skill = _arg_1;
            if (this._skill >= 0)
            {
                dispatchEvent(new LivingEvent(LivingEvent.USING_SPECIAL_SKILL));
            };
        }

        public function get isSpecialSkill():Boolean
        {
            return (this._isSpecialSkill);
        }

        public function set isSpecialSkill(_arg_1:Boolean):void
        {
            if (this._isSpecialSkill != _arg_1)
            {
                this._isSpecialSkill = _arg_1;
                if (_arg_1)
                {
                    dispatchEvent(new LivingEvent(LivingEvent.USING_SPECIAL_SKILL));
                };
            };
        }

        public function get dander():int
        {
            return (this._dander);
        }

        public function set dander(_arg_1:int):void
        {
            if (RoomManager.Instance.current)
            {
                if (RoomManager.Instance.current.gameMode == 8)
                {
                    return;
                };
            };
            if (this._dander == _arg_1)
            {
                return;
            };
            if (((this._dander > _arg_1) && (_arg_1 > 0)))
            {
                return;
            };
            if (this._dander < 0)
            {
                this._dander = 0;
            }
            else
            {
                this._dander = ((_arg_1 > TOTAL_DANDER) ? TOTAL_DANDER : _arg_1);
            };
            dispatchEvent(new LivingEvent(LivingEvent.DANDER_CHANGED, this._dander));
        }

        public function reduceDander(_arg_1:int):void
        {
            if (this._dander == _arg_1)
            {
                return;
            };
            if (this._dander < 0)
            {
                this._dander = 0;
            }
            else
            {
                this._dander = ((_arg_1 > TOTAL_DANDER) ? TOTAL_DANDER : _arg_1);
            };
            dispatchEvent(new LivingEvent(LivingEvent.DANDER_CHANGED, this._dander));
        }

        public function get currentWeapInfo():WeaponInfo
        {
            return (this._currentWeapInfo);
        }

        public function get currentBomb():int
        {
            return (this._currentBomb);
        }

        public function set currentBomb(_arg_1:int):void
        {
            if (_arg_1 == this._currentBomb)
            {
                return;
            };
            this._currentBomb = _arg_1;
            dispatchEvent(new LivingEvent(LivingEvent.BOMB_CHANGED, this._currentBomb, 0));
        }

        override public function beginNewTurn():void
        {
            super.beginNewTurn();
            this._currentBomb = this._currentWeapInfo.commonBall;
            this._isSpecialSkill = false;
            gemDefense = false;
        }

        override public function die(_arg_1:Boolean=true):void
        {
            if (isLiving)
            {
                this._movie.State = LACK_HP;
                super.die();
                this.isSpecialSkill = false;
                this.dander = 0;
                SoundManager.instance.play("Sound042");
            };
        }

        override public function isPlayer():Boolean
        {
            return (true);
        }

        protected function setWeaponInfo():void
        {
            var _local_1:InventoryItemInfo = new InventoryItemInfo();
            _local_1.TemplateID = this.playerInfo.WeaponID;
            ItemManager.fill(_local_1);
            if (this._currentWeapInfo)
            {
                this._currentWeapInfo.dispose();
            };
            this._currentWeapInfo = new WeaponInfo(_local_1);
            this.currentBomb = this._currentWeapInfo.commonBall;
        }

        public function setDeputyWeaponInfo():void
        {
            var _local_1:InventoryItemInfo = new InventoryItemInfo();
            _local_1.TemplateID = this._info.DeputyWeaponID;
            ItemManager.fill(_local_1);
            this._currentDeputyWeaponInfo = new DeputyWeaponInfo(_local_1);
        }

        public function get currentDeputyWeaponInfo():DeputyWeaponInfo
        {
            return (this._currentDeputyWeaponInfo);
        }

        public function hasDeputyWeapon():Boolean
        {
            return ((!(this._info == null)) && (this._info.DeputyWeaponID > 0));
        }

        private function __playerPropChanged(_arg_1:PlayerPropertyEvent):void
        {
            if (_arg_1.changedProperties["WeaponID"])
            {
                this.setWeaponInfo();
            }
            else
            {
                if (_arg_1.changedProperties["DeputyWeaponID"])
                {
                    this.setDeputyWeaponInfo();
                };
            };
            if (((_arg_1.changedProperties["Grade"]) && (!(StateManager.currentStateType == StateType.MISSION_ROOM))))
            {
                this.isUpGrade = this._info.IsUpGrade;
                if (this.isSelf)
                {
                    PlayerManager.Instance.Self.isUpGradeInGame = true;
                };
            };
        }

        override public function updateBlood(_arg_1:int, _arg_2:int, _arg_3:int=0, _arg_4:int=-1):void
        {
            super.updateBlood(_arg_1, _arg_2, _arg_3);
            if (this._movie == null)
            {
                return;
            };
            if (blood <= (maxBlood * 0.3))
            {
                this._movie.State = LACK_HP;
            }
            else
            {
                this._movie.State = FULL_HP;
            };
            this._movie.isLackHp = ((!(_arg_2 == 0)) && (_arg_3 >= (maxBlood * 0.1)));
        }

        public function get turnTime():int
        {
            return (this._turnTime);
        }

        public function set turnTime(_arg_1:int):void
        {
            this._turnTime = _arg_1;
        }

        public function get reverse():int
        {
            return (this._reverse);
        }

        public function set reverse(_arg_1:int):void
        {
            this._reverse = _arg_1;
            dispatchEvent(new LivingEvent(LivingEvent.REVERSE_CHANGED, 0, 0, this._reverse));
        }

        public function get isAutoGuide():Boolean
        {
            if (this._isAutoGuide == true)
            {
                this._isAutoGuide = false;
                return (true);
            };
            return (this._isAutoGuide);
        }

        public function set isAutoGuide(_arg_1:Boolean):void
        {
            if (this._isAutoGuide == _arg_1)
            {
                return;
            };
            this._isAutoGuide = _arg_1;
        }

        public function get currentPet():Pet
        {
            return (this._pet);
        }

        public function set currentPet(_arg_1:Pet):void
        {
            this._pet = _arg_1;
        }

        private function onUsePetSkill(_arg_1:LivingEvent):void
        {
            dispatchEvent(new LivingEvent(_arg_1.type, _arg_1.value, 0, _arg_1.paras[0]));
        }

        public function usePetSkill(_arg_1:int, _arg_2:Boolean):void
        {
            var _local_3:PetSkillInfo = PetSkillManager.instance.getSkillByID(_arg_1);
            if (((_local_3) && (_arg_2)))
            {
                this.currentPet.MP = (this.currentPet.MP - _local_3.CostMP);
                this.currentPet.useSkill(_arg_1, _arg_2);
            };
            dispatchEvent(new LivingEvent(LivingEvent.USE_PET_SKILL, _arg_1, 0, _arg_2));
        }

        public function petBeat(_arg_1:String, _arg_2:Point, _arg_3:Array):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.PET_BEAT, 0, 0, _arg_1, _arg_2, _arg_3));
        }

        public function petDefence(_arg_1:String, _arg_2:Point):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.PET_DEFENCE, 0, 0, _arg_1, _arg_2));
        }

        public function set actionMCname(_arg_1:String):void
        {
            this.actionMovieName = _arg_1;
        }

        public function get petLiving():PetLiving
        {
            return (this._petLiving);
        }

        public function set petLiving(_arg_1:PetLiving):void
        {
            if (this._petLiving)
            {
                this._petLiving.removeEventListener(LivingEvent.USE_PET_SKILL, this.onUsePetSkill);
                this._petLiving.dispose();
            };
            this._petLiving = _arg_1;
            if (this._petLiving)
            {
                this._petLiving.addEventListener(LivingEvent.USE_PET_SKILL, this.onUsePetSkill);
            };
        }


    }
}//package game.model

