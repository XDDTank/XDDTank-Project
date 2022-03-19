// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.prop.BossSkillBar

package game.view.prop
{
    import flash.geom.Point;
    import flash.display.MovieClip;
    import __AS3__.vec.Vector;
    import game.model.LocalPlayer;
    import com.pickgliss.utils.ClassUtils;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.ObjectUtils;
    import game.GameManager;
    import ddt.events.LivingEvent;
    import org.aswing.KeyStroke;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import org.aswing.KeyboardManager;
    import ddt.manager.SoundManager;
    import pet.date.PetSkillInfo;
    import road7th.comm.PackageIn;
    import ddt.data.FightPropMode;
    import ddt.manager.PetSkillManager;
    import com.greensock.TweenLite;
    import com.pickgliss.utils.DisplayUtils;
    import com.pickgliss.ui.ComponentFactory;
    import __AS3__.vec.*;

    public class BossSkillBar extends FightPropBar 
    {

        private var _startPos:Point;
        private var _usedPetSkill:Boolean = false;
        private var _usedItem:Boolean = false;
        private var _usedSpecialSkill:Boolean = false;
        private var _petskillGuideMC:MovieClip;
        private var _moveGuideMC:MovieClip;

        protected var letters:Array = ["1", "2", "3", "4", "5"];
        private var _skillCells:Vector.<PetSkillCell> = new Vector.<PetSkillCell>();

        public function BossSkillBar(_arg_1:LocalPlayer)
        {
            super(_arg_1);
            if ((!(_arg_1.mouseState)))
            {
                this.addGuideMC();
            };
            this.createPetSkillMC();
        }

        private function addGuideMC():void
        {
            this._moveGuideMC = ClassUtils.CreatInstance("asset.bossplayer.flashDirMC");
            PositionUtils.setPos(this._moveGuideMC, "singledungeon.moveGuidePos");
            addChild(this._moveGuideMC);
        }

        private function createPetSkillMC():void
        {
            this._petskillGuideMC = ClassUtils.CreatInstance("asset.bossplayer.flashTextMC");
            PositionUtils.setPos(this._petskillGuideMC, "singledungeon.petSkillGuidePos");
            addChild(this._petskillGuideMC);
            this.startShine();
        }

        private function removePetSkillGuide():void
        {
            if (this._moveGuideMC)
            {
                this.removeMoveGuide();
            };
            if (this._petskillGuideMC)
            {
                this._petskillGuideMC.stop();
                ObjectUtils.disposeObject(this._petskillGuideMC);
                this._petskillGuideMC = null;
                this.stopShine();
            };
        }

        public function removeMoveGuide():void
        {
            if (this._moveGuideMC)
            {
                this._moveGuideMC.stop();
                ObjectUtils.disposeObject(this._moveGuideMC);
                this._moveGuideMC = null;
                GameManager.Instance.removeEventListener(LivingEvent.START_MOVING, this.__onStartMoving);
            };
        }

        override protected function __keyDown(_arg_1:KeyboardEvent):void
        {
            var _local_4:PetSkillCell;
            var _local_2:int = -1;
            switch (_arg_1.keyCode)
            {
                case KeyStroke.VK_1.getCode():
                case KeyStroke.VK_NUMPAD_1.getCode():
                    _local_2 = 0;
                    break;
                case KeyStroke.VK_2.getCode():
                case KeyStroke.VK_NUMPAD_2.getCode():
                    _local_2 = 1;
                    break;
                case KeyStroke.VK_3.getCode():
                case KeyStroke.VK_NUMPAD_3.getCode():
                    _local_2 = 2;
                    break;
                case KeyStroke.VK_4.getCode():
                case KeyStroke.VK_NUMPAD_4.getCode():
                    _local_2 = 3;
                    break;
                case KeyStroke.VK_5.getCode():
                case KeyStroke.VK_NUMPAD_5.getCode():
                    _local_2 = 4;
                    break;
            };
            var _local_3:String = this.letters[_local_2];
            for each (_local_4 in this._skillCells)
            {
                if ((((((_local_4.skillInfo) && (_local_4.shortcutKey == _local_3)) && (_local_4.skillInfo.isActiveSkill)) && (_local_4.isEnabled)) && (_local_4.enabled)))
                {
                    if (_local_4.skillInfo)
                    {
                        _local_4.useProp();
                    };
                    break;
                };
            };
        }

        override protected function addEvent():void
        {
            var _local_1:PetSkillCell;
            for each (_local_1 in this._skillCells)
            {
                if (_local_1.isEnabled)
                {
                    _local_1.addEventListener(MouseEvent.CLICK, this.onCellClick);
                };
            };
            if (_self.currentPet)
            {
                _self.currentPet.addEventListener(LivingEvent.PET_MP_CHANGE, this.__onChange);
                _self.currentPet.addEventListener(LivingEvent.USE_PET_SKILL, this.__onUsePetSkill);
            };
            _self.addEventListener(LivingEvent.ATTACKING_CHANGED, this.__onAttackingChange);
            _self.addEventListener(LivingEvent.USING_SPECIAL_SKILL, this.__usingSpecialKill);
            _self.addEventListener(LivingEvent.USING_ITEM, this.__onUseItem);
            _self.addEventListener(LivingEvent.IS_CALCFORCE_CHANGE, this.__onChange);
            _self.addEventListener(LivingEvent.PETSKILL_ENABLED_CHANGED, this.__onChange);
            GameManager.Instance.addEventListener(LivingEvent.START_MOVING, this.__onStartMoving);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PET_SKILL_CD, this.__petSkillCD);
            KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN, this.__keyDown);
            GameManager.Instance.addEventListener(LivingEvent.PETSKILL_USED_FAIL, this.__onPetSkillUsedFail);
        }

        private function __onStartMoving(_arg_1:LivingEvent):void
        {
            this.removeMoveGuide();
        }

        private function startShine():void
        {
            var _local_1:PetSkillCell;
            for each (_local_1 in this._skillCells)
            {
                if (_local_1.skillInfo)
                {
                    _local_1.shine();
                };
            };
        }

        private function stopShine():void
        {
            var _local_1:PetSkillCell;
            for each (_local_1 in this._skillCells)
            {
                if (_local_1.skillInfo)
                {
                    _local_1.stopShine();
                };
            };
        }

        private function onCellClick(_arg_1:MouseEvent):void
        {
            var _local_2:PetSkillCell = (_arg_1.currentTarget as PetSkillCell);
            if (((_local_2.enabled) && (_self.isAttacking)))
            {
                SoundManager.instance.play("008");
                this.removePetSkillGuide();
                if (((_local_2.skillInfo.BallType == PetSkillInfo.BALL_TYPE_1) || (_local_2.skillInfo.BallType == PetSkillInfo.BALL_TYPE_2)))
                {
                    if (_self.isUsedItem)
                    {
                        return;
                    };
                    _self.customPropEnabled = false;
                    _self.deputyWeaponEnabled = false;
                    _self.isUsedPetSkillWithNoItem = true;
                    if (_local_2.skillInfo.BallType == PetSkillInfo.BALL_TYPE_2)
                    {
                        _self.useSkillDirectly(_local_2.skillInfo.ID, _self.direction);
                        return;
                    };
                };
                SocketManager.Instance.out.sendPetSkill(_local_2.skillInfo.ID, _self.direction);
                this._usedPetSkill = true;
                this.updateCellEnable();
            };
        }

        private function __onPetSkillUsedFail(_arg_1:LivingEvent):void
        {
            this._usedPetSkill = false;
            _self.deputyWeaponEnabled = true;
            _self.isUsedPetSkillWithNoItem = false;
        }

        private function __onChange(_arg_1:LivingEvent):void
        {
            this.updateCellEnable();
        }

        private function __petSkillCD(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:PetSkillCell;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:int = _local_2.readInt();
            for each (_local_5 in this._skillCells)
            {
                if (_local_5.skillInfo.ID == _local_3)
                {
                    _local_5.turnNum = ((_local_5.skillInfo.ColdDown + 1) - _local_4);
                };
            };
            this.updateCellEnable();
        }

        private function __usingSpecialKill(_arg_1:LivingEvent):void
        {
            var _local_2:PetSkillCell;
            for each (_local_2 in this._skillCells)
            {
                _local_2.enabled = false;
            };
            this._usedSpecialSkill = true;
        }

        private function __onUseItem(_arg_1:LivingEvent):void
        {
            var _local_2:PetSkillCell;
            for each (_local_2 in this._skillCells)
            {
                if (((_local_2.skillInfo) && ((_local_2.skillInfo.BallType == PetSkillInfo.BALL_TYPE_1) || (_local_2.skillInfo.BallType == PetSkillInfo.BALL_TYPE_2))))
                {
                    _local_2.enabled = false;
                };
            };
            this._usedItem = true;
        }

        private function __onUsePetSkill(_arg_1:LivingEvent):void
        {
            var _local_2:PetSkillCell;
            for each (_local_2 in this._skillCells)
            {
                if (((_local_2.skillInfo) && (_local_2.skillInfo.ID == _arg_1.value)))
                {
                    _local_2.turnNum = 0;
                    break;
                };
            };
            this.updateCellEnable();
        }

        private function __onAttackingChange(_arg_1:LivingEvent):void
        {
            var _local_2:PetSkillCell;
            if (_self.isAttacking)
            {
                for each (_local_2 in this._skillCells)
                {
                    _local_2.turnNum++;
                };
                this._usedItem = false;
                this._usedSpecialSkill = false;
                this._usedPetSkill = false;
                _self.isUsedPetSkillWithNoItem = false;
            };
            this.updateCellEnable();
        }

        private function updateCellEnable():void
        {
            var _local_2:PetSkillCell;
            var _local_1:Boolean = _self.petSkillEnabled;
            for each (_local_2 in this._skillCells)
            {
                if (!(!(_local_2.skillInfo)))
                {
                    switch (_local_2.skillInfo.BallType)
                    {
                        case PetSkillInfo.BALL_TYPE_0:
                            _local_2.enabled = ((((((_local_1) && (_self.isAttacking)) && (!(this._usedPetSkill))) && (!(this._usedSpecialSkill))) && (_local_2.skillInfo.CostMP <= _self.currentPet.MP)) && (_local_2.turnNum > _local_2.skillInfo.ColdDown));
                            break;
                        case PetSkillInfo.BALL_TYPE_1:
                            _local_2.enabled = (((((((_local_1) && (_self.isAttacking)) && (!(this._usedPetSkill))) && (!(this._usedItem))) && (!(this._usedSpecialSkill))) && (_local_2.skillInfo.CostMP <= _self.currentPet.MP)) && (_local_2.turnNum > _local_2.skillInfo.ColdDown));
                            break;
                        case PetSkillInfo.BALL_TYPE_2:
                            _local_2.enabled = ((((((((_local_1) && (_self.isAttacking)) && (!(this._usedPetSkill))) && (!(this._usedItem))) && (!(this._usedSpecialSkill))) && (!(_self.iscalcForce))) && (_local_2.skillInfo.CostMP <= _self.currentPet.MP)) && (_local_2.turnNum > _local_2.skillInfo.ColdDown));
                            break;
                        case PetSkillInfo.BALL_TYPE_3:
                            _local_2.enabled = ((((((_local_1) && (_self.isAttacking)) && (!(this._usedPetSkill))) && (!(this._usedSpecialSkill))) && (_local_2.skillInfo.CostMP <= _self.currentPet.MP)) && (_local_2.turnNum > _local_2.skillInfo.ColdDown));
                            break;
                    };
                };
            };
        }

        override protected function drawCells():void
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:PetSkillInfo;
            var _local_4:PetSkillCell;
            var _local_5:int;
            var _local_6:PetSkillInfo;
            if (_self.currentPet)
            {
                _local_2 = 0;
                while (_local_2 < this.letters.length)
                {
                    _local_3 = null;
                    _local_4 = new PetSkillCell(this.letters[_local_2], FightPropMode.VERTICAL, false, 33, 33);
                    _local_5 = _self.currentPet.equipedSkillIDs[_local_2];
                    if (((_local_5 > 0) && (_local_5 < 1000)))
                    {
                        _local_3 = PetSkillManager.instance.getSkillByID(_local_5);
                    };
                    if (_local_3)
                    {
                        _local_6 = PetSkillManager.instance.getSkillByID(_local_3.ID);
                        _local_4.creteSkillCell(_local_6);
                    }
                    else
                    {
                        _local_4.creteSkillCell(null);
                    };
                    this._skillCells.push(_local_4);
                    addChild(_local_4);
                    _local_2++;
                };
                this.drawLayer();
            };
        }

        override protected function drawLayer():void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_1:int = this._skillCells.length;
            _local_2 = 0;
            while (_local_2 < _local_1)
            {
                _local_3 = 7;
                _local_4 = (6 + (_local_2 * (36 + 3)));
                this._skillCells[_local_2].setPossiton(_local_3, _local_4);
                this._skillCells[_local_2].setMode(2);
                if (_inited)
                {
                    TweenLite.to(this._skillCells[_local_2], (0.05 * (_local_1 - _local_2)), {
                        "x":_local_3,
                        "y":_local_4
                    });
                }
                else
                {
                    this._skillCells[_local_2].x = _local_3;
                    this._skillCells[_local_2].y = _local_4;
                };
                _local_2++;
            };
            DisplayUtils.setFrame(_background, 2);
            PositionUtils.setPos(_background, new Point(0, 0));
        }

        override protected function removeEvent():void
        {
            var _local_1:PetSkillCell;
            for each (_local_1 in this._skillCells)
            {
                if (_local_1.isEnabled)
                {
                    _local_1.removeEventListener(MouseEvent.CLICK, this.onCellClick);
                };
            };
            if (_self.currentPet)
            {
                _self.currentPet.removeEventListener(LivingEvent.PET_MP_CHANGE, this.__onChange);
                _self.currentPet.removeEventListener(LivingEvent.USE_PET_SKILL, this.__onUsePetSkill);
            };
            _self.removeEventListener(LivingEvent.ATTACKING_CHANGED, this.__onAttackingChange);
            _self.removeEventListener(LivingEvent.USING_SPECIAL_SKILL, this.__usingSpecialKill);
            _self.removeEventListener(LivingEvent.USING_ITEM, this.__onUseItem);
            _self.removeEventListener(LivingEvent.IS_CALCFORCE_CHANGE, this.__onChange);
            _self.removeEventListener(LivingEvent.PETSKILL_ENABLED_CHANGED, this.__onChange);
            GameManager.Instance.removeEventListener(LivingEvent.START_MOVING, this.__onStartMoving);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PET_SKILL_CD, this.__petSkillCD);
            GameManager.Instance.removeEventListener(LivingEvent.PETSKILL_USED_FAIL, this.__onPetSkillUsedFail);
        }

        override protected function configUI():void
        {
            _background = ComponentFactory.Instance.creatComponentByStylename("RightPropBack");
            addChild(_background);
            super.configUI();
        }

        override public function dispose():void
        {
            if (this._petskillGuideMC)
            {
                ObjectUtils.disposeObject(this._petskillGuideMC);
                this._petskillGuideMC = null;
            };
            if (this._moveGuideMC)
            {
                ObjectUtils.disposeObject(this._moveGuideMC);
                this._moveGuideMC = null;
            };
            super.dispose();
        }


    }
}//package game.view.prop

