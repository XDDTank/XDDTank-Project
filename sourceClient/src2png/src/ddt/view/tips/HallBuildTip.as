﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.HallBuildTip

package ddt.view.tips
{
    import flash.display.Sprite;
    import com.pickgliss.ui.tip.ITransformableTip;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.vo.DirectionPos;

    public class HallBuildTip extends Sprite implements ITransformableTip 
    {

        protected var _bg:ScaleBitmapImage;
        protected var _contentTxt:FilterFrameText;
        protected var _title:FilterFrameText;
        private var _rule:ScaleBitmapImage;
        protected var _data:Object;
        protected var _tipWidth:int;
        protected var _tipHeight:int;

        public function HallBuildTip()
        {
            this.init();
        }

        protected function init():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("core.commonTipBg");
            this._title = ComponentFactory.Instance.creatComponentByStylename("hall.tips.title");
            this._rule = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
            this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("core.commonTipText");
            addChild(this._bg);
            addChild(this._title);
            addChild(this._rule);
            addChild(this._contentTxt);
            PositionUtils.setPos(this._rule, "hall.tip.rule.pos");
            PositionUtils.setPos(this._contentTxt, "hall.tip.context.pos");
        }

        public function get tipData():Object
        {
            return (this._data);
        }

        public function set tipData(_arg_1:Object):void
        {
            if (_arg_1 != null)
            {
                this._data = _arg_1;
                this._title.text = this._data["title"];
                this._contentTxt.text = this._data["content"];
                this.update();
            };
        }

        private function update():void
        {
            this._bg.width = (this._contentTxt.textWidth + 20);
            this._bg.height = ((this._contentTxt.y + this._contentTxt.textHeight) + 10);
            this._rule.width = (this._bg.width - 10);
        }

        public function get tipWidth():int
        {
            return (this._tipWidth);
        }

        public function set tipWidth(_arg_1:int):void
        {
            this._tipWidth = _arg_1;
        }

        public function get tipHeight():int
        {
            return (this._bg.height);
        }

        public function set tipHeight(_arg_1:int):void
        {
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function dispose():void
        {
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._title)
            {
                ObjectUtils.disposeObject(this._title);
            };
            this._title = null;
            if (this._rule)
            {
                ObjectUtils.disposeObject(this._rule);
            };
            this._rule = null;
            if (this._contentTxt)
            {
                ObjectUtils.disposeObject(this._contentTxt);
            };
            this._contentTxt = null;
            this._data = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }

        public function get currentDirectionPos():DirectionPos
        {
            return (null);
        }

        public function set currentDirectionPos(_arg_1:DirectionPos):void
        {
        }


    }
}//package ddt.view.tips

