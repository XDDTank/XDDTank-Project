// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.BackgoundView

package ddt.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Bitmap;

    public class BackgoundView extends Sprite 
    {

        private static var _instance:BackgoundView;

        public function BackgoundView()
        {
            mouseChildren = false;
            mouseEnabled = false;
            this.initView();
        }

        public static function get Instance():BackgoundView
        {
            if (_instance == null)
            {
                _instance = new (BackgoundView)();
            };
            return (_instance);
        }


        public function hide():void
        {
            if (parent != null)
            {
                parent.removeChild(this);
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_BOTTOM_LAYER, false, 0, false);
        }

        private function initView():void
        {
            var _local_1:Bitmap = ComponentFactory.Instance.creatBitmap("asset.core.bigbg");
            addChild(_local_1);
        }


    }
}//package ddt.view

