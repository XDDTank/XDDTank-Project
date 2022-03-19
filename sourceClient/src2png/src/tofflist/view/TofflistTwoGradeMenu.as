// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tofflist.view.TofflistTwoGradeMenu

package tofflist.view
{
    import com.pickgliss.ui.controls.container.HBox;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.SelectedTextButton;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;
    import tofflist.TofflistModel;
    import tofflist.TofflistEvent;
    import ddt.manager.SoundManager;

    public class TofflistTwoGradeMenu extends HBox implements Disposeable 
    {

        public static const ACHIEVEMENTPOINT:String = "achievementpoint";
        public static const ASSETS:String = "assets";
        public static const BATTLE:String = "battle";
        public static const GESTE:String = "geste";
        public static const LEVEL:String = "level";
        public static const MATCHES:String = "matches";
        public static const MILITARY:String = "military";
        public static const ARENA:String = "arena";
        private static const BTN_CONST:Array = [BATTLE, LEVEL, MILITARY, ARENA];

        private var _battleBtn:SelectedTextButton;
        private var _levelBtn:SelectedTextButton;
        private var _achiveBtn:SelectedTextButton;
        private var _matcheBtn:SelectedTextButton;
        private var _militaryBtn:SelectedTextButton;
        private var _arenaBtn:SelectedTextButton;
        private var _btns:Array;
        private var _selectedButtonGroup:SelectedButtonGroup;

        public function TofflistTwoGradeMenu()
        {
            _spacing = -7;
            this._btns = [];
            this.initView();
        }

        private function initView():void
        {
            var _local_1:SelectedTextButton;
            this._battleBtn = ComponentFactory.Instance.creatComponentByStylename("toffilist.battleBtn");
            this._levelBtn = ComponentFactory.Instance.creatComponentByStylename("toffilist.gradeOrderBtn");
            this._militaryBtn = ComponentFactory.Instance.creatComponentByStylename("toffilist.militaryBtn");
            this._arenaBtn = ComponentFactory.Instance.creatComponentByStylename("toffilist.arenaBtn");
            this._battleBtn.text = LanguageMgr.GetTranslation("tank.menu.FightPoweTxt");
            this._levelBtn.text = LanguageMgr.GetTranslation("tank.menu.LevelTxt");
            this._arenaBtn.text = LanguageMgr.GetTranslation("tank.menu.Arena");
            this._militaryBtn.text = LanguageMgr.GetTranslation("tank.menu.MilitaryScore");
            this._btns.push(this._battleBtn);
            this._btns.push(this._levelBtn);
            this._btns.push(this._militaryBtn);
            this._btns.push(this._arenaBtn);
            addChild(this._battleBtn);
            addChild(this._levelBtn);
            addChild(this._militaryBtn);
            addChild(this._arenaBtn);
            this._selectedButtonGroup = new SelectedButtonGroup();
            this._selectedButtonGroup.addSelectItem(this._battleBtn);
            this._selectedButtonGroup.addSelectItem(this._levelBtn);
            this._selectedButtonGroup.addSelectItem(this._militaryBtn);
            this._selectedButtonGroup.addSelectItem(this._arenaBtn);
            this._selectedButtonGroup.selectIndex = 0;
            for each (_local_1 in this._btns)
            {
                _local_1.addEventListener(MouseEvent.CLICK, this.__selectToolBarHandler);
            };
        }

        override public function dispose():void
        {
            var _local_1:SelectedTextButton;
            for each (_local_1 in this._btns)
            {
                _local_1.dispose();
                _local_1.removeEventListener(MouseEvent.CLICK, this.__selectToolBarHandler);
            };
            if (this._battleBtn)
            {
                ObjectUtils.disposeObject(this._battleBtn);
            };
            if (this._levelBtn)
            {
                ObjectUtils.disposeObject(this._levelBtn);
            };
            if (this._militaryBtn)
            {
                ObjectUtils.disposeObject(this._militaryBtn);
            };
            ObjectUtils.disposeObject(this._arenaBtn);
            this._arenaBtn = null;
            this._battleBtn = null;
            this._levelBtn = null;
            this._militaryBtn = null;
            this._btns = null;
            super.dispose();
        }

        public function setParentType(_arg_1:String):void
        {
            var _local_2:SelectedTextButton;
            this.type = BATTLE;
            for each (_local_2 in this._btns)
            {
                _local_2.selected = true;
                if (_local_2.parent)
                {
                    _local_2.parent.removeChild(_local_2);
                };
            };
            if (_arg_1 == TofflistStairMenu.PERSONAL)
            {
                addChild(this._battleBtn);
                addChild(this._levelBtn);
                addChild(this._militaryBtn);
                addChild(this._arenaBtn);
            }
            else
            {
                if (_arg_1 == TofflistStairMenu.CROSS_SERVER_PERSONAL)
                {
                    addChild(this._battleBtn);
                    addChild(this._levelBtn);
                    addChild(this._arenaBtn);
                }
                else
                {
                    if (((_arg_1 == TofflistStairMenu.CONSORTIA) || (_arg_1 == TofflistStairMenu.CROSS_SERVER_CONSORTIA)))
                    {
                        addChild(this._battleBtn);
                        addChild(this._levelBtn);
                    };
                };
            };
            for each (_local_2 in this._btns)
            {
                _local_2.selected = false;
            };
            this._selectedButtonGroup.selectIndex = 0;
        }

        public function get type():String
        {
            return (TofflistModel.secondMenuType);
        }

        public function set type(_arg_1:String):void
        {
            TofflistModel.secondMenuType = _arg_1;
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

