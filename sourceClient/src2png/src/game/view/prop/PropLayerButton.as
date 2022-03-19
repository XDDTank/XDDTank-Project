// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.prop.PropLayerButton

package game.view.prop
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.core.ITipedDisplay;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import flash.display.Bitmap;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.DisplayUtils;
    import com.pickgliss.ui.ShowTipManager;
    import com.pickgliss.utils.ObjectUtils;
    import flash.display.DisplayObject;

    public class PropLayerButton extends Sprite implements Disposeable, ITipedDisplay 
    {

        private var _background:ScaleFrameImage;
        private var _shine:Bitmap;
        private var _tipData:String;
        private var _mode:int;
        private var _mouseOver:Boolean = false;
        private var _tipDirction:String;
        private var _tipGapH:int;
        private var _tipGapV:int;
        private var _tipStyle:String;

        public function PropLayerButton(_arg_1:int)
        {
            this._mode = _arg_1;
            this.configUI();
            this.addEvent();
            buttonMode = true;
        }

        private function addEvent():void
        {
            addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
        }

        private function removeEvent():void
        {
            removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
        }

        private function __mouseOut(_arg_1:MouseEvent):void
        {
            if (((this._shine) && (this._shine.parent)))
            {
                this._shine.parent.removeChild(this._shine);
            };
            this._mouseOver = false;
        }

        public function set enabled(_arg_1:Boolean):void
        {
        }

        public function get enabled():Boolean
        {
            return (true);
        }

        private function __mouseOver(_arg_1:MouseEvent):void
        {
            if (this._shine)
            {
                addChild(this._shine);
            };
            this._mouseOver = true;
        }

        private function configUI():void
        {
            this._background = ComponentFactory.Instance.creatComponentByStylename("asset.game.prop.ModeBack");
            addChild(this._background);
            this.tipData = LanguageMgr.GetTranslation(("tank.game.ToolStripView.proplayer" + this._mode));
            DisplayUtils.setFrame(this._background, this._mode);
            this._shine = ComponentFactory.Instance.creatBitmap("asset.game.prop.ModeShine");
            ShowTipManager.Instance.addTip(this);
            this._shine.x = (this._shine.y = -3);
        }

        public function setMode(_arg_1:int):void
        {
            this.tipData = LanguageMgr.GetTranslation(("tank.game.ToolStripView.proplayer" + _arg_1));
            DisplayUtils.setFrame(this._background, _arg_1);
            if (this._mouseOver)
            {
                ShowTipManager.Instance.showTip(this);
            };
        }

        public function dispose():void
        {
            ShowTipManager.Instance.removeTip(this);
            this.removeEvent();
            if (this._background)
            {
                ObjectUtils.disposeObject(this._background);
                this._background = null;
            };
            if (this._shine)
            {
                ObjectUtils.disposeObject(this._shine);
                this._shine = null;
            };
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get tipData():Object
        {
            return (this._tipData);
        }

        public function set tipData(_arg_1:Object):void
        {
            this._tipData = _arg_1.toString();
        }

        public function get tipDirctions():String
        {
            return (this._tipDirction);
        }

        public function set tipDirctions(_arg_1:String):void
        {
            this._tipDirction = _arg_1;
        }

        public function get tipGapH():int
        {
            return (this._tipGapH);
        }

        public function set tipGapH(_arg_1:int):void
        {
            this._tipGapH = _arg_1;
        }

        public function get tipGapV():int
        {
            return (this._tipGapV);
        }

        public function set tipGapV(_arg_1:int):void
        {
            this._tipGapV = _arg_1;
        }

        public function get tipStyle():String
        {
            return (this._tipStyle);
        }

        public function set tipStyle(_arg_1:String):void
        {
            this._tipStyle = _arg_1;
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }


    }
}//package game.view.prop

