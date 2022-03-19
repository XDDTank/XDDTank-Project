// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.QuestStarListView

package quest
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.controls.container.HBox;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import flash.display.MovieClip;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class QuestStarListView extends Component 
    {

        private var _level:int;
        private var _starContainer:HBox;
        private var _starImg:Vector.<ScaleFrameImage>;
        private var _lightMovie:MovieClip;

        public function QuestStarListView()
        {
            this.initView();
        }

        private function initView():void
        {
            this._starContainer = new HBox();
            addChild(this._starContainer);
            this._starImg = new Vector.<ScaleFrameImage>(5);
            var _local_1:int;
            while (_local_1 < 5)
            {
                this._starImg[_local_1] = ComponentFactory.Instance.creatComponentByStylename("quest.complete.star");
                _local_1++;
            };
            this._lightMovie = ComponentFactory.Instance.creat("asset.core.improveEffect");
        }

        public function level(_arg_1:int, _arg_2:Boolean=false):void
        {
            if (((_arg_1 > 5) || (_arg_1 < 0)))
            {
                return;
            };
            this._level = _arg_1;
            var _local_3:int;
            while (_local_3 < 5)
            {
                if (this._level > _local_3)
                {
                    if (((_arg_2) && ((this._level - 1) == _local_3)))
                    {
                        this._starContainer.addChild(this._lightMovie);
                        this._lightMovie.play();
                    }
                    else
                    {
                        this._starContainer.addChild(this._starImg[_local_3]);
                        this._starImg[_local_3].setFrame(2);
                    };
                }
                else
                {
                    this._starContainer.addChild(this._starImg[_local_3]);
                    this._starImg[_local_3].setFrame(1);
                };
                _local_3++;
            };
        }

        override public function dispose():void
        {
            var _local_1:int;
            super.dispose();
            if (this._starContainer)
            {
                ObjectUtils.disposeObject(this._starContainer);
            };
            this._starContainer = null;
            if (this._lightMovie)
            {
                ObjectUtils.disposeObject(this._lightMovie);
            };
            this._lightMovie = null;
            if (this._starImg)
            {
                _local_1 = 0;
                while (_local_1 < 5)
                {
                    if (this._starImg[_local_1])
                    {
                        ObjectUtils.disposeObject(this._starImg[_local_1]);
                    };
                    this._starImg[_local_1] = null;
                    _local_1++;
                };
            };
            if (this._starImg)
            {
                ObjectUtils.disposeObject(this._starImg);
            };
            this._starImg = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package quest

