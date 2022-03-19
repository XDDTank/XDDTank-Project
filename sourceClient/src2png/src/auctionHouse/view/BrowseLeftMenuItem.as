// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.view.BrowseLeftMenuItem

package auctionHouse.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.data.goods.CateCoryInfo;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;

    public class BrowseLeftMenuItem extends Sprite implements Disposeable, IMenuItem 
    {

        private var accect:BrowserLeftStripAsset;
        private var _info:CateCoryInfo;
        private var _isOpen:Boolean = false;
        private var _hasIcon:Boolean;
        private var _hideIcon:Boolean;

        public function BrowseLeftMenuItem(_arg_1:BrowserLeftStripAsset, _arg_2:CateCoryInfo, _arg_3:Boolean=false)
        {
            this.accect = _arg_1;
            this._info = _arg_2;
            this._hideIcon = _arg_3;
            buttonMode = true;
            addChild(this.accect);
            this.initView();
            this.initEvent();
        }

        private function initEvent():void
        {
            this.accect.addEventListener(MouseEvent.CLICK, this.btnClickHandler);
            this.addRollEvent();
            if (this.accect.icon)
            {
                this._hasIcon = true;
                if (this._hideIcon)
                {
                    this.accect.icon.visible = false;
                };
                this.accect.icon.setFrame(1);
            };
        }

        public function dispose():void
        {
            if (this.accect)
            {
                this.removeRollEvent();
                ObjectUtils.disposeObject(this.accect);
            };
            this.accect = null;
            this._info = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        private function removeRollEvent():void
        {
            this.accect.removeEventListener(MouseEvent.CLICK, this.btnClickHandler);
            this.accect.removeEventListener(MouseEvent.ROLL_OVER, this.btnClickHandler);
            this.accect.removeEventListener(MouseEvent.ROLL_OUT, this.btnClickHandler);
        }

        private function addRollEvent():void
        {
            this.accect.addEventListener(MouseEvent.ROLL_OVER, this.btnClickHandler);
            this.accect.addEventListener(MouseEvent.ROLL_OUT, this.btnClickHandler);
        }

        private function initView():void
        {
            this.accect.type_txt.text = this._info.Name;
            this.accect.type_text = this._info.Name;
        }

        public function get info():Object
        {
            return (this._info);
        }

        public function get isOpen():Boolean
        {
            return (this._isOpen);
        }

        public function set isOpen(_arg_1:Boolean):void
        {
            this._isOpen = _arg_1;
            if (((this._isOpen) && (this._hasIcon)))
            {
                this.accect.icon.setFrame(2);
                this.accect.setFrameOnImage(1);
            }
            else
            {
                if (((!(this._isOpen)) && (this._hasIcon)))
                {
                    this.accect.icon.setFrame(1);
                    this.accect.setFrameOnImage(2);
                }
                else
                {
                    this.accect.icon.setFrame(1);
                    this.accect.setFrameOnImage(2);
                };
            };
        }

        public function set enable(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.accect.bg.setFrame(1);
                this.accect.setFrameOnImage(2);
                this.accect.selectState = false;
                this.addRollEvent();
            }
            else
            {
                this.accect.bg.setFrame(2);
                this.accect.setFrameOnImage(1);
                this.accect.selectState = true;
                this.removeRollEvent();
            };
        }

        private function btnClickHandler(_arg_1:MouseEvent):void
        {
            switch (_arg_1.type)
            {
                case MouseEvent.CLICK:
                    this.accect.bg.setFrame(2);
                    this.accect.setFrameOnImage(1);
                    this.accect.selectState = true;
                    return;
                case MouseEvent.ROLL_OVER:
                    this.accect.bg.setFrame(1);
                    return;
                case MouseEvent.ROLL_OUT:
                    this.accect.bg.setFrame(1);
                    return;
            };
        }


    }
}//package auctionHouse.view

