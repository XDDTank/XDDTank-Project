// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tofflist.view.TofflistThirdClassMenu

package tofflist.view
{
    import com.pickgliss.ui.controls.container.HBox;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.SelectedTextButton;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import com.pickgliss.ui.controls.SelectedButton;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import tofflist.TofflistModel;
    import tofflist.TofflistEvent;
    import ddt.manager.SoundManager;

    public class TofflistThirdClassMenu extends HBox implements Disposeable 
    {

        public static const PERSON_LOCAL_BATTLE:String = "personLocalBattle";
        public static const PERSON_LOCAL_LEVEL:String = "personLocalLevel";
        public static const PERSON_LOCAL_ACHIVE:String = "personLocalAchive";
        public static const PERSON_LOCAL_MATCH:String = "personLocalMatch";
        public static const PERSON_LOCAL_MILITARY:String = "personLocalMilitary";
        public static const PERSON_CROSS_BATTLE:String = "personCrossBattle";
        public static const PERSON_CROSS_LEVEL:String = "personCrossLevel";
        public static const PERSON_CROSS_ACHIVE:String = "personCrossAchive";
        public static const CONSORTIA_LOCAL_BATTLE:String = "consortiaLocalBattle";
        public static const CONSORTIA_LOCAL_LEVEL:String = "consortiaLocalLevel";
        public static const CONSORTIA_LOCAL_ASSET:String = "consortiaLocalAsset";
        public static const CONSORTIA_CROSS_BATTLE:String = "consortiaCrossBattle";
        public static const CONSORTIA_CROSS_LEVEL:String = "consortiaCrossLevel";
        public static const CONSORTIA_CROSS_ASSET:String = "consortiaCrossAsset";
        public static const LOCAL_ARENA_SCORE_DAY:String = "arenaLocalScoreDay";
        public static const LOCAL_ARENA_SCORE_WEEK:String = "arenaLocalScoreWeek";
        public static const CROSS_ARENA_SCORE_DAY:String = "arenaCrossScoreDay";
        public static const CROSS_ARENA_SCORE_WEEK:String = "arenaCrossScoreWeek";
        public static const DAY:String = "day";
        public static const TOTAL:String = "total";
        public static const WEEK:String = "week";
        private static const BTN_CONST:Array = [DAY, WEEK, TOTAL];

        private var _dayBtn:SelectedTextButton;
        private var _weekBtn:SelectedTextButton;
        private var _totalBtn:SelectedTextButton;
        private var _btns:Array;
        private var _selectedButtonGroup:SelectedButtonGroup;

        public function TofflistThirdClassMenu()
        {
            this._btns = [];
            this.initView();
        }

        private function initView():void
        {
            var _local_1:SelectedButton;
            this._dayBtn = ComponentFactory.Instance.creatComponentByStylename("toffilist.dayAddBtn");
            this._weekBtn = ComponentFactory.Instance.creatComponentByStylename("toffilist.weekAddBtn");
            this._totalBtn = ComponentFactory.Instance.creatComponentByStylename("toffilist.accumulateBtn");
            this._dayBtn.text = LanguageMgr.GetTranslation("tofflist.dayAdd");
            this._weekBtn.text = LanguageMgr.GetTranslation("tofflist.weekAdd");
            this._totalBtn.text = LanguageMgr.GetTranslation("tofflist.total");
            this._selectedButtonGroup = new SelectedButtonGroup();
            this._selectedButtonGroup.addSelectItem(this._dayBtn);
            this._selectedButtonGroup.addSelectItem(this._weekBtn);
            this._selectedButtonGroup.addSelectItem(this._totalBtn);
            this._selectedButtonGroup.selectIndex = 1;
            this._btns.push(this._dayBtn);
            this._btns.push(this._weekBtn);
            this._btns.push(this._totalBtn);
            for each (_local_1 in this._btns)
            {
                _local_1.addEventListener(MouseEvent.CLICK, this.__selectToolBarHandler);
                addChild(_local_1);
            };
        }

        override public function dispose():void
        {
            var _local_1:SelectedTextButton;
            for each (_local_1 in this._btns)
            {
                _local_1.removeEventListener(MouseEvent.CLICK, this.__selectToolBarHandler);
                _local_1.dispose();
            };
            this._btns = null;
        }

        public function selectType(_arg_1:String, _arg_2:String):void
        {
            switch (TofflistModel.firstMenuType)
            {
                case TofflistStairMenu.PERSONAL:
                case TofflistStairMenu.CROSS_SERVER_PERSONAL:
                    switch (TofflistModel.secondMenuType)
                    {
                        case TofflistTwoGradeMenu.BATTLE:
                            this._btns[0].enable = (this._btns[1].enable = false);
                            this._btns[2].enable = true;
                            this._selectedButtonGroup.selectIndex = 2;
                            this.type = TOTAL;
                            break;
                        case TofflistTwoGradeMenu.MATCHES:
                            this._btns[0].enable = (this._btns[2].enable = false);
                            this._btns[1].enable = true;
                            this._selectedButtonGroup.selectIndex = 1;
                            this.type = WEEK;
                            break;
                        case TofflistTwoGradeMenu.MILITARY:
                            this._btns[0].enable = (this._btns[1].enable = false);
                            this._btns[2].enable = true;
                            this._selectedButtonGroup.selectIndex = 1;
                            this.type = TOTAL;
                            break;
                        case TofflistTwoGradeMenu.ARENA:
                            this._btns[2].enable = false;
                            this._btns[0].enable = (this._btns[1].enable = true);
                            this._selectedButtonGroup.selectIndex = 0;
                            this.type = DAY;
                            break;
                        default:
                            this._btns[0].enable = (this._btns[1].enable = (this._btns[2].enable = true));
                            this._selectedButtonGroup.selectIndex = 1;
                            this.type = WEEK;
                    };
                    return;
                case TofflistStairMenu.CONSORTIA:
                case TofflistStairMenu.CROSS_SERVER_CONSORTIA:
                    switch (TofflistModel.secondMenuType)
                    {
                        case TofflistTwoGradeMenu.BATTLE:
                        case TofflistTwoGradeMenu.LEVEL:
                            this._btns[0].enable = (this._btns[1].enable = false);
                            this._btns[2].enable = true;
                            this._selectedButtonGroup.selectIndex = 2;
                            this.type = TOTAL;
                            break;
                        default:
                            this._btns[0].enable = (this._btns[1].enable = (this._btns[2].enable = true));
                            this._selectedButtonGroup.selectIndex = 1;
                            this.type = WEEK;
                    };
                    return;
            };
        }

        public function get type():String
        {
            return (TofflistModel.thirdMenuType);
        }

        public function set type(_arg_1:String):void
        {
            TofflistModel.thirdMenuType = _arg_1;
            dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT, this.type));
        }

        private function __selectToolBarHandler(_arg_1:MouseEvent):void
        {
            if (this.type == _arg_1.currentTarget.name)
            {
                return;
            };
            SoundManager.instance.play("008");
            this.type = BTN_CONST[this._btns.indexOf(_arg_1.currentTarget)];
        }


    }
}//package tofflist.view

