﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.EnergyView

package game.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import game.model.LocalPlayer;
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import game.view.map.MapView;
    import ddt.events.LivingEvent;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import flash.events.Event;
    import org.aswing.KeyboardManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.SoundManager;
    import flash.events.MouseEvent;

    public class EnergyView extends Sprite implements Disposeable 
    {

        public static const STRIP_WIDTH:Number = 498;
        public static const FORCE_MAX:Number = 2000;
        public static const SHOOT_FORCE_STEP:Number = 20;
        public static const HIT_FORCE_STEP:Number = 40;

        private var _recordeWidth:Number;
        private var _self:LocalPlayer;
        private var _force:Number = 0;
        private var _hitArea:Sprite;
        private var _forceSpeed:Number = 20;
        private var _hitX:int;
        private var _bg:Bitmap;
        private var _grayStrip:Bitmap;
        private var _lightStrip:Bitmap;
        private var _ruling:Bitmap;
        private var _slider:Sprite;
        private var _maxForce:int = 2000;
        private var _shootMsgShape:DisplayObject;
        private var _firstShoot:Boolean = false;
        private var _onProcess:Boolean = false;
        private var _keyDown:Boolean;
        private var _dir:int = 1;

        public function EnergyView(_arg_1:LocalPlayer, _arg_2:MapView=null)
        {
            var _local_3:String;
            super();
            _local_3 = "asset.game.power.back";
            this._bg = ComponentFactory.Instance.creatBitmap(_local_3);
            addChild(this._bg);
            this._lightStrip = ComponentFactory.Instance.creatBitmap("asset.game.rulingLightStripAsset");
            addChild(this._lightStrip);
            this._grayStrip = ComponentFactory.Instance.creatBitmap("asset.game.rulingGrayStripAsset");
            addChild(this._grayStrip);
            this._ruling = ComponentFactory.Instance.creatBitmap("asset.game.rulingAsset");
            addChild(this._ruling);
            this._slider = new Sprite();
            this._slider.addChild(ComponentFactory.Instance.creatBitmap("asset.game.rulingBtnAsset"));
            addChild(this._slider);
            this._slider.x = this._lightStrip.x;
            this._slider.y = this._lightStrip.y;
            this._hitArea = new Sprite();
            this._hitArea.graphics.beginFill(0xFFFF00, 1);
            this._hitArea.graphics.drawRect(0, 0, 499, 25);
            this._hitArea.graphics.endFill();
            this._hitArea.x = this._lightStrip.x;
            this._hitArea.y = this._lightStrip.y;
            this._hitArea.buttonMode = true;
            this._hitArea.alpha = 0;
            addChild(this._hitArea);
            this._lightStrip.width = 0;
            this._recordeWidth = 0;
            this._grayStrip.width = 0;
            this._self = _arg_1;
            this._shootMsgShape = ComponentFactory.Instance.creatBitmap("asset.game.power.ShootMsg");
            addChildAt(this._shootMsgShape, getChildIndex(this._hitArea));
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MISSION_OVE, this.__over);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_OVER, this.__over);
        }

        private function __maxForceChanged(_arg_1:LivingEvent):void
        {
            this._maxForce = _arg_1.value;
        }

        private function __over(_arg_1:CrazyTankSocketEvent):void
        {
            StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.__keyDownSpace);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE, this.__over);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_OVER, this.__over);
        }

        private function __keyDownSpace(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == Keyboard.SPACE)
            {
                if (this._self.isLiving)
                {
                    if ((((!(this._self.isAttacking)) && (!(this._onProcess))) || (this._self.usingFightToolBoxSkill)))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.ArrowViewIII.fall"));
                    };
                };
            };
        }

        private function __attackingChanged(_arg_1:LivingEvent):void
        {
            if (((this._self.isAttacking) && (this._self.isLiving)))
            {
                addEventListener(Event.ENTER_FRAME, this.__enterFrame);
                this._keyDown = false;
                this._force = 0;
                this._dir = 1;
                this._onProcess = true;
            }
            else
            {
                removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
                this._onProcess = false;
            };
        }

        private function __enterFrame(_arg_1:Event):void
        {
            if (KeyboardManager.isDown(Keyboard.SPACE))
            {
                if ((!(this._self.canNormalShoot)))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.bossplayer.cannotusespace"));
                    return;
                };
                if (this._self.usingFightToolBoxSkill)
                {
                    return;
                };
                if (this._keyDown)
                {
                    this.calcForce();
                }
                else
                {
                    if ((!(this._self.isMoving)))
                    {
                        this._keyDown = true;
                        this._onProcess = true;
                        this._self.beginShoot();
                        this._self.setCenter(this._self.pos.x, (this._self.pos.y - 150), true);
                        if ((!(this._firstShoot)))
                        {
                            this._firstShoot = true;
                            ObjectUtils.disposeObject(this._shootMsgShape);
                            this._shootMsgShape = null;
                        };
                    };
                };
            }
            else
            {
                if (this._keyDown)
                {
                    SoundManager.instance.stop("020");
                    SoundManager.instance.play("019");
                    this._onProcess = false;
                    if (this._self.shootType == 0)
                    {
                        this._self.sendShootAction(this._force);
                    }
                    else
                    {
                        this._self.sendShootAction((this._force - this._hitX));
                    };
                    removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
                };
            };
        }

        private function __beginNewTurn(_arg_1:LivingEvent):void
        {
            this._self.iscalcForce = false;
            this._lightStrip.width = 0;
            this._grayStrip.width = this._recordeWidth;
            this._forceSpeed = SHOOT_FORCE_STEP;
        }

        private function calcForce():void
        {
            if (this._force >= this._maxForce)
            {
                this._dir = -1;
            };
            this._self.iscalcForce = true;
            this._force = (this._force + (this._dir * this._forceSpeed));
            this._force = ((this._force > this._maxForce) ? this._maxForce : this._force);
            this._lightStrip.width = Math.ceil(((STRIP_WIDTH / FORCE_MAX) * this._force));
            this._recordeWidth = this._lightStrip.width;
            SoundManager.instance.play("020", false, false);
            if (this._force <= 0)
            {
                removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
                SoundManager.instance.stop("020");
                this._self.skip();
            };
        }

        public function get force():Number
        {
            return (((this._slider.x - this._hitArea.x) / STRIP_WIDTH) * FORCE_MAX);
        }

        private function __click(_arg_1:MouseEvent):void
        {
            if ((!(this._firstShoot)))
            {
                this._firstShoot = true;
                ObjectUtils.disposeObject(this._shootMsgShape);
                this._shootMsgShape = null;
            };
            this._slider.x = (this._hitArea.x + _arg_1.localX);
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function enter():void
        {
            this._self.addEventListener(LivingEvent.ATTACKING_CHANGED, this.__attackingChanged);
            this._self.addEventListener(LivingEvent.BEGIN_NEW_TURN, this.__beginNewTurn);
            this._self.addEventListener(LivingEvent.MAXFORCE_CHANGED, this.__maxForceChanged);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MISSION_OVE, this.__over);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_OVER, this.__over);
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.__keyDownSpace);
            this._hitArea.addEventListener(MouseEvent.CLICK, this.__click);
            if (((this._self.isAttacking) && (this._self.isLiving)))
            {
                addEventListener(Event.ENTER_FRAME, this.__enterFrame);
                this._keyDown = false;
                this._force = 0;
                this._dir = 1;
                this._onProcess = true;
            }
            else
            {
                removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
                this._onProcess = false;
            };
        }

        private function removeEvent():void
        {
            StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.__keyDownSpace);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE, this.__over);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_OVER, this.__over);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE, this.__over);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_OVER, this.__over);
            removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
            if (this._hitArea)
            {
                this._hitArea.removeEventListener(MouseEvent.CLICK, this.__click);
            };
            if (this._self)
            {
                this._self.removeEventListener(LivingEvent.ATTACKING_CHANGED, this.__attackingChanged);
                this._self.removeEventListener(LivingEvent.BEGIN_NEW_TURN, this.__beginNewTurn);
                this._self.removeEventListener(LivingEvent.MAXFORCE_CHANGED, this.__maxForceChanged);
            };
        }

        public function leaving():void
        {
            this.removeEvent();
        }

        public function dispose():void
        {
            this.removeEvent();
            this._self = null;
            ObjectUtils.disposeObject(this._shootMsgShape);
            this._shootMsgShape = null;
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            removeChild(this._grayStrip);
            this._grayStrip.bitmapData.dispose();
            this._grayStrip = null;
            removeChild(this._lightStrip);
            this._lightStrip.bitmapData.dispose();
            this._lightStrip = null;
            removeChild(this._ruling);
            this._ruling.bitmapData.dispose();
            this._ruling = null;
            ObjectUtils.disposeAllChildren(this._slider);
            removeChild(this._slider);
            this._slider = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view

