// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.control.LiveState

package game.view.control
{
    import game.view.arrow.ArrowView;
    import game.view.EnergyView;
    import game.view.prop.CustomPropBar;
    import game.view.tool.ToolStripView;
    import game.view.prop.RightPropBar;
    import game.view.prop.WeaponPropBar;
    import game.view.prop.VipPropBar;
    import game.view.prop.FightModelPropBar;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.BaseButton;
    import game.view.prop.BossSkillBar;
    import game.model.GameInfo;
    import flash.display.MovieClip;
    import game.model.LocalPlayer;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.SharedManager;
    import game.GameManager;
    import room.RoomManager;
    import ddt.events.SharedEvent;
    import ddt.events.GameEvent;
    import com.greensock.TweenLite;
    import flash.events.Event;
    import ddt.manager.SavePointManager;
    import flash.display.DisplayObjectContainer;
    import room.model.RoomInfo;
    import SingleDungeon.SingleDungeonManager;
    import ddt.events.LivingEvent;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.PlayerManager;
    import com.pickgliss.utils.ClassUtils;
    import game.model.Player;
    import road7th.utils.MovieClipWrapper;
    import com.pickgliss.utils.ObjectUtils;

    public class LiveState extends ControlState 
    {

        protected var _arrow:ArrowView;
        protected var _energy:EnergyView;
        protected var _customPropBar:CustomPropBar;
        protected var _tool:ToolStripView;
        protected var _rightPropBar:RightPropBar;
        protected var _weaponPropBar:WeaponPropBar;
        protected var _vipPropBar:VipPropBar;
        protected var _fightModelPropBar:FightModelPropBar;
        protected var _mouseControlBar:MouseControlBar;
        protected var _quickKeyBg:Bitmap;
        protected var _petSkillIsShowBtn:BaseButton;
        protected var _petSkillBtnCurrentFrame:int;
        protected var _petSkillIsShowBtnTopY:Number;
        private var _bossSkillBar:BossSkillBar;
        private var _gameInfo:GameInfo;
        private var threeShine:MovieClip;
        private var addOneShine:MovieClip;
        private var _currentState:Boolean = false;
        private var _hasShowMouseGuilde:Boolean;
        private var _angleTips:MovieClip;
        private var _forceTips:MovieClip;
        private var _useVipProp:Boolean = false;

        public function LiveState(_arg_1:LocalPlayer)
        {
            super(_arg_1);
        }

        override protected function configUI():void
        {
            var _local_1:Point;
            var _local_2:Point;
            this._quickKeyBg = ComponentFactory.Instance.creatBitmap("asset.game.mouseState.quickKeyBg.png");
            this._arrow = new ArrowView(_self);
            _local_1 = ComponentFactory.Instance.creatCustomObject("asset.game.ArrowViewPos");
            this._arrow.x = _local_1.x;
            this._arrow.y = _local_1.y;
            addChild(this._arrow);
            this._energy = new EnergyView(_self);
            _local_2 = ComponentFactory.Instance.creatCustomObject("asset.game.energyPos");
            this._energy.x = _local_2.x;
            this._energy.y = _local_2.y;
            addChild(this._energy);
            this._customPropBar = ComponentFactory.Instance.creatCustomObject("LiveCustomPropBar", [_self, FightControlBar.LIVE]);
            addChild(this._customPropBar);
            if (((_self.currentPet) && (_self.isBoss)))
            {
                this._bossSkillBar = new BossSkillBar(_self);
                PositionUtils.setPos(this._bossSkillBar, "asset.game.bossskillBarPos");
                addChild(this._bossSkillBar);
            };
            this._weaponPropBar = ComponentFactory.Instance.creatCustomObject("WeaponPropBar", [_self]);
            addChild(this._weaponPropBar);
            this._vipPropBar = ComponentFactory.Instance.creatCustomObject("VipPropBar", [_self]);
            addChild(this._vipPropBar);
            this._fightModelPropBar = ComponentFactory.Instance.creatCustomObject("FightModelPropBar", [_self]);
            addChild(this._fightModelPropBar);
            this._mouseControlBar = new MouseControlBar(_self);
            PositionUtils.setPos(this._mouseControlBar, "mouseControlBar.point");
            addChild(this._mouseControlBar);
            this.currentState = SharedManager.Instance.mouseModel;
            this._tool = new ToolStripView(_self);
            var _local_3:Point = ComponentFactory.Instance.creatCustomObject("asset.game.toolPos");
            this._tool.x = _local_3.x;
            this._tool.y = _local_3.y;
            addChild(this._tool);
            this._rightPropBar = ComponentFactory.Instance.creatCustomObject("RightPropBar", [_self, this]);
            this.setPropBarVisible();
            y = 600;
            super.configUI();
        }

        private function setPropBarVisible():void
        {
            if (this._rightPropBar)
            {
                if (((RoomManager.Instance.current.gameMode == 8) || (GameManager.Instance.Current.selfGamePlayer.isBoss)))
                {
                    this._rightPropBar.hidePropBar();
                };
            };
        }

        override protected function addEvent():void
        {
            SharedManager.Instance.addEventListener(SharedEvent.TRANSPARENTCHANGED, this.__transparentChanged);
            this._tool.addEventListener(GameEvent.MOUSE_STATE_CHANGE, this.__mouseStateChange);
            GameManager.Instance.addEventListener(GameManager.MOVE_PROPBAR, this.__moveProp);
            super.addEvent();
        }

        private function __moveProp(_arg_1:Event):void
        {
            this._useVipProp = true;
            if (this._weaponPropBar != null)
            {
                TweenLite.to(this._weaponPropBar, 0.5, {"x":(this._weaponPropBar.x - 60)});
            };
            if (this._fightModelPropBar != null)
            {
                TweenLite.to(this._fightModelPropBar, 0.5, {"x":(this._fightModelPropBar.x - 60)});
            };
            if (((!(this._customPropBar == null)) && (this._currentState)))
            {
                TweenLite.to(this._customPropBar, 0.5, {"x":(this._customPropBar.x - 60)});
            };
        }

        protected function __transparentChanged(_arg_1:Event):void
        {
            if (SharedManager.Instance.propTransparent)
            {
                this._arrow.alpha = 0.5;
                this._energy.alpha = 0.5;
                this._customPropBar.alpha = 0.5;
                this._weaponPropBar.alpha = 0.5;
                this._vipPropBar.alpha = 0.5;
                this._fightModelPropBar.alpha = 0.5;
                this._tool.alpha = 0.5;
                if (this._bossSkillBar)
                {
                    this._bossSkillBar.alpha = 0.5;
                };
            }
            else
            {
                this._arrow.alpha = 1;
                this._energy.alpha = 1;
                this._customPropBar.alpha = 1;
                this._weaponPropBar.alpha = 1;
                this._vipPropBar.alpha = 1;
                this._fightModelPropBar.alpha = 1;
                this._tool.alpha = 1;
                if (this._bossSkillBar)
                {
                    this._bossSkillBar.alpha = 1;
                };
            };
        }

        protected function __mouseStateChange(_arg_1:GameEvent):void
        {
            this.mouseStateTweenOut();
            this.currentState = (!(this._currentState));
            _self.mouseState = this._currentState;
            if (this._currentState)
            {
                if (_self.isBoss)
                {
                    this._bossSkillBar.removeMoveGuide();
                };
                if ((!(this._hasShowMouseGuilde)))
                {
                    this._hasShowMouseGuilde = true;
                    this._mouseControlBar.showLead();
                };
            };
            _self.dispatchEvent(new GameEvent(GameEvent.MOUSE_MODEL_STATE));
        }

        private function movePosition():void
        {
            if (this._currentState)
            {
                this._energy.visible = false;
                this._arrow.visible = false;
                PositionUtils.setPos(this._fightModelPropBar, "FightModelPropBar.pos2");
                PositionUtils.setPos(this._weaponPropBar, "WeaponPropBar.pos2");
                PositionUtils.setPos(this._vipPropBar, "VipPropBar.Pos2");
                if (_self.isBoss)
                {
                    PositionUtils.setPos(this._customPropBar, "CustomPropPos3");
                }
                else
                {
                    PositionUtils.setPos(this._customPropBar, "CustomPropPos2");
                };
            }
            else
            {
                this._energy.visible = true;
                this._arrow.visible = true;
                PositionUtils.setPos(this._vipPropBar, "VipPropBar.Pos1");
                PositionUtils.setPos(this._weaponPropBar, "WeaponPropBar.pos1");
                this._fightModelPropBar.x = (this._weaponPropBar.x + this._weaponPropBar.width);
                PositionUtils.setPos(this._customPropBar, "CustomPropPos1");
                PositionUtils.setPos(this._fightModelPropBar, "FightModelPropBar.pos1");
            };
            if (this._useVipProp)
            {
                this._fightModelPropBar.x = (this._fightModelPropBar.x - 60);
                this._weaponPropBar.x = (this._weaponPropBar.x - 60);
                if (this._currentState)
                {
                    this._customPropBar.x = (this._customPropBar.x - 60);
                };
            };
        }

        protected function mouseStateTweenOut():void
        {
            TweenLite.to(this, 0.3, {
                "y":600,
                "onComplete":this.mouseStateTweenIn
            });
        }

        protected function mouseStateTweenIn():void
        {
            y = 600;
            TweenLite.to(this, 0.3, {"y":498});
        }

        public function set currentState(_arg_1:Boolean):void
        {
            this._currentState = _arg_1;
            this._mouseControlBar.state = this._currentState;
            if (SavePointManager.Instance.isInSavePoint(4))
            {
                this._hasShowMouseGuilde = true;
                this._mouseControlBar.showLead();
            };
            this._quickKeyBg.visible = this._currentState;
            this.movePosition();
        }

        override protected function removeEvent():void
        {
            SharedManager.Instance.removeEventListener(SharedEvent.TRANSPARENTCHANGED, this.__transparentChanged);
            this._tool.removeEventListener(GameEvent.MOUSE_STATE_CHANGE, this.__mouseStateChange);
            GameManager.Instance.removeEventListener(GameManager.MOVE_PROPBAR, this.__moveProp);
            super.removeEvent();
        }

        override public function enter(_arg_1:DisplayObjectContainer):void
        {
            this._customPropBar.enter();
            this._weaponPropBar.enter();
            this._vipPropBar.enter();
            this._fightModelPropBar.enter();
            this._energy.enter();
            this._arrow.enter();
            this._rightPropBar.setup(_arg_1);
            this._rightPropBar.enter();
            this._gameInfo = GameManager.Instance.Current;
            this.loadWeakGuild();
            this.__transparentChanged(null);
            super.enter(_arg_1);
        }

        override public function leaving(_arg_1:Function=null):void
        {
            this._customPropBar.leaving();
            this._rightPropBar.leaving();
            this._weaponPropBar.leaving();
            this._vipPropBar.leaving();
            this._fightModelPropBar.leaving();
            this._energy.leaving();
            this._arrow.leaving();
            super.leaving(_arg_1);
        }

        override public function tweenIn():void
        {
            if (_container)
            {
                _container.addChild(this);
            };
            TweenLite.killTweensOf(this);
            TweenLite.killTweensOf(this._rightPropBar);
            TweenLite.to(this, 0.3, {"y":498});
            TweenLite.to(this._rightPropBar, 0.3, {"x":0});
        }

        override public function tweenOut():void
        {
            TweenLite.killTweensOf(this);
            TweenLite.killTweensOf(this._rightPropBar);
            TweenLite.to(this._rightPropBar, 0.3, {"x":60});
            TweenLite.to(this, 0.3, {
                "y":600,
                "onComplete":leavingComplete
            });
        }

        protected function loadWeakGuild():void
        {
            this.setRightPropVisible(false, 0, 1, 2, 3, 4, 5, 6);
            this._fightModelPropBar.setPropCellVisible(true, 0, 1);
            this._fightModelPropBar.removeKeyRepose(true);
            this._weaponPropBar.setFlyVisible(false);
            this._weaponPropBar.setDeputyWeaponVisible(false);
            this._rightPropBar.setArrowVisible(false);
            if (SavePointManager.Instance.savePoints[4])
            {
                this.setRightPropVisible(true, 1);
            };
            if (SavePointManager.Instance.savePoints[6])
            {
                this.setRightPropVisible(true, 1, 2);
                this._fightModelPropBar.removeKeyRepose(true);
            };
            if (SavePointManager.Instance.savePoints[12])
            {
                this.setRightPropVisible(true, 1, 2, 3, 4, 5, 6);
                this._rightPropBar.setArrowVisible(true);
            };
            if (SavePointManager.Instance.savePoints[19])
            {
                this.setRightPropVisible(true, 0, 1, 2, 3, 4, 5, 6);
                this._rightPropBar.setArrowVisible(true);
                this._weaponPropBar.setFlyVisible(true);
                this._weaponPropBar.setDeputyWeaponVisible(true);
            };
            if (this._gameInfo.roomType == RoomInfo.SINGLE_DUNGEON)
            {
                if (SavePointManager.Instance.isInSavePoint(4))
                {
                    if (this._gameInfo.missionInfo.missionIndex == 1)
                    {
                        this._rightPropBar.setBackGroundVisible(false);
                        GameManager.Instance.addEventListener(GameEvent.GET_THREE_ICON, this.__showThreeIcon);
                    }
                    else
                    {
                        this.setRightPropVisible(true, 1);
                    };
                };
                if (((SavePointManager.Instance.isInSavePoint(6)) && ((SingleDungeonManager.Instance.currentMapId == 1005) || (SingleDungeonManager.Instance.currentMapId == 2005))))
                {
                    GameManager.Instance.addEventListener(GameEvent.GET_ADDONE_ICON, this.__showAddOneIcon);
                    this.setRightPropVisible(true, 1);
                };
                if (SavePointManager.Instance.isInSavePoint(12))
                {
                    this.setRightPropVisible(true, 1, 2);
                    GameManager.Instance.addEventListener(GameEvent.GET_POWMAX_ICON, this.__showPowMaxIcon);
                };
                if (((SavePointManager.Instance.isInSavePoint(19)) && ((SingleDungeonManager.Instance.currentMapId == 1008) || (SingleDungeonManager.Instance.currentMapId == 2008))))
                {
                    this.addThreeShine();
                    if (this._gameInfo.missionInfo.missionIndex == 1)
                    {
                        this._gameInfo.selfGamePlayer.addEventListener(LivingEvent.ATTACKING_CHANGED, this.__showThreeAndAddOneArrow);
                        this._gameInfo.selfGamePlayer.addEventListener(LivingEvent.SHOW_TIP_THREEANDADDONE, this.__showThreeAndAddOneArrow);
                        if (this._gameInfo.selfGamePlayer.mouseState)
                        {
                            NewHandContainer.Instance.showArrow(ArrowType.TIP_POWERMODE, 0, "trainer.mouseModeClickPowerPos", "asset.trainer.clickUsePower", "trainer.mouseModeClickPowerTipPos");
                        }
                        else
                        {
                            NewHandContainer.Instance.showArrow(ArrowType.TIP_POWERMODE, 0, "trainer.clickPowerPos", "asset.trainer.clickUsePower", "trainer.clickPowerTipPos");
                        };
                    };
                    if (this._gameInfo.missionInfo.missionIndex > 1)
                    {
                        this._angleTips = ComponentFactory.Instance.creat("asset.trainer9.mcAngle");
                        this._forceTips = ComponentFactory.Instance.creat("asset.trainer9.mcEnergy");
                        LayerManager.Instance.addToLayer(this._angleTips, LayerManager.GAME_UI_LAYER);
                        LayerManager.Instance.addToLayer(this._forceTips, LayerManager.GAME_UI_LAYER);
                        this._forceTips.x = 70;
                        this._angleTips.visible = false;
                        this._forceTips.visible = false;
                        this._gameInfo.selfGamePlayer.addEventListener(LivingEvent.ATTACKING_CHANGED, this.__showAngleTips);
                        this._gameInfo.selfGamePlayer.addEventListener(LivingEvent.GUNANGLE_CHANGED, this.__gunAngleChange);
                        this._gameInfo.selfGamePlayer.addEventListener(LivingEvent.USE_PLANE, this.__usePlane);
                        GameManager.Instance.addEventListener(GameEvent.GET_PLANE_ICON, this.__showPlaneIcon);
                        GameManager.Instance.addEventListener(GameEvent.GET_ADDTWO_ICON, this.__showAddTwoIcon);
                    };
                    this.setRightPropVisible(true, 1, 2, 3, 4, 5, 6);
                    this._rightPropBar.setArrowVisible(true);
                };
                if (((SavePointManager.Instance.isInSavePoint(10)) && (SingleDungeonManager.Instance.currentMapId == 6)))
                {
                    this.addThreeShine();
                    this._gameInfo.selfGamePlayer.addEventListener(LivingEvent.ATTACKING_CHANGED, this.__showThreeAndAddOneArrow);
                    this._rightPropBar.addEventListener(GameEvent.USE_THREE, this.__useThree);
                    this._rightPropBar.addEventListener(GameEvent.USE_ADDONE, this.__useAddOne);
                };
            };
            if (_self.isBoss)
            {
                this._fightModelPropBar.setPropCellVisible(false, 0, 1);
            };
            if ((((!(SavePointManager.Instance.savePoints[76])) && (PlayerManager.Instance.Self.IsVIP)) && ((this._gameInfo.roomType == RoomInfo.SINGLE_DUNGEON) || (this._gameInfo.roomType == RoomInfo.DUNGEON_ROOM))))
            {
                NewHandContainer.Instance.showArrow(ArrowType.TIP_USE_T, 0, "trainer.ClickTArrowPos", "", "");
            };
        }

        private function addThreeShine():void
        {
            var _local_1:Point;
            var _local_2:Point;
            this.threeShine = (ClassUtils.CreatInstance("asset.trainer.toolShine") as MovieClip);
            this.addOneShine = (ClassUtils.CreatInstance("asset.trainer.toolShine") as MovieClip);
            _local_1 = ComponentFactory.Instance.creatCustomObject("trainer.useThreeShine");
            _local_2 = ComponentFactory.Instance.creatCustomObject("trainer.useAddOneShine");
            this.threeShine.x = _local_1.x;
            this.threeShine.y = _local_1.y;
            this.addOneShine.x = _local_2.x;
            this.addOneShine.y = _local_2.y;
            this.threeShine.visible = false;
            this.addOneShine.visible = false;
            LayerManager.Instance.addToLayer(this.threeShine, LayerManager.GAME_UI_LAYER, false);
            LayerManager.Instance.addToLayer(this.addOneShine, LayerManager.GAME_UI_LAYER, false);
        }

        private function __onDander(_arg_1:LivingEvent):void
        {
            if (this._gameInfo.selfGamePlayer.isAttacking)
            {
                if (GameManager.Instance.Current.selfGamePlayer.dander >= Player.TOTAL_DANDER)
                {
                    NewHandContainer.Instance.showArrow(ArrowType.TIP_POWER, -30, "trainer.posTipPower");
                };
            }
            else
            {
                NewHandContainer.Instance.clearArrowByID(-1);
            };
        }

        private function __gunAngleChange(_arg_1:LivingEvent):void
        {
            if (((this._gameInfo.selfGamePlayer.isAttacking) && (!(NewHandContainer.Instance.hasArrow(ArrowType.TIP_PLANE)))))
            {
                if (this._gameInfo.selfGamePlayer.gunAngle == 70)
                {
                    if (((this._gameInfo.selfGamePlayer.pos.y > 600) && (this._gameInfo.selfGamePlayer.flyEnabled)))
                    {
                        this._angleTips.visible = false;
                        NewHandContainer.Instance.showArrow(ArrowType.TIP_PLANE, 0, "trainer.posTipPlane");
                    }
                    else
                    {
                        this._angleTips.visible = false;
                        this._forceTips.visible = true;
                        this._forceTips.gotoAndPlay(2);
                    };
                };
            };
        }

        private function __usePlane(_arg_1:LivingEvent):void
        {
            if (((this._gameInfo.selfGamePlayer.isAttacking) && (!(NewHandContainer.Instance.hasArrow(ArrowType.TIP_PLANE)))))
            {
                if (((this._gameInfo.selfGamePlayer.gunAngle == 70) && (this._gameInfo.selfGamePlayer.pos.y > 600)))
                {
                    this._angleTips.visible = false;
                    this._forceTips.visible = true;
                    this._forceTips.gotoAndPlay(2);
                };
            };
        }

        private function __showAngleTips(_arg_1:LivingEvent):void
        {
            if (this._gameInfo.selfGamePlayer.isAttacking)
            {
                if (this._gameInfo.selfGamePlayer.pos.y < 600)
                {
                    this._gameInfo.selfGamePlayer.direction = 1;
                    this._forceTips.x = 153;
                    if (this._gameInfo.selfGamePlayer.gunAngle != 70)
                    {
                        this._angleTips.visible = true;
                        this._forceTips.visible = false;
                        this._angleTips.gotoAndPlay(2);
                    }
                    else
                    {
                        this._angleTips.visible = false;
                        this._forceTips.visible = true;
                        this._forceTips.gotoAndPlay(2);
                    };
                };
                if (this._gameInfo.selfGamePlayer.pos.y > 600)
                {
                    this._gameInfo.selfGamePlayer.direction = -1;
                    if (this._gameInfo.selfGamePlayer.gunAngle != 70)
                    {
                        this._angleTips.visible = true;
                        this._forceTips.visible = false;
                        this._angleTips.gotoAndPlay(2);
                    }
                    else
                    {
                        if ((!(NewHandContainer.Instance.hasArrow(ArrowType.TIP_PLANE))))
                        {
                            NewHandContainer.Instance.showArrow(ArrowType.TIP_PLANE, 0, "trainer.posTipPlane");
                        };
                    };
                };
            }
            else
            {
                this._angleTips.visible = false;
                this._forceTips.visible = false;
            };
        }

        private function __showThreeAndAddOneArrow(_arg_1:LivingEvent=null):void
        {
            if ((((SavePointManager.Instance.isInSavePoint(19)) && (this._gameInfo.missionInfo.missionIndex == 1)) && (NewHandContainer.Instance.hasArrow(ArrowType.TIP_POWERMODE))))
            {
                return;
            };
            if (this._gameInfo.selfGamePlayer.isAttacking)
            {
                NewHandContainer.Instance.showArrow(ArrowType.TIP_THREE, -90, "trainer.posTipThreeAndAddOne", "asset.trainer.clickUseTool", "trainer.useThreeAndAddOneTipPos");
                this.threeShine.visible = true;
                this.addOneShine.visible = true;
            }
            else
            {
                NewHandContainer.Instance.clearArrowByID(-1);
                this.threeShine.visible = false;
                this.addOneShine.visible = false;
            };
        }

        private function __useThree(_arg_1:GameEvent):void
        {
            this.threeShine.visible = false;
            if ((!(this.addOneShine.visible)))
            {
                NewHandContainer.Instance.clearArrowByID(-1);
            };
        }

        private function __useAddOne(_arg_1:GameEvent):void
        {
            this.addOneShine.visible = false;
            if ((!(this.threeShine.visible)))
            {
                NewHandContainer.Instance.clearArrowByID(-1);
            };
        }

        private function __showThreeArrow(_arg_1:LivingEvent=null):void
        {
            if (this._gameInfo.selfGamePlayer.isAttacking)
            {
                NewHandContainer.Instance.showArrow(ArrowType.TIP_THREE, -90, "trainer.posTipThree", "asset.trainer.clickUseTool", "trainer.useThreeTipPos");
            }
            else
            {
                NewHandContainer.Instance.clearArrowByID(-1);
            };
        }

        private function __showThreeIcon(_arg_1:GameEvent):void
        {
            GameManager.Instance.removeEventListener(GameEvent.GET_THREE_ICON, this.__showThreeIcon);
            this.setRightPropVisible(true, 1);
            this._rightPropBar.setBackGroundVisible(true);
            this._gameInfo.selfGamePlayer.addEventListener(LivingEvent.ATTACKING_CHANGED, this.__showThreeArrow);
        }

        private function __showAddOneIcon(_arg_1:GameEvent):void
        {
            GameManager.Instance.removeEventListener(GameEvent.GET_ADDONE_ICON, this.__showAddOneIcon);
            this.setRightPropVisible(true, 2);
        }

        private function __showAddLeadIcon(_arg_1:GameEvent):void
        {
            GameManager.Instance.removeEventListener(GameEvent.GET_LEAD_ICON, this.__showAddLeadIcon);
            this._fightModelPropBar.setPropCellVisible(true, 0, 1);
        }

        private function __showPowMaxIcon(_arg_1:GameEvent):void
        {
            GameManager.Instance.removeEventListener(GameEvent.GET_ADDONE_ICON, this.__showPowMaxIcon);
            this.setRightPropVisible(true, 3, 4, 5, 6);
            this._rightPropBar.setArrowVisible(true);
        }

        private function __showAddTwoIcon(_arg_1:GameEvent):void
        {
            GameManager.Instance.removeEventListener(GameEvent.GET_ADDONE_ICON, this.__showAddTwoIcon);
            this.setRightPropVisible(true, 0);
        }

        private function __showPlaneIcon(_arg_1:GameEvent):void
        {
            GameManager.Instance.removeEventListener(GameEvent.GET_PLANE_ICON, this.__showPlaneIcon);
            this._weaponPropBar.setFlyVisible(true);
            this._weaponPropBar.setDeputyWeaponVisible(true);
        }

        private function propOpenShow(_arg_1:String):void
        {
            var _local_2:MovieClipWrapper = new MovieClipWrapper(ClassUtils.CreatInstance(_arg_1), true, true);
            LayerManager.Instance.addToLayer(_local_2.movie, LayerManager.GAME_UI_LAYER, false);
        }

        protected function setWeaponPropVisible(_arg_1:Boolean):void
        {
            this._weaponPropBar.setVisible(_arg_1);
            if (_arg_1)
            {
                if ((!(this._weaponPropBar.parent)))
                {
                    addChild(this._weaponPropBar);
                };
            }
            else
            {
                if (this._weaponPropBar.parent)
                {
                    this._weaponPropBar.parent.removeChild(this._weaponPropBar);
                };
            };
        }

        protected function setRightPropVisible(_arg_1:Boolean, ... _args):void
        {
            var _local_3:int;
            while (_local_3 < _args.length)
            {
                this._rightPropBar.setPropVisible(_args[_local_3], _arg_1);
                _local_3++;
            };
        }

        protected function setSelfPropBarVisible(_arg_1:Boolean):void
        {
            this._customPropBar.setVisible(_arg_1);
            if (_arg_1)
            {
                if ((!(this._customPropBar.parent)))
                {
                    addChild(this._customPropBar);
                };
            }
            else
            {
                if (this._customPropBar.parent)
                {
                    this._customPropBar.parent.removeChild(this._customPropBar);
                };
            };
        }

        protected function setArrowVisible(_arg_1:Boolean):void
        {
            this._arrow.visible = _arg_1;
        }

        public function setEnergyVisible(_arg_1:Boolean):void
        {
            this._energy.visible = _arg_1;
        }

        override public function dispose():void
        {
            super.dispose();
            if (((this._gameInfo) && (this._gameInfo.selfGamePlayer)))
            {
                this._gameInfo.selfGamePlayer.removeEventListener(LivingEvent.ATTACKING_CHANGED, this.__onDander);
                this._gameInfo.selfGamePlayer.removeEventListener(LivingEvent.DANDER_CHANGED, this.__onDander);
                this._gameInfo.selfGamePlayer.removeEventListener(LivingEvent.ATTACKING_CHANGED, this.__showThreeArrow);
                this._gameInfo.selfGamePlayer.removeEventListener(LivingEvent.ATTACKING_CHANGED, this.__showThreeAndAddOneArrow);
                this._gameInfo.selfGamePlayer.removeEventListener(LivingEvent.USE_PLANE, this.__usePlane);
                this._gameInfo.selfGamePlayer.removeEventListener(LivingEvent.SHOW_TIP_THREEANDADDONE, this.__showThreeAndAddOneArrow);
                this._gameInfo.selfGamePlayer.removeEventListener(LivingEvent.ATTACKING_CHANGED, this.__showAngleTips);
                this._gameInfo.selfGamePlayer.removeEventListener(LivingEvent.GUNANGLE_CHANGED, this.__gunAngleChange);
            };
            GameManager.Instance.removeEventListener(GameEvent.GET_THREE_ICON, this.__showThreeIcon);
            GameManager.Instance.removeEventListener(GameEvent.GET_ADDONE_ICON, this.__showAddOneIcon);
            GameManager.Instance.removeEventListener(GameEvent.GET_LEAD_ICON, this.__showAddLeadIcon);
            GameManager.Instance.removeEventListener(GameEvent.GET_POWMAX_ICON, this.__showPowMaxIcon);
            GameManager.Instance.removeEventListener(GameEvent.GET_ADDTWO_ICON, this.__showAddTwoIcon);
            GameManager.Instance.removeEventListener(GameEvent.GET_PLANE_ICON, this.__showPlaneIcon);
            this._rightPropBar.removeEventListener(GameEvent.USE_THREE, this.__useThree);
            this._rightPropBar.removeEventListener(GameEvent.USE_ADDONE, this.__useAddOne);
            this._gameInfo = null;
            ObjectUtils.disposeObject(this._arrow);
            this._arrow = null;
            ObjectUtils.disposeObject(this._energy);
            this._energy = null;
            ObjectUtils.disposeObject(this._customPropBar);
            this._customPropBar = null;
            ObjectUtils.disposeObject(this._weaponPropBar);
            this._weaponPropBar = null;
            ObjectUtils.disposeObject(this._vipPropBar);
            this._vipPropBar = null;
            ObjectUtils.disposeObject(this._fightModelPropBar);
            this._fightModelPropBar = null;
            ObjectUtils.disposeObject(this._tool);
            this._tool = null;
            ObjectUtils.disposeObject(this._mouseControlBar);
            this._mouseControlBar = null;
            ObjectUtils.disposeObject(this._quickKeyBg);
            this._quickKeyBg = null;
            ObjectUtils.disposeObject(this._rightPropBar);
            this._rightPropBar = null;
            ObjectUtils.disposeObject(this.threeShine);
            this.threeShine = null;
            ObjectUtils.disposeObject(this.addOneShine);
            this.addOneShine = null;
            ObjectUtils.disposeObject(this._angleTips);
            this._angleTips = null;
            ObjectUtils.disposeObject(this._forceTips);
            this._forceTips = null;
            if (this._bossSkillBar)
            {
                ObjectUtils.disposeObject(this._bossSkillBar);
                this._bossSkillBar = null;
            };
        }


    }
}//package game.view.control

