// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tofflist.view.TofflistGridBox

package tofflist.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.image.MutipleImage;
    import flash.utils.Dictionary;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import tofflist.data.TofflistLayoutInfo;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;
    import flash.geom.Point;
    import com.pickgliss.ui.text.FilterFrameText;

    public class TofflistGridBox extends Sprite implements Disposeable 
    {

        private static const RANK:String = LanguageMgr.GetTranslation("repute");
        private static const NAME:String = LanguageMgr.GetTranslation("civil.rightview.listname");
        private static const BATTLE:String = LanguageMgr.GetTranslation("tank.menu.FightPoweTxt");
        private static const LEVEL:String = LanguageMgr.GetTranslation("tank.menu.LevelTxt");
        private static const EXP:String = LanguageMgr.GetTranslation("exp");
        private static const SCORE:String = LanguageMgr.GetTranslation("tofflist.score");
        private static const ACHIVE_POINT:String = LanguageMgr.GetTranslation("tofflist.achivepoint");
        private static const ASSET:String = LanguageMgr.GetTranslation("tank.fightLib.FightLibAwardView.exp");
        private static const TOTAL_ASSET:String = LanguageMgr.GetTranslation("tofflist.totalasset");
        private static const SERVER:String = LanguageMgr.GetTranslation("tofflist.server");
        private static const MILITARY_SCORE:String = LanguageMgr.GetTranslation("tank.menu.MilitaryTxt");
        private static const MILITARY:String = LanguageMgr.GetTranslation("tank.menu.MilitaryScore");
        private static const ARENA_SCORE_TANK:String = LanguageMgr.GetTranslation("tofflist.arenaScoreTank");
        private static const ARENA_SCORE:String = LanguageMgr.GetTranslation("tofflist.arenaScore");

        private var _bg:MutipleImage;
        private var _titleBg:MutipleImage;
        private var _layoutInfoArr:Dictionary;
        private var _title:Sprite;
        private var _scoreBtnShine:Bitmap;
        private var _winBtnShine:Bitmap;
        private var _arenaGroup:SelectedButtonGroup;
        private var _orderList:TofflistOrderList;
        private var _id:String;
        private var _arenaID:String;

        public function TofflistGridBox()
        {
            this._layoutInfoArr = new Dictionary();
            this.initData();
            this._bg = ComponentFactory.Instance.creatComponentByStylename("tofflist.right.listBg");
            addChild(this._bg);
            this._title = new Sprite();
            addChild(this._title);
            this._orderList = new TofflistOrderList();
            PositionUtils.setPos(this._orderList, "tofflist.orderlistPos");
            addChild(this._orderList);
        }

        private function initData():void
        {
            var _local_1:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_local_battle");
            _local_1.TitleTextString = [RANK, NAME, BATTLE];
            this._layoutInfoArr[TofflistThirdClassMenu.PERSON_LOCAL_BATTLE] = _local_1;
            var _local_2:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_local_level");
            _local_2.TitleTextString = [RANK, NAME, LEVEL, EXP];
            this._layoutInfoArr[TofflistThirdClassMenu.PERSON_LOCAL_LEVEL] = _local_2;
            var _local_3:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_local_military");
            _local_3.TitleTextString = [RANK, NAME, MILITARY, MILITARY_SCORE];
            this._layoutInfoArr[TofflistThirdClassMenu.PERSON_LOCAL_MILITARY] = _local_3;
            var _local_4:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_local_achive");
            _local_4.TitleTextString = [RANK, NAME, ACHIVE_POINT];
            this._layoutInfoArr[TofflistThirdClassMenu.PERSON_LOCAL_ACHIVE] = _local_4;
            var _local_5:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_local_match");
            _local_5.TitleTextString = [RANK, NAME, SCORE];
            this._layoutInfoArr[TofflistThirdClassMenu.PERSON_LOCAL_MATCH] = _local_5;
            var _local_6:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_local_arena_score");
            _local_6.TitleTextString = [ARENA_SCORE_TANK, NAME, ARENA_SCORE];
            this._layoutInfoArr[TofflistThirdClassMenu.LOCAL_ARENA_SCORE_DAY] = _local_6;
            var _local_7:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_cross_battle");
            _local_7.TitleTextString = [RANK, NAME, SERVER, BATTLE];
            this._layoutInfoArr[TofflistThirdClassMenu.PERSON_CROSS_BATTLE] = _local_7;
            var _local_8:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_cross_level");
            _local_8.TitleTextString = [RANK, NAME, LEVEL, SERVER, EXP];
            this._layoutInfoArr[TofflistThirdClassMenu.PERSON_CROSS_LEVEL] = _local_8;
            var _local_9:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_cross_achive");
            _local_9.TitleTextString = [RANK, NAME, SERVER, ACHIVE_POINT];
            this._layoutInfoArr[TofflistThirdClassMenu.PERSON_CROSS_ACHIVE] = _local_9;
            var _local_10:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_cross_arena_score");
            _local_10.TitleTextString = [ARENA_SCORE_TANK, NAME, SERVER, ARENA_SCORE];
            this._layoutInfoArr[TofflistThirdClassMenu.CROSS_ARENA_SCORE_DAY] = _local_10;
            var _local_11:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("consortia_local_battle");
            _local_11.TitleTextString = [RANK, NAME, BATTLE];
            this._layoutInfoArr[TofflistThirdClassMenu.CONSORTIA_LOCAL_BATTLE] = _local_11;
            var _local_12:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("consortia_local_level");
            _local_12.TitleTextString = [RANK, NAME, LEVEL, ASSET];
            this._layoutInfoArr[TofflistThirdClassMenu.CONSORTIA_LOCAL_LEVEL] = _local_12;
            var _local_13:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("consortia_local_asset");
            _local_13.TitleTextString = [RANK, NAME, TOTAL_ASSET];
            this._layoutInfoArr[TofflistThirdClassMenu.CONSORTIA_LOCAL_ASSET] = _local_13;
            var _local_14:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("consortia_cross_battle");
            _local_14.TitleTextString = [RANK, NAME, SERVER, BATTLE];
            this._layoutInfoArr[TofflistThirdClassMenu.CONSORTIA_CROSS_BATTLE] = _local_14;
            var _local_15:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("consortia_cross_level");
            _local_15.TitleTextString = [RANK, NAME, LEVEL, SERVER, ASSET];
            this._layoutInfoArr[TofflistThirdClassMenu.CONSORTIA_CROSS_LEVEL] = _local_15;
            var _local_16:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("consortia_cross_asset");
            _local_16.TitleTextString = [RANK, NAME, SERVER, TOTAL_ASSET];
            this._layoutInfoArr[TofflistThirdClassMenu.CONSORTIA_CROSS_ASSET] = _local_16;
            var _local_17:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("local_arena_score");
            _local_17.TitleTextString = [RANK, NAME, ARENA_SCORE];
            this._layoutInfoArr[TofflistThirdClassMenu.LOCAL_ARENA_SCORE_DAY] = _local_17;
        }

        public function get orderList():TofflistOrderList
        {
            return (this._orderList);
        }

        public function updateList(_arg_1:Array, _arg_2:int=1):void
        {
            var _local_3:TofflistLayoutInfo;
            this._orderList.items(_arg_1, _arg_2);
            if (this._id)
            {
                _local_3 = this._layoutInfoArr[this._id];
                this._orderList.showHline(_local_3.TitleHLinePoint);
            };
        }

        public function dispose():void
        {
            var _local_1:DisplayObject;
            if (this._arenaGroup)
            {
                this._arenaGroup.removeEventListener(Event.CHANGE, this.__arenaGroupChange);
            };
            ObjectUtils.disposeObject(this._arenaGroup);
            this._arenaGroup = null;
            while (numChildren > 1)
            {
                _local_1 = getChildAt(0);
                ObjectUtils.disposeObject(_local_1);
                _local_1 = null;
            };
        }

        public function updateStyleXY(_arg_1:String):void
        {
            var _local_3:Point;
            var _local_4:int;
            var _local_5:Bitmap;
            var _local_6:FilterFrameText;
            this._id = _arg_1;
            ObjectUtils.disposeAllChildren(this._title);
            var _local_2:TofflistLayoutInfo = this._layoutInfoArr[this._id];
            for each (_local_3 in _local_2.TitleHLinePoint)
            {
                _local_5 = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
                PositionUtils.setPos(_local_5, _local_3);
                this._title.addChild(_local_5);
            };
            _local_4 = 0;
            while (_local_4 < _local_2.TitleTextPoint.length)
            {
                _local_6 = ComponentFactory.Instance.creatComponentByStylename("toffilist.listTitleText");
                PositionUtils.setPos(_local_6, _local_2.TitleTextPoint[_local_4]);
                _local_6.text = _local_2.TitleTextString[_local_4];
                this._title.addChild(_local_6);
                _local_4++;
            };
        }

        private function __arenaGroupChange(_arg_1:Event):void
        {
            this.updateStyleXY(this._arenaID);
        }


    }
}//package tofflist.view

