// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.view.BrowserLeftSubStripAsset

package auctionHouse.view
{
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.image.ScaleUpDownImage;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.text.GradientText;
    import com.pickgliss.utils.ObjectUtils;

    public class BrowserLeftSubStripAsset extends BrowserLeftStripAsset 
    {

        private var _type_text:FilterFrameText;
        private var _type_text1:FilterFrameText;
        private var _img:ScaleFrameImage;
        private var menubg:ScaleUpDownImage;

        public function BrowserLeftSubStripAsset()
        {
            super(this._img);
        }

        override protected function initView():void
        {
            this.menubg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtauctionHouse.menuBg");
            bg = ComponentFactory.Instance.creat("auctionHouse.BrowseLeftSubStripBG");
            addChild(bg);
            this._type_text = ComponentFactory.Instance.creat("auctionHouse.BrowseLeftSubStripText");
            this._type_text1 = ComponentFactory.Instance.creat("auctionHouse.BrowseLeftSubStripText1");
            _type_txt = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.BrowseLeftStripTextFilt");
            addChild(this._type_text);
            this._type_text1.visible = false;
            addChild(this._type_text1);
            icon = null;
        }

        override public function set selectState(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this._type_text.visible = false;
                this._type_text1.visible = true;
            }
            else
            {
                this._type_text.visible = true;
                this._type_text1.visible = false;
            };
        }

        override public function set type_txt(_arg_1:GradientText):void
        {
            _type_txt = _arg_1;
            this._type_text.text = _type_txt.text;
            this._type_text1.text = _type_txt.text;
        }

        override public function get type_txt():GradientText
        {
            return (_type_txt);
        }

        override public function set type_text(_arg_1:String):void
        {
            this._type_text.text = _arg_1;
            this._type_text1.text = _arg_1;
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._type_text)
            {
                ObjectUtils.disposeObject(this._type_text);
            };
            this._type_text = null;
            if (this._type_text1)
            {
                ObjectUtils.disposeObject(this._type_text1);
            };
            this._type_text1 = null;
            if (this.menubg)
            {
                ObjectUtils.disposeObject(this.menubg);
            };
            this.menubg = null;
        }


    }
}//package auctionHouse.view

