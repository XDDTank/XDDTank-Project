// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.tool.BloodStrip

package game.view.tool
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.core.ITipedDisplay;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Shape;
    import flash.display.MovieClip;
    import ddt.view.tips.ChangeNumToolTipInfo;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.LayerManager;
    import game.GameManager;
    import ddt.events.LivingEvent;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ShowTipManager;
    import com.pickgliss.utils.ObjectUtils;
    import flash.display.DisplayObject;

    public class BloodStrip extends Sprite implements Disposeable, ITipedDisplay 
    {

        private var _HPStripBg:Bitmap;
        private var _HPStrip:Bitmap;
        private var _hpShadow:Bitmap;
        private var _HPTxt:FilterFrameText;
        private var _mask:Shape;
        private var _hurtedMask:MovieClip;
        private var _tipStyle:String;
        private var _tipDirctions:String;
        private var _tipData:Object;
        private var _tipGapH:int;
        private var _tipGapV:int;
        private var _maskH:Number;
        private var _info:ChangeNumToolTipInfo;

        public function BloodStrip()
        {
            this._HPStrip = ComponentFactory.Instance.creatBitmap("asset.game.blood.SelfBack");
            addChild(this._HPStrip);
            this._HPTxt = ComponentFactory.Instance.creatComponentByStylename("asset.toolHPStripTxt");
            addChild(this._HPTxt);
            this._mask = new Shape();
            this._mask.graphics.beginFill(0, 1);
            this._mask.graphics.drawRect(0, 0, 10, this._HPStrip.height);
            this._mask.graphics.endFill();
            addChild(this._mask);
            this._HPStrip.mask = this._mask;
            this._maskH = this._mask.height;
            this._hurtedMask = ComponentFactory.Instance.creatCustomObject("asset.game.OnHurtedFrame");
            LayerManager.Instance.addToLayer(this._hurtedMask, LayerManager.GAME_TOP_LAYER);
            this._hurtedMask.gotoAndStop(1);
            this.initTip();
            this.__update(null);
            GameManager.Instance.Current.selfGamePlayer.addEventListener(LivingEvent.BLOOD_CHANGED, this.__update);
            GameManager.Instance.Current.selfGamePlayer.addEventListener(LivingEvent.MAX_HP_CHANGED, this.__update);
            GameManager.Instance.Current.selfGamePlayer.addEventListener(LivingEvent.DIE, this.__update);
        }

        private function initTip():void
        {
            this.tipStyle = "ddt.view.tips.ChangeNumToolTip";
            this.tipDirctions = "4";
            this.tipGapV = 5;
            this.tipGapH = 5;
            this._info = new ChangeNumToolTipInfo();
            this._info.currentTxt = ComponentFactory.Instance.creatComponentByStylename("game.BloodString.currentTxt");
            this._info.title = (LanguageMgr.GetTranslation("tank.game.BloodStrip.HP") + ":");
            this._info.current = GameManager.Instance.Current.selfGamePlayer.maxBlood;
            this._info.total = GameManager.Instance.Current.selfGamePlayer.maxBlood;
            this._info.content = LanguageMgr.GetTranslation("tank.game.BloodStrip.tip");
            this.tipData = this._info;
            ShowTipManager.Instance.addTip(this);
        }

        public function dispose():void
        {
            ShowTipManager.Instance.removeTip(this);
            GameManager.Instance.Current.selfGamePlayer.removeEventListener(LivingEvent.BLOOD_CHANGED, this.__update);
            GameManager.Instance.Current.selfGamePlayer.removeEventListener(LivingEvent.MAX_HP_CHANGED, this.__update);
            GameManager.Instance.Current.selfGamePlayer.removeEventListener(LivingEvent.DIE, this.__update);
            ObjectUtils.disposeObject(this._HPStripBg);
            this._HPStripBg = null;
            ObjectUtils.disposeObject(this._HPStrip);
            this._HPStrip = null;
            ObjectUtils.disposeObject(this._HPTxt);
            this._HPTxt = null;
            ChangeNumToolTipInfo(this._tipData).currentTxt.dispose();
            if (this._hurtedMask.parent)
            {
                this._hurtedMask.parent.removeChild(this._hurtedMask);
            };
            this._hurtedMask = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        private function __update(_arg_1:LivingEvent):void
        {
            if (GameManager.Instance.Current.selfGamePlayer.isLiving)
            {
                this.update(GameManager.Instance.Current.selfGamePlayer.blood, GameManager.Instance.Current.selfGamePlayer.maxBlood);
                if (((_arg_1) && (_arg_1.paras[0] == 2)))
                {
                    this._hurtedMask.gotoAndPlay(2);
                };
            }
            else
            {
                this.update(0, GameManager.Instance.Current.selfGamePlayer.maxBlood);
            };
        }

        private function update(_arg_1:int, _arg_2:int):void
        {
            if (this._info)
            {
                if (this._info.current > _arg_1)
                {
                };
                this._info.current = ((_arg_1 < 0) ? 0 : _arg_1);
                this._info.total = _arg_2;
                this.tipData = this._info;
            };
            if (_arg_1 < 0)
            {
                _arg_1 = 0;
            }
            else
            {
                if (_arg_1 > _arg_2)
                {
                    _arg_1 = _arg_2;
                };
            };
            this._mask.width = (this._HPStrip.width * (_arg_1 / _arg_2));
            this._mask.x = (this._HPStrip.width - this._mask.width);
            this._HPTxt.text = String(_arg_1);
        }

        public function get tipStyle():String
        {
            return (this._tipStyle);
        }

        public function get tipData():Object
        {
            return (this._tipData);
        }

        public function get tipDirctions():String
        {
            return (this._tipDirctions);
        }

        public function get tipGapV():int
        {
            return (this._tipGapV);
        }

        public function get tipGapH():int
        {
            return (this._tipGapH);
        }

        public function set tipStyle(_arg_1:String):void
        {
            this._tipStyle = _arg_1;
        }

        public function set tipData(_arg_1:Object):void
        {
            this._tipData = _arg_1;
        }

        public function set tipDirctions(_arg_1:String):void
        {
            this._tipDirctions = _arg_1;
        }

        public function set tipGapV(_arg_1:int):void
        {
            this._tipGapV = _arg_1;
        }

        public function set tipGapH(_arg_1:int):void
        {
            this._tipGapH = _arg_1;
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }


    }
}//package game.view.tool

