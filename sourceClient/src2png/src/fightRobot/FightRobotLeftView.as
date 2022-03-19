// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//fightRobot.FightRobotLeftView

package fightRobot
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.view.character.RoomCharacter;
    import ddt.view.common.LevelIcon;
    import ddt.view.common.VipLevelIcon;
    import militaryrank.view.MilitaryIcon;
    import ddt.view.common.MarriedIcon;
    import __AS3__.vec.Vector;
    import ddt.data.player.SelfInfo;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.ComponentFactory;
    import vip.VipController;
    import com.pickgliss.ui.text.GradientText;
    import com.pickgliss.utils.DisplayUtils;
    import flash.text.TextField;
    import ddt.utils.PositionUtils;
    import ddt.view.character.CharactoryFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class FightRobotLeftView extends Sprite implements Disposeable 
    {

        private var _bg:Bitmap;
        private var _nickNameTxt:DisplayObject;
        private var _fightPowerTxt:FilterFrameText;
        private var _character:RoomCharacter;
        private var _levelIcon:LevelIcon;
        private var _vipIcon:VipLevelIcon;
        private var _militaryIcon:MilitaryIcon;
        private var _marriedIcon:MarriedIcon;
        private var _teamateList:Vector.<FightRobotTeamateView>;

        public function FightRobotLeftView()
        {
            this.initView();
        }

        private function initView():void
        {
            var _local_1:SelfInfo;
            _local_1 = PlayerManager.Instance.Self;
            this._bg = ComponentFactory.Instance.creatBitmap("asset.fightrobot.left.bg");
            if (_local_1.IsVIP)
            {
                this._nickNameTxt = VipController.instance.getVipNameTxt(130, _local_1.VIPtype);
                (this._nickNameTxt as GradientText).text = _local_1.NickName;
            }
            else
            {
                this._nickNameTxt = ComponentFactory.Instance.creatComponentByStylename("fightrobot.nickName.text");
                (this._nickNameTxt as FilterFrameText).text = DisplayUtils.subStringByLength((this._nickNameTxt as TextField), _local_1.NickName, 130);
            };
            PositionUtils.setPos(this._nickNameTxt, "fightrobot.nickName.pos");
            this._fightPowerTxt = ComponentFactory.Instance.creatComponentByStylename("fightrobot.fightPower.text");
            this._character = (CharactoryFactory.createCharacter(_local_1, "room") as RoomCharacter);
            this._character.showGun = false;
            this._character.show(true, -1);
            PositionUtils.setPos(this._character, "fightrobot.character.pos");
            this._levelIcon = ComponentFactory.Instance.creatCustomObject("fightrobot.levelIcon");
            this._levelIcon.setSize(LevelIcon.SIZE_BIG);
            this._levelIcon.setInfo(_local_1.Grade, _local_1.Repute, _local_1.WinCount, _local_1.TotalCount, _local_1.FightPower, _local_1.Offer, true, false);
            this._vipIcon = ComponentFactory.Instance.creatCustomObject("fightrobot.vipIcon");
            this._vipIcon.setInfo(_local_1);
            if ((!(_local_1.IsVIP)))
            {
                this._vipIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            }
            else
            {
                this._vipIcon.filters = null;
            };
            this._militaryIcon = new MilitaryIcon(_local_1);
            this._militaryIcon.setMilitary(_local_1.MilitaryRankTotalScores);
            PositionUtils.setPos(this._militaryIcon, "fightrobot.military.pos");
            this._fightPowerTxt.text = String(_local_1.FightPower);
            addChild(this._bg);
            addChild(this._character);
            addChild(this._nickNameTxt);
            addChild(this._fightPowerTxt);
            addChild(this._levelIcon);
            addChild(this._vipIcon);
            addChild(this._militaryIcon);
            if (_local_1.SpouseID > 0)
            {
                this._marriedIcon = ComponentFactory.Instance.creatCustomObject("fightrobot.MarriedIcon");
                this._marriedIcon.tipData = {
                    "nickName":_local_1.SpouseName,
                    "gender":_local_1.Sex
                };
                addChild(this._marriedIcon);
            };
        }

        public function set teamateList(_arg_1:Vector.<FightRobotTeamateView>):void
        {
            this._teamateList = _arg_1;
            var _local_2:uint;
            while (_local_2 < _arg_1.length)
            {
                addChild(_arg_1[_local_2]);
                PositionUtils.setPos(_arg_1[_local_2], (("fightrobot.teamate" + (_local_2 + 1)) + ".pos"));
                _local_2++;
            };
        }

        public function dispose():void
        {
            var _local_1:FightRobotTeamateView;
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._nickNameTxt);
            this._nickNameTxt = null;
            ObjectUtils.disposeObject(this._fightPowerTxt);
            this._fightPowerTxt = null;
            ObjectUtils.disposeObject(this._character);
            this._character = null;
            ObjectUtils.disposeObject(this._levelIcon);
            this._levelIcon = null;
            ObjectUtils.disposeObject(this._vipIcon);
            this._vipIcon = null;
            ObjectUtils.disposeObject(this._militaryIcon);
            this._militaryIcon = null;
            ObjectUtils.disposeObject(this._marriedIcon);
            this._marriedIcon = null;
            for each (_local_1 in this._teamateList)
            {
                ObjectUtils.disposeObject(_local_1);
            };
            this._teamateList = null;
        }


    }
}//package fightRobot

