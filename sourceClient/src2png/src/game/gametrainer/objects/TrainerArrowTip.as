// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.gametrainer.objects.TrainerArrowTip

package game.gametrainer.objects
{
    import phy.object.PhysicalObj;
    import flash.display.MovieClip;
    import com.pickgliss.ui.ComponentFactory;

    public class TrainerArrowTip extends PhysicalObj 
    {

        private var _bannerAsset:MovieClip;

        public function TrainerArrowTip(_arg_1:int, _arg_2:int=1, _arg_3:Number=1, _arg_4:Number=1, _arg_5:Number=1, _arg_6:Number=1)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
            this.init();
        }

        private function init():void
        {
            this._bannerAsset = ComponentFactory.Instance.creat("asset.trainer.TrainerArrowAsset");
            this.addChild(this._bannerAsset);
        }

        public function gotoAndStopII(_arg_1:int):void
        {
            if (this._bannerAsset)
            {
                this._bannerAsset.gotoAndStop(_arg_1);
            };
        }

        override public function dispose():void
        {
            if (this._bannerAsset)
            {
                if (this._bannerAsset.parent)
                {
                    this._bannerAsset.parent.removeChild(this._bannerAsset);
                };
            };
            this._bannerAsset = null;
            super.dispose();
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.gametrainer.objects

