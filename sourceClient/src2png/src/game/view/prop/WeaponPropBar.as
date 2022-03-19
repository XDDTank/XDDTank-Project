// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.prop.WeaponPropBar

package game.view.prop
{
    import game.model.LocalPlayer;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.EquipType;
    import room.RoomManager;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import room.model.RoomInfo;
    import game.GameManager;
    import game.model.GameInfo;
    import ddt.manager.SoundManager;
    import ddt.data.UsePropErrorCode;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import ddt.manager.SavePointManager;
    import ddt.events.LivingEvent;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.MouseEvent;
    import org.aswing.KeyStroke;
    import flash.events.KeyboardEvent;
    import flash.events.Event;
    import org.aswing.KeyboardManager;
    import ddt.events.CrazyTankSocketEvent;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import ddt.data.PropInfo;
    import ddt.manager.ItemManager;

    public class WeaponPropBar extends FightPropBar 
    {

        private var _canEnable:Boolean = true;
        private var _localFlyVisible:Boolean = true;
        private var _localDeputyWeaponVisible:Boolean = true;
        private var _localVisible:Boolean = true;

        public function WeaponPropBar(_arg_1:LocalPlayer)
        {
            super(_arg_1);
            this._canEnable = this.weaponEnabled();
            this.updatePropByEnergy();
        }

        private function weaponEnabled():Boolean
        {
            var _local_2:int;
            var _local_1:ItemTemplateInfo = _self.currentDeputyWeaponInfo.Template;
            if (_local_1.TemplateID == EquipType.WishKingBlessing)
            {
                _local_2 = RoomManager.Instance.current.type;
                if ((((_local_2 == RoomInfo.DUNGEON_ROOM) || (_local_2 == RoomInfo.WORLD_BOSS_FIGHT)) || (StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)))
                {
                    return (false);
                };
            }
            else
            {
                return (true);
            };
            return (true);
        }

        override protected function updatePropByEnergy():void
        {
            _cells[0].enabled = _self.flyEnabled;
            if ((!(this._canEnable)))
            {
                _self.deputyWeaponEnabled = false;
                _cells[1].setGrayFilter();
            };
            _cells[1].enabled = _self.deputyWeaponEnabled;
            var _local_1:GameInfo = GameManager.Instance.Current;
        }

        override protected function __itemClicked(_arg_1:MouseEvent):void
        {
            var _local_4:String;
            if ((!(this._localVisible)))
            {
                return;
            };
            var _local_2:PropCell = (_arg_1.currentTarget as PropCell);
            SoundManager.instance.play("008");
            var _local_3:int = _cells.indexOf(_local_2);
            switch (_local_3)
            {
                case 0:
                    if ((!(this._localFlyVisible)))
                    {
                        return;
                    };
                    _local_4 = _self.useFly();
                    break;
                case 1:
                    if ((!(this._localDeputyWeaponVisible)))
                    {
                        return;
                    };
                    _local_4 = _self.useDeputyWeapon();
                case 2:
                    break;
                default:
                    _local_4 = UsePropErrorCode.None;
            };
            if (_local_4 == UsePropErrorCode.FlyNotCoolDown)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop.NotCoolDown", _self.flyCoolDown));
            }
            else
            {
                if (_local_4 == UsePropErrorCode.DeputyWeaponNotCoolDown)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop.NotCoolDown", _self.deputyWeaponCoolDown));
                }
                else
                {
                    if (_local_4 == UsePropErrorCode.DeputyWeaponEmpty)
                    {
                        switch (_self.selfInfo.DeputyWeapon.TemplateID)
                        {
                            case EquipType.Angle:
                            case EquipType.TrueAngle:
                            case EquipType.ExllenceAngle:
                            case EquipType.FlyAngle:
                                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.deputyWeapon.canNotUse"));
                                break;
                            case EquipType.TrueShield:
                                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.deputyWeapon.canNotUse2"));
                                break;
                            case EquipType.ExcellentShield:
                                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.deputyWeapon.canNotUse3"));
                                break;
                            case EquipType.WishKingBlessing:
                                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.deputyWeapon.canNotUse4"));
                                break;
                        };
                    }
                    else
                    {
                        if (_local_4 != UsePropErrorCode.None)
                        {
                            if (_local_4 != null)
                            {
                                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation(("tank.game.prop." + _local_4)));
                            };
                        }
                        else
                        {
                            if (_local_3 == 0)
                            {
                                NewHandContainer.Instance.clearArrowByID(ArrowType.TIP_PLANE);
                                if (((SavePointManager.Instance.isInSavePoint(19)) && (GameManager.Instance.Current.missionInfo.missionIndex == 2)))
                                {
                                    GameManager.Instance.Current.selfGamePlayer.dispatchEvent(new LivingEvent(LivingEvent.USE_PLANE));
                                    SavePointManager.Instance.setSavePoint(91);
                                };
                            };
                        };
                    };
                };
            };
            StageReferance.stage.focus = null;
        }

        override protected function __keyDown(_arg_1:KeyboardEvent):void
        {
            switch (_arg_1.keyCode)
            {
                case KeyStroke.VK_F.getCode():
                    _cells[0].useProp();
                    break;
                case KeyStroke.VK_R.getCode():
                    _cells[1].useProp();
                    break;
                case KeyStroke.VK_T.getCode():
                    break;
            };
            super.__keyDown(_arg_1);
        }

        override protected function addEvent():void
        {
            var _local_1:PropCell;
            _self.addEventListener(LivingEvent.FLY_CHANGED, this.__flyChanged);
            _self.addEventListener(LivingEvent.DEPUTYWEAPON_CHANGED, this.__deputyWeaponChanged);
            _self.addEventListener(LivingEvent.ATTACKING_CHANGED, this.__changeAttack);
            _self.addEventListener(LivingEvent.WEAPONENABLED_CHANGE, this.__weaponEnabledChanged);
            addEventListener(Event.ENTER_FRAME, this.__enterFrame);
            for each (_local_1 in _cells)
            {
                _local_1.addEventListener(MouseEvent.CLICK, this.__itemClicked);
            };
            super.addEvent();
        }

        private function __enterFrame(_arg_1:Event):void
        {
            if (KeyboardManager.getInstance().isKeyDown(KeyStroke.VK_SPACE.getCode()))
            {
                if ((!(_self.canNormalShoot)))
                {
                    return;
                };
            };
        }

        override protected function __changeAttack(_arg_1:LivingEvent):void
        {
            if (_self.isAttacking)
            {
                this.updatePropByEnergy();
            };
        }

        protected function __weaponEnabledChanged(_arg_1:Event):void
        {
            enabled = ((_self.propEnabled) && (_self.weaponPropEnbled));
        }

        private function __setDeputyWeaponNumber(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            _cells[1].enabled = (!(_local_2 == 0));
        }

        private function __deputyWeaponChanged(_arg_1:LivingEvent):void
        {
            if ((!(this._canEnable)))
            {
                _self.deputyWeaponEnabled = false;
            };
            _cells[1].enabled = _self.deputyWeaponEnabled;
        }

        private function __flyChanged(_arg_1:LivingEvent):void
        {
            if ((!(SavePointManager.Instance.savePoints[18])))
            {
                return;
            };
            _cells[0].enabled = _self.flyEnabled;
        }

        override protected function configUI():void
        {
            _background = ComponentFactory.Instance.creatBitmap("asset.game.prop.FightModelBack");
            addChild(_background);
            super.configUI();
        }

        override public function dispose():void
        {
            super.dispose();
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }

        override protected function drawCells():void
        {
            var _local_1:Point;
            var _local_6:ItemTemplateInfo;
            var _local_2:WeaponPropCell = new WeaponPropCell("f", _mode);
            _local_2.info = new PropInfo(ItemManager.Instance.getTemplateById(10016));
            _local_1 = ComponentFactory.Instance.creatCustomObject("WeaponPropCellPosf");
            _local_2.setPossiton(_local_1.x, _local_1.y);
            addChild(_local_2);
            var _local_3:WeaponPropCell = new WeaponPropCell("r", _mode);
            _local_1 = ComponentFactory.Instance.creatCustomObject("WeaponPropCellPosr");
            _local_3.setPossiton(_local_1.x, _local_1.y);
            var _local_4:WeaponPropCell = new WeaponPropCell("t", _mode);
            _local_1 = ComponentFactory.Instance.creatCustomObject("WeaponPropCellPost");
            _local_4.setPossiton(_local_1.x, _local_1.y);
            if (_self.hasDeputyWeapon())
            {
                _local_6 = _self.currentDeputyWeaponInfo.Template;
                if (_local_6.TemplateID == EquipType.WishKingBlessing)
                {
                    _local_6.Property4 = _self.wishKingEnergy.toString();
                    _self.currentDeputyWeaponInfo.energy = _self.wishKingEnergy;
                    _local_3.info = new PropInfo(_local_6);
                }
                else
                {
                    _local_3.info = new PropInfo(_local_6);
                };
            };
            var _local_5:ItemTemplateInfo = ItemManager.Instance.getTemplateById(17200);
            _local_4.info = new PropInfo(_local_5);
            _self.fightToolBoxCount = 1;
            _cells.push(_local_2);
            _cells.push(_local_3);
            _cells.push(_local_4);
            super.drawCells();
        }

        override protected function removeEvent():void
        {
            var _local_1:PropCell;
            _self.removeEventListener(LivingEvent.FLY_CHANGED, this.__flyChanged);
            _self.removeEventListener(LivingEvent.DEPUTYWEAPON_CHANGED, this.__deputyWeaponChanged);
            _self.removeEventListener(LivingEvent.ATTACKING_CHANGED, this.__changeAttack);
            _self.removeEventListener(LivingEvent.WEAPONENABLED_CHANGE, this.__weaponEnabledChanged);
            removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
            for each (_local_1 in _cells)
            {
                _local_1.removeEventListener(MouseEvent.CLICK, this.__itemClicked);
            };
            super.removeEvent();
        }

        public function setFlyVisible(_arg_1:Boolean):void
        {
            if (this._localFlyVisible != _arg_1)
            {
                this._localFlyVisible = _arg_1;
                if (this._localFlyVisible)
                {
                    if ((!(_cells[0].parent)))
                    {
                        addChild(_cells[0]);
                    };
                }
                else
                {
                    if (_cells[0].parent)
                    {
                        _cells[0].parent.removeChild(_cells[0]);
                    };
                };
            };
        }

        public function setDeputyWeaponVisible(_arg_1:Boolean):void
        {
            if (this._localDeputyWeaponVisible != _arg_1)
            {
                this._localDeputyWeaponVisible = _arg_1;
                if (this._localDeputyWeaponVisible)
                {
                    if ((!(_cells[1].parent)))
                    {
                        addChild(_cells[1]);
                    };
                }
                else
                {
                    if (_cells[1].parent)
                    {
                        _cells[1].parent.removeChild(_cells[1]);
                    };
                };
            };
        }

        public function setVisible(_arg_1:Boolean):void
        {
            this._localVisible = _arg_1;
        }


    }
}//package game.view.prop

