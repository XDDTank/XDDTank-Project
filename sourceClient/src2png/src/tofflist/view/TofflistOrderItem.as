// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tofflist.view.TofflistOrderItem

package tofflist.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import tofflist.data.TofflistConsortiaInfo;
    import consortion.view.selfConsortia.Badge;
    import tofflist.data.TofflistPlayerInfo;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.image.ScaleLeftRightImage;
    import ddt.view.common.LevelIcon;
    import com.pickgliss.ui.text.GradientText;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import __AS3__.vec.Vector;
    import tofflist.data.TofflistConsortiaData;
    import ddt.data.player.PlayerInfo;
    import tofflist.TofflistEvent;
    import ddt.manager.SoundManager;
    import flash.events.MouseEvent;
    import ddt.manager.PlayerManager;
    import ddt.events.PlayerPropertyEvent;
    import flash.text.TextFormat;
    import tofflist.TofflistModel;
    import ddt.manager.ServerConfigManager;
    import militaryrank.MilitaryRankManager;
    import vip.VipController;
    import ddt.data.ConsortiaInfo;

    public class TofflistOrderItem extends Sprite implements Disposeable 
    {

        private var _consortiaInfo:TofflistConsortiaInfo;
        private var _badge:Badge;
        private var _index:int;
        private var _info:TofflistPlayerInfo;
        private var _isSelect:Boolean;
        private var _bg:Image;
        private var _shine:ScaleLeftRightImage;
        private var _level:LevelIcon;
        private var _vipName:GradientText;
        private var _topThreeRink:ScaleFrameImage;
        private var _resourceArr:Array;
        private var _styleLinkArr:Array;
        private var hLines:Array;

        public function TofflistOrderItem()
        {
            this.init();
            this.addEvent();
        }

        public function get currentText():String
        {
            return (this._resourceArr[2].dis["text"]);
        }

        public function dispose():void
        {
            var _local_1:Bitmap;
            var _local_2:DisplayObject;
            var _local_3:uint;
            var _local_4:uint;
            this.removeEvent();
            if (this.hLines)
            {
                for each (_local_1 in this.hLines)
                {
                    ObjectUtils.disposeObject(_local_1);
                };
            };
            if (this._resourceArr)
            {
                _local_3 = 0;
                _local_4 = this._resourceArr.length;
                while (_local_3 < _local_4)
                {
                    _local_2 = this._resourceArr[_local_3].dis;
                    ObjectUtils.disposeObject(_local_2);
                    _local_2 = null;
                    this._resourceArr[_local_3] = null;
                    _local_3++;
                };
                this._resourceArr = null;
            };
            this._styleLinkArr = null;
            this._badge.dispose();
            this._badge = null;
            this._bg.dispose();
            this._bg = null;
            ObjectUtils.disposeAllChildren(this);
            this._shine = null;
            if (this._topThreeRink)
            {
                this._topThreeRink.dispose();
            };
            this._topThreeRink = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get index():int
        {
            return (this._index);
        }

        public function set index(_arg_1:int):void
        {
            this._index = _arg_1;
            this._bg.setFrame(((this._index % 2) + 1));
        }

        public function showHLine(_arg_1:Vector.<Point>):void
        {
            var _local_2:Point;
            var _local_3:Bitmap;
            if (this.hLines)
            {
                for each (_local_3 in this.hLines)
                {
                    ObjectUtils.disposeObject(_local_3);
                };
            };
            this.hLines = [];
            for each (_local_2 in _arg_1)
            {
                _local_3 = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
                this.hLines.push(_local_3);
                PositionUtils.setPos(_local_3, new Point((_local_2.x - parent.parent.x), _local_2.y));
            };
        }

        public function get info():Object
        {
            return (this._info);
        }

        public function set info(_arg_1:Object):void
        {
            var _local_2:TofflistConsortiaData;
            if ((_arg_1 is PlayerInfo))
            {
                this._info = (_arg_1 as TofflistPlayerInfo);
            }
            else
            {
                if ((_arg_1 is TofflistConsortiaData))
                {
                    _local_2 = (_arg_1 as TofflistConsortiaData);
                    if (_local_2)
                    {
                        this._info = _local_2.playerInfo;
                        this._consortiaInfo = _local_2.consortiaInfo;
                    };
                };
            };
            if (this._info)
            {
                this.upView();
            };
        }

        public function set isSelect(_arg_1:Boolean):void
        {
            this._shine.visible = (this._isSelect = _arg_1);
            if (_arg_1)
            {
                this.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_ITEM_SELECT, this));
            };
        }

        public function set resourceLink(_arg_1:String):void
        {
            var _local_2:DisplayObject;
            var _local_6:Object;
            this._resourceArr = [];
            var _local_3:Array = _arg_1.replace(/(\s*)|(\s*$)/g, "").split("|");
            var _local_4:uint;
            var _local_5:uint = _local_3.length;
            while (_local_4 < _local_5)
            {
                _local_6 = {};
                _local_6.id = _local_3[_local_4].split("#")[0];
                _local_6.className = _local_3[_local_4].split("#")[1];
                _local_2 = ComponentFactory.Instance.creat(_local_6.className);
                addChild(_local_2);
                _local_6.dis = _local_2;
                this._resourceArr.push(_local_6);
                _local_4++;
            };
        }

        public function set setAllStyleXY(_arg_1:String):void
        {
            this._styleLinkArr = _arg_1.replace(/(\s*)|(\s*$)/g, "").split("~");
            this.updateStyleXY();
        }

        public function updateStyleXY(_arg_1:int=0):void
        {
            var _local_2:DisplayObject;
            var _local_3:uint;
            var _local_4:uint;
            var _local_6:Array;
            var _local_7:int;
            var _local_8:Point;
            var _local_5:uint = this._resourceArr.length;
            _local_6 = this._styleLinkArr[_arg_1].split("|");
            _local_5 = _local_6.length;
            _local_3 = 0;
            while (_local_3 < _local_5)
            {
                _local_2 = null;
                _local_7 = _local_6[_local_3].split("#")[0];
                _local_4 = 0;
                while (_local_4 < this._resourceArr.length)
                {
                    if (_local_7 == this._resourceArr[_local_4].id)
                    {
                        _local_2 = this._resourceArr[_local_4].dis;
                        break;
                    };
                    _local_4++;
                };
                if (_local_2)
                {
                    _local_8 = new Point();
                    _local_8.x = _local_6[_local_3].split("#")[1].split(",")[0];
                    _local_8.y = _local_6[_local_3].split("#")[1].split(",")[1];
                    _local_2.x = _local_8.x;
                    _local_2.y = _local_8.y;
                    if (_local_6[_local_3].split("#")[1].split(",")[2])
                    {
                        _local_2.width = _local_6[_local_3].split("#")[1].split(",")[2];
                    };
                    if (_local_6[_local_3].split("#")[1].split(",")[3])
                    {
                        _local_2.height = _local_6[_local_3].split("#")[1].split(",")[3];
                    };
                    _local_2["text"] = _local_2["text"];
                    _local_2.visible = true;
                };
                _local_3++;
            };
            if (this._index < 4)
            {
                this._topThreeRink.x = (this._resourceArr[0].dis.x - 9);
                this._topThreeRink.y = (this._resourceArr[0].dis.y - 2);
                this._topThreeRink.visible = true;
                this._topThreeRink.setFrame(this._index);
                this._resourceArr[0].dis.visible = false;
            };
        }

        private function get NO_ID():String
        {
            var _local_1:String = "";
            switch (this._index)
            {
                case 1:
                    _local_1 = (1 + "st");
                    break;
                case 2:
                    _local_1 = (2 + "nd");
                    break;
                case 3:
                    _local_1 = (3 + "rd");
                    break;
                default:
                    _local_1 = (this._index + "th");
            };
            return (_local_1);
        }

        private function __itemClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if ((!(this._isSelect)))
            {
                this.isSelect = true;
            };
        }

        private function __itemMouseOutHandler(_arg_1:MouseEvent):void
        {
            if (this._isSelect)
            {
                return;
            };
            this._shine.visible = false;
        }

        private function __itemMouseOverHandler(_arg_1:MouseEvent):void
        {
            this._shine.visible = true;
        }

        private function addEvent():void
        {
            addEventListener(MouseEvent.CLICK, this.__itemClickHandler);
            addEventListener(MouseEvent.MOUSE_OVER, this.__itemMouseOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT, this.__itemMouseOutHandler);
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__offerChange);
        }

        private function __offerChange(_arg_1:PlayerPropertyEvent):void
        {
            if (_arg_1.changedProperties["isVip"])
            {
                this.upView();
            };
        }

        private function init():void
        {
            this.graphics.beginFill(0, 0);
            this.graphics.drawRect(0, 0, 495, 30);
            this.graphics.endFill();
            this.buttonMode = true;
            this._bg = ComponentFactory.Instance.creatComponentByStylename("tofflist.gridItemBg");
            this._bg.setFrame(((this._index % 2) + 1));
            addChild(this._bg);
            this._shine = ComponentFactory.Instance.creat("tofflist.orderlistitem.shine");
            this._shine.visible = false;
            addChild(this._shine);
            this._badge = new Badge();
            this._badge.visible = false;
            addChild(this._badge);
            PositionUtils.setPos(this._badge, "tofflist.item.badgePos");
            this._level = new LevelIcon();
            this._level.setSize(LevelIcon.SIZE_SMALL);
            addChild(this._level);
            this._level.visible = false;
            this._topThreeRink = ComponentFactory.Instance.creat("toffilist.topThreeRink");
            addChild(this._topThreeRink);
            this._topThreeRink.visible = false;
        }

        private function removeEvent():void
        {
            removeEventListener(MouseEvent.CLICK, this.__itemClickHandler);
            removeEventListener(MouseEvent.MOUSE_OVER, this.__itemMouseOverHandler);
            removeEventListener(MouseEvent.MOUSE_OUT, this.__itemMouseOutHandler);
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__offerChange);
        }

        private function upView():void
        {
            var _local_1:DisplayObject;
            var _local_2:uint;
            var _local_4:int;
            var _local_5:Array;
            var _local_6:TextFormat;
            var _local_7:TextFormat;
            var _local_3:uint = this._resourceArr.length;
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                _local_1 = this._resourceArr[_local_2].dis;
                _local_1["text"] = "";
                _local_1.visible = false;
                _local_2++;
            };
            this._resourceArr[0].dis["text"] = this.NO_ID;
            switch (TofflistModel.firstMenuType)
            {
                case TofflistStairMenu.PERSONAL:
                    this._resourceArr[1].dis["text"] = this._info.NickName;
                    switch (TofflistModel.secondMenuType)
                    {
                        case TofflistTwoGradeMenu.BATTLE:
                            this.updateStyleXY(0);
                            switch (TofflistModel.thirdMenuType)
                            {
                                case TofflistThirdClassMenu.TOTAL:
                                    this._resourceArr[2].dis["text"] = this._info.FightPower;
                                    break;
                            };
                            break;
                        case TofflistTwoGradeMenu.LEVEL:
                            this.updateStyleXY(1);
                            if (this._vipName)
                            {
                                this._vipName.x = (this._resourceArr[1].dis.x - (this._vipName.width / 2));
                            };
                            this._level.x = 227;
                            this._level.y = 3;
                            this._level.setInfo(this._info.Grade, this._info.Repute, this._info.WinCount, this._info.TotalCount, this._info.FightPower, this._info.Offer, true, false);
                            this._level.visible = true;
                            switch (TofflistModel.thirdMenuType)
                            {
                                case TofflistThirdClassMenu.DAY:
                                    this._resourceArr[2].dis["text"] = this._info.AddDayGP;
                                    break;
                                case TofflistThirdClassMenu.WEEK:
                                    this._resourceArr[2].dis["text"] = this._info.AddWeekGP;
                                    break;
                                case TofflistThirdClassMenu.TOTAL:
                                    this._resourceArr[2].dis["text"] = this._info.GP;
                                    break;
                            };
                            break;
                        case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                            this.updateStyleXY(2);
                            switch (TofflistModel.thirdMenuType)
                            {
                                case TofflistThirdClassMenu.DAY:
                                    this._resourceArr[2].dis["text"] = this._info.AddDayAchievementPoint;
                                    break;
                                case TofflistThirdClassMenu.WEEK:
                                    this._resourceArr[2].dis["text"] = this._info.AddWeekAchievementPoint;
                                    break;
                                case TofflistThirdClassMenu.TOTAL:
                                    this._resourceArr[2].dis["text"] = this._info.AchievementPoint;
                                    break;
                            };
                            break;
                        case TofflistTwoGradeMenu.MATCHES:
                            this.updateStyleXY(4);
                            switch (TofflistModel.thirdMenuType)
                            {
                                case TofflistThirdClassMenu.WEEK:
                                    this._resourceArr[2].dis["text"] = this._info.AddWeekLeagueScore;
                                    break;
                            };
                            break;
                        case TofflistTwoGradeMenu.MILITARY:
                            this.updateStyleXY(17);
                            this._resourceArr[2].dis["text"] = this._info.RankScores;
                            _local_4 = ServerConfigManager.instance.getMilitaryData().length;
                            _local_5 = ServerConfigManager.instance.getMilitaryData();
                            this._resourceArr[3].dis["text"] = (((this._index <= 3) && (this._info.RankScores > _local_5[(_local_4 - 1)])) ? MilitaryRankManager.Instance.getOtherMilitaryName(this._index)[0] : MilitaryRankManager.Instance.getMilitaryRankInfo(this._info.RankScores).Name);
                            break;
                        case TofflistTwoGradeMenu.ARENA:
                            this.updateStyleXY(18);
                            switch (TofflistModel.thirdMenuType)
                            {
                                case TofflistThirdClassMenu.DAY:
                                    this._resourceArr[2].dis["text"] = this._info.AddDayMatchScore;
                                    break;
                                case TofflistThirdClassMenu.WEEK:
                                    this._resourceArr[2].dis["text"] = this._info.AddWeekMatchScore;
                                    break;
                            };
                            break;
                    };
                    if (this._info.IsVIP)
                    {
                        if (this._vipName)
                        {
                            ObjectUtils.disposeObject(this._vipName);
                        };
                        this._vipName = VipController.instance.getVipNameTxt(1, this._info.VIPtype);
                        _local_6 = new TextFormat();
                        _local_6.align = "center";
                        _local_6.bold = true;
                        this._vipName.textField.defaultTextFormat = _local_6;
                        this._vipName.textSize = 16;
                        this._vipName.textField.width = this._resourceArr[1].dis.width;
                        this._vipName.x = this._resourceArr[1].dis.x;
                        this._vipName.y = this._resourceArr[1].dis.y;
                        this._vipName.text = this._info.NickName;
                    };
                    PositionUtils.adaptNameStyle(this._info, this._resourceArr[1].dis, this._vipName);
                    break;
                case TofflistStairMenu.CROSS_SERVER_PERSONAL:
                    this._resourceArr[1].dis["text"] = this._info.NickName;
                    this._resourceArr[3].dis["text"] = ((this._info.AreaName) ? this._info.AreaName : "");
                    switch (TofflistModel.secondMenuType)
                    {
                        case TofflistTwoGradeMenu.BATTLE:
                            this.updateStyleXY(9);
                            switch (TofflistModel.thirdMenuType)
                            {
                                case TofflistThirdClassMenu.TOTAL:
                                    this._resourceArr[2].dis["text"] = this._info.FightPower;
                                    break;
                            };
                            break;
                        case TofflistTwoGradeMenu.LEVEL:
                            this.updateStyleXY(10);
                            if (this._vipName)
                            {
                                this._vipName.x = (this._resourceArr[1].dis.x - (this._vipName.width / 2));
                            };
                            this._level.x = 208;
                            this._level.y = 3;
                            this._level.setInfo(this._info.Grade, this._info.Repute, this._info.WinCount, this._info.TotalCount, this._info.FightPower, this._info.Offer, true, false);
                            this._level.visible = true;
                            switch (TofflistModel.thirdMenuType)
                            {
                                case TofflistThirdClassMenu.DAY:
                                    this._resourceArr[2].dis["text"] = this._info.AddDayGP;
                                    break;
                                case TofflistThirdClassMenu.WEEK:
                                    this._resourceArr[2].dis["text"] = this._info.AddWeekGP;
                                    break;
                                case TofflistThirdClassMenu.TOTAL:
                                    this._resourceArr[2].dis["text"] = this._info.GP;
                                    break;
                            };
                            break;
                        case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                            this.updateStyleXY(11);
                            switch (TofflistModel.thirdMenuType)
                            {
                                case TofflistThirdClassMenu.DAY:
                                    this._resourceArr[2].dis["text"] = this._info.AddDayAchievementPoint;
                                    break;
                                case TofflistThirdClassMenu.WEEK:
                                    this._resourceArr[2].dis["text"] = this._info.AddWeekAchievementPoint;
                                    break;
                                case TofflistThirdClassMenu.TOTAL:
                                    this._resourceArr[2].dis["text"] = this._info.AchievementPoint;
                                    break;
                            };
                            break;
                        case TofflistTwoGradeMenu.ARENA:
                            this.updateStyleXY(18);
                            switch (TofflistModel.thirdMenuType)
                            {
                                case TofflistThirdClassMenu.DAY:
                                    this._resourceArr[2].dis["text"] = this._info.AddDayMatchScore;
                                    break;
                                case TofflistThirdClassMenu.WEEK:
                                    this._resourceArr[2].dis["text"] = this._info.AddWeekMatchScore;
                                    break;
                            };
                            break;
                    };
                    if (this._info.IsVIP)
                    {
                        if (this._vipName)
                        {
                            ObjectUtils.disposeObject(this._vipName);
                        };
                        this._vipName = VipController.instance.getVipNameTxt(1, this._info.VIPtype);
                        _local_7 = new TextFormat();
                        _local_7.align = "center";
                        _local_7.bold = true;
                        this._vipName.textField.defaultTextFormat = _local_7;
                        this._vipName.textSize = 16;
                        this._vipName.textField.width = this._resourceArr[1].dis.width;
                        this._vipName.x = this._resourceArr[1].dis.x;
                        this._vipName.y = this._resourceArr[1].dis.y;
                        this._vipName.text = this._info.NickName;
                        addChild(this._vipName);
                    };
                    PositionUtils.adaptNameStyle(this._info, this._resourceArr[1].dis, this._vipName);
                    break;
                case TofflistStairMenu.CONSORTIA:
                    if ((!(this._consortiaInfo))) break;
                    this._badge.visible = (this._consortiaInfo.BadgeID > 0);
                    this._badge.badgeID = this._consortiaInfo.BadgeID;
                    this._resourceArr[1].dis["text"] = this._consortiaInfo.ConsortiaName;
                    switch (TofflistModel.secondMenuType)
                    {
                        case TofflistTwoGradeMenu.BATTLE:
                            this.updateStyleXY(5);
                            switch (TofflistModel.thirdMenuType)
                            {
                                case TofflistThirdClassMenu.TOTAL:
                                    this._resourceArr[2].dis["text"] = this._consortiaInfo.FightPower;
                                    break;
                            };
                            break;
                        case TofflistTwoGradeMenu.LEVEL:
                            this.updateStyleXY(6);
                            switch (TofflistModel.thirdMenuType)
                            {
                                case TofflistThirdClassMenu.TOTAL:
                                    this._resourceArr[2].dis["text"] = this._consortiaInfo.Experience;
                                    this._resourceArr[3].dis["text"] = this._consortiaInfo.Level;
                                    break;
                            };
                            break;
                        case TofflistTwoGradeMenu.ASSETS:
                            this.updateStyleXY(7);
                            switch (TofflistModel.thirdMenuType)
                            {
                                case TofflistThirdClassMenu.DAY:
                                    this._resourceArr[2].dis["text"] = this._consortiaInfo.AddDayRiches;
                                    break;
                                case TofflistThirdClassMenu.WEEK:
                                    this._resourceArr[2].dis["text"] = this._consortiaInfo.AddWeekRiches;
                                    break;
                                case TofflistThirdClassMenu.TOTAL:
                                    this._resourceArr[2].dis["text"] = this._consortiaInfo.LastDayRiches;
                                    break;
                            };
                            break;
                    };
                    break;
                case TofflistStairMenu.CROSS_SERVER_CONSORTIA:
                    if ((!(this._consortiaInfo))) break;
                    this._badge.visible = (this._consortiaInfo.BadgeID > 0);
                    this._badge.badgeID = this._consortiaInfo.BadgeID;
                    this._resourceArr[1].dis["text"] = this._consortiaInfo.ConsortiaName;
                    if (this._consortiaInfo.AreaName)
                    {
                        this._resourceArr[3].dis["text"] = this._consortiaInfo.AreaName;
                    };
                    switch (TofflistModel.secondMenuType)
                    {
                        case TofflistTwoGradeMenu.BATTLE:
                            this.updateStyleXY(13);
                            switch (TofflistModel.thirdMenuType)
                            {
                                case TofflistThirdClassMenu.TOTAL:
                                    this._resourceArr[2].dis["text"] = this._consortiaInfo.FightPower;
                                    break;
                            };
                            break;
                        case TofflistTwoGradeMenu.LEVEL:
                            this.updateStyleXY(14);
                            switch (TofflistModel.thirdMenuType)
                            {
                                case TofflistThirdClassMenu.TOTAL:
                                    this._resourceArr[2].dis["text"] = this._consortiaInfo.Experience;
                                    this._resourceArr[4].dis["text"] = this._consortiaInfo.Level;
                                    break;
                            };
                            break;
                        case TofflistTwoGradeMenu.ASSETS:
                            this.updateStyleXY(15);
                            switch (TofflistModel.thirdMenuType)
                            {
                                case TofflistThirdClassMenu.DAY:
                                    this._resourceArr[2].dis["text"] = this._consortiaInfo.AddDayRiches;
                                    break;
                                case TofflistThirdClassMenu.WEEK:
                                    this._resourceArr[2].dis["text"] = this._consortiaInfo.AddWeekRiches;
                                    break;
                                case TofflistThirdClassMenu.TOTAL:
                                    this._resourceArr[2].dis["text"] = this._consortiaInfo.LastDayRiches;
                                    break;
                            };
                            break;
                    };
                    break;
            };
            if (this._vipName)
            {
                addChild(this._vipName);
            };
        }

        public function get consortiaInfo():ConsortiaInfo
        {
            return (this._consortiaInfo);
        }


    }
}//package tofflist.view

