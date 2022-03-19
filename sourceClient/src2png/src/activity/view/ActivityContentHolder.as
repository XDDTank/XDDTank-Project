// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.ActivityContentHolder

package activity.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class ActivityContentHolder extends Sprite implements Disposeable 
    {

        private var _back:Bitmap;

        public function ActivityContentHolder()
        {
            this.configUI();
        }

        private function configUI():void
        {
            this._back = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityContentBg");
        }

        override public function get height():Number
        {
            return (this._back.height);
        }

        public function dispose():void
        {
            ObjectUtils.disposeObject(this._back);
            this._back = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package activity.view

