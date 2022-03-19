// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//militaryrank.view.FootView

package militaryrank.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.PlayerManager;
    import ddt.data.player.SelfInfo;
    import tofflist.TofflistModel;
    import road7th.data.DictionaryData;
    import ddt.manager.ServerConfigManager;
    import militaryrank.MilitaryRankManager;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;

    public class FootView extends Sprite implements Disposeable 
    {

        private var _bg:Scale9CornerImage;
        private var _tenbitm:Bitmap;
        private var _todaybitm:Bitmap;
        private var _changcibitm:Bitmap;
        private var _junxianbitm:Bitmap;
        private var _zhanji1bitm:Bitmap;
        private var _zhanji2bitm:Bitmap;
        private var _militaryNameTxt:FilterFrameText;
        private var _militaryTotalScoreTxt:FilterFrameText;
        private var _militaryCountTxt:FilterFrameText;
        private var _militaryScoreTxt:FilterFrameText;

        public function FootView()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.militaryrank.footBg");
            this._tenbitm = ComponentFactory.Instance.creatBitmap("asset.militaryrank.tenRankbitm");
            this._todaybitm = ComponentFactory.Instance.creatBitmap("asset.militaryrank.todayRankbitm");
            this._changcibitm = ComponentFactory.Instance.creatBitmap("asset.militaryrank.changci");
            this._junxianbitm = ComponentFactory.Instance.creatBitmap("asset.militaryrank.junxian");
            this._zhanji1bitm = ComponentFactory.Instance.creatBitmap("asset.militaryrank.zhanjibitm");
            this._zhanji2bitm = ComponentFactory.Instance.creatBitmap("asset.militaryrank.zhanji");
            PositionUtils.setPos(this._zhanji2bitm, "militaryrank.zahnji2Pos");
            addChild(this._bg);
            addChild(this._tenbitm);
            addChild(this._todaybitm);
            addChild(this._changcibitm);
            addChild(this._junxianbitm);
            addChild(this._zhanji1bitm);
            addChild(this._zhanji2bitm);
            this._militaryNameTxt = ComponentFactory.Instance.creatComponentByStylename("militaryrank.footInfo.Txt");
            this._militaryTotalScoreTxt = ComponentFactory.Instance.creatComponentByStylename("militaryrank.footInfo.Txt");
            this._militaryCountTxt = ComponentFactory.Instance.creatComponentByStylename("militaryrank.footInfo.Txt");
            this._militaryScoreTxt = ComponentFactory.Instance.creatComponentByStylename("militaryrank.footInfo.Txt");
            PositionUtils.setPos(this._militaryNameTxt, "militaryrank.NameTxt.pos");
            PositionUtils.setPos(this._militaryTotalScoreTxt, "militaryrank.TotalScore.pos");
            PositionUtils.setPos(this._militaryCountTxt, "militaryrank.Count.pos");
            PositionUtils.setPos(this._militaryScoreTxt, "militaryrank.Score.pos");
            addChild(this._militaryNameTxt);
            addChild(this._militaryTotalScoreTxt);
            addChild(this._militaryCountTxt);
            addChild(this._militaryScoreTxt);
            var _local_1:SelfInfo = PlayerManager.Instance.Self;
            var _local_2:DictionaryData = TofflistModel.Instance.getMilitaryLocalTopN(3);
            if (((_local_1.MilitaryRankTotalScores < ServerConfigManager.instance.getMilitaryData()[12]) || (!(_local_2.hasKey(_local_1.ID)))))
            {
                this._militaryNameTxt.text = MilitaryRankManager.Instance.getMilitaryRankInfo(_local_1.MilitaryRankTotalScores).Name;
            }
            else
            {
                this._militaryNameTxt.text = MilitaryRankManager.Instance.getOtherMilitaryName(_local_2[_local_1.ID][0])[0];
            };
            this._militaryTotalScoreTxt.text = PlayerManager.Instance.Self.MilitaryRankTotalScores.toString();
            this._militaryCountTxt.text = PlayerManager.Instance.Self.FightCount.toString();
            this._militaryScoreTxt.text = PlayerManager.Instance.Self.MilitaryRankScores.toString();
        }

        private function initEvent():void
        {
            PlayerManager.Instance.addEventListener(PlayerManager.UPDATE_PLAYER_PROPERTY, this.__onUpdate);
        }

        private function __onUpdate(_arg_1:Event):void
        {
            var _local_2:SelfInfo = PlayerManager.Instance.Self;
            var _local_3:DictionaryData = TofflistModel.Instance.getMilitaryLocalTopN(3);
            if (((_local_2.MilitaryRankTotalScores < ServerConfigManager.instance.getMilitaryData()[12]) || (!(_local_3.hasKey(_local_2.ID)))))
            {
                this._militaryNameTxt.text = MilitaryRankManager.Instance.getMilitaryRankInfo(_local_2.MilitaryRankTotalScores).Name;
            }
            else
            {
                this._militaryNameTxt.text = MilitaryRankManager.Instance.getOtherMilitaryName(_local_3[_local_2.ID][0])[0];
            };
            this._militaryTotalScoreTxt.text = PlayerManager.Instance.Self.MilitaryRankTotalScores.toString();
            this._militaryCountTxt.text = PlayerManager.Instance.Self.FightCount.toString();
            this._militaryScoreTxt.text = PlayerManager.Instance.Self.MilitaryRankScores.toString();
        }

        public function dispose():void
        {
            PlayerManager.Instance.removeEventListener(PlayerManager.UPDATE_PLAYER_PROPERTY, this.__onUpdate);
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._tenbitm);
            this._tenbitm = null;
            ObjectUtils.disposeObject(this._todaybitm);
            this._todaybitm = null;
            ObjectUtils.disposeObject(this._changcibitm);
            this._changcibitm = null;
            ObjectUtils.disposeObject(this._junxianbitm);
            this._junxianbitm = null;
            ObjectUtils.disposeObject(this._zhanji1bitm);
            this._zhanji1bitm = null;
            ObjectUtils.disposeObject(this._zhanji2bitm);
            this._zhanji2bitm = null;
            ObjectUtils.disposeObject(this._militaryNameTxt);
            this._militaryNameTxt = null;
            ObjectUtils.disposeObject(this._militaryTotalScoreTxt);
            this._militaryTotalScoreTxt = null;
            ObjectUtils.disposeObject(this._militaryCountTxt);
            this._militaryCountTxt = null;
            ObjectUtils.disposeObject(this._militaryScoreTxt);
            this._militaryScoreTxt = null;
        }


    }
}//package militaryrank.view

