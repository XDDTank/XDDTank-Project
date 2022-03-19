// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tofflist.view.TofflistLeftView

package tofflist.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.ComponentFactory;

    public class TofflistLeftView extends Sprite implements Disposeable 
    {

        private var _chatFrame:Sprite;
        private var _currentPlayer:TofflistLeftCurrentCharcter;
        private var _bg2:Bitmap;
        private var _lightsMc:MovieClip;

        public function TofflistLeftView()
        {
            this.init();
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            this._currentPlayer = null;
            if (this._bg2)
            {
                ObjectUtils.disposeObject(this._bg2);
            };
            if (this._lightsMc)
            {
                ObjectUtils.disposeObject(this._lightsMc);
            };
            if (this._chatFrame)
            {
                ObjectUtils.disposeObject(this._chatFrame);
            };
            this._bg2 = null;
            this._lightsMc = null;
            this._chatFrame = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        private function init():void
        {
            this._bg2 = ComponentFactory.Instance.creatBitmap("toffilist.leftImgBg");
            addChild(this._bg2);
            this._currentPlayer = new TofflistLeftCurrentCharcter();
            addChild(this._currentPlayer);
            this._lightsMc = ComponentFactory.Instance.creat("asset.LightsMcAsset");
            this._lightsMc.x = -11;
            this._lightsMc.y = 8;
            addChild(this._lightsMc);
        }


    }
}//package tofflist.view

