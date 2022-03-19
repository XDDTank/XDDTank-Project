﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.playerThumbnail.NPCThumbnail

package game.view.playerThumbnail
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import game.model.Living;
    import flash.text.TextField;
    import flash.filters.BitmapFilter;
    import ddt.events.LivingEvent;
    import flash.events.MouseEvent;
    import game.model.SimpleBoss;
    import flash.filters.ColorMatrixFilter;

    public class NPCThumbnail extends Sprite implements Disposeable 
    {

        private var _living:Living;
        private var _headFigure:HeadFigure;
        private var _blood:BloodItem;
        private var _name:TextField;
        private var _tipContainer:Sprite;
        private var lightingFilter:BitmapFilter;

        public function NPCThumbnail(_arg_1:Living)
        {
            this._living = _arg_1;
            this.init();
            this.initEvents();
        }

        public function init():void
        {
            this._headFigure = new HeadFigure(28, 28, this._living);
            this._blood = new BloodItem(this._living.maxBlood);
            this._name = new TextField();
            this.initHead();
            this.initBlood();
            this.initName();
        }

        public function initHead():void
        {
            this._headFigure.x = 7;
            this._headFigure.y = 8;
            addChild(this._headFigure);
        }

        public function initBlood():void
        {
            this._blood.x = 38;
            this._blood.y = 26;
            addChild(this._blood);
        }

        public function initName():void
        {
            var _local_1:int;
            this._name.autoSize = "left";
            this._name.wordWrap = false;
            this._name.text = this._living.name;
            if (this._name.width > 65)
            {
                _local_1 = this._name.getCharIndexAtPoint(50, 5);
                this._name.text = (this._name.text.substring(0, _local_1) + "...");
            };
            this._name.mouseEnabled = false;
            addChild(this._name);
        }

        public function initEvents():void
        {
            if (this._living)
            {
                this._living.addEventListener(LivingEvent.BLOOD_CHANGED, this.__updateBlood);
                this._living.addEventListener(LivingEvent.DIE, this.__die);
                this._living.addEventListener(LivingEvent.ATTACKING_CHANGED, this.__shineChange);
                addEventListener(MouseEvent.ROLL_OVER, this.overHandler);
                addEventListener(MouseEvent.ROLL_OUT, this.outHandler);
            };
        }

        public function __updateBlood(_arg_1:LivingEvent):void
        {
            this._blood.bloodNum = this._living.blood;
        }

        public function __die(_arg_1:LivingEvent):void
        {
            if (this._headFigure)
            {
                this._headFigure.gray();
            };
            if (this._blood)
            {
                this._blood.visible = false;
            };
        }

        private function __shineChange(_arg_1:LivingEvent):void
        {
            var _local_2:SimpleBoss = (this._living as SimpleBoss);
        }

        protected function overHandler(_arg_1:MouseEvent):void
        {
            if (this.lightingFilter)
            {
                this.filters = [this.lightingFilter];
            };
        }

        protected function outHandler(_arg_1:MouseEvent):void
        {
            this.filters = null;
        }

        public function setUpLintingFilter():void
        {
            var _local_1:Array = new Array();
            _local_1 = _local_1.concat([1, 0, 0, 0, 25]);
            _local_1 = _local_1.concat([0, 1, 0, 0, 25]);
            _local_1 = _local_1.concat([0, 0, 1, 0, 25]);
            _local_1 = _local_1.concat([0, 0, 0, 1, 0]);
            this.lightingFilter = new ColorMatrixFilter(_local_1);
        }

        public function removeEvents():void
        {
            if (this._living)
            {
                this._living.removeEventListener(LivingEvent.BLOOD_CHANGED, this.__updateBlood);
                this._living.removeEventListener(LivingEvent.DIE, this.__die);
                this._living.removeEventListener(LivingEvent.ATTACKING_CHANGED, this.__shineChange);
                removeEventListener(MouseEvent.ROLL_OVER, this.overHandler);
                removeEventListener(MouseEvent.ROLL_OUT, this.outHandler);
            };
        }

        public function updateView():void
        {
            if ((!(this._living)))
            {
                this.visible = false;
            }
            else
            {
                if (this._headFigure)
                {
                    this._headFigure.dispose();
                    this._headFigure = null;
                };
                if (this._blood)
                {
                    this._blood = null;
                };
                this.init();
            };
        }

        public function set info(_arg_1:Living):void
        {
            if ((!(_arg_1)))
            {
                this.removeEvents();
            };
            this._living = _arg_1;
            this.updateView();
        }

        public function dispose():void
        {
            if (this._tipContainer)
            {
                if (this._tipContainer.parent)
                {
                    removeChild(this._tipContainer);
                };
                this._tipContainer = null;
            };
            this.removeEvents();
            if (parent)
            {
                parent.removeChild(this);
            };
            this._headFigure.dispose();
            this._headFigure = null;
            this._blood.dispose();
            this._blood = null;
            this._living = null;
        }


    }
}//package game.view.playerThumbnail

