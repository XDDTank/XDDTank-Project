// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.common.SexIcon

package ddt.view.common
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.ComponentFactory;

    public class SexIcon extends Sprite implements Disposeable 
    {

        private var _sexIcon:ScaleFrameImage;
        private var _sex:Boolean;

        public function SexIcon(_arg_1:Boolean=true)
        {
            this._sexIcon = ComponentFactory.Instance.creat("sex_icon");
            this._sexIcon.setFrame(((_arg_1) ? 1 : 2));
            addChild(this._sexIcon);
        }

        public function setSex(_arg_1:Boolean):void
        {
            this._sexIcon.setFrame(((_arg_1) ? 2 : 1));
        }

        public function set size(_arg_1:Number):void
        {
            this._sexIcon.scaleX = (this._sexIcon.scaleY = _arg_1);
        }

        public function dispose():void
        {
            if (this._sexIcon)
            {
                this._sexIcon.dispose();
                this._sexIcon = null;
            };
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package ddt.view.common

