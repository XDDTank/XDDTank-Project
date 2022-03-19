// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.experience.ExpTotalCountingTxt

package game.view.experience
{
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class ExpTotalCountingTxt extends ExpCountingTxt 
    {

        public static const RED:uint = 0xFF0000;
        public static const GREEN:uint = 0xFF00;

        private var _bg:Bitmap;
        private var _color:uint;

        public function ExpTotalCountingTxt(_arg_1:String, _arg_2:String, _arg_3:uint)
        {
            this._color = _arg_3;
            super(_arg_1, _arg_2);
        }

        override protected function init():void
        {
            super.init();
            if (this._color == RED)
            {
                this._bg = ComponentFactory.Instance.creatBitmap("asset.experience.TotalTxtRedBg");
            }
            else
            {
                this._bg = ComponentFactory.Instance.creatBitmap("asset.experience.TotalTxtGreenBg");
            };
            addChildAt(this._bg, 0);
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            super.dispose();
        }


    }
}//package game.view.experience

