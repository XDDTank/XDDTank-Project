// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.WorldBossAwardOptionLeftView

package worldboss.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.MutipleImage;
    import flash.geom.Point;
    import __AS3__.vec.Vector;
    import worldboss.player.RankingPersonInfo;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.DisplayUtils;
    import worldboss.WorldBossRoomController;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class WorldBossAwardOptionLeftView extends Sprite implements Disposeable 
    {

        private var _rankingView:WorldBossRankingView;
        private var _rankBG:MutipleImage;
        private var _rankBGPos:Point;
        private var arr:Vector.<RankingPersonInfo>;
        private var list:Vector.<RankingPersonInfo>;

        public function WorldBossAwardOptionLeftView()
        {
            this.initView();
        }

        private function initView():void
        {
            this._rankBG = ComponentFactory.Instance.creatComponentByStylename("worldBossAward.rankBG");
            addChild(this._rankBG);
            this._rankBGPos = ComponentFactory.Instance.creatCustomObject("asset.worldbossAwardRoom.rankBGPos");
            DisplayUtils.setDisplayPos(this._rankBG, this._rankBGPos);
            this.arr = new Vector.<RankingPersonInfo>();
            this._rankingView = ComponentFactory.Instance.creatComponentByStylename("worldBossAward.rankingView");
            addChild(this._rankingView);
        }

        public function updateScore():void
        {
            var _local_2:RankingPersonInfo;
            if (this.arr.length > 0)
            {
                this.clear();
            };
            this.list = WorldBossRoomController.Instance._sceneModel.list;
            var _local_1:int;
            while (_local_1 < this.list.length)
            {
                _local_2 = new RankingPersonInfo();
                _local_2.nickName = this.list[_local_1].nickName;
                _local_2.damage = (1000 + _local_1);
                _local_2.id = 1;
                _local_2.userId = this.list[_local_1].userId;
                _local_2.isVip = this.list[_local_1].isVip;
                _local_2.typeVip = (((_local_1 % 2) == 0) ? 1 : 0);
                this.arr.push(_local_2);
                _local_1++;
            };
            this._rankingView.rankingInfos = this.arr;
        }

        public function dispose():void
        {
            ObjectUtils.disposeObject(this._rankBG);
            this._rankBG = null;
            ObjectUtils.disposeObject(this._rankingView);
            this._rankingView = null;
        }

        public function clear():void
        {
            this.arr.length = 0;
            this.list = null;
            this._rankingView.rankingInfos = null;
        }


    }
}//package worldboss.view

