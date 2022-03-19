// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.tool.PowerStrip

package game.view.tool
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import game.model.LocalPlayer;
    import flash.utils.Timer;
    import flash.display.MovieClip;
    import flash.geom.Rectangle;
    import flash.display.Shape;
    import ddt.view.tips.ChangeNumToolTip;
    import ddt.view.tips.ChangeNumToolTipInfo;
    import com.pickgliss.ui.text.FilterFrameText;
    import game.GameManager;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ClassUtils;
    import flash.display.Graphics;
    import flash.display.Bitmap;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import ddt.events.LivingEvent;
    import flash.events.TimerEvent;
    import com.pickgliss.ui.LayerManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import com.pickgliss.utils.ObjectUtils;

    public class PowerStrip extends Sprite implements Disposeable 
    {

        private var _self:LocalPlayer;
        private var _timer:Timer;
        private var _bg:Sprite;
        private var _glint:MovieClip;
        private var _smallLight:MovieClip;
        private var _visibleRect:Rectangle;
        private var _maxWidth:int;
        private var _mask:Shape;
        private var _powerStripTip:ChangeNumToolTip;
        private var _powerStripTipInfo:ChangeNumToolTipInfo;
        private var _tipSprite:Sprite;
        private var _powerField:FilterFrameText;
        private var canCount:Boolean = false;
        private var flashLight:MovieClip;

        public function PowerStrip()
        {
            this._self = GameManager.Instance.Current.selfGamePlayer;
            this._timer = new Timer(400, 1);
            this._timer.stop();
            this._bg = new Sprite();
            this._bg.addChild(ComponentFactory.Instance.creatBitmap("asset.game.energy.back"));
            addChild(this._bg);
            this._glint = (ClassUtils.CreatInstance("asset.game.powerStripLightAsset") as MovieClip);
            this._glint.y = 4;
            this._smallLight = (ClassUtils.CreatInstance("asset.game.powerStripLightAssetII") as MovieClip);
            this._smallLight.y = 2;
            this._smallLight.x = 2;
            this._mask = new Shape();
            var _local_1:Graphics = this._mask.graphics;
            _local_1.beginFill(0);
            _local_1.drawRect(0, 0, this._bg.width, this._bg.height);
            _local_1.endFill();
            this._mask.x = this._bg.x;
            this._mask.y = this._bg.y;
            addChild(this._mask);
            this._bg.mask = this._mask;
            this._tipSprite = new Sprite();
            var _local_2:Bitmap = ComponentFactory.Instance.creatBitmap("asset.game.powerStripAsset");
            this._tipSprite.addChild(_local_2);
            _local_2.alpha = 0;
            addChild(this._tipSprite);
            this.addDanderStripTip();
            this._powerField = ComponentFactory.Instance.creatComponentByStylename("game.PowerStrip.PowerTxt");
            addChild(this._powerField);
            this._powerField.text = String(this._self.energy);
            this.initEvents();
        }

        private function addDanderStripTip():void
        {
            this._powerStripTip = new ChangeNumToolTip();
            this._powerStripTipInfo = new ChangeNumToolTipInfo();
            this._powerStripTipInfo.currentTxt = ComponentFactory.Instance.creatComponentByStylename("game.PowerStrip.currentTxt");
            this._powerStripTipInfo.title = LanguageMgr.GetTranslation("tank.game.PowerStrip.energy");
            this._powerStripTipInfo.current = this._self.maxEnergy;
            this._powerStripTipInfo.total = this._self.maxEnergy;
            this._powerStripTipInfo.content = LanguageMgr.GetTranslation("tank.game.PowerStrip.tip");
            this._powerStripTip.tipData = this._powerStripTipInfo;
            this._powerStripTip.mouseChildren = false;
            this._powerStripTip.mouseEnabled = false;
            this._powerStripTip.x = 710;
            this._powerStripTip.y = 440;
        }

        private function initEvents():void
        {
            this._tipSprite.addEventListener(MouseEvent.MOUSE_OVER, this.__showTip);
            this._tipSprite.addEventListener(MouseEvent.MOUSE_OUT, this.__hideTip);
            this._self.addEventListener(LivingEvent.ENERGY_CHANGED, this.__update);
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this._timerComplete);
        }

        private function __showTip(_arg_1:MouseEvent):void
        {
            LayerManager.Instance.addToLayer(this._powerStripTip, LayerManager.STAGE_TOP_LAYER, false);
        }

        private function __hideTip(_arg_1:MouseEvent):void
        {
            if (this._powerStripTip.parent)
            {
                this._powerStripTip.parent.removeChild(this._powerStripTip);
            };
        }

        private function __update(_arg_1:LivingEvent):void
        {
            if ((((this._self.maxEnergy == this._self.energy) && (!(this._self.maxEnergy == 0))) && (this._self.selfInfo.Grade <= 15)))
            {
                this.canCount = true;
                NewHandContainer.Instance.clearArrowByID(ArrowType.POWER_STRIP);
                if (this.flashLight)
                {
                    ObjectUtils.disposeObject(this.flashLight);
                    this.flashLight = null;
                };
            };
            var _local_2:Number = Math.round(this._self.energy);
            this._powerStripTipInfo.current = _local_2;
            this._powerStripTipInfo.total = this._self.maxEnergy;
            this._powerStripTip.tipData = this._powerStripTipInfo;
            this._powerField.text = String(_local_2);
            this._mask.width = ((this._self.energy / this._self.maxEnergy) * this._bg.width);
            this._mask.x = ((this._bg.x + this._bg.width) - this._mask.width);
            if (this._self.energy == this._self.maxEnergy)
            {
                if (this._smallLight.parent)
                {
                    this._smallLight.parent.removeChild(this._smallLight);
                };
                this._bg.addChild(this._glint);
                this._timer.reset();
                this._timer.start();
            }
            else
            {
                this._bg.addChild(this._smallLight);
            };
        }

        private function removeEvents():void
        {
            this._tipSprite.removeEventListener(MouseEvent.MOUSE_OVER, this.__showTip);
            this._tipSprite.removeEventListener(MouseEvent.MOUSE_OUT, this.__hideTip);
            this._self.removeEventListener(LivingEvent.ENERGY_CHANGED, this.__update);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this._timerComplete);
        }

        private function _timerComplete(_arg_1:TimerEvent):void
        {
            if (this._glint.parent)
            {
                this._glint.parent.removeChild(this._glint);
            };
        }

        public function dispose():void
        {
            this.removeEvents();
            if (this._timer)
            {
                this._timer.stop();
                this._timer = null;
            };
            if (this.flashLight)
            {
                ObjectUtils.disposeObject(this.flashLight);
                this.flashLight = null;
            };
            ObjectUtils.disposeAllChildren(this);
            this._bg = null;
            this._glint = null;
            this._smallLight = null;
            this._powerStripTip.dispose();
            this._powerStripTip = null;
            this._powerStripTipInfo = null;
            this._tipSprite = null;
            this._powerField = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.tool

