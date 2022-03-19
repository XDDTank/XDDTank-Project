// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.tool.PetEnergyStrip

package game.view.tool
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.core.ITipedDisplay;
    import game.model.Pet;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.MovieClip;
    import ddt.view.tips.ChangeNumToolTipInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.events.LivingEvent;
    import com.pickgliss.ui.ShowTipManager;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;

    public class PetEnergyStrip extends Sprite implements Disposeable, ITipedDisplay 
    {

        private var _pet:Pet;
        private var _text:FilterFrameText;
        private var _bg:MovieClip;
        private var _mp:int;
        private var _maxMp:int;
        private var _TipInfo:ChangeNumToolTipInfo;

        public function PetEnergyStrip(_arg_1:Pet)
        {
            this._pet = _arg_1;
            this._mp = this._pet.MP;
            this._maxMp = this._pet.MaxMP;
            this._TipInfo = new ChangeNumToolTipInfo();
            this._TipInfo.currentTxt = ComponentFactory.Instance.creatComponentByStylename("game.DanderStrip.currentTxt");
            this._TipInfo.title = (LanguageMgr.GetTranslation("tank.game.petmp.mp") + ":");
            this._TipInfo.current = 0;
            this._TipInfo.total = this._maxMp;
            this._TipInfo.content = LanguageMgr.GetTranslation("core.petMptip.description");
            this.initView();
            this.initEvents();
        }

        private function initEvents():void
        {
            this._pet.addEventListener(LivingEvent.PET_MP_CHANGE, this.onChange);
        }

        private function removeEvents():void
        {
            this._pet.removeEventListener(LivingEvent.PET_MP_CHANGE, this.onChange);
        }

        private function onChange(_arg_1:LivingEvent):void
        {
            this._mp = this._pet.MP;
            this._maxMp = this._pet.MaxMP;
            this._text.text = [this._mp, this._maxMp].join("/");
            this._bg.gotoAndStop(((this._mp * 100) / this._maxMp));
        }

        private function initView():void
        {
            this._text = ComponentFactory.Instance.creatComponentByStylename("game.petEnergyStrip.PowerTxtII");
            this._text.text = [this._mp, this._maxMp].join("/");
            this._bg = ComponentFactory.Instance.creat("asset.game.petEnergyBar");
            addChild(this._bg);
            addChild(this._text);
            ShowTipManager.Instance.addTip(this);
        }

        public function get tipData():Object
        {
            this._TipInfo.current = this._mp;
            this._TipInfo.total = this._maxMp;
            return (this._TipInfo);
        }

        public function set tipData(_arg_1:Object):void
        {
        }

        public function get tipDirctions():String
        {
            return ("0");
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
            return (20);
        }

        public function set tipGapV(_arg_1:int):void
        {
        }

        public function get tipStyle():String
        {
            return ("ddt.view.tips.ChangeNumToolTip");
        }

        public function set tipStyle(_arg_1:String):void
        {
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function dispose():void
        {
            this.removeEvents();
            ShowTipManager.Instance.removeTip(this);
            ObjectUtils.disposeObject(this._text);
            this._text = null;
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            this._pet = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.tool

