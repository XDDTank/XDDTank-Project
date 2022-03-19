// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tofflist.view.TofflistView

package tofflist.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import tofflist.TofflistController;
    import tofflist.data.TofflistPlayerInfo;
    import tofflist.TofflistModel;
    import tofflist.TofflistEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.view.MainToolBar;
    import ddt.utils.PositionUtils;

    public class TofflistView extends Sprite implements Disposeable 
    {

        private var _contro:TofflistController;
        private var _leftView:TofflistLeftView;
        private var _rightView:TofflistRightView;
        private var _arrayList:TofflistPlayerInfo;
        private var _list1:Array;
        private var _list2:Array;

        public function TofflistView(_arg_1:TofflistController)
        {
            this._contro = _arg_1;
            super();
            this.init();
        }

        public function get rightView():TofflistRightView
        {
            return (this._rightView);
        }

        public function addEvent():void
        {
            TofflistModel.addEventListener(TofflistEvent.TOFFLIST_DATA_CHANGER, this.__tofflistDataChange);
            TofflistModel.addEventListener(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.__crossServerTofflistDataChange);
        }

        public function dispose():void
        {
            this._contro = null;
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            this._leftView = null;
            this._rightView = null;
            MainToolBar.Instance.hide();
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function removeEvent():void
        {
            TofflistModel.removeEventListener(TofflistEvent.TOFFLIST_DATA_CHANGER, this.__tofflistDataChange);
            TofflistModel.removeEventListener(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.__crossServerTofflistDataChange);
        }

        private function __crossServerTofflistDataChange(_arg_1:TofflistEvent):void
        {
            this._rightView.updateTime(_arg_1.data.data.lastUpdateTime);
            switch (String(_arg_1.data.flag))
            {
                case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_DAY:
                    this._rightView.orderList(TofflistModel.Instance.crossServerIndividualGradeDay.list);
                    return;
                case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_WEEK:
                    this._rightView.orderList(TofflistModel.Instance.crossServerIndividualGradeWeek.list);
                    return;
                case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_ACCUMULATE:
                    this._rightView.orderList(TofflistModel.Instance.crossServerIndividualGradeAccumulate.list);
                    return;
                case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_DAY:
                    this._rightView.orderList(TofflistModel.Instance.crossServerIndividualExploitDay.list);
                    return;
                case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_WEEK:
                    this._rightView.orderList(TofflistModel.Instance.crossServerIndividualExploitWeek.list);
                    return;
                case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_ACCUMULATE:
                    this._rightView.orderList(TofflistModel.Instance.crossServerIndividualExploitAccumulate.list);
                    return;
                case TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_DAY:
                    this._rightView.orderList(TofflistModel.Instance.crossServerPersonalCharmvalueDay.list);
                    return;
                case TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_WEEK:
                    this._rightView.orderList(TofflistModel.Instance.crossServerPersonalCharmvalueWeek.list);
                    return;
                case TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_ACCUMULATE:
                    this._rightView.orderList(TofflistModel.Instance.crossServerPersonalCharmvalue.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_GRADE_ACCUMULATE:
                    this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaGradeAccumulate.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_DAY:
                    this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaAssetDay.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_WEEK:
                    this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaAssetWeek.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_ACCUMULATE:
                    this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaAssetAccumulate.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_DAY:
                    this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaExploitDay.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_WEEK:
                    this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaExploitWeek.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_ACCUMULATE:
                    this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaExploitAccumulate.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_BATTLE_ACCUMULATE:
                    this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaBattleAccumulate.list);
                    return;
                case TofflistEvent.TOFFLIST_PERSONAL_BATTLE_ACCUMULATE:
                    this._rightView.orderList(TofflistModel.Instance.crossServerPersonalBattleAccumulate.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_DAY:
                    this._rightView.orderList(TofflistModel.Instance.crossServerPersonalAchievementPointDay.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_WEEK:
                    this._rightView.orderList(TofflistModel.Instance.crossServerPersonalAchievementPointWeek.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_ACCUMULATE:
                    this._rightView.orderList(TofflistModel.Instance.crossServerPersonalAchievementPoint.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_DAY:
                    this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaCharmvalueDay.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_WEEK:
                    this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaCharmvalueWeek.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_ACCUMULATE:
                    this._rightView.orderList(TofflistModel.Instance.crossServerConsortiaCharmvalue.list);
                    return;
            };
        }

        private function __tofflistDataChange(_arg_1:TofflistEvent):void
        {
            var _local_2:Array;
            var _local_3:int;
            this._rightView.updateTime(_arg_1.data.data.lastUpdateTime);
            switch (String(_arg_1.data.flag))
            {
                case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_DAY:
                    this._rightView.orderList(TofflistModel.Instance.individualGradeDay.list);
                    return;
                case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_WEEK:
                    this._rightView.orderList(TofflistModel.Instance.individualGradeWeek.list);
                    return;
                case TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_ACCUMULATE:
                    _local_2 = TofflistModel.Instance.individualGradeAccumulate.list;
                    if (_local_2.length != 0)
                    {
                        this._arrayList = _local_2[0];
                        this._list1 = [];
                        this._list2 = [];
                        _local_3 = 1;
                        while (_local_3 < _local_2.length)
                        {
                            if (this._arrayList.GP == _local_2[_local_3].GP)
                            {
                                this._list2.push(_local_2[_local_3]);
                            }
                            else
                            {
                                this.listArray(_local_2[_local_3]);
                            };
                            _local_3++;
                        };
                        this.listArray(_local_2[_local_3]);
                    };
                    this._rightView.orderList(this._list1);
                    return;
                case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_DAY:
                    this._rightView.orderList(TofflistModel.Instance.individualExploitDay.list);
                    return;
                case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_WEEK:
                    this._rightView.orderList(TofflistModel.Instance.individualExploitWeek.list);
                    return;
                case TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_ACCUMULATE:
                    this._rightView.orderList(TofflistModel.Instance.individualExploitAccumulate.list);
                    return;
                case TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_DAY:
                    this._rightView.orderList(TofflistModel.Instance.PersonalCharmvalueDay.list);
                    return;
                case TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_WEEK:
                    this._rightView.orderList(TofflistModel.Instance.PersonalCharmvalueWeek.list);
                    return;
                case TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_ACCUMULATE:
                    this._rightView.orderList(TofflistModel.Instance.PersonalCharmvalue.list);
                    return;
                case TofflistEvent.TOFFLIST_INDIVIDUAL_MATCHES_WEEK:
                    this._rightView.orderList(TofflistModel.Instance.personalMatchesWeek.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_GRADE_ACCUMULATE:
                    this._rightView.orderList(TofflistModel.Instance.consortiaGradeAccumulate.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_DAY:
                    this._rightView.orderList(TofflistModel.Instance.consortiaAssetDay.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_WEEK:
                    this._rightView.orderList(TofflistModel.Instance.consortiaAssetWeek.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_ASSET_ACCUMULATE:
                    this._rightView.orderList(TofflistModel.Instance.consortiaAssetAccumulate.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_DAY:
                    this._rightView.orderList(TofflistModel.Instance.consortiaExploitDay.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_WEEK:
                    this._rightView.orderList(TofflistModel.Instance.consortiaExploitWeek.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_ACCUMULATE:
                    this._rightView.orderList(TofflistModel.Instance.consortiaExploitAccumulate.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_BATTLE_ACCUMULATE:
                    this._rightView.orderList(TofflistModel.Instance.consortiaBattleAccumulate.list);
                    return;
                case TofflistEvent.TOFFLIST_PERSONAL_BATTLE_ACCUMULATE:
                    this._rightView.orderList(TofflistModel.Instance.personalBattleAccumulate.list);
                    return;
                case TofflistEvent.TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_DAY:
                    this._rightView.orderList(TofflistModel.Instance.PersonalAchievementPointDay.list);
                    return;
                case TofflistEvent.TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_WEEK:
                    this._rightView.orderList(TofflistModel.Instance.PersonalAchievementPointWeek.list);
                    return;
                case TofflistEvent.TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_ACCUMULATE:
                    this._rightView.orderList(TofflistModel.Instance.PersonalAchievementPoint.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_DAY:
                    this._rightView.orderList(TofflistModel.Instance.ConsortiaCharmvalueDay.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_WEEK:
                    this._rightView.orderList(TofflistModel.Instance.ConsortiaCharmvalueWeek.list);
                    return;
                case TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_ACCUMULATE:
                    this._rightView.orderList(TofflistModel.Instance.ConsortiaCharmvalue.list);
                    return;
                case TofflistEvent.TOFFLIST_PERSON_LOCAL_MILITARY:
                    this._rightView.orderList(TofflistModel.Instance.Person_local_military.list);
                    return;
                case TofflistEvent.TOFFLIST_ARENA_LOCAL_SCORE_DAY:
                    this._rightView.orderList(TofflistModel.Instance.arenaLocalScoreDay.list);
                    return;
                case TofflistEvent.TOFFLIST_ARENA_LOCAL_SCORE_WEEK:
                    this._rightView.orderList(TofflistModel.Instance.arenaLocalScoreWeek.list);
                    return;
                case TofflistEvent.TOFFLIST_ARENA_CROSS_SCORE_DAY:
                    this._rightView.orderList(TofflistModel.Instance.arenaCrossScoreDay.list);
                    return;
                case TofflistEvent.TOFFLIST_ARENA_CROSS_SCORE_WEEK:
                    this._rightView.orderList(TofflistModel.Instance.arenaCrossScoreWeek.list);
                    return;
            };
        }

        public function clearDisplayContent():void
        {
            this._rightView.orderList(new Array());
            this._rightView.updateTime(null);
        }

        private function init():void
        {
            this._leftView = new TofflistLeftView();
            addChild(this._leftView);
            this._rightView = new TofflistRightView(this._contro);
            PositionUtils.setPos(this._rightView, "tofflist.rightViewPos");
            addChild(this._rightView);
            MainToolBar.Instance.show();
        }

        private function listArray(_arg_1:TofflistPlayerInfo):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:TofflistPlayerInfo;
            var _local_6:int;
            if (this._list2.length == 0)
            {
                this._list1.push(this._arrayList);
                this._arrayList = _arg_1;
            }
            else
            {
                this._list2.push(this._arrayList);
                this._arrayList = _arg_1;
                _local_2 = this._list1.length;
                _local_3 = 0;
                while (_local_3 < this._list2.length)
                {
                    _local_4 = (this._list2.length - 1);
                    _local_5 = this._list2[_local_3];
                    _local_6 = 0;
                    while (_local_6 < this._list2.length)
                    {
                        if (_local_5.Repute < this._list2[_local_6].Repute)
                        {
                            _local_4--;
                        };
                        _local_6++;
                    };
                    this._list1[(_local_2 + _local_4)] = _local_5;
                    _local_3++;
                };
                this._list2.length = 0;
            };
        }


    }
}//package tofflist.view

