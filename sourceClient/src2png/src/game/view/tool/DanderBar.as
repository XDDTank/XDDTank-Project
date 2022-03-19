// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.tool.DanderBar

package game.view.tool
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.core.ITipedDisplay;
    import flash.display.DisplayObject;
    import flash.display.Bitmap;
    import game.model.LocalPlayer;
    import flash.display.Shape;
    import flash.display.MovieClip;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import ddt.view.tips.ChangeNumToolTip;
    import ddt.view.tips.ChangeNumToolTipInfo;
    import flash.display.DisplayObjectContainer;
    import ddt.events.LivingEvent;
    import flash.events.MouseEvent;
    import org.aswing.KeyboardManager;
    import flash.events.KeyboardEvent;
    import org.aswing.KeyStroke;
    import ddt.data.UsePropErrorCode;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import game.model.Player;
    import com.pickgliss.ui.LayerManager;
    import com.greensock.TweenLite;
    import flash.display.Graphics;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.view.tips.ToolPropInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class DanderBar extends Sprite implements Disposeable, ITipedDisplay 
    {

        private static const Min:int = 90;
        private static const Max:int = -180;

        private var _back:DisplayObject;
        private var _animateBack:Bitmap;
        private var _self:LocalPlayer;
        private var _maskShape:Shape;
        private var _rate:Number;
        private var _animate:MovieClip;
        private var _btn:SimpleBitmapButton;
        private var _skillBtn:Sprite;
        private var _tipHitArea:Sprite;
        private var _localDander:int;
        private var _danderStripTip:ChangeNumToolTip;
        private var _danderStripTipInfo:ChangeNumToolTipInfo;
        private var _bg:DisplayObject;
        private var _localVisible:Boolean = true;
        private var _container:DisplayObjectContainer;
        private var _specialEnabled:Boolean = true;

        public function DanderBar(_arg_1:LocalPlayer, _arg_2:DisplayObjectContainer)
        {
            this._self = _arg_1;
            this._container = _arg_2;
            buttonMode = true;
            this.configUI();
            this.addEvent();
            this.setDander();
        }

        private function addEvent():void
        {
            this._self.addEventListener(LivingEvent.DANDER_CHANGED, this.__danderChanged);
            this._self.addEventListener(LivingEvent.SPELLKILL_CHANGED, this.__spellKillChanged);
            this._self.addEventListener(LivingEvent.ATTACKING_CHANGED, this.__attackingChanged);
            this._tipHitArea.addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            this._tipHitArea.addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
            addEventListener(MouseEvent.CLICK, this.__click);
            KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN, this.__keyDown);
        }

        private function __attackingChanged(_arg_1:LivingEvent):void
        {
            buttonMode = ((this._self.spellKillEnabled) && (this._self.isAttacking));
        }

        private function __keyDown(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == KeyStroke.VK_B.getCode())
            {
                this.useSkill();
            };
        }

        private function useSkill():void
        {
            var _local_1:String;
            if (((this._specialEnabled) && (this._localVisible)))
            {
                _local_1 = this._self.useSpellKill();
                if (_local_1 == UsePropErrorCode.Done)
                {
                    if (NewHandContainer.Instance.hasArrow(ArrowType.TIP_THREE))
                    {
                        NewHandContainer.Instance.clearArrowByID(ArrowType.TIP_THREE);
                    };
                    if (NewHandContainer.Instance.hasArrow(ArrowType.TIP_POWER))
                    {
                        NewHandContainer.Instance.clearArrowByID(ArrowType.TIP_POWER);
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("game.view.propContainer.ItemContainer.energy"));
                    };
                }
                else
                {
                    if (_local_1 != UsePropErrorCode.None)
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation(("tank.game.prop." + _local_1)));
                    };
                };
            };
        }

        private function addDanderStripTip():void
        {
            this._danderStripTip = new ChangeNumToolTip();
            this._danderStripTipInfo = new ChangeNumToolTipInfo();
            this._danderStripTipInfo.currentTxt = ComponentFactory.Instance.creatComponentByStylename("game.DanderStrip.currentTxt");
            this._danderStripTipInfo.title = (LanguageMgr.GetTranslation("tank.game.danderStripTip.pow") + ":");
            this._danderStripTipInfo.current = 0;
            this._danderStripTipInfo.total = (Player.TOTAL_DANDER / 2);
            this._danderStripTipInfo.content = LanguageMgr.GetTranslation("tank.game.DanderStrip.tip");
            this._danderStripTip.tipData = this._danderStripTipInfo;
            this._danderStripTip.mouseChildren = false;
            this._danderStripTip.mouseEnabled = false;
            this._danderStripTip.x = 740;
            this._danderStripTip.y = 430;
        }

        private function __mouseOut(_arg_1:MouseEvent):void
        {
            if (this._danderStripTip.parent)
            {
                this._danderStripTip.parent.removeChild(this._danderStripTip);
            };
        }

        private function __mouseOver(_arg_1:MouseEvent):void
        {
            LayerManager.Instance.addToLayer(this._danderStripTip, LayerManager.STAGE_TOP_LAYER, false);
        }

        private function removeEvent():void
        {
            this._self.removeEventListener(LivingEvent.DANDER_CHANGED, this.__danderChanged);
            this._self.removeEventListener(LivingEvent.SPELLKILL_CHANGED, this.__spellKillChanged);
            this._self.removeEventListener(LivingEvent.ATTACKING_CHANGED, this.__attackingChanged);
            this._tipHitArea.removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            this._tipHitArea.removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
            removeEventListener(MouseEvent.CLICK, this.__click);
            KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN, this.__keyDown);
        }

        private function __spellKillChanged(_arg_1:LivingEvent):void
        {
            if (this._self.isBoss)
            {
                return;
            };
            if (this._self.spellKillEnabled)
            {
                this._animate.visible = true;
                this._animate.gotoAndPlay(1);
            }
            else
            {
                this._animate.visible = false;
                this._animate.gotoAndStop(1);
            };
        }

        private function __click(_arg_1:MouseEvent):void
        {
            this.useSkill();
        }

        private function __danderChanged(_arg_1:LivingEvent):void
        {
            if (this._self.isBoss)
            {
                return;
            };
            this.setDander();
        }

        private function setDander():void
        {
            this._danderStripTipInfo.current = (this._self.dander / 2);
            this._danderStripTip.tipData = this._danderStripTipInfo;
            TweenLite.killTweensOf(this);
            TweenLite.to(this, 0.3, {"localDander":this._self.dander});
            if (this._self.dander >= Player.TOTAL_DANDER)
            {
                if (this._self.spellKillEnabled)
                {
                    this._animate.visible = true;
                    this._animate.gotoAndPlay(1);
                    buttonMode = true;
                };
            }
            else
            {
                this._animate.visible = false;
                this._animate.gotoAndStop(1);
                buttonMode = false;
            };
        }

        private function drawProgress(_arg_1:Number):void
        {
            var _local_6:Number;
            var _local_7:Number;
            var _local_2:int = (Min - (Math.abs((Max - Min)) * _arg_1));
            var _local_3:Graphics = this._maskShape.graphics;
            _local_3.clear();
            var _local_4:int = 52;
            _local_3.beginFill(0, 1);
            _local_3.moveTo(0, 0);
            _local_3.lineTo(0, _local_4);
            var _local_5:int = Min;
            while (_local_5 >= _local_2)
            {
                _local_6 = (_local_4 * Math.cos(((_local_5 / 180) * Math.PI)));
                _local_7 = (_local_4 * Math.sin(((_local_5 / 180) * Math.PI)));
                _local_3.lineTo(_local_6, _local_7);
                _local_5--;
            };
            _local_3.lineTo(0, 0);
        }

        private function configUI():void
        {
            var _local_1:Graphics;
            var _local_3:int;
            var _local_4:Number;
            var _local_5:Number;
            this._bg = ComponentFactory.Instance.creatBitmap("asset.game.dander.bg");
            addChild(this._bg);
            this._back = ComponentFactory.Instance.creat("asset.game.dander.back");
            this._back.x = (this._back.y = -1);
            addChild(this._back);
            var _local_2:int = 52;
            this._tipHitArea = new Sprite();
            _local_1 = this._tipHitArea.graphics;
            _local_1.clear();
            _local_1.beginFill(0, 0);
            _local_1.moveTo(0, 0);
            _local_1.lineTo(0, _local_2);
            _local_3 = Min;
            while (_local_3 >= Max)
            {
                _local_4 = (_local_2 * Math.cos(((_local_3 / 180) * Math.PI)));
                _local_5 = (_local_2 * Math.sin(((_local_3 / 180) * Math.PI)));
                _local_1.lineTo(_local_4, _local_5);
                _local_3--;
            };
            _local_1.lineTo(0, 0);
            this._tipHitArea.x = _local_2;
            this._tipHitArea.y = _local_2;
            addChild(this._tipHitArea);
            this._maskShape = new Shape();
            _local_1 = this._maskShape.graphics;
            _local_1.clear();
            _local_1.beginFill(0, 1);
            _local_1.moveTo(0, 0);
            _local_1.lineTo(0, _local_2);
            _local_3 = Min;
            while (_local_3 >= Min)
            {
                _local_4 = (_local_2 * Math.cos(((_local_3 / 180) * Math.PI)));
                _local_5 = (_local_2 * Math.sin(((_local_3 / 180) * Math.PI)));
                _local_1.lineTo(_local_4, _local_5);
                _local_3--;
            };
            _local_1.lineTo(0, 0);
            this._maskShape.x = _local_2;
            this._maskShape.y = _local_2;
            addChild(this._maskShape);
            this._back.mask = this._maskShape;
            this._animateBack = ComponentFactory.Instance.creatBitmap("asset.game.dander.animate.back");
            addChild(this._animateBack);
            this._animate = ComponentFactory.Instance.creat("asset.game.dande.animate");
            this._animate.mouseChildren = (this._animate.mouseEnabled = false);
            this._animate.visible = false;
            this._animate.gotoAndStop(1);
            this._animate.x = 34;
            this._animate.y = 33;
            this._animate.scaleX = (this._animate.scaleY = 0.8);
            addChild(this._animate);
            this._btn = new SimpleBitmapButton();
            addChild(this._btn);
            this._btn.x = 39;
            this._btn.y = 40;
            this._btn.mouseChildren = true;
            this._btn.buttonMode = false;
            this._skillBtn = new Sprite();
            this._skillBtn.graphics.beginFill(0xFFFFFF, 0);
            this._skillBtn.graphics.drawCircle(0, 0, 22);
            this._skillBtn.graphics.endFill();
            this._btn.addChild(this._skillBtn);
            this._btn.tipStyle = "core.ToolPropTips";
            this._btn.tipDirctions = "4";
            this._btn.tipGapV = 30;
            this._btn.tipGapH = 30;
            var _local_6:ItemTemplateInfo = new ItemTemplateInfo();
            _local_6.Name = LanguageMgr.GetTranslation("tank.game.ToolStripView.itemTemplateInfo.Name");
            _local_6.Description = LanguageMgr.GetTranslation("tank.game.ToolStripView.itemTemplateInfo.Description");
            var _local_7:ToolPropInfo = new ToolPropInfo();
            _local_7.info = _local_6;
            _local_7.showTurn = false;
            _local_7.showThew = false;
            _local_7.showCount = false;
            this._btn.tipData = _local_7;
            this.addDanderStripTip();
        }

        public function set localDander(_arg_1:int):void
        {
            this._localDander = _arg_1;
            this.drawProgress((this._localDander / Player.TOTAL_DANDER));
        }

        public function get localDander():int
        {
            return (this._localDander);
        }

        public function setVisible(_arg_1:Boolean):void
        {
            if (this._localVisible != _arg_1)
            {
                this._localVisible = _arg_1;
                if (this._localVisible)
                {
                    this._container.addChild(this);
                }
                else
                {
                    if (parent)
                    {
                        parent.removeChild(this);
                    };
                };
            };
        }

        public function set specialEnabled(_arg_1:Boolean):void
        {
            if (this._specialEnabled != _arg_1)
            {
                this._specialEnabled = _arg_1;
                if ((!(this._specialEnabled)))
                {
                };
                mouseEnabled = this._specialEnabled;
            };
        }

        public function dispose():void
        {
            TweenLite.killTweensOf(this);
            this.removeEvent();
            this._self = null;
            this._danderStripTipInfo = null;
            this._back = null;
            this._maskShape = null;
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            if (this._back)
            {
                ObjectUtils.disposeObject(this._back);
                this._back = null;
            };
            if (this._tipHitArea)
            {
                ObjectUtils.disposeObject(this._tipHitArea);
                this._tipHitArea = null;
            };
            if (this._animate)
            {
                this._animate.gotoAndStop(1);
                ObjectUtils.disposeObject(this._animate);
                this._animate = null;
            };
            this._btn = null;
            this._skillBtn = null;
            if (this._danderStripTip)
            {
                ObjectUtils.disposeObject(this._danderStripTip);
                this._danderStripTip = null;
            };
            if (this._animateBack)
            {
                ObjectUtils.disposeObject(this._animateBack);
                this._animateBack = null;
            };
            ObjectUtils.disposeAllChildren(this);
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }

        public function get tipData():Object
        {
            return (null);
        }

        public function set tipData(_arg_1:Object):void
        {
        }

        public function get tipDirctions():String
        {
            return (null);
        }

        public function set tipDirctions(_arg_1:String):void
        {
        }

        public function get tipGapH():int
        {
            return (0);
        }

        public function set tipGapH(_arg_1:int):void
        {
        }

        public function get tipGapV():int
        {
            return (0);
        }

        public function set tipGapV(_arg_1:int):void
        {
        }

        public function get tipStyle():String
        {
            return (null);
        }

        public function set tipStyle(_arg_1:String):void
        {
        }

        public function asDisplayObject():DisplayObject
        {
            return (null);
        }


    }
}//package game.view.tool

