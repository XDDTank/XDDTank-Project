﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tofflist.TofflistEvent

package tofflist
{
    import flash.events.Event;

    public class TofflistEvent extends Event 
    {

        public static const TOFFLIST_DATA_CHANGER:String = "tofflistdatachange";
        public static const CROSS_SEREVR_DATA_CHANGER:String = "crossServerTofflistDataChange";
        public static const TOFFLIST_TOOL_BAR_SELECT:String = "tofflisttoolbarselect";
        public static const TOFFLIST_TYPE_CHANGE:String = "tofflisttypechange";
        public static const TOFFLIST_ITEM_SELECT:String = "tofflistitemselect";
        public static const TOFFLIST_CURRENT_PLAYER:String = "tofflistcurrentplaye";
        public static const TOFFLIST_INDIVIDUAL_GRADE_DAY:String = "individualGradeDay";
        public static const TOFFLIST_INDIVIDUAL_GRADE_WEEK:String = "individualgradeWeek";
        public static const TOFFLIST_INDIVIDUAL_GRADE_ACCUMULATE:String = "individualgradeweek";
        public static const TOFFLIST_PERSON_LOCAL_MILITARY:String = "pLocalMilitary";
        public static const TOFFLIST_INDIVIDUAL_EXPLOIT_DAY:String = "individualexploitday";
        public static const TOFFLIST_INDIVIDUAL_EXPLOIT_WEEK:String = "individualexploitweek";
        public static const TOFFLIST_INDIVIDUAL_EXPLOIT_ACCUMULATE:String = "individualexploitaccumulate";
        public static const TOFFLIST_INDIVIDUAL_CHARMVALUE_DAY:String = "individualcharmvalueday";
        public static const TOFFLIST_INDIVIDUAL_CHARMVALUE_WEEK:String = "individualcharmvalueweek";
        public static const TOFFLIST_INDIVIDUAL_CHARMVALUE_ACCUMULATE:String = "individualcharmvalueaccumulate";
        public static const TOFFLIST_INDIVIDUAL_MATCHES_WEEK:String = "individualMatchesWeek";
        public static const TOFFLIST_CONSORTIA_GRADE_ACCUMULATE:String = "consortiagradeaccumulate";
        public static const TOFFLIST_CONSORTIA_ASSET_DAY:String = "consortiaassetday";
        public static const TOFFLIST_CONSORTIA_ASSET_WEEK:String = "consortiaassetweek";
        public static const TOFFLIST_CONSORTIA_ASSET_ACCUMULATE:String = "consortiaassetaccumulate";
        public static const TOFFLIST_CONSORTIA_BATTLE_ACCUMULATE:String = "consortiaBattleAccumulate";
        public static const TOFFLIST_CONSORTIA_EXPLOIT_DAY:String = "consortiaexploitday";
        public static const TOFFLIST_CONSORTIA_EXPLOIT_WEEK:String = "consortiaexploitweek";
        public static const TOFFLIST_CONSORTIA_EXPLOIT_ACCUMULATE:String = "consortiaexploitaccumulate";
        public static const TOFFLIST_CONSORTIA_CHARMVALUE_DAY:String = "consortiacharmvalueday";
        public static const TOFFLIST_CONSORTIA_CHARMVALUE_WEEK:String = "consortiacharmvalueweek";
        public static const TOFFLIST_CONSORTIA_CHARMVALUE_ACCUMULATE:String = "consortiacharmvalueAccumulate";
        public static const TOFFLIST_PERSONAL_BATTLE_ACCUMULATE:String = "personalBattleAccumulate";
        public static const TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_DAY:String = "individualAchievementPointDay";
        public static const TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_WEEK:String = "individualAchievementPointWeek";
        public static const TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_ACCUMULATE:String = "individualAchievementPointAccumulate";
        public static const TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_DAY:String = "consortiaAchievementPointDay";
        public static const TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_WEEK:String = "consortiaAchievementPointWeek";
        public static const TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_ACCUMULATE:String = "consortiaAchievementPointAccumulate";
        public static const TOFFLIST_ARENA_LOCAL_SCORE_DAY:String = "arenaLocalScoreDay";
        public static const TOFFLIST_ARENA_LOCAL_SCORE_WEEK:String = "arenaLocalScoreWeek";
        public static const TOFFLIST_ARENA_CROSS_SCORE_DAY:String = "arenaCrossScoreDay";
        public static const TOFFLIST_ARENA_CROSS_SCORE_WEEK:String = "arenaCrossScoreWeek";
        public static const RANKINFO_READY:String = "rankInfo_ready";

        private var _info:Object;

        public function TofflistEvent(_arg_1:String, _arg_2:Object=null, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            super(_arg_1, _arg_3, _arg_4);
            this._info = _arg_2;
        }

        public function get data():Object
        {
            return (this._info);
        }


    }
}//package tofflist

