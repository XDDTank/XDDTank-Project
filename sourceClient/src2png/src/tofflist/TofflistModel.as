// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tofflist.TofflistModel

package tofflist
{
    import ddt.data.player.PlayerInfo;
    import tofflist.view.TofflistStairMenu;
    import tofflist.view.TofflistTwoGradeMenu;
    import tofflist.view.TofflistThirdClassMenu;
    import flash.events.EventDispatcher;
    import ddt.data.ConsortiaInfo;
    import tofflist.data.TofflistListData;
    import __AS3__.vec.Vector;
    import consortion.data.ConsortiaApplyInfo;
    import road7th.data.DictionaryData;
    import tofflist.data.RankInfo;
    import tofflist.analyze.TofflistListTwoAnalyzer;
    import tofflist.analyze.TofflistListAnalyzer;
    import ddt.manager.ServerConfigManager;
    import flash.net.URLVariables;
    import ddt.manager.PlayerManager;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import tofflist.analyze.RankInfoAnalyz;

    public class TofflistModel 
    {

        private static var _tofflistType:int;
        public static var childType:int;
        private static var _currentPlayerInfo:PlayerInfo;
        public static var currentText:String;
        public static var currentIndex:int;
        private static var _firstMenuType:String = TofflistStairMenu.PERSONAL;//"personal"
        private static var _secondMenuType:String = TofflistTwoGradeMenu.BATTLE;//"battle"
        private static var _thirdMenuType:String = TofflistThirdClassMenu.TOTAL;//"total"
        private static var _dispatcher:EventDispatcher = new EventDispatcher();
        private static var _currentConsortiaInfo:ConsortiaInfo;
        private static var _instance:TofflistModel;

        private var _personalBattleAccumulate:TofflistListData;
        private var _individualGradeDay:TofflistListData;
        private var _individualGradeWeek:TofflistListData;
        private var _person_local_military:TofflistListData;
        private var _person_cross_military:TofflistListData;
        private var _individualGradeAccumulate:TofflistListData;
        private var _individualExploitDay:TofflistListData;
        private var _individualExploitWeek:TofflistListData;
        private var _individualExploitAccumulate:TofflistListData;
        private var _personalAchievementPointDay:TofflistListData;
        private var _personalAchievementPointWeek:TofflistListData;
        private var _personalAchievementPoint:TofflistListData;
        private var _PersonalCharmvalueDay:TofflistListData;
        private var _PersonalCharmvalueWeek:TofflistListData;
        private var _PersonalCharmvalue:TofflistListData;
        private var _personalMatchesWeek:TofflistListData;
        private var _consortiaBattleAccumulate:TofflistListData;
        private var _consortiaGradeAccumulate:TofflistListData;
        private var _consortiaAssetDay:TofflistListData;
        private var _consortiaAssetWeek:TofflistListData;
        private var _consortiaAssetAccumulate:TofflistListData;
        private var _consortiaExploitDay:TofflistListData;
        private var _consortiaExploitWeek:TofflistListData;
        private var _consortiaExploitAccumulate:TofflistListData;
        private var _ConsortiaCharmvalueDay:TofflistListData;
        private var _ConsortiaCharmvalueWeek:TofflistListData;
        private var _ConsortiaCharmvalue:TofflistListData;
        private var _crossServerPersonalBattleAccumulate:TofflistListData;
        private var _crossServerIndividualGradeDay:TofflistListData;
        private var _crossServerIndividualGradeWeek:TofflistListData;
        private var _crossServerIndividualGradeAccumulate:TofflistListData;
        private var _crossServerIndividualExploitDay:TofflistListData;
        private var _crossServerIndividualExploitWeek:TofflistListData;
        private var _crossServerIndividualExploitAccumulate:TofflistListData;
        private var _crossServerPersonalAchievementPointDay:TofflistListData;
        private var _crossServerPersonalAchievementPointWeek:TofflistListData;
        private var _crossServerPersonalAchievementPoint:TofflistListData;
        private var _crossServerPersonalCharmvalueDay:TofflistListData;
        private var _crossServerPersonalCharmvalueWeek:TofflistListData;
        private var _crossServerPersonalCharmvalue:TofflistListData;
        private var _crossServerConsortiaBattleAccumulate:TofflistListData;
        private var _crossServerConsortiaGradeAccumulate:TofflistListData;
        private var _crossServerConsortiaAssetDay:TofflistListData;
        private var _crossServerConsortiaAssetWeek:TofflistListData;
        private var _crossServerConsortiaAssetAccumulate:TofflistListData;
        private var _crossServerConsortiaExploitDay:TofflistListData;
        private var _crossServerConsortiaExploitWeek:TofflistListData;
        private var _crossServerConsortiaExploitAccumulate:TofflistListData;
        private var _crossServerConsortiaCharmvalueDay:TofflistListData;
        private var _crossServerConsortiaCharmvalueWeek:TofflistListData;
        private var _crossServerConsortiaCharmvalue:TofflistListData;
        private var _arenaLocalScoreDay:TofflistListData;
        private var _arenaLocalScoreWeek:TofflistListData;
        private var _arenaCrossScoreDay:TofflistListData;
        private var _arenaCrossScoreWeek:TofflistListData;
        private var _myConsortiaAuditingApplyData:Vector.<ConsortiaApplyInfo>;
        private var _militaryLocalTopTen:DictionaryData = new DictionaryData();
        public var rankInfo:RankInfo;


        public static function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            _dispatcher.addEventListener(_arg_1, _arg_2, _arg_3);
        }

        public static function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            _dispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public static function set firstMenuType(_arg_1:String):void
        {
            _firstMenuType = _arg_1;
        }

        public static function get firstMenuType():String
        {
            return (_firstMenuType);
        }

        public static function set secondMenuType(_arg_1:String):void
        {
            _secondMenuType = _arg_1;
        }

        public static function get secondMenuType():String
        {
            return (_secondMenuType);
        }

        public static function set thirdMenuType(_arg_1:String):void
        {
            _thirdMenuType = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_TYPE_CHANGE, _arg_1));
        }

        public static function get thirdMenuType():String
        {
            return (_thirdMenuType);
        }

        public static function set currentPlayerInfo(_arg_1:PlayerInfo):void
        {
            _currentPlayerInfo = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_CURRENT_PLAYER, _arg_1));
        }

        public static function get currentPlayerInfo():PlayerInfo
        {
            return (_currentPlayerInfo);
        }

        public static function set currentConsortiaInfo(_arg_1:ConsortiaInfo):void
        {
            _currentConsortiaInfo = _arg_1;
        }

        public static function get currentConsortiaInfo():ConsortiaInfo
        {
            return (_currentConsortiaInfo);
        }

        public static function get Instance():TofflistModel
        {
            if (_instance == null)
            {
                _instance = new (TofflistModel)();
            };
            return (_instance);
        }


        public function set personalBattleAccumulate(_arg_1:TofflistListData):void
        {
            this._personalBattleAccumulate = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_PERSONAL_BATTLE_ACCUMULATE, this._personalBattleAccumulate)));
        }

        public function get personalBattleAccumulate():TofflistListData
        {
            return (this._personalBattleAccumulate);
        }

        public function set individualGradeDay(_arg_1:TofflistListData):void
        {
            this._individualGradeDay = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_DAY, this._individualGradeDay)));
        }

        public function get individualGradeDay():TofflistListData
        {
            return (this._individualGradeDay);
        }

        public function set individualGradeWeek(_arg_1:TofflistListData):void
        {
            this._individualGradeWeek = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_WEEK, this._individualGradeWeek)));
        }

        public function get individualGradeWeek():TofflistListData
        {
            return (this._individualGradeWeek);
        }

        public function set Person_local_military(_arg_1:TofflistListData):void
        {
            this._person_local_military = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_PERSON_LOCAL_MILITARY, this._person_local_military)));
        }

        public function get Person_local_military():TofflistListData
        {
            return (this._person_local_military);
        }

        public function set Person_cross_military(_arg_1:TofflistListData):void
        {
            this._person_cross_military = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_PERSON_LOCAL_MILITARY, this._person_cross_military)));
        }

        public function get Person_cross_military():TofflistListData
        {
            return (this._person_cross_military);
        }

        public function set individualGradeAccumulate(_arg_1:TofflistListData):void
        {
            this._individualGradeAccumulate = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_ACCUMULATE, this._individualGradeAccumulate)));
        }

        public function get individualGradeAccumulate():TofflistListData
        {
            return (this._individualGradeAccumulate);
        }

        public function set individualExploitDay(_arg_1:TofflistListData):void
        {
            this._individualExploitDay = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_DAY, this._individualExploitDay)));
        }

        public function get individualExploitDay():TofflistListData
        {
            return (this._individualExploitDay);
        }

        public function set individualExploitWeek(_arg_1:TofflistListData):void
        {
            this._individualExploitWeek = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_WEEK, this._individualExploitWeek)));
        }

        public function get individualExploitWeek():TofflistListData
        {
            return (this._individualExploitWeek);
        }

        public function set individualExploitAccumulate(_arg_1:TofflistListData):void
        {
            this._individualExploitAccumulate = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_ACCUMULATE, this._individualExploitAccumulate)));
        }

        public function get individualExploitAccumulate():TofflistListData
        {
            return (this._individualExploitAccumulate);
        }

        public function set PersonalAchievementPointDay(_arg_1:TofflistListData):void
        {
            this._personalAchievementPointDay = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_DAY, this._personalAchievementPointDay)));
        }

        public function get PersonalAchievementPointDay():TofflistListData
        {
            return (this._personalAchievementPointDay);
        }

        public function set PersonalAchievementPointWeek(_arg_1:TofflistListData):void
        {
            this._personalAchievementPointWeek = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_WEEK, this._personalAchievementPointWeek)));
        }

        public function get PersonalAchievementPointWeek():TofflistListData
        {
            return (this._personalAchievementPointWeek);
        }

        public function set PersonalAchievementPoint(_arg_1:TofflistListData):void
        {
            this._personalAchievementPoint = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_ACCUMULATE, this._personalAchievementPoint)));
        }

        public function get PersonalAchievementPoint():TofflistListData
        {
            return (this._personalAchievementPoint);
        }

        public function set PersonalCharmvalueDay(_arg_1:TofflistListData):void
        {
            this._PersonalCharmvalueDay = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_DAY, this._PersonalCharmvalueDay)));
        }

        public function get PersonalCharmvalueDay():TofflistListData
        {
            return (this._PersonalCharmvalueDay);
        }

        public function set PersonalCharmvalueWeek(_arg_1:TofflistListData):void
        {
            this._PersonalCharmvalueWeek = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_WEEK, this._PersonalCharmvalueWeek)));
        }

        public function get PersonalCharmvalueWeek():TofflistListData
        {
            return (this._PersonalCharmvalueWeek);
        }

        public function set PersonalCharmvalue(_arg_1:TofflistListData):void
        {
            this._PersonalCharmvalue = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_ACCUMULATE, this._PersonalCharmvalue)));
        }

        public function get PersonalCharmvalue():TofflistListData
        {
            return (this._PersonalCharmvalue);
        }

        public function get personalMatchesWeek():TofflistListData
        {
            return (this._personalMatchesWeek);
        }

        public function set personalMatchesWeek(_arg_1:TofflistListData):void
        {
            this._personalMatchesWeek = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_MATCHES_WEEK, this._personalMatchesWeek)));
        }

        public function set consortiaBattleAccumulate(_arg_1:TofflistListData):void
        {
            this._consortiaBattleAccumulate = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_BATTLE_ACCUMULATE, this._consortiaBattleAccumulate)));
        }

        public function get consortiaBattleAccumulate():TofflistListData
        {
            return (this._consortiaBattleAccumulate);
        }

        public function set consortiaGradeAccumulate(_arg_1:TofflistListData):void
        {
            this._consortiaGradeAccumulate = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_GRADE_ACCUMULATE, this._consortiaGradeAccumulate)));
        }

        public function get consortiaGradeAccumulate():TofflistListData
        {
            return (this._consortiaGradeAccumulate);
        }

        public function set consortiaAssetDay(_arg_1:TofflistListData):void
        {
            this._consortiaAssetDay = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_ASSET_DAY, this._consortiaAssetDay)));
        }

        public function get consortiaAssetDay():TofflistListData
        {
            return (this._consortiaAssetDay);
        }

        public function set consortiaAssetWeek(_arg_1:TofflistListData):void
        {
            this._consortiaAssetWeek = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_ASSET_WEEK, this._consortiaAssetWeek)));
        }

        public function get consortiaAssetWeek():TofflistListData
        {
            return (this._consortiaAssetWeek);
        }

        public function set consortiaAssetAccumulate(_arg_1:TofflistListData):void
        {
            this._consortiaAssetAccumulate = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_ASSET_ACCUMULATE, this._consortiaAssetAccumulate)));
        }

        public function get consortiaAssetAccumulate():TofflistListData
        {
            return (this._consortiaAssetAccumulate);
        }

        public function set consortiaExploitDay(_arg_1:TofflistListData):void
        {
            this._consortiaExploitDay = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_DAY, this._consortiaExploitDay)));
        }

        public function get consortiaExploitDay():TofflistListData
        {
            return (this._consortiaExploitDay);
        }

        public function set consortiaExploitWeek(_arg_1:TofflistListData):void
        {
            this._consortiaExploitWeek = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_WEEK, this._consortiaExploitWeek)));
        }

        public function get consortiaExploitWeek():TofflistListData
        {
            return (this._consortiaExploitWeek);
        }

        public function set consortiaExploitAccumulate(_arg_1:TofflistListData):void
        {
            this._consortiaExploitAccumulate = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_ACCUMULATE, this._consortiaExploitAccumulate)));
        }

        public function get consortiaExploitAccumulate():TofflistListData
        {
            return (this._consortiaExploitAccumulate);
        }

        public function set ConsortiaCharmvalueDay(_arg_1:TofflistListData):void
        {
            this._ConsortiaCharmvalueDay = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_DAY, this._ConsortiaCharmvalueDay)));
        }

        public function get ConsortiaCharmvalueDay():TofflistListData
        {
            return (this._ConsortiaCharmvalueDay);
        }

        public function set ConsortiaCharmvalueWeek(_arg_1:TofflistListData):void
        {
            this._ConsortiaCharmvalueWeek = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_WEEK, this._ConsortiaCharmvalueWeek)));
        }

        public function get ConsortiaCharmvalueWeek():TofflistListData
        {
            return (this._ConsortiaCharmvalueWeek);
        }

        public function set ConsortiaCharmvalue(_arg_1:TofflistListData):void
        {
            this._ConsortiaCharmvalue = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_ACCUMULATE, this._ConsortiaCharmvalue)));
        }

        public function get ConsortiaCharmvalue():TofflistListData
        {
            return (this._ConsortiaCharmvalue);
        }

        public function set crossServerPersonalBattleAccumulate(_arg_1:TofflistListData):void
        {
            this._crossServerPersonalBattleAccumulate = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_PERSONAL_BATTLE_ACCUMULATE, this._crossServerPersonalBattleAccumulate)));
        }

        public function get crossServerPersonalBattleAccumulate():TofflistListData
        {
            return (this._crossServerPersonalBattleAccumulate);
        }

        public function set crossServerIndividualGradeDay(_arg_1:TofflistListData):void
        {
            this._crossServerIndividualGradeDay = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_DAY, this._crossServerIndividualGradeDay)));
        }

        public function get crossServerIndividualGradeDay():TofflistListData
        {
            return (this._crossServerIndividualGradeDay);
        }

        public function set crossServerIndividualGradeWeek(_arg_1:TofflistListData):void
        {
            this._crossServerIndividualGradeWeek = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_WEEK, this._crossServerIndividualGradeWeek)));
        }

        public function get crossServerIndividualGradeWeek():TofflistListData
        {
            return (this._crossServerIndividualGradeWeek);
        }

        public function set crossServerIndividualGradeAccumulate(_arg_1:TofflistListData):void
        {
            this._crossServerIndividualGradeAccumulate = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_ACCUMULATE, this._crossServerIndividualGradeAccumulate)));
        }

        public function get crossServerIndividualGradeAccumulate():TofflistListData
        {
            return (this._crossServerIndividualGradeAccumulate);
        }

        public function set crossServerIndividualExploitDay(_arg_1:TofflistListData):void
        {
            this._crossServerIndividualExploitDay = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_DAY, this._crossServerIndividualExploitDay)));
        }

        public function get crossServerIndividualExploitDay():TofflistListData
        {
            return (this._crossServerIndividualExploitDay);
        }

        public function set crossServerIndividualExploitWeek(_arg_1:TofflistListData):void
        {
            this._crossServerIndividualExploitWeek = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_WEEK, this._crossServerIndividualExploitWeek)));
        }

        public function get crossServerIndividualExploitWeek():TofflistListData
        {
            return (this._crossServerIndividualExploitWeek);
        }

        public function set crossServerIndividualExploitAccumulate(_arg_1:TofflistListData):void
        {
            this._crossServerIndividualExploitAccumulate = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_ACCUMULATE, this._crossServerIndividualExploitAccumulate)));
        }

        public function get crossServerIndividualExploitAccumulate():TofflistListData
        {
            return (this._crossServerIndividualExploitAccumulate);
        }

        public function set crossServerPersonalAchievementPointDay(_arg_1:TofflistListData):void
        {
            this._crossServerPersonalAchievementPointDay = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_DAY, this._crossServerPersonalAchievementPointDay)));
        }

        public function get crossServerPersonalAchievementPointDay():TofflistListData
        {
            return (this._crossServerPersonalAchievementPointDay);
        }

        public function set crossServerPersonalAchievementPointWeek(_arg_1:TofflistListData):void
        {
            this._crossServerPersonalAchievementPointWeek = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_WEEK, this._crossServerPersonalAchievementPointWeek)));
        }

        public function get crossServerPersonalAchievementPointWeek():TofflistListData
        {
            return (this._crossServerPersonalAchievementPointWeek);
        }

        public function set crossServerPersonalAchievementPoint(_arg_1:TofflistListData):void
        {
            this._crossServerPersonalAchievementPoint = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_ACCUMULATE, this._crossServerPersonalAchievementPoint)));
        }

        public function get crossServerPersonalAchievementPoint():TofflistListData
        {
            return (this._crossServerPersonalAchievementPoint);
        }

        public function set crossServerPersonalCharmvalueDay(_arg_1:TofflistListData):void
        {
            this._crossServerPersonalCharmvalueDay = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_DAY, this._crossServerPersonalCharmvalueDay)));
        }

        public function get crossServerPersonalCharmvalueDay():TofflistListData
        {
            return (this._crossServerPersonalCharmvalueDay);
        }

        public function set crossServerPersonalCharmvalueWeek(_arg_1:TofflistListData):void
        {
            this._crossServerPersonalCharmvalueWeek = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_WEEK, this._crossServerPersonalCharmvalueWeek)));
        }

        public function get crossServerPersonalCharmvalueWeek():TofflistListData
        {
            return (this._crossServerPersonalCharmvalueWeek);
        }

        public function set crossServerPersonalCharmvalue(_arg_1:TofflistListData):void
        {
            this._crossServerPersonalCharmvalue = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_ACCUMULATE, this._crossServerPersonalCharmvalue)));
        }

        public function get crossServerPersonalCharmvalue():TofflistListData
        {
            return (this._crossServerPersonalCharmvalue);
        }

        public function set crossServerConsortiaBattleAccumulate(_arg_1:TofflistListData):void
        {
            this._crossServerConsortiaBattleAccumulate = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_BATTLE_ACCUMULATE, this._crossServerConsortiaBattleAccumulate)));
        }

        public function get crossServerConsortiaBattleAccumulate():TofflistListData
        {
            return (this._crossServerConsortiaBattleAccumulate);
        }

        public function set crossServerConsortiaGradeAccumulate(_arg_1:TofflistListData):void
        {
            this._crossServerConsortiaGradeAccumulate = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_GRADE_ACCUMULATE, this._crossServerConsortiaGradeAccumulate)));
        }

        public function get crossServerConsortiaGradeAccumulate():TofflistListData
        {
            return (this._crossServerConsortiaGradeAccumulate);
        }

        public function set crossServerConsortiaAssetDay(_arg_1:TofflistListData):void
        {
            this._crossServerConsortiaAssetDay = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_ASSET_DAY, this._crossServerConsortiaAssetDay)));
        }

        public function get crossServerConsortiaAssetDay():TofflistListData
        {
            return (this._crossServerConsortiaAssetDay);
        }

        public function set crossServerConsortiaAssetWeek(_arg_1:TofflistListData):void
        {
            this._crossServerConsortiaAssetWeek = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_ASSET_WEEK, this._crossServerConsortiaAssetWeek)));
        }

        public function get crossServerConsortiaAssetWeek():TofflistListData
        {
            return (this._crossServerConsortiaAssetWeek);
        }

        public function set crossServerConsortiaAssetAccumulate(_arg_1:TofflistListData):void
        {
            this._crossServerConsortiaAssetAccumulate = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_ASSET_ACCUMULATE, this._crossServerConsortiaAssetAccumulate)));
        }

        public function get crossServerConsortiaAssetAccumulate():TofflistListData
        {
            return (this._crossServerConsortiaAssetAccumulate);
        }

        public function set crossServerConsortiaExploitDay(_arg_1:TofflistListData):void
        {
            this._crossServerConsortiaExploitDay = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_DAY, this._crossServerConsortiaExploitDay)));
        }

        public function get crossServerConsortiaExploitDay():TofflistListData
        {
            return (this._crossServerConsortiaExploitDay);
        }

        public function set crossServerConsortiaExploitWeek(_arg_1:TofflistListData):void
        {
            this._crossServerConsortiaExploitWeek = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_WEEK, this._crossServerConsortiaExploitWeek)));
        }

        public function get crossServerConsortiaExploitWeek():TofflistListData
        {
            return (this._crossServerConsortiaExploitWeek);
        }

        public function set crossServerConsortiaExploitAccumulate(_arg_1:TofflistListData):void
        {
            this._crossServerConsortiaExploitAccumulate = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_ACCUMULATE, this._crossServerConsortiaExploitAccumulate)));
        }

        public function get crossServerConsortiaExploitAccumulate():TofflistListData
        {
            return (this._crossServerConsortiaExploitAccumulate);
        }

        public function set crossServerConsortiaCharmvalueDay(_arg_1:TofflistListData):void
        {
            this._crossServerConsortiaCharmvalueDay = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_DAY, this._crossServerConsortiaCharmvalueDay)));
        }

        public function get crossServerConsortiaCharmvalueDay():TofflistListData
        {
            return (this._crossServerConsortiaCharmvalueDay);
        }

        public function set crossServerConsortiaCharmvalueWeek(_arg_1:TofflistListData):void
        {
            this._crossServerConsortiaCharmvalueWeek = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_WEEK, this._crossServerConsortiaCharmvalueWeek)));
        }

        public function get crossServerConsortiaCharmvalueWeek():TofflistListData
        {
            return (this._crossServerConsortiaCharmvalueWeek);
        }

        public function set crossServerConsortiaCharmvalue(_arg_1:TofflistListData):void
        {
            this._crossServerConsortiaCharmvalue = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_ACCUMULATE, this._crossServerConsortiaCharmvalue)));
        }

        public function get crossServerConsortiaCharmvalue():TofflistListData
        {
            return (this._crossServerConsortiaCharmvalue);
        }

        public function set arenaLocalScoreDay(_arg_1:TofflistListData):void
        {
            this._arenaLocalScoreDay = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_ARENA_LOCAL_SCORE_DAY, this._arenaLocalScoreDay)));
        }

        public function get arenaLocalScoreDay():TofflistListData
        {
            return (this._arenaLocalScoreDay);
        }

        public function set arenaLocalScoreWeek(_arg_1:TofflistListData):void
        {
            this._arenaLocalScoreWeek = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_ARENA_LOCAL_SCORE_WEEK, this._arenaLocalScoreWeek)));
        }

        public function get arenaLocalScoreWeek():TofflistListData
        {
            return (this._arenaLocalScoreWeek);
        }

        public function set arenaCrossScoreDay(_arg_1:TofflistListData):void
        {
            this._arenaCrossScoreDay = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_ARENA_CROSS_SCORE_DAY, this._arenaCrossScoreDay)));
        }

        public function get arenaCrossScoreDay():TofflistListData
        {
            return (this._arenaCrossScoreDay);
        }

        public function set arenaCrossScoreWeek(_arg_1:TofflistListData):void
        {
            this._arenaCrossScoreWeek = _arg_1;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER, this.getTofflistEventParams(TofflistEvent.TOFFLIST_ARENA_CROSS_SCORE_WEEK, this._arenaCrossScoreWeek)));
        }

        public function get arenaCrossScoreWeek():TofflistListData
        {
            return (this._arenaCrossScoreWeek);
        }

        private function getTofflistEventParams(_arg_1:String, _arg_2:TofflistListData):Object
        {
            var _local_3:Object = new Object();
            _local_3.flag = _arg_1;
            _local_3.data = _arg_2;
            return (_local_3);
        }

        public function set myConsortiaAuditingApplyData(_arg_1:Vector.<ConsortiaApplyInfo>):void
        {
            this._myConsortiaAuditingApplyData = _arg_1;
        }

        public function get myConsortiaAuditingApplyData():Vector.<ConsortiaApplyInfo>
        {
            return (this._myConsortiaAuditingApplyData);
        }

        public function personalResult(_arg_1:TofflistListTwoAnalyzer):void
        {
            TofflistModel.Instance[_arg_1.listName] = _arg_1.data;
        }

        public function sociatyResult(_arg_1:TofflistListAnalyzer):void
        {
            TofflistModel.Instance[_arg_1.listName] = _arg_1.data;
        }

        public function getMilitaryLocalTopN(_arg_1:int=3):DictionaryData
        {
            var _local_2:int;
            var _local_3:Array;
            if (this._militaryLocalTopTen.length <= 0)
            {
                if (this.Person_local_military.list.length > 0)
                {
                    _local_2 = 0;
                    while (_local_2 < _arg_1)
                    {
                        if (this.Person_local_military.list[_local_2].RankScores > ServerConfigManager.instance.getMilitaryData()[12])
                        {
                            _local_3 = [];
                            _local_3.push((_local_2 + 1));
                            _local_3.push(this.Person_local_military.list[_local_2]);
                            this._militaryLocalTopTen.add(this.Person_local_military.list[_local_2].ID, _local_3);
                        }
                        else
                        {
                            break;
                        };
                        _local_2++;
                    };
                };
            };
            return (this._militaryLocalTopTen);
        }

        public function loadRankInfo():void
        {
            var _local_1:URLVariables = new URLVariables();
            _local_1["userID"] = PlayerManager.Instance.Self.ID;
            _local_1["ConsortiaID"] = PlayerManager.Instance.Self.ConsortiaID;
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("UserRankDate.ashx"), BaseLoader.REQUEST_LOADER, _local_1);
            _local_2.loadErrorMessage = "";
            _local_2.analyzer = new RankInfoAnalyz(this._loadRankCom);
            LoadResourceManager.instance.startLoad(_local_2);
        }

        private function _loadRankCom(_arg_1:RankInfoAnalyz):void
        {
            this.rankInfo = _arg_1.info;
            _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.RANKINFO_READY));
        }


    }
}//package tofflist

