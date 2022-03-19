// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//fightRobot.FightRobotTeamateView

package fightRobot
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import ddt.view.PlayerPortraitView;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.player.PlayerInfo;
    import ddt.utils.PositionUtils;
    import vip.VipController;
    import com.pickgliss.ui.text.GradientText;
    import com.pickgliss.utils.DisplayUtils;
    import flash.text.TextField;
    import com.pickgliss.utils.ObjectUtils;

    public class FightRobotTeamateView extends Sprite implements Disposeable 
    {

        private var _bg:Bitmap;
        private var _portrait:PlayerPortraitView;
        private var _nickNameTxt:DisplayObject;
        private var _isVIP:Boolean;
        private var _fightPowerTxt:FilterFrameText;

        public function FightRobotTeamateView()
        {
            this.initView();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.fightrobot.teamate.bg");
            addChild(this._bg);
        }

        public function setStyle(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:int, _arg_5:Boolean):void
        {
            var _local_6:PlayerInfo = new PlayerInfo();
            _local_6.Sex = _arg_5;
            _local_6.Style = _arg_1;
            _local_6.Skin = _arg_2;
            _local_6.Colors = _arg_3;
            _local_6.Hide = _arg_4;
            this._portrait = ComponentFactory.Instance.creatCustomObject("hall.fightPowerAndFatigue.selfPortrait", ["right"]);
            this._portrait.info = _local_6;
            this._portrait.isShowFrame = false;
            this._portrait.scaleX = (this._portrait.scaleY = 0.9);
            PositionUtils.setPos(this._portrait, "fightrobot.teamatePortrait.pos");
            addChild(this._portrait);
        }

        public function set nickName(_arg_1:String):void
        {
            var _local_2:String;
            if (this._isVIP)
            {
                this._nickNameTxt = VipController.instance.getVipNameTxt(130);
                (this._nickNameTxt as GradientText).text = _arg_1;
            }
            else
            {
                this._nickNameTxt = ComponentFactory.Instance.creatComponentByStylename("fightrobot.nickName.text");
                _local_2 = DisplayUtils.subStringByLength((this._nickNameTxt as TextField), _arg_1, 130);
                (this._nickNameTxt as FilterFrameText).text = _local_2;
            };
            PositionUtils.setPos(this._nickNameTxt, "fightrobot.teamateName.pos");
            addChild(this._nickNameTxt);
        }

        public function set fightPower(_arg_1:int):void
        {
            this._fightPowerTxt = ComponentFactory.Instance.creatComponentByStylename("fightrobot.fightPower.text");
            this._fightPowerTxt.text = String(_arg_1);
            PositionUtils.setPos(this._fightPowerTxt, "fightrobot.teamateFightPower.pos");
            addChild(this._fightPowerTxt);
        }

        public function set isVIP(_arg_1:Boolean):void
        {
            this._isVIP = _arg_1;
        }

        public function dispose():void
        {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._portrait);
            this._portrait = null;
            ObjectUtils.disposeObject(this._nickNameTxt);
            this._nickNameTxt = null;
            ObjectUtils.disposeObject(this._fightPowerTxt);
            this._fightPowerTxt = null;
        }


    }
}//package fightRobot

