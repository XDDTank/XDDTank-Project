// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.arrow.ArrowView

package game.view.arrow
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import game.model.LocalPlayer;
    import ddt.view.common.GradientText;
    import flash.display.MovieClip;
    import com.pickgliss.effect.IEffect;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.GraphicsUtils;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.view.tips.ToolPropInfo;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.effect.EffectManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.events.LivingEvent;
    import flash.events.Event;
    import org.aswing.KeyboardManager;
    import flash.events.KeyboardEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import flash.utils.getTimer;
    import flash.ui.Keyboard;
    import org.aswing.KeyStroke;
    import room.model.WeaponInfo;
    import ddt.manager.SoundManager;
    import ddt.manager.ChatManager;
    import com.pickgliss.ui.controls.SimpleBitmapButton;

    public class ArrowView extends Sprite implements Disposeable 
    {

        public static const FLY_CD:int = 2;
        public static const HIDE_BAR:String = "hide bar";
        public static const USE_TOOL:String = "use_tool";
        public static const ADD_BLOOD_CD:int = 2;
        public static const RANDOW_COLORSII:Array = [[1351165, 0xFFDE00], [1478655, 2607344], [1555258, 14293039], [7912215, 14293199], [12862218, 7721224], [0xDE6E00, 15970051], [6011902, 832292], [521814, 13411850], [15035908, 11327256], [15118867, 8369930], [2213785, 8116729], [10735137, 14497882], [15460371, 15430666], [13032456, 2861311], [16670299, 12510266], [44799, 7721224]];
        public static const ANGLE_NEXTCHANGE_TIME:int = 100;

        private var _bg:ArrowBg;
        private var _info:LocalPlayer;
        private var _sector:Sprite;
        private var _recordChangeBefore:Number;
        private var _flyCoolDown:int = 0;
        private var _flyEnable:Boolean;
        private var _isLockFly:Boolean = false;
        private var rotationCountField:GradientText;
        private var _hammerCoolDown:int = 0;
        private var _hammerEnable:Boolean;
        private var _deputyWeaponResCount:int;
        private var _AngelLine:MovieClip;
        private var _ShineKey:Boolean;
        public var _AnglelShineEffect:IEffect;
        private var _hideState:Boolean;
        private var _enableArrow:Boolean;
        private var _currentAngleChangeTime:int = 0;
        private var _first:Boolean = true;
        private var _recordRotation:Number;
        private var _hammerBlocked:Boolean;

        public function ArrowView(_arg_1:LocalPlayer)
        {
            var _local_3:Point;
            super();
            this._info = _arg_1;
            this._bg = (ComponentFactory.Instance.creatCustomObject("game.view.arrowBg") as ArrowBg);
            addChild(this._bg);
            this._bg.arrowSub.arrowClone_mc.visible = false;
            this._bg.arrowSub.arrowChonghe_mc.visible = false;
            this._sector = GraphicsUtils.drawSector(0, 0, 55, 0, 90);
            this._sector.y = 1;
            this._bg.arrowSub.circle_mc.mask = this._sector;
            this._bg.arrowSub.circle_mc.visible = true;
            this._bg.arrowSub.green_mc.visible = false;
            this._bg.arrowSub.addChild(this._sector);
            var _local_2:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("asset.game.rotationCountFieldText");
            this.rotationCountField = new GradientText(_local_2, RANDOW_COLORSII);
            _local_3 = ComponentFactory.Instance.creatCustomObject("asset.game.rotationCountPos");
            this.rotationCountField.x = _local_3.x;
            this.rotationCountField.y = _local_3.y;
            addChild(this.rotationCountField);
            this.rotationCountField.filters = ComponentFactory.Instance.creatFilters("game.rotationCountField_Filter");
            this.rotationCountField.setText(this.rotationCountField.text);
            this.reset();
            this.__weapAngle(null);
            this.__changeDirection(null);
            this.flyEnable = true;
            this.hammerEnable = true;
            this._flyCoolDown = 0;
            this._hammerCoolDown = 0;
            if (((this._info.selfInfo) && (this._info.selfInfo.DeputyWeapon)))
            {
                this._deputyWeaponResCount = (this._info.selfInfo.DeputyWeapon.StrengthenLevel + 1);
            };
            this.updataAngleLine();
        }

        public function set flyEnable(_arg_1:Boolean):void
        {
            if (_arg_1 == this._flyEnable)
            {
                return;
            };
            this._flyEnable = _arg_1;
            if (this._isLockFly)
            {
                this._info.flyEnabled = false;
            }
            else
            {
                this._info.flyEnabled = this._flyEnable;
            };
        }

        public function set hammerEnable(_arg_1:Boolean):void
        {
            if (_arg_1 == this._hammerEnable)
            {
                return;
            };
            if ((!(this._info.hasDeputyWeapon())))
            {
                this._hammerEnable = false;
            }
            else
            {
                this._hammerEnable = _arg_1;
            };
            this._info.deputyWeaponEnabled = this._hammerEnable;
        }

        public function get hammerEnable():Boolean
        {
            return (this._hammerEnable);
        }

        public function disable():void
        {
            this.flyEnable = false;
            if ((!(this._info.currentDeputyWeaponInfo.isShield)))
            {
                this.hammerEnable = false;
            };
        }

        private function updataAngleLine():void
        {
        }

        private function setTip(_arg_1:BaseButton, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:String="0", _arg_6:Boolean=true, _arg_7:int=10):void
        {
            _arg_1.tipStyle = "core.ToolPropTips";
            _arg_1.tipDirctions = _arg_5;
            _arg_1.tipGapV = 0;
            _arg_1.tipGapH = _arg_7;
            var _local_8:ItemTemplateInfo = new ItemTemplateInfo();
            _local_8.Name = _arg_2;
            _local_8.Property4 = _arg_3;
            _local_8.Description = _arg_4;
            var _local_9:ToolPropInfo = new ToolPropInfo();
            _local_9.info = _local_8;
            _local_9.count = 1;
            _local_9.showTurn = false;
            _local_9.showThew = _arg_6;
            _local_9.showCount = false;
            _arg_1.tipData = _local_9;
        }

        private function reset():void
        {
            this._bg.arrowSub.green_mc.mask = null;
            this._bg.arrowSub.circle_mc.mask = this._sector;
            this._bg.arrowSub.circle_mc.visible = true;
            this._bg.arrowSub.green_mc.visible = false;
            if (((this._info) && (this._info.currentWeapInfo)))
            {
                GraphicsUtils.changeSectorAngle(this._sector, 0, 0, 55, this._info.currentWeapInfo.armMinAngle, ((this._info.currentWeapInfo.armMaxAngle - this._info.currentWeapInfo.armMinAngle) + 1));
            };
        }

        public function set hideState(_arg_1:Boolean):void
        {
            this._hideState = _arg_1;
        }

        public function get hideState():Boolean
        {
            return (this._hideState);
        }

        private function carrayAngle():void
        {
            this._bg.arrowSub.circle_mc.mask = null;
            this._bg.arrowSub.green_mc.mask = this._sector;
            this._bg.arrowSub.circle_mc.visible = false;
            this._bg.arrowSub.green_mc.visible = true;
            GraphicsUtils.changeSectorAngle(this._sector, 0, 0, 55, 0, 90);
        }

        public function dispose():void
        {
            if (this._AnglelShineEffect)
            {
                EffectManager.Instance.removeEffect(this._AnglelShineEffect);
            };
            this.removeEvent();
            ObjectUtils.disposeObject(this._bg);
            ObjectUtils.disposeObject(this._sector);
            ObjectUtils.disposeObject(this.rotationCountField);
            ObjectUtils.disposeObject(this._AngelLine);
            this._bg = null;
            this._info = null;
            this._sector = null;
            this.rotationCountField = null;
            this._AngelLine = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        private function initEvents():void
        {
            this._info.addEventListener(LivingEvent.GUNANGLE_CHANGED, this.__weapAngle);
            this._info.addEventListener(LivingEvent.DIR_CHANGED, this.__changeDirection);
            this._info.addEventListener(LivingEvent.ANGLE_CHANGED, this.__changeAngle);
            this._info.addEventListener(LivingEvent.BOMB_CHANGED, this.__changeBall);
            this._info.addEventListener(LivingEvent.ATTACKING_CHANGED, this.__setArrowClone);
            this._info.addEventListener(LivingEvent.ATTACKING_CHANGED, this.__change);
            this._info.addEventListener(LivingEvent.BEGIN_NEW_TURN, this.__onTurnChange);
            this._info.addEventListener(LivingEvent.DIE, this.__die);
            this._info.addEventListener(LivingEvent.LOCKANGLE_CHANGE, this.__lockAngleChangeHandler);
            addEventListener(Event.ENTER_FRAME, this.__enterFrame);
            KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN, this.__keydown);
            KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN, this.__inputKeyDown);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USE_DEPUTY_WEAPON, this.__setDeputyWeaponNumber);
        }

        private function removeEvent():void
        {
            this._info.removeEventListener(LivingEvent.GUNANGLE_CHANGED, this.__weapAngle);
            this._info.removeEventListener(LivingEvent.DIR_CHANGED, this.__changeDirection);
            this._info.removeEventListener(LivingEvent.ANGLE_CHANGED, this.__changeAngle);
            this._info.removeEventListener(LivingEvent.BOMB_CHANGED, this.__changeBall);
            this._info.removeEventListener(LivingEvent.ATTACKING_CHANGED, this.__setArrowClone);
            this._info.removeEventListener(LivingEvent.ATTACKING_CHANGED, this.__change);
            this._info.removeEventListener(LivingEvent.DIE, this.__die);
            this._info.removeEventListener(LivingEvent.BEGIN_NEW_TURN, this.__onTurnChange);
            this._info.removeEventListener(LivingEvent.LOCKANGLE_CHANGE, this.__lockAngleChangeHandler);
            removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
            KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN, this.__keydown);
            KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN, this.__inputKeyDown);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.USE_DEPUTY_WEAPON, this.__setDeputyWeaponNumber);
        }

        private function __lockAngleChangeHandler(_arg_1:LivingEvent):void
        {
            this.enableArrow = this._info.isLockAngle;
        }

        public function set enableArrow(_arg_1:Boolean):void
        {
            this._enableArrow = _arg_1;
            if ((!(_arg_1)))
            {
                addEventListener(Event.ENTER_FRAME, this.__enterFrame);
                KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN, this.__inputKeyDown);
            }
            else
            {
                KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN, this.__inputKeyDown);
                removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
            };
        }

        private function __onTurnChange(_arg_1:LivingEvent):void
        {
            this.rotationCountField.setText(this.rotationCountField.text);
        }

        private function __die(_arg_1:Event):void
        {
            if ((!(this._info.isLiving)))
            {
                this.flyEnable = false;
                this.hammerEnable = false;
            };
        }

        private function __enterFrame(_arg_1:Event):void
        {
            var _local_4:Boolean;
            var _local_2:int = getTimer();
            if ((_local_2 - this._currentAngleChangeTime) < ANGLE_NEXTCHANGE_TIME)
            {
                return;
            };
            var _local_3:Boolean;
            if (((KeyboardManager.isDown(KeyStroke.VK_S.getCode())) || (KeyboardManager.isDown(Keyboard.DOWN))))
            {
                if (this._currentAngleChangeTime != 0)
                {
                    _local_3 = this._info.manuallySetGunAngle((this._info.gunAngle - (WeaponInfo.ROTATITON_SPEED * this._info.reverse)));
                }
                else
                {
                    this._currentAngleChangeTime = getTimer();
                };
                _local_4 = true;
            }
            else
            {
                if (((KeyboardManager.isDown(KeyStroke.VK_W.getCode())) || (KeyboardManager.isDown(Keyboard.UP))))
                {
                    if (this._currentAngleChangeTime != 0)
                    {
                        _local_3 = this._info.manuallySetGunAngle((this._info.gunAngle + (WeaponInfo.ROTATITON_SPEED * this._info.reverse)));
                    };
                    if (this._currentAngleChangeTime == 0)
                    {
                        this._currentAngleChangeTime = getTimer();
                    };
                    _local_4 = true;
                };
            };
            if ((!(_local_4)))
            {
                this._currentAngleChangeTime = 0;
            };
            if (_local_3)
            {
                SoundManager.instance.play("006");
            };
        }

        private function __inputKeyDown(_arg_1:KeyboardEvent):void
        {
            var _local_2:Boolean;
            if ((!(ChatManager.Instance.input.inputField.isFocus())))
            {
                _local_2 = false;
                if (((_arg_1.keyCode == KeyStroke.VK_S.getCode()) || (_arg_1.keyCode == Keyboard.DOWN)))
                {
                    _local_2 = this._info.manuallySetGunAngle((this._info.gunAngle - (WeaponInfo.ROTATITON_SPEED * this._info.reverse)));
                    this._currentAngleChangeTime = 0;
                }
                else
                {
                    if (((_arg_1.keyCode == KeyStroke.VK_W.getCode()) || (_arg_1.keyCode == Keyboard.UP)))
                    {
                        _local_2 = this._info.manuallySetGunAngle((this._info.gunAngle + (WeaponInfo.ROTATITON_SPEED * this._info.reverse)));
                        this._currentAngleChangeTime = 0;
                    };
                };
                if (_local_2)
                {
                    SoundManager.instance.play("006");
                };
            };
        }

        private function __keydown(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode != KeyStroke.VK_F.getCode())
            {
                if (_arg_1.keyCode == KeyStroke.VK_T.getCode())
                {
                    dispatchEvent(new Event(ArrowView.HIDE_BAR));
                };
            };
        }

        private function __changeBall(_arg_1:LivingEvent):void
        {
            if (this._info.currentBomb == 3)
            {
                this.carrayAngle();
            }
            else
            {
                this.resetAngle();
            };
        }

        private function resetAngle():void
        {
            this.reset();
        }

        private function __change(_arg_1:LivingEvent):void
        {
            if (this._info == null)
            {
                return;
            };
            var _local_2:Number = Number(this._info.currentDeputyWeaponInfo.energy);
            this.resetAngle();
        }

        private function __weapAngle(_arg_1:LivingEvent):void
        {
            var _local_2:Number = 0;
            if (this._info.direction == -1)
            {
                _local_2 = 0;
            }
            else
            {
                _local_2 = 180;
            };
            if (this._info.gunAngle < 0)
            {
                this._bg.arrowSub.arrow.rotation = (360 - (((this._info.gunAngle - 180) + _local_2) * this._info.direction));
            }
            else
            {
                this._bg.arrowSub.arrow.rotation = (360 - (((this._info.gunAngle + 180) + _local_2) * this._info.direction));
            };
            this._info.arrowRotation = this._bg.arrowSub.arrow.rotation;
            this._recordChangeBefore = this._info.gunAngle;
            this.rotationCountField.setText(String((this._info.gunAngle + ((this._info.playerAngle * -1) * this._info.direction))), false);
            if (this._bg.arrowSub.arrow.rotation == this._bg.arrowSub.arrowClone_mc.rotation)
            {
                this._bg.arrowSub.arrowChonghe_mc.visible = true;
                this._bg.arrowSub.arrowChonghe_mc.rotation = this._bg.arrowSub.arrow.rotation;
                this._bg.arrowSub.arrowClone_mc.visible = false;
                this._bg.arrowSub.arrow.visible = false;
            }
            else
            {
                this._bg.arrowSub.arrowChonghe_mc.visible = false;
                this._bg.arrowSub.arrowClone_mc.visible = ((this._first) ? false : true);
                this._bg.arrowSub.arrow.visible = true;
            };
        }

        public function set ShineKey(_arg_1:Boolean):void
        {
            if (this._ShineKey == _arg_1)
            {
                return;
            };
            this._ShineKey = _arg_1;
            this.shineAngleLine();
        }

        public function get ShineKey():Boolean
        {
            return (this._ShineKey);
        }

        private function shineAngleLine():void
        {
            if (this._ShineKey == true)
            {
                this._AnglelShineEffect.play();
            }
            else
            {
                this._AnglelShineEffect.stop();
            };
        }

        private function __changeDirection(_arg_1:LivingEvent):void
        {
            this.__weapAngle(null);
            if (this._info.direction == -1)
            {
                this._sector.scaleX = -1;
                if (this._AnglelShineEffect)
                {
                    this.ShineKey = true;
                };
            }
            else
            {
                this._sector.scaleX = 1;
            };
        }

        private function __changeAngle(_arg_1:LivingEvent):void
        {
            var _local_2:Number = (this._bg.arrowSub.rotation - this._info.playerAngle);
            this._bg.arrowSub.rotation = this._info.playerAngle;
            this._recordRotation = (this._recordRotation + _local_2);
            this._bg.arrowSub.arrowClone_mc.rotation = this._recordRotation;
            this._info.arrowRotation = this._bg.arrowSub.arrow.rotation;
            this.rotationCountField.setText(String((this._info.gunAngle + ((this._info.playerAngle * -1) * this._info.direction))), false);
            if (this._bg.arrowSub.arrow.rotation == this._bg.arrowSub.arrowClone_mc.rotation)
            {
                this._bg.arrowSub.arrowChonghe_mc.visible = true;
                this._bg.arrowSub.arrowChonghe_mc.rotation = this._bg.arrowSub.arrow.rotation;
                this._bg.arrowSub.arrowClone_mc.visible = false;
                this._bg.arrowSub.arrow.visible = false;
            }
            else
            {
                this._bg.arrowSub.arrowChonghe_mc.visible = false;
                this._bg.arrowSub.arrowClone_mc.visible = ((this._first) ? false : true);
                this._bg.arrowSub.arrow.visible = true;
            };
        }

        private function __setArrowClone(_arg_1:Event):void
        {
            if ((!(this._info.isAttacking)))
            {
                this._first = false;
                this._bg.arrowSub.arrowClone_mc.visible = true;
                this._recordRotation = this._bg.arrowSub.arrow.rotation;
                this._bg.arrowSub.arrowClone_mc.rotation = this._bg.arrowSub.arrow.rotation;
            };
        }

        public function setRecordRotation():void
        {
            this._first = false;
            this._bg.arrowSub.arrowClone_mc.visible = true;
            this._recordRotation = this._bg.arrowSub.arrow.rotation;
            this._bg.arrowSub.arrowClone_mc.rotation = this._bg.arrowSub.arrow.rotation;
        }

        public function blockHammer():void
        {
            this._hammerBlocked = true;
            this._hammerCoolDown = 100000;
        }

        public function allowHammer():void
        {
            this._hammerBlocked = false;
            this._hammerCoolDown = 0;
        }

        private function __setDeputyWeaponNumber(_arg_1:CrazyTankSocketEvent):void
        {
            this._deputyWeaponResCount = _arg_1.pkg.readInt();
            this._info.deputyWeaponCount = this._deputyWeaponResCount;
        }

        public function get transparentBtn():SimpleBitmapButton
        {
            return (null);
        }

        public function setPlaneBtnVisible(_arg_1:Boolean):void
        {
            this.flyEnable = _arg_1;
        }

        public function setOffHandedBtnVisible(_arg_1:Boolean):void
        {
            this.hammerEnable = _arg_1;
        }

        public function enter():void
        {
            this.initEvents();
            this.__changeAngle(null);
        }

        public function leaving():void
        {
            this.removeEvent();
        }


    }
}//package game.view.arrow

