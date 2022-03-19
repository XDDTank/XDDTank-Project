// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.view.BrowserLeftStripAsset

package auctionHouse.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.text.GradientText;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class BrowserLeftStripAsset extends Sprite implements Disposeable 
    {

        private var _bg:ScaleFrameImage;
        private var _icon:ScaleFrameImage;
        private var _filterTextImage:ScaleFrameImage;
        protected var _type_txt:GradientText;

        public function BrowserLeftStripAsset(_arg_1:ScaleFrameImage)
        {
            this._filterTextImage = _arg_1;
            this.initView();
        }

        public function set selectState(_arg_1:Boolean):void
        {
        }

        protected function initView():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.BrowseLeftStripBG");
            addChild(this._bg);
            this._icon = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.BrowseLeftStripIcon");
            this._type_txt = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.BrowseLeftStripTextFilt");
            addChild(this._type_txt);
            addChild(this._filterTextImage);
        }

        public function set bg(_arg_1:ScaleFrameImage):void
        {
            this._bg = _arg_1;
        }

        public function set icon(_arg_1:ScaleFrameImage):void
        {
            this._icon = _arg_1;
        }

        public function set type_txt(_arg_1:GradientText):void
        {
            this._type_txt = _arg_1;
        }

        public function get bg():ScaleFrameImage
        {
            return (this._bg);
        }

        public function get icon():ScaleFrameImage
        {
            return (this._icon);
        }

        public function get type_txt():GradientText
        {
            return (this._type_txt);
        }

        public function setFrameOnImage(_arg_1:int):void
        {
            if (this._filterTextImage)
            {
                this._filterTextImage.setFrame(_arg_1);
            };
        }

        public function dispose():void
        {
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._icon)
            {
                ObjectUtils.disposeObject(this._icon);
            };
            this._icon = null;
            if (this._type_txt)
            {
                ObjectUtils.disposeObject(this._type_txt);
            };
            this._type_txt = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function set type_text(_arg_1:String):void
        {
        }

        public function set type_text1(_arg_1:String):void
        {
        }


    }
}//package auctionHouse.view

