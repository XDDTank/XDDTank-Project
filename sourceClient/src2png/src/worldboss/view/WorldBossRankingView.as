// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.WorldBossRankingView

package worldboss.view
{
    import com.pickgliss.ui.core.Component;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.MutipleImage;
    import flash.display.Sprite;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.DisplayUtils;
    import worldboss.player.RankingPersonInfo;
    import __AS3__.vec.Vector;
    import com.pickgliss.utils.ObjectUtils;

    public class WorldBossRankingView extends Component 
    {

        private var _titleBg:Bitmap;
        private var _rankBG:MutipleImage;
        private var _container:Sprite;
        private var _horizontalArrangePos:Point;
        private var _horizontalObjPos:Point;

        public function WorldBossRankingView()
        {
            this.initView();
        }

        private function initView():void
        {
            this._titleBg = ComponentFactory.Instance.creatBitmap("asset.worldboss.rankingTitle");
            addChild(this._titleBg);
            this._rankBG = ComponentFactory.Instance.creatComponentByStylename("worldboss.awardview.rankingBG");
            addChild(this._rankBG);
            this._horizontalArrangePos = ComponentFactory.Instance.creatCustomObject("worldboss.awardview.horizontalArrangePos");
            this._horizontalObjPos = ComponentFactory.Instance.creatCustomObject("worldboss.awardview.horizontalobjPos");
            this._container = new Sprite();
            DisplayUtils.setDisplayPos(this._container, this._horizontalObjPos);
            addChild(this._container);
        }

        public function set rankingInfos(_arg_1:Vector.<RankingPersonInfo>):void
        {
            var _local_4:int;
            var _local_5:RankingPersonInfo;
            var _local_6:RankViewItem;
            if (_arg_1 == null)
            {
                return;
            };
            var _local_2:int = 1;
            var _local_3:int;
            for each (_local_5 in _arg_1)
            {
                _local_6 = new RankViewItem(_local_2++, _local_5);
                _local_6.y = (_local_6.y + (32 * _local_3));
                _local_3++;
                this._container.addChild(_local_6);
            };
        }

        override public function dispose():void
        {
            while (this._container.numChildren > 0)
            {
                this._container.removeChildAt(0);
            };
            ObjectUtils.disposeObject(this._titleBg);
            this._titleBg = null;
            ObjectUtils.disposeObject(this._rankBG);
            this._rankBG = null;
            ObjectUtils.disposeObject(this._container);
            this._container = null;
            super.dispose();
        }


    }
}//package worldboss.view

